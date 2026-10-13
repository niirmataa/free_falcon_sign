# Exact arithmetic only; invoke: sage CHECK_RESOURCE_CHARGES_020E4.sage
from pathlib import Path
from sage.version import version as sage_version
import json, hashlib, sys
S=Path.cwd()/'proofs/ft1536/development/S05_QROM'
B=S/'.build/pair_machine_020/array_backend_001'
N=ZZ(877);F=ZZ(28941);L=ZZ(1106642201817)
T=ZZ(24662538240);R=ZZ(93698);O=ZZ(50689);RAM=ZZ(4608)
def write(n,w): return n*(2*w+8)+8
W=4+write(O,1)
V=6+N*(6+(81+write(N,2)))
A=V+140+W
P=4+write(F,3)
STEP=18+A+(2+2*(3+P))
CORE=4+L*(5+STEP)
COMMIT=12+write(N,5)+write(N,1)
PARSE=4+N*(40+313+COMMIT)
EMPTY=4+(4+N*9)+(4+N*5)
BOOT=(4+6*N)+EMPTY+PARSE
FROM=4+((6+F*7)+(7+(P+1+CORE)))
PROGRAM=BOOT+1+FROM
INPUT=4+((4+T*5+T)+(4+R*5+R*20))
INIT=4+((4+32*5)+((4+RAM*5)+(4+O*5)))
COPY=4+O*5+O*3
TOTAL=INPUT+(INIT+(PROGRAM+1+COPY))
rows={'value_scan':V,'action':A,'frame_push':P,'executor_step':STEP,'executor':CORE,
      'parser_boot':BOOT,'program':PROGRAM,'input':INPUT,'initial':INIT,'output_copy':COPY,
      'total_time_and_cumulative_charge':TOTAL,'materialized_coin_cells':T,
      'coin_bytes_if_padded_to_one_512_bit_word_per_cell':64*T}
assert all(x>=0 for x in rows.values())
assert N<2^511 and F<2^511 and L<2^511 and TOTAL<2^511
out=Path(sys.argv[1]) if len(sys.argv)>1 else S/'formal/CostNumbers020E4.lean'
assert not out.exists()
unfolds='''CostDriver020E4.price,CostInput020E4.price,CostBoundary020E4.initialPrice,
    CostBoundary020E4.copyPrice,CostProgram020E4.price,CostBoot020E4.price,
    CostParse020E4.loadPrice,CostParse020E4.emptyPrice,CostParse020E4.parsePrice,
    CostParserStep020E4.price,CostParserStep020E4.commitPrice,CostProgram020E4.fromPrice,
    CostExecute020E4.price,CostExecute020E4.stepPrice,CostExecute020E4.pushManyPrice,
    CostAction020E4.price,CostValues020E4.buildPrice,CostValues020E4.stepPrice,
    CostAtom020E4.writeBound,CostState020E4.writePrice,CostFrames020E4.pushPrice,
    CostBank020E4.writePrice,BankProgram020E3.frameCapacity,NodeProgram020E2.controlLimit,
    WordRAM020.tapeSize,WordRAM020.romSize,WordRAM020.ramSize,WordRAM020.outputSize'''
text='''import CostCertificate020E4

namespace FT1536.S05.CostNumbers020E4
/-- Computed by Sage; this equality, not generator output, is authoritative in Lean. -/
theorem total : CostDriver020E4.price=%s := by
  norm_num [%s]

theorem every_call (k : CostInput020E4.Key) (coins : JointInterface019.Bits WordRAM020.tapeSize) :
    CostRun020E4.Bounded (CostDriver020E4.run k coins) %s %s := by
  rw [←total]
  exact CostDriver020E4.bound k coins

/-- Payload-size statement for the declared one-word-per-Bool storage model;
    neither a native Lean measurement nor a packed tape claim. -/
theorem coin_payload_bytes : 64*WordRAM020.tapeSize=%s := by norm_num [WordRAM020.tapeSize]

end FT1536.S05.CostNumbers020E4
''' % (TOTAL,unfolds,TOTAL,TOTAL,64*T)
out.write_text(text)
receipt={'status':'EXACT_SAGE_MODEL_ARITHMETIC_NOT_PEAK_PROOF','sage':str(sage_version),
         'values':{k:str(v) for k,v in rows.items()},'generated_source_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),
         'script_sha256':hashlib.sha256((S/'notes/CHECK_RESOURCE_CHARGES_020E4.sage').read_bytes()).hexdigest()}
p=out.with_suffix('.generation.json');assert not p.exists();p.write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt['values'],indent=2))
