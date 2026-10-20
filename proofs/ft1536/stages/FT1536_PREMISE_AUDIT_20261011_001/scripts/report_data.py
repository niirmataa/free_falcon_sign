"""Generate inspectable coverage/consumer registries; unresolved means SUSPECT."""
from pathlib import Path
import json,collections,re,csv,gzip,hashlib
W=Path(__file__).resolve().parents[1]
def jsonl(path):return [json.loads(x) for x in path.read_text().splitlines()]
def dump(name,data):
    (W/name).write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
def main():
    raw=json.loads((W/'SOURCE_INVENTORY.json').read_text())
    by={r['name_guess']:r for r in raw}
    es=jsonl(W/'ELABORATED.jsonl');er=jsonl(W/'ELABORATED_RUN2.jsonl')
    em={r['name']:r for r in es+er if r['available']}
    direct=collections.defaultdict(list);structural=collections.defaultdict(set)
    for r in em.values():
        for b in r['binders']:
            for c in b['constants']:
                direct[c].append({'consumer':r['name'],'binder':b['name'],'type':b['type'],'proof':b['proof']})
        for c in r['body_constants']+r['type_constants']:
            structural[c].add(r['name'])
    candidates={r['name'] for r in em.values() if r['returns_prop'] or r['kind']=='inductive'}
    candidates.update(r['name_guess'] for r in raw if r['kind'] in ('structure','class','inductive') or
                      (r['kind'] in ('def','abbrev') and ': Prop' in r['signature_source']))
    closed={r['result_head']:r['name'] for r in em.values() if r['kind']=='theorem'
            and r['result_head'] in em and em[r['result_head']]['returns_prop']
            and not em[r['result_head']]['binders'] and not r['binders']}
    controls={
      'C99MemoryReference.Allocated':'Source3Probes.allocated_witness',
      'C99MemoryReference.Load64':'Source3Probes.load64_witness',
      'KeygenMakeSearchPrefix.Dimensions':'Source3Probes.dimensions_inhabited',
      'CertificateFrameEntry.Legal':'Source3Probes.certificate_frame_legal_witness',
      'KeygenMakeInvocation.Canonical':'PositiveControls.canonical_witness',
      'StableTopMemory.WellFormed':'PositiveControls.top_layout_witness',
      'CertificateMemory.WellFormed':'PositiveControls.certificate_layout_witness',
      'StableBinary.Layout.wellFormed':'PositiveControls.binary_layout_witness'}
    controls={'FT1536.Source3.'+k:v for k,v in controls.items()}
    matrix=[]
    for name in sorted(candidates):
        if name not in by:continue
        s=by[name];e=em.get(name)
        classification='SUSPECT';scope='Family not certified jointly satisfiable by this audit.';evidence=[]
        if name in controls:classification='OK';scope='At least one explicit kernel witness; not arbitrary-instance or execution reachability.';evidence=[controls[name]]
        if name in closed:classification='TRIVIAL';scope='Closed proposition proved without assumptions; not a defect.';evidence=[closed[name]]
        if name=='FT1536.Source3.KeygenMakeInvocation.VirtualLegal':classification='IMPOSSIBLE';scope='All vb : Nat → Nat; F01.';evidence=['Source3Probes.no_virtual_legal']
        if name=='FT1536.Source3.KeygenMakeInvocation.Invocation':classification='VACUOUS';scope='encoded branch and every successful invocation only; capped branch not certified inhabited.';evidence=['Source3Probes.invocation_only_failure']
        if name=='FT1536.Source3.KeygenMakeCertMaterial.LegalWorkspace':scope='Local family is not declared impossible. Its all-state lifting excludes every CertBind/Call; F03.';evidence=['Source3Probes.all_workspace_iff_no_binding']
        if name=='FT1536.HacGlue.UniformChallengeAt':classification='IMPOSSIBLE';scope='Every Sampler with a fixed finite fair-bit tape; F04.';evidence=['Run2Probes.no_uniform_challenge_at']
        if name=='FT1536.VerifyBind.UniformChallenge':classification='OK';scope='Witness Law.uniform; must not be confused with UniformChallengeAt.';evidence=['Run2Probes.uniform_challenge_law_witness']
        if name=='FT1536.Source3.KeygenPublicTableStore.EvalWord':classification='TRIVIAL';scope='Only unsupported load32 expressions, where Eval has no constructor; not all expressions.';evidence=['Source3Probes.evalword_load32_trivial']
        if name=='FT1536.Source3.KeygenNttCells.Cells':classification='TRIVIAL';scope='Only length n=0; positive lengths are not cleared.';evidence=['Source3Probes.ntt_cells_zero_trivial']
        if name=='FT1536.CompPrg.CompPRGBound':classification='TRIVIAL';scope='Only empty test class; CompWinCert blocks vacuous consumption.';evidence=['Run2Probes.empty_test_class_trivial','Run2Probes.empty_test_class_no_certificate']
        matrix.append({'name':name,'lane':s['lane'],'kind':s['kind'],'origin':s['origin'],'line':s['line'],
            'source_sha256':s['sha256'],'classification':classification,'scope':scope,'evidence':evidence,
            'quote':s['source'],'type':e['type'] if e else None,'elaborated':e is not None,
            'direct_binder_consumers':direct[name],
            'provenance':'EXPLICIT_SOURCE_TYPE_INTERFACE; concrete discharge is separate from the signature',
            'all_joint_instances_checked':False})
    dump('PREMISE_MATRIX.json',matrix)
    with (W/'PREMISE_MATRIX.tsv').open('w') as f:
        wr=csv.writer(f,delimiter='\t');wr.writerow(['classification','lane','name','origin','line','direct consumers','scope'])
        for r in matrix:wr.writerow([r['classification'],r['lane'],r['name'],r['origin'],r['line'],len(r['direct_binder_consumers']),r['scope']])
    branches=[]
    for r in em.values():
        for c in r['constructors']:
            status='SUSPECT';why='No standalone existential witness for the complete constructor telescope.'
            if c['name']=='FT1536.Source3.KeygenMakeInvocation.Invocation.encoded':status='IMPOSSIBLE';why='F01: VirtualLegal constructor argument is impossible.'
            if c['name']=='FT1536.Source3.KeygenMakeCertCall.CertificateGate.unprofiled':status='OK';why='Source3Probes.profile_false_branch_reachable; false under the intended profile is a separate restriction.'
            if c['name']=='FT1536.Source3.C99MemoryReference.Load64.load':status='OK';why='Source3Probes.load64_witness.'
            branches.append({'parent':r['name'],'constructor':c['name'],'classification':status,'reason':why,'type':c['type'],'binders':c['binders']})
    dump('BRANCH_MATRIX.json',branches)
    # This is explicitly a lexical candidate list, not a parser-completeness claim.
    matches=[]
    for r in raw:
        if r['kind'] not in ('def','abbrev'):continue
        for i,line in enumerate(r['code'].splitlines()):
            if re.match(r'\s*\|',line):matches.append({'definition':r['name_guess'],'origin':r['origin'],'line':r['line']+i,'source_line':line.strip(),'classification':'SUSPECT','evidence':'LEXICAL_BRANCH_CANDIDATE_ONLY'})
    dump('DEFINITION_BRANCH_CANDIDATES.json',matches)
    usages=[{'export':r['name'],'type':r['type'],'binders':r['binders'],'body_constants':r['body_constants']}
            for r in em.values() if r['kind']=='theorem']
    dump('EXPORT_PREMISES.json',usages)
    unused=[{'export':r['name'],'binder':b['name'],'type':b['type'],'classification':'SUSPECT',
             'meaning':'Syntactically unused after beta reduction; does not imply premise is always true.'}
            for r in em.values() if r['kind']=='theorem' for b in r['binders'] if b['proof'] and b['used_in_term']==False]
    dump('UNUSED_PREMISES.json',unused)
    findings={
      'F01':{'classification':'IMPOSSIBLE','premise':'VirtualLegal vb','consumer':direct['FT1536.Source3.KeygenMakeInvocation.VirtualLegal'],'branch':'Invocation.encoded','proof':'FT1536.PremiseAudit.no_virtual_legal'},
      'F02':{'classification':'IMPOSSIBLE','premise':'∀ s : State, Dimensions s','consumers':['FT1536.Source3.KeygenMakeInvocation.invocation_certificate'],'proof':'FT1536.PremiseAudit.no_all_state_dimensions'},
      'F03':{'classification':'VACUOUS','premise':'∀ s : State, LegalWorkspace s ctx together with an executed certificate call','consumers':['FT1536.Source3.KeygenMakeAttemptSpine.attempt_spine','FT1536.Source3.KeygenMakeInvocation.invocation_certificate'],'proof':'FT1536.PremiseAudit.attempt_spine_premises_impossible'},
      'F04':{'classification':'IMPOSSIBLE','premise':'UniformChallengeAt S','consumers':[r['name_guess'] for r in raw if r['kind']=='theorem' and 'UniformChallengeAt' in r['signature_source']],'proof':'FT1536.PremiseAuditRun2.no_uniform_challenge_at'},
      'F05':{'classification':'SUSPECT','premise':'positive global mass floor + TowerWhole + a point outside the fiber','consumers':['FT1536.T5Pointwise.machineStage_of_absErr_floor'],'proof':'FT1536.PremiseAuditRun2.positive_floor_incompatible_with_fiber_support','note':'Conditional incompatibility; not a refutation of the lemma with its actual argument list.'},
      'F06':{'classification':'IMPOSSIBLE','premise':'ChaCha20PRFBound at delta < 1 - 2^448/2^n','consumers':['FT1536.AdvPrg.assembled_hardness_substitution_chacha','FT1536.AdvPrg.end_to_end_assembled_theorem_statement_chacha'],'proof':'FT1536.PremiseAuditRun2.no_statistical_chacha_below_support_bound','note':'Known statistical obstruction; no such verdict about class-restricted CompPRGBound.'}}
    dump('FINDINGS.json',findings)
    cov={'source_head':json.loads((W/'ENTRY.json').read_text())['head'],
         'files':dict(collections.Counter(r['lane'] for r in json.loads((W/'FILE_COVERAGE.json').read_text()))),
         'source3_elaboration':{'requested':len(es),'resolved':sum(r['available'] for r in es),'missing':[r['name'] for r in es if not r['available']]},
         'run2_elaboration':{'requested':len(er),'resolved':sum(r['available'] for r in er),'missing':[r['name'] for r in er if not r['available']]},
         'matrix_entries':len(matrix),'classification_counts':dict(collections.Counter(r['classification'] for r in matrix)),
         'matrix_by_lane':dict(collections.Counter(r['lane'] for r in matrix)),
         'inductive_constructor_entries':len(branches),'branch_counts':dict(collections.Counter(r['classification'] for r in branches)),
         'lexical_definition_branch_candidates':len(matches),'export_entries':len(usages),'unused_proof_premises':unused,
         'closed_propositions':closed,'feasibility_complete':False,'all_impossible_premises_found':False,
         'scope_warning':'Inventory and bounded contradiction search do not establish exhaustive semantic satisfiability. SUSPECT entries are open obligations.'}
    dump('COVERAGE.json',cov)
    print(json.dumps({k:v for k,v in cov.items() if k not in ('source3_elaboration','run2_elaboration','closed_propositions','unused_proof_premises')},indent=2))
if __name__=='__main__':main()
