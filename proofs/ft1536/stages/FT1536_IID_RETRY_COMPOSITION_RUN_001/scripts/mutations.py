"""Scripted-source and exact-model mutations; no synthetic Emitted claim."""
import difflib,json,shlex,subprocess
from fractions import Fraction as Q
from pathlib import Path
from replaylib import sha
W=Path.cwd();D=W/'artifacts/mutations';D.mkdir(exist_ok=True);C=W/'checks/mutations';C.mkdir(exist_ok=True)
driver=(W/'checks/retry.c').read_text();region=(W/'checks/retry_region.inc').read_text();cases={c['name']:c for c in json.loads((W/'artifacts/fixtures.json').read_text())['cases']}
flags=shlex.split(next(s.split('=',1)[1].strip() for s in (W/'source/Makefile').read_text().splitlines() if s.startswith('CFLAGS =')))
rows=[];runtime=[]
def replace(s,a,b):assert s.count(a)==1,(a,s.count(a));return s.replace(a,b)
def native(name,case,ds=driver,rs=region,noop=False,reset=False):
 d=C/name;d.mkdir(exist_ok=True);ds=ds.replace('../source/','../../../source/');(d/'retry.c').write_text(ds)
 for n in ['context','prng_init','target_fill','target_compute']:(d/(n+'.inc')).write_bytes((W/'checks'/(n+'.inc')).read_bytes())
 (d/'retry_region.inc').write_text(rs)
 if reset:(d/'reset.c').write_bytes((W/'checks/reset.c').read_bytes())
 diff=''.join(difflib.unified_diff(driver.splitlines(True),ds.splitlines(True),fromfile='checks/retry.c',tofile='checks/mutations/'+name+'/retry.c'))+''.join(difflib.unified_diff(region.splitlines(True),rs.splitlines(True),fromfile='checks/retry_region.inc',tofile='checks/mutations/'+name+'/retry_region.inc'))
 (D/(name+'.patch')).write_text(diff)
 rel=d.relative_to(W).as_posix();cmd=['gcc','-std=c99']+flags+['-Isource',rel+('/reset.c' if reset else '/retry.c'),'source/fpr-emulated.c','-lm','-o','bin/mutation-'+name]
 p=subprocess.run(cmd,capture_output=True,timeout=60)
 for stream,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/('mutation_build_'+name+'.'+stream)).write_bytes(b)
 assert p.returncode==0 and not p.stderr,(name,p.stderr.decode())
 inp=b'' if reset else (W/cases[case]['input']).read_bytes();expected=(W/'artifacts/reset.expected').read_bytes() if reset else (W/cases[case]['expected']).read_bytes()
 p=subprocess.run(['bin/mutation-'+name],input=inp,capture_output=True,timeout=60)
 for stream,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/('mutation_'+name+'.'+stream)).write_bytes(b)
 same=p.returncode==0 and p.stdout==expected and not p.stderr
 assert same==noop,(name,p.returncode)
 row=dict(name=name,kind='native_original_loop_scripted_callbacks',case=case,classification='NO_OP_EQUIVALENT_ON_CONTROL' if noop else 'KILLED',exit_code=p.returncode,stdout_sha256=sha(W/'logs'/('mutation_'+name+'.stdout')),expected_sha256=sha(W/'artifacts/reset.expected') if reset else cases[case]['expected_sha256'],patch_sha256=sha(D/(name+'.patch')),source_changed=False,Emitted_membership=False)
 # Assertion stderr embeds cwd-dependent executable name; keep it as evidence,
 # not as a reproducibility claim. Source delta and semantic outcome are pinned.
 runtime.append(dict(name=name,argv=cmd,stderr_sha256=sha(W/'logs'/('mutation_'+name+'.stderr'))));rows.append(row)
native('noop','last_accept_source',noop=True)
native('allow_seventeenth','sixteen_reject_source',rs=replace(region,'> SIGN_MAX_ATTEMPTS)', '> SIGN_MAX_ATTEMPTS + 1)'))
native('reject_sixteenth','last_accept_source',rs=replace(region,'> SIGN_MAX_ATTEMPTS)', '>= SIGN_MAX_ATTEMPTS)'))
poison=replace(region,'ternary_sampler_context tsc;','ternary_sampler_context tsc;\n\t\ttsc.fault = FT_SAMPLER_FAULT_NONFINITE_MU;')
# Use the actual enum member from context.inc rather than inventing a fault.
enum_text=(W/'checks/context.inc').read_text();fault_name=next(s.strip().split('=')[0].strip().rstrip(',') for s in enum_text.splitlines() if 'FT_SAMPLER_FAULT_' in s and 'NONE' not in s)
poison=poison.replace('FT_SAMPLER_FAULT_NONFINITE_MU',fault_name)
native('noop_poison_then_reset','first_accept_source',rs=poison,noop=True)
native('missing_fault_reset','first_accept_source',rs=replace(poison,'tsc.fault = FT_SAMPLER_FAULT_NONE;','/* omitted fault reset */'))
native('stale_target_scratch','first_accept_source',ds=replace(driver,'prepare_targets(tmp,sk,hm,logn,q);','/* incorrectly reuse scratch */'))
retry_codec=replace(region,'\tfor (;;) {','\tgoto retry_again;\nretry_again:\n\tfor (;;) {')
retry_codec=replace(retry_codec,'\t\treturn 0;\n\t}\n\tsig_buf[0]', '\t\tgoto retry_again;\n\t}\n\tsig_buf[0]')
native('codec_failure_retries','codec_capacity_failure_source',rs=retry_codec)
native('reuse_buffer_after_reset','reset_boundaries',ds=replace(driver,'size_t id=blocks++;','size_t id=0;blocks++;'),reset=True)
pc=json.loads((W/'artifacts/probability_controls.json').read_text())
def model(name,witness):rows.append(dict(name=name,kind='exact_control_model',classification='KILLED',witness=witness,Emitted_membership=False))
x=pc['independent_marginal_countermodel'];assert Q(x['actual_union'])>Q(x['wrong_product_formula']);model('independent_marginal_composition',x)
x=pc['success_countermodel'];assert Q(x['Bad_conditioned_on_positive'])>Q(x['uniform_union']);model('conditioning_on_success',dict(actual_conditional=x['Bad_conditioned_on_positive'],incorrect_bound=x['uniform_union']))
x=json.loads((W/cases['bad_then_accept_source']['model']).read_text());assert x['WholeRegionBad'];model('omit_bad_rejected_attempt',dict(actual_WholeRegionBad=True,accepted_kind=4,accepted_bad=False,wrong_accepted_only_event=False))
from buffer_model import reset_region
x=reset_region([3072,3072]);assert x['total_blocks']*4096==x['returned']+x['getter_drops']+x['abandoned_at_reinit']+x['final_unused']
assert (x['total_blocks']-2)*4096<x['returned']+x['getter_drops']+x['abandoned_at_reinit']+x['final_unused'];model('missing_initial_blocks',x)
assert x['abandoned_at_reinit']>0 and x['total_blocks']*4096!=x['returned']+x['getter_drops']+x['final_unused'];model('carry_conservation_across_resets',x)
out=dict(status='PASS_MEANINGFUL_MUTATIONS_AND_NOOPS',rows=rows,meaningful=sum(r['classification']=='KILLED' for r in rows),noops=sum(r['classification']=='NO_OP_EQUIVALENT_ON_CONTROL' for r in rows),uniform_conditional_hazard_formula='sound with conditional bound, not killed; independence of retry outcomes never assumed',membership='public scripted controls or finite toy probability, not required-domain C counterexamples')
(W/'artifacts/mutation_commands.json').write_text(json.dumps(runtime,indent=2)+'\n');(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS_MUTATIONS',out['meaningful'],'NOOPS',out['noops'])
