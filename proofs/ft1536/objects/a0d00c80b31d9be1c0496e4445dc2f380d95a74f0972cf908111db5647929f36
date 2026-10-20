import Run2.BitArithmetic

namespace FT1536.Run2.LocalBitCode

/- Finite binary code for the local A/S interface. There is no constructor
carrying an arbitrary mathematical function with a user-assigned price.
Addresses are unary; complete code storage and output copying are charged.
The public reduction's arithmetic is compiled separately to bit procedures. -/
inductive Code where
  | output : List Bool → Code
  | read : ℕ → Code → Code → Code

def codeBits : Code → ℕ
  | .output xs => 2*xs.length+2
  | .read n no yes => n+3+codeBits no+codeBits yes

def depth : Code → ℕ
  | .output _ => 0
  | .read _ no yes => 1+max (depth no) (depth yes)

def probe : List Bool → ℕ → Bool × ℕ
  | [],_ => (false,1)
  | b::_,0 => (b,1)
  | _::xs,n+1 => let r:=probe xs n; (r.1,r.2+2)

theorem probe_correct (xs : List Bool) (n : ℕ) : (probe xs n).1=xs[n]?.getD false := by
  induction xs generalizing n with
  | nil => simp [probe]
  | cons b xs ih => cases n <;> simp [probe,ih]

theorem probe_steps (xs : List Bool) (n : ℕ) : (probe xs n).2≤2*xs.length+1 := by
  induction xs generalizing n with
  | nil => simp [probe]
  | cons b xs ih =>
    cases n with
    | zero => simp [probe]
    | succ n => have hh:=ih n; simp only [probe,List.length_cons]; omega

/- Each branch pays a scan of its code block, so no jump over an arbitrarily
large sibling code block is considered a free random access. -/
def run (input : List Bool) : Code → BitArithmetic.Result
  | .output xs => ⟨xs,2*xs.length+2⟩
  | .read n no yes =>
      let p:=probe input n
      let r:=if p.1 then run input yes else run input no
      ⟨r.bits,p.2+codeBits (.read n no yes)+r.steps+4⟩

theorem output_length (input : List Bool) (code : Code) :
    (run input code).bits.length≤codeBits code := by
  induction code with
  | output xs => simp only [run,codeBits]; omega
  | read n no yes hn hy =>
    simp only [run,codeBits]
    split <;> omega

theorem code_positive (code : Code) : 0<codeBits code := by
  cases code <;> simp [codeBits]

def timeBound (inputBits : ℕ) (code : Code) : ℕ :=
  (depth code+1)*(2*inputBits+3*codeBits code+8)

theorem run_steps (input : List Bool) (code : Code) :
    (run input code).steps≤timeBound input.length code := by
  induction code with
  | output xs => simp [run,timeBound,depth,codeBits]; omega
  | read n no yes hn hy =>
    have hp:=probe_steps input n
    have hlo : codeBits no≤codeBits (.read n no yes) := by simp only [codeBits]; omega
    have hhi : codeBits yes≤codeBits (.read n no yes) := by simp only [codeBits]; omega
    have dno : depth no≤max (depth no) (depth yes) := Nat.le_max_left ..
    have dyes : depth yes≤max (depth no) (depth yes) := Nat.le_max_right ..
    have ncap := Nat.mul_le_mul (Nat.add_le_add_right dno 1)
      (show 2*input.length+3*codeBits no+8≤2*input.length+3*codeBits (.read n no yes)+8 by omega)
    have ycap := Nat.mul_le_mul (Nat.add_le_add_right dyes 1)
      (show 2*input.length+3*codeBits yes+8≤2*input.length+3*codeBits (.read n no yes)+8 by omega)
    unfold timeBound at hn hy ⊢
    simp only [run,depth]
    split <;> nlinarith

/- Full static code, input, output and unary navigation path. This is the
declared finite-file machine's space envelope; neither code nor input is
silently omitted from the local certificate. -/
def workspace (input : List Bool) (code : Code) : ℕ :=
  input.length+codeBits code+(run input code).bits.length+depth code+8

def spaceBound (inputBits : ℕ) (code : Code) : ℕ := inputBits+2*codeBits code+depth code+8

theorem timeBound_mono (code : Code) {n N : ℕ} (h : n≤N) :
    timeBound n code≤timeBound N code := by
  unfold timeBound
  exact Nat.mul_le_mul_left _ (by omega)

theorem spaceBound_mono (code : Code) {n N : ℕ} (h : n≤N) :
    spaceBound n code≤spaceBound N code := by
  unfold spaceBound
  omega

theorem workspace_bound (input : List Bool) (code : Code) :
    workspace input code≤spaceBound input.length code := by
  have hh:=output_length input code
  unfold workspace spaceBound
  omega

end FT1536.Run2.LocalBitCode
