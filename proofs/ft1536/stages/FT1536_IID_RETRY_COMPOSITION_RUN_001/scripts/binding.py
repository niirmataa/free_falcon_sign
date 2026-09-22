import json,re
from pathlib import Path
from replaylib import sha
W=Path.cwd();sign=(W/'source/falcon-sign.c').read_text().splitlines(True);rng=(W/'source/frng.c').read_text().splitlines(True);rows=[]
for name,src,lo,hi,lines in [('retry_region','falcon-sign.c',3327,3421,sign),('context','falcon-sign.c',1319,1331,sign),('prng_init','frng.c',281,324,rng),('target_fill','falcon-sign.c',1874,1879,sign),('target_compute','falcon-sign.c',1886,1892,sign)]:
 p=W/'checks'/(name+'.inc');p.write_text(''.join(lines[lo-1:hi]));rows.append(dict(copy=p.relative_to(W).as_posix(),source='source/'+src,first=lo,last=hi,sha256=sha(p),exact_bytes=True))
assert 'if (++ sign_loop_attempts > SIGN_MAX_ATTEMPTS)' in (W/'checks/retry_region.inc').read_text()
out=dict(status='PASS_EXACT_RETRY_INIT_TARGET_SLICES',source_pin=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),slices=rows,refill_projection=dict(source='source/frng.c',read_counter_line=214,loop_64_bytes_line=215,increment_line=264,write_counter_line=277,pointer_reset_line=338,loops=64,real_ChaCha_executed=False),scheduler_do_sign_is_scripted_stub=True,actual_codec_used=True,full_Sign_executed=False,source_changed=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS_RETRY_SOURCE_BINDING')
