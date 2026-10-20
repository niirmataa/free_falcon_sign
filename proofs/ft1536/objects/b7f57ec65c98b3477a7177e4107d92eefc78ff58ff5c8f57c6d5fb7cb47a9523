import Mathlib.Tactic
import Std.Tactic.BVDecide

/-!
# SelectBitPreserve — bit-preservation naprawy timingu selecta (dudect floor-ct)

Pin M0 `fpr-emulated.h` (`242a7027…`, linie ~120–131) używał branchless select
na xor-owym bit-tricku:

    xi ^= (xi ^ -(int64_t)t) & -(int64_t)((uint32_t)(63 - cc) >> 31);

Kandydat floor-ct (`6b897d6c…`, commit `fe6f92a`, „bit-preserving floor timing
repair") zastąpił go jawnym selectem unsigned:

    mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
    xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));

Poniższe lematy wykazują, że oba wybory są **równe bitowo dla każdego** słowa
i **każdej** maski (stąd „bit-preserving") — tym samym różnica wersji M0
i kandydata nie wnosi żadnej różnicy semantycznej do modelu: dowody na pinie M0
przenoszą się na binaria kampanii dudect bez zastrzeżeń.
-/

namespace FT1536.FPError.SelectBitPreserve

-- Rdzeń algebraiczny: xor-select ≡ mux-select dla KAŻDEJ maski (bitowo).
theorem select_bits_equiv (a b m : BitVec 64) :
    a ^^^ (a ^^^ b) &&& m = (a &&& ~~~m) ||| (b &&& m) := by
  bv_decide

-- Postać rzeczywistego kodu: z `xi = a`, `t' = -t`, stary select
-- `xi ^= (xi ^ t') & mask` daje ten sam bit-pattern co nowy mux.

theorem select_old_eq_new (a t m : BitVec 64) :
    a ^^^ (a ^^^ t) &&& m = (a &&& ~~~m) ||| (t &&& m) :=
  select_bits_equiv a t m

-- Maska pochodna kodu: dla surowego bitu s ∈ {0,1} rozszerzenia
-- zero i sign dają tę samą maskę (0 albo wszystkie jedynki),
-- a negacja jest ich wspólnym selectem.

theorem mask_extend_eq (s : BitVec 32) (hs : s = 0#32 ∨ s = 1#32) :
    -s.zeroExtend 64 = -s.signExtend 64 := by
  rcases hs with h | h <;> subst h <;> bv_decide

-- Pełna zgodność obu wariantów na poziomie słów: stary wiersz kodu
-- (z maską z rozszerzenia sign) i nowy (z maską z rozszerzenia zero)
-- produkują identyczne słowo wynikowe.

theorem select_code_variants_equiv (xi t : BitVec 64) (s : BitVec 32)
    (hs : s = 0#32 ∨ s = 1#32) :
    xi ^^^ (xi ^^^ (-t)) &&& (-s.signExtend 64)
      = (xi &&& ~~~(-s.zeroExtend 64)) ||| ((-t) &&& (-s.zeroExtend 64)) := by
  have hm : (-s.signExtend 64) = (-s.zeroExtend 64) := (mask_extend_eq s hs).symm
  rw [hm]
  exact select_bits_equiv xi (-t) (-s.zeroExtend 64)

#print axioms select_bits_equiv
#print axioms select_old_eq_new
#print axioms mask_extend_eq
#print axioms select_code_variants_equiv

end FT1536.FPError.SelectBitPreserve
