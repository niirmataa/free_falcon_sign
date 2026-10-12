import OutputValues020D
import MachineAtoms020D
import ScalarExpr020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.EmitRead020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 PairArithmetic020B
open Residue020D Interleaved020D DataWords020D OutputValues020D BufferField020D MachineAtoms020D ScalarExpr020D
attribute [local irreducible] exec loopState

def keyOps : List Code := [set 23 (PairProgram020.exponent 21),loadRAM 18 (r 21),
  loadRAM 19 (add (lit 3072) (r 23)),set 30 (mod (add (r 18) (r 19)) (lit 18433))]
def keyResult (s : State) (z : StandaloneRuntime019.CachedBox) (v : Coeffs) (j : Fin 1536) : State :=
  put (put (put (put s 23 (word (exponentN j.val:Int))) 18 (word (signed z false j)))
    19 (fw (v ⟨exponentN j.val,exponent_bound j.val j.isLt⟩))) 30 (fw (keyValue z v j))

theorem key_run (i : Input) (s : State) (z : StandaloneRuntime019.CachedBox) (v : Coeffs)
    (j : Fin 1536) (hz : BoxImage020C.readVec s=BoxImage020C.image z) (hv : Holds s v)
    (h21 : s.reg 21=word (j.val:Int)) : exec i (seqs keyOps) s=keyResult s z v j := by
  let k : Fin 1536 := ⟨exponentN j.val,exponent_bound j.val j.isLt⟩
  let x := signed z false j
  let q0 := put s 23 (word (exponentN j.val:Int))
  let q1 := put q0 18 (word x)
  let q2 := put q1 19 (fw (v k))
  have a0 : eval q0 (r 21)=word ((dataSlot false j).val:Int) := by
    change q0.reg 21=word ((0+j.val:Nat):Int)
    rw [Nat.zero_add]
    exact (put_other s 23 21 _ (by decide)).trans h21
  have l0 : exec i (loadRAM 18 (r 21)) q0=q1 := by
    rw [load_ram_at i q0 18 _ (dataSlot false j) a0]
    change put q0 18 (s.ram (dataSlot false j))=q1
    rw [data_word s z false j hz]
  have q123 : q1.reg 23=word (exponentN j.val:Int) :=
    (put_other q0 18 23 _ (by decide)).trans (put_same _ _ _)
  have a1 : eval q1 (add (lit 3072) (r 23))=word ((BufferUpdate020D.slot k).val:Int) := by
    change op .add (word 3072) (q1.reg 23)=_
    rw [q123,add_word (3072:Int) (exponentN j.val:Int) (small_nat 3072 (by decide))
      (small_nat _ (by have := exponent_bound j.val j.isLt;omega))]
    rfl
  have l1 : exec i (loadRAM 19 (add (lit 3072) (r 23))) q1=q2 := by
    rw [load_ram_at i q1 19 _ (BufferUpdate020D.slot k) a1]
    change put q1 19 (s.ram (BufferUpdate020D.slot k))=q2
    rw [hv k]
  have q218 : q2.reg 18=word x := (put_other q1 19 18 _ (by decide)).trans (put_same _ _ _)
  have ev : eval q2 (mod (add (r 18) (r 19)) (lit 18433))=fw (keyValue z v j) := by
    have bx := signed_bounds z false j
    have bv := field_bounds (v k)
    have fx : Fits x := bounded_fits _ (by omega) (by omega)
    have fs : Fits (x+(v k).val) := bounded_fits _ (by omega) (by omega)
    change op .mod (op .add (q2.reg 18) (q2.reg 19)) (word 18433)=_
    rw [q218,put_same]
    change op .mod (op .add (word x) (word ((v k).val:Int))) (word 18433)=_
    rw [add_word _ _ fx (field_fits (v k)),mod_word _ _ fs (show Fits (18433:Int) from small_nat 18433 (by decide)),modular_word]
    apply congrArg fw
    rw [Int.cast_add,value_cast]
    rfl
  simp only [keyOps,exec_seqs_cons,exec_seqs_nil,exec_set,exponent_eval s 21 j.val j.isLt h21]
  change put (exec i (loadRAM 19 (add (lit 3072) (r 23))) (exec i (loadRAM 18 (r 21)) q0)) 30 _ = _
  rw [l0,l1]
  change put q2 30 (eval q2 (mod (add (r 18) (r 19)) (lit 18433)))=_
  rw [ev]
  rfl

theorem key_fields (s : State) (z : StandaloneRuntime019.CachedBox) (v : Coeffs) (j : Fin 1536) :
    let q := keyResult s z v j
    q.reg 30=fw (keyValue z v j) ∧ q.reg 21=s.reg 21 ∧ q.reg 28=s.reg 28 ∧
      q.ram=s.ram ∧ q.out=s.out ∧ q.fault=s.fault := by
  refine ⟨put_same _ _ _,?_,?_,rfl,rfl,rfl⟩ <;>
    simp [keyResult,put,Function.update]

def replyOps : List Code := [loadRAM 30 (add (lit 1536) (r 21)),set 30 (add (r 30) (lit 65535))]
def replyResult (s : State) (z : StandaloneRuntime019.CachedBox) (j : Fin 1536) : State :=
  put (put s 30 (word (signed z true j))) 30 (word (replyValue z j:Int))

theorem reply_run (i : Input) (s : State) (z : StandaloneRuntime019.CachedBox) (j : Fin 1536)
    (hz : BoxImage020C.readVec s=BoxImage020C.image z) (h21 : s.reg 21=word (j.val:Int)) :
    exec i (seqs replyOps) s=replyResult s z j := by
  let q := put s 30 (word (signed z true j))
  have addr : eval s (add (lit 1536) (r 21))=word ((dataSlot true j).val:Int) := by
    change op .add (word 1536) (s.reg 21)=_
    rw [h21,add_word (1536:Int) (j.val:Int) (small_nat 1536 (by decide)) (small_nat _ (by have := j.isLt;omega))]
    rfl
  have ld : exec i (loadRAM 30 (add (lit 1536) (r 21))) s=q := by
    rw [load_ram_at i s 30 _ (dataSlot true j) addr,data_word s z true j hz]
  have e : eval q (add (r 30) (lit 65535))=word (replyValue z j:Int) := by
    have bx := signed_bounds z true j
    change op .add (q.reg 30) (word 65535)=_
    rw [put_same,add_word (signed z true j) (65535:Int)
      (bounded_fits _ (by omega) (by omega)) (small_nat 65535 (by decide)),reply_shift]
  simp only [replyOps,exec_seqs_cons,exec_seqs_nil,ld,exec_set,e]
  rfl

theorem reply_fields (s : State) (z : StandaloneRuntime019.CachedBox) (j : Fin 1536) :
    let q := replyResult s z j
    q.reg 30=word (replyValue z j:Int) ∧ q.reg 21=s.reg 21 ∧ q.reg 28=s.reg 28 ∧
      q.ram=s.ram ∧ q.out=s.out ∧ q.fault=s.fault := by
  refine ⟨put_same _ _ _,?_,?_,rfl,rfl,rfl⟩ <;> simp [replyResult,put,Function.update]

end FT1536.S05.EmitRead020D
