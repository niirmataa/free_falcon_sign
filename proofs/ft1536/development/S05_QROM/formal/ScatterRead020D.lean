import DataWords020D
import MachineAtoms020D
import ScalarExpr020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ScatterRead020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 PairArithmetic020B
open Residue020D Interleaved020D MachineAtoms020D DataWords020D ScalarExpr020D
attribute [local irreducible] exec loopState

def ops : List Code := [set 24 (PairProgram020.exponent 22),loadRAM 19 (add (lit 1536) (r 22)),
  set 19 (mod (r 19) (lit 18433)),set 25 (mod (mul (r 18) (r 19)) (lit 18433)),
  set 17 (add (r 23) (r 24))]
def readCode : Code := seqs ops
def result (s : State) (j : Fin 1536) (e : Nat) (a : F) (x : Int) : State :=
  put (put (put (put (put s 24 (word (exponentN j.val:Int))) 19 (word x))
    19 (fw (x:F))) 25 (fw (a*(x:F)))) 17 (word ((e+exponentN j.val:Nat):Int))

theorem read_correct (i : Input) (s : State) (j : Fin 1536) (e : Nat) (a : F) (x : Int)
    (he : e<1536) (hx : -65535≤x ∧ x≤65535)
    (h22 : s.reg 22=word (j.val:Int)) (h23 : s.reg 23=word (e:Int))
    (h18 : s.reg 18=fw a) (hm : s.ram (dataSlot true j)=word x) :
    exec i readCode s=result s j e a x := by
  let q0 := put s 24 (word (exponentN j.val:Int))
  let q1 := put q0 19 (word x)
  let q2 := put q1 19 (fw (x:F))
  let q3 := put q2 25 (fw (a*(x:F)))
  have ej := exponent_bound j.val j.isLt
  have f1536 : Fits (1536:Int) := small_nat 1536 (by decide)
  have fq : Fits (18433:Int) := small_nat 18433 (by decide)
  have fx : Fits x := bounded_fits _ (by omega) (by omega)
  have addr : eval q0 (add (lit 1536) (r 22))=word ((dataSlot true j).val:Int) := by
    change op .add (word 1536) (q0.reg 22)=_
    rw [put_other s 24 22 _ (by decide),h22,
      add_word (1536:Int) (j.val:Int) f1536 (small_nat j.val (by have := j.isLt;omega))]
    rfl
  have load : exec i (loadRAM 19 (add (lit 1536) (r 22))) q0=q1 := by
    rw [load_ram_at i q0 19 _ (dataSlot true j) addr]
    change put q0 19 (s.ram (dataSlot true j))=q1
    rw [hm]
  have canon : eval q1 (mod (r 19) (lit 18433))=fw (x:F) := by
    change op .mod (q1.reg 19) (word 18433)=_
    rw [put_same,mod_word x (18433:Int) fx fq,modular_word]
  have q218 : q2.reg 18=fw a := by
    change (put (put (put s 24 _) 19 _) 19 _).reg 18=fw a
    rw [put_other _ 19 18 _ (by decide),put_other _ 19 18 _ (by decide),put_other _ 24 18 _ (by decide),h18]
  have prod : eval q2 (mod (mul (r 18) (r 19)) (lit 18433))=fw (a*(x:F)) := by
    have ba := field_bounds a;have bx := field_bounds (x:F)
    have bp := scatter_scalar_bound (a.val:Int) ((x:F).val:Int) ba bx
    have fp : Fits ((a.val:Int)*((x:F).val:Int)) := bounded_fits _ (by nlinarith) (by nlinarith [bp.2.2])
    change op .mod (op .mul (q2.reg 18) (q2.reg 19)) (word 18433)=_
    rw [q218,put_same]
    change op .mod (op .mul (word (a.val:Int)) (word ((x:F).val:Int))) (word 18433)=_
    rw [mul_word _ _ (field_fits a) (field_fits (x:F)),mod_word _ _ fp fq,product_modular_word]
  have q323 : q3.reg 23=word (e:Int) := by
    change (put (put (put (put s 24 _) 19 _) 19 _) 25 _).reg 23=_
    rw [put_other _ 25 23 _ (by decide),put_other _ 19 23 _ (by decide),put_other _ 19 23 _ (by decide),put_other _ 24 23 _ (by decide),h23]
  have q324 : q3.reg 24=word (exponentN j.val:Int) := by
    change (put (put (put (put s 24 _) 19 _) 19 _) 25 _).reg 24=_
    rw [put_other _ 25 24 _ (by decide),put_other _ 19 24 _ (by decide),put_other _ 19 24 _ (by decide),put_same]
  have expSum : eval q3 (add (r 23) (r 24))=word ((e+exponentN j.val:Nat):Int) := by
    change op .add (q3.reg 23) (q3.reg 24)=_
    rw [q323,q324,add_word _ _ (small_nat e (by omega)) (small_nat _ (by omega))]
    rfl
  simp only [readCode,ops,exec_seqs_cons,exec_seqs_nil,exec_set,exponent_eval s 22 j.val j.isLt h22]
  change put (put (put (exec i (loadRAM 19 (add (lit 1536) (r 22))) q0) 19
    (eval (exec i (loadRAM 19 (add (lit 1536) (r 22))) q0) (mod (r 19) (lit 18433)))) 25 _) 17 _ = _
  rw [load,canon]
  change put (put q2 25 (eval q2 (mod (mul (r 18) (r 19)) (lit 18433)))) 17 _ = _
  rw [prod]
  change put q3 17 (eval q3 (add (r 23) (r 24)))=_
  rw [expSum]
  rfl

theorem result_exponent (s : State) (j : Fin 1536) (e : Nat) (a : F) (x : Int) :
    (result s j e a x).reg 17=word ((e+exponentN j.val:Nat):Int) := put_same _ _ _
theorem result_product (s : State) (j : Fin 1536) (e : Nat) (a : F) (x : Int) :
    (result s j e a x).reg 25=fw (a*(x:F)) := by
  unfold result
  rw [put_other _ 17 25 _ (by decide),put_same]
theorem result_other (s : State) (j : Fin 1536) (e : Nat) (a : F) (x : Int) (rr : Reg)
    (h24 : rr≠24) (h19 : rr≠19) (h25 : rr≠25) (h17 : rr≠17) :
    (result s j e a x).reg rr=s.reg rr := by
  unfold result
  rw [put_other _ 17 rr _ h17,put_other _ 25 rr _ h25,put_other _ 19 rr _ h19,
    put_other _ 19 rr _ h19,put_other _ 24 rr _ h24]
theorem result_memory (s : State) (j : Fin 1536) (e : Nat) (a : F) (x : Int) :
    (result s j e a x).ram=s.ram ∧ (result s j e a x).out=s.out ∧
    (result s j e a x).fault=s.fault := ⟨rfl,rfl,rfl⟩

end FT1536.S05.ScatterRead020D
