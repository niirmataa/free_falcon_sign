import Source3.KeygenCodecScalarCalculation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticProfile
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation KeygenCodecControl

abbrev IV := C99IntegerReference.Value

def Cell (name : Name) (ty : C99IntegerReference.Ty) (v : IV) (l : Locals) : Prop :=
  l.scalars name=some (ty,some v)

theorem assignment (args : Args) (s t : State) (flow : Flow) (name : Name)
    (ty : C99IntegerReference.Ty) (old : Option IV) (rhs : Expr) (v : IV)
    (cell : s.locals.scalars name=some (ty,old)) (calculation : Computes s.locals rhs v)
    (source : Exec args (.write (.variable name) .set rhs) s t flow) :
    Cell name ty (C99IntegerReference.convert ty v.integer) t.locals := by
  rw [(assign_set args s t flow name ty old rhs v cell calculation source).1]
  simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true]

theorem declarations (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node003 s t flow) :
    t.locals.scalars "j".toList=some (.int32,none) ∧
    t.locals.scalars "acc_len".toList=some (.int32,none) := by
  cases source with
  | declare args s objects locals declarations =>
    have same : locals=localSet (localSet s.locals "acc_len".toList .int32 none) "j".toList .int32 none := by
      simpa [KeygenCodecStaticBinding.node003,declareLocals,scalarTy] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

theorem branch_j (args : Args) (s t : State) (flow : Flow)
    (qCell : Cell "q".toList .uint32 (.uint32 18433) s.locals)
    (jCell : s.locals.scalars "j".toList=some (.int32,none))
    (source : Exec args KeygenCodecStaticBinding.node016 s t flow) :
    Cell "j".toList .int32 (.int32 8) t.locals := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    have zero := (KeygenCodecNoneResult.q_test args s locals value qCell evaluated).1
    rw [zero] at yes
    cases yes
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    have same := (KeygenCodecNoneResult.q_test args s locals value qCell evaluated).2
    subst locals
    cases selected with
    | scope args a s t flow noBufShadow inside =>
      obtain ⟨middle,first,rest⟩ := seq_split args KeygenCodecStaticBinding.node010 KeygenCodecStaticBinding.node013 s t flow inside (by rfl)
      obtain ⟨last,second,rest⟩ := seq_split args KeygenCodecStaticBinding.node011 KeygenCodecStaticBinding.node012 middle t flow rest (by rfl)
      have kept := (KeygenCodecCellFrame.exec_frame "j".toList args _ s middle .normal first (by decide +kernel)).trans jCell
      have written := assignment args middle last .normal "j".toList .int32 none (.number .i32 8) (.int32 8)
        kept (.number _ _ _ (by decide +kernel)) second
      cases rest
      exact written

theorem prologue_split (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    ∃ start final, Cell "j".toList .int32 (.int32 8) start.locals ∧
      Exec args KeygenCodecStaticBinding.node129 start final flow ∧ after.heap=final.heap := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨s1,e0,rest⟩ := seq_split args KeygenCodecStaticBinding.node000 KeygenCodecStaticBinding.node133 _ t flow inside (by rfl)
    obtain ⟨s2,e1,rest⟩ := seq_split args KeygenCodecStaticBinding.node001 KeygenCodecStaticBinding.node132 s1 t flow rest (by rfl)
    obtain ⟨s3,e2,rest⟩ := seq_split args KeygenCodecStaticBinding.node002 KeygenCodecStaticBinding.node131 s2 t flow rest (by rfl)
    obtain ⟨s4,e3,rest⟩ := seq_split args KeygenCodecStaticBinding.node003 KeygenCodecStaticBinding.node130 s3 t flow rest (by rfl)
    obtain ⟨start,branch,rest⟩ := seq_split args KeygenCodecStaticBinding.node016 KeygenCodecStaticBinding.node129 s4 t flow rest (by decide +kernel)
    have qc0 := KeygenCodecCellFrame.exec_frame "q".toList args _ _ s1 .normal e0 (by decide +kernel)
    have qc1 := KeygenCodecCellFrame.exec_frame "q".toList args _ s1 s2 .normal e1 (by decide +kernel)
    have qc2 := KeygenCodecCellFrame.exec_frame "q".toList args _ s2 s3 .normal e2 (by decide +kernel)
    have qc3 := KeygenCodecCellFrame.exec_frame "q".toList args _ s3 s4 .normal e3 (by decide +kernel)
    have qc : Cell "q".toList .uint32 (.uint32 18433) s4.locals := by
      simpa [Cell,initial,initialLocals,q] using qc3.trans (qc2.trans (qc1.trans qc0))
    exact ⟨start,t,branch_j args s4 start .normal qc (declarations args s3 s4 .normal e3).1 branch,rest,rfl⟩

/-- j8 is derived from the complete source prologue, and the actual
    remaining body cannot change it, including rejected finite paths. -/
theorem prologue_j_frame (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433)
    (source : Exec args KeygenCodecStaticBinding.code (initial args before) after flow) :
    ∃ start final, Cell "j".toList .int32 (.int32 8) start.locals ∧
      Cell "j".toList .int32 (.int32 8) final.locals ∧
      Exec args KeygenCodecStaticBinding.node129 start final flow ∧ after.heap=final.heap := by
  obtain ⟨start,final,cell,rest,heap⟩ := prologue_split args before after flow q source
  exact ⟨start,final,cell,(KeygenCodecCellFrame.exec_frame "j".toList args _ start final flow rest (by decide +kernel)).trans cell,rest,heap⟩

end FT1536.Source3.KeygenCodecStaticProfile
