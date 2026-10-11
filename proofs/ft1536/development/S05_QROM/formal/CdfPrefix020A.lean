import ReadWordSites020A
import SearchBounds020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CdfPrefix020A
open WordRAM020 WordArithmetic020 PairProgram020 ReadSemantics020A BitValue020A SearchBounds020A

abbrev nw (n : Nat) : Word := word (n : Int)

@[simp] theorem exec_branch (i : Input) (s : State) (e : Expr) (yes no : Code) :
    exec i (.branch e yes no) s=(if eval s e=0 then exec i no s else exec i yes s) := by
  simp only [exec,run]
  split <;> rfl
@[simp] theorem exec_rom (i : Input) (s : State) (dst : Reg) (a : Expr) :
    exec i (loadROM dst a) s=(match address romSize (eval s a) with
    | none => fail s | some k => put s dst (i.rom k)) := rfl

def prefixList : List Code := [
  set 10 (div (r 9) (lit 2)),set 11 (add (r 8) (r 10)),
  .branch (lt (r 11) (lit 30721)) (set 30 (r 11)) (set 30 (lit 30720)),
  loadROM 12 (r 30)]

def loaded (s : State) (lo len : Nat) (cdf : Nat → Nat) : State :=
  put (put (put (put s 10 (nw (len/2))) 11 (nw (lo+len/2))) 30 (nw (lo+len/2)))
    12 (nw (cdf (lo+len/2)))

/-- Fixed public table image. Only real in-range addresses are required. -/
def Image (i : Input) (cdf : Nat → Nat) : Prop := ∀ k : Fin 30721,
  i.rom ⟨k.val,by have := k.isLt; simp only [romSize]; omega⟩=nw (cdf k.val)

/-- The actual four-instruction CDF prefix; even the clamp branch is discharged
    from the reachable interval bound, rather than assumed in a trace. -/
theorem prefix_correct (i : Input) (cdf : Nat → Nat) (s : State) (lo len : Nat)
    (image : Image i cdf) (hlo : s.reg 8=nw lo) (hlen : s.reg 9=nw len)
    (hp : 0<len) (hbound : lo+len≤30721) :
    exec i (seqs prefixList) s=loaded s lo len cdf := by
  have hi := (interval_step lo len hp hbound).1
  have flo : Fits (lo : Int) := tiny_fits (by omega)
  have flen : Fits (len : Int) := tiny_fits (by omega)
  have fmid : Fits ((len/2 : Nat) : Int) := tiny_fits (by omega)
  have fidx : Fits ((lo+len/2 : Nat) : Int) := tiny_fits (by omega)
  have f2 : Fits (2 : Int) := by norm_num [Fits]
  have f30721 : Fits (30721 : Int) := by norm_num [Fits]
  have emid : eval s (div (r 9) (lit 2))=nw (len/2) := by
    change op .div (s.reg 9) (word 2)=_
    rw [hlen,div_word _ _ flen f2]
    rfl
  let s1 := put s 10 (nw (len/2))
  have eidx : eval s1 (add (r 8) (r 10))=nw (lo+len/2) := by
    change op .add (s1.reg 8) (s1.reg 10)=_
    dsimp [s1]
    rw [put_other _ 10 8 _ (by decide),put_same,hlo]
    exact add_word _ _ flo fmid
  let s2 := put s1 11 (nw (lo+len/2))
  have eguard : eval s2 (lt (r 11) (lit 30721))=word 1 := by
    change op .lt (s2.reg 11) (word 30721)=_
    rw [put_same,lt_word _ _ fidx f30721]
    have hi' : ((lo+len/2 : Nat) : Int)<30721 := by exact_mod_cast hi
    rw [ite_eq_left hi']
  have branch : exec i (.branch (lt (r 11) (lit 30721)) (set 30 (r 11)) (set 30 (lit 30720))) s2 =
      put s2 30 (nw (lo+len/2)) := by
    rw [exec_branch,eguard,ite_eq_right (show word 1≠0 by decide),exec_set]
    change put s2 30 (s2.reg 11)=_
    rw [put_same]
  let s3 := put s2 30 (nw (lo+len/2))
  have load : exec i (loadROM 12 (r 30)) s3=put s3 12 (nw (cdf (lo+len/2))) := by
    rw [exec_rom]
    change (match address romSize (s3.reg 30) with
      | none => fail s3 | some k => put s3 12 (i.rom k))=_
    rw [put_same]
    have hr : lo+len/2<romSize := by simp only [romSize]; omega
    have hw : ((lo+len/2 : Nat) : Int)<2^511 := fidx.2
    rw [address_exact romSize (lo+len/2) hr hw]
    change put s3 12 (i.rom ⟨lo+len/2,hr⟩)=_
    exact congrArg (put s3 12) (image ⟨lo+len/2,hi⟩)
  simp only [prefixList,exec_seqs_cons,exec_seqs_nil,exec_set,emid]
  change exec i (loadROM 12 (r 30))
    (exec i (.branch (lt (r 11) (lit 30721)) (set 30 (r 11)) (set 30 (lit 30720)))
      (put s1 11 (eval s1 (add (r 8) (r 10))))) = _
  rw [eidx,branch,load]
  rfl

end FT1536.S05.CdfPrefix020A
