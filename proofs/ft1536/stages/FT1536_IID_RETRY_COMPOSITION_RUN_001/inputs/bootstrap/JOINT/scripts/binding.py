import difflib,json,subprocess,sys
from pathlib import Path
from replaylib import sha
W=Path.cwd();D=W/'checks';rows={}
for name in ['scalar','post']:
 subprocess.run([sys.executable,'-B','scripts/'+name+'_binding.py'],check=True,timeout=30)
 p=W/'artifacts/source_binding.json';dst=W/'artifacts'/(name+'_binding.json');dst.write_bytes(p.read_bytes());rows[name]=sha(dst)
sign=(W/'source/falcon-sign.c').read_text().splitlines(True);(D/'sampling.inc').write_text(''.join(sign[1615:1839]));(D/'prerequisites.inc').write_text(sign[147]+sign[1318])
original=(D/'ordered_template.c').read_text();text=original.replace('#include "prerequisites.inc"','#include "prerequisites.inc"\n#include "joint_scalar.inc"')
text=text.replace('static struct {char tag;int k,b;unsigned stutters;} tape[3072];','')
a=text.index('static int scripted(');b=text.index('\nint main(',a)
text=text[:a]+'''static int scripted(void *ctx,fpr mu,fpr sigma){
 if(ctx!=&fault||call_index>=3072)abort();
 unsigned i=call_index++;printf("C %u %016" PRIx64 " %016" PRIx64 " %u\\n",i,mu,sigma,fault);
 pre_floor++;if(!numeric(mu))abort();
 int z=checked_scalar(mu,sigma);fault=sc.fault;
 printf("R %u N %d\\n",i,z);return z;
}'''+text[b:]
old='for(unsigned i=0;i<3072;i++)if(scanf(" %c %d %d %u",&tape[i].tag,&tape[i].k,&tape[i].b,&tape[i].stutters)!=4)return 5;'
assert old in text
text=text.replace(old,'''size_t ptr;unsigned byte;
  assert(scanf("%zu %zu",&ptr,&block_count)==2 && ptr<4096 && block_count>0 && block_count<=128);
  for(size_t j=0;j<block_count;j++)for(size_t i=0;i<4096;i++){assert(scanf("%2x",&byte)==1);public_blocks[j][i]=(unsigned char)byte;}
  memset(&sc,0x5a,sizeof sc);sc.p.ptr=ptr;sc.p.type=PRNG_CHACHA20;sc.fault=0;memcpy(sc.p.buf.d,public_blocks[0],4096);''')
text=text.replace('printf("END %s', 'printf("RESOURCE %zu %zu %zu %zu\\n",sc.p.ptr,refills,drops,returned);\n  printf("END %s')
assert text.count('checked_scalar(mu,sigma)')==1 and 'KeyGen' not in text
(D/'joint.c').write_text(text);(W/'artifacts/diffs/joint_driver.patch').write_text(''.join(difflib.unified_diff(original.splitlines(True),text.splitlines(True),fromfile='inputs/bootstrap/ORDERED/checks/ordered.c',tofile='checks/joint.c')))
out=dict(status='PASS_LITERAL_RECURSION_SCALAR_AND_POST_SLICES',sampling_sha256=sha(D/'sampling.inc'),sampling_source_lines=[1616,1839],scalar_post_bindings=rows,joint_driver_sha256=sha(D/'joint.c'),support_sha256=sha(D/'joint_scalar.inc'),source_pin=sha(W/'inputs/bootstrap/CANDIDATE.sha256'),native_scope='original recursive sampling + original sampler vs observer at every callback + original getters with public test refill; separate original POST slices',no_real_PRNG_or_full_Sign=True,source_changed=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print('PASS_JOINT_SOURCE_BINDING')
