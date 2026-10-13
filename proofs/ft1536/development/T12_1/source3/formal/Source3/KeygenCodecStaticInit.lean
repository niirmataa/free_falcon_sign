import Source3.KeygenCodecStaticProfile

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual STATIC initialization. The internal activation is exposed before
   the coefficient loop; no return value, output length or frame is assumed. -/
namespace FT1536.Source3.KeygenCodecStaticInit
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation KeygenCodecStaticProfile KeygenCodecControl

def Initialized (args : Args) (s : State) : Prop :=
  Cell "j".toList .int32 (.int32 8) s.locals ∧
  Cell "n".toList .uint64 (.uint64 1536) s.locals ∧
  Cell "mask".toList .uint32 (.uint32 255) s.locals ∧
  Cell "u".toList .uint64 (.uint64 0) s.locals ∧
  Cell "acc".toList .uint32 (.uint32 0) s.locals ∧
  Cell "acc_len".toList .int32 (.int32 0) s.locals ∧ s.buf=some args.out

theorem n_calculation (l : Locals)
    (logn : Cell "logn".toList .uint32 (.uint32 10) l) :
    Computes l (.binary .shl (.cast .size (.number .i32 3))
      (.binary .sub (.variable "logn".toList) (.number .i32 1))) (.uint64 1536) := by
  apply Computes.binary _ _ _ (.uint64 3) (.uint32 9) (.uint64 1536)
  · exact .cast .size _ (.int32 3) (.uint64 3) (.number _ _ _ (by decide +kernel)) (by decide +kernel)
  · apply Computes.binary _ _ _ (.uint32 10) (.int32 1) (.uint32 9)
    · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) logn
    · exact .number _ _ _ (by decide +kernel)
    · exact .sub _ _ _ ((C99IntegerReference.arithmetic_iff _ _ _ _).mpr (by exact ⟨(by intro h; cases h),rfl⟩))
  · exact .shl _ _ _ (.unsignedLeft (.uint64 3) (.uint32 9) 9 (by decide +kernel) rfl (by decide +kernel))

theorem mask_calculation (l : Locals)
    (j : Cell "j".toList .int32 (.int32 8) l) :
    Computes l (.binary .sub (.binary .shl (.number .u32 1) (.variable "j".toList))
      (.number .u32 1)) (.uint32 255) := by
  apply Computes.binary _ _ _ (.uint32 256) (.uint32 1) (.uint32 255)
  · apply Computes.binary _ _ _ (.uint32 1) (.int32 8) (.uint32 256)
    · exact .number _ _ _ (by decide +kernel)
    · exact .scalar _ _ _ (by unfold Ordinary; decide +kernel) j
    · exact .shl _ _ _ (.unsignedLeft (.uint32 1) (.int32 8) 8 (by decide +kernel) rfl (by decide +kernel))
  · exact .number _ _ _ (by decide +kernel)
  · exact .sub _ _ _ ((C99IntegerReference.arithmetic_iff _ _ _ _).mpr (by exact ⟨(by intro h; cases h),rfl⟩))

theorem branch_n (args : Args) (s t : State) (flow : Flow)
    (q : Cell "q".toList .uint32 (.uint32 18433) s.locals)
    (logn : Cell "logn".toList .uint32 (.uint32 10) s.locals)
    (n : s.locals.scalars "n".toList=some (.uint64,none))
    (source : Exec args KeygenCodecStaticBinding.node016 s t flow) :
    Cell "n".toList .uint64 (.uint64 1536) t.locals := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    rw [(KeygenCodecNoneResult.q_test args s locals value q evaluated).1] at yes
    cases yes
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    have same := (KeygenCodecNoneResult.q_test args s locals value q evaluated).2
    subst locals
    cases selected with
    | scope args a s t flow noBufShadow inside =>
      obtain ⟨m,first,rest⟩ := seq_split args KeygenCodecStaticBinding.node010 KeygenCodecStaticBinding.node013 s t flow inside (by rfl)
      have written := assignment args s m .normal "n".toList .uint64 none _ (.uint64 1536) n (n_calculation s.locals logn) first
      exact (KeygenCodecCellFrame.exec_frame "n".toList args _ m t flow rest (by decide +kernel)).trans written

theorem size_declarations (args : Args) (s t : State)
    (source : Exec args KeygenCodecStaticBinding.node001 s t .normal) :
    t.locals.scalars "n".toList=some (.uint64,none) ∧
    t.locals.scalars "u".toList=some (.uint64,none) := by
  cases source with
  | declare args s objects locals declarations =>
    have same : locals=localSet (localSet s.locals "n".toList .uint64 none) "u".toList .uint64 none := by
      simpa [KeygenCodecStaticBinding.node001,declareLocals,scalarTy] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

theorem word_declarations (args : Args) (s t : State)
    (source : Exec args KeygenCodecStaticBinding.node002 s t .normal) :
    t.locals.scalars "acc".toList=some (.uint32,none) ∧
    t.locals.scalars "mask".toList=some (.uint32,none) := by
  cases source with
  | declare args s objects locals declarations =>
    have same : locals=localSet (localSet s.locals "acc".toList .uint32 none) "mask".toList .uint32 none := by
      simpa [KeygenCodecStaticBinding.node002,declareLocals,scalarTy] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

/-- Complete source prologue, under just its concrete q/logn input profile.
    The coefficient loop and final padding remain the actual residual code. -/
theorem initialization (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    ∃ start final, Initialized args start ∧ start.heap=before ∧
      Exec args KeygenCodecStaticBinding.node124 start final flow ∧ after.heap=final.heap := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨s1,e0,rest⟩ := seq_split args KeygenCodecStaticBinding.node000 KeygenCodecStaticBinding.node133 (initial args before) t flow inside (by decide +kernel)
    obtain ⟨s2,e1,rest⟩ := seq_split args KeygenCodecStaticBinding.node001 KeygenCodecStaticBinding.node132 (s1) t flow rest (by decide +kernel)
    obtain ⟨s3,e2,rest⟩ := seq_split args KeygenCodecStaticBinding.node002 KeygenCodecStaticBinding.node131 (s2) t flow rest (by decide +kernel)
    obtain ⟨s4,e3,rest⟩ := seq_split args KeygenCodecStaticBinding.node003 KeygenCodecStaticBinding.node130 (s3) t flow rest (by decide +kernel)
    obtain ⟨s5,e4,rest⟩ := seq_split args KeygenCodecStaticBinding.node016 KeygenCodecStaticBinding.node129 (s4) t flow rest (by decide +kernel)
    obtain ⟨s6,e5,rest⟩ := seq_split args KeygenCodecStaticBinding.node017 KeygenCodecStaticBinding.node128 (s5) t flow rest (by decide +kernel)
    obtain ⟨s7,e6,rest⟩ := seq_split args KeygenCodecStaticBinding.node018 KeygenCodecStaticBinding.node127 (s6) t flow rest (by decide +kernel)
    obtain ⟨s8,e7,rest⟩ := seq_split args KeygenCodecStaticBinding.node019 KeygenCodecStaticBinding.node126 (s7) t flow rest (by decide +kernel)
    obtain ⟨s9,e8,rest⟩ := seq_split args KeygenCodecStaticBinding.node020 KeygenCodecStaticBinding.node125 (s8) t flow rest (by decide +kernel)
    obtain ⟨s10,e9,rest⟩ := seq_split args KeygenCodecStaticBinding.node021 KeygenCodecStaticBinding.node124 (s9) t flow rest (by decide +kernel)
    have q0 : Cell "q".toList .uint32 (.uint32 18433) (initial args before).locals := by simp [Cell,initial,initialLocals,q]
    have q4 := (KeygenCodecCellFrame.exec_frame "q".toList args _ (s3) s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "q".toList args _ (s2) s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "q".toList args _ (s1) s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "q".toList args _ (initial args before) s1 .normal e0 (by decide +kernel)).trans (q0))))
    have logn0 : Cell "logn".toList .uint32 (.uint32 10) (initial args before).locals := by simp [Cell,initial,initialLocals,logn]
    have logn4 := (KeygenCodecCellFrame.exec_frame "logn".toList args _ (s3) s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "logn".toList args _ (s2) s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "logn".toList args _ (s1) s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "logn".toList args _ (initial args before) s1 .normal e0 (by decide +kernel)).trans (logn0))))
    have n4 := (KeygenCodecCellFrame.exec_frame "n".toList args _ (s3) s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "n".toList args _ (s2) s3 .normal e2 (by decide +kernel)).trans ((size_declarations args s1 s2 e1).1))
    have u4 := (KeygenCodecCellFrame.exec_frame "u".toList args _ (s3) s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "u".toList args _ (s2) s3 .normal e2 (by decide +kernel)).trans ((size_declarations args s1 s2 e1).2))
    have acc4 := (KeygenCodecCellFrame.exec_frame "acc".toList args _ (s3) s4 .normal e3 (by decide +kernel)).trans ((word_declarations args s2 s3 e2).1)
    have mask4 := (KeygenCodecCellFrame.exec_frame "mask".toList args _ (s3) s4 .normal e3 (by decide +kernel)).trans ((word_declarations args s2 s3 e2).2)
    have j4 := (declarations args s3 s4 .normal e3).1
    have acc_len4 := (declarations args s3 s4 .normal e3).2
    have n5 := branch_n args s4 s5 .normal q4 logn4 n4 e4
    have j5 := branch_j args s4 s5 .normal q4 j4 e4
    have mask5 := (KeygenCodecCellFrame.exec_frame "mask".toList args _ (s4) s5 .normal e4 (by decide +kernel)).trans (mask4)
    have u5 := (KeygenCodecCellFrame.exec_frame "u".toList args _ (s4) s5 .normal e4 (by decide +kernel)).trans (u4)
    have acc5 := (KeygenCodecCellFrame.exec_frame "acc".toList args _ (s4) s5 .normal e4 (by decide +kernel)).trans (acc4)
    have acc_len5 := (KeygenCodecCellFrame.exec_frame "acc_len".toList args _ (s4) s5 .normal e4 (by decide +kernel)).trans (acc_len4)
    have mask6 := assignment args s5 s6 .normal "mask".toList .uint32 none _ (.uint32 255) mask5 (mask_calculation s5.locals j5) e5
    have u8 := assignment args s7 s8 .normal "u".toList .uint64 none (.number .i32 0) (.int32 0) ((KeygenCodecCellFrame.exec_frame "u".toList args _ (s6) s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "u".toList args _ (s5) s6 .normal e5 (by decide +kernel)).trans (u5))) (.number _ _ _ (by decide +kernel)) e7
    have acc9 := assignment args s8 s9 .normal "acc".toList .uint32 none (.number .i32 0) (.int32 0) ((KeygenCodecCellFrame.exec_frame "acc".toList args _ (s7) s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ (s6) s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc".toList args _ (s5) s6 .normal e5 (by decide +kernel)).trans (acc5)))) (.number _ _ _ (by decide +kernel)) e8
    have acc_len10 := assignment args s9 s10 .normal "acc_len".toList .int32 none (.number .i32 0) (.int32 0) ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ (s8) s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ (s7) s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ (s6) s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ (s5) s6 .normal e5 (by decide +kernel)).trans (acc_len5))))) (.number _ _ _ (by decide +kernel)) e9
    have buf7 : s7.buf=some args.out := by
      cases e6 with
      | bind => rfl
      | scalar args s name op rhs ty old value result locals notBuf => exact False.elim (notBuf rfl)
    have buf10 := (KeygenCodecStateFrame.buf_frame args _ s9 s10 .normal e9 (by decide +kernel)).trans ((KeygenCodecStateFrame.buf_frame args _ s8 s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecStateFrame.buf_frame args _ s7 s8 .normal e7 (by decide +kernel)).trans (buf7)))
    have cells : Initialized args s10 := ⟨(KeygenCodecCellFrame.exec_frame "j".toList args _ (s9) s10 .normal e9 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ (s8) s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ (s7) s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ (s6) s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "j".toList args _ (s5) s6 .normal e5 (by decide +kernel)).trans (j5))))),
      (KeygenCodecCellFrame.exec_frame "n".toList args _ (s9) s10 .normal e9 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "n".toList args _ (s8) s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "n".toList args _ (s7) s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "n".toList args _ (s6) s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "n".toList args _ (s5) s6 .normal e5 (by decide +kernel)).trans (n5))))),
      (KeygenCodecCellFrame.exec_frame "mask".toList args _ (s9) s10 .normal e9 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ (s8) s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ (s7) s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "mask".toList args _ (s6) s7 .normal e6 (by decide +kernel)).trans (mask6)))),
      (KeygenCodecCellFrame.exec_frame "u".toList args _ (s9) s10 .normal e9 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "u".toList args _ (s8) s9 .normal e8 (by decide +kernel)).trans (u8)),
      (KeygenCodecCellFrame.exec_frame "acc".toList args _ (s9) s10 .normal e9 (by decide +kernel)).trans (acc9),
      acc_len10,
      buf10⟩
    exact ⟨s10,t,cells,(KeygenCodecStateFrame.heap_frame args _ (s9) s10 .normal e9 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s8) s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s7) s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s6) s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s5) s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s4) s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s3) s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s2) s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s1) s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (initial args before) s1 .normal e0 (by decide +kernel)).trans (rfl)))))))))),rest,rfl⟩

end FT1536.Source3.KeygenCodecStaticInit
