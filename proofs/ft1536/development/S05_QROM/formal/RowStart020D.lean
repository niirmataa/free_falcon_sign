import KeyWords020D
import MachineAtoms020D
import ScalarExpr020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.RowStart020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020
open Interleaved020D IndexReference020D Residue020D KeyWords020D MachineAtoms020D ScalarExpr020D
open FT1536.Relation FT1536.Run2.PolynomialReference JointInterface019
attribute [local irreducible] exec loopState

def ops : List Code := [set 23 (PairProgram020.exponent 21),loadROM 18 (add (lit 92162) (r 23))]
def code : Code := seqs ops
def result (s : State) (h : Rq) (p : Fin 1536) : State :=
  put (put s 23 (word (exponentN p.val:Int))) 18 (fw (coefficient h (term p)))

theorem run_correct (h : Rq) (tape : Bits tapeSize) (s : State) (p : Fin 1536)
    (h21 : s.reg 21=word (p.val:Int)) : exec (InputLayout020.encode h tape) code s=result s h p := by
  let q := put s 23 (word (exponentN p.val:Int))
  have pe := exponent_bound p.val p.isLt
  have addr : eval q (add (lit 92162) (r 23))=word ((keySlot p).val:Int) := by
    change op .add (word 92162) (q.reg 23)=_
    rw [put_same,add_word (92162:Int) (exponentN p.val:Int) (small_nat 92162 (by decide)) (small_nat _ (by omega))]
    rfl
  have ld : exec (InputLayout020.encode h tape) (loadROM 18 (add (lit 92162) (r 23))) q=result s h p := by
    rw [load_rom_at _ q 18 _ (keySlot p) addr]
    change put q 18 (InputLayout020.image h (keySlot p))=result s h p
    rw [key_word]
    rfl
  simp only [code,ops,exec_seqs_cons,exec_seqs_nil,exec_set,exponent_eval s 21 p.val p.isLt h21]
  exact ld

theorem result_key (s : State) (h : Rq) (p : Fin 1536) :
    (result s h p).reg 18=fw (coefficient h (term p)) := put_same _ _ _
theorem result_exponent (s : State) (h : Rq) (p : Fin 1536) :
    (result s h p).reg 23=word (exponentN p.val:Int) := by
  unfold result;rw [put_other _ 18 23 _ (by decide),put_same]
theorem result_counter (s : State) (h : Rq) (p : Fin 1536) :
    (result s h p).reg 21=s.reg 21 := by
  unfold result;rw [put_other _ 18 21 _ (by decide),put_other _ 23 21 _ (by decide)]
theorem result_memory (s : State) (h : Rq) (p : Fin 1536) :
    (result s h p).ram=s.ram ∧ (result s h p).out=s.out ∧ (result s h p).fault=s.fault := ⟨rfl,rfl,rfl⟩

end FT1536.S05.RowStart020D
