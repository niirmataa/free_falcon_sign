import json
from pathlib import Path
from kernel_model import Buffer,schedule
from replaylib import sha
W=Path.cwd();D=W/'artifacts/fixtures';rows=[];stats=[]
for k in range(4):
 x=json.loads((W/'artifacts'/('fixtures_'+str(k)+'.json')).read_text());rows+=x['cases'];stats.append(x['stats'])
def gf(e):return f"G {e['n']} {e['old'][0]} {e['old'][1]} {e['read'][0]} {e['read'][1]} {e['after'][0]} {e['after'][1]} {e['discard']} {e['value']:016x}\n"
blocks=[bytes((j*101+i*29+(i>>4))%256 for i in range(4096)) for j in range(2)];out=[];schedules=[]
for p in range(4096):
 b=Buffer(blocks,p);b.proposal();out.append(f'CASE {p}\n'+''.join(gf(e) for e in b.events)+f'END {b.ptr} {b.block} {b.dropped} {b.returned}\n');s=schedule(p);assert p+33+s['discarded']==4096*s['refills']+s['end'] and 0<=s['discarded']<=9*s['refills'] and s['refills']<=1;schedules.append({k:v for k,v in s.items() if k!='events'})
b=Buffer(blocks,4095);b.get(1);out.append('U8_LAST\n'+gf(b.events[0]));(D/'getters.input').write_text('');(D/'getters.expected').write_text(''.join(out));rows.append(dict(name='getters',exe='kernel',mode='getters',input='artifacts/fixtures/getters.input',input_sha256=sha(D/'getters.input'),expected='artifacts/fixtures/getters.expected',expected_sha256=sha(D/'getters.expected'),preflight=True,classification='ALL_4096_LEGAL_START_PTRS_AND_FINAL_U8_BYTE'))
a=json.loads((W/'artifacts/controls/root_boundary_trace.json').read_text());b=json.loads((W/'artifacts/controls/root_extra_rejections_trace.json').read_text())
project=lambda x:[{k:r[k] for k in ['index','mu','sigma','bank','sample']} for r in x['calls_data']]
assert project(a)==project(b) and a['proposals']!=b['proposals'] and a['products']==b['products']
for stem in ['suffix','codec']:assert json.loads((W/f'artifacts/controls/root_boundary_{stem}.json').read_text())==json.loads((W/f'artifacts/controls/root_extra_rejections_{stem}.json').read_text())
order=json.loads((W/'SOURCE_ORDER.json').read_text())['positions'];assert len(order)==len(a['calls_data'])
(W/'artifacts/projection_control.json').write_text(json.dumps(dict(status='PASS_VALUE_CALLER_FRAME_INDEPENDENT_OF_REJECTIONS_AND_PTR',calls=3072,proposals=[a['proposals'],b['proposals']],ptr=[a['start_ptr'],b['start_ptr']],identical_value_centers_widths_banks_returns_products_POST_bytes=True,classification='synthetic original-C-bound source tapes; no Emitted membership; control of universal source frame argument'),indent=2)+'\n')
(W/'artifacts/byte_schedule.json').write_text(json.dumps(schedules,separators=(',',':'))+'\n')
(W/'artifacts/fixtures.json').write_text(json.dumps(dict(status='PASS_FULL_DOMAIN_PREFLIGHT_AND_EXPECTED_TRACES',cases=rows,root_and_terminal=stats,native_batches=len(rows),total_scalar_calls=sum(x['calls'] for x in stats),total_proposals=sum(x['proposals'] for x in stats),cutoff_rejections=sum(x['cutoff_rejections'] for x in stats),getter_starts=4096),indent=2)+'\n');print('FIXTURES',len(rows),'CALLS',sum(x['calls'] for x in stats),'PROPOSALS',sum(x['proposals'] for x in stats))
