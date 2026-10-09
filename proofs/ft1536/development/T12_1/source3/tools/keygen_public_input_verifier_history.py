#!/usr/bin/env python3
"""Recover the exact pre-header-decision organizer bytes against its receipt SHA.

This is reversible source bookkeeping,not a mathematical computation. The
old receipt/source is preserved; a new final predecessor receipt follows.
"""
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main():
    source = (ROOT/'.build/levels_039/SEAL_VERIFIER_HEADER_DECISION_001.py').read_text()
    assert hashlib.sha256(source.encode()).hexdigest() == '8cd866a34a7c5344e9c4a9df152466b06ba5c7e68806224dfe1f75023a20a544'
    assert source.count("CONTROL = '.build/jobs/keygen_public_input_checks_039_004'") == 1
    source = source.replace("CONTROL = '.build/jobs/keygen_public_input_checks_039_004'",
        "CONTROL = '.build/jobs/keygen_public_input_checks_039_003'")
    start = source.index("    headers = read(control_dir/'PUBLIC_INPUT_HEADERS.json')\n")
    end = source.index("    for variant in controls['variants']:\n",start)
    source = source[:start]+"    artifacts = [pin(control_dir/'PUBLIC_INPUT_FIXTURE.json')]\n"+source[end:]
    line = "            'actual_include_binding':pin(control_dir/'PUBLIC_INPUT_HEADERS.json'),'header_differences':controls['header_differences'],\n"
    assert source.count(line) == 1
    source = source.replace(line,'')
    expected = json.loads((ROOT/'.build/levels_039/PRESEAL_PREDECESSOR.json').read_text())['verifier_sha256']
    assert hashlib.sha256(source.encode()).hexdigest() == expected, 'Old organizer bytes do not match the original preseal receipt'
    output = ROOT/'.build/levels_039/PRESEAL_VERIFIER_001.py'
    if output.exists():
        assert output.read_bytes() == source.encode(), 'Never replace retained organizer bytes'
    else:
        with output.open('x') as stream:
            stream.write(source)
    print(json.dumps({'path':str(output.relative_to(ROOT)),'sha256':expected,'bytes':output.stat().st_size},indent=2))


if __name__ == '__main__':
    main()
