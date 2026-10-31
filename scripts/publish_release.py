#!/usr/bin/env python3
"""Upload a verified release ZIP to CurseForge, then publish its GitHub draft."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
from urllib.error import HTTPError, URLError
from urllib.request import Request, build_opener, HTTPRedirectHandler
import uuid
import zipfile

import quote_tools as qt

API = 'https://wow.curseforge.com/api'


class NoRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None  # Never forward the upload credential to a different URL.


def api_json(path, token, data=None, content_type=None):
    headers = {'X-Api-Token': token, 'User-Agent': 'TrumpQuotesForever release publisher'}
    if content_type:
        headers['Content-Type'] = content_type
    request = Request(API + path, data=data, headers=headers)
    try:
        with build_opener(NoRedirect).open(request, timeout=90) as response:
            return json.load(response)
    except HTTPError as error:
        raise ValueError(f'CurseForge HTTP {error.code}; no successful upload is claimed') from None
    except (URLError, TimeoutError, json.JSONDecodeError):
        raise ValueError('CurseForge response unavailable or ambiguous; inspect the project before retrying') from None


def upload_metadata(config, versions, version):
    matches = [v for v in versions if v.get('name') == config['game_version']]
    if len(matches) != 1 or type(matches[0].get('id')) is not int:
        raise ValueError('Supported Forever version must resolve to exactly one CurseForge game-version ID')
    return {'displayName': f'Trump Quotes {version} (Forever)',
            'changelog': f'Version {version}: validated quote collection update. Source/context notes are included. '
                         'Contains unfiltered profanity, insults, sexual references and disputed claims. '
                         'The timer starts off. Live public-channel delivery remains unverified.',
            'changelogType': 'text', 'gameVersions': [matches[0]['id']],
            'releaseType': config['release_type'],
            'isMarkedForManualRelease': config['manual_release']}


def validate_archive(path, version, interface):
    with zipfile.ZipFile(path) as archive:
        if archive.testzip():
            raise ValueError('Corrupt release ZIP')
        files = {}
        for item in archive.infolist():
            if item.is_dir():
                continue
            if not item.filename.startswith('TrumpQuotesForever/') or '..' in Path(item.filename).parts:
                raise ValueError('Invalid addon archive layout')
            files[item.filename] = archive.read(item)
        qt.privacy_check(files)
        toc = files['TrumpQuotesForever/TrumpQuotesForever.toc'].decode()
        if (f'## Version: {version}\n' not in toc or f'## Interface: {interface}\n' not in toc
                or 'TrumpQuotesForever/REVIEW_ONLY.txt' in files):
            raise ValueError('Release version/interface mismatch or unapproved review archive')
        if re.search(rb'mikejennings|mike\s+jennings', b'\n'.join(files.values()), re.I):
            raise ValueError('Personal maintainer identifier found in package')


def multipart(metadata, filename, data):
    boundary = 'tq-' + uuid.uuid4().hex
    body = (f'--{boundary}\r\nContent-Disposition: form-data; name="metadata"\r\n'
            'Content-Type: application/json\r\n\r\n').encode() + json.dumps(metadata).encode()
    body += (f'\r\n--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="{filename}"\r\n'
             'Content-Type: application/zip\r\n\r\n').encode() + data
    body += f'\r\n--{boundary}--\r\n'.encode()
    return body, f'multipart/form-data; boundary={boundary}'


def publish(tag):
    match = re.fullmatch(r'v(\d+\.\d+\.\d+)', tag)
    if not match:
        raise ValueError('Expected a numeric vX.Y.Z release tag')
    version = match[1]
    config = json.loads((qt.ROOT / 'data/curseforge.json').read_text())
    release = json.loads(subprocess.check_output(['gh', 'release', 'view', tag, '--json', 'isDraft,assets'], text=True))
    assets = {a['name'] for a in release['assets']}
    filename = f'TrumpQuotesForever-{version}.zip'
    receipt_name, attempt_name = 'curseforge-upload.json', 'curseforge-upload-started.json'
    with tempfile.TemporaryDirectory() as directory:
        folder = Path(directory)
        for name in [filename, filename + '.sha256']:
            subprocess.run(['gh', 'release', 'download', tag, '--pattern', name, '--dir', directory], check=True)
        archive = folder / filename
        digest = hashlib.sha256(archive.read_bytes()).hexdigest()
        expected = (folder / (filename + '.sha256')).read_text().split()
        if expected != [digest, filename]:
            raise ValueError('Release ZIP does not match its SHA-256 file')
        validate_archive(archive, version, config['interface'])
        if receipt_name in assets:
            subprocess.run(['gh', 'release', 'download', tag, '--pattern', receipt_name, '--dir', directory], check=True)
            receipt = json.loads((folder / receipt_name).read_text())
            if (receipt.get('sha256') != digest or receipt.get('project_id') != config['project_id']
                    or type(receipt.get('file_id')) is not int or receipt['file_id'] <= 0):
                raise ValueError('Existing upload receipt does not match this release')
            print(f"Already uploaded to CurseForge: file {receipt['file_id']}; no duplicate upload")
        else:
            token = os.environ.get('CF_API_TOKEN', '')
            if not token:
                raise ValueError('Set the CF_API_TOKEN repository Actions secret before publication')
            if attempt_name in assets:
                raise ValueError('An earlier upload attempt has no receipt. Inspect CurseForge before retrying; automatic duplicate upload refused')
            versions = api_json('/game/versions', token)
            metadata = upload_metadata(config, versions, version)
            marker = folder / attempt_name
            marker.write_text(json.dumps({'project_id': config['project_id'], 'version': version, 'sha256': digest}) + '\n')
            # Persist intent BEFORE the POST. If the connection dies after server
            # acceptance, reruns stop instead of silently uploading duplicates.
            subprocess.run(['gh', 'release', 'upload', tag, str(marker)], check=True)
            body, content_type = multipart(metadata, filename, archive.read_bytes())
            result = api_json(f"/projects/{config['project_id']}/upload-file", token, body, content_type)
            file_id = result.get('id')
            if type(file_id) is not int or file_id <= 0:
                raise ValueError('CurseForge did not return a valid file ID; inspect the project before retrying')
            receipt = {'project_id': config['project_id'], 'file_id': file_id,
                       'version': version, 'sha256': digest, 'release_type': metadata['releaseType'],
                       'manual_release': metadata['isMarkedForManualRelease'], 'status': 'uploaded; moderation pending'}
            receipt_path = folder / receipt_name
            receipt_path.write_text(json.dumps(receipt, indent=2) + '\n')
            subprocess.run(['gh', 'release', 'upload', tag, str(receipt_path)], check=True)
            print(f'CurseForge accepted upload: file {file_id}; publication follows moderator approval')
        if release['isDraft']:
            subprocess.run(['gh', 'release', 'edit', tag, '--draft=false', '--latest'], check=True)
            print('GitHub release published after CurseForge accepted the upload')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--tag', required=True)
    args = parser.parse_args()
    try:
        publish(args.tag)
    except (ValueError, KeyError, TypeError) as error:
        parser.exit(1, f'ERROR: {error}\n')
