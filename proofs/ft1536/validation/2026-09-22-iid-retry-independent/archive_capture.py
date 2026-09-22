"""Archive the owner's independent review; perform byte binding, not a new proof/replay."""
import json
from pathlib import Path
import subprocess
import sys

REPO = Path('/home/footfalcon/free_falcon_sign')
ROOT = REPO / 'proofs/ft1536'
sys.path.insert(0, str(ROOT / 'tools'))
import archive

STAGE = 'FT1536_IID_RETRY_COMPOSITION_RUN_001'
REVIEW = 'FT1536_IID_RETRY_INDEPENDENT_REVIEW_001'
BASE = ROOT / 'stages' / STAGE
SOURCE = ROOT / 'work' / STAGE
REVIEW_W = ROOT / 'work' / REVIEW
CHILD = REVIEW_W / 'seed/tmp/independent_001'
TARGET = ROOT / 'validation/2026-09-22-iid-retry-independent'
PINS = {
    'report': 'b7164dbbee02db248ea43adce1d63ae0a38ed4493a566c5acd3a2f507db14590',
    'outputs': '3d68249f4f0e017f32eb7edeb0d90f5c4a6cd6b4b9f93307cec6919439525074',
    'review': '8523b1ea63faabdf2d78c602ccf1a5f7aaceba9c71ecc3ee6032c1add02344ec',
    'review_outputs': '5072eacae41c4eedf6184484385076a5447b538a2f646166e3dc5d872a7ca318',
}
parent = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO).decode().strip()
archive.require(parent.startswith('4488293'), 'Unexpected parent')
stage_result = archive.verify_stage(ROOT, STAGE)
archive.require(stage_result['manifest_sha256'] == PINS['outputs'], 'Stage pin')
members = archive.manifest(archive.checked_bytes(SOURCE / 'OUTPUTS.sha256', PINS['outputs']))
archive.checked_bytes(SOURCE / 'REPORT.md', PINS['report'])
for path, pin in members.items():
    archive.checked_bytes(SOURCE / path, pin)

review_manifest = archive.checked_bytes(REVIEW_W / 'REVIEW_OUTPUTS.sha256', PINS['review_outputs'])
review_members = archive.manifest(review_manifest)
archive.require(len(review_members) == 12 and review_members['REVIEW.md'] == PINS['review'], 'Review scope/pin')
for path, pin in review_members.items():
    archive.checked_bytes(REVIEW_W / path, pin)
review_result = json.loads(archive.read(REVIEW_W / 'REVIEW_RESULT.json'))
archive.require(review_result['source_task'] == STAGE and review_result['review_id'] == REVIEW
                and review_result['verdict'] == 'PASS_SCOPED_REVIEW'
                and not review_result['owner_accepted'], 'Received verdict')
replay_pin = review_members['logs/independent_REPLAY_RESULT.json']
replay = json.loads(archive.checked_bytes(CHILD / 'REPLAY_RESULT.json', replay_pin))
archive.require(replay['status'] == 'FRESH_REPLAY_PASS' and replay['game'] == 'G_retry_IID'
                and replay['external_manifest_sha256'] == PINS['outputs']
                and replay['controller_exit_code'] == 0 and replay['matched'] == 492
                and replay['destination'] == str(CHILD), 'Received replay identity')
for flag in ('fresh_project_cache', 'original_trees_hidden', 'only_destination_written',
             'source_inputs_readonly', 'network_off'):
    archive.require(replay[flag] is True, 'Received replay flag: ' + flag)
semantic = json.loads(archive.read(BASE / 'SEMANTIC_FILES.json'))
archive.require(archive.check_replay_result(BASE, CHILD, semantic, replay) == 492, 'Semantic byte binding')
archive.checked_bytes(CHILD / 'SEMANTIC_FILES.json', members['SEMANTIC_FILES.json'])

paths = {}
for path in review_members:
    paths['review/' + path] = REVIEW_W / path
paths['review/REVIEW_OUTPUTS.sha256'] = REVIEW_W / 'REVIEW_OUTPUTS.sha256'
for path in archive.semantic_rows(replay):
    paths['replay/' + path] = CHILD / path
for folder in ('logs', 'artifacts'):
    for path in archive.regular_files(CHILD / folder):
        # Auxiliary file-name inventory, not a semantic result or review-sealed receipt.
        # Keep it in REVIEW_W; archive policy excludes names containing "seed".
        if folder == 'artifacts' and path == 'replay_seed.json':
            continue
        paths['replay/' + folder + '/' + path] = CHILD / folder / path
for path in ('REPLAY_RESULT.json', 'SEMANTIC_FILES.json', 'COMMANDS.log'):
    paths['replay/' + path] = CHILD / path

# These hashes bind the copied streams to the already executed review's receipts.
commands = [json.loads(line) for line in archive.read(CHILD / 'COMMANDS.log').decode().splitlines()]
for command in commands:
    archive.require(command['exit_code'] == 0 and not command['timeout'], 'Recorded command failed')
    for stream in ('stdout', 'stderr'):
        archive.checked_bytes(CHILD / command[stream], command['stream_sha256'][stream])
kernel = json.loads(archive.read(CHILD / 'artifacts/final_kernel_receipts.json'))
for command in kernel:
    archive.require(command['exit_code'] == 0 and not command['timeout'], 'Recorded kernel command failed')
    for stream in ('stdout', 'stderr'):
        archive.checked_bytes(CHILD / command[stream], command[stream + '_sha256'])
    archive.checked_bytes(CHILD / 'formal' / (command['module'] + '.lean'), command['source_sha256'])

# Resolve changed live-document provenance through sealed copies, as the importer does.
inputs = archive.manifest(archive.read(BASE / 'INPUTS.sha256'), absolute=True)
by_hash = {}
for path, pin in members.items():
    by_hash.setdefault(pin, path)
stale = []
for name in (str(REPO / 'AGENTS.md'), str(ROOT / 'CURRENT_TASK.md')):
    pin = inputs[name]
    sealed_path = by_hash[pin]
    archive.checked_bytes(BASE / sealed_path, pin)
    archive.checked_bytes(ROOT / 'objects' / pin, pin)
    stale.append(dict(original=name, input_sha256=pin, sealed_path=sealed_path,
                      live_sha256_at_archive=archive.digest(archive.read(Path(name))),
                      resolution='UNCHANGED_SEALED_COPY_AND_CONTENT_ADDRESSED_OBJECT'))

files = {}
for path, source in sorted(paths.items()):
    data = archive.checked_bytes(source)
    archive.put_once(TARGET / path, data)
    files[path] = archive.digest(data)
paths_report = dict(
    schema='FT1536_EXTERNAL_REVIEW_ARCHIVE_V1',
    status='PASS_ADMINISTRATIVE_ARCHIVE_BINDING',
    roadmap_id='T01', stage=STAGE, review_id=REVIEW, parent_commit=parent,
    received_verdict=review_result['verdict'], received_scope=review_result['scope'],
    reviewer='Independent model selected by the owner; exact model ID not supplied in the report',
    reviewer_model_id=None, owner_accepted=False, pins=PINS,
    source_output_entries=len(members), input_entries=len(inputs),
    independent_replay_receipt_sha256=replay_pin,
    received_replay_elapsed_seconds=replay['elapsed_seconds'], semantic_files_byte_bound=492,
    received_kernel_receipts=len(kernel), received_recipe_commands=len(commands),
    retained_replay_logs=len(archive.regular_files(CHILD / 'logs')),
    retained_replay_artifacts=len(archive.regular_files(CHILD / 'artifacts')) - 1,
    auxiliary_inventory_left_in_review_work='artifacts/replay_seed.json (archive filename policy)',
    maintainer_executed_replay=False, maintainer_performed_mathematical_review=False,
    maintainer_actions='External-pin verification, immutable import, receipt/byte binding and Git checkpoint only',
    live_input_provenance=stale,
    publication='BLOCKED_BY_OWNER_FAMILY_REVIEW_CONDITION', source_changed=False,
)
data = archive.json_bytes(paths_report)
archive.put_once(TARGET / 'ARCHIVE_RECEIPT.json', data)
files['ARCHIVE_RECEIPT.json'] = archive.digest(data)
data = archive.read(Path(__file__))
archive.put_once(TARGET / 'archive_capture.py', data)
files['archive_capture.py'] = archive.digest(data)
manifest = ''.join(pin + '  ' + path + '\n' for path, pin in sorted(files.items())).encode()
archive.put_once(TARGET / 'VALIDATION.sha256', manifest)
archive.require(archive.regular_files(TARGET) <= set(files) | {'README.md', 'VALIDATION.sha256'}, 'Unexpected validation file')
print(json.dumps(dict(status=paths_report['status'], received_verdict=review_result['verdict'],
    files=len(files), bytes=sum((TARGET / path).stat().st_size for path in files),
    validation_sha256=archive.digest(manifest), replay_rerun=False, live_input_provenance=stale), indent=2))
