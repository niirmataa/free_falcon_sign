import WordRAM020
import StandaloneRuntime019
import WordBounds018

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.InputLayout020
open WordRAM020 FT1536.Relation

/-- Constants are loaded as a finite public image, never treated as a free
    computation of CDF values at runtime. Key order is exponent order. -/
def image (h : Rq) (a : Fin romSize) : Word :=
  if hc : a.val < 30721 then word (StandaloneRuntime019.tables.cdf ⟨a.val,hc⟩) else
  if ht : a.val < 92162 then word (StandaloneRuntime019.tables.threshold ⟨a.val-30721,by omega⟩) else
  if hk : a.val-92162 < 768 then word ((h ⟨a.val-92162,hk⟩).1.val) else
    word ((h ⟨a.val-92930,by have := a.isLt; simp only [romSize] at this; omega⟩).2.val)

def encode (h : Rq) (tape : Fin tapeSize → Bool) : Input := ⟨tape,image h⟩

theorem tape_unchanged (h : Rq) (tape : Fin tapeSize → Bool) :
    (encode h tape).tape = tape := rfl

theorem nat_word_exact (n : Nat) (hn : n < 2^511) : (word n).toInt = n := by
  apply word_exact
  · exact le_trans (neg_nonpos.mpr (pow_nonneg (by decide) _)) (Nat.cast_nonneg _)
  · exact_mod_cast hn

theorem cdf_exact (h : Rq) (k : Fin 30721) :
    (image h ⟨k.val,by have := k.isLt; simp [romSize]; omega⟩).toInt = StandaloneRuntime019.tables.cdf k := by
  have hk := k.isLt
  have hw := WordBounds018.cdf_width k
  have hn : StandaloneRuntime019.tables.cdf k < 2^511 := by
    change TableData016.cdf k.val < 2^511
    change TableData016.cdf k.val < 2^268 at hw
    exact lt_trans hw (by norm_num)
  simpa only [image,dite_eq_left hk] using nat_word_exact _ hn

theorem threshold_exact (h : Rq) (k : Fin 61441) :
    (image h ⟨30721+k.val,by have := k.isLt; simp [romSize]; omega⟩).toInt = StandaloneRuntime019.tables.threshold k := by
  have hk := k.isLt
  have h0 : ¬30721+k.val < 30721 := by omega
  have h1 : 30721+k.val < 92162 := by omega
  have hw := WordBounds018.threshold_width k
  have hn : StandaloneRuntime019.tables.threshold k < 2^511 := by
    change TableData016.threshold k.val < 2^511
    change TableData016.threshold k.val < 2^257 at hw
    exact lt_trans hw (by norm_num)
  simpa [image,h0,h1] using nat_word_exact _ hn

theorem key_first_exact (h : Rq) (k : Fin 768) :
    (image h ⟨92162+k.val,by have := k.isLt; simp [romSize]; omega⟩).toInt = (h k).1.val := by
  have hk := k.isLt
  have hv := ZMod.val_lt (h k).1
  have hn : (h k).1.val < 2^511 := lt_trans hv (by norm_num)
  have h0 : ¬92162+k.val < 30721 := by omega
  have h1 : ¬92162+k.val < 92162 := by omega
  simpa [image,h0,h1,hk] using nat_word_exact _ hn

theorem key_second_exact (h : Rq) (k : Fin 768) :
    (image h ⟨92930+k.val,by have := k.isLt; simp [romSize]; omega⟩).toInt = (h k).2.val := by
  have hk := k.isLt
  have hv := ZMod.val_lt (h k).2
  have hn : (h k).2.val < 2^511 := lt_trans hv (by norm_num)
  have h0 : ¬92930+k.val < 30721 := by omega
  have h1 : ¬92930+k.val < 92162 := by omega
  have h2 : ¬92930+k.val-92162 < 768 := by omega
  have h3 : 92930+k.val-92930=k.val := by omega
  simpa [image,h0,h1,h2,h3] using nat_word_exact _ hn

/-- Closed physical slots for every attempted pair, including rejected ones. -/
def trialAddress (n : Fin 196) (p : Fin 1536) (k : Fin 80) (j : Fin 1024) : Fin tapeSize :=
  ⟨((n.val*1536+p.val)*80+k.val)*1024+j.val,by
    have := n.isLt; have := p.isLt; have := k.isLt; have := j.isLt
    simp only [tapeSize]; omega⟩

def cubeAddress (p : Fin 1536) (j : Fin 20) : Fin tapeSize :=
  ⟨196*1536*80*1024+p.val*20+j.val,by
    have := p.isLt; have := j.isLt; simp only [tapeSize]; omega⟩

theorem fresh_suffix (n : Fin 196) (p : Fin 1536) (k : Fin 80) (j : Fin 1024)
    (p' : Fin 1536) (j' : Fin 20) :
    trialAddress n p k j ≠ cubeAddress p' j' := by
  have hn := n.isLt; have hp := p.isLt; have hk := k.isLt; have hj := j.isLt
  intro he
  have hv := congrArg Fin.val he
  simp only [trialAddress,cubeAddress] at hv
  omega

theorem trialAddress_injective : Function.Injective
    (fun x : Fin 196 × Fin 1536 × Fin 80 × Fin 1024 => trialAddress x.1 x.2.1 x.2.2.1 x.2.2.2) := by
  rintro ⟨n,p,k,j⟩ ⟨n',p',k',j'⟩ he
  have hv := congrArg Fin.val he
  simp only [trialAddress] at hv
  have := p.isLt; have := p'.isLt; have := k.isLt; have := k'.isLt
  have := j.isLt; have := j'.isLt
  have hj : j=j' := Fin.ext (by omega)
  have hk : k=k' := Fin.ext (by omega)
  have hp : p=p' := Fin.ext (by omega)
  have hn : n=n' := Fin.ext (by omega)
  simp [hn,hp,hk,hj]

theorem cubeAddress_injective : Function.Injective
    (fun x : Fin 1536 × Fin 20 => cubeAddress x.1 x.2) := by
  rintro ⟨p,j⟩ ⟨p',j'⟩ he
  have hv := congrArg Fin.val he
  simp only [cubeAddress] at hv
  have := j.isLt; have := j'.isLt
  have hj : j=j' := Fin.ext (by omega)
  have hp : p=p' := Fin.ext (by omega)
  simp [hp,hj]

end FT1536.S05.InputLayout020
