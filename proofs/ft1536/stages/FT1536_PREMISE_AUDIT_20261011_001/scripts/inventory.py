"""Source inventory, not a mathematical decision procedure."""
from pathlib import Path
import re, json, hashlib, collections
W=Path(__file__).resolve().parents[1]

def strip_comments(s):
    out=[]; i=0; depth=0; string=False
    while i<len(s):
        if depth:
            if s[i:i+2]=='/-': depth+=1;out.extend('  ');i+=2
            elif s[i:i+2]=='-/':depth-=1;out.extend('  ');i+=2
            else:out.append('\n' if s[i]=='\n' else ' ');i+=1
        elif string:
            out.append(s[i])
            if s[i]=='\\' and i+1<len(s):out.append(s[i+1]);i+=2;continue
            if s[i]=='"':string=False
            i+=1
        elif s[i:i+2]=='/-':depth=1;out.extend('  ');i+=2
        elif s[i:i+2]=='--':
            j=s.find('\n',i);j=len(s) if j<0 else j
            out.extend(' '*(j-i));i=j
        else:
            if s[i]=='"':string=True
            out.append(s[i]);i+=1
    return ''.join(out)

def main():
    rows=[]; files=[]
    for lane in ['source3','run2']:
        base=W/'snapshot/proofs/ft1536/development/T12_1'/lane/'formal'
        for p in sorted(base.rglob('*.lean')):
            raw=p.read_text();s=strip_comments(raw);stack=[];ns=''; starts=[]
            for mat in re.finditer(r'(?m)^(namespace\s+([^\s]+)|section(?:\s+([^\s]+))?|mutual|end(?:\s+([^\s]+))?|(?:(?:private|protected|noncomputable|unsafe|partial)\s+)*(def|abbrev|structure|class|inductive|theorem|lemma|axiom|opaque)\s+([^\s(:{\[]+))',s):
                text=mat.group(0)
                if text.startswith('namespace '):
                    stack.append(ns);ns=(ns+'.' if ns else '')+mat.group(2)
                elif text.startswith('section') or text=='mutual':stack.append(ns)
                elif text.startswith('end'):
                    if stack:ns=stack.pop()
                else:
                    kind,name=mat.group(5,6)
                    fullname=name.removeprefix('_root_.') if name.startswith('_root_.') else (ns+'.' if ns else '')+name
                    starts.append((mat.start(),kind,fullname,text.startswith('private ')))
            for k,(a,kind,name,private) in enumerate(starts):
                b=starts[k+1][0] if k+1<len(starts) else len(s)
                segment=s[a:b]; original=raw[a:b].rstrip()
                # Signature stop is only a search aid. Lean inventory records exact elaborated types.
                sig=re.split(r'\s:=|\swhere\b',segment,maxsplit=1)[0].strip()
                rows.append({'lane':lane,'name_guess':name,'kind':kind,'private':private,
                  'module':str(p.relative_to(base)).removesuffix('.lean').replace('/','.'),
                  'path':str(p.relative_to(W)), 'origin':str(p.relative_to(W/'snapshot')),
                  'line':raw.count('\n',0,a)+1,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),
                  'signature_source':sig,'source':original,'code':segment.strip()})
            files.append({'lane':lane,'module':str(p.relative_to(base)).removesuffix('.lean').replace('/','.'),'path':str(p.relative_to(W)),'declarations':len(starts)})
    (W/'SOURCE_INVENTORY.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
    (W/'FILE_COVERAGE.json').write_text(json.dumps(files,indent=2)+'\n')
    print(collections.Counter((r['lane'],r['kind']) for r in rows))
    high=[r for r in rows if r['kind'] in ('structure','class') or
          (r['kind'] in ('def','abbrev') and ': Prop' in r['signature_source'])]
    (W/'PREDICATES_SOURCE.txt').write_text('\n\n'.join(f"{r['origin']}:{r['line']} {r['name_guess']}\n{r['source']}" for r in high))
    wanted=[r['name_guess'] for r in rows if r['lane']=='source3' and not r['private']]
    (W/'WANTED.json').write_text(json.dumps(wanted)+'\n')

if __name__=='__main__':main()
