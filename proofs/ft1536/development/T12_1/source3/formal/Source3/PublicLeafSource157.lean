import Source3.PublicLinearSource157
import Source3.KeygenPublicLeafWords
import Source3.C99ScalarDeterminism089
import Source3.C99HeaderSound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicLeafSource157
open B20.C
open C99ValueBridge (value)
open KeygenPublicScalar (Kind)
open KeygenPublicLeafWords (code Supported)

theorem body (kind : Kind) (supported : Supported kind) (args : List Val) (word : BitVec 32)
    (length : args.length=(KeygenPublicScalar.params kind).length)
    (binding : C99ScalarReference.BindArgs (C99Frontend.headerFunction (code kind)).params (args.map value)
      (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params kind) (args.map value)).locals)
    (computed : CLogic.execute (fun _ _ => none) (code kind) args=some (.u32 word)) :
    KeygenPublicScalar.Body (fun _ _ _ => False) kind (args.map value) (.uint32 word) := by
  have function := C99HeaderSound.function_sound C99HeaderProof.noSignature FprPrefixCalls.calls (fun _ _ => none)
    (by intro _ _ _ impossible; cases impossible) (code kind) args (.u32 word) (KeygenPublicLeafWords.checked kind supported) computed
  obtain ⟨env,raw,parameters,executed,returned⟩ := C99HeaderProof.function_inv _ _ _ _ function
  have same := C99ScalarDeterminism089.parameters_unique _ _ _ _ parameters binding
  rw [same] at executed
  obtain ⟨after,source⟩ := PublicLinearSource157.source (fun _ _ _ => False) (code kind).body
    (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params kind) (args.map value)) raw executed
  refine ⟨by simpa only [List.length_map] using length,⟨after,.returned (some raw)⟩,?_,?_⟩
  · rw [KeygenPublicLeafWords.source_binding kind supported]
    exact source
  · change C99IntegerReference.Value.uint32 word=C99IntegerReference.convert .uint32 raw.integer at returned
    rw [returned]
    exact .value _ _

theorem call (kind : Kind) (supported : Supported kind) (args : List Val) (word : BitVec 32)
    (length : args.length=(KeygenPublicScalar.params kind).length)
    (binding : C99ScalarReference.BindArgs (C99Frontend.headerFunction (code kind)).params (args.map value)
      (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params kind) (args.map value)).locals)
    (computed : CLogic.execute (fun _ _ => none) (code kind) args=some (.u32 word)) :
    KeygenPublicScalar.Call (KeygenPublicScalar.name kind) (args.map value) (.uint32 word) := by
  have leaf : KeygenPublicScalar.IsLeaf kind := by
    cases kind <;> simp_all [Supported,KeygenPublicScalar.IsLeaf]
  exact .square _ _ _ (.leaf _ _ _ (.run kind _ _ leaf (body kind supported args word length binding computed)))

theorem add (x y q : BitVec 32) : KeygenPublicScalar.Call "mq_add".toList [.uint32 x,.uint32 y,.uint32 q]
    (.uint32 (KeygenModpAddSub.result .add x y q)) :=
  call .add (by decide) [.u32 x,.u32 y,.u32 q] _ rfl
    (KeygenPublicLeafWords.bound_add_sub .add (Or.inl rfl) x y q) (KeygenPublicLeafWords.add_model x y q)
theorem sub (x y q : BitVec 32) : KeygenPublicScalar.Call "mq_sub".toList [.uint32 x,.uint32 y,.uint32 q]
    (.uint32 (KeygenModpAddSub.result .sub x y q)) :=
  call .sub (by decide) [.u32 x,.u32 y,.u32 q] _ rfl
    (KeygenPublicLeafWords.bound_add_sub .sub (Or.inr rfl) x y q) (KeygenPublicLeafWords.sub_model x y q)
theorem mul (x y q q0i : BitVec 32) : KeygenPublicScalar.Call "mq_montymul".toList [.uint32 x,.uint32 y,.uint32 q,.uint32 q0i]
    (.uint32 (KeygenPublicLeafWords.montgomery x y q q0i)) :=
  call .mul (by decide) [.u32 x,.u32 y,.u32 q,.u32 q0i] _ rfl
    (KeygenPublicLeafWords.bound_mul x y q q0i) (KeygenPublicLeafWords.mul_model x y q q0i)
theorem conv (x q : BitVec 32) : KeygenPublicScalar.Call "mq_conv_small".toList [.int32 x,.uint32 q]
    (.uint32 (KeygenModpSet.word x q)) :=
  call .conv (by decide) [.i32 x,.u32 q] _ rfl
    (KeygenPublicLeafWords.bound_two .conv (Or.inl rfl) x q) (KeygenPublicLeafWords.conv_model x q)
theorem half (x q : BitVec 32) : KeygenPublicScalar.Call "mq_rshift1".toList [.uint32 x,.uint32 q]
    (.uint32 (KeygenPublicLeafWords.half x q)) :=
  call .half (by decide) [.u32 x,.u32 q] _ rfl
    (KeygenPublicLeafWords.bound_two .half (Or.inr rfl) x q) (KeygenPublicLeafWords.half_model x q)

end FT1536.Source3.PublicLeafSource157
