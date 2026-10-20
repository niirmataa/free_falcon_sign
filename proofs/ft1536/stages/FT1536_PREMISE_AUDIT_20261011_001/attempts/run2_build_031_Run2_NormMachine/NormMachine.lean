import Run2.WordEncoding
import FT1536.Geometry

namespace FT1536.Run2.NormMachine
open BitArithmetic FT1536.Geometry

def blockCode (x y : SignedWord) : SignedResult :=
  let xx:=signedMultiply x x; let xy:=signedMultiply x y; let yy:=signedMultiply y y
  let a:=signedAdd xx.word xy.word
  let b:=signedAdd a.word yy.word
  ⟨b.word,xx.steps+xy.steps+yy.steps+a.steps+b.steps+6⟩

theorem blockCode_correct (x y : SignedWord) :
    signedValue (blockCode x y).word=block (signedValue x) (signedValue y) := by
  simp only [blockCode,signedAdd_correct,signedMultiply_correct,block,pow_two]

theorem blockCode_length (x y : SignedWord)
    (hx : x.magnitude.length≤16) (hy : y.magnitude.length≤16) :
    (blockCode x y).word.magnitude.length≤50 := by
  have hxx:=signedMultiply_length x x
  have hxy:=signedMultiply_length x y
  have hyy:=signedMultiply_length y y
  have ha:=signedAdd_length (signedMultiply x x).word (signedMultiply x y).word
  have hb:=signedAdd_length (signedAdd (signedMultiply x x).word (signedMultiply x y).word).word
    (signedMultiply y y).word
  dsimp only [blockCode]
  omega

theorem blockCode_steps (x y : SignedWord)
    (hx : x.magnitude.length≤16) (hy : y.magnitude.length≤16) :
    (blockCode x y).steps≤2^18 := by
  have hxx:=signedMultiply_steps x x
  have hxy:=signedMultiply_steps x y
  have hyy:=signedMultiply_steps y y
  have lxx:=signedMultiply_length x x
  have lxy:=signedMultiply_length x y
  have lyy:=signedMultiply_length y y
  have la:=signedAdd_length (signedMultiply x x).word (signedMultiply x y).word
  have ha:=signedAdd_steps (signedMultiply x x).word (signedMultiply x y).word
  have hb:=signedAdd_steps (signedAdd (signedMultiply x x).word (signedMultiply x y).word).word
    (signedMultiply y y).word
  have cxx : (signedMultiply x x).steps≤64*33*17+1 := by nlinarith
  have cxy : (signedMultiply x y).steps≤64*33*17+1 := by nlinarith
  have cyy : (signedMultiply y y).steps≤64*33*17+1 := by nlinarith
  dsimp only [blockCode]
  omega

def sumResults : List SignedResult → SignedResult
  | [] => ⟨⟨false,[]⟩,1⟩
  | x::xs =>
      let r:=sumResults xs
      let a:=signedAdd x.word r.word
      ⟨a.word,x.steps+r.steps+a.steps+2⟩

theorem sumResults_correct (xs : List SignedResult) :
    signedValue (sumResults xs).word=(xs.map (fun r => signedValue r.word)).sum := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp only [sumResults,signedAdd_correct,List.map_cons,List.sum_cons,ih]

theorem sumResults_length (xs : List SignedResult) (K : ℕ)
    (h : ∀ x∈xs,x.word.magnitude.length≤K) :
    (sumResults xs).word.magnitude.length≤K+xs.length := by
  induction xs with
  | nil => simp [sumResults]
  | cons x xs ih =>
    have hx:=h x (List.mem_cons_self ..)
    have ht:=ih (fun y hy => h y (List.mem_cons_of_mem _ hy))
    have ha:=signedAdd_length x.word (sumResults xs).word
    simp only [sumResults,List.length_cons]
    omega

theorem sumResults_steps (xs : List SignedResult) (K C : ℕ)
    (hl : ∀ x∈xs,x.word.magnitude.length≤K) (hc : ∀ x∈xs,x.steps≤C) :
    (sumResults xs).steps≤(xs.length+1)*(C+32*(K+xs.length+1)+8) := by
  induction xs with
  | nil => simp [sumResults]
  | cons x xs ih =>
    have lx:=hl x (List.mem_cons_self ..)
    have cx:=hc x (List.mem_cons_self ..)
    have lt:=sumResults_length xs K (fun y hy => hl y (List.mem_cons_of_mem _ hy))
    have ct:=ih (fun y hy => hl y (List.mem_cons_of_mem _ hy))
      (fun y hy => hc y (List.mem_cons_of_mem _ hy))
    have ca:=signedAdd_steps x.word (sumResults xs).word
    have hmax : max x.word.magnitude.length (sumResults xs).word.magnitude.length≤K+xs.length := by omega
    simp only [sumResults,List.length_cons]
    nlinarith

def normCode (xs : List (SignedWord × SignedWord)) : SignedResult :=
  sumResults (xs.map fun x => blockCode x.1 x.2)

theorem normCode_correct (xs : List (SignedWord × SignedWord)) :
    signedValue (normCode xs).word=
      (xs.map (fun x => block (signedValue x.1) (signedValue x.2))).sum := by
  simp only [normCode,sumResults_correct,List.map_map,Function.comp_def,blockCode_correct]

theorem normCode_steps (xs : List (SignedWord × SignedWord))
    (hn : xs.length≤1536)
    (h : ∀ x∈xs,x.1.magnitude.length≤16 ∧ x.2.magnitude.length≤16) :
    (normCode xs).steps≤2^30 := by
  have hc:=sumResults_steps (xs.map fun x => blockCode x.1 x.2) 50 (2^18)
    (by intro z hz; obtain ⟨x,hx,rfl⟩:=List.mem_map.mp hz; exact blockCode_length _ _ (h x hx).1 (h x hx).2)
    (by intro z hz; obtain ⟨x,hx,rfl⟩:=List.mem_map.mp hz; exact blockCode_steps _ _ (h x hx).1 (h x hx).2)
  simp only [List.length_map] at hc
  change (sumResults _).steps≤2^30
  nlinarith

end FT1536.Run2.NormMachine
