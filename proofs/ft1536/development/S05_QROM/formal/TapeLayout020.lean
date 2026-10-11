import InputLayout020

set_option maxRecDepth 8192
namespace FT1536.S05.TapeLayout020
open StandaloneRuntime019 JointInterface019 InputLayout020

theorem split_left (a b : Nat) (t : Bits (a+b)) (i : Fin a) :
    (split a b t).1 i = t (Fin.castAdd b i) := rfl

theorem split_right (a b : Nat) (t : Bits (a+b)) (i : Fin b) :
    (split a b t).2 i = t (Fin.natAdd a i) := rfl

theorem chunks_apply (n k : Nat) (t : Bits (n*k)) (i : Fin n) (j : Fin k) :
    chunks n k t i j = t (finProdFinEquiv (i,j)) := rfl

/-- The first384 bits of a pair trial in the first vector half. -/
theorem first_word_address (t : Bits 24662538240) (n : Fin 196) (i : Fin 768)
    (a : Fin 80) (j : Fin 384) :
    ((((seedEquiv t).1 n).1 i) a).1 j =
      t (trialAddress n ⟨i.val,by have := i.isLt; omega⟩ a ⟨j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [trialAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem second_word_address (t : Bits 24662538240) (n : Fin 196) (i : Fin 768)
    (a : Fin 80) (j : Fin 384) :
    ((((seedEquiv t).1 n).1 i) a).2.1 j =
      t (trialAddress n ⟨i.val,by have := i.isLt; omega⟩ a ⟨384+j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [trialAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem accept_word_address (t : Bits 24662538240) (n : Fin 196) (i : Fin 768)
    (a : Fin 80) (j : Fin 256) :
    ((((seedEquiv t).1 n).1 i) a).2.2 j =
      t (trialAddress n ⟨i.val,by have := i.isLt; omega⟩ a ⟨768+j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [trialAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem right_first_word_address (t : Bits 24662538240) (n : Fin 196) (i : Fin 768)
    (a : Fin 80) (j : Fin 384) :
    ((((seedEquiv t).1 n).2 i) a).1 j =
      t (trialAddress n ⟨768+i.val,by have := i.isLt; omega⟩ a ⟨j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [trialAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem right_second_word_address (t : Bits 24662538240) (n : Fin 196) (i : Fin 768)
    (a : Fin 80) (j : Fin 384) :
    ((((seedEquiv t).1 n).2 i) a).2.1 j =
      t (trialAddress n ⟨768+i.val,by have := i.isLt; omega⟩ a ⟨384+j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [trialAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem right_accept_word_address (t : Bits 24662538240) (n : Fin 196) (i : Fin 768)
    (a : Fin 80) (j : Fin 256) :
    ((((seedEquiv t).1 n).2 i) a).2.2 j =
      t (trialAddress n ⟨768+i.val,by have := i.isLt; omega⟩ a ⟨768+j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [trialAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem cube_first_word_address (t : Bits 24662538240) (i : Fin 768) (j : Fin 10) :
    ((seedEquiv t).2.1 i).1 j =
      t (cubeAddress ⟨i.val,by have := i.isLt; omega⟩ ⟨j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [cubeAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem cube_second_word_address (t : Bits 24662538240) (i : Fin 768) (j : Fin 10) :
    ((seedEquiv t).2.1 i).2 j =
      t (cubeAddress ⟨i.val,by have := i.isLt; omega⟩ ⟨10+j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [cubeAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem cube_right_first_word_address (t : Bits 24662538240) (i : Fin 768) (j : Fin 10) :
    ((seedEquiv t).2.2 i).1 j =
      t (cubeAddress ⟨768+i.val,by have := i.isLt; omega⟩ ⟨j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [cubeAddress,finProdFinEquiv,finSumFinEquiv]
  omega

theorem cube_right_second_word_address (t : Bits 24662538240) (i : Fin 768) (j : Fin 10) :
    ((seedEquiv t).2.2 i).2 j =
      t (cubeAddress ⟨768+i.val,by have := i.isLt; omega⟩ ⟨10+j.val,by have := j.isLt; omega⟩) := by
  change t _ = t _
  congr 1
  apply Fin.ext
  simp [cubeAddress,finProdFinEquiv,finSumFinEquiv]
  omega

end FT1536.S05.TapeLayout020
