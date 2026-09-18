"""Check the exact allowed production edit; derive separate test copies."""
import difflib, hashlib, json
from pathlib import Path
W=Path.cwd()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
helper='''/*
 * FT1536: canonical residue of every decoded int16_t coefficient.
 * x + 2*q is in [4098,69633], so the C remainder is nonnegative.
 */
static uint16_t
ft1536_normalize_s2(int16_t x)
{
\tint32_t t;

\tt = (int32_t)x + 36866;
\treturn (uint16_t)(t % 18433);
}

'''
old='''\tfor (u = 0; u < n; u ++) {
\t\tuint32_t w;

\t\t w = (uint32_t)s2[u];
\t\tw += q & -(w >> 31);
\t\tx[u] = (uint16_t)w;
\t}'''.replace('\t\t w','\t\tw')
new='''\tfor (u = 0; u < n; u ++) {
\t\tif (ternary == 1 && logn == 10) {
\t\t\tx[u] = ft1536_normalize_s2(s2[u]);
\t\t} else {
\t\t\tuint32_t w;

\t\t\tw = (uint32_t)s2[u];
\t\t\tw += q & -(w >> 31);
\t\t\tx[u] = (uint16_t)w;
\t\t}
\t}'''
anchor='/* see internal.h */\nint\nfalcon_vrfy_verify_raw('
a=(W/'reference/falcon-vrfy.c').read_text(); b=(W/'candidate/falcon-vrfy.c').read_text()
assert a.count(anchor)==a.count(old)==1
expected=a.replace(anchor,helper+anchor,1).replace(old,new,1)
assert b==expected,'candidate contains edits outside the permitted normalization/helper'
assert b.count('ft1536_normalize_s2(s2[u])')==1
sources={}
for line in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,n=line.split();assert sha(W/'reference'/n)==h
    ch=sha(W/'candidate'/n);sources[n]=ch
    if n!='falcon-vrfy.c':assert ch==h
with (W/'CANDIDATE.sha256').open('x') as f:
    f.write(''.join(h+'  '+n+'\n' for n,h in sources.items()))
with (W/'candidate.patch').open('x') as f:
    f.writelines(difflib.unified_diff(a.splitlines(True),b.splitlines(True),fromfile='reference/falcon-vrfy.c',tofile='candidate/falcon-vrfy.c'))

# Read-only instrumentation just before the real NTT entry. The original NTT
# definition and loader occur earlier; the wrapper copies then delegates.
injection='''/* TEST OBSERVER ONLY: not part of reference/ or candidate/. */
static uint16_t rho_observed_pre[3072];
static size_t rho_observed_n;
static unsigned rho_observed_calls;
static void
rho_observe_NTT(uint16_t *a, unsigned logn, int ternary)
{
    size_t count = MKN(logn, ternary);
    memcpy(rho_observed_pre, a, count * sizeof *a);
    rho_observed_n = count;
    rho_observed_calls ++;
    mq_NTT(a, logn, ternary);
}
#define mq_NTT rho_observe_NTT

'''
observed={}
for variant,text in [('reference',a),('candidate',b)]:
    d=W/'observed'/variant;d.mkdir(parents=True)
    instrumented=text.replace(anchor,injection+anchor,1)
    assert instrumented.replace(injection,'',1)==text
    (d/'falcon-vrfy.c').write_text(instrumented)
    (d/'observation.patch').write_text(''.join(difflib.unified_diff(text.splitlines(True),instrumented.splitlines(True),fromfile=variant+'/falcon-vrfy.c',tofile='observed/'+variant+'/falcon-vrfy.c')))
    observed[variant]=sha(d/'falcon-vrfy.c')
mutants={
 'old_map':'\tuint32_t w = (uint32_t)x;\n\tw += 18433u & -(w >> 31);\n\treturn (uint16_t)w;',
 'early_u16':'\tuint16_t t = (uint16_t)((int32_t)x + 36866);\n\treturn (uint16_t)(t % 18433);',
 'wrong_modulus':'\tint32_t t = (int32_t)x + 36866;\n\treturn (uint16_t)(t % 18432);',
 'negative_C_remainder':'\tint32_t t = (int32_t)x % 18433;\n\treturn (uint16_t)t;',
 'noop':'\tint32_t t = (int32_t)x + 36866 + 0;\n\treturn (uint16_t)(t % 18433);'
}
body='\tint32_t t;\n\n\tt = (int32_t)x + 36866;\n\treturn (uint16_t)(t % 18433);'
mh={}
for name,replacement in mutants.items():
    d=W/'mutants'/name;d.mkdir(parents=True)
    text=b.replace(body,replacement,1);assert text!=b
    (d/'falcon-vrfy.c').write_text(text);mh[name]=sha(d/'falcon-vrfy.c')
record=dict(reference_sha256=sha(W/'reference/falcon-vrfy.c'),candidate_sha256=sha(W/'candidate/falcon-vrfy.c'),
 candidate_manifest_sha256=sha(W/'CANDIDATE.sha256'),diff_sha256=sha(W/'candidate.patch'),
 helper_sha256=hashlib.sha256(helper.encode()).hexdigest(),helper=helper,
 exact_allowed_edit=True,other_files_identical=16,guard='ternary == 1 && logn == 10',
 signed_s2_argument_unchanged='return falcon_is_short((int16_t *)x, s2, logn, ternary);' in b,
 observer_injection=injection,observed_sources=observed,mutants=mh,
 formal_sha256=sha(W/'formal/Rho.lean'),formal_model='u16(t-(t/18433)*18433), t=x+36866, nonnegative t')
(W/'artifacts/source_binding.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({k:v for k,v in record.items() if k not in ['helper','observer_injection']},indent=2))
