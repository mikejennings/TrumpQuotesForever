#!/usr/bin/env python3
"""Collect review-only RSS excerpts and plan five-day draft releases."""
import argparse
import datetime as dt
from email.utils import parsedate_to_datetime
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import subprocess
import tempfile
from urllib.request import Request, urlopen
import xml.etree.ElementTree as ET

import quote_tools as qt

ARCHIVE = 'https://www.trumpstruth.org/rss-extensions'
TRUTH = 'https://truthsocial.com/ns'
DC = 'http://purl.org/dc/elements/1.1/'
SIGNAL = re.compile(r'\b(ass|asses|piggy|loser|stupid|idiot|dumb|crooked|disgusting|crazy|lunatic|moron|ugly|fat|greatest|smartest|tremendous|witch hunt)\b', re.I)


class PlainText(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.parts = []

    def handle_data(self, text):
        self.parts.append(text)

    def handle_starttag(self, tag, attrs):
        if tag in {'p', 'br'}:
            self.parts.append(' ')

    def handle_endtag(self, tag):
        if tag == 'p':
            self.parts.append(' ')


def candidates(xml, now):
    root = ET.fromstring(xml)
    if root.tag != 'rss' or root.find('channel') is None:
        raise ValueError('Expected RSS channel; source coverage unavailable')
    items = root.findall('./channel/item')
    if not items:
        raise ValueError('Empty feed; cannot claim a successful source check')
    results = []
    for item in reversed(items):
        # Quote-posts, reposts, media transcripts and image descriptions are not
        # attributable original text; never mine their nested/generated material.
        if item.findtext(f'{{{ARCHIVE}}}postType') != 'original':
            continue
        if item.findtext(f'{{{ARCHIVE}}}removed') != 'false':
            continue
        if item.findtext(f'{{{DC}}}creator') != 'Donald J. Trump':
            continue
        original = item.findtext(f'{{{TRUTH}}}originalUrl', '')
        evidence = item.findtext('link', '')
        identity = re.fullmatch(r'https://truthsocial.com/@realDonaldTrump/(\d+)', original)
        if not identity or not re.fullmatch(r'https://www.trumpstruth.org/statuses/\d+', evidence):
            continue
        try:
            published = parsedate_to_datetime(item.findtext('pubDate', ''))
            if not published.tzinfo or not now - dt.timedelta(days=7) <= published <= now:
                continue
        except (ValueError, TypeError):
            continue
        html = item.findtext('description', '')
        if re.search(r'<(?:blockquote|script|iframe)\b|https?://|[“”"]', html, re.I):
            continue
        parser = PlainText()
        parser.feed(html)
        text = re.sub(r'\s+', ' ', ''.join(parser.parts)).strip()
        if re.search(r'\b(endorse(?:ment)?|vote for|donate|retruth|reposted)\b', text, re.I):
            continue
        # Only complete sentences. No truncation, paraphrasing or reconstructed
        # speech. At most one distinctive sentence from any original post.
        sentences = re.findall(r'(?:^|(?<=[.!?])\s)([^.!?]+[.!?])(?=\s|$)', text)
        for sentence in sentences:
            sentence = sentence.strip()
            if not 3 <= len(sentence.split()) <= 25 or not SIGNAL.search(sentence):
                continue
            if re.search(r'\b(endorsement|vote for|donate|retruth|reposted)\b', sentence, re.I):
                continue
            results.append({
                'id': 'truth-' + identity[1], 'quote': sentence,
                'date': published.date().isoformat(), 'source_url': original,
                'evidence_url': evidence, 'source_kind': 'account_post',
                'context': 'Automatically extracted contiguous sentence from an archive RSS item marked original by Donald J. Trump. '
                           'Only the original text field was used, not media transcripts, image descriptions or reposts. '
                           'Other sentences are omitted. Archive attribution is not independent authentication or fact checking. '
                           'Automatic quote-only acceptance was authorized by the maintainer; linked context remains available for correction.',
                'assessment': 'unverified-claim', 'checked_at': now.isoformat(),
                'attribution': 'source-matched',
            })
            break
    return results


def collect(root=qt.ROOT, xml=None, now=None):
    now = now or dt.datetime.now(dt.timezone.utc)
    if xml is None:
        # Fixed public endpoint; feed content cannot redirect the collector to
        # arbitrary source URLs or execute commands. Network errors fail the job.
        start = (now - dt.timedelta(days=7)).date().isoformat()
        request = Request(f'https://www.trumpstruth.org/feed?start_date={start}&limit=500',
                          headers={'User-Agent': 'TrumpQuotesForever review RSS reader'})
        with urlopen(request, timeout=30) as response:
            xml = response.read(8_000_001)
        if len(xml) > 8_000_000:
            raise ValueError('Feed exceeds size limit')
    records = qt.read_records(root)
    added = []
    for record in candidates(xml, now):
        try:
            qt.validate(records + [record], root)
        except ValueError:
            continue  # Existing sources, duplicates, or unsafe/oversized text.
        records.append(record)
        added.append(record)
        if len(added) >= 10:
            break
    if added:
        (root / qt.LEDGER).write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n')
        qt.render(root)
    print(f'RSS check: {len(added)} new review proposals; no merge or publication')
    return added


def release_plan(releases, now, changed):
    if any(r['draft'] for r in releases):
        return None  # Never replace a draft that is waiting for human review.
    published = [r for r in releases if not r['draft'] and not r['prerelease']]
    if not published:
        return None  # Initial publication stays an explicit manual operation.
    latest = max(published, key=lambda r: r['published_at'])
    age = now - dt.datetime.fromisoformat(latest['published_at'].replace('Z', '+00:00'))
    if age < dt.timedelta(days=5) or not changed:
        return None
    match = re.fullmatch(r'v(\d+)\.(\d+)\.(\d+)', latest['tag_name'])
    if not match:
        raise ValueError('Latest release must have a numeric vX.Y.Z tag')
    major, minor, patch = map(int, match.groups())
    return f'{major}.{minor}.{patch + 1}'


def plan(root=qt.ROOT):
    releases = json.loads(subprocess.check_output(
        ['gh', 'api', '--paginate', '--slurp', 'repos/{owner}/{repo}/releases'], text=True))
    releases = [r for page in releases for r in page]
    published = [r for r in releases if not r['draft'] and not r['prerelease']]
    changed = False
    if published:
        latest = max(published, key=lambda r: r['published_at'])
        result = subprocess.run(['git', 'diff', '--quiet', latest['tag_name'], 'HEAD', '--',
                                 'TrumpQuotesForever', 'data/daily_quotes.json'], cwd=root)
        if result.returncode not in (0, 1):
            raise ValueError('Cannot compare the last release with approved main')
        changed = result.returncode == 1
    version = release_plan(releases, dt.datetime.now(dt.timezone.utc), changed)
    if version:
        toc_path = root / 'TrumpQuotesForever/TrumpQuotesForever.toc'
        toc = toc_path.read_text()
        current = re.search(r'^## Version: (.+)$', toc, re.M)[1]
        if tuple(map(int, current.split('.'))) > tuple(map(int, version.split('.'))):
            version = current
        toc_path.write_text(re.sub(r'^## Version: .+$', '## Version: ' + version, toc, flags=re.M))
        qt.render(root)
        Path('dist/release-version.txt').parent.mkdir(parents=True, exist_ok=True)
        Path('dist/release-version.txt').write_text(version)
    print('Draft release due: ' + (version or 'no; unchanged, too early, or draft pending'))
    return version


def check_append_only(base, proposed):
    if len(proposed) <= len(base) or proposed[:len(base)] != base:
        raise ValueError('Automatic acceptance permits additions only; existing quotes must stay unchanged')


def verify_quote_only(root=qt.ROOT, base='origin/main'):
    """Reconstruct generated outputs from trusted main, rejecting other edits."""
    def show(path):
        return subprocess.check_output(['git', 'show', f'{base}:{path}'], cwd=root)
    paths = subprocess.check_output(['git', 'diff', '--name-only', base, 'HEAD'], cwd=root, text=True).splitlines()
    allowed = {qt.LEDGER, *qt.GENERATED}
    if set(paths) - allowed:
        raise ValueError('Automatic acceptance is limited to the quote ledger and exact generated outputs')
    proposed = qt.read_records(root)
    check_append_only(json.loads(show(qt.LEDGER)), proposed)
    qt.validate(proposed, root)
    with tempfile.TemporaryDirectory() as directory:
        clean = Path(directory)
        inputs = subprocess.check_output(['git', 'ls-tree', '-r', '--name-only', base, '--',
                                          'TrumpQuotesForever', 'README.md', qt.LEDGER], cwd=root, text=True)
        for path in inputs.splitlines():
            destination = clean / path
            destination.parent.mkdir(parents=True, exist_ok=True)
            destination.write_bytes(show(path))
        (clean / qt.LEDGER).write_text(json.dumps(proposed, ensure_ascii=False, indent=2) + '\n')
        qt.render(clean)
        for path in qt.GENERATED:
            if (clean / path).read_bytes() != (root / path).read_bytes():
                raise ValueError('Unexpected non-quote content in ' + path)
    print('PASS: additions only; generated outputs match trusted main')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('command', choices=['collect', 'plan-release', 'verify-quote-only'])
    args = parser.parse_args()
    if args.command == 'collect':
        collect()
    elif args.command == 'plan-release':
        plan()
    else:
        verify_quote_only()
