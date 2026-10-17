import Source3.KeygenPublicTableIndex
import Source3.Word16Memory158

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Value-free execution support for the mq_mkgm3 generator suffix. Written
   cells, table frames and legal sixteen-bit writes replace table images; no
   generated value, root property or evaluation enters this layer. Semantic
   conclusions stay with the separate extractive consumers. -/
namespace FT1536.Source3.PublicGenerateTable159
open C99ArrayReference (State Name)
open C99MemoryReference (Memory ArrayPointer Allocated)
open C99NarrowReads (Load16)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval Address)
open KeygenSmallOutput (element)

def Written (heap : Memory) (q : ArrayPointer) : Prop :=
  ∃ w : BitVec 16, Load16 heap q w

def WrittenRange (heap : Memory) (p : ArrayPointer) (lo hi : Nat) : Prop :=
  ∀ i, lo ≤ i → i < hi → Written heap (element p i)

structure Tables (s : State) (gm igm : ArrayPointer) : Prop where
  gmBinding : s.arrays "gm".toList=some gm
  igmBinding : s.arrays "igm".toList=some igm
  gmWidth : gm.elementBytes=2
  igmWidth : igm.elementBytes=2
  gmCapacity : gm.index+1024 ≤ gm.count
  igmCapacity : igm.index+1024 ≤ igm.count
  gmAllocated : ∀ i<1024, Allocated s.heap (element gm i)
  igmAllocated : ∀ i<1024, Allocated s.heap (element igm i)
  gmWritable : s.heap.writable gm.block=true
  igmWritable : s.heap.writable igm.block=true
  separate : gm.block≠igm.block

theorem separate_elements (p : ArrayPointer) (width : p.elementBytes=2) (i j : Nat)
    (different : i≠j) : Word16Memory158.Separate (element p i) (element p j) := by
  unfold Word16Memory158.Separate
  simp only [element,ArrayPointer.offset,width]
  by_cases order : i<j
  · refine Or.inr (Or.inl ?_)
    omega
  · refine Or.inr (Or.inr ?_)
    omega

theorem separate_cross (gm igm : ArrayPointer) (separate : gm.block≠igm.block)
    (i j : Nat) : Word16Memory158.Separate (element gm i) (element igm j) :=
  Or.inl separate

theorem separate_cross_right (gm igm : ArrayPointer) (separate : gm.block≠igm.block)
    (i j : Nat) : Word16Memory158.Separate (element igm i) (element gm j) :=
  Or.inl (Ne.symm separate)

theorem written_here (before : Memory) (p : ArrayPointer) (w : BitVec 16)
    (allocated : Allocated before p) (width : p.elementBytes=2)
    (writable : before.writable p.block=true) :
    Written (Word16Memory158.write before p w) p :=
  ⟨w,Word16Memory158.here before p w allocated width writable⟩

theorem written_preserved (before : Memory) (p q : ArrayPointer) (w : BitVec 16)
    (separate : Word16Memory158.Separate p q) (old : Written before q) :
    Written (Word16Memory158.write before p w) q := by
  obtain ⟨w0,read⟩ := old
  exact ⟨w0,Word16Memory158.outside before p q w w0 separate read⟩

theorem allocated_write (before : Memory) (p q : ArrayPointer) (w : BitVec 16)
    (allocated : Allocated before q) : Allocated (Word16Memory158.write before p w) q :=
  allocated

theorem tables_write (s : State) (gm igm : ArrayPointer) (t : Tables s gm igm)
    (p : ArrayPointer) (target : p=gm ∨ p=igm) (i : Nat) (_hi : i<1024) (w : BitVec 16) :
    Tables {s with heap := Word16Memory158.write s.heap (element p i) w} gm igm := by
  cases target with
  | inl equal =>
      subst p
      exact ⟨t.gmBinding,t.igmBinding,t.gmWidth,t.igmWidth,t.gmCapacity,t.igmCapacity,
        fun j hj => allocated_write _ _ _ _ (t.gmAllocated j hj),
        fun j hj => allocated_write _ _ _ _ (t.igmAllocated j hj),
        t.gmWritable,t.igmWritable,t.separate⟩
  | inr equal =>
      subst p
      exact ⟨t.gmBinding,t.igmBinding,t.gmWidth,t.igmWidth,t.gmCapacity,t.igmCapacity,
        fun j hj => allocated_write _ _ _ _ (t.gmAllocated j hj),
        fun j hj => allocated_write _ _ _ _ (t.igmAllocated j hj),
        t.gmWritable,t.igmWritable,t.separate⟩

theorem store_source (s : State) (gm igm : ArrayPointer) (t : Tables s gm igm)
    (name : Name) (index : CLogic.Expr) (e : KeygenWordExpr.Expr) (cast : Bool)
    (p : ArrayPointer) (target : p=gm ∨ p=igm) (i : Nat) (hi : i<1024) (v : Value)
    (address : Address s name index (element p i)) (value : Eval [] s e v) :
    Exec KeygenPublicSource.program [] (.store name index cast e) s
      ⟨{s with heap := Word16Memory158.write s.heap (element p i) (KeygenPublicWord.narrow v)},.normal⟩ := by
  cases target with
  | inl equal =>
      subst p
      exact .store name index cast e s
        (Word16Memory158.write s.heap (element gm i) (KeygenPublicWord.narrow v))
        (element gm i) v address value
        (Word16Memory158.source s.heap (element gm i) (KeygenPublicWord.narrow v)
          (t.gmAllocated i hi) t.gmWidth t.gmWritable)
  | inr equal =>
      subst p
      exact .store name index cast e s
        (Word16Memory158.write s.heap (element igm i) (KeygenPublicWord.narrow v))
        (element igm i) v address value
        (Word16Memory158.source s.heap (element igm i) (KeygenPublicWord.narrow v)
          (t.igmAllocated i hi) t.igmWidth t.igmWritable)

theorem written_new (s : State) (gm igm : ArrayPointer) (t : Tables s gm igm)
    (p : ArrayPointer) (target : p=gm ∨ p=igm) (i : Nat) (hi : i<1024) (w : BitVec 16) :
    Written (Word16Memory158.write s.heap (element p i) w) (element p i) := by
  cases target with
  | inl equal =>
      subst p
      exact written_here _ _ w (t.gmAllocated i hi) t.gmWidth t.gmWritable
  | inr equal =>
      subst p
      exact written_here _ _ w (t.igmAllocated i hi) t.igmWidth t.igmWritable

theorem width_of (s : State) (gm igm q : ArrayPointer) (t : Tables s gm igm) (about : q=gm ∨ q=igm) :
    q.elementBytes=2 := by
  rcases about with equal | equal <;> subst equal
  · exact t.gmWidth
  · exact t.igmWidth

theorem separate_or_same (s : State) (gm igm : ArrayPointer) (t : Tables s gm igm)
    (p q : ArrayPointer) (target : p=gm ∨ p=igm) (about : q=gm ∨ q=igm) (i j : Nat) :
    (p=q ∧ i=j) ∨ Word16Memory158.Separate (element p i) (element q j) := by
  rcases target with rfl | rfl <;> rcases about with rfl | rfl
  · by_cases same : i=j
    · exact Or.inl ⟨rfl,same⟩
    · exact Or.inr (separate_elements _ t.gmWidth i j same)
  · exact Or.inr (separate_cross _ _ t.separate i j)
  · exact Or.inr (separate_cross_right _ _ t.separate i j)
  · by_cases same : i=j
    · exact Or.inl ⟨rfl,same⟩
    · exact Or.inr (separate_elements _ t.igmWidth i j same)

theorem written_after (s : State) (gm igm : ArrayPointer) (t : Tables s gm igm)
    (p q : ArrayPointer) (target : p=gm ∨ p=igm) (about : q=gm ∨ q=igm)
    (i j : Nat) (hi : i<1024) (_hj : j<1024) (w : BitVec 16)
    (old : Written s.heap (element q j)) :
    Written (Word16Memory158.write s.heap (element p i) w) (element q j) := by
  rcases separate_or_same s gm igm t p q target about i j with ⟨equal,same⟩ | separate
  · subst equal; subst same
    exact written_new s gm igm t p target i hi w
  · exact written_preserved _ _ _ w separate old

end FT1536.Source3.PublicGenerateTable159
