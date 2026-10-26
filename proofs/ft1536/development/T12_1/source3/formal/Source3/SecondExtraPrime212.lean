import Source3.ZintSignedStore212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraPrime212
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenFullData127 (primes)
open KeygenStaticTables (PrimeObject primeField rows row values)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open CrtState205 (set32)
open SelectedStepAddPrime195 (withX withWords withV locals_keep effect_locals)
open SecondStepOuter204 (Outer)
open SecondStepBasic203 (Basic)
open KeygenMakeFgSource (Exec)

def p2 : BitVec 32 := 2147309569
 def g2 : BitVec 32 := 686923925
 def i2 := KeygenNinv31.word p2
 def r22 := KeygenModpR2Word.word p2 i2
 def rx2 := RxModel210.resultWord 2 p2 i2 r22
 def prime2 : ArrayPointer := {primes with index:=primes.index+2}
 def withP (s : State) := set32 (withX s) "p" p2
 def withI (s : State) := set32 (withP s) "p0i" i2
 def withR (s : State) := set32 (withI s) "R2" r22
 def after (s : State) := set32 (withR s) "Rx" rx2

theorem row2 : ((rows .ternary)[2]?).bind row=some (2147309569,686923925,434763914) := by decide +kernel

theorem row2_value : (values .ternary)[2]?=some (2147309569,686923925,434763914) :=
  (KeygenStaticReads.indexed_source .ternary 2).symm.trans row2

theorem p_object (s : State) (object : PrimeObject s.heap primes .ternary) :
    Load32 s.heap (KeygenLevelCalls.fieldPointer prime2 .p) p2 :=
  object.2.2.2.2.2.2 2 (2147309569,686923925,434763914) row2_value .p

theorem g_object (s : State) (object : PrimeObject s.heap primes .ternary) :
    Load32 s.heap (KeygenLevelCalls.fieldPointer prime2 .g) g2 :=
  object.2.2.2.2.2.2 2 (2147309569,686923925,434763914) row2_value .g

theorem declared_locals (s : State) (name : Name) (absent : name∉MakeFgAddPrimeShape194.localNames) :
    (withX s).locals name=s.locals name := by
  have noWords : name∉["p".toList,"p0i".toList,"R2".toList,"Rx".toList] := fun member =>
    absent (List.mem_append_left ["v".toList] member)
  have nv : name≠"v".toList := by
    intro eq; apply absent; rw [eq]
    decide
  exact (ZintSubWord194.effect_one_other .u64 "v".toList name (withWords s) nv).trans
    (effect_locals .u32 ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s name noWords)

theorem arrays (s : State) (name : Name) (nx : name≠"x".toList) : (after s).arrays name=s.arrays name :=
  SelectedStepAddPrime195.clear_arrays (withV s) "x".toList name nx

theorem locals (s : State) (name : Name) (absent : name∉MakeFgAddPrimeShape194.localNames) : (after s).locals name=s.locals name := by
  have ne (word : String) (member : word.toList∈MakeFgAddPrimeShape194.localNames) : name≠word.toList := by
    intro eq; apply absent; rw [eq]; exact member
  exact (locals_keep (withR s) "Rx".toList .uint32 (.uint32 rx2) name (ne "Rx" (by decide))).trans
    ((locals_keep (withI s) "R2".toList .uint32 (.uint32 r22) name (ne "R2" (by decide))).trans
      ((locals_keep (withP s) "p0i".toList .uint32 (.uint32 i2) name (ne "p0i" (by decide))).trans
        ((locals_keep (withX s) "p".toList .uint32 (.uint32 p2) name (ne "p" (by decide))).trans (declared_locals s name absent))))

theorem p_cell (s : State) : Slot (after s) "p" p2 :=
  (CrtState205.keep32 (withR s) "Rx" "p" rx2 (by decide)).trans
    ((CrtState205.keep32 (withI s) "R2" "p" r22 (by decide)).trans
      ((CrtState205.keep32 (withP s) "p0i" "p" i2 (by decide)).trans (CrtState205.cell32 _ _ _)))

theorem i_cell (s : State) : Slot (after s) "p0i" i2 :=
  (CrtState205.keep32 (withR s) "Rx" "p0i" rx2 (by decide)).trans
    ((CrtState205.keep32 (withI s) "R2" "p0i" r22 (by decide)).trans (CrtState205.cell32 _ _ _))

theorem r_cell (s : State) : Slot (after s) "R2" r22 :=
  (CrtState205.keep32 (withR s) "Rx" "R2" rx2 (by decide)).trans (CrtState205.cell32 _ _ _)

theorem rx_cell (s : State) : Slot (after s) "Rx" rx2 := CrtState205.cell32 _ _ _

theorem source (s : State) (h : Outer s 2) (object : PrimeObject s.heap primes .ternary)
    (tail : KeygenMakeFgSource.Stmt) (out : C99ProcedureReference.Result) (rest : Exec tail (after s) out) :
    Exec (MakeFgSequence187.append MakeFgAddPrimeShape194.prefixSteps tail) s out := by
  have uD : Cell (withX s) "u".toList 2 := (declared_locals s "u".toList (by decide)).trans h.uCell
  have pRead : KeygenLevelCalls.PrimeRead (withX s) "primes".toList (.var "u".toList) .p (.uint32 p2) :=
    .read prime2 p2 (.add _ _ primes prime2 (.uint64 2)
      (SelectedStepAddPrime195.withX_primes s h.primesBinding) (.variable _ _ _ uD) (by decide) (.within primes 2 (by decide))) rfl (by decide) (p_object s object)
  have pRun : Exec MakeFgAddPrimeShape194.pSet (withX s) ⟨withP s,.normal⟩ :=
    .level _ _ _ (.prime _ _ _ _ _ .uint32 none (.uint32 p2) rfl pRead)
  have iRun : Exec MakeFgAddPrimeShape194.iSet (withP s) ⟨withI s,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign _ "p0i" none _ i2 rfl
      (.call1 _ _ _ _ (ModularAtoms178.cell _ "p" p2 (CrtState205.cell32 _ _ _)) (.inverse _ _ (KeygenNinv31.source_exists p2)))))
  have pI : Slot (withI s) "p" p2 := (CrtState205.keep32 (withP s) "p0i" "p" i2 (by decide)).trans (CrtState205.cell32 _ _ _)
  have rRun : Exec MakeFgAddPrimeShape194.rSet (withI s) ⟨withR s,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign _ "R2" none _ r22 rfl
      (.call2 _ _ _ _ _ _ (ModularAtoms178.cell _ "p" p2 pI) (ModularAtoms178.cell _ "p0i" i2 (CrtState205.cell32 _ _ _))
        (.r2 _ _ (KeygenModpR2Exec.source_exists (withI s) p2 i2)))))
  have slenR : Cell (withR s) "slen".toList 2 := by
    exact (CrtState205.keep32 (withI s) "R2" "slen" r22 (by decide)).trans
      ((CrtState205.keep32 (withP s) "p0i" "slen" i2 (by decide)).trans
        ((CrtState205.keep32 (withX s) "p" "slen" p2 (by decide)).trans ((declared_locals s "slen".toList (by decide)).trans h.slenCell)))
  have pR : Slot (withR s) "p" p2 := (CrtState205.keep32 (withI s) "R2" "p" r22 (by decide)).trans pI
  have iR : Slot (withR s) "p0i" i2 := (CrtState205.keep32 (withI s) "R2" "p0i" r22 (by decide)).trans (CrtState205.cell32 _ _ _)
  have rxRun : Exec MakeFgAddPrimeShape194.rxSet (withR s) ⟨after s,.normal⟩ :=
    RxSection210.source (withR s) 2 p2 i2 r22 none (by decide) (by decide) slenR pR iR (CrtState205.cell32 _ _ _) rfl
  exact MakeFgSequence187.source [MakeFgAddPrimeShape194.declP,MakeFgAddPrimeShape194.declV,MakeFgAddPrimeShape194.declX]
    s (withX s) (SelectedStepAddPrime195.decls_run s) _ out
    (.seqNormal _ _ _ _ _ pRun (.seqNormal _ _ _ _ _ iRun (.seqNormal _ _ _ _ _ rRun (.seqNormal _ _ _ _ _ rxRun rest))))

theorem basic (s : State) (h : Outer s 2) : Basic (after s) 2 p2 i2 r22 := by
  refine ⟨(locals _ _ (by decide)).trans h.nCell,(locals _ _ (by decide)).trans h.hnCell,
    (locals _ _ (by decide)).trans h.slenCell,(locals _ _ (by decide)).trans h.tlenCell,(locals _ _ (by decide)).trans h.uCell,
    p_cell s,i_cell s,r_cell s,(locals _ _ (by decide)).trans h.lognCell,(locals _ _ (by decide)).trans h.terCell,
    (locals _ _ (by decide)).trans h.inCell,(locals _ _ (by decide)).trans h.outCell,
    (arrays _ _ (by decide)).trans h.fdBinding,(arrays _ _ (by decide)).trans h.gdBinding,
    (arrays _ _ (by decide)).trans h.fsBinding,(arrays _ _ (by decide)).trans h.gsBinding,
    (arrays _ _ (by decide)).trans h.gmBinding,(arrays _ _ (by decide)).trans h.igmBinding,
    (arrays _ _ (by decide)).trans h.t1Binding,(arrays _ _ (by decide)).trans h.primesBinding,h.writable,h.allocated⟩

end FT1536.Source3.SecondExtraPrime212
