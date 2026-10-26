import Source3.CrtCoefficientState214

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtCoefficient214
open C99ArrayReference (State Name Pointer restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open CrtState205 (Slot64 set32)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open ZintNormWalkFlat208 (Data)
open CrtRoundShape205
open CrtCoefficientState214
open KeygenZintCall (Exec)

theorem source (s : State) (x tmp : ArrayPointer) (n : Nat) (W T : Nat → BitVec 32) (p pi r2 c : BitVec 32)
    (xb : s.arrays "x".toList=some x) (tb : s.arrays "tmp".toList=some tmp)
    (u : Cell s "u".toList n) (pp : Slot s "p" p) (ip : Slot s "p0i" pi)
    (rp : Slot s "R2" r2) (sp : Slot s "s" c)
    (nb : n < 2^64) (cap : x.index+n < x.count) (tc : tmp.index ≤ tmp.count) (width : x.elementBytes=4)
    (data : ∀ i, i ≤ n → Load32 s.heap (elem x i) (W i))
    (modulus : ∀ i, i < n → Load32 s.heap (elem tmp i) (T i))
    (apart : ∀ i j, i < n → j < n → Separate (elem x i) (elem tmp j))
    (writable : s.heap.writable x.block=true) :
    ∃ out, Exec coeff s ⟨out,.normal⟩ ∧ Data out x (n+1) (words W T n p pi r2 c) ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ q old, (∀ i, i ≤ n → Separate (elem x i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have dc : ∀ name∈coeffNames, (declared s).locals name=some (.uint32,none) := by
    intro name member
    simp [coeffNames] at member
    rcases member with h|h|h <;> subst name <;> rfl
  have uD : Cell (declared s) "u".toList n := (declared_outside s "u".toList (by decide)).trans u
  have tailBound : x.index+n ≤ x.count := by omega
  have decl : Exec (declare .u32 coeffNames) s ⟨declared s,.normal⟩ :=
    .word _ _ _ (ZintSubWord194.declare_run .u32 coeffNames s)
  have readXp : Exec setXp (declared s) ⟨withXp s W n,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "xp" none _ (W n) (dc _ (by decide))
      (.load32 _ _ (elem x n) (W n)
        (.add _ _ x _ (.uint64 (C99NatWord141.word n)) xb (.variable _ _ _ uD) (by rw [C99NatWord141.integer n nb]; omega) (by rw [C99NatWord141.integer n nb]; exact .within x n tailBound)) (data n (Nat.le_refl n))))
  have uP : Cell (withXp s W n) "u".toList n := (CrtState205.keep32 (declared s) "xp" "u" (W n) (by decide)).trans uD
  have pP : Slot (withXp s W n) "p" p := (CrtState205.keep32 (declared s) "xp" "p" (W n) (by decide)).trans
    ((declared_outside s "p".toList (by decide)).trans pp)
  have iP : Slot (withXp s W n) "p0i" pi := (CrtState205.keep32 (declared s) "xp" "p0i" (W n) (by decide)).trans
    ((declared_outside s "p0i".toList (by decide)).trans ip)
  have rP : Slot (withXp s W n) "R2" r2 := (CrtState205.keep32 (declared s) "xp" "R2" (W n) (by decide)).trans
    ((declared_outside s "R2".toList (by decide)).trans rp)
  have qD : (withXp s W n).locals "xq".toList=some (.uint32,none) :=
    (CrtState205.keep32 (declared s) "xp" "xq" (W n) (by decide)).trans (dc _ (by decide))
  have reduce : Exec reduceCall (withXp s W n) ⟨withXq s W n p pi r2,.normal⟩ :=
    ZintReduceCall209.source "x" "u" "xq" _ x n W p pi r2 none xb uP pP iP rP qD nb (by omega) (fun i bound => data i (by omega))
  have qQ : Slot (withXq s W n p pi r2) "xq" (quotient W n p pi r2) := CrtState205.cell32 _ _ _
  have bQ : Slot (withXq s W n p pi r2) "xp" (W n) :=
    (CrtState205.keep32 (withXp s W n) "xq" "xp" (quotient W n p pi r2) (by decide)).trans (CrtState205.cell32 _ _ _)
  have pQ : Slot (withXq s W n p pi r2) "p" p :=
    (CrtState205.keep32 (withXp s W n) "xq" "p" (quotient W n p pi r2) (by decide)).trans pP
  have iQ : Slot (withXq s W n p pi r2) "p0i" pi :=
    (CrtState205.keep32 (withXp s W n) "xq" "p0i" (quotient W n p pi r2) (by decide)).trans iP
  have sQ : Slot (withXq s W n p pi r2) "s" c :=
    (CrtState205.keep32 (withXp s W n) "xq" "s" (quotient W n p pi r2) (by decide)).trans
      ((CrtState205.keep32 (declared s) "xp" "s" (W n) (by decide)).trans
        ((declared_outside s "s".toList (by decide)).trans sp))
  have rD : (withXq s W n p pi r2).locals "xr".toList=some (.uint32,none) :=
    (CrtState205.keep32 (withXp s W n) "xq" "xr" (quotient W n p pi r2) (by decide)).trans
      ((CrtState205.keep32 (declared s) "xp" "xr" (W n) (by decide)).trans (dc _ (by decide)))
  have ce : KeygenWordExpr.Eval (withXq s W n p pi r2) correction (.uint32 (correctionWord W n p pi r2 c)) :=
    .call4 _ _ _ _ _ _ _ _ _ _ (CrtState205.expr32 _ "s" c sQ)
      (.call3 _ _ _ _ _ _ _ _ (CrtState205.expr32 _ "xp" (W n) bQ) (CrtState205.expr32 _ "xq" _ qQ)
        (CrtState205.expr32 _ "p" p pQ) (.sub _ _ (KeygenModpAddSub.source_exists .sub (W n) (quotient W n p pi r2) p)))
      (CrtState205.expr32 _ "p" p pQ) (CrtState205.expr32 _ "p0i" pi iQ)
      (.montgomery _ _ (KeygenModpWord.source_exists c (KeygenModpAddSub.result .sub (W n) (quotient W n p pi r2) p) p pi))
  have setR : Exec setXr (withXq s W n p pi r2) ⟨beforeWrite s W n p pi r2 c,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "xr" none _ _ rD ce)
  have uR : Cell (beforeWrite s W n p pi r2 c) "u".toList n :=
    (before_outside s W n p pi r2 c "u".toList (by decide)).trans u
  obtain ⟨result,add,image,ls,ars,keep⟩:=CrtAddMulCall213.source (beforeWrite s W n p pi r2 c) x tmp n W T
    (correctionWord W n p pi r2 c) xb tb uR (CrtState205.cell32 _ _ _) nb cap tc width
    (StepProductFixed203.load_allocated (data n (Nat.le_refl n))) writable
    (fun i bound => data i (by omega)) modulus apart
  have inner : Exec coeffBody s ⟨result,.normal⟩ :=
    .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ readXp (.seqNormal _ _ _ _ _ reduce
      (.seqNormal _ _ _ _ _ setR (.seqNormal _ _ _ _ _ add (.word _ _ _ (ZintSubWord194.skip_run result))))))
  let out:=restoreScope s result coeffNames []
  refine ⟨out,.scope _ _ _ _ _ inner,image,?_,ars,keep⟩
  funext name
  by_cases member : name∈coeffNames
  · simp only [out,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,member,ite_true]
  · exact (WordControl205.restored s result coeffNames name member).trans
      ((congrFun ls name).trans (before_outside s W n p pi r2 c name member))

end FT1536.Source3.CrtCoefficient214
