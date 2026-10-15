#!/usr/bin/env python3
"""Reproducible source revision candidates from exact declaration dependencies.
No generated declaration is accepted without the ordinary kernel job/audit.
"""
from pathlib import Path
from collections import defaultdict
import hashlib,json,re
ROOT=Path(__file__).resolve().parents[1];BUILD=ROOT/'.build/revision134';FORMAL=ROOT/'formal/Source3'
plan=json.loads((BUILD/'DEPENDENCY_PLAN.json').read_text());assert not plan['unowned_constants']
PREFIX='FT1536.Source3.'
closed={**{'KeygenAttemptNorm.'+n:'KeygenAttemptNorm133.'+n for n in ['Exec','frame','bytes','material','stable']},
 'KeygenAttemptSlots.norm':'KeygenAttemptNorm133.slots','KeygenNormSource094.norm_unique':'KeygenAttemptNorm133.unique'}
changes={};selected=defaultdict(list)
for row in plan['modules']:
    module=row['module'];new=re.sub(r'\d{3}$','',module)+'134'
    for full in row['declarations']:
        short=full.removeprefix(PREFIX)
        if short in closed:changes[short]=closed[short]
        else:
            name=short[len(module)+1:];changes[short]=new+'.'+name;selected[module].append(name)
new_modules={m:re.sub(r'\d{3}$','',m)+'134' for m in selected}
assert len(set(new_modules.values()))==len(new_modules)
qualified=re.compile(r'(?<![A-Za-z0-9_])('+'|'.join(map(re.escape,sorted(changes,key=len,reverse=True)))+r')(?=\b|\.)')
def rewrite(text):return qualified.sub(lambda m:changes[m[1]],text)
def no_comments(text):
    # Keep strings and every newline; comments carry no declaration semantics.
    out=[];i=0;depth=0;string=False
    while i<len(text):
        if depth:
            if text.startswith('/-',i):depth+=1;out.extend('  ');i+=2
            elif text.startswith('-/',i):depth-=1;out.extend('  ');i+=2
            else:out.append('\n' if text[i]=='\n' else ' ');i+=1
        elif string:
            out.append(text[i])
            if text[i]=='\\' and i+1<len(text):out.append(text[i+1]);i+=2;continue
            if text[i]=='"':string=False
            i+=1
        elif text[i]=='"':string=True;out.append(text[i]);i+=1
        elif text.startswith('/-',i):depth=1;out.extend('  ');i+=2
        elif text.startswith('--',i):
            while i<len(text) and text[i]!='\n':out.append(' ');i+=1
        else:out.append(text[i]);i+=1
    assert not depth and not string
    return ''.join(out)
pattern=re.compile(r'^(?:noncomputable )?(?:abbrev|def|theorem|structure|inductive|instance)\s+([A-Za-z_]\w*(?:\.\w+)*)',re.M)
prior_plan=json.loads((BUILD/'SOURCE_REVISION_PLAN.json').read_text()) if (BUILD/'SOURCE_REVISION_PLAN.json').exists() else {'modules':[]}
prior_hashes={r['module']:r['source_sha256'] for r in prior_plan['modules']}
results=[]
for row in plan['modules']:
    module=row['module']
    if module not in selected:continue
    path=FORMAL/(module+'.lean');raw=path.read_text()
    assert hashlib.sha256(path.read_bytes()).hexdigest()==row['source_sha256']
    src=no_comments(raw);matches=list(pattern.finditer(src));new=new_modules[module]
    assert len(re.findall(r'^namespace ',src,re.M))==1
    header=src[:matches[0].start()]
    imports=re.findall(r'^import (\S+)',header,re.M)
    context=header[header.index('namespace '):]
    context=context.replace('namespace '+PREFIX+module,'namespace '+PREFIX+new)
    context+='\nopen '+module+'\n'
    # Split explicit opens so old and revised types are never ambiguous.
    def opened(match):
        target,names=match[1],match[2].split();old=[];new=defaultdict(list)
        for name in names:
            key=target+'.'+name
            if key in changes:
                dest,short=changes[key].rsplit('.',1);new[dest].append(short)
            else:old.append(name)
        lines=['open '+target+' ('+' '.join(old)+')'] if old else []
        lines+=['open '+dest+' ('+' '.join(items)+')' for dest,items in new.items()]
        return '\n'.join(lines)
    context=re.sub(r'^open (\w+)\s*\(([^)]+)\)',opened,context,flags=re.M)
    for target in re.findall(r'^open (\w+)\s*$',context,re.M):
        if target in new_modules and target!=module:
            hidden=sorted({name.split('.')[0] for name in selected[target]})
            context=re.sub(r'^open '+re.escape(target)+r'\s*$',
                'open '+target+' hiding '+' '.join(hidden)+'\nopen '+new_modules[target],context,flags=re.M)
    blocks=[]
    for i,match in enumerate(matches):
        name=match[1]
        if name not in selected[module]:continue
        end=matches[i+1].start() if i+1<len(matches) else src.index('end '+PREFIX+module,match.end())
        block=src[match.start():end].strip()
        # Unnamed output commands after the last declaration are not copied.
        block=re.split(r'^#(?:print|check|eval)',block,flags=re.M)[0].strip()
        blocks.append(rewrite(block))
    assert len(blocks)==len(selected[module]),module
    if module=='KeygenMakeLocalFrame':
        support=src[src.index('theorem search ('):src.index('def fixed :')]
        support=support.replace('KeygenSearchExec.Exec','KeygenSearchExtended133.Exec')
        blocks.insert(0,support.strip())
    text=context+'\n\n'.join(blocks)+'\n\nend '+PREFIX+new+'\n'
    referenced={n for n in list(new_modules.values())+['KeygenAttemptNorm133'] if re.search(r'\b'+n+r'\b',text)}-{new}
    allimports=list(dict.fromkeys(['Source3.'+module]+imports+['Source3.'+n for n in sorted(referenced)]))
    text='\n'.join('import '+n for n in allimports)+'''

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
'''+text
    text='\n'.join(line.rstrip() for line in text.splitlines())+'\n'
    output=FORMAL/(new+'.lean')
    if output.exists() and output.read_text()!=text:
        assert new in prior_hashes,('untracked_candidate_change',new)
        assert hashlib.sha256(output.read_bytes()).hexdigest()==prior_hashes[new],('candidate_changed_outside_recipe',new)
    output.write_text(text)
    results.append({'original':module,'module':new,'source':str(output),'source_sha256':hashlib.sha256(output.read_bytes()).hexdigest(),
      'original_sha256':row['source_sha256'],'declarations':selected[module],'imports':allimports})
remaining={r['module']:r for r in results};order=[]
while remaining:
    ready=sorted(n for n,r in remaining.items() if not({i.removeprefix('Source3.') for i in r['imports']}&remaining.keys()))
    assert ready,('new_import_cycle',list(remaining))
    for n in ready:order.append(n);del remaining[n]
(BUILD/'SOURCE_REVISION_PLAN.json').write_text(json.dumps({'status':'UNVERIFIED_SOURCE_CANDIDATES','changes':changes,'closed_replacements':closed,'modules':results,'order':order},indent=2)+'\n')
print(json.dumps({'new_modules':len(results),'new_declarations':sum(len(r['declarations']) for r in results),'order':order}))
