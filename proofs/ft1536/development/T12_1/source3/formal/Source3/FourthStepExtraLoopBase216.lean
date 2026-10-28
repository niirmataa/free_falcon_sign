import Source3.FourthStepExtraInner216
import Source3.FourthStepCrtFirst216
import Source3.KeygenMakeEntry

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source control, separation and pinned rows for the d4 extra-prime loop. -/
namespace FT1536.Source3.FourthStepExtraLoopBase216
open C99ArrayReference (State Name restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SecondStepProduct203 (root)
open FourthStepLayout216 (fd gd fs gs gm igm t1)
open SecondStepGeometry203 (scratch ordered)
open KeygenFullData127 (primes rev)
open KeygenStaticTables (values)
open FourthStepGenerator216 (Basic Outer rxVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open ZintNormWalkFlat208 (Data)
open StepProductFixed203 (Image)
open FourthStepExtraPair216 (sWords)
open FourthStepExtraInner216 (Earlier)

def LoopKeep (s out : State) : Prop :=
  ∀ q old, (∀ i, i < 64 → Separate (elem t1 i) q) →
    (∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 64 q.block (q.offset+byte.val)) →
    MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
    (∀ u, u < 12 → ∀ i, i < 32 → Separate (addr fd u i 12) q) →
    (∀ u, u < 12 → ∀ i, i < 32 → Separate (addr gd u i 12) q) →
    Load32 s.heap q old → Load32 out.heap q old

theorem loopPremises (u : Nat) (hu : u<12) (q : ArrayPointer)
    (t1s : ∀ i, i < 64 → Separate (elem t1 i) q)
    (frame : ∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 64 q.block (q.offset+byte.val))
    (gmOut : MkgmCallKeep203.Outside gm q) (igmOut : MkgmCallKeep203.Outside igm q)
    (fdSep : ∀ u, u < 12 → ∀ i, i < 32 → Separate (addr fd u i 12) q)
    (gdSep : ∀ u, u < 12 → ∀ i, i < 32 → Separate (addr gd u i 12) q) : Earlier u q :=
  And.intro (And.intro (And.intro t1s (And.intro frame (fun i => fdSep u hu i.val i.isLt)))
      (And.intro t1s (And.intro frame (fun i => gdSep u hu i.val i.isLt))))
    (And.intro gmOut igmOut)

/- Column separations across additional loop indices. -/
theorem outside_cols (side source : Side) (u' u : Nat) (hu' : u'<12) (hu : u<12) (hne : u'≠u)
    (i : Fin 32) : FourthStepExtraPair216.Outside side u' (addr (root source) u i.val 12) := by
  have before : addr (root source) u i.val 12 = scratch ((root source).index+u+i.val*12) := by
    cases source <;> rfl
  have ibound : (root source).index+u+i.val*12<2334 := by
    cases source
    · change 670+u+i.val*12<2334; have b:=i.isLt; omega
    · change 1054+u+i.val*12<2334; have b:=i.isLt; omega
  rw [before]
  refine ⟨(FourthStepExtraPair216.before_t1 _ ibound).1,(FourthStepExtraPair216.before_t1 _ ibound).2,?_⟩
  intro j
  cases side <;> cases source
  · change Separate (scratch (670+u'+j.val*12)) (scratch (670+u+i.val*12))
    exact FourthStepExtraSide216.sep_at (by have b:=j.isLt; omega)
  · change Separate (scratch (670+u'+j.val*12)) (scratch (1054+u+i.val*12))
    exact FourthStepExtraSide216.sep_at (by have b:=j.isLt; omega)
  · change Separate (scratch (1054+u'+j.val*12)) (scratch (670+u+i.val*12))
    exact FourthStepExtraSide216.sep_at (by have b:=j.isLt; omega)
  · change Separate (scratch (1054+u'+j.val*12)) (scratch (1054+u+i.val*12))
    exact FourthStepExtraSide216.sep_at (by have b:=j.isLt; omega)

theorem gm_cols (source : Side) (u i : Nat) (hu : u<12) (ib : i<32) :
    MkgmCallKeep203.Outside gm (addr (root source) u i 12) := by
  intro byte; right; left
  cases source
  · change 0+4*(670+u+i*12)+byte.val<0+4*2206
    have b:=byte.isLt; omega
  · change 0+4*(1054+u+i*12)+byte.val<0+4*2206
    have b:=byte.isLt; omega

theorem igm_cols (source : Side) (u i : Nat) (hu : u<12) (ib : i<32) :
    MkgmCallKeep203.Outside igm (addr (root source) u i 12) := by
  intro byte; right; left
  cases source
  · change 0+4*(670+u+i*12)+byte.val<0+4*2270
    have b:=byte.isLt; omega
  · change 0+4*(1054+u+i*12)+byte.val<0+4*2270
    have b:=byte.isLt; omega

theorem t1_cols (source : Side) (u i : Nat) (hu : u<12) (ib : i<32) :
    (∀ j, j < 64 → Separate (elem t1 j) (addr (root source) u i 12)) ∧
    (∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 64 (addr (root source) u i 12).block
      ((addr (root source) u i 12).offset+byte.val)) := by
  cases source
  · exact FourthStepExtraPair216.before_t1 (670+u+i*12) (by omega)
  · exact FourthStepExtraPair216.before_t1 (1054+u+i*12) (by omega)

/- Readonly transports across any executed statement of the loop. -/
theorem object_keep {s out : State} {code : KeygenMakeFgSource.Stmt}
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) (run : Exec code s ⟨out,.normal⟩) :
    KeygenStaticTables.PrimeObject out.heap primes .ternary := by
  have stable:=KeygenHelperStability.make _ _ _ run
  have block : KeygenMakeObjects.Block s.heap out.heap primes.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset object.2.2.2.1⟩
  exact KeygenMakeEntry.prime_block _ _ primes block object

theorem rev_keep {s out : State} {code : KeygenMakeFgSource.Stmt}
    (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev) (run : Exec code s ⟨out,.normal⟩) :
    KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  have stable:=KeygenHelperStability.make _ _ _ run
  have block : KeygenMakeObjects.Block s.heap out.heap rev.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset revS.1⟩
  exact KeygenMakeEntry.rev_block _ _ rev block revS

theorem revB_keep {s out : State} {code : KeygenMakeFgSource.Stmt}
    (revB : s.tables "REV10".toList=some rev) (run : Exec code s ⟨out,.normal⟩) :
    out.tables "REV10".toList=some rev :=
  (congrFun (KeygenTables204.make _ _ _ run) "REV10".toList).trans revB

/- Scope/counter machinery of the counted loop. -/
def scopedState (s out : State) := restoreScope s out MakeFgAddPrimeShape194.localNames MakeFgAddPrimeShape194.pointerNames
def counter (s out : State) (k : Nat) := FftLocalCells140.put (scopedState s out) "u".toList (C99NatWord141.word k)

theorem scoped_local (s out : State) (name : Name) (absent : name∉MakeFgAddPrimeShape194.localNames) :
    (scopedState s out).locals name=out.locals name := by
  simp only [scopedState,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,absent,ite_false]

theorem scope_source (s out : State) (run : Exec MakeFgAddPrimeShape194.aInner s ⟨out,.normal⟩) :
    Exec MakeFgAddPrimeShape194.aBody s ⟨scopedState s out,.normal⟩ := by
  rw [MakeFgAddPrimeShape194.body_shape]
  exact .scope _ _ _ s ⟨out,.normal⟩ run

theorem put_same (s : State) (name : Name) (w : BitVec 64)
    (cell : s.locals name=some (.uint64,some (.uint64 w))) : FftLocalCells140.put s name w=s := by
  have eq : C99ScalarReference.set s.locals name (.uint64,some (.uint64 w))=s.locals := by
    funext other
    by_cases same : other=name
    · subst other; simp only [C99ScalarReference.set,ite_true]; exact cell.symm
    · simp only [C99ScalarReference.set,same,ite_false]
  change {s with locals:=C99ScalarReference.set s.locals name (.uint64,some (.uint64 w))}=s
  rw [eq]

theorem init_source (s : State) (h : Outer s 6) : Exec MakeFgAddPrimeShape194.aInit s ⟨s,.normal⟩ := by
  have run : Exec MakeFgAddPrimeShape194.initU s ⟨CrtState205.set64 s "u" 6,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 (some (.uint64 6)) (.uint64 6) h.uCell
      (.scalar _ _ (.variable _ _ _ h.slenCell))))
  rw [MakeFgAddPrimeShape194.init_shape]
  have eq : CrtState205.set64 s "u" 6=s := (FftLocalCells140.put_bind s "u".toList 6).symm.trans
    (put_same s "u".toList 6 h.uCell)
  simpa only [eq] using run

theorem incrementK (s out : State) (k : Nat) (kb : k<12) (u : Cell out "u".toList k) :
    Exec MakeFgAddPrimeShape194.aInc (scopedState s out) ⟨counter s out (k+1),.normal⟩ := by
  have cell : Cell (scopedState s out) "u".toList k := (scoped_local s out _ (by decide)).trans u
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (MakeFgTailShape190.num 1))) (scopedState s out) (counter s out (k+1)) := by
    cases C99LoopScalar141.increment (fun _ => none) (scopedState s out) "u".toList k (by omega) cell with
    | base _ _ _ source => exact source
  rw [MakeFgAddPrimeShape194.inc_shape]
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem counter_u (s out : State) (k : Nat) : Cell (counter s out k) "u".toList k :=
  FftLocalCells140.cell_at _ _ _

theorem counter_tlen (s out : State) (k : Nat) (tlen : Cell out "tlen".toList 12) :
    Cell (counter s out k) "tlen".toList 12 :=
  (FftLocalCells140.outside (scopedState s out) "u".toList "tlen".toList _ (by decide)).trans
    ((scoped_local s out "tlen".toList (by decide)).trans tlen)

theorem counter_heap (s out : State) (k : Nat) : (counter s out k).heap=out.heap := rfl

theorem counter_arrays (s out : State) (k : Nat) (name : Name) :
    (counter s out k).arrays name=(scopedState s out).arrays name := rfl

theorem scope_arrays (s out : State) (name : Name) (absent : name∉MakeFgAddPrimeShape194.pointerNames) :
    (scopedState s out).arrays name=out.arrays name := by
  change (if MakeFgAddPrimeShape194.pointerNames.contains name then s.arrays name else out.arrays name)=out.arrays name
  simp only [List.contains_iff_mem,absent,ite_false]

theorem outer_counter {out : State} {k : Nat} {p pp rr : BitVec 32} (b : Basic out k p pp rr)
    (before : State) (j : Nat) : Outer (counter before out j) j := by
  have loc (name : Name) (notU : name≠"u".toList) (absent : name∉MakeFgAddPrimeShape194.localNames) :
      (counter before out j).locals name=out.locals name :=
    (FftLocalCells140.outside (scopedState before out) "u".toList name (C99NatWord141.word j) notU).trans
      (scoped_local before out name absent)
  have arr (name : Name) (absent : name∉MakeFgAddPrimeShape194.pointerNames) :
      (counter before out j).arrays name=out.arrays name :=
    (counter_arrays before out j name).trans (scope_arrays before out name absent)
  refine ⟨(loc _ (by decide) (by decide)).trans b.nCell,(loc _ (by decide) (by decide)).trans b.hnCell,
    (loc _ (by decide) (by decide)).trans b.slenCell,(loc _ (by decide) (by decide)).trans b.tlenCell,
    FftLocalCells140.cell_at _ _ _,(loc _ (by decide) (by decide)).trans b.lognCell,
    (loc _ (by decide) (by decide)).trans b.terCell,
    (loc _ (by decide) (by decide)).trans b.inCell,(loc _ (by decide) (by decide)).trans b.outCell,
    (arr _ (by decide)).trans b.fdBinding,(arr _ (by decide)).trans b.gdBinding,
    (arr _ (by decide)).trans b.fsBinding,(arr _ (by decide)).trans b.gsBinding,
    (arr _ (by decide)).trans b.gmBinding,(arr _ (by decide)).trans b.igmBinding,
    (arr _ (by decide)).trans b.t1Binding,(arr _ (by decide)).trans b.primesBinding,?_,?_⟩
  · rw [counter_heap]; exact b.writable
  · intro index bound; rw [counter_heap]; exact b.allocated index bound

theorem input_counter {out : State} {k : Nat} {p pp rr : BitVec 32} (b : Basic out k p pp rr)
    (before : State) (j : Nat) (jb : j<12) (v : Nat×Nat×Nat) (rowV : (values .ternary)[j]?=some v)
    (object : KeygenStaticTables.PrimeObject out.heap primes .ternary) :
    CrtPrimePrefix214.Input (counter before out j) j v :=
  ⟨by omega,FftLocalCells140.cell_at _ _ _,rowV,
    ((counter_arrays before out j "primes".toList).trans
      ((scope_arrays before out "primes".toList (by decide)).trans b.primesBinding)),
    by rw [counter_heap]; exact object⟩

theorem earlier_fs (u : Nat) (hu : u<12) (i : Nat) (bound : i<384) : Earlier u (elem fs i) :=
  And.intro (And.intro (FourthStepExtraPair216.data .f .f u hu i bound)
      (FourthStepExtraPair216.data .g .f u hu i bound))
    (And.intro (FourthStepExtraInner216.fs_gm_out i bound) (FourthStepExtraInner216.fs_igm_out i bound))

theorem earlier_gs (u : Nat) (hu : u<12) (i : Nat) (bound : i<384) : Earlier u (elem gs i) :=
  And.intro (And.intro (FourthStepExtraPair216.data .f .g u hu i bound)
      (FourthStepExtraPair216.data .g .g u hu i bound))
    (And.intro (FourthStepExtraInner216.gs_gm_out i bound) (FourthStepExtraInner216.gs_igm_out i bound))

theorem earlier_col (source : Side) (u' u : Nat) (hu' : u'<12) (hu : u<12) (hne : u'≠u)
    (i : Nat) (ib : i<32) : Earlier u' (addr (root source) u i 12) :=
  And.intro (And.intro (outside_cols .f source u' u hu' hu hne ⟨i,ib⟩)
      (outside_cols .g source u' u hu' hu hne ⟨i,ib⟩))
    (And.intro (gm_cols source u i hu ib) (igm_cols source u i hu ib))

theorem image_keep {s out : State} {k u : Nat} {side : Side} {p pi r2 : BitVec 32} {w : Nat → BitVec 32}
    (keep : ∀ q old, Earlier u q → Load32 s.heap q old → Load32 out.heap q old)
    (image : Image s (root side) k 12 32 p pi r2 w 32) (hne : u≠k) (hu : u<12) (hk : k<12) :
    Image out (root side) k 12 32 p pi r2 w 32 := by
  intro i bound
  exact keep _ _ (earlier_col side u k hu hk hne i.val i.isLt) (image i bound)

theorem fs_keep_u {s out : State} {u : Nat} {W : Nat → BitVec 32}
    (keep : ∀ q old, Earlier u q → Load32 s.heap q old → Load32 out.heap q old)
    (data : Data s fs 384 W) (hu : u<12) : Data out fs 384 W := by
  intro i bound
  exact keep _ _ (earlier_fs u hu i bound) (data i bound)

theorem gs_keep_u {s out : State} {u : Nat} {W : Nat → BitVec 32}
    (keep : ∀ q old, Earlier u q → Load32 s.heap q old → Load32 out.heap q old)
    (data : Data s gs 384 W) (hu : u<12) : Data out gs 384 W := by
  intro i bound
  exact keep _ _ (earlier_gs u hu i bound) (data i bound)


open FourthStepPrimeRows216 (v6 v7 v8 v9 v10 v11)

def extraRow (k : Nat) : Nat×Nat×Nat :=
  if k=6 then v6 else if k=7 then v7 else if k=8 then v8 else if k=9 then v9 else if k=10 then v10 else v11

theorem extraRow_value (k : Nat) (lo : 6 ≤ k) (hi : k<12) : (values .ternary)[k]?=some (extraRow k) := by
  have choices : k=6 ∨ k=7 ∨ k=8 ∨ k=9 ∨ k=10 ∨ k=11 := by omega
  rcases choices with eq | eq | eq | eq | eq | eq <;> subst k
  · exact FourthStepPrimeRows216.row6_value
  · exact FourthStepPrimeRows216.row7_value
  · exact FourthStepPrimeRows216.row8_value
  · exact FourthStepPrimeRows216.row9_value
  · exact FourthStepPrimeRows216.row10_value
  · exact FourthStepPrimeRows216.row11_value

theorem guard (s : State) (u : Nat) (outer : Outer s u) (ub : u<2^64) :
    C99ArrayReference.scalar s (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen)
      (C99ScalarReference.boolean (decide (u<12))) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ outer.uCell) (.variable _ _ _ outer.tlenCell)
    (C99NatWord141.less u 12 ub (by decide))

end FT1536.Source3.FourthStepExtraLoopBase216
