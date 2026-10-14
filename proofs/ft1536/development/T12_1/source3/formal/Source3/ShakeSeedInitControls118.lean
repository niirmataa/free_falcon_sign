import Source3.ShakeSeedInvoke118

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeSeedInitControls118
open C99CompactState115 (State reference)
open ShakeExtractSource (field)

def ctx : ShakeExtractSource.Layout := ⟨1,8⟩
def before : State := ⟨C99FiniteMemory114.putBlock ⟨.empty⟩ 1 ⟨448,true,none,.empty⟩,[],[],[],[]⟩
def afterRate := C99FiniteWrite114.write64 before.heap (field ctx .rate) 136
def afterCounter := C99FiniteWrite114.write64 afterRate (field ctx .dptr) 0
def afterZero := C99FiniteWrite114.writeVec afterCounter 1 224 200 (fun _ => 0)
def afterLanes := ([1,2,8,12,17,20] : List Nat).foldl (fun heap i =>
  C99FiniteWrite114.write64 heap (KeygenSmallOutput.element (field ctx .a) i) 0xffffffffffffffff) afterZero
def initialized : State := {before with heap := afterLanes}

/-- The input bytes are uninitialized. The source init body must produce
    every initialized lane/counter itself, not read an assumed SHAKE state. -/
theorem init_computed : ShakeSeedInvoke118.init ctx 64 before (.i32 512)=some initialized := by decide +kernel

theorem init_source : ShakeSeedReference.Init ctx (reference before) (.int32 512) (reference initialized) :=
  ShakeSeedInvoke118.init_sound ctx 64 before initialized (.i32 512) init_computed

theorem rate_and_counter :
    C99FiniteRead114.read64 initialized.heap (field ctx .rate)=some 136 ∧
    C99FiniteRead114.read64 initialized.heap (field ctx .dptr)=some 0 := by decide +kernel

theorem lane_values : ∀ i : Fin 25,
    C99FiniteRead114.read64 initialized.heap (KeygenSmallOutput.element (field ctx .a) i.val)=
      some (if i.val∈[1,2,8,12,17,20] then 0xffffffffffffffff else 0) := by decide +kernel

theorem data_buffer_untouched : (C99FiniteMemory114.memory initialized.heap).bytes 1 8=none := by decide +kernel

end FT1536.Source3.ShakeSeedInitControls118
