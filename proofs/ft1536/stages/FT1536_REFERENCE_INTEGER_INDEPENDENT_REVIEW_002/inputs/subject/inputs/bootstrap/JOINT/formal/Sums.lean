import Pipeline
set_option maxRecDepth 16384
set_option maxHeartbeats 30000000
namespace FT1536Forward

def sumN : Nat → (Nat → Int) → Int
  | 0,_ => 0
  | n+1,f => sumN n f+f n

theorem sum_congr (n : Nat) (f g : Nat → Int) (h : ∀ i, i<n → f i=g i) : sumN n f=sumN n g := by
  induction n with
  | zero => rfl
  | succ n ih => rw [sumN,sumN,ih (fun i hi => h i (by omega)),h n (by omega)]
theorem sum_zero (n : Nat) : sumN n (fun _ => 0)=0 := by induction n <;> simp_all [sumN]
theorem sum_add (n : Nat) (f g : Nat → Int) : sumN n (fun i => f i+g i)=sumN n f+sumN n g := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [sumN,ih]; omega
theorem sum_sub (n : Nat) (f g : Nat → Int) : sumN n (fun i => f i-g i)=sumN n f-sumN n g := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [sumN,ih]; omega
theorem sum_scale (n : Nat) (c : Int) (f : Nat → Int) : sumN n (fun i => c*f i)=c*sumN n f := by
  induction n <;> simp_all [sumN,Int.mul_add]
theorem sum_scale_right (n : Nat) (c : Int) (f : Nat → Int) : sumN n (fun i => f i*c)=sumN n f*c := by
  simpa only [Int.mul_comm] using sum_scale n c f
theorem sum_split (n m : Nat) (f : Nat → Int) : sumN (n+m) f=sumN n f+sumN m (fun i => f (n+i)) := by
  induction m <;> simp_all [sumN,Int.add_assoc]
theorem sum_mod (n : Nat) (f : Nat → Int) : (sumN n (fun i => f i%18433))%18433=(sumN n f)%18433 := by
  induction n <;> simp_all [sumN,Int.add_emod]
theorem sum_congr_mod (n : Nat) (f g : Nat → Int) (h : ∀ i, i<n → f i%18433=g i%18433) :
    sumN n f%18433=sumN n g%18433 := by
  rw [←sum_mod n f,←sum_mod n g,sum_congr n _ _ h]
theorem sum_swap (n m : Nat) (f : Nat → Nat → Int) :
    sumN n (fun i => sumN m (f i))=sumN m (fun j => sumN n (fun i => f i j)) := by
  induction n with
  | zero => simp only [sumN,sum_zero]
  | succ n ih => simp only [sumN,sum_add,ih]

theorem sum_delta (n k : Nat) (f : Nat → Int) :
    sumN n (fun j => if j=k then f j else 0)=if k<n then f k else 0 := by
  induction n with
  | zero => simp [sumN]
  | succ n ih =>
    by_cases he : k=n
    · subst k; simp [sumN,ih]
    · by_cases hl : k<n
      · have hl1 : k<n+1 := by omega
        simp [sumN,ih,Ne.symm he,hl,hl1]
      · have hl1 : ¬k<n+1 := by omega
        simp [sumN,ih,Ne.symm he,hl,hl1]

theorem sum_ofFn (n : Nat) (f : Nat → Int) :
    (List.ofFn (fun i : Fin n => f i.val)).foldl (·+·) 0=sumN n f := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [List.ofFn_succ_last,List.foldl_append]
    change (List.ofFn (fun i : Fin n => f i.val)).foldl (·+·) 0+f n=sumN n f+f n
    rw [ih]
theorem sum_ofFn_congr (n : Nat) (f : Fin n → Int) (g : Nat → Int) (h : ∀ i, f i=g i.val) :
    (List.ofFn f).foldl (·+·) 0=sumN n g := by
  have he : f=(fun i => g i.val) := funext h
  rw [he,sum_ofFn]

#check @sum_congr_mod
#check @sum_swap
#check @sum_ofFn_congr
#print axioms sum_congr
#print axioms sum_zero
#print axioms sum_add
#print axioms sum_sub
#print axioms sum_scale
#print axioms sum_scale_right
#print axioms sum_split
#print axioms sum_mod
#print axioms sum_congr_mod
#print axioms sum_swap
#print axioms sum_delta
#print axioms sum_ofFn
#print axioms sum_ofFn_congr
end FT1536Forward
