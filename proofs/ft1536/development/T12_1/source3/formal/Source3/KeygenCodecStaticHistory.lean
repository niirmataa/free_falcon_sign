import Source3.KeygenCodecStaticAdvance

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- An expected-byte history at consecutive natural cursor positions.
   The progress count is a conclusion; the capacity stop keeps the prefix. -/
namespace FT1536.Source3.KeygenCodecStaticHistory
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)

def single (out : Option ArrayPointer) (n : Nat) (b : BitVec 8) : List KeygenCodecByteHistory.Write :=
  out.toList.map (fun dst => (byteOff dst n,b))

def positions (out : Option ArrayPointer) : Nat → List (BitVec 8) → List KeygenCodecByteHistory.Write
  | _,[] => []
  | n,b::rest => single out n b ++ positions out (n+1) rest

def Progress (args : Args) (s t : State) (n : Nat) (expected : List (BitVec 8)) (flow : Flow) : Prop :=
  ∃ k : Nat, k≤expected.length ∧ Ready args t ∧ Cursor (BitVec.ofNat 64 (n+k)) t ∧
    KeygenCodecByteHistory.Trace s.heap t.heap (positions args.out n (expected.take k)) ∧
    ((flow=.normal ∧ k=expected.length) ∨
      (flow=.returned 0 ∧ args.out≠none ∧ k<expected.length ∧ args.capacity.toNat≤n+k))

theorem emit_single (out : Option ArrayPointer) (n : Nat) (word : BitVec 32) (small : n<2^64) :
    KeygenCodecStaticEmit.writes out (BitVec.ofNat 64 n) word=single out n (KeygenCodecStaticByte.byte word) := by
  simp only [KeygenCodecStaticEmit.writes,single,BitVec.toNat_ofNat,Nat.mod_eq_of_lt small]

theorem nil_progress (args : Args) (s : State) (n : Nat)
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 n) s) : Progress args s s n [] .normal :=
  ⟨0,Nat.le_refl 0,ready,by simpa only [Nat.add_zero] using cursor,.nil _,Or.inl ⟨rfl,rfl⟩⟩

theorem rejected_progress (args : Args) (s : State) (n : Nat) (b : BitVec 8) (rest : List (BitVec 8))
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 n) s)
    (nonnull : args.out≠none) (bound : args.capacity.toNat≤n) :
    Progress args s s n (b::rest) (.returned 0) :=
  ⟨0,by simp only [List.length_cons]; omega,ready,by simpa only [Nat.add_zero] using cursor,
    .nil _,Or.inr ⟨rfl,nonnull,by simp only [List.length_cons]; omega,by simpa only [Nat.add_zero] using bound⟩⟩

theorem cons_progress (args : Args) (s middle t : State) (n : Nat)
    (b : BitVec 8) (rest : List (BitVec 8)) (flow : Flow)
    (first : KeygenCodecByteHistory.Trace s.heap middle.heap (single args.out n b))
    (tail : Progress args middle t (n+1) rest flow) : Progress args s t n (b::rest) flow := by
  obtain ⟨k,bound,ready,cursor,trace,ending⟩ := tail
  refine ⟨k+1,by simp only [List.length_cons]; omega,ready,?_,?_,?_⟩
  · simpa only [show n+(k+1)=n+1+k by omega] using cursor
  · simpa only [List.take_succ_cons,positions] using KeygenCodecByteHistory.append _ _ _ _ _ first trace
  · rcases ending with ⟨normal,complete⟩ | ⟨returned,nonnull,short,capacity⟩
    · exact Or.inl ⟨normal,by simp only [List.length_cons]; omega⟩
    · exact Or.inr ⟨returned,nonnull,by simp only [List.length_cons]; omega,by omega⟩

theorem positions_append (out : Option ArrayPointer) (n : Nat) (xs ys : List (BitVec 8)) :
    positions out n (xs++ys)=positions out n xs++positions out (n+xs.length) ys := by
  induction xs generalizing n with
  | nil => simp only [List.nil_append,List.length_nil,Nat.add_zero,positions]
  | cons b xs ih =>
    simp only [List.cons_append,positions,ih,List.length_cons,List.append_assoc]
    rw [show n+1+xs.length=n+(xs.length+1) by omega]

theorem append_progress (args : Args) (s middle t : State) (n : Nat) (xs ys : List (BitVec 8)) (flow : Flow)
    (first : Progress args s middle n xs .normal)
    (tail : Progress args middle t (n+xs.length) ys flow) : Progress args s t n (xs++ys) flow := by
  obtain ⟨i,_,_,_,firstTrace,ending⟩ := first
  have complete : i=xs.length := by rcases ending with ⟨_,complete⟩ | ⟨bad,_⟩; exact complete; cases bad
  subst i
  rw [List.take_length] at firstTrace
  obtain ⟨k,bound,ready,cursor,trace,last⟩ := tail
  refine ⟨xs.length+k,by simp only [List.length_append]; omega,ready,?_,?_,?_⟩
  · simpa only [Nat.add_assoc] using cursor
  · rw [List.take_append,List.take_of_length_le (show xs.length≤xs.length+k by omega),
      show xs.length+k-xs.length=k by omega,positions_append]
    exact KeygenCodecByteHistory.append _ _ _ _ _ firstTrace trace
  · rcases last with ⟨normal,complete⟩ | ⟨returned,nonnull,short,capacity⟩
    · exact Or.inl ⟨normal,by simp only [List.length_append]; omega⟩
    · exact Or.inr ⟨returned,nonnull,by simp only [List.length_append]; omega,by omega⟩

theorem extend_rejection (args : Args) (s t : State) (n : Nat) (xs ys : List (BitVec 8)) (value : BitVec 64)
    (first : Progress args s t n xs (.returned value)) : Progress args s t n (xs++ys) (.returned value) := by
  obtain ⟨k,bound,ready,cursor,trace,ending⟩ := first
  rcases ending with ⟨bad,_⟩ | ⟨returned,nonnull,short,capacity⟩
  · cases bad
  · refine ⟨k,by simp only [List.length_append]; omega,ready,cursor,?_,Or.inr ⟨returned,nonnull,?_,capacity⟩⟩
    · have same : (xs++ys).take k=xs.take k := by rw [List.take_append_of_le_length bound]
      rw [same]; exact trace
    · simp only [List.length_append]; omega

end FT1536.Source3.KeygenCodecStaticHistory
