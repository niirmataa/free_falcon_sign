import Source3.KeygenSamplerContext121

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSamplerControls121
open C99CompactState115 (State reference)
open C99MemoryReference (ArrayPointer)
open C99FiniteMemory114 (putBlock)

def ctx : KeygenSearchContext.Context := ⟨⟨1,0,1,448,0⟩,⟨2,0,1,4,0⟩,fun _ => 0⟩
def f : ArrayPointer := ⟨10,0,2,2,0⟩
def g : ArrayPointer := ⟨11,0,2,2,0⟩
def blank := putBlock (putBlock (putBlock ⟨.empty⟩ 1 ⟨448,true,none,.empty⟩) 10 ⟨4,true,none,.empty⟩)
  11 ⟨4,true,none,.empty⟩
def counters := C99FiniteWrite114.write64
  (C99FiniteWrite114.write64 blank ⟨1,216,1,8,0⟩ 136) ⟨1,208,1,8,0⟩ 0
def buffered := C99FiniteWrite114.write64
  (C99FiniteWrite114.write64 counters ⟨1,8,2,8,0⟩ 11) ⟨1,8,2,8,1⟩ 1
def before : State := ⟨buffered,[("n".toList,.u64 (some 2))],
  [("fk".toList,ctx.object),("f".toList,f),("g".toList,g)],[],[]⟩
def fHeap := C99FiniteMemory114.putBlock
  (KeygenStore16Compute121.write16
    (KeygenStore16Compute121.write16
      (C99FiniteWrite114.write64 buffered ⟨1,208,1,8,0⟩ 8) f 1)
    (KeygenSmallOutput.element f 1) 65535) 7 C99FiniteAllocation115.emptyBlock
def afterF : State := {before with heap := fHeap}
def gHeap := KeygenStore16Compute121.write16
  (KeygenStore16Compute121.write16
    (C99FiniteWrite114.write64 fHeap ⟨1,208,1,8,0⟩ 16) g 0)
  (KeygenSmallOutput.element g 1) 65535
def afterG : State := {before with heap := gHeap}

/-- Small source control, not the1536-coordinate chosen-seed witness.
    Word11 rejects low bits3, then accepts2 and0, producing[1,-1]. -/
theorem first_computed : KeygenSamplerContext121.invoke ctx 128 7 4 4 before "f"=some afterF := by decide +kernel

theorem first_source : KeygenSamplerContext.Call ctx (reference before) "f" (reference afterF) :=
  KeygenSamplerContext121.invoke_sound ctx 128 7 4 4 before afterF "f" first_computed

/-- The next call discards the prior local residual bits and reads word1
    from the SAME SHAKE state at cursor8, producing[0,-1] and cursor16. -/
theorem second_computed : KeygenSamplerContext121.invoke ctx 128 7 4 4 afterF "g"=some afterG := by decide +kernel

theorem second_source : KeygenSamplerContext.Call ctx (reference afterF) "g" (reference afterG) :=
  KeygenSamplerContext121.invoke_sound ctx 128 7 4 4 afterF afterG "g" second_computed

theorem cursor_continues : C99FiniteRead114.read64 afterG.heap ⟨1,208,1,8,0⟩=some 16 := by decide +kernel

theorem temporary_restored : C99FiniteAllocation115.fresh afterG.heap 7=true := by decide +kernel

end FT1536.Source3.KeygenSamplerControls121
