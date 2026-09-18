import CRTStages
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Forward
open FT1536Global

def powFuel : Nat → Int → Nat → Int
  | 0,_,_ => 1
  | fuel+1,z,n => if n=0 then 1 else
      let t:=powFuel fuel z (n/2)
      (t*t*(if n%2=0 then 1 else z))%18433
def powFast (z : Int) (n : Nat) : Int := powFuel n z n

theorem powFuel_correct (fuel : Nat) (z : Int) (n : Nat) (hn : n<2^fuel) : powFuel fuel z n=z^n%18433 := by
  induction fuel generalizing n with
  | zero => have he : n=0 := by simpa using hn; subst n; simp [powFuel]
  | succ fuel ih =>
    rw [powFuel]
    split
    · rename_i he; subst n; simp
    · rename_i hne
      have hn' : n/2<2^fuel := by rw [Nat.pow_succ] at hn; omega
      rw [ih (n/2) hn']
      have he : z^n=z^(n/2)*z^(n/2)*z^(n%2) := by
        have h : n=n/2+n/2+n%2 := by omega
        conv => lhs; rw [h]
        rw [Int.pow_add,Int.pow_add]
      rw [he]
      have hm : n%2=0 ∨ n%2=1 := by omega
      rcases hm with hm|hm
      · simp [hm,Int.mul_emod]
      · simp [hm,Int.pow_one,Int.mul_emod]

theorem powFast_correct (z : Int) (n : Nat) : powFast z n=z^n%18433 :=
  powFuel_correct n z n Nat.lt_two_pow_self

def nodeFromWord (w : Int) (j : Fin 3) : Int := (ordinary w*14648^j.val)%18433
def node (b : Nat) (j : Fin 3) : Int := nodeFromWord (gmAt (512+b)) j
def PhiZero (z : Int) : Prop := (z^1536-z^768+1)%18433=0

-- A leaf certificate binds all source-stage ancestor labels and the three
-- source-expression coefficients. Its soundness will yield hypotheses for
-- the separately proved symbolic global evaluation invariant.
def nodeCheck (i : Nat) (w : Int) (j : Fin 3) : Bool :=
  let pos:=3*(i-512)
  let z:=nodeFromWord w j
  decide (powFast z 768=rootLabel pos%18433) &&
  (forwardSchedule 9 2 768).all (fun p => decide (powFast z (p.2/2)=splitLabel p.1 (p.2/2) pos%18433)) &&
  decide ((powFast z 1536-powFast z 768+1)%18433=0) &&
  ([0,1,2] : List (Fin 3)).all (fun k => decide ((cubeFExpr w fW j).eval (basis k)=powFast z k.val))
def leafCheck (r : List Int) : Bool :=
  if rowID r<512 then true else
    ([0,1,2] : List (Fin 3)).all (fun j => nodeCheck (rowID r).toNat (rowGM r) j)

theorem nodeCheck_sound (i : Nat) (w : Int) (j : Fin 3) (h : nodeCheck i w j=true) :
    let pos:=3*(i-512);let z:=nodeFromWord w j
    z^768%18433=rootLabel pos%18433 ∧
    (∀ p, p∈forwardSchedule 9 2 768 → z^(p.2/2)%18433=splitLabel p.1 (p.2/2) pos%18433) ∧
    PhiZero z ∧ (∀ k, (cubeFExpr w fW j).eval (basis k)=z^k.val%18433) := by
  have hs : ((decide (powFast (nodeFromWord w j) 768=rootLabel (3*(i-512))%18433) &&
      (forwardSchedule 9 2 768).all (fun p => decide (powFast (nodeFromWord w j) (p.2/2)=splitLabel p.1 (p.2/2) (3*(i-512))%18433))) &&
      decide ((powFast (nodeFromWord w j) 1536-powFast (nodeFromWord w j) 768+1)%18433=0))=true ∧
      ([0,1,2] : List (Fin 3)).all (fun k => decide ((cubeFExpr w fW j).eval (basis k)=powFast (nodeFromWord w j) k.val))=true := Bool.and_eq_true_iff.mp h
  obtain ⟨ha,hc⟩:=Bool.and_eq_true_iff.mp hs.1
  obtain ⟨hr,hb⟩:=Bool.and_eq_true_iff.mp ha
  refine ⟨?_,?_,?_,?_⟩
  · simpa only [powFast_correct] using of_decide_eq_true hr
  · intro p hp
    simpa only [powFast_correct] using of_decide_eq_true (List.all_eq_true.mp hb p hp)
  · have hc':=(of_decide_eq_true hc)
    simpa [PhiZero,powFast_correct,Int.add_emod,Int.sub_emod] using hc'
  · intro k
    simpa only [powFast_correct] using of_decide_eq_true (List.all_eq_true.mp hs.2 k (fin3_mem k))

#check @powFast_correct
#check @nodeCheck_sound
#print axioms powFast_correct
#print axioms powFuel_correct
#print axioms nodeCheck_sound
end FT1536Forward
