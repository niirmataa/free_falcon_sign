"""Collect the successful replay and write the bounded execution verdict."""
import datetime
import hashlib
import json
from pathlib import Path

W=Path.cwd()
def load(rel):return json.loads((W/rel).read_text())
def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def write(rel,value):
    with (W/rel).open("x") as f:json.dump(value,f,indent=2);f.write("\n")

replay=W/"tmp/replay_001"
receipt=json.loads((replay/"REPLAY_RESULT.json").read_text())
assert receipt["status"]=="FRESH_REPLAY_MATCH" and len(receipt["compared"])==10
for row in receipt["compared"]:
    assert sha(W/row["path"])==sha(replay/row["path"])==row["sha256"]
archive=W/"artifacts/fresh_replay_logs";archive.mkdir()
copy_log=[]
for r in map(json.loads,(replay/"COMMANDS.log").read_text().splitlines()):
    for key in ["stdout","stderr"]:
        rel=r[key];source=replay/rel;target=archive/source.name
        with target.open("xb") as f:f.write(source.read_bytes())
        assert sha(target)==r["stream_sha256"][key]
        copy_log.append({"original":rel,"archive":str(target.relative_to(W)),"sha256":sha(target)})
with (W/"artifacts/fresh_replay_COMMANDS.log").open("xb") as f:f.write((replay/"COMMANDS.log").read_bytes())
receipt["archived_command_log"]="artifacts/fresh_replay_COMMANDS.log"
receipt["archived_streams"]=copy_log
write("artifacts/fresh_replay.json",receipt)

w=load("artifacts/witness.json"); v=load("artifacts/verification.json")
assert v["status"]=="BINDINGS_VERIFIED" and v["theorems_checked"]==26
assert v["inherited_files_unchanged"]==1429
source={name:digest for digest,name in (line.split() for line in (W/"inputs/source_hashes.sha256").read_text().splitlines())}
result={
 "schema":"FT1536_LV_STATIC_RESULT_V1",
 "created_utc":datetime.datetime.now(datetime.timezone.utc).isoformat(),
 "lemma":"L_V-STATIC",
 "result":"COUNTEREXAMPLE_REQUIRED_DOMAIN",
 "project_acceptance":False,
 "honest_profile":"FT1536 full ternary secret / FALCON_COMP_STATIC",
 "quantification_refuted":"all h in successful-output support of real S17 KeyGen, all canonical c, all accepted finite payloads; Ext0 unchanged",
 "parameters":{"N":1536,"q":18433,"Phi":"X^1536-X^768+1","B":2093922385,"Q":"sum of offset-768 A2 blocks in both components","strict":True},
 "extractor":"Ext0(h,c,b)=(center_q(c-h*s(b)),s(b)); s(b) is the actual decoded int16 vector",
 "source_manifest":{"git_commit":"d641ab1037c2fa1dd4a22c258854d79d67b9b46b","git_path":"evidence/_work/PO-01-BASELINE-001-20260803-a1/source_hashes.sha256","sha256":"03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589"},
 "source_hashes":source,
 "model":{"platform":"Linux x86_64 LP64","compiler":"GCC 14.2.0 (Debian 14.2.0-19)","language":"C99","CHAR_BIT":8,"int_bits":32,"unsigned_bits":32,"long_bits":64,"size_t_bits":64,"int16_bits":16,"uint16_bits":16,"int64_bits":64,"unsigned_arithmetic":"modulo corresponding word size","signed_narrowing":"GCC observed semantics recorded for boundary controls; the full witness decodes magnitude 20000 and needs no out-of-range signed narrowing","signed_overflow_assumed":False,"flags_anchor":"artifacts/build-base-normal.json"},
 "support":{"public_key_sha256":w["public_key_sha256"],"public_h_sha256":w["public_h_sha256"],"historical_keygen_attempt":"inputs/resume_001/KEYGEN_ATTEMPT.json","historical_keygen_attempt_sha256":"e357d32d0aa91e6b80af2a83674965fbad776699c6c6f999fa71376ec52a7370","key_commitment":"inputs/key/KEY_COMMITMENT.json","key_commitment_sha256":"014358887337670f599c442bb3b838aa6084931efeba17a00eb72fda014e9523","basis":"hash-bound public record of a successful S17 KeyGen call; no new or private KeyGen replay"},
 "witness":{"json":"artifacts/witness.json","json_sha256":sha(W/"artifacts/witness.json"),"payload":"artifacts/witness.bin","payload_sha256":w["payload_sha256"],"payload_bytes":1931,"header":"0xAA","decoded":"s(x)=-20000; all other coefficients zero","challenge":"c_i=(8670*h_i) mod 18433","challenge_file":"artifacts/witness_c.txt","challenge_sha256":sha(W/"artifacts/witness_c.txt"),"extracted_first":"center_q(10237*h)","source_verify":1,"raw_verify":1,"actual_machine_first":"all zero","machine_Q":400000000,"Ext0_first_Q":42658711057,"Ext0_Q":43058711057,"Ext0_excess_over_B":40964788672,"congruence_holds":True,"shortness_holds":False},
 "checks":{"positive_full_Verify":10,"full_Verify_B_boundaries":6,"decoder_cases":35,"semantic_mutations_rejected":11,"mutation_survivors":0,"C_normal_replay":"artifacts/c-replay-normal.json","C_ASan_UBSan_replay":"artifacts/c-replay-sanitize.json","independent_Sage":"artifacts/sage_check.json","fresh_replay":"artifacts/fresh_replay.json","fresh_semantic_files_identical":10},
 "formal":{"checked_file":"formal/WitnessBlocks.lean","sha256":"f166ae8569868ec8eda7a816e7ffdaa1ebacfa4c98acafde565f869b75da7215","toolchain":"Lean 4.34.0 / Std","theorems":26,"nonempty_axiom_dependencies":["propext"],"literal_pairs":768,"pair_binding":"artifacts/lean_blocks_binding.json","scope":"all literal A2 pair energies, append composition, strict/non-strict witness inequalities and auxiliary word arithmetic; not C semantics or the KeyGen provenance","C_semantics_formalized":False,"uncompleted_attempt":"formal/Witness.lean","uncompleted_attempt_record":"artifacts/lean_array_timeout.json"},
 "remaining_premises":["required-key-support membership is consumed from the pinned historical public KeyGen evidence","C acceptance is established by reproducible GCC/LP64 execution and checked harness fidelity, not by a complete kernel formalization of C"],
 "claim_limits":{"other_extractors_ruled_out":False,"HashToPoint_preimage_found":False,"efficient_EUF_CMA_forgery_proved":False,"T2C3_or_T5_reopened":False,"reference_sources_changed":False,"parameters_or_Ext0_changed":False,"new_keys_generated":False,"private_coefficients_read":False},
 "next_mathematical_task":"Separate source-bound normalization contract: decoded int16 -> canonical residue in [0,q-1] congruent to the original signed value, for a future explicitly pinned verifier version; retain this witness as a regression.",
 "report":"REPORT.md",
 "report_sha256":sha(W/"REPORT.md"),
 "output_manifest":"OUTPUTS.sha256",
 "output_scope":"OUTPUT_SCOPE.md"
}
write("RESULT.json",result)
print(json.dumps({"result":result["result"],"report_sha256":result["report_sha256"],"witness_sha256":result["witness"]["json_sha256"],"fresh_replay_files":10},indent=2))
