import Source3.RxLoop210

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RxEntry210
open C99ArrayReference (State Name)
open C99ModularReference (bindParams rxParams)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32)
open RxControl210 (word setI ISlot)

def withX (base : State) (n : Nat) := set32 base "x" (word n)
 def withP (base : State) (n : Nat) (p : BitVec 32) := set32 (withX base n) "p" p
 def withI (base : State) (n : Nat) (p pi : BitVec 32) := set32 (withP base n p) "p0i" pi
 def entry (base : State) (n : Nat) (p pi r2 : BitVec 32) := set32 (withI base n p pi) "R2" r2
 def s1 (base : State) (n : Nat) (p pi r2 : BitVec 32) := C99DeclarationStatements.effect .i32 ["i".toList] (entry base n p pi r2)
 def s2 (base : State) (n : Nat) (p pi r2 : BitVec 32) := C99DeclarationStatements.effect .u32 ["r".toList,"z".toList] (s1 base n p pi r2)
 def s3 (base : State) (n : Nat) (p pi r2 : BitVec 32) := set32 (s2 base n p pi r2) "x" (word (n-1))
 def s4 (base : State) (n : Nat) (p pi r2 : BitVec 32) := set32 (s3 base n p pi r2) "r" r2
 def s5 (base : State) (n : Nat) (p pi r2 : BitVec 32) := set32 (s4 base n p pi r2) "z" (KeygenModpR.word p)
 def beforeLoop (base : State) (n : Nat) (p pi r2 : BitVec 32) := setI (s5 base n p pi r2) 0

theorem binding (base : State) (n : Nat) (p pi r2 : BitVec 32) :
    bindParams base rxParams [.uint32 (word n),.uint32 p,.uint32 pi,.uint32 r2]=entry base n p pi r2 := rfl

theorem xCell (base : State) (n : Nat) (p pi r2 : BitVec 32) : Slot (entry base n p pi r2) "x" (word n) :=
  (CrtState205.keep32 (withI base n p pi) "R2" "x" r2 (by decide)).trans
    ((CrtState205.keep32 (withP base n p) "p0i" "x" pi (by decide)).trans
      ((CrtState205.keep32 (withX base n) "p" "x" p (by decide)).trans (CrtState205.cell32 _ _ _)))

theorem pCell (base : State) (n : Nat) (p pi r2 : BitVec 32) : Slot (entry base n p pi r2) "p" p :=
  (CrtState205.keep32 (withI base n p pi) "R2" "p" r2 (by decide)).trans
    ((CrtState205.keep32 (withP base n p) "p0i" "p" pi (by decide)).trans (CrtState205.cell32 _ _ _))

theorem iCell (base : State) (n : Nat) (p pi r2 : BitVec 32) : Slot (entry base n p pi r2) "p0i" pi :=
  (CrtState205.keep32 (withI base n p pi) "R2" "p0i" r2 (by decide)).trans (CrtState205.cell32 _ _ _)

theorem r2Cell (base : State) (n : Nat) (p pi r2 : BitVec 32) : Slot (entry base n p pi r2) "R2" r2 := CrtState205.cell32 _ _ _

theorem declared_locals (base : State) (n : Nat) (p pi r2 : BitVec 32) (name : Name)
    (absent : name∉["i".toList,"r".toList,"z".toList]) : (s2 base n p pi r2).locals name=(entry base n p pi r2).locals name := by
  have nrz : name∉["r".toList,"z".toList] := fun member => absent (List.mem_cons_of_mem _ member)
  have ni : name≠"i".toList := fun eq => absent (List.mem_cons.mpr (Or.inl eq))
  exact (SelectedStepAddPrime195.effect_locals .u32 ["r".toList,"z".toList] (s1 base n p pi r2) name nrz).trans
    (ZintSubWord194.effect_one_other .i32 "i".toList name (entry base n p pi r2) ni)

theorem param_locals (base : State) (n : Nat) (p pi r2 : BitVec 32) (name : Name)
    (ni : name≠"i".toList) (nz : name≠"z".toList) (nr : name≠"r".toList) (nx : name≠"x".toList) :
    (beforeLoop base n p pi r2).locals name=(entry base n p pi r2).locals name := by
  have absent : name∉["i".toList,"r".toList,"z".toList] := by simpa using (show name≠"i".toList ∧ name≠"r".toList ∧ name≠"z".toList from ⟨ni,nr,nz⟩)
  exact (RxControl210.i_outside (s5 base n p pi r2) 0 name ni).trans
    ((SelectedStepAddPrime195.locals_keep (s4 base n p pi r2) "z".toList .uint32 (.uint32 (KeygenModpR.word p)) name nz).trans
      ((SelectedStepAddPrime195.locals_keep (s3 base n p pi r2) "r".toList .uint32 (.uint32 r2) name nr).trans
        ((SelectedStepAddPrime195.locals_keep (s2 base n p pi r2) "x".toList .uint32 (.uint32 (word (n-1))) name nx).trans
          (declared_locals base n p pi r2 name absent))))

theorem loop_x (base : State) (n : Nat) (p pi r2 : BitVec 32) : Slot (beforeLoop base n p pi r2) "x" (word (n-1)) :=
  (RxControl210.i_outside (s5 base n p pi r2) 0 "x".toList (by decide)).trans
    ((CrtState205.keep32 (s4 base n p pi r2) "z" "x" (KeygenModpR.word p) (by decide)).trans
      ((CrtState205.keep32 (s3 base n p pi r2) "r" "x" r2 (by decide)).trans (CrtState205.cell32 _ _ _)))

theorem loop_r (base : State) (n : Nat) (p pi r2 : BitVec 32) : Slot (beforeLoop base n p pi r2) "r" r2 :=
  (RxControl210.i_outside (s5 base n p pi r2) 0 "r".toList (by decide)).trans
    ((CrtState205.keep32 (s4 base n p pi r2) "z" "r" (KeygenModpR.word p) (by decide)).trans (CrtState205.cell32 _ _ _))

theorem loop_z (base : State) (n : Nat) (p pi r2 : BitVec 32) : Slot (beforeLoop base n p pi r2) "z" (KeygenModpR.word p) :=
  (RxControl210.i_outside (s5 base n p pi r2) 0 "z".toList (by decide)).trans (CrtState205.cell32 _ _ _)

end FT1536.Source3.RxEntry210
