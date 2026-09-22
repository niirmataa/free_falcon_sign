/-!
# FTFamily.Layout — rekurencje rozmiaru drzewa ffLDL_fft3 (kernel Lean 4)

Źródło (Extra/c, manifest 56974571...): falcon-keygen.c
`ffLDL_inner_fft3_keygen` (baza 4 słowa + dwa poddrzewa),
`ffLDL_depth1_fft3_keygen` (3*2^j słów L + trzy poddrzewa wewnętrzne),
`ffLDL_fft3_keygen` (3*2^(ell-1) słów L + dwa poddrzewa depth1).

Parametryzacja: k = logn - 2 >= 0, tzn. wierzchołek ma logn = k+2 i stopień
N = 3*2^(k+1). Definicje odpowiadają blokom kodu:

  Srec k   — poddrzewo wewnętrzne o logn = k (2^k słów L + dwa dzieci),
  Dfun k   — węzeł depth1 o logn = k+1 (3*2^(k+1) słów L + trzy Srec k),
  Tfun k   — wierzchołek o logn = k+2 (3*2^(k+1) słów L + dwa Dfun k).

Główna tożsamość `tfun_closed`: T = (logn+2)*N = (k+4)*N. Instancje dla
FT768/FT1536/FT3072 (k = 7/8/9) sprawdzone przez kernel. To analiza layoutu
przy niezmienionej strukturze źródeł — nie dowód implementacji FT768/FT3072.

Log kompilacji jest czysty; nie użyto sorry/admit/native_decide.
-/

namespace FTFamily

/-- Rozmiar poddrzewa wewnętrznego o logn = k (baza: 2 L-słowa + 2 liście). -/
def Srec : Nat → Nat
  | 0 => 1
  | k + 1 => 2 ^ (k + 1) + 2 * Srec k

/-- Zamknięta postać: S(k) = (k+1) * 2^k. -/
theorem srec_closed (k : Nat) : Srec k = (k + 1) * 2 ^ k := by
  induction k with
  | zero => rfl
  | succ k ih =>
    unfold Srec
    rw [ih, Nat.pow_succ]
    calc 2 ^ k * 2 + 2 * ((k + 1) * 2 ^ k)
        = 2 ^ k * 2 + (k + 1) * (2 * 2 ^ k) := by
          rw [Nat.mul_left_comm]
      _ = 2 ^ k * 2 + (k + 1) * (2 ^ k * 2) := by
          rw [Nat.mul_comm 2 (2 ^ k)]
      _ = (k + 2) * (2 ^ k * 2) := by
          rw [Nat.add_comm (2 ^ k * 2) ((k + 1) * (2 ^ k * 2)), ← Nat.succ_mul]
      _ = (k + 2) * 2 ^ (k + 1) := by
          rw [Nat.pow_succ]

/-- Węzeł depth1 o logn = k+1: L + trzy poddrzewa o logn = k. -/
def Dfun (k : Nat) : Nat := 3 * 2 ^ (k + 1) + 3 * Srec k

/-- Zamknięta postać: D(k+1) = 3*2^(k+1) + 3*(k+1)*2^k. -/
theorem dfun_closed (k : Nat) :
    Dfun k = 3 * 2 ^ (k + 1) + 3 * ((k + 1) * 2 ^ k) := by
  unfold Dfun
  rw [srec_closed]

/-- Wierzchołek o logn = k+2: L + dwa poddrzewa depth1. -/
def Tfun (k : Nat) : Nat := 3 * 2 ^ (k + 1) + 2 * Dfun k

/-- Stopień N wierzchołka o logn = k+2. -/
def Ndeg (k : Nat) : Nat := 3 * 2 ^ (k + 1)

/-- Główna tożsamość parametryczna: T = (logn+2) * N. -/
theorem tfun_closed (k : Nat) : Tfun k = (k + 4) * Ndeg k := by
  unfold Tfun Dfun Ndeg
  rw [srec_closed]
  have hmid : 2 * (3 * ((k + 1) * 2 ^ k)) = (k + 1) * (3 * 2 ^ (k + 1)) := by
    rw [Nat.mul_left_comm 2 3, Nat.mul_left_comm 2 (k + 1),
      Nat.mul_comm 2 (2 ^ k), ← Nat.pow_succ,
      Nat.mul_left_comm 3 (k + 1) (2 ^ (k + 1))]
  rw [Nat.mul_add 2 (3 * 2 ^ (k + 1)) (3 * ((k + 1) * 2 ^ k)), hmid]
  have hx : 2 * (3 * 2 ^ (k + 1)) + (k + 1) * (3 * 2 ^ (k + 1))
      = (2 + (k + 1)) * (3 * 2 ^ (k + 1)) := by
    rw [Nat.add_mul 2 (k + 1)]
  rw [hx]
  have hy : 3 * 2 ^ (k + 1) + (2 + (k + 1)) * (3 * 2 ^ (k + 1))
      = (k + 4) * (3 * 2 ^ (k + 1)) := by
    rw [Nat.add_comm (3 * 2 ^ (k + 1)) ((2 + (k + 1)) * (3 * 2 ^ (k + 1))),
      ← Nat.succ_mul]
    congr 1
    omega
  rw [hy]

/-- Liczba słów liści w całym drzewie równa się N. -/
theorem leaf_words_eq (k : Nat) : 6 * 2 ^ k = Ndeg k := by
  unfold Ndeg
  have h6 : 6 = 3 * 2 := rfl
  rw [h6, Nat.mul_assoc, Nat.mul_comm 2 (2 ^ k), ← Nat.pow_succ]

-- Instancje dla FT768 (k=7), FT1536 (k=8), FT3072 (k=9):
-- kernel sprawdza dokładne liczby słów z raportów i layoutu.

example : Ndeg 7 = 768 := by decide
example : Ndeg 8 = 1536 := by decide
example : Ndeg 9 = 3072 := by decide

example : Tfun 7 = 8448 := by decide
example : Tfun 8 = 18432 := by decide
example : Tfun 9 = 39936 := by decide

example : (7 + 4) * Ndeg 7 = 8448 := by decide
example : (8 + 4) * Ndeg 8 = 18432 := by decide
example : (9 + 4) * Ndeg 9 = 39936 := by decide

example : 4 * Ndeg 8 = 6144 := by decide
example : 4 * Ndeg 8 + Tfun 8 = 24576 := by decide
example : 7 * Ndeg 8 = 10752 := by decide

example : Srec 8 = 2304 := by decide
example : Srec 7 = 1024 := by decide
example : Srec 6 = 448 := by decide
example : Dfun 8 = 8448 := by decide

example : 4 * Ndeg 7 + Tfun 7 = 11520 := by decide
example : 4 * Ndeg 9 + Tfun 9 = 52224 := by decide
example : 7 * Ndeg 7 = 5376 := by decide
example : 7 * Ndeg 9 = 21504 := by decide

-- Scratch: model z poprawionym maximum (dwa źródła zapisu na bazie t2:
-- rekurencja dziecka oraz własny zapis d11 przez t2, 2^r słów).
def Wrec : Nat → Nat
  | 0 => 0
  | 1 => 2
  | r + 2 => max (2 ^ (r + 2) + Wrec (r + 1)) (2 ^ (r + 3))

/-- Zamknięta postać scratch: W(r) = 2^(r+1) dla r >= 2. -/
theorem wrec_closed (r : Nat) : Wrec (r + 2) = 2 ^ (r + 3) := by
  induction r with
  | zero => decide
  | succ r ih =>
    have h2 : 2 * 2 ^ (r + 3) = 2 ^ (r + 4) := by
      rw [Nat.mul_comm, ← Nat.pow_succ]
    show max (2 ^ (r + 3) + Wrec (r + 2)) (2 ^ (r + 4)) = 2 ^ (r + 4)
    rw [ih, ← Nat.two_mul, h2, Nat.max_self]

/-- Scratch depth1 o logn = j: t2 przy 3*2^j, potem max(2^j, W(j-1)). -/
def Dtmp (j : Nat) : Nat := 3 * 2 ^ j + max (2 ^ j) (Wrec (j - 1))

/-- Scratch wierzchołka o logn = ell: baza t3 przy 3*2^(ell-1). -/
def Wtop (ell : Nat) : Nat :=
  3 * 2 ^ (ell - 1) + max (3 * 2 ^ (ell - 1)) (Dtmp (ell - 1))

example : Wrec 2 = 8 := by decide
example : Wrec 8 = 512 := by decide
example : Dtmp 9 = 2048 := by decide
example : Wtop 9 = 1792 := by decide
example : Wtop 10 = 3584 := by decide
example : Wtop 11 = 7168 := by decide
example : 3 * 1536 + Wtop 10 = 8192 := by decide

end FTFamily
