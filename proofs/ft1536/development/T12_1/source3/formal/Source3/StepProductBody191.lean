import Source3.MakeFgProductShape191
import Source3.StepCopyBody190

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- One original pair-product iteration of the make_fg_step first-prime
   tail and its two-clause increment: the two source loads of the copied
   t1 image, the nested Montgomery product written through the walked x
   pointer, and the exact v/x updates. Values are only the executed
   operations; no image law or transform property is assumed. -/
namespace FT1536.Source3.StepProductBody191
open C99ArrayReference (State Name Pointer bindPointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open KeygenMakeFgSource (Exec skip)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open C99NatWord141 (word)
open MakeFgProductShape191 (at0 productBody productInc productIncCode)
open StepCopyBody190 (addr elem)

def value (w0 w1 r2 p p0i : BitVec 32) : BitVec 32 :=
  KeygenModpWord.montgomery (KeygenModpWord.montgomery w0 w1 p p0i) r2 p p0i

def output (s : State) (fd : ArrayPointer) (u0 tlen v : Nat) (z : BitVec 32) : State :=
  {s with heap := Word32Memory176.write s.heap (addr fd u0 v tlen) z}

def next (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) : State :=
  bindPointer (FftLocalCells140.put s "v".toList (word (i+1))) "x".toList (addr fd u0 (i+1) tlen)

/- Scalar evaluation of the original source index (v << 1) + k. -/
theorem twice_value (s : State) (v : Nat) (bound : v<2^64) (counter : Cell s "v".toList v) :
    C99ArrayReference.scalar s MakeFgProductShape191.twice (KeygenNttLoopSupport.u64 (2*v)) :=
  .shift .left _ _ _ _ _ (C99LoopScalar141.read s "v".toList v counter) (.literal .int32 1)
    (PublicGenerateIndex159.shl_one v bound (.int32 1) rfl)

theorem add_zero (a : Nat) (bound : a<2^64) :
    C99IntegerReference.ArithmeticExec .plus (.uint64 (word a)) (.int32 0) (.uint64 (word (a+0))) := by
  have raw := C99IntegerReference.ArithmeticExec.step .plus (.uint64 (word a)) (.int32 0) .uint64 rfl
    (.uint64 (word a)) (.uint64 0)
    (C99CountedWords.convert_self (.uint64 (word a))).symm rfl (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .plus (.uint64 (word a)) (.int32 0)
    (.uint64 (BitVec.ofInt 64 ((C99IntegerReference.Value.uint64 (word a)).integer+0))) at raw
  rw [C99NatWord141.integer a bound] at raw
  have sum : (a : Int)+0=((a+0 : Nat) : Int) := by omega
  rw [sum,BitVec.ofInt_natCast] at raw
  exact raw

theorem index0_value (s : State) (v : Nat) (bound : v<2^64) (wide : 2*v+1<2^64)
    (counter : Cell s "v".toList v) :
    C99ArrayReference.scalar s (MakeFgProductShape191.index 0) (KeygenNttLoopSupport.u64 (2*v+0)) :=
  .arithmetic .plus _ _ _ _ _ (twice_value s v bound counter) (.literal .int32 0)
    (add_zero (2*v) (by omega))

theorem index1_value (s : State) (v : Nat) (bound : v<2^64) (wide : 2*v+1<2^64)
    (counter : Cell s "v".toList v) :
    C99ArrayReference.scalar s (MakeFgProductShape191.index 1) (KeygenNttLoopSupport.u64 (2*v+1)) :=
  .arithmetic .plus _ _ _ _ _ (twice_value s v bound counter) (.literal .int32 1)
    (C99NatWord141.add_one (2*v) (by omega))

/- The declared block locals of one product iteration and the intermediate
   states of its body; the scope restores both locals at exit. -/
def declared (s : State) : State :=
  C99DeclarationStatements.effect .u32 ["w0".toList,"w1".toList] s

def w0s (s : State) (w0 : BitVec 32) : State := ModularAtoms178.set (declared s) "w0" w0
def w1s (s : State) (w0 w1 : BitVec 32) : State := ModularAtoms178.set (w0s s w0) "w1" w1

def written (s : State) (fd : ArrayPointer) (u0 tlen v : Nat) (w0 w1 z : BitVec 32) : State :=
  {w1s s w0 w1 with heap := Word32Memory176.write (w1s s w0 w1).heap (addr fd u0 v tlen) z}

def after (s : State) (fd : ArrayPointer) (u0 tlen v : Nat) (w0 w1 z : BitVec 32) : State :=
  C99ArrayReference.restoreScope s (written s fd u0 tlen v w0 w1 z) ["w0".toList,"w1".toList] []

theorem put32_outside (s : State) (target : Name) (w : BitVec 32) (other : Name)
    (different : other≠target) :
    (C99ArrayReference.bindValue s target .uint32 (.uint32 w)).locals other=s.locals other := by
  simp only [C99ArrayReference.bindValue,C99ScalarReference.set,different,ite_false]

theorem cells_outside (ty : C99IntegerReference.Ty) : ∀ (names : List Name)
    (env : C99ScalarReference.Env) (name : Name), name∉names →
    C99DeclarationCells.declareCells ty names env name=env name
  | [],_,_ => by
    intro _
    rfl
  | head::tail,env,name => by
    intro absent
    have different : name≠head := by
      intro same
      apply absent
      rw [same]
      exact List.mem_cons_self
    have rest : name∉tail := by
      intro hit
      apply absent
      exact List.mem_cons_of_mem head hit
    have step : C99DeclarationCells.declareCells ty (head::tail) env=
        C99DeclarationCells.declareCells ty tail (C99ScalarReference.set env head (ty,none)) := rfl
    rw [step]
    exact (cells_outside ty tail (C99ScalarReference.set env head (ty,none)) name rest).trans
      (by simp only [C99ScalarReference.set,different,ite_false])

theorem block_outside (name : Name) (first : name≠"w0".toList) (second : name≠"w1".toList) :
    name∉["w0".toList,"w1".toList] := by
  intro hit
  simp only [List.mem_cons,List.not_mem_nil,or_false] at hit
  cases hit with
  | inl left => exact first left
  | inr right => exact second right

theorem block_absent (name : Name) (first : name≠"w0".toList) (second : name≠"w1".toList) :
    ¬ ["w0".toList,"w1".toList].contains name=true :=
  fun hit => block_outside name first second (List.contains_iff_mem.mp hit)

theorem declared_outside (s : State) (name : Name) (first : name≠"w0".toList)
    (second : name≠"w1".toList) : (declared s).locals name=s.locals name :=
  cells_outside .uint32 ["w0".toList,"w1".toList] s.locals name (block_outside name first second)

theorem after_locals (s : State) (fd : ArrayPointer) (u0 tlen v : Nat) (w0 w1 z : BitVec 32) :
    (after s fd u0 tlen v w0 w1 z).locals=s.locals := by
  funext name
  by_cases first : name="w0".toList
  · subst first
    rfl
  · by_cases second : name="w1".toList
    · subst second
      rfl
    · show C99ScalarReference.restore s.locals (written s fd u0 tlen v w0 w1 z).locals
        ["w0".toList,"w1".toList] name=s.locals name
      have kept : ¬ ["w0".toList,"w1".toList].contains name=true := block_absent name first second
      simp only [C99ScalarReference.restore,kept]
      exact ((put32_outside _ "w1".toList w1 name second).trans
        ((put32_outside _ "w0".toList w0 name first).trans (declared_outside s name first second)))

theorem after_arrays (s : State) (fd : ArrayPointer) (u0 tlen v : Nat) (w0 w1 z : BitVec 32) :
    (after s fd u0 tlen v w0 w1 z).arrays=s.arrays := by
  funext name
  rfl

theorem state_ext {a b : State} (heap : a.heap=b.heap) (locals : a.locals=b.locals)
    (arrays : a.arrays=b.arrays) (globals : a.globals=b.globals) (tables : a.tables=b.tables) : a=b := by
  cases a with
  | mk aheap alocals aarrays aglobals atables =>
    cases b with
    | mk bheap blocals barrays bglobals btables =>
      have first : aheap=bheap := heap
      have second : alocals=blocals := locals
      have third : aarrays=barrays := arrays
      have fourth : aglobals=bglobals := globals
      have fifth : atables=btables := tables
      subst first
      subst second
      subst third
      subst fourth
      subst fifth
      rfl

theorem body_state (s : State) (fd : ArrayPointer) (u0 tlen v : Nat) (w0 w1 z : BitVec 32) :
    after s fd u0 tlen v w0 w1 z=output s fd u0 tlen v z :=
  state_ext rfl (after_locals s fd u0 tlen v w0 w1 z) (after_arrays s fd u0 tlen v w0 w1 z) rfl rfl

theorem t1_address (s : State) (t1 : ArrayPointer) (e : CLogic.Expr) (i : Nat) (bound : i<2^64)
    (capacity : t1.index+i≤t1.count) (binding : s.arrays "t1".toList=some t1)
    (indexed : C99ArrayReference.scalar s e (KeygenNttLoopSupport.u64 i)) :
    Pointer s "t1".toList e (elem t1 i) := by
  refine .add _ _ t1 _ (KeygenNttLoopSupport.u64 i) binding indexed ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer i bound]; omega
  · rw [KeygenNttLoopSupport.u64_toNat i bound]
    exact .within t1 i capacity

theorem x_address (s : State) (fd : ArrayPointer) (u0 tlen v : Nat)
    (binding : s.arrays "x".toList=some (addr fd u0 v tlen)) (capacity : fd.index+u0+v*tlen≤fd.count) :
    Pointer s "x".toList at0 (addr fd u0 v tlen) :=
  StepCopyBody190.zero_pointer s "x".toList (addr fd u0 v tlen) binding
    (by simpa [StepCopyBody190.addr] using capacity)

theorem w0_keep (s : State) (w0 w1 : BitVec 32) : Slot (w1s s w0 w1) "w0" w0 :=
  (ModularAtoms178.outside (w0s s w0) "w1" "w0" w1 (by decide)).trans
    (ModularAtoms178.slot (declared s) "w0" w0)

theorem w1_keep (s : State) (w0 w1 : BitVec 32) : Slot (w1s s w0 w1) "w1" w1 :=
  ModularAtoms178.slot (w0s s w0) "w1" w1

theorem slot_keep (s : State) (w0 w1 : BitVec 32) (name : String) (v : BitVec 32)
    (first : name.toList≠"w0".toList) (second : name.toList≠"w1".toList) (cell : Slot s name v) :
    Slot (w1s s w0 w1) name v :=
  ((ModularAtoms178.outside (w0s s w0) "w1" name w1 second).trans
    ((ModularAtoms178.outside (declared s) "w0" name w0 first).trans
      ((declared_outside s name.toList first second).trans cell)))

theorem body_source (s : State) (fd t1 : ArrayPointer) (u0 tlen v : Nat) (p p0i r2 : BitVec 32)
    (w0 w1 : BitVec 32) (bound : v<2^64) (wide : 2*v+1<2^64)
    (fdCapacity : fd.index+u0+v*tlen<fd.count)
    (t1Capacity : t1.index+(2*v+1)<t1.count) (fdWidth : fd.elementBytes=4)
    (fdWritable : s.heap.writable fd.block=true)
    (t1Binding : s.arrays "t1".toList=some t1) (xBinding : s.arrays "x".toList=some (addr fd u0 v tlen))
    (counter : Cell s "v".toList v) (pc : Slot s "p" p) (ic : Slot s "p0i" p0i) (rc : Slot s "R2" r2)
    (r0 : Load32 s.heap (elem t1 (2*v)) w0) (r1 : Load32 s.heap (elem t1 (2*v+1)) w1)
    (fdAllocated : Allocated s.heap (addr fd u0 v tlen)) :
    Exec productBody s ⟨output s fd u0 tlen v (value w0 w1 r2 p p0i),.normal⟩ := by
  have declareRun : Exec MakeFgProductShape191.declareLocals s ⟨declared s,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.base _ _ _
      (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
        ["w0".toList,"w1".toList] s)))
  have counterD : Cell (declared s) "v".toList v :=
    (declared_outside s "v".toList (by decide) (by decide)).trans counter
  have firstAddress : Pointer (declared s) "t1".toList (MakeFgProductShape191.index 0) (elem t1 (2*v)) :=
    t1_address (declared s) t1 (MakeFgProductShape191.index 0) (2*v+0) (by omega) (by omega)
      t1Binding (index0_value (declared s) v bound wide counterD)
  have w0Run : Exec MakeFgProductShape191.w0Assign (declared s) ⟨w0s s w0,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign (declared s) "w0" none
      (MakeFgProductShape191.readT1 0) w0 rfl
      (.load32 "t1".toList (MakeFgProductShape191.index 0) (elem t1 (2*v)) w0 firstAddress r0)))
  have counterW0 : Cell (w0s s w0) "v".toList v :=
    (ModularAtoms178.outside (declared s) "w0" "v" w0 (by decide)).trans counterD
  have secondAddress : Pointer (w0s s w0) "t1".toList (MakeFgProductShape191.index 1) (elem t1 (2*v+1)) :=
    t1_address (w0s s w0) t1 (MakeFgProductShape191.index 1) (2*v+1) (by omega) (by omega)
      t1Binding (index1_value (w0s s w0) v bound wide counterW0)
  have w1Run : Exec MakeFgProductShape191.w1Assign (w0s s w0) ⟨w1s s w0 w1,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign (w0s s w0) "w1" none
      (MakeFgProductShape191.readT1 1) w1 rfl
      (.load32 "t1".toList (MakeFgProductShape191.index 1) (elem t1 (2*v+1)) w1 secondAddress r1)))
  have valueRun : C99ModularReference.Eval (w1s s w0 w1) MakeFgProductShape191.productExpr
      (.uint32 (value w0 w1 r2 p p0i)) :=
    ModularAtoms178.mont (w1s s w0 w1) _ _
      (KeygenModpWord.montgomery w0 w1 p p0i) r2 p p0i
      (ModularAtoms178.mont (w1s s w0 w1) _ _ w0 w1 p p0i
        (ModularAtoms178.cell (w1s s w0 w1) "w0" w0 (w0_keep s w0 w1))
        (ModularAtoms178.cell (w1s s w0 w1) "w1" w1 (w1_keep s w0 w1))
        (slot_keep s w0 w1 "p" p (by decide) (by decide) pc)
        (slot_keep s w0 w1 "p0i" p0i (by decide) (by decide) ic))
      (ModularAtoms178.cell (w1s s w0 w1) "R2" r2
        (slot_keep s w0 w1 "R2" r2 (by decide) (by decide) rc))
      (slot_keep s w0 w1 "p" p (by decide) (by decide) pc)
      (slot_keep s w0 w1 "p0i" p0i (by decide) (by decide) ic)
  have stored : C99MemoryReference.Store32 (w1s s w0 w1).heap (addr fd u0 v tlen)
      (BitVec.ofInt 32 (C99IntegerReference.Value.integer (.uint32 (value w0 w1 r2 p p0i))))
      (Word32Memory176.write (w1s s w0 w1).heap (addr fd u0 v tlen) (value w0 w1 r2 p p0i)) := by
    simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
      BitVec.setWidth_eq] using
      Word32Memory176.source (w1s s w0 w1).heap (addr fd u0 v tlen) (value w0 w1 r2 p p0i)
        fdAllocated fdWidth fdWritable
  have storeRun : C99ModularReference.Exec (.store32 "x".toList at0 MakeFgProductShape191.productExpr)
      (w1s s w0 w1) ⟨StepProductBody191.written s fd u0 tlen v w0 w1 (value w0 w1 r2 p p0i),.normal⟩ :=
    .store32 "x".toList at0 MakeFgProductShape191.productExpr (w1s s w0 w1)
      (Word32Memory176.write (w1s s w0 w1).heap (addr fd u0 v tlen) (value w0 w1 r2 p p0i))
      (addr fd u0 v tlen) (.uint32 (value w0 w1 r2 p p0i))
      (x_address (w1s s w0 w1) fd u0 tlen v xBinding (by omega)) valueRun stored
  have storeLevel : Exec MakeFgProductShape191.storeX (w1s s w0 w1)
      ⟨StepProductBody191.written s fd u0 tlen v w0 w1 (value w0 w1 r2 p p0i),.normal⟩ :=
    .level _ _ _ (.modular _ _ _ storeRun)
  have inner : Exec MakeFgProductShape191.productInner s
      ⟨StepProductBody191.written s fd u0 tlen v w0 w1 (value w0 w1 r2 p p0i),.normal⟩ :=
    .seqNormal _ _ s (declared s) _ declareRun
      (.seqNormal _ _ (declared s) (w0s s w0) _ w0Run
        (.seqNormal _ _ (w0s s w0) (w1s s w0 w1) _ w1Run
          (.seqNormal _ _ (w1s s w0 w1) _ _ storeLevel
            (.level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip _)))))))
  have bodyScope : Exec productBody s
      ⟨after s fd u0 tlen v w0 w1 (value w0 w1 r2 p p0i),.normal⟩ :=
    .scope ["w0".toList,"w1".toList] [] _ s
      ⟨StepProductBody191.written s fd u0 tlen v w0 w1 (value w0 w1 r2 p p0i),.normal⟩ inner
  simpa only [StepProductBody191.body_state] using bodyScope

theorem inc_source (s : State) (fd : ArrayPointer) (u0 tlen i : Nat) (bound : i<2^64)
    (tlenBound : tlen<2^64) (fdCapacity : fd.index+u0+i*tlen+tlen≤fd.count)
    (counter : Cell s "v".toList i) (tlenCell : Cell s "tlen".toList tlen)
    (xBinding : s.arrays "x".toList=some (addr fd u0 i tlen)) :
    Exec productInc s ⟨next s fd u0 tlen i,.normal⟩ := by
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "v".toList .add (MakeFgProductShape191.num 1)))
      s (FftLocalCells140.put s "v".toList (word (i+1))) := by
    cases C99LoopScalar141.increment (fun _ => none) s "v".toList i bound counter with
    | base _ _ _ source => exact source
  set mid : State := FftLocalCells140.put s "v".toList (word (i+1)) with midEq
  have xAfter : mid.arrays "x".toList=some (addr fd u0 i tlen) := by
    rw [midEq]; exact xBinding
  have tlenAfter : Cell mid "tlen".toList tlen := by
    rw [midEq]
    exact (FftLocalCells140.outside s "v".toList "tlen".toList (word (i+1)) (by decide)).trans tlenCell
  have walked : Pointer mid "x".toList MakeFgProductShape191.varTlen (addr fd u0 (i+1) tlen) := by
    refine .add _ _ (addr fd u0 i tlen) _ (.uint64 (word tlen))
      xAfter (.variable _ _ _ tlenAfter) ?_ ?_
    · rw [C99NatWord141.integer tlen tlenBound]; omega
    · rw [C99NatWord141.integer tlen tlenBound]
      rw [← StepCopyBody190.addr_step fd u0 tlen i]
      refine .within (addr fd u0 i tlen) tlen ?_
      change fd.index + u0 + i * tlen + tlen ≤ fd.count
      omega
  have bind : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "x".toList "x".toList MakeFgProductShape191.varTlen) mid
      (bindPointer mid "x".toList (addr fd u0 (i+1) tlen)) :=
    .bindPtr _ _ _ _ _ walked
  have first : C99ModularReference.Exec
      (.base (.scalar (.update "v".toList .add (MakeFgProductShape191.num 1)))) s ⟨mid,.normal⟩ := by
    rw [midEq]
    exact .base _ _ _ update
  have second : C99ModularReference.Exec
      (.base (.bindPtr "x".toList "x".toList MakeFgProductShape191.varTlen)) mid
      ⟨next s fd u0 tlen i,.normal⟩ := by
    refine .base _ _ _ ?_
    rw [midEq]
    exact bind
  have combined : C99ModularReference.Exec productIncCode s ⟨next s fd u0 tlen i,.normal⟩ :=
    .seqNormal _ _ _ _ _ first second
  exact .level _ _ _ (.modular _ _ _ combined)

end FT1536.Source3.StepProductBody191
