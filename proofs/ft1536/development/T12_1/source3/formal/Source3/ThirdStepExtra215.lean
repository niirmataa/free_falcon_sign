import Source3.ThirdStepExtraInner215
import Source3.KeygenMakeEntry

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The counted d=3 additional-prime loop (part 4): `for (u = slen;
   u < tlen; u ++)` at slen = 3 / tlen = 6, the three counted
   iterations over the PRIMES3 rows 3..5 from the u = 3 initializer to
   the false u < 6 guard. The loop produces the fd/gd product columns
   3..5 with exact executed words and preserves the fs/gs reassembled
   images, every earlier column and the readonly tables. Executed
   words only; no NTT/Montgomery/CRT/table law is claimed. -/
namespace FT1536.Source3.ThirdStepExtra215
open C99ArrayReference (State Name restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SecondStepProduct203 (root)
open ThirdStepLayout215 (fd gd fs gs gm igm t1)
open SecondStepGeometry203 (scratch ordered)
open KeygenFullData127 (primes rev)
open KeygenStaticTables (values)
open ThirdStepGenerator215 (Basic Outer rxVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open ZintNormWalkFlat208 (Data)
open StepProductFixed203 (Image)
open ThirdStepExtraPair215 (sWords)
open ThirdStepExtraInner215 (Earlier)

/- The three additional PRIMES3 rows of the d=3 part-4 loop. -/
def v3 : Nat×Nat×Nat := (2147281921,658779219,742235228)
def v4 : Nat×Nat×Nat := (2147235841,1567830083,1964117354)
def v5 : Nat×Nat×Nat := (2147217409,273379403,890663385)

theorem rowV3 : (values .ternary)[3]?=some v3 := ThirdStepGenerator215.row3_value
theorem rowV4 : (values .ternary)[4]?=some v4 := ThirdStepGenerator215.row4_value
theorem rowV5 : (values .ternary)[5]?=some v5 := ThirdStepGenerator215.row5_value

/- The loop keep domain: everything except the 128 t1 words, the
   gm/igm generator scratch and the fd/gd columns u < 6. -/
def LoopKeep (s out : State) : Prop :=
  ∀ q old, (∀ i, i < 128 → Separate (elem t1 i) q) →
    (∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 128 q.block (q.offset+byte.val)) →
    MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
    (∀ u, u < 6 → ∀ i, i < 64 → Separate (addr fd u i 6) q) →
    (∀ u, u < 6 → ∀ i, i < 64 → Separate (addr gd u i 6) q) →
    Load32 s.heap q old → Load32 out.heap q old

theorem loopPremises (u : Nat) (hu : u<6) (q : ArrayPointer)
    (t1s : ∀ i, i < 128 → Separate (elem t1 i) q)
    (frame : ∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 128 q.block (q.offset+byte.val))
    (gmOut : MkgmCallKeep203.Outside gm q) (igmOut : MkgmCallKeep203.Outside igm q)
    (fdSep : ∀ u, u < 6 → ∀ i, i < 64 → Separate (addr fd u i 6) q)
    (gdSep : ∀ u, u < 6 → ∀ i, i < 64 → Separate (addr gd u i 6) q) : Earlier u q :=
  And.intro (And.intro (And.intro t1s (And.intro frame (fun i => fdSep u hu i.val i.isLt)))
      (And.intro t1s (And.intro frame (fun i => gdSep u hu i.val i.isLt))))
    (And.intro gmOut igmOut)

/- Column separations across additional loop indices. -/
theorem outside_cols (side source : Side) (u' u : Nat) (hu' : u'<6) (hu : u<6) (hne : u'≠u)
    (i : Fin 64) : ThirdStepExtraPair215.Outside side u' (addr (root source) u i.val 6) := by
  have before : addr (root source) u i.val 6 = scratch ((root source).index+u+i.val*6) := by
    cases source <;> rfl
  have ibound : (root source).index+u+i.val*6<2462 := by
    cases source
    · change 670+u+i.val*6<2462; have b:=i.isLt; omega
    · change 1054+u+i.val*6<2462; have b:=i.isLt; omega
  rw [before]
  refine ⟨(ThirdStepExtraPair215.before_t1 _ ibound).1,(ThirdStepExtraPair215.before_t1 _ ibound).2,?_⟩
  intro j
  cases side <;> cases source
  · change Separate (scratch (670+u'+j.val*6)) (scratch (670+u+i.val*6))
    exact ThirdStepExtraSide215.sep_at (by have b:=j.isLt; omega)
  · change Separate (scratch (670+u'+j.val*6)) (scratch (1054+u+i.val*6))
    exact ThirdStepExtraSide215.sep_at (by have b:=j.isLt; omega)
  · change Separate (scratch (1054+u'+j.val*6)) (scratch (670+u+i.val*6))
    exact ThirdStepExtraSide215.sep_at (by have b:=j.isLt; omega)
  · change Separate (scratch (1054+u'+j.val*6)) (scratch (1054+u+i.val*6))
    exact ThirdStepExtraSide215.sep_at (by have b:=j.isLt; omega)

theorem gm_cols (source : Side) (u i : Nat) (hu : u<6) (ib : i<64) :
    MkgmCallKeep203.Outside gm (addr (root source) u i 6) := by
  intro byte; right; left
  cases source
  · change 0+4*(670+u+i*6)+byte.val<0+4*2206
    have b:=byte.isLt; omega
  · change 0+4*(1054+u+i*6)+byte.val<0+4*2206
    have b:=byte.isLt; omega

theorem igm_cols (source : Side) (u i : Nat) (hu : u<6) (ib : i<64) :
    MkgmCallKeep203.Outside igm (addr (root source) u i 6) := by
  intro byte; right; left
  cases source
  · change 0+4*(670+u+i*6)+byte.val<0+4*2334
    have b:=byte.isLt; omega
  · change 0+4*(1054+u+i*6)+byte.val<0+4*2334
    have b:=byte.isLt; omega

theorem t1_cols (source : Side) (u i : Nat) (hu : u<6) (ib : i<64) :
    (∀ j, j < 128 → Separate (elem t1 j) (addr (root source) u i 6)) ∧
    (∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 128 (addr (root source) u i 6).block
      ((addr (root source) u i 6).offset+byte.val)) := by
  cases source
  · exact ThirdStepExtraPair215.before_t1 (670+u+i*6) (by omega)
  · exact ThirdStepExtraPair215.before_t1 (1054+u+i*6) (by omega)

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

theorem init_source (s : State) (h : Outer s 3) : Exec MakeFgAddPrimeShape194.aInit s ⟨s,.normal⟩ := by
  have run : Exec MakeFgAddPrimeShape194.initU s ⟨CrtState205.set64 s "u" 3,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 (some (.uint64 3)) (.uint64 3) h.uCell
      (.scalar _ _ (.variable _ _ _ h.slenCell))))
  rw [MakeFgAddPrimeShape194.init_shape]
  have eq : CrtState205.set64 s "u" 3=s := (FftLocalCells140.put_bind s "u".toList 3).symm.trans
    (put_same s "u".toList 3 h.uCell)
  simpa only [eq] using run

theorem incrementK (s out : State) (k : Nat) (kb : k<6) (u : Cell out "u".toList k) :
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

theorem counter_tlen (s out : State) (k : Nat) (tlen : Cell out "tlen".toList 6) :
    Cell (counter s out k) "tlen".toList 6 :=
  (FftLocalCells140.outside (scopedState s out) "u".toList "tlen".toList _ (by decide)).trans
    ((scoped_local s out "tlen".toList (by decide)).trans tlen)

theorem guard3 (s out : State) (tlen : Cell out "tlen".toList 6) :
    C99ArrayReference.scalar (counter s out 3) (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen)
      (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (counter_u s out 3)) (.variable _ _ _ (counter_tlen s out 3 tlen))
    (.step .lt (.uint64 3) (.uint64 6) .uint64 rfl (.uint64 3) (.uint64 6) rfl rfl)

theorem guard4 (s out : State) (tlen : Cell out "tlen".toList 6) :
    C99ArrayReference.scalar (counter s out 4) (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen)
      (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (counter_u s out 4)) (.variable _ _ _ (counter_tlen s out 4 tlen))
    (.step .lt (.uint64 4) (.uint64 6) .uint64 rfl (.uint64 4) (.uint64 6) rfl rfl)

theorem guard5 (s out : State) (tlen : Cell out "tlen".toList 6) :
    C99ArrayReference.scalar (counter s out 5) (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen)
      (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (counter_u s out 5)) (.variable _ _ _ (counter_tlen s out 5 tlen))
    (.step .lt (.uint64 5) (.uint64 6) .uint64 rfl (.uint64 5) (.uint64 6) rfl rfl)

theorem guard6 (s out : State) (tlen : Cell out "tlen".toList 6) :
    C99ArrayReference.scalar (counter s out 6) (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen)
      (.int32 0) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ (counter_u s out 6)) (.variable _ _ _ (counter_tlen s out 6 tlen))
    (.step .lt (.uint64 6) (.uint64 6) .uint64 rfl (.uint64 6) (.uint64 6) rfl rfl)

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
    (before : State) (j : Nat) (jb : j<6) (v : Nat×Nat×Nat) (rowV : (values .ternary)[j]?=some v)
    (object : KeygenStaticTables.PrimeObject out.heap primes .ternary) :
    CrtPrimePrefix214.Input (counter before out j) j v :=
  ⟨by omega,FftLocalCells140.cell_at _ _ _,rowV,
    ((counter_arrays before out j "primes".toList).trans
      ((scope_arrays before out "primes".toList (by decide)).trans b.primesBinding)),
    by rw [counter_heap]; exact object⟩

theorem guard_start (s : State) (h : Outer s 3) :
    C99ArrayReference.scalar s (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen)
      (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ h.uCell) (.variable _ _ _ h.tlenCell)
    (.step .lt (.uint64 3) (.uint64 6) .uint64 rfl (.uint64 3) (.uint64 6) rfl rfl)

/- Earlier-row transports of the loop keeps. -/
theorem earlier_fs (u : Nat) (hu : u<6) (i : Nat) (bound : i<384) : Earlier u (elem fs i) :=
  And.intro (And.intro (ThirdStepExtraPair215.data .f .f u hu i bound)
      (ThirdStepExtraPair215.data .g .f u hu i bound))
    (And.intro (ThirdStepExtraInner215.fs_gm_out i bound) (ThirdStepExtraInner215.fs_igm_out i bound))

theorem earlier_gs (u : Nat) (hu : u<6) (i : Nat) (bound : i<384) : Earlier u (elem gs i) :=
  And.intro (And.intro (ThirdStepExtraPair215.data .f .g u hu i bound)
      (ThirdStepExtraPair215.data .g .g u hu i bound))
    (And.intro (ThirdStepExtraInner215.gs_gm_out i bound) (ThirdStepExtraInner215.gs_igm_out i bound))

theorem earlier_col (source : Side) (u' u : Nat) (hu' : u'<6) (hu : u<6) (hne : u'≠u)
    (i : Nat) (ib : i<64) : Earlier u' (addr (root source) u i 6) :=
  And.intro (And.intro (outside_cols .f source u' u hu' hu hne ⟨i,ib⟩)
      (outside_cols .g source u' u hu' hu hne ⟨i,ib⟩))
    (And.intro (gm_cols source u i hu ib) (igm_cols source u i hu ib))

theorem image_keep {s out : State} {k u : Nat} {side : Side} {p pi r2 : BitVec 32} {w : Nat → BitVec 32}
    (keep : ∀ q old, Earlier u q → Load32 s.heap q old → Load32 out.heap q old)
    (image : Image s (root side) k 6 64 p pi r2 w 64) (hne : u≠k) (hu : u<6) (hk : k<6) :
    Image out (root side) k 6 64 p pi r2 w 64 := by
  intro i bound
  exact keep _ _ (earlier_col side u k hu hk hne i.val i.isLt) (image i bound)

theorem fs_keep_u {s out : State} {u : Nat} {W : Nat → BitVec 32}
    (keep : ∀ q old, Earlier u q → Load32 s.heap q old → Load32 out.heap q old)
    (data : Data s fs 384 W) (hu : u<6) : Data out fs 384 W := by
  intro i bound
  exact keep _ _ (earlier_fs u hu i bound) (data i bound)

theorem gs_keep_u {s out : State} {u : Nat} {W : Nat → BitVec 32}
    (keep : ∀ q old, Earlier u q → Load32 s.heap q old → Load32 out.heap q old)
    (data : Data s gs 384 W) (hu : u<6) : Data out gs 384 W := by
  intro i bound
  exact keep _ _ (earlier_gs u hu i bound) (data i bound)

/- The complete counted loop: three iterations over rows 3..5, the
   false u < 6 exit, all three additional product columns, the fs/gs
   images and the readonly tables at the exit. -/
theorem source (s : State) (F G : Nat → BitVec 32) (o : Outer s 3)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revB : s.tables "REV10".toList=some rev)
    (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fdata : Data s fs 384 F) (gdata : Data s gs 384 G) :
    ∃ (out : State) (gvs3 gvs4 gvs5 : Fin 128 → BitVec 32),
      Exec MakeFgAddPrimeShape194.part4 s ⟨out,.normal⟩ ∧ Outer out 6 ∧
      Image out fd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords F gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 ∧
      Image out fd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords F gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 ∧
      Image out fd 5 6 64 (pVal v5) (iVal v5) (rVal v5) (sWords F gvs5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)) 64 ∧
      Image out gd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords G gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 ∧
      Image out gd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords G gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 ∧
      Image out gd 5 6 64 (pVal v5) (iVal v5) (rVal v5) (sWords G gvs5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)) 64 ∧
      Data out fs 384 F ∧ Data out gs 384 G ∧
      KeygenStaticTables.PrimeObject out.heap primes .ternary ∧
      out.tables "REV10".toList=some rev ∧
      KeygenMkgm3RevMemory.SourceTable out.heap rev ∧
      LoopKeep s out := by
  have input3 : CrtPrimePrefix214.Input s 3 v3 := ⟨by omega,o.uCell,rowV3,o.primesBinding,object⟩
  obtain ⟨out3,gvs3,run3,basic3,fd3,gd3,ls3,ars3,keep3⟩ :=
    ThirdStepExtraInner215.source s 3 v3 F G o input3 (by decide) revB revS fdata gdata
  have object3 : KeygenStaticTables.PrimeObject out3.heap primes .ternary := object_keep object run3
  have revB3 : out3.tables "REV10".toList=some rev := revB_keep revB run3
  have revS3 : KeygenMkgm3RevMemory.SourceTable out3.heap rev := rev_keep revS run3
  let s1 := counter s out3 4
  have object3s : KeygenStaticTables.PrimeObject s1.heap primes .ternary := by rw [counter_heap]; exact object3
  have revS3s : KeygenMkgm3RevMemory.SourceTable s1.heap rev := by rw [counter_heap]; exact revS3
  have revB3s : s1.tables "REV10".toList=some rev := revB3
  have o1 : Outer s1 4 := outer_counter basic3 s 4
  have input4 : CrtPrimePrefix214.Input s1 4 v4 := input_counter basic3 s 4 (by decide) v4 rowV4 object3s
  have fdata1 : Data s1 fs 384 F := by
    intro i bound; rw [counter_heap]; exact keep3 _ _ (earlier_fs 3 (by decide) i bound) (fdata i bound)
  have gdata1 : Data s1 gs 384 G := by
    intro i bound; rw [counter_heap]; exact keep3 _ _ (earlier_gs 3 (by decide) i bound) (gdata i bound)
  obtain ⟨out4,gvs4,run4,basic4,fd4,gd4,ls4,ars4,keep4⟩ :=
    ThirdStepExtraInner215.source s1 4 v4 F G o1 input4 (by decide) revB3s revS3s fdata1 gdata1
  have object4 : KeygenStaticTables.PrimeObject out4.heap primes .ternary := object_keep object3s run4
  have revB4 : out4.tables "REV10".toList=some rev := revB_keep revB3s run4
  have revS4 : KeygenMkgm3RevMemory.SourceTable out4.heap rev := rev_keep revS3s run4
  let s2 := counter s1 out4 5
  have object4s : KeygenStaticTables.PrimeObject s2.heap primes .ternary := by rw [counter_heap]; exact object4
  have revS4s : KeygenMkgm3RevMemory.SourceTable s2.heap rev := by rw [counter_heap]; exact revS4
  have revB4s : s2.tables "REV10".toList=some rev := revB4
  have o2 : Outer s2 5 := outer_counter basic4 s1 5
  have input5 : CrtPrimePrefix214.Input s2 5 v5 := input_counter basic4 s1 5 (by decide) v5 rowV5 object4s
  have fdata2 : Data s2 fs 384 F := fs_keep_u keep4 fdata1 (by decide)
  have gdata2 : Data s2 gs 384 G := gs_keep_u keep4 gdata1 (by decide)
  obtain ⟨out5,gvs5,run5,basic5,fd5,gd5,ls5,ars5,keep5⟩ :=
    ThirdStepExtraInner215.source s2 5 v5 F G o2 input5 (by decide) revB4s revS4s fdata2 gdata2
  have object5 : KeygenStaticTables.PrimeObject out5.heap primes .ternary := object_keep object4s run5
  have revB5 : out5.tables "REV10".toList=some rev := revB_keep revB4s run5
  have revS5 : KeygenMkgm3RevMemory.SourceTable out5.heap rev := rev_keep revS4s run5
  let out := counter s2 out5 6
  have fd3f : Image out fd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords F gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 :=
    image_keep (u:=5) (k:=3) (side:=.f) keep5
      (image_keep (u:=4) (k:=3) (side:=.f) keep4 fd3 (by decide) (by decide) (by decide))
      (by decide) (by decide) (by decide)
  have fd4f : Image out fd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords F gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 :=
    image_keep (u:=5) (k:=4) (side:=.f) keep5 fd4 (by decide) (by decide) (by decide)
  have gd3f : Image out gd 3 6 64 (pVal v3) (iVal v3) (rVal v3) (sWords G gvs3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3)) 64 :=
    image_keep (u:=5) (k:=3) (side:=.g) keep5
      (image_keep (u:=4) (k:=3) (side:=.g) keep4 gd3 (by decide) (by decide) (by decide))
      (by decide) (by decide) (by decide)
  have gd4f : Image out gd 4 6 64 (pVal v4) (iVal v4) (rVal v4) (sWords G gvs4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4)) 64 :=
    image_keep (u:=5) (k:=4) (side:=.g) keep5 gd4 (by decide) (by decide) (by decide)
  have fdataF : Data out fs 384 F := fs_keep_u keep5 (fs_keep_u keep4 fdata1 (by decide)) (by decide)
  have gdataF : Data out gs 384 G := gs_keep_u keep5 (gs_keep_u keep4 gdata1 (by decide)) (by decide)
  have loopEnd : Exec MakeFgAddPrimeShape194.aLoop out ⟨out,.normal⟩ :=
    .loopFalse _ _ _ _ (.int32 0) (guard6 s2 out5 basic5.tlenCell) rfl
  have loop5 : Exec MakeFgAddPrimeShape194.aLoop s2 ⟨out,.normal⟩ :=
    .loopNormal _ _ _ s2 (scopedState s2 out5) out _ (.int32 1) (guard5 s1 out4 basic4.tlenCell) (by decide)
      (scope_source s2 out5 run5) (incrementK s2 out5 5 (by decide) basic5.uCell) loopEnd
  have loop4 : Exec MakeFgAddPrimeShape194.aLoop s1 ⟨out,.normal⟩ :=
    .loopNormal _ _ _ s1 (scopedState s1 out4) s2 _ (.int32 1) (guard4 s out3 basic3.tlenCell) (by decide)
      (scope_source s1 out4 run4) (incrementK s1 out4 4 (by decide) basic4.uCell) loop5
  have loop3 : Exec MakeFgAddPrimeShape194.aLoop s ⟨out,.normal⟩ :=
    .loopNormal _ _ _ s (scopedState s out3) s1 _ (.int32 1) (guard_start s o) (by decide)
      (scope_source s out3 run3) (incrementK s out3 3 (by decide) basic3.uCell) loop4
  have part : Exec MakeFgAddPrimeShape194.part4 s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.part4_split,MakeFgAddPrimeShape194.aFor_split,MakeFgAddPrimeShape194.aTail_skip]
    exact .seqNormal _ _ _ out _ (.seqNormal _ _ _ s _ (init_source s o) loop3)
      (SelectedStepAddPrime195.skip_run out)
  refine ⟨out,gvs3,gvs4,gvs5,part,outer_counter basic5 s2 6,fd3f,fd4f,?_,gd3f,gd4f,?_,fdataF,gdataF,?_,?_,?_,?_⟩
  · intro i bound
    rw [counter_heap]
    exact fd5 i bound
  · intro i bound
    rw [counter_heap]
    exact gd5 i bound
  · rw [counter_heap]; exact object5
  · exact revB5
  · rw [counter_heap]; exact revS5
  · intro q old t1s frame gmO igmO fdS gdS read
    exact keep5 q old (loopPremises 5 (by decide) q t1s frame gmO igmO fdS gdS)
      (keep4 q old (loopPremises 4 (by decide) q t1s frame gmO igmO fdS gdS)
        (keep3 q old (loopPremises 3 (by decide) q t1s frame gmO igmO fdS gdS) read))

end FT1536.Source3.ThirdStepExtra215
