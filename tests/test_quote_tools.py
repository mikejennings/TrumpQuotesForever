import copy
import datetime as dt
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest
import zipfile

spec = importlib.util.spec_from_file_location('quote_tools', Path(__file__).resolve().parents[1] / 'scripts/quote_tools.py')
tools = importlib.util.module_from_spec(spec)
spec.loader.exec_module(tools)


def record():
    checked = dt.datetime.now(dt.timezone.utc) - dt.timedelta(minutes=10)
    return {
        'id': 'fixture-source-123',
        'quote': 'These imaginary cushions are the most tremendous cushions anywhere.',
        'date': (checked.date() - dt.timedelta(days=1)).isoformat(),
        'source_url': 'https://example.test/posts/123',
        'evidence_url': 'https://archive.example.test/posts/123',
        'source_kind': 'account_post',
        'context': 'Synthetic unit-test fixture, not a real quotation.',
        'assessment': 'joke-or-boast',
        'checked_at': checked.isoformat(),
        'attribution': 'source-matched',
    }


class QuoteToolsTests(unittest.TestCase):
    def test_valid_record(self):
        self.assertEqual(tools.validate([record()])[0]['id'], 'fixture-source-123')

    def test_historical_and_near_duplicates_rejected(self):
        for quote in [tools.base_quotes()[0], tools.base_quotes()[0] + '!']:
            item = record(); item['quote'] = quote
            with self.assertRaisesRegex(ValueError, 'Duplicate'):
                tools.validate([item])

    def test_chat_injection_and_utf8_bytes_rejected(self):
        for quote in ['A nasty\nnew line', 'A nasty |Hlink', ' '.join(['tremendous'] * 26), ' '.join(['é' * 40] * 4)]:
            item = record(); item['quote'] = quote
            with self.assertRaises(ValueError):
                tools.validate([item])

    def test_duplicate_source_or_evidence_cannot_expand_quote_budget(self):
        first = record()
        second = record(); second.update(id='fixture-source-456', quote='The fictional oranges are enormous and absolutely ridiculous.')
        for key in ['source_url', 'evidence_url']:
            item = copy.deepcopy(second)
            item['source_url'] = 'https://example.test/posts/456'
            item['evidence_url'] = 'https://archive.example.test/posts/456'
            item[key] = first[key] + '?tracking=changed#timecode'
            with self.assertRaisesRegex(ValueError, 'Source already used'):
                tools.validate([first, item])

    def test_historical_source_cannot_be_reused(self):
        item = record()
        item['source_url'] = 'https://trumpwhitehouse.archives.gov/briefings-statements/the-inaugural-address/'
        with self.assertRaisesRegex(ValueError, 'Source already used'):
            tools.validate([item])

    def test_attribution_and_dates_required(self):
        for field, value in [('attribution', 'guessed'), ('date', '2999-01-01'), ('checked_at', '2026-01-01'),
                             ('source_kind', 'headline'), ('assessment', 'proven-lie')]:
            item = record(); item[field] = value
            with self.assertRaises(ValueError):
                tools.validate([item])

    def test_no_unexpected_fields_or_private_source_urls(self):
        item = record(); item['personal_author'] = 'Example'
        with self.assertRaises(ValueError):
            tools.validate([item])
        for url in ['http://example.test/post', 'https://localhost/post', 'https://127.0.0.1/post',
                    'https://user:pass@example.test/post', 'https://example.test:443/post']:
            item = record(); item['source_url'] = url
            with self.assertRaises(ValueError):
                tools.validate([item])

    def test_render_and_package_are_reproducible_and_current(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            shutil.copytree(tools.ROOT / 'TrumpQuotesForever', root / 'TrumpQuotesForever')
            shutil.copy(tools.ROOT / 'README.md', root / 'README.md')
            (root / 'data').mkdir()
            (root / tools.LEDGER).write_text(json.dumps([record()]))
            self.assertEqual(tools.render(root), len(tools.base_quotes(root)) + 1)
            tools.render(root, check=True)
            first = tools.package(root, output=root / 'first.zip', review=True)
            second = tools.package(root, output=root / 'second.zip', review=True)
            self.assertEqual(first.read_bytes(), second.read_bytes())
            with zipfile.ZipFile(first) as archive:
                self.assertIn('TrumpQuotesForever/REVIEW_ONLY.txt', archive.namelist())
                self.assertIn('TrumpQuotesForever/DailyQuotes.lua', archive.namelist())
                self.assertFalse(any('.git/' in name or name.startswith('data/') for name in archive.namelist()))
                self.assertIn(b'TQ Maintainers', archive.read('TrumpQuotesForever/TrumpQuotesForever.toc'))
                self.assertIn(b'Synthetic unit-test fixture', archive.read('TrumpQuotesForever/DAILY_SOURCES.md'))
                self.assertTrue(all(info.date_time == (1980, 1, 1, 0, 0, 0) for info in archive.infolist()))
            (root / 'TrumpQuotesForever/DailyQuotes.lua').write_text('stale')
            with self.assertRaisesRegex(ValueError, 'stale'):
                tools.package(root, output=root / 'bad.zip')

    def test_release_bundle_targets_forever_and_excludes_review_marker(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            shutil.copytree(tools.ROOT / 'TrumpQuotesForever', root / 'TrumpQuotesForever')
            shutil.copy(tools.ROOT / 'README.md', root / 'README.md')
            (root / 'data').mkdir()
            shutil.copy(tools.ROOT / tools.LEDGER, root / tools.LEDGER)
            tools.render(root)
            version = tools.re.search(r'^## Version: (.+)$', (root / 'TrumpQuotesForever/TrumpQuotesForever.toc').read_text(), tools.re.M).group(1)
            archive = tools.release_bundle(version, root)
            metadata = json.loads((archive.parent / 'release.json').read_text())['releases'][0]
            self.assertEqual(metadata['filename'], archive.name)
            self.assertEqual(metadata['metadata'], [{'flavor': 'forever', 'interface': 16001}])
            with zipfile.ZipFile(archive) as z:
                self.assertNotIn('TrumpQuotesForever/REVIEW_ONLY.txt', z.namelist())
                self.assertIn('TrumpQuotesForever/TrumpQuotesForever.toc', z.namelist())
            for version in ['9999.0.0', '../invalid', '0.8.0\\nINJECT=value']:
                with self.assertRaises(ValueError):
                    tools.release_bundle(version, root)

    def test_identifying_metadata_blocks_distribution(self):
        toc = b'## Author: TQ Maintainers\n'
        for data in [b'Author: Jane Example <jane@example.test>', b'/Users/example/private', b'C:\\Users\\example\\private']:
            with self.assertRaises(ValueError):
                tools.privacy_check({'TrumpQuotesForever/TrumpQuotesForever.toc': toc, 'README.md': data})
        with self.assertRaises(ValueError):
            tools.privacy_check({'TrumpQuotesForever/TrumpQuotesForever.toc': b'## Author: Personal Name\n'})


if __name__ == '__main__':
    unittest.main()
