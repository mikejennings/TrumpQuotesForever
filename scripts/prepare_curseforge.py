#!/usr/bin/env python3
"""Assemble listing materials around the unchanged v0.8.0 release ZIP."""
from pathlib import Path
import hashlib
import re
import struct
import zipfile

ROOT = Path(__file__).resolve().parents[1]
VERSION = '0.8.0'
EXPECTED_SHA256 = '215a08eaaaa855117e74a7a2eed2c8d45e65979f08c3a8d7fb22a229611f349f'
NAME = f'TrumpQuotesForever-{VERSION}.zip'
SOURCE = ROOT / 'submission' / 'curseforge'
DEST = ROOT / 'dist' / 'curseforge-ready'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def privacy_check(name, data):
    for pattern in (rb'/Users/', rb'C:\\Users\\', rb'mikejennings',
                    rb'mike\s+jennings', rb'[\w.+-]+@[\w.-]+\.[A-Za-z]{2,}'):
        if re.search(pattern, data, re.I):
            raise ValueError(f'Personal identifier in {name}')


def main():
    addon = (ROOT / 'dist' / 'release' / NAME).read_bytes()
    if digest(addon) != EXPECTED_SHA256:
        raise ValueError('Install ZIP differs from the published v0.8.0 release')
    icon = (SOURCE / 'icon-400.png').read_bytes()
    if icon[:8] != b'\x89PNG\r\n\x1a\n' or struct.unpack('>II', icon[16:24]) != (400, 400):
        raise ValueError('Project icon must be a 400x400 PNG')
    with zipfile.ZipFile(ROOT / 'dist' / 'release' / NAME) as archive:
        if archive.testzip():
            raise ValueError('Corrupt addon archive')
        for member in archive.infolist():
            if not member.filename.startswith('TrumpQuotesForever/'):
                raise ValueError('Unexpected addon root folder')
            if not member.is_dir():
                privacy_check(member.filename, archive.read(member))
        toc = archive.read('TrumpQuotesForever/TrumpQuotesForever.toc').decode()
        if '## Interface: 16001' not in toc or '## Author: TQ Maintainers' not in toc:
            raise ValueError('Unexpected interface or author credit')
    payload = {p.name: p.read_bytes() for p in SOURCE.iterdir() if p.is_file()}
    for name, data in payload.items():
        privacy_check(name, data)
    payload[NAME] = addon
    payload['SHA256SUMS.txt'] = ''.join(
        f'{digest(data)}  {name}\n' for name, data in sorted(payload.items())
    ).encode()
    DEST.mkdir(parents=True, exist_ok=True)
    for name, data in payload.items():
        (DEST / name).write_bytes(data)
    kit = ROOT / 'dist' / f'TrumpQuotesForever-{VERSION}-CurseForge-kit.zip'
    with zipfile.ZipFile(kit, 'w', zipfile.ZIP_DEFLATED) as archive:
        for name, data in sorted(payload.items()):
            info = zipfile.ZipInfo(f'CurseForge-kit/{name}', (1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.create_system = 3
            info.external_attr = 0o100644 << 16
            archive.writestr(info, data)
    print(f'PASS: unchanged v{VERSION} ZIP, anonymous materials, 400x400 PNG')
    print(kit.relative_to(ROOT))


if __name__ == '__main__':
    main()
