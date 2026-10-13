import Source3.KeygenPublicDecodeExtract077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicDecodeIteration077
open KeygenDecodeSyntax KeygenDecodeValues KeygenPublicDecodeExecution077 C99MemoryReference
open KeygenDecodeDynamicCalculation KeygenPublicDecodeCertified077 KeygenPublicDecodeReady077

theorem finish (args : Args) (s middle t : State)
    (first : Checked args KeygenPublicDecodeRefill077.code s middle .normal)
    (second : Checked args KeygenPublicDecodeBinding077.node036 middle t .normal) :
    Checked args KeygenPublicDecodeBinding077.node042 s t .normal := by
  have suffix : Checked args KeygenPublicDecodeBinding077.node038 middle t .normal :=
    seq args _ _ middle t t .normal second (skip args t)
  have body : Checked args KeygenPublicDecodeBinding077.node041 s t .normal :=
    KeygenPublicDecodeSequence077.append_checked KeygenPublicDecodeRefill077.pieces args s middle t
      KeygenPublicDecodeBinding077.node038 .normal first suffix
  have full := scope args KeygenPublicDecodeBinding077.node041 s t .normal (by intro impossible; cases impossible) body
  rw [empty_scope _ _ _ rfl] at full
  exact full

theorem no_store (args : Args) (s : State) (src ptr : ArrayPointer) (n u p : Nat) (acc : BitVec 32)
    (byte : BitVec 8) (bytes : List (BitVec 8)) (small : p+8<15)
    (wire : Wire args src ptr n u p acc (byte::bytes) s) :
    ∃ t, Checked args KeygenPublicDecodeBinding077.node042 s t .normal ∧
      Wire args src ptr n (u+1) (p+8) (KeygenPublicDecodeBits077.appended acc byte) bytes t ∧ t.heap=s.heap := by
  obtain ⟨atByte,advance,load⟩ := KeygenDecodeStaticWire.head s.heap src u byte bytes wire.reads
  have available : u<args.len.toNat := by have extent:=wire.extent; simp only [List.length_cons] at extent; omega
  obtain ⟨first,middleReady,heap⟩ := KeygenPublicDecodeRefill077.refill args s src ptr atByte n u p acc byte (by omega) available wire.ready advance load
  let middle := KeygenPublicDecodeRefill077.after s u p acc byte
  have same : withLocals middle middle.locals=middle := by cases middle; rfl
  have second : Checked args KeygenPublicDecodeBinding077.node036 middle middle .normal :=
    branch_false args KeygenPublicDecodeBinding077.guard036 KeygenPublicDecodeBinding077.node035 .skip middle middle .normal
      _ middle.locals (.pure _ _ _ (KeygenPublicDecodeExtractCalc077.pending_calculation args middle (p+8) (by omega) middleReady.pending))
      (by simp [small.not_ge,truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer])
      (by rw [same]; exact skip args middle)
  refine ⟨middle,finish args s middle middle first second,⟨middleReady,?_,?_,?_⟩,heap⟩
  · rw [heap]
    exact KeygenDecodeStaticWire.tail s.heap src u byte bytes wire.reads
  · have extent:=wire.extent
    simp only [List.length_cons] at extent
    omega
  · exact KeygenPublicDecodeBits077.append_bound p acc byte (by omega) wire.accumulatorBound

theorem reads_preserved (a b : Memory) (src ptr : ArrayPointer) (u : Nat) (bytes : List (BitVec 8)) (input : BitVec 16)
    (reads : Reads a src u bytes) (separate : src.block≠ptr.block) (store : Store16 a ptr input b) : Reads b src u bytes := by
  intro i
  obtain ⟨atByte,advance,load⟩ := reads i
  have sameBlock : atByte.block=src.block := by cases advance; rfl
  exact ⟨atByte,advance,KeygenDecodeWrite16.byte_preserved a b ptr atByte input _ store
    (by rw [sameBlock]; exact separate) load⟩

theorem store (args : Args) (s : State) (src ptr next : ArrayPointer) (n u p : Nat) (acc : BitVec 32)
    (byte : BitVec 8) (bytes : List (BitVec 8)) (input : BitVec 16) (rest : List (BitVec 16))
    (positive : 1≤n) (small : p<15) (fits : 15≤p+8) (canonical : input.toNat<18433)
    (wire : Wire args src ptr n u p acc (byte::bytes) s)
    (held : remaining p acc (byte::bytes)=KeygenPublicBits077.bits (input::rest))
    (advance : PointerAdd ptr 1 next) (allocated : Allocated s.heap ptr) (width : ptr.elementBytes=2)
    (writable : s.heap.writable ptr.block=true) (separate : src.block≠ptr.block) :
    ∃ t, Checked args KeygenPublicDecodeBinding077.node042 s t .normal ∧
      Wire args src next (n-1) (u+1) (p+8-15)
        (KeygenPublicBits077.masked (p+8-15) (KeygenPublicDecodeBits077.appended acc byte)) bytes t ∧
      remaining (p+8-15) (KeygenPublicBits077.masked (p+8-15) (KeygenPublicDecodeBits077.appended acc byte)) bytes=
        KeygenPublicBits077.bits rest ∧ Store16 s.heap ptr input t.heap := by
  obtain ⟨atByte,byteAdvance,load⟩ := KeygenDecodeStaticWire.head s.heap src u byte bytes wire.reads
  have available : u<args.len.toNat := by have extent:=wire.extent; simp only [List.length_cons] at extent; omega
  obtain ⟨first,middleReady,heap⟩ := KeygenPublicDecodeRefill077.refill args s src ptr atByte n u p acc byte small available wire.ready byteAdvance load
  let middle := KeygenPublicDecodeRefill077.after s u p acc byte
  have bits : remaining (p+8) (KeygenPublicDecodeBits077.appended acc byte) bytes=KeygenPublicBits077.bits (input::rest) :=
    (KeygenPublicDecodeBits077.refill p acc byte bytes small).trans held
  obtain ⟨recovered,lastBits,lastBound⟩ := KeygenPublicDecodeBits077.extract (p+8) (KeygenPublicDecodeBits077.appended acc byte) bytes input rest
    fits (by omega) (KeygenPublicDecodeBits077.append_bound p acc byte small wire.accumulatorBound) canonical bits
  obtain ⟨t,extract,lastReady,write⟩ := KeygenPublicDecodeExtract077.extract args middle src ptr next n (u+1) (p+8)
    (KeygenPublicDecodeBits077.appended acc byte) input positive fits (by omega) canonical recovered middleReady advance allocated width writable
  have same : withLocals middle middle.locals=middle := by cases middle; rfl
  have second : Checked args KeygenPublicDecodeBinding077.node036 middle t .normal :=
    branch_true args KeygenPublicDecodeBinding077.guard036 KeygenPublicDecodeBinding077.node035 .skip middle t .normal
      _ middle.locals (.pure _ _ _ (KeygenPublicDecodeExtractCalc077.pending_calculation args middle (p+8) (by omega) middleReady.pending))
      (by simp [fits,truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer]) (by rw [same]; exact extract)
  have actualStore : Store16 s.heap ptr input t.heap := by
    have heapEq : middle.heap=s.heap := heap
    rw [heapEq] at write
    exact write
  refine ⟨t,finish args s middle t first second,⟨lastReady,?_,?_,lastBound⟩,lastBits,actualStore⟩
  · exact reads_preserved s.heap t.heap src ptr (u+1) bytes input
      (KeygenDecodeStaticWire.tail s.heap src u byte bytes wire.reads) separate actualStore
  · have extent:=wire.extent
    simp only [List.length_cons] at extent
    omega

end FT1536.Source3.KeygenPublicDecodeIteration077
