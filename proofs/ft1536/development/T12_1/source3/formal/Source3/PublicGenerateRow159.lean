import Source3.PublicGenerateIndex159
import Source3.PublicGenerateHead159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Constructive execution of the mq_mkgm3 row loop: the 256 two-store
   iterations with their four scalar updates, driven by the value-free
   Written-range invariant. The loop writes exactly the cells with
   bit-reversed row indices; no table value or evaluation is assumed. -/
namespace FT1536.Source3.PublicGenerateRow159
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value Ty)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval Address)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenMkgm3Indices (lastIndex reverse9)
open KeygenPublicLastProgram (store advance index nextU u)
open PublicGenerateTable159 (Tables Written WrittenRange written_here written_preserved
  written_new written_after tables_write store_source separate_elements separate_cross
  separate_cross_right allocated_write)
open PublicGenerateIndex159
open PublicGenerateHead159 (mul_call eval_lit eval_var)
open KeygenPublicLeafWords (montgomery)
open KeygenSmallOutput (element)

def rowValue (x y : BitVec 32) : BitVec 32 := montgomery x y 18433#32 18431#32

theorem mont_var (s : State) (n m : String) (xw mw : BitVec 32)
    (x : Slot s n xw) (slot : Slot s m mw) :
    Eval [] s (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var n)
      (KeygenPublicTableAtoms.var m)) (.uint32 (rowValue xw mw)) := by
  unfold rowValue
  exact KeygenPublicWord.Eval.call4 _ _ _ _ _ (.uint32 xw) (.uint32 mw)
    (C99IntegerReference.convert .int32 18433) (C99IntegerReference.convert .int32 18431) _
    (eval_var s n xw x) (eval_var s m mw slot) (eval_lit s 18433) (eval_lit s 18431)
    (mul_call xw mw _ _ _ _ (KeygenPublicArguments.u32_self xw)
      (KeygenPublicArguments.u32_self mw) (KeygenPublicArguments.u32_literal 18433)
      (KeygenPublicArguments.u32_literal 18431))

theorem u64_slot_after (s : State) (name : String) (m : Nat) (bound : m<2^64) :
    USlot (bindValue s name.toList .uint64 (u64 m)) name m := by
  have converted : C99IntegerReference.convert .uint64 (u64 m).integer=u64 m :=
    KeygenNttLoopSupport.convert_u64_self m bound
  simp [KeygenNttLoopSupport.USlot,C99ArrayReference.bindValue,C99ScalarReference.set,converted]

theorem u32_slot_after (s : State) (name : String) (w : BitVec 32) :
    Slot (bindValue s name.toList .uint32 (.uint32 w)) name w :=
  KeygenPublicTableAtoms.slot_after s name w

theorem restoreScope_empty (before after : State) :
    C99ArrayReference.restoreScope before after [] [] = after := rfl

theorem scope_empty (body : Stmt) (s m : State)
    (source : Exec KeygenPublicSource.program [] body s ⟨m,.normal⟩) :
    Exec KeygenPublicSource.program [] (.scope [] [] body) s ⟨m,.normal⟩ :=
  KeygenPublicExec.Exec.scope [] [] body s ⟨m,.normal⟩ source

structure RowInv (s : State) (gm igm : ArrayPointer) (i : Nat) : Prop where
  tables : Tables s gm igm
  lognSlot : Slot s "logn" 10
  counter : USlot s "u" i
  kSlot : Slot s "k" 1
  bSlot : USlot s "b" 512
  xSlot : ∃ w, Slot s "x" w
  ixSlot : ∃ w, Slot s "ix" w
  g2Slot : ∃ w, Slot s "g2" w
  g4Slot : ∃ w, Slot s "g4" w
  ig2Slot : ∃ w, Slot s "ig2" w
  ig4Slot : ∃ w, Slot s "ig4" w
  covered : ∀ j, j < i → Written s.heap (element gm (lastIndex j)) ∧
    Written s.heap (element igm (lastIndex j))

theorem last_distinct (i j : Nat) (upper : i+1<512) (lower : j < i) :
    lastIndex j≠lastIndex i ∧ lastIndex j≠lastIndex (i+1) := by
  refine ⟨fun equal => ?_,fun equal => ?_⟩
  · have := KeygenMkgm3Table.last_injective j i (by omega) (by omega) equal
    omega
  · have := KeygenMkgm3Table.last_injective j (i+1) (by omega) (by omega) equal
    omega

theorem guard_row (s : State) (gm igm : ArrayPointer) (i : Nat) (bound : i<2^64)
    (inv : RowInv s gm igm i) :
    Eval [] s KeygenPublicLastProgram.condition
      (C99ScalarReference.boolean (decide (i<512))) :=
  .cmp .lt _ _ _ _ _ (.scalar _ _ (var_u64 s "u" i inv.counter))
    (.scalar _ _ (var_u64 s "b" 512 inv.bSlot))
    (C99NatWord141.less i 512 bound (by decide))

theorem increment_source (s : State) (gm igm : ArrayPointer) (i : Nat) (bound : i<2^64)
    (inv : RowInv s gm igm i) :
    Exec KeygenPublicSource.program [] KeygenPublicLastProgram.increment s
      ⟨bindValue s "u".toList .uint64 (u64 (i+2)),.normal⟩ :=
  .assign "u".toList _ _ .uint64 (some (u64 i)) (u64 (i+2))
    inv.counter (.bin .add _ _ _ _ _
      (.scalar _ _ (var_u64 s "u" i inv.counter)) (.scalar _ _ (lit_i32 s 2))
      (add_two i bound))

theorem keep_slot (s : State) (name other : String) (ty : Ty) (v : Value) (w : BitVec 32)
    (different : name≠other) (slot : Slot s name w) :
    Slot (bindValue s other.toList ty v) name w :=
  KeygenPublicTableAtoms.slot_preserved s name other w ty v different slot

theorem keep_u64 (s : State) (name other : String) (ty : Ty) (v : Value) (m : Nat)
    (different : name≠other) (slot : USlot s name m) :
    USlot (bindValue s other.toList ty v) name m := by
  unfold KeygenNttLoopSupport.USlot
  simp [C99ArrayReference.bindValue,C99ScalarReference.set,
    show name.toList≠other.toList from fun equal => different (String.toList_injective equal)]
  exact slot

/- Four-write composition helpers for one row iteration. -/
theorem tables_frame (s s' : State) (gm igm : ArrayPointer) (t : Tables s gm igm)
    (arrays : s'.arrays=s.arrays) (size : s'.heap.size=s.heap.size)
    (writable : s'.heap.writable=s.heap.writable) : Tables s' gm igm := by
  refine ⟨?_,?_,t.gmWidth,t.igmWidth,t.gmCapacity,t.igmCapacity,?_,?_,?_,?_,t.separate⟩
  · rw [arrays]
    exact t.gmBinding
  · rw [arrays]
    exact t.igmBinding
  · intro i hi
    have old := t.gmAllocated i hi
    simp only [C99MemoryReference.Allocated] at old ⊢
    rw [size]
    exact old
  · intro i hi
    have old := t.igmAllocated i hi
    simp only [C99MemoryReference.Allocated] at old ⊢
    rw [size]
    exact old
  · rw [writable]
    exact t.gmWritable
  · rw [writable]
    exact t.igmWritable

theorem through4 (A B C D X : ArrayPointer) (h0 : C99MemoryReference.Memory)
    (wA wB wC wD : BitVec 16)
    (sepA : Word16Memory158.Separate A X) (sepB : Word16Memory158.Separate B X)
    (sepC : Word16Memory158.Separate C X) (sepD : Word16Memory158.Separate D X)
    (old : Written h0 X) :
    Written (Word16Memory158.write (Word16Memory158.write (Word16Memory158.write
      (Word16Memory158.write h0 A wA) B wB) C wC) D wD) X :=
  written_preserved _ D X wD sepD
    (written_preserved _ C X wC sepC
      (written_preserved _ B X wB sepB
        (written_preserved _ A X wA sepA old)))

theorem alloc_four (A B C D X : ArrayPointer) (h0 : C99MemoryReference.Memory)
    (wA wB wC wD : BitVec 16) (allocated : C99MemoryReference.Allocated h0 X) :
    C99MemoryReference.Allocated
      (Word16Memory158.write (Word16Memory158.write (Word16Memory158.write
        (Word16Memory158.write h0 A wA) B wB) C wC) D wD) X :=
  allocated_write _ D X wD (allocated_write _ C X wC (allocated_write _ B X wB
    (allocated_write _ A X wA allocated)))

theorem writable_four (A B C D X : ArrayPointer) (h0 : C99MemoryReference.Memory)
    (wA wB wC wD : BitVec 16) (writable : h0.writable X.block=true) :
    (Word16Memory158.write (Word16Memory158.write (Word16Memory158.write
      (Word16Memory158.write h0 A wA) B wB) C wC) D wD).writable X.block=true :=
  writable

theorem new_first (A B C D : ArrayPointer) (h0 : C99MemoryReference.Memory)
    (wA wB wC wD : BitVec 16)
    (allocated : C99MemoryReference.Allocated h0 A) (width : A.elementBytes=2)
    (writable : h0.writable A.block=true)
    (sepB : Word16Memory158.Separate B A) (sepC : Word16Memory158.Separate C A)
    (sepD : Word16Memory158.Separate D A) :
    Written (Word16Memory158.write (Word16Memory158.write (Word16Memory158.write
      (Word16Memory158.write h0 A wA) B wB) C wC) D wD) A :=
  written_preserved _ D A wD sepD
    (written_preserved _ C A wC sepC
      (written_preserved _ B A wB sepB
        (written_here h0 A wA allocated width writable)))

theorem new_second (A B C D : ArrayPointer) (h0 : C99MemoryReference.Memory)
    (wA wB wC wD : BitVec 16)
    (allocated : C99MemoryReference.Allocated h0 B) (width : B.elementBytes=2)
    (writable : h0.writable B.block=true)
    (sepC : Word16Memory158.Separate C B) (sepD : Word16Memory158.Separate D B) :
    Written (Word16Memory158.write (Word16Memory158.write (Word16Memory158.write
      (Word16Memory158.write h0 A wA) B wB) C wC) D wD) B :=
  written_preserved _ D B wD sepD
    (written_preserved _ C B wC sepC
      (written_here _ B wB (allocated_write _ A B wA allocated) width writable))

theorem new_third (A B C D : ArrayPointer) (h0 : C99MemoryReference.Memory)
    (wA wB wC wD : BitVec 16)
    (allocated : C99MemoryReference.Allocated h0 C) (width : C.elementBytes=2)
    (writable : h0.writable C.block=true)
    (sepD : Word16Memory158.Separate D C) :
    Written (Word16Memory158.write (Word16Memory158.write (Word16Memory158.write
      (Word16Memory158.write h0 A wA) B wB) C wC) D wD) C :=
  written_preserved _ D C wD sepD
    (written_here _ C wC
      (allocated_write _ B C wB (allocated_write _ A C wA allocated)) width writable)

theorem new_fourth (A B C D : ArrayPointer) (h0 : C99MemoryReference.Memory)
    (wA wB wC wD : BitVec 16)
    (allocated : C99MemoryReference.Allocated h0 D) (width : D.elementBytes=2)
    (writable : h0.writable D.block=true) :
    Written (Word16Memory158.write (Word16Memory158.write (Word16Memory158.write
      (Word16Memory158.write h0 A wA) B wB) C wC) D wD) D :=
  written_here _ D wD
    (alloc_four A B C D D h0 wA wB wC wD allocated) width
    (writable_four A B C D D h0 wA wB wC wD writable)

theorem lastIndex_ne (a b : Nat) (ha : a<512) (hb : b<512) (different : a≠b) :
    lastIndex a≠lastIndex b := by
  intro equal
  have := KeygenMkgm3Table.last_injective a b ha hb equal
  omega

def Cover2 (s : State) (gm igm : ArrayPointer) (i : Nat) : Prop :=
  ∀ j, j < i+2 → Written s.heap (element gm (lastIndex j)) ∧
    Written s.heap (element igm (lastIndex j))

theorem chain_step (a : Stmt) (rest : List Stmt) (s m : State) (out : C99ProcedureReference.Result)
    (head : Exec KeygenPublicSource.program [] a s ⟨m,.normal⟩)
    (tail : Exec KeygenPublicSource.program [] (KeygenPublicExec.chain rest) m out) :
    Exec KeygenPublicSource.program [] (KeygenPublicExec.chain (a::rest)) s out :=
  .seqNormal a (KeygenPublicExec.chain rest) s m out head tail

/- One complete row iteration: four sixteen-bit stores and four scalar
   updates, with the exact heap writes and full caller frame. -/
theorem body_source (s : State) (gm igm : ArrayPointer) (i : Nat) (upper : i+1<512)
    (inv : RowInv s gm igm i) :
    ∃ mid, Exec KeygenPublicSource.program [] KeygenPublicLastProgram.body s ⟨mid,.normal⟩ ∧
      RowInv mid gm igm i ∧ Cover2 mid gm igm i := by
  obtain ⟨xw,xSlot⟩ := inv.xSlot
  obtain ⟨ixw,ixSlot⟩ := inv.ixSlot
  obtain ⟨g2w,g2Slot⟩ := inv.g2Slot
  obtain ⟨g4w,g4Slot⟩ := inv.g4Slot
  obtain ⟨ig2w,ig2Slot⟩ := inv.ig2Slot
  obtain ⟨ig4w,ig4Slot⟩ := inv.ig4Slot
  have t := inv.tables
  set x1 := rowValue xw g4w
  set ix1 := rowValue ixw ig4w
  set x2 := rowValue x1 g2w
  set ix2 := rowValue ix1 ig2w
  set wA := KeygenPublicWord.narrow (.uint32 xw)
  set wB := KeygenPublicWord.narrow (.uint32 ixw)
  set wC := KeygenPublicWord.narrow (.uint32 x1)
  set wD := KeygenPublicWord.narrow (.uint32 ix1)
  set A : ArrayPointer := element gm (lastIndex i)
  set B : ArrayPointer := element igm (lastIndex i)
  set C : ArrayPointer := element gm (lastIndex (i+1))
  set D : ArrayPointer := element igm (lastIndex (i+1))
  set h1 := Word16Memory158.write s.heap A wA
  set m1 : State := {s with heap := h1}
  set h2 := Word16Memory158.write h1 B wB
  set m2 : State := {m1 with heap := h2}
  set m3 : State := bindValue m2 "x".toList .uint32 (.uint32 x1)
  set m4 : State := bindValue m3 "ix".toList .uint32 (.uint32 ix1)
  set h3 := Word16Memory158.write h2 C wC
  set m5 : State := {m4 with heap := h3}
  set h4 := Word16Memory158.write h3 D wD
  set m6 : State := {m5 with heap := h4}
  set m7 : State := bindValue m6 "x".toList .uint32 (.uint32 x2)
  set m8 : State := bindValue m7 "ix".toList .uint32 (.uint32 ix2)
  have e1 : Exec KeygenPublicSource.program [] (store "gm" "x" u) s ⟨m1,.normal⟩ :=
    store_source s gm igm t "gm".toList _ (KeygenPublicTableAtoms.var "x") true gm (Or.inl rfl)
      (lastIndex i) (lastIndex_lt i (by omega)) (.uint32 xw)
      (address_index s "gm".toList gm i (by omega) inv.kSlot inv.bSlot inv.counter
        t.gmBinding t.gmCapacity) (eval_var s "x" xw xSlot)
  have t1 : Tables m1 gm igm := tables_frame s m1 gm igm t rfl rfl rfl
  have e2 : Exec KeygenPublicSource.program [] (store "igm" "ix" u) m1 ⟨m2,.normal⟩ :=
    store_source m1 gm igm t1 "igm".toList _ (KeygenPublicTableAtoms.var "ix") true igm (Or.inr rfl)
      (lastIndex i) (lastIndex_lt i (by omega)) (.uint32 ixw)
      (address_index m1 "igm".toList igm i (by omega) inv.kSlot inv.bSlot inv.counter
        t.igmBinding t.igmCapacity) (eval_var m1 "ix" ixw ixSlot)
  have e3 : Exec KeygenPublicSource.program [] (advance "x" "g4") m2 ⟨m3,.normal⟩ :=
    .assign "x".toList _ _ .uint32 (some (.uint32 xw)) (.uint32 x1) xSlot
      (mont_var m2 "x" "g4" xw g4w xSlot g4Slot)
  have ix3 : Slot m3 "ix" ixw :=
    keep_slot m2 "ix" "x" .uint32 (.uint32 x1) ixw (by decide) ixSlot
  have ig43 : Slot m3 "ig4" ig4w :=
    keep_slot m2 "ig4" "x" .uint32 (.uint32 x1) ig4w (by decide) ig4Slot
  have e4 : Exec KeygenPublicSource.program [] (advance "ix" "ig4") m3 ⟨m4,.normal⟩ :=
    .assign "ix".toList _ _ .uint32 (some (.uint32 ixw)) (.uint32 ix1) ix3
      (mont_var m3 "ix" "ig4" ixw ig4w ix3 ig43)
  have x4 : Slot m4 "x" x1 :=
    keep_slot m3 "x" "ix" .uint32 (.uint32 ix1) x1 (by decide) (u32_slot_after m2 "x" x1)
  have g24 : Slot m4 "g2" g2w := keep_slot m3 "g2" "ix" .uint32 (.uint32 ix1) g2w (by decide) g2Slot
  have t4 : Tables m4 gm igm := tables_frame s m4 gm igm t rfl rfl rfl
  have e5 : Exec KeygenPublicSource.program [] (store "gm" "x" nextU) m4 ⟨m5,.normal⟩ :=
    store_source m4 gm igm t4 "gm".toList _ (KeygenPublicTableAtoms.var "x") true gm (Or.inl rfl)
      (lastIndex (i+1)) (lastIndex_lt (i+1) (by omega)) (.uint32 x1)
      (address_index_next m4 "gm".toList gm i (by omega) inv.kSlot inv.bSlot inv.counter
        t.gmBinding t.gmCapacity) (eval_var m4 "x" x1 x4)
  have ix5 : Slot m5 "ix" ix1 :=
    keep_slot m4 "ix" "x" .uint32 (.uint32 x1) ix1 (by decide) (u32_slot_after m3 "ix" ix1)
  have t5 : Tables m5 gm igm := tables_frame s m5 gm igm t rfl rfl rfl
  have e6 : Exec KeygenPublicSource.program [] (store "igm" "ix" nextU) m5 ⟨m6,.normal⟩ :=
    store_source m5 gm igm t5 "igm".toList _ (KeygenPublicTableAtoms.var "ix") true igm (Or.inr rfl)
      (lastIndex (i+1)) (lastIndex_lt (i+1) (by omega)) (.uint32 ix1)
      (address_index_next m5 "igm".toList igm i (by omega) inv.kSlot inv.bSlot inv.counter
        t.igmBinding t.igmCapacity) (eval_var m5 "ix" ix1 ix5)
  have x6 : Slot m6 "x" x1 := keep_slot m5 "x" "ix" .uint32 (.uint32 ix1) x1 (by decide) x4
  have g26 : Slot m6 "g2" g2w := keep_slot m5 "g2" "ix" .uint32 (.uint32 ix1) g2w (by decide) g24
  have e7 : Exec KeygenPublicSource.program [] (advance "x" "g2") m6 ⟨m7,.normal⟩ :=
    .assign "x".toList _ _ .uint32 (some (.uint32 x1)) (.uint32 x2) x6
      (mont_var m6 "x" "g2" x1 g2w x6 g26)
  have ix7 : Slot m7 "ix" ix1 :=
    keep_slot m6 "ix" "x" .uint32 (.uint32 x2) ix1 (by decide) ix5
  have ig27 : Slot m7 "ig2" ig2w :=
    keep_slot m6 "ig2" "x" .uint32 (.uint32 x2) ig2w (by decide) ig2Slot
  have e8 : Exec KeygenPublicSource.program [] (advance "ix" "ig2") m7 ⟨m8,.normal⟩ :=
    .assign "ix".toList _ _ .uint32 (some (.uint32 ix1)) (.uint32 ix2) ix7
      (mont_var m7 "ix" "ig2" ix1 ig2w ix7 ig27)
  have cover2 : Cover2 m8 gm igm i := by
    intro j hj
    by_cases c1 : j=i+1
    · rw [c1]
      refine ⟨?_,?_⟩
      · exact new_third A B C D s.heap wA wB wC wD (t.gmAllocated (lastIndex (i+1)) (lastIndex_lt (i+1) (by omega)))
          t.gmWidth t.gmWritable (separate_cross_right gm igm t.separate _ _)
      · exact new_fourth A B C D s.heap wA wB wC wD (t.igmAllocated (lastIndex (i+1)) (lastIndex_lt (i+1) (by omega)))
          t.igmWidth t.igmWritable
    · by_cases c2 : j=i
      · rw [c2]
        refine ⟨?_,?_⟩
        · exact new_first A B C D s.heap wA wB wC wD (t.gmAllocated (lastIndex i) (lastIndex_lt i (by omega)))
            t.gmWidth t.gmWritable (separate_cross_right gm igm t.separate _ _)
            (separate_elements gm t.gmWidth _ _
              (lastIndex_ne (i+1) i (by omega) (by omega) (by omega)))
            (separate_cross_right gm igm t.separate _ _)
        · exact new_second A B C D s.heap wA wB wC wD (t.igmAllocated (lastIndex i) (lastIndex_lt i (by omega)))
            t.igmWidth t.igmWritable (separate_cross gm igm t.separate _ _)
            (separate_elements igm t.igmWidth _ _
              (lastIndex_ne (i+1) i (by omega) (by omega) (by omega)))
      · have jd := last_distinct i j upper (by omega)
        refine ⟨?_,?_⟩
        · exact through4 A B C D (element gm (lastIndex j)) s.heap wA wB wC wD
            (separate_elements gm t.gmWidth _ _ (Ne.symm jd.1))
            (separate_cross_right gm igm t.separate _ _)
            (separate_elements gm t.gmWidth _ _ (Ne.symm jd.2))
            (separate_cross_right gm igm t.separate _ _)
            (inv.covered j (by omega)).1
        · exact through4 A B C D (element igm (lastIndex j)) s.heap wA wB wC wD
            (separate_cross gm igm t.separate _ _)
            (separate_elements igm t.igmWidth _ _ (Ne.symm jd.1))
            (separate_cross gm igm t.separate _ _)
            (separate_elements igm t.igmWidth _ _ (Ne.symm jd.2))
            (inv.covered j (by omega)).2
  have invM8 : RowInv m8 gm igm i :=
    ⟨⟨t.gmBinding,t.igmBinding,t.gmWidth,t.igmWidth,t.gmCapacity,t.igmCapacity,
      t.gmAllocated,t.igmAllocated,t.gmWritable,t.igmWritable,t.separate⟩,
      inv.lognSlot,inv.counter,inv.kSlot,inv.bSlot,
      ⟨x2,u32_slot_after m6 "x" x2⟩,⟨ix2,u32_slot_after m7 "ix" ix2⟩,
      ⟨g2w,g2Slot⟩,⟨g4w,g4Slot⟩,⟨ig2w,ig2Slot⟩,⟨ig4w,ig4Slot⟩,
      fun j hj => cover2 j (by omega)⟩
  have c8 : Exec KeygenPublicSource.program [] (KeygenPublicExec.chain [advance "ix" "ig2"])
      m7 ⟨m8,.normal⟩ :=
    chain_step (advance "ix" "ig2") [] m7 m8 ⟨m8,.normal⟩ e8 (.skip m8)
  have c7 : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain [advance "x" "g2",advance "ix" "ig2"]) m6 ⟨m8,.normal⟩ :=
    chain_step (advance "x" "g2") _ m6 m7 _ e7 c8
  have c6 : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain [store "igm" "ix" nextU,advance "x" "g2",advance "ix" "ig2"])
      m5 ⟨m8,.normal⟩ :=
    chain_step (store "igm" "ix" nextU) _ m5 m6 _ e6 c7
  have c5 : Exec KeygenPublicSource.program [] (KeygenPublicExec.chain
      [store "gm" "x" nextU,store "igm" "ix" nextU,advance "x" "g2",advance "ix" "ig2"])
      m4 ⟨m8,.normal⟩ :=
    chain_step (store "gm" "x" nextU) _ m4 m5 _ e5 c6
  have c4 : Exec KeygenPublicSource.program [] (KeygenPublicExec.chain
      [advance "ix" "ig4",store "gm" "x" nextU,store "igm" "ix" nextU,advance "x" "g2",
       advance "ix" "ig2"]) m3 ⟨m8,.normal⟩ :=
    chain_step (advance "ix" "ig4") _ m3 m4 _ e4 c5
  have c3 : Exec KeygenPublicSource.program [] (KeygenPublicExec.chain
      [advance "x" "g4",advance "ix" "ig4",store "gm" "x" nextU,store "igm" "ix" nextU,
       advance "x" "g2",advance "ix" "ig2"]) m2 ⟨m8,.normal⟩ :=
    chain_step (advance "x" "g4") _ m2 m3 _ e3 c4
  have c2 : Exec KeygenPublicSource.program [] (KeygenPublicExec.chain
      [store "igm" "ix" u,advance "x" "g4",advance "ix" "ig4",store "gm" "x" nextU,
       store "igm" "ix" nextU,advance "x" "g2",advance "ix" "ig2"]) m1 ⟨m8,.normal⟩ :=
    chain_step (store "igm" "ix" u) _ m1 m2 _ e2 c3
  refine ⟨m8,?_,invM8,cover2⟩
  exact chain_step (store "gm" "x" u) _ s m1 _ e1 c2

theorem increment_inv_full (s : State) (gm igm : ArrayPointer) (i : Nat) (bound : i+2<2^64)
    (inv : RowInv s gm igm i) (cover : Cover2 s gm igm i) :
    RowInv (bindValue s "u".toList .uint64 (u64 (i+2))) gm igm (i+2) := by
  have t := inv.tables
  refine ⟨⟨t.gmBinding,t.igmBinding,t.gmWidth,t.igmWidth,t.gmCapacity,t.igmCapacity,
    t.gmAllocated,t.igmAllocated,t.gmWritable,t.igmWritable,t.separate⟩,?_,
    u64_slot_after s "u" (i+2) bound,?_,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · exact keep_slot s "logn" "u" .uint64 _ 10 (by decide) inv.lognSlot
  · exact keep_slot s "k" "u" .uint64 _ 1 (by decide) inv.kSlot
  · exact keep_u64 s "b" "u" .uint64 _ 512 (by decide) inv.bSlot
  · obtain ⟨w,h⟩ := inv.xSlot
    exact ⟨w,keep_slot s "x" "u" .uint64 _ w (by decide) h⟩
  · obtain ⟨w,h⟩ := inv.ixSlot
    exact ⟨w,keep_slot s "ix" "u" .uint64 _ w (by decide) h⟩
  · obtain ⟨w,h⟩ := inv.g2Slot
    exact ⟨w,keep_slot s "g2" "u" .uint64 _ w (by decide) h⟩
  · obtain ⟨w,h⟩ := inv.g4Slot
    exact ⟨w,keep_slot s "g4" "u" .uint64 _ w (by decide) h⟩
  · obtain ⟨w,h⟩ := inv.ig2Slot
    exact ⟨w,keep_slot s "ig2" "u" .uint64 _ w (by decide) h⟩
  · obtain ⟨w,h⟩ := inv.ig4Slot
    exact ⟨w,keep_slot s "ig4" "u" .uint64 _ w (by decide) h⟩
  · exact cover

/- The full row loop: 256 iterations from the even counter to 512. -/
theorem loop_source (count : Nat) (i : Nat) (s : State) (gm igm : ArrayPointer)
    (inv : RowInv s gm igm i) (finish : i+2*count=512) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicLastProgram.loop s ⟨after,.normal⟩ ∧
      RowInv after gm igm 512 := by
  induction count generalizing i s with
  | zero =>
      have same : i=512 := by omega
      subst i
      have guard := guard_row s gm igm 512 (by decide) inv
      have zero : (C99ScalarReference.boolean (decide (512<512))).integer=0 := by decide
      exact ⟨s,.loopFalse _ _ _ _ _ guard zero,inv⟩
  | succ count ih =>
      have upper : i+1<512 := by omega
      have inside : i<512 := by omega
      obtain ⟨mid,bodyExec,invMid,coverMid⟩ := body_source s gm igm i upper inv
      have inc : Exec KeygenPublicSource.program [] KeygenPublicLastProgram.increment mid
          ⟨bindValue mid "u".toList .uint64 (u64 (i+2)),.normal⟩ :=
        increment_source mid gm igm i (by omega) invMid
      have invNext : RowInv (bindValue mid "u".toList .uint64 (u64 (i+2))) gm igm (i+2) :=
        increment_inv_full mid gm igm i (by omega) invMid coverMid
      obtain ⟨after,rest,invAfter⟩ :=
        ih (i+2) (bindValue mid "u".toList .uint64 (u64 (i+2))) invNext (by omega)
      have guardTrue : Eval [] s KeygenPublicLastProgram.condition
          (C99ScalarReference.boolean true) := by
        simpa [inside] using guard_row s gm igm i (by omega) inv
      have nonzero : (C99ScalarReference.boolean true).integer≠0 := by decide
      exact ⟨after,.loopNormal _ _ _ s mid
        (bindValue mid "u".toList .uint64 (u64 (i+2))) ⟨after,.normal⟩
        (C99ScalarReference.boolean true) guardTrue nonzero
        (scope_empty KeygenPublicLastProgram.body s mid bodyExec) inc rest,invAfter⟩

theorem covered_top (after : State) (gm igm : ArrayPointer)
    (inv : RowInv after gm igm 512) :
    WrittenRange after.heap gm 512 1024 ∧ WrittenRange after.heap igm 512 1024 := by
  refine ⟨fun i lo hi => ?_,fun i lo hi => ?_⟩
  · obtain ⟨u,_,eq⟩ := KeygenMkgm3Table.last_covers i lo hi
    rw [← eq]
    exact (inv.covered u (by omega)).1
  · obtain ⟨u,_,eq⟩ := KeygenMkgm3Table.last_covers i lo hi
    rw [← eq]
    exact (inv.covered u (by omega)).2

end FT1536.Source3.PublicGenerateRow159
