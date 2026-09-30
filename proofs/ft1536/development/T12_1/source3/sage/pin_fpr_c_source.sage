# Literal M0 source transport. No arithmetic claim: Lean must parse/execute it.
from pathlib import Path
import sys, json, hashlib
assert parent(1) is ZZ and parent(1/3) is QQ
base=Path(sys.argv[1]).resolve()
expected={'fpr-emulated.c':'7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f',
          'fpr-emulated.h':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa',
          'Makefile':'25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049'}
data={}
for name,h in expected.items():
    raw=(base/name).read_bytes()
    assert hashlib.sha256(raw).hexdigest()==h
    lines=raw.decode('utf-8').splitlines(keepends=True)
    assert ''.join(lines).encode('utf-8')==raw
    data[name]=lines
src=data['fpr-emulated.c']
assert len(src)==1259
for start,end,name in [(449,554,'fpr_add'),(681,774,'fpr_mul'),(916,1000,'fpr_div')]:
    assert src[start-1].startswith(name+'(')
    assert src[end-1].strip()=='}'
assert src[7]=='#ifndef FALCON_ASM_CORTEXM4\n'
assert src[8]=='#define FALCON_ASM_CORTEXM4 0\n'
assert not any('DFALCON_ASM_CORTEXM4' in line for line in data['Makefile'])
assert src[445].startswith('#else') and src[677].startswith('#else') and src[912].startswith('#else')
assert src[555].startswith('#endif') and src[775].startswith('#endif') and src[1001].startswith('#endif')
code='set_option maxRecDepth 32768\nnamespace FT1536.Source3.FprPinned\n'
code+='def cLines : List String := [\n'+',\n'.join(json.dumps(s,ensure_ascii=False) for s in src)+'\n]\n'
code+='end FT1536.Source3.FprPinned\n'
Path('generated').mkdir()
Path('generated/FprCSource.lean').write_text(code)
result={'source_pins':expected,'c_lines':len(src),'generated_sha256':hashlib.sha256(code.encode()).hexdigest(),
        'active_fpr_add':[int(449),int(554)],'active_fpr_mul':[int(681),int(774)],'active_fpr_div':[int(916),int(1000)],
        'preprocessor':'M0 FALCON_ASM_CORTEXM4=0','mode':'sage preparser; ZZ/QQ'}
Path('FPR_C_SOURCE_TRANSPORT.json').write_text(json.dumps(result,sort_keys=True,indent=int(2))+'\n')
print('FPR_C_SOURCE_TRANSPORT_PASS',json.dumps(result,sort_keys=True))
