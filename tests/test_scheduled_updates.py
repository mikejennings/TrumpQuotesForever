import datetime as dt
from email.utils import format_datetime
from html import escape
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import scheduled_updates as updates

NOW = dt.datetime.now(dt.timezone.utc).replace(microsecond=0)


def feed(text='These imaginary cushions are the most tremendous cushions anywhere.',
         kind='original', creator='Donald J. Trump', removed='false', when=None):
    return f'''<rss xmlns:archive="{updates.ARCHIVE}" xmlns:truth="{updates.TRUTH}" xmlns:dc="{updates.DC}">
      <channel><item><link>https://www.trumpstruth.org/statuses/999999</link>
      <description>{escape('<p>' + text + '</p>')}</description>
      <archive:postType>{kind}</archive:postType><archive:removed>{removed}</archive:removed>
      <dc:creator>{creator}</dc:creator><truth:originalUrl>https://truthsocial.com/@realDonaldTrump/999999</truth:originalUrl>
      <pubDate>{format_datetime(when or NOW - dt.timedelta(hours=1))}</pubDate>
      </item></channel></rss>'''


class ScheduledUpdatesTests(unittest.TestCase):
    def test_total_source_outage_keeps_ledger_unchanged_and_records_coverage(self):
        import public_quote_sources
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory)
            for name in ['TrumpQuotesForever','data']:
                shutil.copytree(updates.qt.ROOT/name,root/name)
            shutil.copy(updates.qt.ROOT/'README.md',root/'README.md')
            before=(root/updates.qt.LEDGER).read_bytes()
            with patch.object(updates,'urlopen',side_effect=ValueError('Unavailable')), \
                 patch.object(public_quote_sources,'fetch',side_effect=ValueError('Unavailable')), \
                 patch('builtins.print'):
                with self.assertRaisesRegex(ValueError,'All sources unavailable'):
                    updates.collect(root=root,now=NOW)
            self.assertEqual((root/updates.qt.LEDGER).read_bytes(),before)
            self.assertTrue((root/'dist/quote-source-coverage.json').exists())

    def test_auto_accept_rejects_edits_removals_and_noop(self):
        base = [{'id': 'old', 'quote': 'Original quote'}]
        updates.check_append_only(base, base + [{'id': 'new', 'quote': 'Another quote'}])
        for proposed in [[], base, [{'id': 'old', 'quote': 'Edited quote'}, {'id': 'new'}]]:
            with self.assertRaisesRegex(ValueError, 'additions only'):
                updates.check_append_only(base, proposed)

    def test_auto_accept_rejects_unrelated_generated_file_changes(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory) / 'repo'
            subprocess.run(['git', 'clone', '--quiet', '--no-hardlinks', str(updates.qt.ROOT), str(root)], check=True)
            subprocess.run(['git', 'config', 'user.name', 'TQ Maintainers'], cwd=root, check=True)
            subprocess.run(['git', 'config', 'user.email', 'tq-maintainers@users.noreply.github.com'], cwd=root, check=True)
            base = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=root, text=True).strip()
            updates.collect(root, feed(), NOW)
            subprocess.run(['git', 'add', '.'], cwd=root, check=True)
            subprocess.run(['git', 'commit', '--quiet', '-m', 'Synthetic fixture'], cwd=root, check=True)
            updates.verify_quote_only(root, base)
            with (root / 'README.md').open('a') as file:
                file.write('\nUnrelated injected instructions.\n')
            subprocess.run(['git', 'add', 'README.md'], cwd=root, check=True)
            subprocess.run(['git', 'commit', '--quiet', '-m', 'Synthetic unwanted edit'], cwd=root, check=True)
            with self.assertRaisesRegex(ValueError, 'Unexpected non-quote content'):
                updates.verify_quote_only(root, base)

    def test_exact_sentence_and_archive_attribution(self):
        quote = 'These tremendous cushions are lovely!'
        result = updates.candidates(feed(quote + ' A routine second sentence.'), NOW)
        self.assertEqual([r['quote'] for r in result], [quote])
        self.assertIn('not independent authentication', result[0]['context'])

    def test_reposts_quoted_material_wrong_creator_removed(self):
        for kwargs in [{'kind': 'repost'}, {'kind': 'quote'}, {'creator': 'Other Person'},
                       {'removed': 'true'}, {'text': '"These tremendous cushions are lovely!"'},
                       {'text': '<blockquote>These tremendous cushions are lovely!</blockquote>'}]:
            with self.subTest(kwargs=kwargs):
                self.assertEqual(updates.candidates(feed(**kwargs), NOW), [])

    def test_no_media_link_fragments_or_unfinished_sentences(self):
        for text in ['View tremendous video https://example.test/video.',
                     'An unfinished tremendous sentence',
                     'Tremendous!', 'Tremendous ' + 'cushions ' * 27 + '.',
                     'These ordinary cushions are rather nice.',
                     'These tremendous people have my endorsement!',
                     'These tremendous cushions are lovely! Please donate today.']:
            with self.subTest(text=text):
                self.assertEqual(updates.candidates(feed(text=text), NOW), [])

    def test_time_window_excludes_future_and_old(self):
        for when in [NOW + dt.timedelta(hours=1), NOW - dt.timedelta(days=8)]:
            self.assertEqual(updates.candidates(feed(when=when), NOW), [])

    def test_broken_or_empty_feed_is_a_failure(self):
        for xml in ['<html/>', '<rss><channel/></rss>', '<broken>']:
            with self.assertRaises(ValueError if xml != '<broken>' else updates.ET.ParseError):
                updates.candidates(xml, NOW)

    def test_collection_is_idempotent_and_source_budget_preserved(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            shutil.copytree(updates.qt.ROOT / 'TrumpQuotesForever', root / 'TrumpQuotesForever')
            shutil.copytree(updates.qt.ROOT / 'data', root / 'data')
            shutil.copy(updates.qt.ROOT / 'README.md', root / 'README.md')
            first = updates.collect(root, feed(), NOW)
            self.assertEqual(len(first), 1)
            original = (root / updates.qt.LEDGER).read_bytes()
            self.assertEqual(updates.collect(root, feed(), NOW), [])
            self.assertEqual(updates.collect(root, feed(text='These tremendous cushions are very different today!'), NOW), [])
            self.assertEqual((root / updates.qt.LEDGER).read_bytes(), original)
            updates.qt.render(root, check=True)

    def test_five_days_is_elapsed_time_not_day_of_month(self):
        release = {'draft': False, 'prerelease': False, 'tag_name': 'v0.8.0',
                   'published_at': '2026-10-29T02:24:42Z'}
        published = dt.datetime(2026, 10, 29, 2, 24, 42, tzinfo=dt.timezone.utc)
        self.assertIsNone(updates.release_plan([release], published + dt.timedelta(days=5, seconds=-1), True))
        self.assertEqual(updates.release_plan([release], published + dt.timedelta(days=5), True), '0.8.1')
        self.assertIsNone(updates.release_plan([release], published + dt.timedelta(days=8), False))
        self.assertIsNone(updates.release_plan([release, {'draft': True}], published + dt.timedelta(days=8), True))
        self.assertIsNone(updates.release_plan([], published, True))


if __name__ == '__main__':
    unittest.main()
