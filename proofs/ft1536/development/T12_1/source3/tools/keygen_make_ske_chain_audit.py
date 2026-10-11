#!/usr/bin/env python3
"""Generate063's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeSkeChain']
INHERITED=['KeygenMakeSkeCells.SkeCellWord','KeygenMakeSkeCells.ske_word_of_bind',
    'KeygenMakeSkeCells.ske_word_of_store_frame','KeygenMakeSkeCells.small_site_src_live',
    'KeygenMakeSkeCells.small_site_material_extended','KeygenMakeInvocation.Head',
    'KeygenMakeInvocation.Encoding','KeygenMakeInvocation.Segments',
    'KeygenMakeInvocation.head_cells','KeygenMakeProgram.encoding','KeygenSearchContext.Context',
    'KeygenMakeSearchPrefix.Dimensions','KeygenMakeSearchPrefix.Remaining',
    'KeygenMakeSearchPrefix.Sampled','KeygenMakeSearchPrefix.sampled_remaining',
    'KeygenMakeCertChronology.AttemptExec','KeygenMakeCertChronology.AttemptExecution',
    'KeygenMakeCertChronology.LoopTrace','KeygenMakeCertChronology.attempt_remaining',
    'KeygenMakeCertCall.CertBind','KeygenMakeCertCall.Profile','KeygenMakeCertCall.Call',
    'KeygenMakeCertCall.CertificateGate','KeygenMakeCertCall.profile_of_dimensions',
    'KeygenMakeCertCall.accepted_break_requires_call',
    'KeygenMakeRetryTransport.EntryFrame','KeygenMakeRetryTransport.CertEntryFrame',
    'KeygenMakeRetryTransport.sampled_entry','KeygenMakeRetryTransport.initial_of_attempt',
    'KeygenMakeRetryTransport.frame_of_attempt',
    'KeygenCallerEntry.Initial',
    'KeygenMakeAttemptSpine.entry_of_allocation',
    'KeygenMakeEntry.Original','KeygenMakeEntry.input','KeygenMakeEntry.publicPointer',
    'KeygenMakeReady.Prefix',
    'KeygenMakeWorkspaceBridge.Shape','KeygenMakeWorkspaceBridge.legalWorkspace_of_shape',
    'KeygenMkgm3Layout.Legal',
    'KeygenMakeCertMaterial.LegalWorkspace','KeygenMakeCertMaterial.workspace_scratch_block',
    'C99Automatic32.Space','C99Automatic32.align4',
    'KeygenMakeInvocation.Env','KeygenMakeInvocation.CertPackage',
    'KeygenMakeInvocation.cert_package','KeygenMakeInvocation.Invocation',
    'KeygenMakeInvocation.SmallSite','KeygenMakeInvocation.VirtualLegal',
    'KeygenMakeInvocation.Canonical','KeygenMakeInvocation.skeElem','KeygenMakeInvocation.skeName',
    'KeygenMakeInvocation.inputOf','KeygenMakeInvocation.wordOf',
    'KeygenMakeInvocation.WritePointer','KeygenMakeInvocation.ReadPointer',
    'KeygenMakeInvocation.load64_of_store','KeygenMakeInvocation.canonical_word_eq',
    'KeygenMakeInvocation.input_canonical','KeygenMakeInvocation.inputOf_mem_live',
    'KeygenMakeInvocation.virtualLegal_exists',
    'KeygenMakeLifetime.close_flow',
    'KeygenCapExecution.abortFlow',
    'KeygenEntropySource.Event',
    'C99MemoryReference.Memory','C99MemoryReference.ArrayPointer','C99MemoryReference.Allocated',
    'C99MemoryReference.Load64','C99MemoryReference.Store64',
    'C99MemoryReference.load64_deterministic',
    'C99ArrayReference.State','C99ArrayReference.Name',
    'C99IntegerReference.Value',
    'C99ProcedureReference.Result','C99ProcedureReference.Flow']

def declarations():
    result=[]
    for module in MODULES:
        text=(ROOT/'formal/Source3'/(module+'.lean')).read_text()
        namespace=re.search(r'^namespace (FT1536\.Source3\.\w+)$',text,re.M).group(1)
        names=re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)',text,re.M)
        assert names and len(names)==len(set(names)),module
        result.extend(namespace+'.'+name for name in names)
    assert len(result)==len(set(result))
    return result

def main():
    groups=defaultdict(list)
    for full in declarations():
        namespace,name=full.rsplit('.',1);groups[namespace].append(name)
    template=(ROOT/'formal/Source3/KeygenLevelsAudit.lean').read_text()
    suffix=template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT','SEARCH_AUDIT')
    suffix=suffix.replace('    IO.FS.writeFile "../SEARCH_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../SEARCH_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header=''.join('import Source3.'+module+'\n' for module in MODULES)
    header+='import Source3.CertificateM0Environment\nimport Lean.Util.CollectAxioms\n\n'
    header+='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header+='set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header+='set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header+='/- Generated063 full terms for the concrete nine-statement ske chain.\n'
    header+='   Internal audit only; no codec frame or law claim. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeSkeChainAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__':
    main()
