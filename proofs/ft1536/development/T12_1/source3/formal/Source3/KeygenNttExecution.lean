import Source3.KeygenNttTripleValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- The complete existing forwardBody, through common execution States.
   This module establishes its canonical, source-ordered butterfly array;
   the polynomial-evaluation identification is a separate mathematical seam. -/
namespace FT1536.Source3.KeygenNttExecution
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Stmt Exec)
open KeygenNttWordAlgebra (R)
open KeygenNttLoopSupport (USlot)
open KeygenNttButterflyCalls (U32Slot U32Declared)
open KeygenNttFirstComposition (Entry)
open KeygenNttMiddleValues (Args args_keep)
open KeygenNttControl (seq_inv keep_u64 keep_u32)
open KeygenNttForwardPrograms (glue)
open KeygenNttButterflyPrograms (chain)

def transform (a : Nat → R) : Nat → R :=
  KeygenNttTripleValues.values (KeygenNttMiddleValues.rounds
    (KeygenNttFirstValues.values a KeygenNttFirstValues.firstRoot) 8)

theorem glue_chain (codes : List Stmt) (tail : Stmt) (before : State) (out : Result)
    (source : Exec (glue (chain codes) tail) before out) : Exec (.seq (chain codes) tail) before out := by
  induction codes generalizing before out with
  | nil => exact .seqNormal _ _ before before out (.base _ _ _ (.skip before)) source
  | cons c cs ih =>
      change Exec (.seq c (glue (chain cs) tail)) before out at source
      cases source with
      | seqNormal _ _ _ middle _ head rest =>
          have composed := ih middle out rest
          cases composed with
          | seqNormal _ _ _ last _ first second =>
              exact .seqNormal _ _ before last out (.seqNormal _ _ before middle ⟨last,.normal⟩ head first) second
          | seqExit _ _ _ _ first exit =>
              exact .seqExit _ _ before out (.seqNormal _ _ before middle out head first) exit
      | seqExit _ _ _ _ head exit =>
          exact .seqExit _ _ before out (.seqExit _ _ before out head exit) exit

theorem first_trace_exit (p : ArrayPointer) (k : Nat) (before after : State)
    (trace : KeygenNttFirstLoop.FirstTrace p 1 k before after) : USlot after "u" 768 := by
  induction trace with
  | done k s stop inv =>
      have equal : k=768 := by have := inv.bound; omega
      simpa only [equal] using inv.counter
  | next _ _ _ _ _ _ _ _ _ _ ih => exact ih

theorem first_exit (before : State) (out : Result) (p gm : ArrayPointer) (p0i : BitVec 32)
    (args : Args p gm p0i before) (wc : U32Declared before "w")
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old)) (hn : USlot before "hn" 768)
    (source : Exec KeygenNttForwardPrograms.firstPass before out) :
    U32Declared out.state "w" ∧ USlot out.state "u" 768 := by
  obtain ⟨s1,load,tail1⟩ := seq_inv _ _ before out (by decide) source
  obtain ⟨s2,loop,tail2⟩ := seq_inv _ _ s1 out (by decide) tail1
  obtain ⟨w,_,slot,_,_,_,_⟩ := KeygenNttButterflyCalls.assign32_result (fun _ => True) before "w" _ ⟨s1,.normal⟩ wc load
    (by
      intro v ev
      obtain ⟨q,w,_,_,hv⟩ := KeygenNttButterflyCalls.load_exists before "gm" _ v ev
      exact ⟨w,hv,trivial⟩)
  obtain ⟨old,ucell⟩ := uc
  have uc1 : ∃ old, s1.locals "u".toList=some (.uint64,old) :=
    ⟨old,((KeygenNttControl.frame _ _ _ (by decide) load).2.1 "u".toList (by decide)).trans ucell⟩
  have args1 := args_keep load (by decide) args
  obtain ⟨_,s0,_,trace⟩ := KeygenNttFirstLoop.first_result p 1 s1 ⟨s2,.normal⟩ (by decide) (by decide) loop uc1
    (keep_u64 load (by decide) "hn" 768 (by decide) hn) args1.stride args1.array
  rw [C99ModularReference.skip_result s2 out tail2]
  exact ⟨⟨some (.uint32 w),keep_u32 loop (by decide) "w" w (by decide) slot⟩,first_trace_exit p 0 s0 s2 trace⟩

theorem source_values (before : State) (out : Result) (p gm : ArrayPointer) (p0i : BitVec 32) (a : Nat → R)
    (entry : Entry before p gm p0i) (pw : p.elementBytes=4) (gw : gm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes p 6144 gm 4096)
    (input : KeygenNttCells.Cells before.heap p 1536 a) (table : KeygenMkgm3Table.Initialized before.heap gm)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec KeygenNttForwardPrograms.forwardBody before out) :
    out.flow=.normal ∧ KeygenNttCells.Cells out.state.heap p 1536 (transform a) ∧
      KeygenMkgm3Table.Initialized out.state.heap gm ∧ KeygenNttFirstValues.Frame before.heap out.state.heap p := by
  have split0 := glue_chain _ _ before out source
  obtain ⟨ready,prologue,rest⟩ := (KeygenNttForwardExec.seq_inv _ _ before out split0).resolve_right
    (by
      rintro ⟨r,hr,hn,he⟩
      subst r
      exact hn (congrArg Result.flow (KeygenNttForwardExec.prologue_result before out entry.logn entry.full hr)))
  have readyEq := congrArg Result.state (KeygenNttForwardExec.prologue_result before ⟨ready,.normal⟩ entry.logn entry.full prologue)
  dsimp only at readyEq
  subst ready
  have split1 := glue_chain _ _ (KeygenNttForwardExec.ready before) out rest
  obtain ⟨first,firstPass,rest1⟩ := seq_inv _ _ _ out (by decide) split1
  have split2 := glue_chain _ _ first out rest1
  obtain ⟨middle,middlePass,triplePass⟩ := seq_inv _ _ first out (by decide) split2
  have args0 : Args p gm p0i (KeygenNttForwardExec.ready before) :=
    ⟨entry.prime,entry.inverse,entry.stride,entry.array,entry.table⟩
  have hn0 : USlot (KeygenNttForwardExec.ready before) "hn" 768 := KeygenNttForwardExec.ready_hn_slot before
  have nc0 : USlot (KeygenNttForwardExec.ready before) "n" 1536 := KeygenNttForwardExec.ready_n_slot before
  obtain ⟨_,firstCells,firstFrame⟩ := KeygenNttFirstValues.pass_values _ ⟨first,.normal⟩ p gm a p0i pw ⟨none,rfl⟩
    args0.prime args0.inverse args0.stride hn0 ⟨none,rfl⟩ args0.array args0.table input table initialization firstPass
  have firstTable := KeygenNttFirstComposition.table_preserved _ _ p gm pw gw separate table firstFrame
  have args1 := args_keep firstPass (by decide) args0
  have local1 := (KeygenNttControl.frame _ _ _ (by decide) firstPass).2.1
  obtain ⟨_,middleCells,middleTable,middleFrame⟩ := KeygenNttMiddleValues.intermediate_values first ⟨middle,.normal⟩
    p gm p0i _ pw gw separate args1 (keep_u64 firstPass (by decide) "hn" 768 (by decide) hn0)
    ⟨none,local1 "t".toList (by decide)⟩ ⟨none,local1 "m".toList (by decide)⟩
    ((local1 "full".toList (by decide)).trans entry.full) firstCells firstTable initialization middlePass
  obtain ⟨wc1,uc1⟩ := first_exit _ ⟨first,.normal⟩ p gm p0i args0 ⟨none,rfl⟩ ⟨none,rfl⟩ hn0 firstPass
  obtain ⟨oldw,wslot⟩ := wc1
  have local2 := (KeygenNttControl.frame _ _ _ (by decide) middlePass).2.1
  have uc2 := keep_u64 middlePass (by decide) "u" 768 (by decide) uc1
  obtain ⟨flow,cells,tableOut,tripleFrame⟩ := KeygenNttTripleValues.pass_values middle out p gm _ p0i pw gw separate
    (args_keep middlePass (by decide) args1) ⟨oldw,(local2 "w".toList (by decide)).trans wslot⟩
    ⟨some (KeygenNttLoopSupport.u64 768),uc2⟩
    ⟨none,(local2 "r".toList (by decide)).trans (local1 "r".toList (by decide))⟩
    ((local2 "logn".toList (by decide)).trans ((local1 "logn".toList (by decide)).trans entry.logn))
    ((local2 "full".toList (by decide)).trans ((local1 "full".toList (by decide)).trans entry.full))
    (keep_u64 middlePass (by decide) "n" 1536 (by decide) (keep_u64 firstPass (by decide) "n" 1536 (by decide) nc0))
    middleCells middleTable initialization triplePass
  exact ⟨flow,cells,tableOut,fun q z outside cell => tripleFrame q z outside
    (middleFrame q z outside (firstFrame q z outside cell))⟩

end FT1536.Source3.KeygenNttExecution
