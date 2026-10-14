import Source3.ShakeExtractInvoke120

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractControls120
open C99CompactState115 (State reference)
open C99MemoryReference
open ShakeExtractSource (field)

def ctx : ShakeExtractSource.Layout := ⟨1,8⟩
def output : ArrayPointer := ⟨7,0,4,1,0⟩
def blank := C99FiniteMemory114.putBlock
  (C99FiniteMemory114.putBlock ⟨.empty⟩ 1 ⟨448,true,none,.empty⟩) 7 ⟨4,true,none,.empty⟩
def counters := C99FiniteWrite114.write64
  (C99FiniteWrite114.write64 blank (field ctx .rate) 136) (field ctx .dptr) 2
def buffered := C99FiniteWrite114.write64 counters ⟨1,8,1,8,0⟩ 0x8877665544332211
def before : State := ⟨buffered,[],[],[],[]⟩
def copied := C99FiniteWrite114.writeVec buffered 7 0 4 (fun i => (byte32 (0x66554433 : BitVec 32)) i)
def after : State := {before with heap := C99FiniteWrite114.write64 copied (field ctx .dptr) 6}

/-- A prebuffered extraction control. RC and A are absent/uninitialized;
    this branch must not invoke process_block or invent missing bytes. -/
theorem computed : ShakeExtractInvoke120.invoke ctx 128 before output (.u64 4)=some after := by decide +kernel

theorem source : ShakeExtractFrame.Call ctx (reference before) output (.uint64 4) (reference after) :=
  ShakeExtractInvoke120.invoke_sound ctx 128 before after output (.u64 4) computed

theorem output_bytes : ∀ i : Fin 4,
    (reference after).heap.bytes 7 i.val=some (byte32 (0x66554433 : BitVec 32) i) := by decide +kernel

theorem counter_updated : C99FiniteRead114.read64 after.heap (field ctx .dptr)=some 6 := by decide +kernel

theorem small_object_rejected : ShakeExtractInvoke120.invoke ctx 128 before ⟨7,0,3,1,0⟩ (.u64 4)=none := by decide +kernel

end FT1536.Source3.ShakeExtractControls120
