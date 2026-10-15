#!/usr/bin/env python3
"""Diagnostic constant-dependency plan; no mathematical claims or source edits."""
from pathlib import Path
from collections import defaultdict,deque
import hashlib,json,re
import keygen_whole088_audit as audit
ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'.build/revision134'
GRAPH=ROOT/'.build/jobs/keygen_revision134_002/REVISION134_CONSTANT_DEPENDENCIES.json'
rows=json.loads(GRAPH.read_text());graph={row['name']:set(row['dependencies']) for row in rows}
modules={row['name']:row['module'].removeprefix('Source3.') for row in rows}
assert len(graph)==len(rows)
target_modules=['KeygenProbability110','KeygenModelBinding111','KeygenSuccessMass112','KeygenFirstMass112','KeygenCountTarget112']
targets=audit.declarations(target_modules)
assert all(n in graph for n in targets)
def closure(roots,edges):
    seen=set(roots);pending=deque(roots)
    while pending:
        for name in edges.get(pending.popleft(),()):
            if name not in seen:seen.add(name);pending.append(name)
    return seen
reachable=closure(targets,graph)
reverse=defaultdict(set)
for n,deps in graph.items():
    for dep in deps:reverse[dep].add(n)
root='FT1536.Source3.KeygenAttemptNorm.Exec'
affected=closure([root],reverse)&reachable
owners={};explicit={}
for module in sorted({modules[n] for n in affected}):
    path=ROOT/'formal/Source3'/(module+'.lean')
    assert path.is_file(),module
    for name in audit.declarations([module]):explicit[name]=module
for name in affected:
    candidates=[n for n in explicit if name==n or name.startswith(n+'.')]
    owners[name]=max(candidates,key=len) if candidates else None
unowned=sorted(n for n,v in owners.items() if v is None)
selected=defaultdict(set)
for n,v in owners.items():
    if v:selected[explicit[v]].add(v)
summary=[{'module':m,'declarations':sorted(v),'source_sha256':hashlib.sha256((ROOT/'formal/Source3'/(m+'.lean')).read_bytes()).hexdigest()} for m,v in sorted(selected.items())]
result={'status':'DIAGNOSTIC_EXACT_CONSTANT_DEPENDENCIES; GENERATED_PROOFS_STILL_REQUIRE_KERNEL_CHECKING',
 'graph':{'path':str(GRAPH),'sha256':hashlib.sha256(GRAPH.read_bytes()).hexdigest()},
 'root':root,'targets':targets,'reachable_constants':len(reachable),'affected_constants':len(affected),
 'modules':summary,'unowned_constants':unowned}
(BUILD/'DEPENDENCY_PLAN.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({'modules':len(summary),'source_declarations':sum(len(r['declarations']) for r in summary),'affected_constants':len(affected),'unowned':unowned}))
for r in summary:print(r['module'],len(r['declarations']))
