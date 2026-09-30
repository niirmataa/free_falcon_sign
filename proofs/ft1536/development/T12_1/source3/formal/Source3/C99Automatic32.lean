import Source3.C99MemoryAccess
import Source3.C99InitializationTrace

/- An automatic uint32 object in the selected byte-memory machine. Its
   extent is added on function entry and removed on return. Object offsets
   are internal model addresses; existing caller objects retain their bytes.
   The enclosing source function must still bind this frame operation to its
   declaration/return rules. No dead-object load is used for its snapshot. -/
namespace FT1536.Source3.C99Automatic32
open C99MemoryReference C99MemoryBridge

def align4 (n : Nat) : Nat := ((n+3)/4)*4
def address (before : Memory) : Nat := align4 (before.size 0)
def pointer (before : Memory) : ArrayPointer := ⟨0,address before,1,4,0⟩

theorem alignment (n : Nat) : n≤align4 n ∧ align4 n<n+4 ∧ align4 n%4=0 := by
  unfold align4
  refine ⟨by omega,by omega,?_⟩
  simp

def enter (before : Memory) : Memory where
  bytes := fun b i => if b=0 ∧ before.size 0 ≤ i then none else before.bytes b i
  size := fun b => if b=0 then address before+4 else before.size b
  writable := fun b => if b=0 then true else before.writable b

def leave (before edge : Memory) : Memory where
  bytes := fun b i => if i<before.size b then edge.bytes b i else before.bytes b i
  size := before.size
  writable := before.writable

def Space (before : Memory) : Prop := address before+4<2^64

theorem entered_allocated (before : Memory) (space : Space before) :
    Allocated (enter before) (pointer before) := by
  refine ⟨by change 0<4; decide,(alignment (before.size 0)).2.2,by change 0<1; decide,?_,space⟩
  simp [enter,pointer]

theorem entered_uninitialized (before : Memory) (b : Fin 4) :
    (enter before).bytes 0 ((pointer before).offset+b.val)=none := by
  have ha := (alignment (before.size 0)).1
  simp only [enter,pointer,ArrayPointer.offset,address,Nat.mul_zero,Nat.add_zero]
  rw [ite_eq_left (by exact ⟨rfl,by omega⟩)]

theorem enter_preserves_caller (before : Memory) (block offset : Nat) (live : offset<before.size block) :
    (enter before).bytes block offset=before.bytes block offset := by
  unfold enter
  split
  · rename_i h
    obtain ⟨rfl,h⟩ := h
    omega
  · rfl

theorem leave_preserves_caller (before edge : Memory) (block offset : Nat) (live : offset<before.size block) :
    (leave before edge).bytes block offset=edge.bytes block offset := by
  simp only [leave,ite_eq_left live]

theorem dead_read_impossible (before edge : Memory) (w : BitVec 32) :
    ¬Load32 (leave before edge) (pointer before) w := by
  intro read
  cases read with
  | load bytes allocated typeSize initialized =>
      have ha := (alignment (before.size 0)).1
      have hb := allocated.2.2.2.1
      dsimp [Allocated,leave,pointer,address] at hb
      omega

theorem zero_initialization_exists (before : Memory) (space : Space before) :
    ∃ initialized, Store32 (enter before) (pointer before) 0 initialized ∧
      C99InitializationTrace.Initialized initialized 0 (address before) 4 := by
  let initialized := decode (StableBinaryByteView.flagStored (encode (enter before)) (address before) 0)
  have write : Store32 (enter before) (pointer before) 0 initialized :=
    C99MemoryAccess.store32_model (enter before) (pointer before) 0 rfl
      (entered_allocated before space) rfl (by simp [enter,pointer])
  refine ⟨initialized,write,?_⟩
  intro i hi
  have hb := write.2.2.2.2.2.1 ⟨i,hi⟩
  change initialized.bytes 0 (address before+i)=some (byte32 0 ⟨i,hi⟩) at hb
  rw [hb]
  rfl

end FT1536.Source3.C99Automatic32
