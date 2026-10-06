import Source3.KeygenMkgm3Upward

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMkgm3RevMemory
open C99MemoryReference
open C99InitializationTrace
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenSmallOutput (element)
open KeygenMkgm3Indices (reverse9 lastIndex)

theorem memory_steps (code : Stmt) (before : State) (out : Result) (source : Exec code before out) :
    Steps before.heap out.state.heap := by
  induction source with
  | base code before after source => exact C99ArrayReference.memory_steps _ _ _ _ source
  | assign | loopFalse | ret | retVoid => exact .done _
  | store32 name index e before after p v address value write => exact .write32 _ _ _ p _ write (.done _)
  | storeRev name table base index e before after p q bv w v be ta tr address value write =>
      exact .write32 _ _ _ p _ write (.done _)
  | seqNormal first second before middle result head tail ih1 ih2 => exact steps_trans _ _ _ ih1 ih2
  | seqExit first second before result head exit ih => exact ih
  | scope names body before result inner ih => exact ih
  | branchTrue condition yes no before result v guard nonzero body ih => exact ih
  | branchFalse condition yes no before result v guard zero body ih => exact ih
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact steps_trans _ _ _ ih1 (steps_trans _ _ _ ih2 ih3)
  | loopReturn condition body increment before after v value guard nonzero iteration ih => exact ih

theorem readonly_bytes (before after : Memory) (source : Steps before after) (block offset : Nat)
    (readonly : before.writable block=false) : after.bytes block offset=before.bytes block offset := by
  induction source with
  | done => rfl
  | write64 before middle after p w write rest ih =>
      have ne : block≠p.block := by intro h; rw [h,write.2.2.1] at readonly; cases readonly
      exact (ih (by rw [write.2.2.2.2.1]; exact readonly)).trans
        (write.2.2.2.2.2.2 block offset (Or.inl ne))
  | write32 before middle after p w write rest ih =>
      have ne : block≠p.block := by intro h; rw [h,write.2.2.1] at readonly; cases readonly
      exact (ih (by rw [write.2.2.2.2.1]; exact readonly)).trans
        (write.2.2.2.2.2.2 block offset (Or.inl ne))
  | copy before middle after dst src count copy rest ih =>
      obtain ⟨_,_,_,_,writable,_,_,size,wr,_,bytes⟩ := copy
      have ne : block≠dst.block := by intro h; rw [h,writable] at readonly; cases readonly
      exact (ih (by rw [wr]; exact readonly)).trans (bytes block offset (Or.inl ne))

def SourceTable (heap : Memory) (rev : ArrayPointer) : Prop :=
  heap.writable rev.block=false ∧ ∃ data : List Nat,
    KeygenRev10.rawTable=some data ∧ ∀ i n, data[i]?=some n →
      C99NarrowReads.Load16 heap (element rev i) (BitVec.ofNat 16 n)

def Rev (s : State) (rev : ArrayPointer) : Prop :=
  s.arrays "REV10".toList=some rev ∧ s.heap.writable rev.block=false ∧
    ∀ u<512, C99NarrowReads.Load16 s.heap (element rev (2*u)) (BitVec.ofNat 16 (reverse9 u))

theorem from_source (s : State) (rev : ArrayPointer)
    (binding : s.arrays "REV10".toList=some rev) (table : SourceTable s.heap rev) : Rev s rev := by
  obtain ⟨readonly,data,parsed,loaded⟩ := table
  have he := Option.some.inj (parsed.symm.trans KeygenRev10Cert.rawTable_exact)
  subst data
  refine ⟨binding,readonly,?_⟩
  intro u hu
  apply loaded
  simp [reverse9,show 2*u<1024 by omega]

theorem transported (code : Stmt) (before : State) (out : Result) (rev : ArrayPointer)
    (support : KeygenMkgm3Control.supported code=true) (h : Rev before rev)
    (source : Exec code before out) : Rev out.state rev := by
  have steps := memory_steps code before out source
  have metadata := steps_preserve _ _ steps
  refine ⟨?_,?_,?_⟩
  · rw [(KeygenMkgm3Control.frame code before out support source).2.1]
    exact h.1
  · rw [metadata.writable]
    exact h.2.1
  · intro u hu
    exact C99NarrowReads.load16_transport _ _ _ _ (h.2.2 u hu) metadata.size
      (fun byte => readonly_bytes _ _ steps rev.block _ h.2.1)

theorem storeRev_address (s : State) (name : String) (idx : CLogic.Expr)
    (dst rev : ArrayPointer) (u : Nat) (hu : u<512)
    (binding : s.arrays name.toList=some dst) (table : Rev s rev)
    (base : KeygenNttLoopSupport.USlot s "b" 512)
    (index : ∀ v, C99ArrayReference.scalar s idx v → v.integer.toNat=2*u)
    (expr : C99ModularReference.Expr) (out : Result)
    (source : Exec (KeygenMkgm3Program.storeRev name idx expr) s out) :
    ∃ v, C99ModularReference.Eval s expr v ∧
      Store32 s.heap (element dst (lastIndex u)) (BitVec.ofInt 32 v.integer) out.state.heap := by
  cases source with
  | storeRev _ _ _ _ _ before after p q bv w v be ta tr address evaluated write =>
      have bval := KeygenNttLoopSupport.variable_u64 s "b" 512 bv base be
      subst bv
      have qa := KeygenMkgm3Atoms.pointer_index s "REV10" idx rev q (2*u) table.1 index ta
      rw [qa] at tr
      have we := C99NarrowReads.load16_deterministic s.heap _ w _ tr (table.2.2 u hu)
      subst w
      have wb : (BitVec.ofNat 16 (reverse9 u)).toNat=reverse9 u := by
        rw [BitVec.toNat_ofNat]
        exact Nat.mod_eq_of_lt (by have := (KeygenMkgm3Table.last_range u hu).2; dsimp [lastIndex] at *; omega)
      have ni : ((KeygenNttLoopSupport.u64 512).integer.toNat+
          (C99NarrowReads.unsignedPromotion (BitVec.ofNat 16 (reverse9 u))).integer.toNat)%2^64=lastIndex u := by
        rw [KeygenNttLoopSupport.u64_toNat 512 (by decide),C99NarrowReads.unsigned_promotion_exact]
        simp only [Int.toNat_natCast,wb]
        exact Nat.mod_eq_of_lt (by have := (KeygenMkgm3Table.last_range u hu).2; dsimp [lastIndex] at *; omega)
      rw [ni] at address
      have pa := KeygenMkgm3Atoms.pointer_index s name _ dst p (lastIndex u) binding
        (fun v hv => by
          rw [KeygenNttForwardExec.literal_value s .u64 (lastIndex u) v hv]
          exact KeygenNttLoopSupport.u64_toNat _ (by have := (KeygenMkgm3Table.last_range u hu).2; omega)) address
      rw [pa] at write
      exact ⟨v,evaluated,write⟩

end FT1536.Source3.KeygenMkgm3RevMemory
