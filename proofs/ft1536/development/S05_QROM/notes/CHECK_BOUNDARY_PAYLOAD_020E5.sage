# Run with Sage's standard preparser. Exact ZZ arithmetic only.
from pathlib import Path
from sage.version import version as sage_version
import json, hashlib, sys
S=Path.cwd()/'proofs/ft1536/development/S05_QROM'
B=S/'.build/pair_machine_020/peak_memory_001'
T=ZZ(24662538240);R=ZZ(93698);O=ZZ(50689);C=ZZ(877);F=ZZ(28941)
rows={
 'public_image':ZZ(768)*2+30721+61441+C*2,
 'tape_with_cursor':T+1,
 'rom_with_cursor':R+1,
 'parser_with_cursor_and_failure':C*5+C+2+2,
 'core_complete':ZZ(32)+4608+O+F*3+C*2+16,
 'output_with_cursor':O+1,
 'stored_script_with_cursor':ZZ(32)*3+1,
 'seven_region_headers':ZZ(7)*2,
}
payload=sum(rows[k] for k in ['public_image','tape_with_cursor','rom_with_cursor','parser_with_cursor_and_failure','core_complete','output_with_cursor'])
resident=payload+rows['stored_script_with_cursor']+rows['seven_region_headers']
rows.update({'boundary_payload':payload,'represented_resident_with_script':resident,'padded_bytes_for_represented_resident':resident*64})
assert all(0<=v<2^511 for v in rows.values())
assert rows['core_complete']==143922 and rows['public_image']==95452
out=Path(sys.argv[1]);assert not out.exists()
src='''import BoundaryPayload020E5

set_option maxRecDepth 8192
namespace FT1536.S05.BoundaryNumbers020E5
/-- Exact size of the represented resident data, not a bound for all
    producer/controller temporaries or native process memory. -/
theorem payload : BoundaryPayload020E5.payloadWords=%s := by
  rfl

theorem represented_resident {n : Nat} (d : BoundaryPayload020E5.Data) (hn : n≤2^511)
    (b : ScriptBuffer020E5.Buffer n 32) (cursor : Fin 33) :
    RegionRam020E5.live (BoundaryPayload020E5.withScratch d hn b cursor)=%s := by
  rw [BoundaryPayload020E5.withScratch_live,payload]

theorem padded_bytes : 64*(%s : Nat)=%s := by norm_num

end FT1536.S05.BoundaryNumbers020E5
'''%(payload,resident,resident,64*resident)
out.write_text(src)
receipt={'status':'EXACT_SAGE_REPRESENTED_PAYLOAD_NOT_FULL_PEAK','sage':str(sage_version),
 'values':{k:str(v) for k,v in rows.items()},'script_sha256':hashlib.sha256((S/'notes/CHECK_BOUNDARY_PAYLOAD_020E5.sage').read_bytes()).hexdigest(),
 'generated_source_sha256':hashlib.sha256(out.read_bytes()).hexdigest(),
 'exclusions':['emitter-local lifetime proof','outer scheduler and whole-call allocation composition','native Lean/C implementation and bit cost']}
r=out.with_suffix('.generation.json');assert not r.exists();r.write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps(receipt,indent=2))
