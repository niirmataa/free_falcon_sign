import Source3.KeygenPublicRev
import Source3.KeygenMkgm3IndexCert

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete kernel check of all public table-generator indices. The source
   execution theorem is separate and universal over uint32 words. -/
namespace FT1536.Source3.KeygenPublicRevCert
def Correct (i : Nat) : Prop :=
  (KeygenPublicRev.reversed 10 (BitVec.ofNat 32 i) 0).toNat=KeygenRev10.bitrev10 i ∧
    KeygenRev10.bitrev10 i<1024
instance (i : Nat) : Decidable (Correct i) := by unfold Correct; infer_instance
theorem chunk00 : ∀ j : Fin 16, Correct (0+j.val) := by decide
theorem chunk01 : ∀ j : Fin 16, Correct (16+j.val) := by decide
theorem chunk02 : ∀ j : Fin 16, Correct (32+j.val) := by decide
theorem chunk03 : ∀ j : Fin 16, Correct (48+j.val) := by decide
theorem chunk04 : ∀ j : Fin 16, Correct (64+j.val) := by decide
theorem chunk05 : ∀ j : Fin 16, Correct (80+j.val) := by decide
theorem chunk06 : ∀ j : Fin 16, Correct (96+j.val) := by decide
theorem chunk07 : ∀ j : Fin 16, Correct (112+j.val) := by decide
theorem chunk08 : ∀ j : Fin 16, Correct (128+j.val) := by decide
theorem chunk09 : ∀ j : Fin 16, Correct (144+j.val) := by decide
theorem chunk10 : ∀ j : Fin 16, Correct (160+j.val) := by decide
theorem chunk11 : ∀ j : Fin 16, Correct (176+j.val) := by decide
theorem chunk12 : ∀ j : Fin 16, Correct (192+j.val) := by decide
theorem chunk13 : ∀ j : Fin 16, Correct (208+j.val) := by decide
theorem chunk14 : ∀ j : Fin 16, Correct (224+j.val) := by decide
theorem chunk15 : ∀ j : Fin 16, Correct (240+j.val) := by decide
theorem chunk16 : ∀ j : Fin 16, Correct (256+j.val) := by decide
theorem chunk17 : ∀ j : Fin 16, Correct (272+j.val) := by decide
theorem chunk18 : ∀ j : Fin 16, Correct (288+j.val) := by decide
theorem chunk19 : ∀ j : Fin 16, Correct (304+j.val) := by decide
theorem chunk20 : ∀ j : Fin 16, Correct (320+j.val) := by decide
theorem chunk21 : ∀ j : Fin 16, Correct (336+j.val) := by decide
theorem chunk22 : ∀ j : Fin 16, Correct (352+j.val) := by decide
theorem chunk23 : ∀ j : Fin 16, Correct (368+j.val) := by decide
theorem chunk24 : ∀ j : Fin 16, Correct (384+j.val) := by decide
theorem chunk25 : ∀ j : Fin 16, Correct (400+j.val) := by decide
theorem chunk26 : ∀ j : Fin 16, Correct (416+j.val) := by decide
theorem chunk27 : ∀ j : Fin 16, Correct (432+j.val) := by decide
theorem chunk28 : ∀ j : Fin 16, Correct (448+j.val) := by decide
theorem chunk29 : ∀ j : Fin 16, Correct (464+j.val) := by decide
theorem chunk30 : ∀ j : Fin 16, Correct (480+j.val) := by decide
theorem chunk31 : ∀ j : Fin 16, Correct (496+j.val) := by decide
theorem chunk32 : ∀ j : Fin 16, Correct (512+j.val) := by decide
theorem chunk33 : ∀ j : Fin 16, Correct (528+j.val) := by decide
theorem chunk34 : ∀ j : Fin 16, Correct (544+j.val) := by decide
theorem chunk35 : ∀ j : Fin 16, Correct (560+j.val) := by decide
theorem chunk36 : ∀ j : Fin 16, Correct (576+j.val) := by decide
theorem chunk37 : ∀ j : Fin 16, Correct (592+j.val) := by decide
theorem chunk38 : ∀ j : Fin 16, Correct (608+j.val) := by decide
theorem chunk39 : ∀ j : Fin 16, Correct (624+j.val) := by decide
theorem chunk40 : ∀ j : Fin 16, Correct (640+j.val) := by decide
theorem chunk41 : ∀ j : Fin 16, Correct (656+j.val) := by decide
theorem chunk42 : ∀ j : Fin 16, Correct (672+j.val) := by decide
theorem chunk43 : ∀ j : Fin 16, Correct (688+j.val) := by decide
theorem chunk44 : ∀ j : Fin 16, Correct (704+j.val) := by decide
theorem chunk45 : ∀ j : Fin 16, Correct (720+j.val) := by decide
theorem chunk46 : ∀ j : Fin 16, Correct (736+j.val) := by decide
theorem chunk47 : ∀ j : Fin 16, Correct (752+j.val) := by decide
theorem chunk48 : ∀ j : Fin 16, Correct (768+j.val) := by decide
theorem chunk49 : ∀ j : Fin 16, Correct (784+j.val) := by decide
theorem chunk50 : ∀ j : Fin 16, Correct (800+j.val) := by decide
theorem chunk51 : ∀ j : Fin 16, Correct (816+j.val) := by decide
theorem chunk52 : ∀ j : Fin 16, Correct (832+j.val) := by decide
theorem chunk53 : ∀ j : Fin 16, Correct (848+j.val) := by decide
theorem chunk54 : ∀ j : Fin 16, Correct (864+j.val) := by decide
theorem chunk55 : ∀ j : Fin 16, Correct (880+j.val) := by decide
theorem chunk56 : ∀ j : Fin 16, Correct (896+j.val) := by decide
theorem chunk57 : ∀ j : Fin 16, Correct (912+j.val) := by decide
theorem chunk58 : ∀ j : Fin 16, Correct (928+j.val) := by decide
theorem chunk59 : ∀ j : Fin 16, Correct (944+j.val) := by decide
theorem chunk60 : ∀ j : Fin 16, Correct (960+j.val) := by decide
theorem chunk61 : ∀ j : Fin 16, Correct (976+j.val) := by decide
theorem chunk62 : ∀ j : Fin 16, Correct (992+j.val) := by decide
theorem chunk63 : ∀ j : Fin 16, Correct (1008+j.val) := by decide
theorem all_indices (i : Nat) (hi : i<1024) : Correct i := by
  have chunks : ∀ b : Fin 64, ∀ j : Fin 16, Correct (16*b.val+j.val) := by
    intro b
    fin_cases b
    · exact chunk00
    · exact chunk01
    · exact chunk02
    · exact chunk03
    · exact chunk04
    · exact chunk05
    · exact chunk06
    · exact chunk07
    · exact chunk08
    · exact chunk09
    · exact chunk10
    · exact chunk11
    · exact chunk12
    · exact chunk13
    · exact chunk14
    · exact chunk15
    · exact chunk16
    · exact chunk17
    · exact chunk18
    · exact chunk19
    · exact chunk20
    · exact chunk21
    · exact chunk22
    · exact chunk23
    · exact chunk24
    · exact chunk25
    · exact chunk26
    · exact chunk27
    · exact chunk28
    · exact chunk29
    · exact chunk30
    · exact chunk31
    · exact chunk32
    · exact chunk33
    · exact chunk34
    · exact chunk35
    · exact chunk36
    · exact chunk37
    · exact chunk38
    · exact chunk39
    · exact chunk40
    · exact chunk41
    · exact chunk42
    · exact chunk43
    · exact chunk44
    · exact chunk45
    · exact chunk46
    · exact chunk47
    · exact chunk48
    · exact chunk49
    · exact chunk50
    · exact chunk51
    · exact chunk52
    · exact chunk53
    · exact chunk54
    · exact chunk55
    · exact chunk56
    · exact chunk57
    · exact chunk58
    · exact chunk59
    · exact chunk60
    · exact chunk61
    · exact chunk62
    · exact chunk63
  have hb : i/16<64 := by omega
  have hj : i%16<16 := Nat.mod_lt i (by decide)
  have certificate := chunks ⟨i/16,hb⟩ ⟨i%16,hj⟩
  have index : 16*(i/16)+i%16=i := by omega
  simpa only [index] using certificate
theorem source_bitrev (x : BitVec 32) (v : C99IntegerReference.Value) (hx : x.toNat<1024)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .rev) [.uint32 x] v) :
    v=.uint32 (BitVec.ofNat 32 (KeygenRev10.bitrev10 x.toNat)) ∧
      KeygenRev10.bitrev10 x.toNat<1024 := by
  have certificate := all_indices x.toNat hx
  have equal := KeygenPublicRev.source_result x v source
  refine ⟨equal.trans ?_,certificate.2⟩
  congr 1
  apply BitVec.eq_of_toNat_eq
  have word : BitVec.ofNat 32 x.toNat=x := by simp
  have returnNat : (KeygenPublicRev.reversed 10 x 0).toNat=KeygenRev10.bitrev10 x.toNat := by
    have result := certificate.1
    rw [word] at result
    exact result
  rw [returnNat,BitVec.toNat_ofNat,Nat.mod_eq_of_lt (by have bound := certificate.2; omega)]
theorem source_last_index (u : Nat) (hu : u<512) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .rev)
      [.uint32 (BitVec.ofNat 32 (2*u))] v) :
    v=.uint32 (BitVec.ofNat 32 (KeygenMkgm3Indices.reverse9 u)) ∧
      KeygenMkgm3Indices.reverse9 u<512 := by
  have exactInput : (BitVec.ofNat 32 (2*u)).toNat=2*u := Nat.mod_eq_of_lt (by omega)
  have result := (source_bitrev _ v (by rw [exactInput]; omega) source).1
  rw [exactInput] at result
  exact ⟨result,((KeygenMkgm3IndexCert.all_indices u (by omega)).1 hu).1⟩
end FT1536.Source3.KeygenPublicRevCert
