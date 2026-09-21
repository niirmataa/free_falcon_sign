"""Historical baseline and floor candidate pins, independent of default-build changes."""
FLOOR_STAGE = 'proofs/ft1536/stages/FT1536_FPEMU_FLOOR_CT_RUN_001'
PROFILES = {
    'baseline': {
        'manifest': FLOOR_STAGE + '/inputs/bootstrap/CANDIDATE.sha256',
        'source': FLOOR_STAGE + '/baseline/source',
        'sha256': '2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a',
        'floor_branch_expected': True,
        'unit': 'ft1536-dudect-run-001.service',
    },
    'floor-ct': {
        'manifest': FLOOR_STAGE + '/candidate/CANDIDATE.sha256',
        'source': FLOOR_STAGE + '/candidate/source',
        'sha256': '56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985',
        'floor_branch_expected': False,
        'unit': 'ft1536-dudect-run-002.service',
        'report_sha256': '4002cff773e58828eee13232fbd3fe3acdbe8ac224572527cd69ace1e021f707',
    },
}


def floor_assembly_ok(text, profile):
    import re
    operations = re.findall(r'^\s*[0-9a-f]+:\s+(?:[0-9a-f]{2}\s+)+([a-z][a-z0-9]*)\b', text, re.M)
    if not operations:
        return False
    if profile['floor_branch_expected']:
        return 'js' in operations
    return not any(op.startswith(('j', 'call', 'loop', 'div', 'idiv')) for op in operations)
