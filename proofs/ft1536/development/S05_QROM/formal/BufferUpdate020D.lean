import MachineAtoms020D

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.BufferUpdate020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020 PairArithmetic020B MachineAtoms020D
attribute [local irreducible] exec loopState

def slot (k : Fin 1536) : Fin ramSize := ⟨3072+k.val,by have := k.isLt;unfold ramSize;omega⟩
def result (s : State) (k : Fin 1536) (x d : Int) : State :=
  ramPut (put (put s 26 (word (3072+(k.val:Int)))) 27 (word x)) (slot k) (word ((x+d)%18433))

/-- Actual update including address, load, signed addition and Euclidean mod.
    Stability of delta is a syntactic read-set obligation, not an assumed run. -/
theorem update_correct (i : Input) (s : State) (k : Fin 1536) (x d : Int) (idx delta : Expr)
    (hx : 0≤x ∧ x<18433) (hd : -18433≤d ∧ d≤18433)
    (hi : eval s idx=word (k.val:Int)) (he : eval s delta=word d)
    (h26 : (26:Reg)∉reads delta) (h27 : (27:Reg)∉reads delta)
    (hm : s.ram (slot k)=word x) : exec i (update idx delta) s=result s k x d := by
  have fk : Fits (k.val:Int) := bounded_fits _ (by omega) (by have := k.isLt;omega)
  have fc : Fits 3072 := bounded_fits _ (by norm_num) (by norm_num)
  have fx : Fits x := bounded_fits _ (by omega) (by omega)
  have fd : Fits d := bounded_fits _ (by omega) (by omega)
  have fs : Fits (x+d) := bounded_fits _ (by omega) (by omega)
  have fq : Fits 18433 := bounded_fits _ (by norm_num) (by norm_num)
  have eaddr : eval s (add (lit 3072) idx)=word (3072+(k.val:Int)) := by
    change op .add (word 3072) (eval s idx)=_
    rw [hi,add_word _ _ fc fk]
  let a := put s 26 (word (3072+(k.val:Int)))
  let b := put a 27 (word x)
  have ar : eval a (r 26)=word ((slot k).val:Int) := put_same _ _ _
  have loaded : exec i (loadRAM 27 (r 26)) a=b := by
    rw [load_ram_at i a 27 (r 26) (slot k) ar]
    change put a 27 (s.ram (slot k))=b
    rw [hm]
  have br : eval b (r 26)=word ((slot k).val:Int) := by
    exact (put_other a 27 26 (word x) (by decide)).trans (put_same _ _ _)
  have bd : eval b delta=word d := by
    rw [eval_put a delta 27 (word x) h27,eval_put s delta 26 _ h26,he]
  have ev : eval b (mod (add (r 27) delta) (lit 18433))=word ((x+d)%18433) := by
    change op .mod (op .add (b.reg 27) (eval b delta)) (word 18433)=_
    rw [put_same,bd,add_word _ _ fx fd,mod_word _ _ fs fq]
  simp only [update,exec_seqs_cons,exec_seqs_nil,exec_set,eaddr]
  change exec i (store (r 26) (mod (add (r 27) delta) (lit 18433))) (exec i (loadRAM 27 (r 26)) a)=_
  rw [loaded,store_at i b _ _ (slot k) br,ev]
  rfl

theorem result_same (s : State) (k : Fin 1536) (x d : Int) :
    (result s k x d).ram (slot k)=word ((x+d)%18433) := ramPut_same _ _ _
theorem result_other (s : State) (k : Fin 1536) (x d : Int) (j : Fin ramSize) (hj : j≠slot k) :
    (result s k x d).ram j=s.ram j := ramPut_other _ _ _ _ hj
theorem result_reg (s : State) (k : Fin 1536) (x d : Int) (rr : Reg) (h26 : rr≠26) (h27 : rr≠27) :
    (result s k x d).reg rr=s.reg rr := by
  change (put (put s 26 _) 27 _).reg rr=s.reg rr
  rw [put_other _ 27 rr _ h27,put_other _ 26 rr _ h26]
theorem result_frame (s : State) (k : Fin 1536) (x d : Int) :
    (result s k x d).out=s.out ∧ (result s k x d).fault=s.fault := ⟨rfl,rfl⟩

end FT1536.S05.BufferUpdate020D
