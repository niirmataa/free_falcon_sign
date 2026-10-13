# Exact counts, standard Sage preparser. This does not discharge source equivalence.
from pathlib import Path
from sage.version import version as sage_version
import json,hashlib,sys
S=Path.cwd()/'proofs/ft1536/development/S05_QROM';B=S/'.build/pair_machine_020/producer_001'
paths=[B/'runs/windowexport001/stdout.txt',B/'runs/coreexport001/stdout.txt']
W,C=[ZZ(len(json.loads(p.read_text()))) for p in paths]
regs=ZZ(64);out=ZZ(96);control=ZZ(2);ir=ZZ(23);phase=ZZ(1)
working=regs+out+control+ir+phase
instruction=ZZ(22)
assert working==186 and W==3469 and C==11264
values={'window_instructions':W,'slot_instructions':C,'registers':regs,'output_words':out,
 'pc_and_load_flag':control,'fetched_instruction_words':ir,'fetch_execute_phase':phase,
 'working_payload_words':working,'working_payload_bytes':64*working,
 'window_code_words':instruction*W,'slot_code_words':instruction*C,
 'window_increment_over_resident_sources_words':instruction*W+working+4,
 'slot_increment_over_resident_sources_words':instruction*C+working+4,
 'slot_standalone_with_96_word_input_words':instruction*C+working+4+96+2}
assert all(v<2^511 for v in values.values())
outfile=Path(sys.argv[1]);assert not outfile.exists()
source='''import ProducerMemory020E6
import ProducerWindow020E6
import ProducerCoreSlots020E6
import ProducerProgram020E6

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
namespace FT1536.S05.ProducerNumbers020E6

theorem window_size : ProducerBatch020E6.size ProducerWindow020E6.cells=%s := by decide +kernel
theorem slot_size : ProducerBatch020E6.size ProducerCoreSlots020E6.cells=%s := by decide +kernel

theorem window_fits : ProducerBatch020E6.size ProducerWindow020E6.cells<2^511 := by rw [window_size];decide +kernel
theorem slot_fits : ProducerBatch020E6.size ProducerCoreSlots020E6.cells<2^511 := by rw [slot_size];decide +kernel

/-- Actual stored working payload, including IR and fetch/execute phase. -/
theorem payload_bytes : 64*(186 : Nat)=%s := by decide +kernel

theorem window_increment : 22*ProducerBatch020E6.size ProducerWindow020E6.cells+190=%s := by rw [window_size]
theorem slot_increment : 22*ProducerBatch020E6.size ProducerCoreSlots020E6.cells+190=%s := by rw [slot_size]

end FT1536.S05.ProducerNumbers020E6
'''%(W,C,64*working,values['window_increment_over_resident_sources_words'],values['slot_increment_over_resident_sources_words'])
outfile.write_text(source)
receipt={'status':'EXACT_COUNTS_NOT_SOURCE_EQUIVALENCE','sage':str(sage_version),
 'values':{k:str(v) for k,v in values.items()},'program_inputs':[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],
 'source_sha256':hashlib.sha256(outfile.read_bytes()).hexdigest(),'script_sha256':hashlib.sha256((S/'notes/CHECK_PRODUCER_COUNTS_020E6.sage').read_bytes()).hexdigest(),
 'scope':'Two individual compiled programs. Full original-generator equivalence and enclosing lifetime/controller composition remain obligations.'}
r=outfile.with_suffix('.generation.json');assert not r.exists();r.write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt,indent=2))
