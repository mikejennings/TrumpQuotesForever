#!/usr/bin/env python3
"""Validate, render, and package source-checked quote proposals. No publishing."""
import argparse
import datetime as dt
import difflib
import hashlib
import json
from pathlib import Path
import re
import sys
import unicodedata
from urllib.parse import urlsplit, urlunsplit
import zipfile

ROOT = Path(__file__).resolve().parents[1]
BASE_FILES = ('Quotes.lua', 'MoreQuotes.lua', 'InsultQuotes.lua', 'ArchiveQuotes.lua')
LEDGER = 'data/daily_quotes.json'
FIELDS = {'id', 'quote', 'date', 'source_url', 'evidence_url', 'source_kind',
          'context', 'assessment', 'checked_at', 'attribution'}
GENERATED = ('TrumpQuotesForever/DailyQuotes.lua', 'TrumpQuotesForever/DAILY_SOURCES.md',
             'TrumpQuotesForever/QUOTE_CATALOG.md', 'README.md', 'TrumpQuotesForever/QUOTES.txt')


def canonical(text):
    text = unicodedata.normalize('NFKD', text).casefold()
    return ' '.join(re.findall(r'[a-z0-9]+', text))


def source_key(url):
    if re.search(r'\s', url):
        raise ValueError('Source URLs cannot contain whitespace')
    p = urlsplit(url)
    host = (p.hostname or '').lower().removeprefix('www.')
    if p.scheme != 'https' or not host or p.username or p.password or p.port:
        raise ValueError('Sources must be public HTTPS URLs without credentials or ports')
    if host == 'localhost' or re.fullmatch(r'[\d.]+', host) or ':' in host or host.endswith(('.local', '.internal')):
        raise ValueError('Sources must use public domain names')
    if host == 'x.com':
        host = 'twitter.com'
    return urlunsplit(('https', host, p.path.rstrip('/'), '', ''))


def base_quotes(root=ROOT):
    result = []
    for name in BASE_FILES:
        for line in (root / 'TrumpQuotesForever' / name).read_text().splitlines():
            if line.strip().startswith('"'):
                result.append(json.loads(line.strip().removesuffix(',')))
    return result


def read_records(root=ROOT):
    records = json.loads((root / LEDGER).read_text())
    if not isinstance(records, list):
        raise ValueError('Daily ledger must be a JSON array')
    return records


def validate(records, root=ROOT):
    if not isinstance(records, list):
        raise ValueError('Daily ledger must be a JSON array')
    existing = [canonical(q) for q in base_quotes(root)]
    # Do not reuse a historical source: this also avoids exceeding its quote budget.
    historical = set()
    for name in ('QUOTE_SOURCES.md', 'INSULT_SOURCES.md', 'ARCHIVE_SOURCES.md'):
        for url in re.findall(r'https://[^\s)>`]+', (root / 'TrumpQuotesForever' / name).read_text()):
            historical.add(source_key(url))
    seen_ids, seen_sources = set(), set()
    today = dt.datetime.now(dt.timezone.utc).date()
    for record in records:
        if not isinstance(record, dict) or set(record) != FIELDS:
            raise ValueError('Record fields must match the documented schema exactly')
        if any(not isinstance(value, str) or not value.strip() for value in record.values()):
            raise ValueError('Every record field must be a nonempty string')
        identity = record['id']
        if not re.fullmatch(r'[a-z0-9][a-z0-9-]{2,100}', identity) or identity in seen_ids:
            raise ValueError('Invalid or duplicate quote ID')
        seen_ids.add(identity)
        quote = record['quote']
        if quote != quote.strip() or re.search(r'[\x00-\x1f\x7f|]', quote):
            raise ValueError('Quote contains control characters, markup, or edge whitespace')
        if len(quote.split()) > 25 or len(quote.split()) < 3:
            raise ValueError('Use one short excerpt of 3-25 words per source')
        if len(('"' + quote + '" - Donald Trump').encode('utf-8')) > 255:
            raise ValueError('Quote exceeds the in-game 255-byte limit')
        key = canonical(quote)
        if not key or any(key == old or difflib.SequenceMatcher(None, key, old).ratio() > .92 for old in existing):
            raise ValueError('Duplicate or near-duplicate quote')
        existing.append(key)
        source = source_key(record['source_url'])
        evidence = source_key(record['evidence_url'])
        if {source, evidence} & (historical | seen_sources):
            raise ValueError('Source already used; preserve the per-source excerpt budget')
        seen_sources.update({source, evidence})
        if not re.fullmatch(r'\d{4}-\d{2}-\d{2}', record['date']):
            raise ValueError('Source date must be YYYY-MM-DD')
        date = dt.date.fromisoformat(record['date'])
        checked = dt.datetime.fromisoformat(record['checked_at'].replace('Z', '+00:00'))
        if date > today or not checked.tzinfo or checked.date() < date:
            raise ValueError('Invalid source/check dates')
        if checked > dt.datetime.now(dt.timezone.utc) + dt.timedelta(minutes=5):
            raise ValueError('Verification timestamp is in the future')
        if record['source_kind'] not in {'account_post', 'speech', 'interview', 'press_exchange', 'news_report'}:
            raise ValueError('Unsupported source kind')
        if record['attribution'] != 'source-matched':
            raise ValueError('Attribution must be source-matched before proposing an entry')
        if record['assessment'] not in {'unverified-claim', 'opinion-or-insult', 'joke-or-boast'}:
            raise ValueError('Use an explicit claim/context assessment')
        # A source match is a researcher assertion, NOT automatic authentication or fact checking.
    return records


def render(root=ROOT, check=False):
    records = validate(read_records(root), root)
    base = base_quotes(root)
    toc = (root / 'TrumpQuotesForever/TrumpQuotesForever.toc').read_text()
    version = re.search(r'^## Version: (.+)$', toc, re.M).group(1)
    lua = ['local _, ns = ...', '', '-- Generated from data/daily_quotes.json. Review source/context before merging.',
           '-- Source matching does not establish the truth of an accusation.', 'local additions = {']
    sources = ['# Daily quote sources', '',
               'Generated from `data/daily_quotes.json`. Entries on an open review PR are proposals.',
               'Accepted additions enter the main pool and the next scheduled release; see UPDATE_GUIDE.md.',
               'A source match documents wording and attribution, not whether the underlying claim is true.', '',
               'One excerpt of at most 25 words is used per distinct source. Review the linked context.', '']
    for i, record in enumerate(records, len(base) + 1):
        lua += [f"    -- {i}: {record['id']}; {record['date']}", '    ' + json.dumps(record['quote'], ensure_ascii=False) + ',']
        sources += [f"## {i}. {record['date']} — {record['id']}", '', '> ' + record['quote'], '',
                    f"[Original source]({record['source_url']}) · [Attribution evidence]({record['evidence_url']})", '',
                    f"Type: {record['source_kind']}; assessment: {record['assessment']}; checked: {record['checked_at']}.", '',
                    record['context'], '']
    lua += ['}', '', 'for _, quote in ipairs(additions) do', '    ns.quotes[#ns.quotes + 1] = quote', 'end', '']
    all_quotes = base + [r['quote'] for r in records]
    catalog = [f'# All {len(all_quotes):,} entries — Trump Quotes Forever {version}', '',
               'Every chat message adds `- Donald Trump`. The pool includes complete statements, short excerpts, and nickname fragments.', '',
               '[Sources 1–120](QUOTE_SOURCES.md) · [Sources 121–200](INSULT_SOURCES.md) · '
               '[Sources 201–1012](ARCHIVE_SOURCES.md) · [Daily additions](DAILY_SOURCES.md)', '',
               'Accusations, opinions, jokes, and boasts are attributed remarks, not established facts.', '']
    catalog += [f'{i}. {quote}' for i, quote in enumerate(all_quotes, 1)]
    readme = (root / 'README.md').read_text()
    readme = re.sub(r'^# Trump Quotes Forever.*$', '# Trump Quotes Forever — ' + version, readme, count=1, flags=re.M)
    readme = re.sub(r'[\d,]+ sourced Trump quotes', f'{len(all_quotes):,} sourced Trump quotes', readme)
    readme = re.sub(r'all [\d,]+ entries', f'all {len(all_quotes):,} entries', readme)
    readme = re.sub(r'The full pool now has [\d,]+ entries', f'The full pool now has {len(all_quotes):,} entries', readme)
    outputs = {GENERATED[0]: '\n'.join(lua), GENERATED[1]: '\n'.join(sources).rstrip() + '\n',
               GENERATED[2]: '\n'.join(catalog) + '\n', GENERATED[3]: readme,
               GENERATED[4]: '\n'.join(all_quotes) + '\n'}
    for name, value in outputs.items():
        path = root / name
        if check:
            if not path.exists() or path.read_text() != value:
                raise ValueError('Generated file is stale: ' + name)
        else:
            path.write_text(value)
    return len(all_quotes)


def privacy_check(files):
    for name, data in files.items():
        text = data.decode('utf-8')
        if re.search(r'(?:/Users/[^\s/]+|[A-Za-z]:[\\/]Users[\\/][^\s\\/]+)', text):
            raise ValueError('Personal filesystem path found in ' + name)
        if re.search(r'(?<![\w/])[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}', text):
            raise ValueError('Email address found in ' + name)
    toc = files['TrumpQuotesForever/TrumpQuotesForever.toc'].decode()
    author = re.search(r'^## Author: (.+)$', toc, re.M)
    if not author or author.group(1) != 'TQ Maintainers':
        raise ValueError('Distribution must use anonymous author credit')


def package(root=ROOT, output=None, review=False):
    render(root, check=True)
    addon = root / 'TrumpQuotesForever'
    toc = (addon / 'TrumpQuotesForever.toc').read_text()
    version = re.search(r'^## Version: (.+)$', toc, re.M).group(1)
    files = {'TrumpQuotesForever/' + p.name: p.read_bytes() for p in sorted(addon.iterdir()) if p.is_file()}
    files['TrumpQuotesForever/README.md'] = (root / 'README.md').read_text().replace('](TrumpQuotesForever/', '](').encode()
    privacy_check(files)
    for line in toc.splitlines():
        if line and not line.startswith('#') and 'TrumpQuotesForever/' + line not in files:
            raise ValueError('Missing TOC dependency: ' + line)
    if review:
        files['TrumpQuotesForever/REVIEW_ONLY.txt'] = b'UNAPPROVED REVIEW BUILD. Do not redistribute as a release.\n'
    destination = Path(output) if output else root / 'dist' / f'TrumpQuotesForever-{version}{"-review" if review else ""}.zip'
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(destination, 'w', zipfile.ZIP_DEFLATED) as archive:
        for name, data in sorted(files.items()):
            info = zipfile.ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, data)
    with zipfile.ZipFile(destination) as archive:
        if archive.testzip():
            raise ValueError('ZIP verification failed')
    digest = hashlib.sha256(destination.read_bytes()).hexdigest()
    destination.with_suffix('.zip.sha256').write_text(digest + '  ' + destination.name + '\n')
    return destination


def release_bundle(version, root=ROOT):
    """Build an install ZIP plus WoW addon-manager metadata; never upload."""
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise ValueError("Release version must be a three-part numeric version")
    toc = (root / 'TrumpQuotesForever/TrumpQuotesForever.toc').read_text()
    actual = re.search(r'^## Version: (.+)$', toc, re.M).group(1)
    interface = re.search(r'^## Interface: (.+)$', toc, re.M).group(1)
    if version != actual:
        raise ValueError("Requested release version must match the TOC")
    if interface != '16001':
        raise ValueError("Recheck Forever compatibility metadata before releasing this interface")
    directory = root / 'dist/release'
    archive = package(root, output=directory / f'TrumpQuotesForever-{version}.zip')
    metadata = {'releases': [{
        'name': 'TrumpQuotesForever', 'version': version, 'filename': archive.name,
        'nolib': False, 'metadata': [{'flavor': 'forever', 'interface': int(interface)}],
    }]}
    (directory / 'release.json').write_text(json.dumps(metadata, indent=2) + '\n')
    return archive


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    sub.add_parser('validate')
    releasing = sub.add_parser('release')
    releasing.add_argument('--version', required=True)
    rendering = sub.add_parser('render')
    rendering.add_argument('--check', action='store_true')
    adding = sub.add_parser('add')
    adding.add_argument('record', type=Path)
    packing = sub.add_parser('package')
    packing.add_argument('--review', action='store_true')
    packing.add_argument('--output')
    args = parser.parse_args()
    try:
        if args.command == 'validate':
            records = validate(read_records())
            print(f'PASS: {len(records)} sourced additions; duplicate, source, date, and byte checks')
        elif args.command == 'render':
            print(f'{render(check=args.check)} total quotes; generated files {"verified" if args.check else "updated"}')
        elif args.command == 'add':
            records = read_records() + [json.loads(args.record.read_text())]
            validate(records)
            (ROOT / LEDGER).write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n')
            render()
            print('Added to local proposal. Commit only to a review branch; do not auto-merge.')
        elif args.command == 'release':
            print(release_bundle(args.version))
        else:
            print(package(output=args.output, review=args.review))
    except (ValueError, KeyError, TypeError) as error:
        parser.exit(1, f'ERROR: {error}\n')


if __name__ == '__main__':
    main()
