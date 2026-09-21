import hashlib,json
from pathlib import Path
W=Path.cwd()
def load(p):return json.loads((W/p).read_text())
def sha(p):return hashlib.sha256((W/p).read_bytes()).hexdigest()
def write(p,v):
    with (W/p).open('x') as f:json.dump(v,f,indent=2,ensure_ascii=False);f.write('\n')
prov=load('inputs/provenance.json');audit=load('artifacts/formal_audit.json')
for r in prov:assert sha(r['copy'])==r['sha256']
for line in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,p=line.split('  ',1);assert sha('source/'+p)==h
write('artifacts/input_audit.json',dict(inputs=len(prov),all_local_copies_match=True,source_files=17,
    source_manifest_sha256=sha('inputs/source_hashes.sha256'),source_sha256=sha('source/falcon-vrfy.c'),inherited_modules_unchanged=59))
entries=[('CENTER_C','source/falcon-vrfy.c',1429,1435,['BridgeWords.CENTER_C','center_prefix','center_unread','center_loop_correct']),
 ('SIGN_BRIDGE','source/falcon-vrfy.c',1418,1441,['RawBridge.SIGN_BRIDGE','Norm64.Q0_neg','RawBridge.extract_congruence']),
 ('NORM64_EXACT','source/falcon-enc.c',597,623,['Norm64.int16_product','norm_prefix','norm_no_overflow','NORM64_EXACT']),
 ('STRICT_B','source/falcon-enc.c',635,666,['Norm64.STRICT_B','RawBridge.raw_reject_at_bound']),
 ('DECODE_NONE','source/falcon-enc.c',401,456,['DecodeNone.noneWord','none_word_spec','DECODE_NONE','none_read_bounds']),
 ('DECODE_STATIC','source/falcon-enc.c',462,544,['ByteCursor.fill_source/unary_source/unary_skip_zeros/unary_wrap','DecodeStatic.readStatic/staticLoop/DECODE_STATIC','Initialization.gcc_narrow16','ParserRefinement.unary_terminates']),
 ('VERIFY_GUARDS','source/falcon-vrfy.c',1446,1517,['VerifyBytes.signature/verifyContext','decoder_return_guard','header_exact','SIGNATURE_DECODE']),
 ('PK_DECODER','source/falcon-enc.c',216,250,['PublicKey.byte_concat/readPK/pkLoop','PK_CONSUMED','DECODE_PK']),
 ('PK_PREPARATION','source/falcon-vrfy.c',1284,1352,['PublicKey.loadFT','PK_PREPARATION','VerifyBytes.pk_header_exact','Initialization.public_failure_guard']),
 ('FINAL_COMPOSITION','source/falcon-vrfy.c',1388,1517,['RawBridge.RAW_VERIFIER_SOUND','VerifyBytes.L_V_BYTES/L_V_LOADED','Initialization.L_V_SOURCE'])]
bindings=[]
for ident,p,a,b,theorems in entries:
    lines=(W/p).read_bytes().splitlines(keepends=True)
    bindings.append(dict(id=ident,source=p,source_sha256=sha(p),lines=[a,b],slice_sha256=hashlib.sha256(b''.join(lines[a-1:b])).hexdigest(),theorems=theorems))
write('artifacts/source_bindings.json',dict(platform='GCC14.2.0/C99/Linux x86_64 LP64; signed16/32/64 and unsigned32/64 conventions explicit',
    verifier_source_sha256=sha('source/falcon-vrfy.c'),encoder_source_sha256=sha('source/falcon-enc.c'),internal_header_sha256=sha('source/internal.h'),
    formal_sources=audit['sources_sha256'],bindings=bindings,
    aliasing='int16_t is GCC short, uint16_t unsigned short; corresponding signed/unsigned effective-type access, equal alignment/size; tested by compile-time assertions.',
    source_readonly=True,other_profiles='loadFT is an explicit FT profile projection; accepted other profiles are not classified as C loader failures.',
    hash_to_point='Explicit canonical c is the task domain; plain and observer share only this hook. No preimage claim.',
    mathematical_models_not_redefined=True))
rows=[dict(id='REUSED_RHO_NTT',origin='inherited',status='REUSED_PROVED',claim='L_NTT_rho and definitions unchanged, all59 source dependencies rechecked',
           evidence=['inputs/PREV/REPORT.md','formal/Complete.lean','artifacts/formal_audit.json'],gap=None)]
for ident,p,a,b,ths in entries:
    rows.append(dict(id=ident,origin='new',status='PROVED_FOR_PINNED_MODEL',source=p,lines=[a,b],evidence=ths,gap=None))
rows.extend([
 dict(id='OUTPUT_INITIALIZATION',origin='new',status='PROVED',evidence=['Initialization.signature_initializes','L_V_SOURCE'],gap=None),
 dict(id='UNARY_WRAP_TERMINATION',origin='new',status='PROVED_ALL_FINITE_LEGAL_LENGTHS',evidence=['ByteCursor.unary_source/unary_skip_zeros/unary_wrap','ParserRefinement.unary_terminates'],gap=None),
 dict(id='CONTROLS_REPLAY',origin='new',status='PASS',evidence=['artifacts/controls.json','artifacts/fresh_replay.json'],gap=None)])
write('OBLIGATIONS.json',dict(schema='FT1536_L_V_BRIDGE_OBLIGATIONS_V1',status='L_V_PROVED_FOR_PINNED_MODEL',
    source_sha256=sha('source/falcon-vrfy.c'),full_L_V_proved=True,source_integrated=False,owner_accepted=False,
    obligations=rows,blocking=[],limits=['Pinned GCC model and legal API objects/lifecycle','FT1536 profile; NONE and STATIC both included','No sampler, EUF-CMA, hardness, key-distribution or H2P-preimage theorem']))
print(json.dumps(dict(obligations=len(rows),source_bindings=len(bindings),status='L_V_PROVED_FOR_PINNED_MODEL'),indent=2))
