"""Sign locally with the original key and reject any replacement certificate.

Passwords are passed through WIDE55_KEYSTORE_PASS and WIDE55_KEY_PASS environment
variables. Do not commit a signing key or its passwords to this repository.
"""
import argparse
import re
import subprocess
import tempfile
from pathlib import Path

EXPECTED_CERT = 'eb0f6a44174aecf09cedc237be2ca0305ea491d47b381407d31e903acbd34b46'


def main():
    p = argparse.ArgumentParser(description=__doc__)
    for key in ['unsigned', 'apksigner', 'keystore', 'output']:
        p.add_argument('--' + key, required=True, type=Path)
    p.add_argument('--alias', required=True)
    a = p.parse_args()
    if a.output.exists():
        raise SystemExit('Output exists; use a new filename.')
    a.output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='wide55-sign-') as tmp:
        signed = Path(tmp) / 'signed.apk'
        subprocess.run(['java', '-jar', str(a.apksigner), 'sign', '--ks', str(a.keystore),
                        '--ks-key-alias', a.alias, '--ks-pass', 'env:WIDE55_KEYSTORE_PASS',
                        '--key-pass', 'env:WIDE55_KEY_PASS', '--out', str(signed), str(a.unsigned)], check=True)
        result = subprocess.check_output(['java', '-jar', str(a.apksigner), 'verify',
                                          '--verbose', '--print-certs', str(signed)], text=True)
        certs = re.findall(r'Signer #\d+ certificate SHA-256 digest: ([0-9a-fA-F]+)', result)
        if certs != [EXPECTED_CERT]:
            raise SystemExit('Certificate does not match wide54; no installable output produced.')
        a.output.write_bytes(signed.read_bytes())
        print('Verified original signing certificate:', EXPECTED_CERT)
        print('Signed APK:', a.output)


if __name__ == '__main__':
    main()
