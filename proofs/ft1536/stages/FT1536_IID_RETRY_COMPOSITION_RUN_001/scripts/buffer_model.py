"""Deterministic state projection and ideal block labels; source getters unchanged."""
def proposal_schedule(T,ptr=0):
 R=D=0
 for _ in range(T):
  for n in [8,8,1,8,8]:
   if n==8 and ptr>=4087:D+=4096-ptr;R+=1;ptr=0
   ptr+=n
   if n==1 and ptr==4096:R+=1;ptr=0
 return dict(ptr=ptr,additional_refills=R,getter_drops=D,returned=33*T)
def reset_region(counts,counters=None):
 if counters is None:counters=[0]*len(counts)
 rows=[];block_id=0;abandon=0
 for j,(T,counter) in enumerate(zip(counts,counters),1):
  old_tail=0 if j==1 else 4096-rows[-1]['ptr'];abandon+=old_tail
  init_id=block_id;block_id+=1;s=proposal_schedule(T);ids=list(range(init_id,block_id+s['additional_refills']));block_id+=s['additional_refills']
  assert 33*T+s['getter_drops']==4096*s['additional_refills']+s['ptr']
  rows.append(dict(attempt=j,T=T,initial_block_id=init_id,block_ids=ids,abandoned_old_tail=old_tail,source_SHAKE_request_bytes=56,state_counter_before=counter,state_counter_after=(counter+64*(1+s['additional_refills']))%2**64,**s))
 unused=4096-rows[-1]['ptr'];returned=sum(r['returned'] for r in rows);drops=sum(r['getter_drops'] for r in rows)
 assert 4096*block_id==returned+drops+abandon+unused
 return dict(rows=rows,initial_blocks=len(rows),total_blocks=block_id,returned=returned,getter_drops=drops,abandoned_at_reinit=abandon,final_unused=unused,SHAKE56_bytes=56*len(rows))
