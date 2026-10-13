import Source3.KeygenCodecStaticLow9

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Fold every actual statement of one normally completed coefficient body.
   Initial accumulator/pending/profile cells remain local entry conditions. -/
namespace FT1536.Source3.KeygenCodecStaticIteration
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticProfile KeygenCodecStaticCoefficient
open KeygenCodecStaticPending (normal_seq)

def nextPending (p : Nat) (n : Int) : Nat :=
  ((p+9)%8+(magnitude n/256+1).toNat)%8

def nextWord (p : Nat) (word : BitVec 32) (n : Int) : BitVec 32 :=
  (KeygenCodecStaticUnaryInvariant.finish (magnitude n/256+1).toNat ((p+9)%8)
    ((word <<< 9) ||| KeygenCodecStaticLow9.packed n)).2

theorem single_declaration (args : Args) (s t : State) (name : Name)
    (ty : Ty) (refTy : C99IntegerReference.Ty) (notBuf : name≠"buf".toList)
    (scalarType : scalarTy ty=some refTy)
    (source : Exec args (.declare [⟨name,ty,none⟩]) s t .normal) :
    t.locals.scalars name=some (refTy,none) := by
  cases source with
  | declare args s objects locals declarations =>
    have same : locals=localSet s.locals name refTy none := by
      simpa [declareLocals,show name≠['b','u','f'] from notBuf,scalarType] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

/-- No initial w/lo/ne cells or quotient/pending ranges are assumed.
    Those cells come from the real declarations/read/branches/drain. -/
theorem body_state (args : Args) (s t : State) (p : Nat) (word : BitVec 32)
    (small : p<8) (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (j : Cell "j".toList .int32 (.int32 8) s.locals)
    (mask : Cell "mask".toList .uint32 (.uint32 255) s.locals)
    (source : Exec args KeygenCodecStaticBinding.node101 s t .normal) :
    ∃ input : BitVec 16, KeygenCodecStaticPending.Cell (nextPending p input.toInt) t.locals ∧
      KeygenCodecStaticUnaryInvariant.Acc (nextWord p word input.toInt) t.locals := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨s1,e0,rest⟩ := normal_seq args KeygenCodecStaticBinding.node022 KeygenCodecStaticBinding.node099 s t inside
    obtain ⟨s2,e1,rest⟩ := normal_seq args KeygenCodecStaticBinding.node023 KeygenCodecStaticBinding.node098 s1 t rest
    obtain ⟨s3,e2,rest⟩ := normal_seq args KeygenCodecStaticBinding.node024 KeygenCodecStaticBinding.node097 s2 t rest
    obtain ⟨s4,e3,rest⟩ := normal_seq args KeygenCodecStaticBinding.node025 KeygenCodecStaticBinding.node096 s3 t rest
    obtain ⟨s5,e4,rest⟩ := normal_seq args KeygenCodecStaticBinding.node026 KeygenCodecStaticBinding.node095 s4 t rest
    obtain ⟨s6,e5,rest⟩ := normal_seq args KeygenCodecStaticBinding.node037 KeygenCodecStaticBinding.node094 s5 t rest
    obtain ⟨s7,e6,rest⟩ := normal_seq args KeygenCodecStaticBinding.node038 KeygenCodecStaticBinding.node093 s6 t rest
    obtain ⟨s8,e7,rest⟩ := normal_seq args KeygenCodecStaticBinding.node039 KeygenCodecStaticBinding.node092 s7 t rest
    obtain ⟨s9,e8,rest⟩ := normal_seq args KeygenCodecStaticBinding.node040 KeygenCodecStaticBinding.node091 s8 t rest
    obtain ⟨s10,e9,rest⟩ := normal_seq args KeygenCodecStaticBinding.node041 KeygenCodecStaticBinding.node090 s9 t rest
    obtain ⟨s11,e10,rest⟩ := normal_seq args KeygenCodecStaticBinding.node060 KeygenCodecStaticBinding.node089 s10 t rest
    obtain ⟨s12,e11,rest⟩ := normal_seq args KeygenCodecStaticBinding.node087 KeygenCodecStaticBinding.node088 s11 t rest
    have w3 := (KeygenCodecCellFrame.exec_frame "w".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "w".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((single_declaration args s s1 "w".toList .i32 .int32 (by decide +kernel) rfl e0)))
    obtain ⟨ptr,next,input,held,advance,load,lastPointer,inputW,lower,upper⟩ := input_read args s3 s4 .normal w3 e3
    have w5 := (KeygenCodecCellFrame.exec_frame "w".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans (inputW)
    have lo5 := (KeygenCodecCellFrame.exec_frame "lo".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "lo".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "lo".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((single_declaration args s1 s2 "lo".toList .u32 .uint32 (by decide +kernel) rfl e1))))
    have j5 := (KeygenCodecCellFrame.exec_frame "j".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s s1 .normal e0 (by decide +kernel)).trans (j)))))
    have mask6 := (KeygenCodecCellFrame.exec_frame "mask".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ s s1 .normal e0 (by decide +kernel)).trans (mask))))))
    have ne7 := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((single_declaration args s2 s3 "ne".toList .i32 .int32 (by decide +kernel) rfl e2)))))
    have acc8 := (KeygenCodecCellFrame.exec_frame "acc".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s s1 .normal e0 (by decide +kernel)).trans (acc))))))))
    have acc_len9 := (KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s8 s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s s1 .normal e0 (by decide +kernel)).trans (count)))))))))
    obtain ⟨mag6,sign6⟩ := sign_magnitude args s5 s6 .normal input.toInt lower upper w5 lo5 j5 e5
    have packed7 := KeygenCodecStaticLow9.low9_step args s6 s7 .normal input.toInt lower upper mag6 sign6 mask6 e6
    have mag7 := (KeygenCodecCellFrame.exec_frame "w".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans (mag6)
    have j7 := (KeygenCodecCellFrame.exec_frame "j".toList args _ s6 s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans (j5))
    have bounds := magnitude_bounds input.toInt lower upper
    obtain ⟨ne8,neLower,neUpper⟩ := quotient args s7 s8 .normal (magnitude input.toInt) bounds.1 bounds.2 mag7 j7 ne7 e7
    have packed8 := (KeygenCodecCellFrame.exec_frame "lo".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans (packed7)
    have j8 := (KeygenCodecCellFrame.exec_frame "j".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans (j7)
    have word9 := KeygenCodecStaticAppend.append_step args s8 s9 .normal word (KeygenCodecStaticLow9.packed input.toInt) acc8 j8 packed8 e8
    have j9 := (KeygenCodecCellFrame.exec_frame "j".toList args _ s8 s9 .normal e8 (by decide +kernel)).trans (j8)
    obtain ⟨pending11,word11⟩ := KeygenCodecStaticDrain.append_and_drain args s9 s10 s11 p _ small acc_len9 j9 word9 e9 e10
    have ne11 := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s10 s11 .normal e10 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s9 s10 .normal e9 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "ne".toList args _ s8 s9 .normal e8 (by decide +kernel)).trans (ne8)))
    obtain ⟨terminal,pending12,word12⟩ := KeygenCodecStaticUnaryInvariant.unary_invariant args s11 s12 e11
      (magnitude input.toInt/256) (by omega) neUpper ((p+9)%8) (Nat.mod_lt _ (by decide +kernel)) _ ne11 pending11 word11
    cases rest
    refine ⟨input,?_,?_⟩
    · simpa [nextPending,KeygenCodecStaticPending.Cell,scopeExit,
        show scopeObjects KeygenCodecStaticBinding.node100=
          [⟨"w".toList,.i32,none⟩,⟨"lo".toList,.u32,none⟩,⟨"ne".toList,.i32,none⟩] from rfl] using pending12
    · simpa [nextWord,KeygenCodecStaticUnaryInvariant.Acc,scopeExit,
        show scopeObjects KeygenCodecStaticBinding.node100=
          [⟨"w".toList,.i32,none⟩,⟨"lo".toList,.u32,none⟩,⟨"ne".toList,.i32,none⟩] from rfl] using word12

end FT1536.Source3.KeygenCodecStaticIteration
