import Source3.KeygenCodecStaticInit
import Source3.KeygenCodecStaticEmit
import Source3.KeygenCodecPointerFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Expose one common source prologue state, including the reserved-name
   absence, actual capacity, buffer and original input pointer. -/
namespace FT1536.Source3.KeygenCodecStaticEntry
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation KeygenCodecStaticProfile KeygenCodecControl
open KeygenCodecStaticInit

def prologue : Stmt := (.seq KeygenCodecStaticBinding.node000 (.seq KeygenCodecStaticBinding.node001 (.seq KeygenCodecStaticBinding.node002 (.seq KeygenCodecStaticBinding.node003 (.seq KeygenCodecStaticBinding.node016 (.seq KeygenCodecStaticBinding.node017 (.seq KeygenCodecStaticBinding.node018 (.seq KeygenCodecStaticBinding.node019 (.seq KeygenCodecStaticBinding.node020 (.seq KeygenCodecStaticBinding.node021 .skip))))))))))

/-- Complete source prologue, under just its concrete q/logn input profile.
    The coefficient loop and final padding remain the actual residual code. -/
theorem entry (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    ∃ start final, Initialized args start ∧ KeygenCodecStaticEmit.Ready args start ∧ start.locals.x=args.x ∧ start.heap=before ∧
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
    have prologueRun : Exec args prologue (initial args before) s10 .normal := (Exec.seq args KeygenCodecStaticBinding.node000 _ (initial args before) s1 s10 .normal e0 (Exec.seq args KeygenCodecStaticBinding.node001 _ s1 s2 s10 .normal e1 (Exec.seq args KeygenCodecStaticBinding.node002 _ s2 s3 s10 .normal e2 (Exec.seq args KeygenCodecStaticBinding.node003 _ s3 s4 s10 .normal e3 (Exec.seq args KeygenCodecStaticBinding.node016 _ s4 s5 s10 .normal e4 (Exec.seq args KeygenCodecStaticBinding.node017 _ s5 s6 s10 .normal e5 (Exec.seq args KeygenCodecStaticBinding.node018 _ s6 s7 s10 .normal e6 (Exec.seq args KeygenCodecStaticBinding.node019 _ s7 s8 s10 .normal e7 (Exec.seq args KeygenCodecStaticBinding.node020 _ s8 s9 s10 .normal e8 (Exec.seq args KeygenCodecStaticBinding.node021 _ s9 s10 s10 .normal e9 (Exec.skip args s10)))))))))))
    have buf1 : s1.locals.scalars "buf".toList=none := by
      cases e0 with
      | declare args s objects locals declarations =>
        have same : locals=(initial args before).locals := by
          simpa [declareLocals] using declarations.symm
        subst locals
        simp [declared,initial,initialLocals]
    have buf7Cell : s7.locals.scalars "buf".toList=s6.locals.scalars "buf".toList := by
      cases e6 with
      | bind => rfl
      | scalar args s name op rhs ty old value result locals notBuf => exact (notBuf rfl).elim
    have ready : KeygenCodecStaticEmit.Ready args s10 := ⟨buf10,
      ((KeygenCodecCellFrame.exec_frame "buf".toList args _ s9 s10 .normal e9 (by decide +kernel)).trans (((KeygenCodecCellFrame.exec_frame "buf".toList args _ s8 s9 .normal e8 (by decide +kernel)).trans (((KeygenCodecCellFrame.exec_frame "buf".toList args _ s7 s8 .normal e7 (by decide +kernel)).trans (buf7Cell.trans ((KeygenCodecCellFrame.exec_frame "buf".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "buf".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "buf".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "buf".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecCellFrame.exec_frame "buf".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans buf1))))))))))),
      (KeygenCodecCellFrame.exec_frame "NULL".toList args _ _ _ .normal prologueRun (by decide +kernel)).trans (by simp [initial,initialLocals]),
      (KeygenCodecCellFrame.exec_frame "max_out_len".toList args _ _ _ .normal prologueRun (by decide +kernel)).trans rfl⟩
    have pointer : s10.locals.x=args.x := KeygenCodecPointerFrame.exec_frame args _ _ _ .normal prologueRun (by decide +kernel)
    exact ⟨s10,t,cells,ready,pointer,(KeygenCodecStateFrame.heap_frame args _ (s9) s10 .normal e9 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s8) s9 .normal e8 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s7) s8 .normal e7 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s6) s7 .normal e6 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s5) s6 .normal e5 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s4) s5 .normal e4 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s3) s4 .normal e3 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s2) s3 .normal e2 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (s1) s2 .normal e1 (by decide +kernel)).trans ((KeygenCodecStateFrame.heap_frame args _ (initial args before) s1 .normal e0 (by decide +kernel)).trans (rfl)))))))))),rest,rfl⟩


end FT1536.Source3.KeygenCodecStaticEntry
