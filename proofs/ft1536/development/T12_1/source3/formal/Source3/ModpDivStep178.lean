import Source3.ModpDivSelect178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModpDivStep178
open C99ArrayReference (State restoreScope)
open C99ModularReference (GenEval GenExec LeafCall Expr)
open KeygenModpR2Exec (Slot cell_exists)
open ModularAtoms178 (set slot)

def Fixed (s : State) (a b p p0i e : BitVec 32) : Prop :=
  Slot s "a" a ∧ Slot s "b" b ∧ Slot s "p" p ∧ Slot s "p0i" p0i ∧ Slot s "e" e

def square (z p p0i : BitVec 32) := KeygenModpWord.montgomery z z p p0i
def product (z b p p0i : BitVec 32) := KeygenModpWord.montgomery (square z p p0i) b p p0i
def word (z b p p0i e : BitVec 32) (n : Nat) := ModpDivSelect178.word (square z p p0i) (product z b p p0i) e n

def declared (s : State) := C99DeclarationStatements.effect .u32 ["z2".toList] s
def first (s : State) (z p p0i : BitVec 32) := set (declared s) "z" (square z p p0i)
def second (s : State) (z b p p0i : BitVec 32) := set (first s z p p0i) "z2" (product z b p p0i)
def third (s : State) (z b p p0i e : BitVec 32) (n : Nat) := set (second s z b p p0i) "z" (word z b p p0i e n)
def after (s : State) (z b p p0i e : BitVec 32) (n : Nat) :=
  restoreScope s (third s z b p p0i e n) ["z2".toList] []

theorem leaf_mont (s : State) (left right : Expr) (x y p p0i : BitVec 32)
    (first : GenEval LeafCall s left (.uint32 x)) (second : GenEval LeafCall s right (.uint32 y))
    (hp : Slot s "p" p) (hi : Slot s "p0i" p0i) :
    GenEval LeafCall s (KeygenMkgm3Program.mont left right) (.uint32 (KeygenModpWord.montgomery x y p p0i)) :=
  .call4 _ _ _ _ _ _ _ _ _ _ first second (cell_exists s "p" p hp) (cell_exists s "p0i" p0i hi)
    (.montgomery _ _ (KeygenModpWord.source_exists x y p p0i))

theorem first_z (s : State) (z b p p0i : BitVec 32) : Slot (second s z b p p0i) "z" (square z p p0i) := by
  unfold Slot second
  rw [ModularAtoms178.outside (first s z p p0i) "z2" "z" (product z b p p0i) (by decide)]
  exact slot (declared s) "z" _

theorem source (s : State) (a b p p0i e z : BitVec 32) (n : Nat) (bound : n<31)
    (fixed : Fixed s a b p p0i e) (hz : Slot s "z" z)
    (hi : s.locals "i".toList=some (.int32,some (.int32 (ModpDivSelect178.index n)))) :
    GenExec LeafCall C99ModularReference.divLoopBody s ⟨after s z b p p0i e n,.normal⟩ := by
  have d : GenExec LeafCall (.base (.scalar (.declare .u32 ["z2".toList]))) s ⟨declared s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32 ["z2".toList] s)
  have q : GenExec LeafCall (.assign "z".toList C99ModularReference.montZZ) (declared s) ⟨first s z p p0i,.normal⟩ :=
    .assign _ _ _ .uint32 (some (.uint32 z)) (.uint32 (square z p p0i)) hz
      (leaf_mont (declared s) _ _ z z p p0i (cell_exists _ "z" z hz) (cell_exists _ "z" z hz) fixed.2.2.1 fixed.2.2.2.1)
  have qb : GenExec LeafCall (.assign "z2".toList C99ModularReference.montZB) (first s z p p0i) ⟨second s z b p p0i,.normal⟩ :=
    .assign _ _ _ .uint32 none (.uint32 (product z b p p0i)) rfl
      (leaf_mont (first s z p p0i) _ _ (square z p p0i) b p p0i
        (cell_exists _ "z" _ (slot (declared s) "z" _)) (cell_exists _ "b" b fixed.2.1) fixed.2.2.1 fixed.2.2.2.1)
  have select : GenExec LeafCall (.base (.scalar (.update "z".toList .xor C99ModularReference.divSelect)))
      (second s z b p p0i) ⟨third s z b p p0i e n,.normal⟩ :=
    .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 (square z p p0i)))
      (.uint32 (word z b p p0i e n)) (first_z s z b p p0i)
      (ModpDivSelect178.source (second s z b p p0i) _ _ e n bound (first_z s z b p p0i)
        (slot (first s z p p0i) "z2" _) fixed.2.2.2.2 hi)))
  exact .scope ["z2".toList] _ s ⟨third s z b p p0i e n,.normal⟩
    (.seqNormal _ _ s (declared s) _ d (.seqNormal _ _ (declared s) (first s z p p0i) _ q
      (.seqNormal _ _ (first s z p p0i) (second s z b p p0i) _ qb
        (.seqNormal _ _ (second s z b p p0i) (third s z b p p0i e n) _ select
          (.base .skip _ _ (.skip _))))))

theorem fixed_after (s : State) (a b p p0i e z : BitVec 32) (n : Nat) (fixed : Fixed s a b p p0i e) :
    Fixed (after s z b p p0i e n) a b p p0i e :=
  ⟨fixed.1,fixed.2.1,fixed.2.2.1,fixed.2.2.2.1,fixed.2.2.2.2⟩

theorem z_after (s : State) (b p p0i e z : BitVec 32) (n : Nat) :
    Slot (after s z b p p0i e n) "z" (word z b p p0i e n) :=
  slot (second s z b p p0i) "z" _

theorem i_after (s : State) (b p p0i e z : BitVec 32) (n : Nat) :
    (after s z b p p0i e n).locals "i".toList=s.locals "i".toList := rfl

theorem heap (s : State) (b p p0i e z : BitVec 32) (n : Nat) :
    (after s z b p p0i e n).heap=s.heap := rfl

end FT1536.Source3.ModpDivStep178
