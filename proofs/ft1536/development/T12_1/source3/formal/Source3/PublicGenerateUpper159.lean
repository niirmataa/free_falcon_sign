import Source3.PublicGenerateRow159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact parsed shapes of the mq_mkgm3 upper and square suffix loops
   (falcon-vrfy.c fragment 863 22): the k rebind, the 256-iteration upper
   loop with its two loads and pair stores, the 255-iteration descending
   square loop and the final three statements. Value-free; the shape
   theorem is kernel-checked against the pinned parser. -/
namespace FT1536.Source3.PublicGenerateUpper159
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value Ty)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval Address)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open PublicGenerateTable159 (Tables Written WrittenRange written_here written_preserved
  written_new written_after tables_write store_source separate_elements separate_cross
  separate_cross_right)
open PublicGenerateIndex159
open PublicGenerateRow159 (rowValue mont_var keep_slot keep_u64 u32_slot_after u64_slot_after
  restoreScope_empty scope_empty chain_step)

def kSet : Stmt := .assign "k".toList
  (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 2))
def u2Init : Stmt := .assign "u".toList
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1)) (KeygenPublicTableAtoms.var "k"))
def upperGuard : KeygenWordExpr.Expr := .cmp .lt (KeygenPublicTableAtoms.var "u")
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
    (.bin .add (KeygenPublicTableAtoms.var "k") (KeygenPublicTableAtoms.literal 1)))
def upperBody : Stmt := .scope ["y".toList,"z".toList] [] (KeygenPublicExec.chain [
  .scalar (.declare .u32 ["y".toList,"z".toList]),
  .assign "y".toList (.load16 "gm".toList
    (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
  .assign "z".toList (.load16 "igm".toList
    (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
  .store "gm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y"))),
  .store "igm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))])
def upperInc : Stmt := .scalar (.update "u".toList .add (CLogic.Expr.literal .i32 1))
def upperLoop : Stmt := .loop upperGuard upperBody upperInc
def u3Init : Stmt := .assign "u".toList (.bin .sub
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1)) (KeygenPublicTableAtoms.var "k"))
  (KeygenPublicTableAtoms.literal 1))
def squareGuard : KeygenWordExpr.Expr := .cmp .gt (KeygenPublicTableAtoms.var "u")
  (KeygenPublicTableAtoms.literal 0)
def squareBody : Stmt := .scope ["v".toList] [] (KeygenPublicExec.chain [
  .scalar (.declare .u64 ["v".toList]),
  .assign "v".toList (.bin .shl (KeygenPublicTableAtoms.var "u")
    (KeygenPublicTableAtoms.literal 1)),
  .store "gm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (.load16 "gm".toList (CLogic.Expr.var "v".toList))
      (.load16 "gm".toList (CLogic.Expr.var "v".toList))),
  .store "igm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
      (.load16 "igm".toList (CLogic.Expr.var "v".toList)))])
def squareInc : Stmt := .scalar (.update "u".toList .sub (CLogic.Expr.literal .i32 1))
def squareLoop : Stmt := .loop squareGuard squareBody squareInc
def finalTail : Stmt :=
  .seq (.store "gm".toList (CLogic.Expr.literal .i32 0) false
      (.load16 "gm".toList (CLogic.Expr.literal .i32 1)))
  (.seq (.assign "w".toList (.load16 "gm".toList (CLogic.Expr.literal .i32 1)))
  (.seq (.store "igm".toList (CLogic.Expr.literal .i32 0) true
    (KeygenPublicTableAtoms.divide (KeygenPublicTableAtoms.literal 4564)
      (.call3 (KeygenPublicScalar.name .sub)
        (.call3 (KeygenPublicScalar.name .add)
          (KeygenPublicTableAtoms.var "w") (KeygenPublicTableAtoms.var "w")
          (KeygenPublicTableAtoms.literal 18433))
        (KeygenPublicTableAtoms.literal 10237)
        (KeygenPublicTableAtoms.literal 18433))))
  .skip))

theorem afterRows_shape : KeygenPublicTableRows.afterRows =
    .seq kSet (.seq (.seq u2Init upperLoop) (.seq (.seq u3Init squareLoop) finalTail)) :=
  by decide

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

/- Upper loop: 256 iterations writing gm[u]/igm[u] from their doubled
   reads, with the coverage invariant over [256,512) and the top range. -/
structure UpperInv (s : State) (gm igm : ArrayPointer) (c : Nat) : Prop where
  tables : Tables s gm igm
  lognSlot : Slot s "logn" 10
  kSlot : Slot s "k" (BitVec.ofNat 32 8)
  counter : USlot s "u" c
  covered : ∀ j, 256 ≤ j → j < c → Written s.heap (element gm j) ∧ Written s.heap (element igm j)
  coveredTop : ∀ j, 512 ≤ j → j < 1024 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)

def CoverUp (s : State) (gm igm : ArrayPointer) (c : Nat) : Prop :=
  ∀ j, 256 ≤ j → j < c+1 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)

theorem keep_slot (s : State) (name other : String) (ty : Ty) (v : Value) (w : BitVec 32)
    (different : name≠other) (slot : Slot s name w) :
    Slot (bindValue s other.toList ty v) name w :=
  KeygenPublicTableAtoms.slot_preserved s name other w ty v different slot

theorem u32_slot_after (s : State) (name : String) (w : BitVec 32) :
    Slot (bindValue s name.toList .uint32 (.uint32 w)) name w :=
  KeygenPublicTableAtoms.slot_after s name w

theorem u64_slot_after (s : State) (name : String) (m : Nat) (bound : m<2^64) :
    USlot (bindValue s name.toList .uint64 (u64 m)) name m := by
  have converted : C99IntegerReference.convert .uint64 (u64 m).integer=u64 m :=
    KeygenNttLoopSupport.convert_u64_self m bound
  simp [KeygenNttLoopSupport.USlot,C99ArrayReference.bindValue,C99ScalarReference.set,converted]

theorem update_exec (s : State) (name : String) (c : Nat) (bound : c+1<2^64)
    (slot : USlot s name c) :
    Exec KeygenPublicSource.program [] (.scalar (.update name.toList .add (CLogic.Expr.literal .i32 1)))
      s ⟨bindValue s name.toList .uint64 (u64 (c+1)),.normal⟩ :=
  .scalar _ _ _ (C99ScalarReference.Exec.assign s.locals name.toList _
    .uint64 (some (u64 c)) (u64 (c+1)) slot
    (.arithmetic .plus _ _ _ _ _ (C99ScalarReference.Eval.variable name.toList .uint64 (u64 c) slot)
      (C99ScalarReference.Eval.literal .int32 1) (C99NatWord141.add_one c (Nat.lt_of_succ_lt bound))))

theorem update_down_exec (s : State) (name : String) (c : Nat) (pos : 1 ≤ c) (bound : c<2^64)
    (slot : USlot s name c) :
    Exec KeygenPublicSource.program [] (.scalar (.update name.toList .sub (CLogic.Expr.literal .i32 1)))
      s ⟨bindValue s name.toList .uint64 (u64 (c-1)),.normal⟩ := by
  have op := PublicGenerateIndex159.sub_one c pos bound
  refine .scalar _ _ _ (C99ScalarReference.Exec.assign s.locals name.toList _
    .uint64 (some (u64 c)) (u64 (c-1)) slot
    (.arithmetic .minus _ _ _ _ _ (C99ScalarReference.Eval.variable name.toList .uint64 (u64 c) slot)
      (C99ScalarReference.Eval.literal .int32 1) ?_))
  exact op


/- Value-free load support: a Written cell supplies a sixteen-bit read and
   its unsigned promotion; no stored word enters any premise. -/
theorem u32_promoted (w : BitVec 16) :
    KeygenPublicArguments.U32 (C99NarrowReads.unsignedPromotion w) (BitVec.ofNat 32 w.toNat) := by
  show C99IntegerReference.convert .uint32 (C99NarrowReads.unsignedPromotion w).integer=_
  rw [C99NarrowReads.unsigned_promotion_exact]
  show C99IntegerReference.Value.uint32 (BitVec.ofInt 32 (w.toNat:Int))=_
  rw [BitVec.ofInt_natCast]

theorem load_slot (s : State) (name : String) (w : BitVec 16) :
    Slot (bindValue s name.toList .uint32 (C99NarrowReads.unsignedPromotion w)) name
      (BitVec.ofNat 32 w.toNat) := by
  show (C99ScalarReference.set s.locals name.toList
    (C99IntegerReference.Ty.uint32,
      some (C99IntegerReference.convert .uint32 (C99NarrowReads.unsignedPromotion w).integer))) name.toList=_
  simp only [C99ScalarReference.set,ite_true]
  rw [u32_promoted]

theorem load_eval (s : State) (name : Name) (index : CLogic.Expr) (p : ArrayPointer) (i : Nat)
    (address : Address s name index (element p i)) (w : BitVec 16)
    (read : C99NarrowReads.Load16 s.heap (element p i) w) :
    Eval [] s (.load16 name index) (C99NarrowReads.unsignedPromotion w) :=
  .load16 name index (element p i) w address read

theorem lit_integer (i : Nat) (hi : i<2^31) : (C99IntegerReference.convert .int32 i).integer=(i:Int) := by
  show (BitVec.ofInt 32 (i:Int)).toInt=(i:Int)
  exact BitVec.toInt_ofInt_eq_self (by decide) (by omega) (by omega)

theorem address_lit (s : State) (name : Name) (p : ArrayPointer) (i : Nat) (hi : i<2^31)
    (binding : s.arrays name=some p) (capacity : p.index+i ≤ p.count) :
    Address s name (CLogic.Expr.literal .i32 i) (element p i) :=
  .add name (CLogic.Expr.literal .i32 i) p (element p i)
    (C99IntegerReference.convert .int32 i) binding (PublicGenerateIndex159.lit_i32 s i)
    (by rw [lit_integer i hi]; omega)
    (by rw [lit_integer i hi]; exact PublicGenerateIndex159.pointer_within p i capacity)

theorem address_named (s : State) (name cn : String) (p : ArrayPointer) (i : Nat) (hi : i<2^64)
    (binding : s.arrays name.toList=some p) (slot : USlot s cn i)
    (capacity : p.index+i ≤ p.count) :
    Address s name.toList (CLogic.Expr.var cn.toList) (element p i) :=
  .add name.toList _ p _ (u64 i) binding (PublicGenerateIndex159.var_u64 s cn i slot)
    (by rw [KeygenNttLoopSupport.u64_integer i hi]; omega)
    (by rw [KeygenNttLoopSupport.u64_toNat i hi]; exact PublicGenerateIndex159.pointer_within p i capacity)

theorem mont_u32 (s : State) (a b : KeygenWordExpr.Expr) (va vb : Value) (x y : BitVec 32)
    (ha : Eval [] s a va) (hb : Eval [] s b vb)
    (ua : KeygenPublicArguments.U32 va x) (ub : KeygenPublicArguments.U32 vb y) :
    Eval [] s (KeygenPublicTableAtoms.mont a b)
      (.uint32 (KeygenPublicLeafWords.montgomery x y 18433#32 18431#32)) :=
  KeygenPublicWord.Eval.call4 (KeygenPublicScalar.name .mul) a b
    (KeygenPublicTableAtoms.literal 18433) (KeygenPublicTableAtoms.literal 18431)
    va vb (C99IntegerReference.convert .int32 18433) (C99IntegerReference.convert .int32 18431) _ ha hb
    (PublicGenerateHead159.eval_lit s 18433) (PublicGenerateHead159.eval_lit s 18431)
    (PublicGenerateHead159.mul_call x y va vb _ _ ua ub
      (PublicGenerateHead159.u32_arg 18433) (PublicGenerateHead159.u32_arg 18431))

theorem cube_eval (s : State) (n : String) (xw : BitVec 32) (slot : Slot s n xw) :
    Eval [] s (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var n)
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var n) (KeygenPublicTableAtoms.var n)))
      (.uint32 (rowValue xw (rowValue xw xw))) :=
  mont_u32 s _ _ (.uint32 xw) (.uint32 (rowValue xw xw)) xw (rowValue xw xw)
    (PublicGenerateHead159.eval_var s n xw slot) (mont_var s n n xw xw slot slot)
    (KeygenPublicArguments.u32_self xw) (KeygenPublicArguments.u32_self (rowValue xw xw))

theorem cell_frame (code : Stmt) (s t : State) (name : String)
    (ok : KeygenPublicTableControl.supported code=true)
    (outside : name.toList ∉ KeygenPublicTableControl.writes code)
    (source : Exec KeygenPublicSource.program [] code s ⟨t,.normal⟩) :
    t.locals name.toList=s.locals name.toList :=
  (KeygenPublicTableControl.frame KeygenPublicSource.program [] code s ⟨t,.normal⟩ ok source).2.2
    name.toList outside

theorem bind_keep (s : State) (ty : Ty) (v : Value) (name other : String) (different : name≠other) :
    (bindValue s name.toList ty v).locals other.toList=s.locals other.toList := by
  show (C99ScalarReference.set s.locals name.toList
    (ty, some (C99IntegerReference.convert ty v.integer))) other.toList=_
  simp only [C99ScalarReference.set]
  have absent : other.toList≠name.toList :=
    fun equal => different (String.toList_injective equal.symm)
  simp only [absent,ite_false]

/- Post-body facts of one upper iteration: the two writes cover the current
   cells, everything below is retained, the top range is untouched. -/
structure UpperMid (s : State) (gm igm : ArrayPointer) (c : Nat) : Prop where
  tables : Tables s gm igm
  lognSlot : Slot s "logn" 10
  kSlot : Slot s "k" (BitVec.ofNat 32 8)
  counter : USlot s "u" c
  covered : CoverUp s gm igm c
  coveredTop : ∀ j, 512 ≤ j → j < 1024 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)

theorem upper_body_source (s : State) (gm igm : ArrayPointer) (c : Nat)
    (lower : 256 ≤ c) (upper : c < 512) (inv : UpperInv s gm igm c) :
    ∃ mid, Exec KeygenPublicSource.program [] upperBody s ⟨mid,.normal⟩ ∧ UpperMid mid gm igm c := by
  have t := inv.tables
  obtain ⟨wy,wyRead⟩ := (inv.coveredTop (2*c) (by omega) (by omega)).1
  obtain ⟨wz,wzRead⟩ := (inv.coveredTop (2*c) (by omega) (by omega)).2
  have cap1 := t.gmCapacity
  have cap2 := t.igmCapacity
  have capG : gm.index+2*c ≤ gm.count := by omega
  have capI : igm.index+2*c ≤ igm.count := by omega
  set xw : BitVec 32 := BitVec.ofNat 32 wy.toNat
  set zw : BitVec 32 := BitVec.ofNat 32 wz.toNat
  set s1 : State := {s with locals := C99DeclarationCells.declareCells .uint32 ["y".toList,"z".toList] s.locals}
  have dExec : Exec KeygenPublicSource.program [] (.scalar (.declare .u32 ["y".toList,"z".toList]))
      s ⟨s1,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32
      ["y".toList,"z".toList] s.locals)
  have yCell : s1.locals "y".toList=some (.uint32,none) := by
    show (C99DeclarationCells.declareCells .uint32 ["y".toList,"z".toList] s.locals) "y".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  have zCell : s1.locals "z".toList=some (.uint32,none) := by
    show (C99DeclarationCells.declareCells .uint32 ["y".toList,"z".toList] s.locals) "z".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  have u1 : USlot s1 "u" c := by
    show (C99DeclarationCells.declareCells .uint32 ["y".toList,"z".toList] s.locals) "u".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
    exact inv.counter
  have yLoad : Eval [] s1
      (.load16 "gm".toList (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1)))
      (C99NarrowReads.unsignedPromotion wy) :=
    load_eval s1 "gm".toList _ gm (2*c)
      (PublicGenerateIndex159.address_shifted s1 "gm" gm c (by omega) t.gmBinding u1 capG) wy wyRead
  have yExec : Exec KeygenPublicSource.program []
      (.assign "y".toList (.load16 "gm".toList
        (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))))
      s1 ⟨bindValue s1 "y".toList .uint32 (C99NarrowReads.unsignedPromotion wy),.normal⟩ :=
    .assign "y".toList _ _ .uint32 none (C99NarrowReads.unsignedPromotion wy) yCell yLoad
  set s2 : State := bindValue s1 "y".toList .uint32 (C99NarrowReads.unsignedPromotion wy)
  have zCell2 : s2.locals "z".toList=some (.uint32,none) := zCell
  have u2 : USlot s2 "u" c :=
    keep_u64 s1 "u" "y" .uint32 (C99NarrowReads.unsignedPromotion wy) c (by decide) u1
  have zLoad : Eval [] s2
      (.load16 "igm".toList (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1)))
      (C99NarrowReads.unsignedPromotion wz) :=
    load_eval s2 "igm".toList _ igm (2*c)
      (PublicGenerateIndex159.address_shifted s2 "igm" igm c (by omega) t.igmBinding u2 capI) wz wzRead
  have zExec : Exec KeygenPublicSource.program []
      (.assign "z".toList (.load16 "igm".toList
        (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))))
      s2 ⟨bindValue s2 "z".toList .uint32 (C99NarrowReads.unsignedPromotion wz),.normal⟩ :=
    .assign "z".toList _ _ .uint32 none (C99NarrowReads.unsignedPromotion wz) zCell2 zLoad
  set s3 : State := bindValue s2 "z".toList .uint32 (C99NarrowReads.unsignedPromotion wz)
  have t3 : Tables s3 gm igm := tables_frame s s3 gm igm t rfl rfl rfl
  have u3 : USlot s3 "u" c :=
    keep_u64 s2 "u" "z" .uint32 (C99NarrowReads.unsignedPromotion wz) c (by decide) u2
  have slotY : Slot s3 "y" xw :=
    keep_slot s2 "y" "z" .uint32 (C99NarrowReads.unsignedPromotion wz) xw (by decide) (load_slot s1 "y" wy)
  have addrG : Address s3 "gm".toList (CLogic.Expr.var "u".toList) (element gm c) :=
    PublicGenerateIndex159.address_u64 s3 "gm" gm c (by omega) t3.gmBinding u3 (by omega)
  have valG : Eval [] s3
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
        (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y")))
      (.uint32 (rowValue xw (rowValue xw xw))) :=
    cube_eval s3 "y" xw slotY
  set hA := Word16Memory158.write s3.heap (element gm c)
    (KeygenPublicWord.narrow (.uint32 (rowValue xw (rowValue xw xw))))
  set s4 : State := {s3 with heap := hA}
  have gmExec : Exec KeygenPublicSource.program []
      (.store "gm".toList (CLogic.Expr.var "u".toList) true
        (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
          (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y"))))
      s3 ⟨s4,.normal⟩ :=
    store_source s3 gm igm t3 "gm".toList _ _ true gm (Or.inl rfl) c (by omega) _ addrG valG
  have t4 : Tables s4 gm igm := tables_frame s s4 gm igm t rfl rfl rfl
  have u4 : USlot s4 "u" c := u3
  have slotZ : Slot s4 "z" zw := load_slot s2 "z" wz
  have addrI : Address s4 "igm".toList (CLogic.Expr.var "u".toList) (element igm c) :=
    PublicGenerateIndex159.address_u64 s4 "igm" igm c (by omega) t4.igmBinding u4 (by omega)
  have valI : Eval [] s4
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
        (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))
      (.uint32 (rowValue zw (rowValue zw zw))) :=
    cube_eval s4 "z" zw slotZ
  set hB := Word16Memory158.write s4.heap (element igm c)
    (KeygenPublicWord.narrow (.uint32 (rowValue zw (rowValue zw zw))))
  set s5 : State := {s4 with heap := hB}
  have igmExec : Exec KeygenPublicSource.program []
      (.store "igm".toList (CLogic.Expr.var "u".toList) true
        (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
          (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z"))))
      s4 ⟨s5,.normal⟩ :=
    store_source s4 gm igm t4 "igm".toList _ _ true igm (Or.inr rfl) c (by omega) _ addrI valI
  have cLast : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.store "igm".toList (CLogic.Expr.var "u".toList) true
          (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))])
      s4 ⟨s5,.normal⟩ :=
    chain_step _ [] s4 s5 ⟨s5,.normal⟩ igmExec (.skip s5)
  have cG : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.store "gm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
              (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y"))),
         .store "igm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
              (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))])
      s3 ⟨s5,.normal⟩ :=
    chain_step _ _ s3 s4 _ gmExec cLast
  have cZ : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.assign "z".toList (.load16 "igm".toList
            (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
         .store "gm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
              (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y"))),
         .store "igm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
              (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))])
      s2 ⟨s5,.normal⟩ :=
    chain_step _ _ s2 s3 _ zExec cG
  have cY : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.assign "y".toList (.load16 "gm".toList
            (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
         .assign "z".toList (.load16 "igm".toList
            (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
         .store "gm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
              (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y"))),
         .store "igm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
              (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))])
      s1 ⟨s5,.normal⟩ :=
    chain_step _ _ s1 s2 _ yExec cZ
  have bodyExec : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.scalar (.declare .u32 ["y".toList,"z".toList]),
         .assign "y".toList (.load16 "gm".toList
            (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
         .assign "z".toList (.load16 "igm".toList
            (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
         .store "gm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
              (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y"))),
         .store "igm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
              (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))])
      s ⟨s5,.normal⟩ :=
    chain_step _ _ s s1 _ dExec cY
  set mid : State := C99ArrayReference.restoreScope s s5 ["y".toList,"z".toList] []
  have outer : Exec KeygenPublicSource.program [] upperBody s ⟨mid,.normal⟩ :=
    .scope ["y".toList,"z".toList] [] _ s ⟨s5,.normal⟩ bodyExec
  set wA : BitVec 16 := KeygenPublicWord.narrow (.uint32 (rowValue xw (rowValue xw xw)))
  set wB : BitVec 16 := KeygenPublicWord.narrow (.uint32 (rowValue zw (rowValue zw zw)))
  have heapEq : mid.heap=
      Word16Memory158.write (Word16Memory158.write s.heap (element gm c) wA) (element igm c) wB := rfl
  have covered : CoverUp mid gm igm c := by
    intro j lo hi
    by_cases same : j=c
    · rw [same]
      refine ⟨?_,?_⟩
      · rw [heapEq]
        exact written_preserved _ (element igm c) (element gm c) wB
          (separate_cross_right gm igm t.separate c c)
          (written_here s.heap (element gm c) wA (t.gmAllocated c (by omega)) t.gmWidth t.gmWritable)
      · rw [heapEq]
        exact written_here _ (element igm c) wB
          (PublicGenerateTable159.allocated_write _ (element gm c) (element igm c) wA (t.igmAllocated c (by omega)))
          t.igmWidth t.igmWritable
    · refine ⟨?_,?_⟩
      · rw [heapEq]
        exact written_preserved _ (element igm c) (element gm j) wB (separate_cross_right gm igm t.separate c j)
          (written_preserved _ (element gm c) (element gm j) wA
            (separate_elements gm t.gmWidth c j (Ne.symm same))
            (inv.covered j lo (by omega)).1)
      · rw [heapEq]
        exact written_preserved _ (element igm c) (element igm j) wB
          (separate_elements igm t.igmWidth c j (Ne.symm same))
          (written_preserved _ (element gm c) (element igm j) wA (separate_cross gm igm t.separate c j)
            (inv.covered j lo (by omega)).2)
  have coveredTop : ∀ j, 512 ≤ j → j < 1024 → Written mid.heap (element gm j) ∧ Written mid.heap (element igm j) := by
    intro j lo hi
    refine ⟨?_,?_⟩
    · rw [heapEq]
      exact written_preserved _ (element igm c) (element gm j) wB (separate_cross_right gm igm t.separate c j)
        (written_preserved _ (element gm c) (element gm j) wA
          (separate_elements gm t.gmWidth c j (by omega))
          (inv.coveredTop j lo hi).1)
    · rw [heapEq]
      exact written_preserved _ (element igm c) (element igm j) wB
        (separate_elements igm t.igmWidth c j (by omega))
        (written_preserved _ (element gm c) (element igm j) wA (separate_cross gm igm t.separate c j)
          (inv.coveredTop j lo hi).2)
  have midLogn : Slot mid "logn" 10 := by
    show mid.locals "logn".toList=_
    rw [cell_frame upperBody s mid "logn" (by decide) (by decide) outer]
    exact inv.lognSlot
  have midK : Slot mid "k" (BitVec.ofNat 32 8) := by
    show mid.locals "k".toList=_
    rw [cell_frame upperBody s mid "k" (by decide) (by decide) outer]
    exact inv.kSlot
  have midU : USlot mid "u" c := by
    show mid.locals "u".toList=_
    rw [cell_frame upperBody s mid "u" (by decide) (by decide) outer]
    exact inv.counter
  exact ⟨mid,outer,⟨tables_frame s mid gm igm t rfl rfl rfl,midLogn,midK,midU,covered,coveredTop⟩⟩

theorem upper_inv_step (mid : State) (gm igm : ArrayPointer) (c : Nat) (bound : c+1<2^64)
    (h : UpperMid mid gm igm c) :
    UpperInv (bindValue mid "u".toList .uint64 (u64 (c+1))) gm igm (c+1) := by
  refine ⟨tables_frame mid (bindValue mid "u".toList .uint64 (u64 (c+1))) gm igm h.tables rfl rfl rfl,
    keep_slot mid "logn" "u" .uint64 _ 10 (by decide) h.lognSlot,
    keep_slot mid "k" "u" .uint64 _ (BitVec.ofNat 32 8) (by decide) h.kSlot,
    u64_slot_after mid "u" (c+1) bound,?_,h.coveredTop⟩
  intro j lo hi
  exact h.covered j lo (by omega)

theorem upper_guard (s : State) (c : Nat) (bound : c<2^64) (k : Slot s "k" (BitVec.ofNat 32 8))
    (u : USlot s "u" c) :
    Eval [] s upperGuard (C99ScalarReference.boolean (decide (c<512))) :=
  .cmp .lt _ _ _ _ _
    (.scalar _ _ (PublicGenerateIndex159.var_u64 s "u" c u))
    (PublicGenerateIndex159.word_shl_upper s 8 (by decide) k)
    (C99NatWord141.less c 512 bound (by decide))

/- The full upper loop: 256 iterations from u=256 to the false guard. -/
theorem upper_loop_source (count : Nat) (c : Nat) (s : State) (gm igm : ArrayPointer)
    (lower : 256 ≤ c) (inv : UpperInv s gm igm c) (finish : c+count=512) :
    ∃ after, Exec KeygenPublicSource.program [] upperLoop s ⟨after,.normal⟩ ∧
      UpperInv after gm igm 512 := by
  induction count generalizing c s with
  | zero =>
      have same : c=512 := by omega
      subst c
      have guard := upper_guard s 512 (by decide) inv.kSlot inv.counter
      have zero : (C99ScalarReference.boolean (decide (512<512))).integer=0 := by decide
      exact ⟨s,.loopFalse _ _ _ _ _ guard zero,inv⟩
  | succ count ih =>
      have upper : c<512 := by omega
      obtain ⟨mid,bodyExec,midFacts⟩ := upper_body_source s gm igm c lower upper inv
      have inc : Exec KeygenPublicSource.program [] upperInc mid
          ⟨bindValue mid "u".toList .uint64 (u64 (c+1)),.normal⟩ :=
        update_exec mid "u" c (by omega) midFacts.counter
      set next : State := bindValue mid "u".toList .uint64 (u64 (c+1))
      have invNext : UpperInv next gm igm (c+1) := by
        show UpperInv (bindValue mid "u".toList .uint64 (u64 (c+1))) gm igm (c+1)
        exact upper_inv_step mid gm igm c (by omega) midFacts
      obtain ⟨after,rest,invAfter⟩ := ih (c+1) next (by omega) invNext (by omega)
      have guardTrue : Eval [] s upperGuard (C99ScalarReference.boolean true) := by
        simpa [upper] using upper_guard s c (by omega) inv.kSlot inv.counter
      have nonzero : (C99ScalarReference.boolean true).integer≠0 := by decide
      exact ⟨after,.loopNormal upperGuard upperBody upperInc s mid next ⟨after,.normal⟩
        (C99ScalarReference.boolean true) guardTrue nonzero bodyExec inc rest,invAfter⟩

/- Square loop: descending u with the coverage invariant over (c,1024). -/
def CoverDown (s : State) (gm igm : ArrayPointer) (c : Nat) : Prop :=
  ∀ j, c-1 < j → j < 1024 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)

structure SquareInv (s : State) (gm igm : ArrayPointer) (c : Nat) : Prop where
  tables : Tables s gm igm
  lognSlot : Slot s "logn" 10
  kSlot : Slot s "k" (BitVec.ofNat 32 8)
  counter : USlot s "u" c
  covered : ∀ j, c < j → j < 1024 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)

structure SquareMid (s : State) (gm igm : ArrayPointer) (c : Nat) : Prop where
  tables : Tables s gm igm
  lognSlot : Slot s "logn" 10
  kSlot : Slot s "k" (BitVec.ofNat 32 8)
  counter : USlot s "u" c
  covered : CoverDown s gm igm c

theorem square_body_source (s : State) (gm igm : ArrayPointer) (c : Nat)
    (pos : 1 ≤ c) (bound : c < 512) (inv : SquareInv s gm igm c) :
    ∃ mid, Exec KeygenPublicSource.program [] squareBody s ⟨mid,.normal⟩ ∧ SquareMid mid gm igm c := by
  have t := inv.tables
  obtain ⟨wy,wyRead⟩ := (inv.covered (2*c) (by omega) (by omega)).1
  obtain ⟨wz,wzRead⟩ := (inv.covered (2*c) (by omega) (by omega)).2
  have cap1 := t.gmCapacity
  have cap2 := t.igmCapacity
  set xw : BitVec 32 := BitVec.ofNat 32 wy.toNat
  set zw : BitVec 32 := BitVec.ofNat 32 wz.toNat
  set s1 : State := {s with locals := C99DeclarationCells.declareCells .uint64 ["v".toList] s.locals}
  have dExec : Exec KeygenPublicSource.program [] (.scalar (.declare .u64 ["v".toList]))
      s ⟨s1,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint64
      ["v".toList] s.locals)
  have vCell : s1.locals "v".toList=some (.uint64,none) := by
    show (C99DeclarationCells.declareCells .uint64 ["v".toList] s.locals) "v".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
  have u1 : USlot s1 "u" c := by
    show (C99DeclarationCells.declareCells .uint64 ["v".toList] s.locals) "u".toList=_
    simp [C99DeclarationCells.declareCells,C99ScalarReference.set]
    exact inv.counter
  have vEval : Eval [] s1 (.bin .shl (KeygenPublicTableAtoms.var "u")
      (KeygenPublicTableAtoms.literal 1)) (u64 (2*c)) :=
    PublicGenerateIndex159.word_shl_double s1 c (by omega) u1
  have vExec : Exec KeygenPublicSource.program []
      (.assign "v".toList (.bin .shl (KeygenPublicTableAtoms.var "u") (KeygenPublicTableAtoms.literal 1)))
      s1 ⟨bindValue s1 "v".toList .uint64 (u64 (2*c)),.normal⟩ :=
    .assign "v".toList _ _ .uint64 none (u64 (2*c)) vCell vEval
  set s2 : State := bindValue s1 "v".toList .uint64 (u64 (2*c))
  have v2 : USlot s2 "v" (2*c) := u64_slot_after s1 "v" (2*c) (by omega)
  have u2 : USlot s2 "u" c := keep_u64 s1 "u" "v" .uint64 (u64 (2*c)) c (by decide) u1
  have t2 : Tables s2 gm igm := tables_frame s s2 gm igm t rfl rfl rfl
  have addrGV : Address s2 "gm".toList (CLogic.Expr.var "v".toList) (element gm (2*c)) :=
    address_named s2 "gm" "v" gm (2*c) (by omega) t2.gmBinding v2 (by omega)
  have loadG : Eval [] s2 (.load16 "gm".toList (CLogic.Expr.var "v".toList))
      (C99NarrowReads.unsignedPromotion wy) :=
    load_eval s2 "gm".toList _ gm (2*c) addrGV wy wyRead
  have valG : Eval [] s2
      (KeygenPublicTableAtoms.mont (.load16 "gm".toList (CLogic.Expr.var "v".toList))
        (.load16 "gm".toList (CLogic.Expr.var "v".toList)))
      (.uint32 (rowValue xw xw)) :=
    mont_u32 s2 _ _ (C99NarrowReads.unsignedPromotion wy) (C99NarrowReads.unsignedPromotion wy)
      xw xw loadG loadG (u32_promoted wy) (u32_promoted wy)
  have addrG : Address s2 "gm".toList (CLogic.Expr.var "u".toList) (element gm c) :=
    address_named s2 "gm" "u" gm c (by omega) t2.gmBinding u2 (by omega)
  set hA := Word16Memory158.write s2.heap (element gm c)
    (KeygenPublicWord.narrow (.uint32 (rowValue xw xw)))
  set s3 : State := {s2 with heap := hA}
  have gmExec : Exec KeygenPublicSource.program []
      (.store "gm".toList (CLogic.Expr.var "u".toList) true
        (KeygenPublicTableAtoms.mont (.load16 "gm".toList (CLogic.Expr.var "v".toList))
          (.load16 "gm".toList (CLogic.Expr.var "v".toList))))
      s2 ⟨s3,.normal⟩ :=
    store_source s2 gm igm t2 "gm".toList _ _ true gm (Or.inl rfl) c (by omega) _ addrG valG
  have t3 : Tables s3 gm igm := tables_frame s s3 gm igm t rfl rfl rfl
  have u3 : USlot s3 "u" c := u2
  have v3 : USlot s3 "v" (2*c) := v2
  have addrIV : Address s3 "igm".toList (CLogic.Expr.var "v".toList) (element igm (2*c)) :=
    address_named s3 "igm" "v" igm (2*c) (by omega) t3.igmBinding v3 (by omega)
  have loadI : Eval [] s3 (.load16 "igm".toList (CLogic.Expr.var "v".toList))
      (C99NarrowReads.unsignedPromotion wz) :=
    load_eval s3 "igm".toList _ igm (2*c) addrIV wz
      (Word16Memory158.outside s2.heap (element gm c) (element igm (2*c))
        (KeygenPublicWord.narrow (.uint32 (rowValue xw xw))) wz
        (separate_cross gm igm t.separate c (2*c)) wzRead)
  have valI : Eval [] s3
      (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
        (.load16 "igm".toList (CLogic.Expr.var "v".toList)))
      (.uint32 (rowValue zw zw)) :=
    mont_u32 s3 _ _ (C99NarrowReads.unsignedPromotion wz) (C99NarrowReads.unsignedPromotion wz)
      zw zw loadI loadI (u32_promoted wz) (u32_promoted wz)
  have addrI : Address s3 "igm".toList (CLogic.Expr.var "u".toList) (element igm c) :=
    address_named s3 "igm" "u" igm c (by omega) t3.igmBinding u3 (by omega)
  set hB := Word16Memory158.write s3.heap (element igm c)
    (KeygenPublicWord.narrow (.uint32 (rowValue zw zw)))
  set s4 : State := {s3 with heap := hB}
  have igmExec : Exec KeygenPublicSource.program []
      (.store "igm".toList (CLogic.Expr.var "u".toList) true
        (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
          (.load16 "igm".toList (CLogic.Expr.var "v".toList))))
      s3 ⟨s4,.normal⟩ :=
    store_source s3 gm igm t3 "igm".toList _ _ true igm (Or.inr rfl) c (by omega) _ addrI valI
  have cLast : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.store "igm".toList (CLogic.Expr.var "u".toList) true
          (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
            (.load16 "igm".toList (CLogic.Expr.var "v".toList)))]) s3 ⟨s4,.normal⟩ :=
    chain_step _ [] s3 s4 ⟨s4,.normal⟩ igmExec (.skip s4)
  have cG : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.store "gm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (.load16 "gm".toList (CLogic.Expr.var "v".toList))
              (.load16 "gm".toList (CLogic.Expr.var "v".toList))),
         .store "igm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
              (.load16 "igm".toList (CLogic.Expr.var "v".toList)))]) s2 ⟨s4,.normal⟩ :=
    chain_step _ _ s2 s3 _ gmExec cLast
  have cV : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.assign "v".toList (.bin .shl (KeygenPublicTableAtoms.var "u") (KeygenPublicTableAtoms.literal 1)),
         .store "gm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (.load16 "gm".toList (CLogic.Expr.var "v".toList))
              (.load16 "gm".toList (CLogic.Expr.var "v".toList))),
         .store "igm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
              (.load16 "igm".toList (CLogic.Expr.var "v".toList)))]) s1 ⟨s4,.normal⟩ :=
    chain_step _ _ s1 s2 _ vExec cG
  have bodyExec : Exec KeygenPublicSource.program []
      (KeygenPublicExec.chain
        [.scalar (.declare .u64 ["v".toList]),
         .assign "v".toList (.bin .shl (KeygenPublicTableAtoms.var "u") (KeygenPublicTableAtoms.literal 1)),
         .store "gm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (.load16 "gm".toList (CLogic.Expr.var "v".toList))
              (.load16 "gm".toList (CLogic.Expr.var "v".toList))),
         .store "igm".toList (CLogic.Expr.var "u".toList) true
            (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
              (.load16 "igm".toList (CLogic.Expr.var "v".toList)))]) s ⟨s4,.normal⟩ :=
    chain_step _ _ s s1 _ dExec cV
  set mid : State := C99ArrayReference.restoreScope s s4 ["v".toList] []
  have outer : Exec KeygenPublicSource.program [] squareBody s ⟨mid,.normal⟩ :=
    .scope ["v".toList] [] _ s ⟨s4,.normal⟩ bodyExec
  set wA : BitVec 16 := KeygenPublicWord.narrow (.uint32 (rowValue xw xw))
  set wB : BitVec 16 := KeygenPublicWord.narrow (.uint32 (rowValue zw zw))
  have heapEq : mid.heap=
      Word16Memory158.write (Word16Memory158.write s.heap (element gm c) wA) (element igm c) wB := rfl
  have covered : CoverDown mid gm igm c := by
    intro j lo hi
    by_cases same : j=c
    · rw [same]
      refine ⟨?_,?_⟩
      · rw [heapEq]
        exact written_preserved _ (element igm c) (element gm c) wB
          (separate_cross_right gm igm t.separate c c)
          (written_here s.heap (element gm c) wA (t.gmAllocated c (by omega)) t.gmWidth t.gmWritable)
      · rw [heapEq]
        exact written_here _ (element igm c) wB
          (PublicGenerateTable159.allocated_write _ (element gm c) (element igm c) wA (t.igmAllocated c (by omega)))
          t.igmWidth t.igmWritable
    · refine ⟨?_,?_⟩
      · rw [heapEq]
        exact written_preserved _ (element igm c) (element gm j) wB (separate_cross_right gm igm t.separate c j)
          (written_preserved _ (element gm c) (element gm j) wA
            (separate_elements gm t.gmWidth c j (Ne.symm same))
            (inv.covered j (by omega) (by omega)).1)
      · rw [heapEq]
        exact written_preserved _ (element igm c) (element igm j) wB
          (separate_elements igm t.igmWidth c j (Ne.symm same))
          (written_preserved _ (element gm c) (element igm j) wA (separate_cross gm igm t.separate c j)
            (inv.covered j (by omega) (by omega)).2)
  have midLogn : Slot mid "logn" 10 := by
    show mid.locals "logn".toList=_
    rw [cell_frame squareBody s mid "logn" (by decide) (by decide) outer]
    exact inv.lognSlot
  have midK : Slot mid "k" (BitVec.ofNat 32 8) := by
    show mid.locals "k".toList=_
    rw [cell_frame squareBody s mid "k" (by decide) (by decide) outer]
    exact inv.kSlot
  have midU : USlot mid "u" c := by
    show mid.locals "u".toList=_
    rw [cell_frame squareBody s mid "u" (by decide) (by decide) outer]
    exact inv.counter
  exact ⟨mid,outer,⟨tables_frame s mid gm igm t rfl rfl rfl,midLogn,midK,midU,covered⟩⟩

theorem square_inv_step (mid : State) (gm igm : ArrayPointer) (c : Nat) (pos : 1 ≤ c)
    (bound : c<2^64) (h : SquareMid mid gm igm c) :
    SquareInv (bindValue mid "u".toList .uint64 (u64 (c-1))) gm igm (c-1) := by
  refine ⟨tables_frame mid (bindValue mid "u".toList .uint64 (u64 (c-1))) gm igm h.tables rfl rfl rfl,
    keep_slot mid "logn" "u" .uint64 _ 10 (by decide) h.lognSlot,
    keep_slot mid "k" "u" .uint64 _ (BitVec.ofNat 32 8) (by decide) h.kSlot,
    u64_slot_after mid "u" (c-1) (by omega),?_⟩
  intro j lo hi
  exact h.covered j (by omega) hi

theorem square_guard (s : State) (c : Nat) (bound : c<2^64) (u : USlot s "u" c) :
    Eval [] s squareGuard (C99ScalarReference.boolean (decide (0<c))) :=
  PublicGenerateIndex159.word_guard_gt s c bound u

/- The full square loop: 255 descending iterations from u=255 to 0. -/
theorem square_loop_source (count : Nat) (c : Nat) (s : State) (gm igm : ArrayPointer)
    (bound : c<512) (inv : SquareInv s gm igm c) (finish : c=count) :
    ∃ after, Exec KeygenPublicSource.program [] squareLoop s ⟨after,.normal⟩ ∧
      SquareInv after gm igm 0 := by
  induction count generalizing c s with
  | zero =>
      have same : c=0 := by omega
      subst c
      have guard := square_guard s 0 (by decide) inv.counter
      have zero : (C99ScalarReference.boolean (decide (0<0))).integer=0 := by decide
      exact ⟨s,.loopFalse _ _ _ _ _ guard zero,inv⟩
  | succ count ih =>
      have pos : 1 ≤ c := by omega
      obtain ⟨mid,bodyExec,midFacts⟩ := square_body_source s gm igm c pos bound inv
      have dec : Exec KeygenPublicSource.program [] squareInc mid
          ⟨bindValue mid "u".toList .uint64 (u64 (c-1)),.normal⟩ :=
        update_down_exec mid "u" c pos (by omega) midFacts.counter
      set next : State := bindValue mid "u".toList .uint64 (u64 (c-1))
      have invNext : SquareInv next gm igm (c-1) := by
        show SquareInv (bindValue mid "u".toList .uint64 (u64 (c-1))) gm igm (c-1)
        exact square_inv_step mid gm igm c pos (by omega) midFacts
      obtain ⟨after,rest,invAfter⟩ := ih (c-1) next (by omega) invNext (by omega)
      have pos' : 0 < c := by omega
      have guardTrue : Eval [] s squareGuard (C99ScalarReference.boolean true) := by
        simpa [pos'] using square_guard s c (by omega) inv.counter
      have nonzero : (C99ScalarReference.boolean true).integer≠0 := by decide
      exact ⟨after,.loopNormal squareGuard squareBody squareInc s mid next ⟨after,.normal⟩
        (C99ScalarReference.boolean true) guardTrue nonzero bodyExec dec rest,invAfter⟩

/- Final stores of the generator suffix: gm[0]=gm[1], w=gm[1] and the mq_div
   store at igm[0]. Value-free: only the Written conclusion is exported. -/
theorem finalTail_source (s : State) (gm igm : ArrayPointer) (t : Tables s gm igm)
    (w : s.locals "w".toList=some (.uint32,none))
    (covered : ∀ j, 0 < j → j < 1024 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)) :
    ∃ after, Exec KeygenPublicSource.program [] finalTail s ⟨after,.normal⟩ ∧
      WrittenRange after.heap gm 0 1024 ∧ WrittenRange after.heap igm 0 1024 := by
  obtain ⟨w1,r1⟩ := (covered 1 (by decide) (by decide)).1
  have cap1 := t.gmCapacity
  have cap2 := t.igmCapacity
  have addr1 : Address s "gm".toList (CLogic.Expr.literal .i32 1) (element gm 1) :=
    address_lit s "gm".toList gm 1 (by decide) t.gmBinding (by omega)
  have addr0 : Address s "gm".toList (CLogic.Expr.literal .i32 0) (element gm 0) :=
    address_lit s "gm".toList gm 0 (by decide) t.gmBinding (by omega)
  have load1 : Eval [] s (.load16 "gm".toList (CLogic.Expr.literal .i32 1))
      (C99NarrowReads.unsignedPromotion w1) :=
    load_eval s "gm".toList _ gm 1 addr1 w1 r1
  set w0 : BitVec 16 := KeygenPublicWord.narrow (C99NarrowReads.unsignedPromotion w1)
  set hA := Word16Memory158.write s.heap (element gm 0) w0
  set s1 : State := {s with heap := hA}
  have gmExec : Exec KeygenPublicSource.program []
      (.store "gm".toList (CLogic.Expr.literal .i32 0) false
        (.load16 "gm".toList (CLogic.Expr.literal .i32 1)))
      s ⟨s1,.normal⟩ :=
    store_source s gm igm t "gm".toList _ _ false gm (Or.inl rfl) 0 (by decide) _ addr0 load1
  have addr1b : Address s1 "gm".toList (CLogic.Expr.literal .i32 1) (element gm 1) :=
    address_lit s1 "gm".toList gm 1 (by decide) t.gmBinding (by omega)
  have load1b : Eval [] s1 (.load16 "gm".toList (CLogic.Expr.literal .i32 1))
      (C99NarrowReads.unsignedPromotion w1) :=
    load_eval s1 "gm".toList _ gm 1 addr1b w1
      (Word16Memory158.outside s.heap (element gm 0) (element gm 1) w0 w1
        (separate_elements gm t.gmWidth 0 1 (by decide)) r1)
  have wExec : Exec KeygenPublicSource.program []
      (.assign "w".toList (.load16 "gm".toList (CLogic.Expr.literal .i32 1)))
      s1 ⟨bindValue s1 "w".toList .uint32 (C99NarrowReads.unsignedPromotion w1),.normal⟩ :=
    .assign "w".toList _ _ .uint32 none (C99NarrowReads.unsignedPromotion w1) w load1b
  set s2 : State := bindValue s1 "w".toList .uint32 (C99NarrowReads.unsignedPromotion w1)
  have slotW : Slot s2 "w" (BitVec.ofNat 32 w1.toNat) := load_slot s1 "w" w1
  set ww : BitVec 32 := BitVec.ofNat 32 w1.toNat
  have wEval : Eval [] s2 (KeygenPublicTableAtoms.var "w") (.uint32 ww) :=
    PublicGenerateHead159.eval_var s2 "w" ww slotW
  have qVal : Eval [] s2 (KeygenPublicTableAtoms.literal 18433)
      (C99IntegerReference.convert .int32 18433) :=
    PublicGenerateHead159.eval_lit s2 18433
  set av : BitVec 32 := KeygenModpAddSub.result .add
    (PublicArgumentSource157.word (.u32 ww)) (PublicArgumentSource157.word (.u32 ww))
    (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))
  have addCall : KeygenPublicScalar.Call (KeygenPublicScalar.name .add)
      [.uint32 ww,.uint32 ww,C99IntegerReference.convert .int32 18433] (.uint32 av) :=
    PublicArgumentSource157.add (.u32 ww) (.u32 ww) (.i32 (BitVec.ofInt 32 18433))
  have addEval : Eval [] s2
      (.call3 (KeygenPublicScalar.name .add) (KeygenPublicTableAtoms.var "w")
        (KeygenPublicTableAtoms.var "w") (KeygenPublicTableAtoms.literal 18433))
      (.uint32 av) :=
    KeygenPublicWord.Eval.call3 _ _ _ _ (.uint32 ww) (.uint32 ww)
      (C99IntegerReference.convert .int32 18433) _ wEval wEval qVal addCall
  have rtVal : Eval [] s2 (KeygenPublicTableAtoms.literal 10237)
      (C99IntegerReference.convert .int32 10237) :=
    PublicGenerateHead159.eval_lit s2 10237
  set sv : BitVec 32 := KeygenModpAddSub.result .sub
    (PublicArgumentSource157.word (.u32 av))
    (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 10237)))
    (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))
  have subCall : KeygenPublicScalar.Call (KeygenPublicScalar.name .sub)
      [.uint32 av,C99IntegerReference.convert .int32 10237,C99IntegerReference.convert .int32 18433]
      (.uint32 sv) :=
    PublicArgumentSource157.sub (.u32 av) (.i32 (BitVec.ofInt 32 10237)) (.i32 (BitVec.ofInt 32 18433))
  have subEval : Eval [] s2
      (.call3 (KeygenPublicScalar.name .sub)
        (.call3 (KeygenPublicScalar.name .add) (KeygenPublicTableAtoms.var "w")
          (KeygenPublicTableAtoms.var "w") (KeygenPublicTableAtoms.literal 18433))
        (KeygenPublicTableAtoms.literal 10237) (KeygenPublicTableAtoms.literal 18433))
      (.uint32 sv) :=
    KeygenPublicWord.Eval.call3 _ _ _ _ (.uint32 av)
      (C99IntegerReference.convert .int32 10237) (C99IntegerReference.convert .int32 18433) _
      addEval rtVal qVal subCall
  have r2Val : Eval [] s2 (KeygenPublicTableAtoms.literal 4564)
      (C99IntegerReference.convert .int32 4564) :=
    PublicGenerateHead159.eval_lit s2 4564
  have divCall : KeygenPublicScalar.Call (KeygenPublicScalar.name .divT)
      [C99IntegerReference.convert .int32 4564,.uint32 sv]
      (.uint32 (KeygenPublicDivisionWords.division
        (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 4564)))
        (PublicArgumentSource157.word (.u32 sv)))) :=
    PublicDivisionSource157.source (.i32 (BitVec.ofInt 32 4564)) (.u32 sv)
  have tailEval : Eval [] s2
      (KeygenPublicTableAtoms.divide (KeygenPublicTableAtoms.literal 4564)
        (.call3 (KeygenPublicScalar.name .sub)
          (.call3 (KeygenPublicScalar.name .add) (KeygenPublicTableAtoms.var "w")
            (KeygenPublicTableAtoms.var "w") (KeygenPublicTableAtoms.literal 18433))
          (KeygenPublicTableAtoms.literal 10237) (KeygenPublicTableAtoms.literal 18433)))
      (.uint32 (KeygenPublicDivisionWords.division
        (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 4564)))
        (PublicArgumentSource157.word (.u32 sv)))) :=
    KeygenPublicWord.Eval.call2 _ _ _ _ _ _ r2Val subEval divCall
  have addr0b : Address s2 "igm".toList (CLogic.Expr.literal .i32 0) (element igm 0) :=
    address_lit s2 "igm".toList igm 0 (by decide) t.igmBinding (by omega)
  set wI : BitVec 16 := KeygenPublicWord.narrow (.uint32 (KeygenPublicDivisionWords.division
    (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 4564)))
    (PublicArgumentSource157.word (.u32 sv))))
  set hB := Word16Memory158.write s2.heap (element igm 0) wI
  set s3 : State := {s2 with heap := hB}
  have igmExec : Exec KeygenPublicSource.program []
      (.store "igm".toList (CLogic.Expr.literal .i32 0) true
        (KeygenPublicTableAtoms.divide (KeygenPublicTableAtoms.literal 4564)
          (.call3 (KeygenPublicScalar.name .sub)
            (.call3 (KeygenPublicScalar.name .add) (KeygenPublicTableAtoms.var "w")
              (KeygenPublicTableAtoms.var "w") (KeygenPublicTableAtoms.literal 18433))
            (KeygenPublicTableAtoms.literal 10237) (KeygenPublicTableAtoms.literal 18433))))
      s2 ⟨s3,.normal⟩ :=
    store_source s2 gm igm (tables_frame s s2 gm igm t rfl rfl rfl) "igm".toList _ _ true igm
      (Or.inr rfl) 0 (by decide) _ addr0b tailEval
  have igmRest : Exec KeygenPublicSource.program [] (.seq _ .skip) s2 ⟨s3,.normal⟩ :=
    .seqNormal _ _ s2 s3 ⟨s3,.normal⟩ igmExec (.skip s3)
  have wRest : Exec KeygenPublicSource.program [] (.seq _ (.seq _ .skip)) s1 ⟨s3,.normal⟩ :=
    .seqNormal _ _ s1 s2 ⟨s3,.normal⟩ wExec igmRest
  have full : Exec KeygenPublicSource.program [] finalTail s ⟨s3,.normal⟩ :=
    .seqNormal _ _ s s1 ⟨s3,.normal⟩ gmExec wRest
  have heapEq : s3.heap=
      Word16Memory158.write (Word16Memory158.write s.heap (element gm 0) w0) (element igm 0) wI := rfl
  have gmRange : WrittenRange s3.heap gm 0 1024 := by
    intro j lo hi
    by_cases zero : j=0
    · subst zero
      rw [heapEq]
      exact written_preserved _ (element igm 0) (element gm 0) wI
        (separate_cross_right gm igm t.separate 0 0)
        (written_here s.heap (element gm 0) w0 (t.gmAllocated 0 (by decide)) t.gmWidth t.gmWritable)
    · rw [heapEq]
      exact written_preserved _ (element igm 0) (element gm j) wI
        (separate_cross_right gm igm t.separate 0 j)
        (written_preserved _ (element gm 0) (element gm j) w0
          (separate_elements gm t.gmWidth 0 j (Ne.symm zero))
          (covered j (by omega) (by omega)).1)
  have igmRange : WrittenRange s3.heap igm 0 1024 := by
    intro j lo hi
    by_cases zero : j=0
    · subst zero
      rw [heapEq]
      exact written_here _ (element igm 0) wI
        (PublicGenerateTable159.allocated_write _ (element gm 0) (element igm 0) w0 (t.igmAllocated 0 (by decide)))
        t.igmWidth t.igmWritable
    · rw [heapEq]
      exact written_preserved _ (element igm 0) (element igm j) wI
        (separate_elements igm t.igmWidth 0 j (Ne.symm zero))
        (written_preserved _ (element gm 0) (element igm j) w0
          (separate_cross gm igm t.separate 0 j)
          (covered j (by omega) (by omega)).2)
  exact ⟨s3,full,gmRange,igmRange⟩

/- afterRows composition: kSet, u2Init, the upper loop, u3Init, the square
   loop and the final stores hand over WrittenRange 0 1024 on both arrays. -/
structure AfterEntry (s : State) (gm igm : ArrayPointer) : Prop where
  tables : Tables s gm igm
  lognSlot : Slot s "logn" 10
  kCell : ∃ old, s.locals "k".toList=some (.uint32,old)
  uCell : ∃ old, s.locals "u".toList=some (.uint64,old)
  wCell : s.locals "w".toList=some (.uint32,none)
  coveredTop : ∀ j, 512 ≤ j → j < 1024 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)

theorem kSet_exec (s : State) (logn : Slot s "logn" 10) (old : Option Value)
    (kk : s.locals "k".toList=some (.uint32,old)) :
    Exec KeygenPublicSource.program [] kSet s
      ⟨bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 8)),.normal⟩ ∧
      Slot (bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 8))) "k" (BitVec.ofNat 32 8) := by
  have sub : C99IntegerReference.ArithmeticExec .minus (.uint32 (BitVec.ofNat 32 10))
      (C99IntegerReference.convert .int32 2) (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 8)) := by
    have raw := C99IntegerReference.ArithmeticExec.step .minus
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))
      (C99IntegerReference.convert .int32 2) .uint32 rfl
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 2))
      (C99CountedWords.convert_self (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))).symm rfl
      (by intro impossible; cases impossible)
    change C99IntegerReference.ArithmeticExec .minus
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))
      (C99IntegerReference.convert .int32 2)
      (C99IntegerReference.convert .uint32
        ((C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10)).integer-
          (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 2)).integer)) at raw
    rw [PublicGenerateIndex159.u32_integer 10 (by decide),
      PublicGenerateIndex159.u32_integer 2 (by decide)] at raw
    have diff : ((10:Nat):Int)-((2:Nat):Int)=(((8:Nat)):Int) := by omega
    rw [diff] at raw
    exact raw
  have eval : Eval [] s (.bin .sub (KeygenPublicTableAtoms.var "logn")
      (KeygenPublicTableAtoms.literal 2)) (.uint32 (BitVec.ofNat 32 8)) :=
    KeygenPublicWord.Eval.bin .sub _ _
      (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 10))
      (C99IntegerReference.convert .int32 2) _
      (PublicGenerateHead159.eval_var s "logn" 10 logn) (PublicGenerateHead159.eval_lit s 2) sub
  refine ⟨?_,?_⟩
  · exact .assign "k".toList _ _ .uint32 old (.uint32 (BitVec.ofNat 32 8)) kk eval
  · show (C99ScalarReference.set s.locals "k".toList
      (C99IntegerReference.Ty.uint32,
        some (C99IntegerReference.convert .uint32
          (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 8)).integer))) "k".toList=_
    simp only [C99ScalarReference.set,ite_true]
    rfl

theorem u2Init_exec (s : State) (k : Slot s "k" (BitVec.ofNat 32 8))
    (old : Option Value) (uu : s.locals "u".toList=some (.uint64,old)) :
    Exec KeygenPublicSource.program [] u2Init s
      ⟨bindValue s "u".toList .uint64 (u64 256),.normal⟩ ∧
      USlot (bindValue s "u".toList .uint64 (u64 256)) "u" 256 := by
  refine ⟨?_,u64_slot_after s "u" 256 (by decide)⟩
  show Exec KeygenPublicSource.program [] u2Init s
    ⟨bindValue s "u".toList .uint64 (u64 (2^8)),.normal⟩
  exact .assign "u".toList _ _ .uint64 old (u64 (2^8)) uu
    (PublicGenerateIndex159.word_shl_base s 8 (by decide) k)

theorem u3Init_exec (s : State) (k : Slot s "k" (BitVec.ofNat 32 8))
    (old : Option Value) (uu : s.locals "u".toList=some (.uint64,old)) :
    Exec KeygenPublicSource.program [] u3Init s
      ⟨bindValue s "u".toList .uint64 (u64 255),.normal⟩ ∧
      USlot (bindValue s "u".toList .uint64 (u64 255)) "u" 255 := by
  refine ⟨?_,u64_slot_after s "u" 255 (by decide)⟩
  show Exec KeygenPublicSource.program [] u3Init s
    ⟨bindValue s "u".toList .uint64 (u64 (2^8-1)),.normal⟩
  exact .assign "u".toList _ _ .uint64 old (u64 (2^8-1)) uu
    (PublicGenerateIndex159.word_shl_sub_one s 8 (by decide) (by decide) (by decide) k)

theorem afterRows_source (s : State) (gm igm : ArrayPointer) (entry : AfterEntry s gm igm) :
    ∃ after, Exec KeygenPublicSource.program [] KeygenPublicTableRows.afterRows s ⟨after,.normal⟩ ∧
      WrittenRange after.heap gm 0 1024 ∧ WrittenRange after.heap igm 0 1024 := by
  rw [afterRows_shape]
  obtain ⟨oldK,kk⟩ := entry.kCell
  obtain ⟨oldU,uu⟩ := entry.uCell
  set s1 : State := bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 8))
  have kFacts := kSet_exec s entry.lognSlot oldK kk
  have kExec : Exec KeygenPublicSource.program [] kSet s ⟨s1,.normal⟩ := by
    show Exec KeygenPublicSource.program [] kSet s
      ⟨bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 8)),.normal⟩
    exact kFacts.1
  have kSlot1 : Slot s1 "k" (BitVec.ofNat 32 8) := by
    show Slot (bindValue s "k".toList .uint32 (.uint32 (BitVec.ofNat 32 8))) "k" (BitVec.ofNat 32 8)
    exact kFacts.2
  have uCell1 : ∃ old, s1.locals "u".toList=some (.uint64,old) :=
    ⟨oldU,(bind_keep s .uint32 (.uint32 (BitVec.ofNat 32 8)) "k" "u" (by decide)).trans uu⟩
  have logn1 : Slot s1 "logn" 10 :=
    (bind_keep s .uint32 (.uint32 (BitVec.ofNat 32 8)) "k" "logn" (by decide)).trans entry.lognSlot
  have w1 : s1.locals "w".toList=some (.uint32,none) :=
    (bind_keep s .uint32 (.uint32 (BitVec.ofNat 32 8)) "k" "w" (by decide)).trans entry.wCell
  have top1 : ∀ j, 512 ≤ j → j < 1024 → Written s1.heap (element gm j) ∧ Written s1.heap (element igm j) :=
    entry.coveredTop
  obtain ⟨oldU1,u1c⟩ := uCell1
  set s2 : State := bindValue s1 "u".toList .uint64 (u64 256)
  have uFacts := u2Init_exec s1 kSlot1 oldU1 u1c
  have uExec2 : Exec KeygenPublicSource.program [] u2Init s1 ⟨s2,.normal⟩ := by
    show Exec KeygenPublicSource.program [] u2Init s1
      ⟨bindValue s1 "u".toList .uint64 (u64 256),.normal⟩
    exact uFacts.1
  have uSlot2 : USlot s2 "u" 256 := by
    show USlot (bindValue s1 "u".toList .uint64 (u64 256)) "u" 256
    exact uFacts.2
  have kSlot2 : Slot s2 "k" (BitVec.ofNat 32 8) :=
    (bind_keep s1 .uint64 (u64 256) "u" "k" (by decide)).trans kSlot1
  have logn2 : Slot s2 "logn" 10 :=
    (bind_keep s1 .uint64 (u64 256) "u" "logn" (by decide)).trans logn1
  have w2 : s2.locals "w".toList=some (.uint32,none) :=
    (bind_keep s1 .uint64 (u64 256) "u" "w" (by decide)).trans w1
  have top2 : ∀ j, 512 ≤ j → j < 1024 → Written s2.heap (element gm j) ∧ Written s2.heap (element igm j) :=
    top1
  have inv2 : UpperInv s2 gm igm 256 := by
    refine ⟨tables_frame s1 s2 gm igm (tables_frame s s1 gm igm entry.tables rfl rfl rfl) rfl rfl rfl,
      logn2,kSlot2,uSlot2,?_,top2⟩
    intro j lo hi
    omega
  obtain ⟨s3,loopExec,inv3⟩ := upper_loop_source 256 256 s2 gm igm (by decide) inv2 (by decide)
  have uCell3 : ∃ old, s3.locals "u".toList=some (.uint64,old) := ⟨some (u64 512),inv3.counter⟩
  have w3 : s3.locals "w".toList=some (.uint32,none) :=
    (cell_frame upperLoop s2 s3 "w" (by decide) (by decide) loopExec).trans w2
  obtain ⟨oldU3,u3c⟩ := uCell3
  set s4 : State := bindValue s3 "u".toList .uint64 (u64 255)
  have uFacts3 := u3Init_exec s3 inv3.kSlot oldU3 u3c
  have uExec4 : Exec KeygenPublicSource.program [] u3Init s3 ⟨s4,.normal⟩ := by
    show Exec KeygenPublicSource.program [] u3Init s3
      ⟨bindValue s3 "u".toList .uint64 (u64 255),.normal⟩
    exact uFacts3.1
  have uSlot4 : USlot s4 "u" 255 := by
    show USlot (bindValue s3 "u".toList .uint64 (u64 255)) "u" 255
    exact uFacts3.2
  have logn4 : Slot s4 "logn" 10 :=
    (bind_keep s3 .uint64 (u64 255) "u" "logn" (by decide)).trans inv3.lognSlot
  have kSlot4 : Slot s4 "k" (BitVec.ofNat 32 8) :=
    (bind_keep s3 .uint64 (u64 255) "u" "k" (by decide)).trans inv3.kSlot
  have w4 : s4.locals "w".toList=some (.uint32,none) :=
    (bind_keep s3 .uint64 (u64 255) "u" "w" (by decide)).trans w3
  have inv4 : SquareInv s4 gm igm 255 := by
    refine ⟨tables_frame s3 s4 gm igm inv3.tables rfl rfl rfl,logn4,kSlot4,uSlot4,?_⟩
    intro j lo hi
    by_cases top : 512 ≤ j
    · exact inv3.coveredTop j top hi
    · exact inv3.covered j (by omega) (by omega)
  obtain ⟨s5,loopExec5,inv5⟩ := square_loop_source 255 255 s4 gm igm (by decide) inv4 rfl
  have w5 : s5.locals "w".toList=some (.uint32,none) :=
    (cell_frame squareLoop s4 s5 "w" (by decide) (by decide) loopExec5).trans w4
  obtain ⟨after,tailExec,gmRange,igmRange⟩ :=
    finalTail_source s5 gm igm inv5.tables w5 inv5.covered
  have cTail : Exec KeygenPublicSource.program []
      (.seq (.seq u3Init squareLoop) finalTail) s3 ⟨after,.normal⟩ :=
    .seqNormal (.seq u3Init squareLoop) finalTail s3 s5 ⟨after,.normal⟩
      (.seqNormal u3Init squareLoop s3 s4 ⟨s5,.normal⟩ uExec4 loopExec5) tailExec
  have cUpper : Exec KeygenPublicSource.program []
      (.seq (.seq u2Init upperLoop) (.seq (.seq u3Init squareLoop) finalTail)) s1 ⟨after,.normal⟩ :=
    .seqNormal (.seq u2Init upperLoop) (.seq (.seq u3Init squareLoop) finalTail) s1 s3 ⟨after,.normal⟩
      (.seqNormal u2Init upperLoop s1 s2 ⟨s3,.normal⟩ uExec2 loopExec) cTail
  exact ⟨after,.seqNormal kSet _ s s1 ⟨after,.normal⟩ kExec cUpper,gmRange,igmRange⟩

end FT1536.Source3.PublicGenerateUpper159
