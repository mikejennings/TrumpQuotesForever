from email.parser import BytesParser
from email.policy import default
import importlib.util
from pathlib import Path
import hashlib
import json
import shutil
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import publish_release as publisher


class PublicationTests(unittest.TestCase):
    def test_existing_receipt_prevents_duplicate_upload_and_resumes_publication(self):
        content = b'Synthetic ZIP fixture; validation is tested separately'
        digest = hashlib.sha256(content).hexdigest()
        receipt = {'project_id': 1771665, 'file_id': 42, 'sha256': digest}
        release = {'isDraft': True, 'assets': [{'name': 'curseforge-upload.json'}]}
        commands = []
        def run(command, **kwargs):
            commands.append(command)
            if command[:3] == ['gh', 'release', 'download']:
                name = command[command.index('--pattern') + 1]
                folder = Path(command[command.index('--dir') + 1])
                data = (json.dumps(receipt).encode() if name == 'curseforge-upload.json' else
                        f'{digest}  TrumpQuotesForever-0.8.1.zip\n'.encode() if name.endswith('.sha256') else content)
                (folder / name).write_bytes(data)
        with patch.object(publisher.subprocess, 'check_output', return_value=json.dumps(release)), \
             patch.object(publisher.subprocess, 'run', side_effect=run), \
             patch.object(publisher, 'validate_archive'), \
             patch.object(publisher, 'api_json') as network, patch.dict(publisher.os.environ, {'CF_API_TOKEN': ''}):
            publisher.publish('v0.8.1')
        network.assert_not_called()
        self.assertIn(['gh', 'release', 'edit', 'v0.8.1', '--draft=false', '--latest'], commands)

    def test_ambiguous_prior_upload_is_not_retried(self):
        release = {'isDraft': True, 'assets': [{'name': 'curseforge-upload-started.json'}]}
        content = b'Fixture'
        digest = hashlib.sha256(content).hexdigest()
        def run(command, **kwargs):
            if command[:3] == ['gh', 'release', 'download']:
                name = command[command.index('--pattern') + 1]
                folder = Path(command[command.index('--dir') + 1])
                (folder / name).write_bytes(f'{digest}  TrumpQuotesForever-0.8.1.zip\n'.encode() if name.endswith('.sha256') else content)
        with patch.object(publisher.subprocess, 'check_output', return_value=json.dumps(release)), \
             patch.object(publisher.subprocess, 'run', side_effect=run), \
             patch.object(publisher, 'validate_archive'), \
             patch.object(publisher, 'api_json') as network, patch.dict(publisher.os.environ, {'CF_API_TOKEN': 'synthetic-fixture'}):
            with self.assertRaisesRegex(ValueError, 'no receipt'):
                publisher.publish('v0.8.1')
        network.assert_not_called()

    def test_metadata_resolves_forever_id_and_auto_publication(self):
        config = {'game_version': '1.60.1', 'release_type': 'release', 'manual_release': False}
        metadata = publisher.upload_metadata(config, [{'id': 123, 'name': '1.60.1'}], '0.8.1')
        self.assertEqual(metadata['gameVersions'], [123])
        self.assertEqual(metadata['releaseType'], 'release')
        self.assertIs(metadata['isMarkedForManualRelease'], False)
        for versions in [[], [{'id': '123', 'name': '1.60.1'}], [{'id': 1, 'name': '1.60.1'}] * 2]:
            with self.assertRaises(ValueError):
                publisher.upload_metadata(config, versions, '0.8.1')

    def test_multipart_round_trips_zip_bytes_and_json_without_token(self):
        binary = b'PK\x00\x01\r\n\xff'
        body, content_type = publisher.multipart({'releaseType': 'release'}, 'addon.zip', binary)
        message = BytesParser(policy=default).parsebytes(('Content-Type: ' + content_type + '\r\n\r\n').encode() + body)
        parts = list(message.iter_parts())
        self.assertEqual(parts[0].get_param('name', header='content-disposition'), 'metadata')
        self.assertEqual(parts[1].get_filename(), 'addon.zip')
        self.assertEqual(parts[1].get_payload(decode=True), binary)
        self.assertNotIn(b'X-Api-Token', body)

    def test_no_credential_forwarding_on_redirect(self):
        self.assertIsNone(publisher.NoRedirect().redirect_request(None, None, 302, '', {}, 'https://other.example/'))

    def test_archive_must_be_install_build_and_match_version(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            shutil.copytree(publisher.qt.ROOT / 'TrumpQuotesForever', root / 'TrumpQuotesForever')
            shutil.copytree(publisher.qt.ROOT / 'data', root / 'data')
            shutil.copy(publisher.qt.ROOT / 'README.md', root / 'README.md')
            publisher.qt.render(root)
            archive = publisher.qt.release_bundle('0.8.0', root)
            publisher.validate_archive(archive, '0.8.0', 16001)
            with self.assertRaises(ValueError):
                publisher.validate_archive(archive, '0.8.1', 16001)
            review = publisher.qt.package(root, review=True)
            with self.assertRaises(ValueError):
                publisher.validate_archive(review, '0.8.0', 16001)


if __name__ == '__main__':
    unittest.main()
