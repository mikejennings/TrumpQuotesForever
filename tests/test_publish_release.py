import hashlib
import json
from pathlib import Path
import shutil
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import publish_release as publisher


class PublicationTests(unittest.TestCase):
    def simulate(self, draft=True, checksum_valid=True, metadata_valid=True, missing=False):
        filename = 'TrumpQuotesForever-0.8.1.zip'
        content = b'Synthetic ZIP; archive validation tested separately'
        digest = hashlib.sha256(content).hexdigest()
        metadata = {'releases': [{'name': 'TrumpQuotesForever', 'version': '0.8.1',
                    'filename': filename, 'nolib': False,
                    'metadata': [{'flavor': 'forever', 'interface': 16001}]}]}
        if not metadata_valid:
            metadata['releases'][0]['metadata'][0]['interface'] = 1
        files = {filename: content, filename + '.sha256':
                 f'{digest if checksum_valid else "bad"}  {filename}\n'.encode(),
                 'release.json': json.dumps(metadata).encode()}
        release = {'isDraft': draft, 'assets': [{'name': name} for name in files if not (missing and name == 'release.json')]}
        commands = []
        def run(command, **kwargs):
            commands.append(command)
            if command[:3] == ['gh', 'release', 'download']:
                name = command[command.index('--pattern') + 1]
                (Path(command[command.index('--dir') + 1]) / name).write_bytes(files[name])
        with patch.object(publisher.subprocess, 'check_output', return_value=json.dumps(release)), \
             patch.object(publisher.subprocess, 'run', side_effect=run), \
             patch.object(publisher, 'validate_archive'):
            try:
                publisher.publish('v0.8.1')
            finally:
                self.commands = commands
        return commands

    def test_verified_draft_publishes_to_github_only(self):
        commands = self.simulate()
        self.assertIn(['gh', 'release', 'edit', 'v0.8.1', '--draft=false', '--latest'], commands)
        self.assertTrue(all(command[:2] == ['gh', 'release'] for command in commands))
        self.assertFalse(any('upload' in command for command in commands))

    def test_already_published_release_is_not_modified(self):
        self.assertFalse(any('edit' in command for command in self.simulate(draft=False)))

    def test_invalid_assets_never_publish(self):
        for options in [dict(checksum_valid=False), dict(metadata_valid=False), dict(missing=True)]:
            with self.subTest(options=options):
                with self.assertRaises(ValueError):
                    self.simulate(**options)
                self.assertFalse(any('edit' in command for command in self.commands))

    def test_invalid_tag_is_rejected_before_any_commands(self):
        with patch.object(publisher.subprocess, 'check_output') as command:
            with self.assertRaises(ValueError):
                publisher.publish('unsafe-tag')
        command.assert_not_called()

    def test_archive_must_be_install_build_and_match_version(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            shutil.copytree(publisher.qt.ROOT / 'TrumpQuotesForever', root / 'TrumpQuotesForever')
            shutil.copytree(publisher.qt.ROOT / 'data', root / 'data')
            shutil.copy(publisher.qt.ROOT / 'README.md', root / 'README.md')
            publisher.qt.render(root)
            toc = (root / 'TrumpQuotesForever/TrumpQuotesForever.toc').read_text()
            version = publisher.re.search(r'^## Version: (.+)$', toc, publisher.re.M)[1]
            archive = publisher.qt.release_bundle(version, root)
            publisher.validate_archive(archive, version, 16001)
            with self.assertRaises(ValueError):
                publisher.validate_archive(archive, '9999.0.0', 16001)
            review = publisher.qt.package(root, review=True)
            with self.assertRaises(ValueError):
                publisher.validate_archive(review, version, 16001)


if __name__ == '__main__':
    unittest.main()
