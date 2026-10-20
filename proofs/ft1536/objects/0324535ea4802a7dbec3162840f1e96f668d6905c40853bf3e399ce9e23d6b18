import Source3.KeygenPublicUpperFrames

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Whole-loop composition for the two upward bodies: the SAME afterRows
   execution derives k=8, u=256, every cube iteration to u=512, u=255 and
   every square iteration to u=0, filling both tables at 1..1023. The child
   cell facts at 2*i come from the preceding iterations of the same run.
   The remaining `finish` statement stays an actual execution; no table
   image, transform result or exceptional index is assumed here. -/
namespace FT1536.Source3.KeygenPublicUpperLoops
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer Memory)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableControl (seq_inv supported writes)
open KeygenPublicTableStore (Pointers Separate)
open KeygenPublicUpperBody (PairCell RowUpdate)
open KeygenPublicUpperFrames (UpperFrame)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicRoots (root)
open KeygenMkgm3Indices (tableExponent)

def PairCells (gm igm : ArrayPointer) (heap : Memory) (lo : Nat) : Prop :=
  ∀ i, lo ≤ i → i<1024 → PairCell heap gm igm i

structure Common (gm igm : ArrayPointer) (s : State) : Prop where
  pointers : Pointers s gm igm
  logn : Slot s "logn" 10
  key : Slot s "k" 8
  w : s.locals "w".toList=some (.uint32,none)

theorem common_same (gm igm : ArrayPointer) (s t : State)
    (locals : t.locals=s.locals) (arrays : t.arrays=s.arrays) (h : Common gm igm s) : Common gm igm t := by
  refine ⟨?_,?_,?_,?_⟩
  · show t.arrays "gm".toList=some gm ∧ t.arrays "igm".toList=some igm
    rw [arrays]
    exact h.pointers
  · show t.locals "logn".toList=some (.uint32,some (.uint32 10))
    rw [locals]
    exact h.logn
  · show t.locals "k".toList=some (.uint32,some (.uint32 8))
    rw [locals]
    exact h.key
  · show t.locals "w".toList=some (.uint32,none)
    rw [locals]
    exact h.w
theorem bind_other (s : State) (ty : C99IntegerReference.Ty) (v : Value) (target name : String)
    (different : name≠target) :
    (bindValue s target.toList ty v).locals name.toList=s.locals name.toList := by
  simp only [bindValue,C99ScalarReference.set,
    show name.toList≠target.toList from fun equal => different (String.toList_injective equal),ite_false]
theorem bind_slot (s : State) (ty : C99IntegerReference.Ty) (v : Value) (target name : String)
    (w : BitVec 32) (different : name≠target) (slot : Slot s name w) :
    Slot (bindValue s target.toList ty v) name w := by
  show (bindValue s target.toList ty v).locals name.toList=some (.uint32,some (.uint32 w))
  rw [bind_other s ty v target name different]
  exact slot
theorem bind_uslot (s : State) (ty : C99IntegerReference.Ty) (v : Value) (target name : String)
    (m : Nat) (different : name≠target) (slot : USlot s name m) :
    USlot (bindValue s target.toList ty v) name m := by
  show (bindValue s target.toList ty v).locals name.toList=some (.uint64,some (u64 m))
  rw [bind_other s ty v target name different]
  exact slot
theorem bind_w (s : State) (ty : C99IntegerReference.Ty) (v : Value) (target : String)
    (slot : s.locals "w".toList=some (.uint32,none)) (different : "w"≠target) :
    (bindValue s target.toList ty v).locals "w".toList=some (.uint32,none) := by
  rw [bind_other s ty v target "w" different]
  exact slot
theorem common_bind (gm igm : ArrayPointer) (s : State) (ty : C99IntegerReference.Ty) (v : Value)
    (h : Common gm igm s) : Common gm igm (bindValue s "u".toList ty v) :=
  ⟨h.pointers,bind_slot s ty v "u" "logn" 10 (by decide) h.logn,
    bind_slot s ty v "u" "k" 8 (by decide) h.key,
    bind_w s ty v "u" h.w (by decide)⟩
theorem common_key (gm igm : ArrayPointer) (s : State) (pointers : Pointers s gm igm)
    (logn : Slot s "logn" 10) (w : s.locals "w".toList=some (.uint32,none)) :
    Common gm igm (bindValue s "k".toList .uint32 (.uint32 8)) :=
  ⟨pointers,bind_slot s .uint32 (.uint32 8) "k" "logn" 10 (by decide) logn,
    KeygenPublicTableAtoms.slot_after s "k" 8,
    bind_w s .uint32 (.uint32 8) "k" w (by decide)⟩
theorem bind_counter (s : State) (m : Nat) (hm : m<2^64) :
    USlot (bindValue s "u".toList .uint64 (u64 m)) "u" m := by
  simp only [USlot,bindValue,C99ScalarReference.set,ite_true,
    KeygenNttLoopSupport.convert_u64_self m hm]
theorem uslot_declared (s : State) (m : Nat) (counter : USlot s "u" m) :
    ∃ old, s.locals "u".toList=some (.uint64,old) := ⟨some (u64 m),counter⟩

/- Counter arithmetic of the two scalar updates. -/
theorem exact_minus (a b : Int) : C99IntegerReference.exact .minus a b=a-b := rfl
theorem sub_one_u64 (x : Nat) (hx : x<2^64) (positive : 0 < x) (v : Value)
    (h : C99IntegerReference.ArithmeticExec .minus (u64 x)
      (C99IntegerReference.convert .int32 1) v) : v=u64 (x-1) := by
  obtain ⟨safe,he⟩ := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp h)
  have htype : C99IntegerReference.usual (C99IntegerReference.promote (u64 x).type)
      (C99IntegerReference.promote (C99IntegerReference.convert .int32 1).type)=.uint64 := rfl
  rw [htype,KeygenNttLoopSupport.convert_u64_self x hx] at he
  have hinner : C99IntegerReference.convert .uint64
      (C99IntegerReference.convert .int32 1).integer=KeygenNttLoopSupport.u64 1 := by decide
  rw [hinner,KeygenNttLoopSupport.u64_integer x hx,KeygenNttLoopSupport.u64_integer 1 (by decide),
    exact_minus] at he
  have cast : ((x : Int)-((1 : Nat) : Int))=(((x-1 : Nat)) : Int) := by omega
  rw [he,cast,KeygenNttLoopSupport.convert_u64_nat]

theorem u_increment (s : State) (out : Result) (i : Nat) (hi : i<2^64)
    (counter : USlot s "u" i)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.cubeIncrement s out) :
    out=⟨bindValue s "u".toList .uint64 (u64 (i+1)),.normal⟩ := by
  cases source with
  | scalar _ _ env executed =>
      cases executed with
      | assign _ _ _ ty old v declared evaluated =>
          have typeEqual : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans counter))
          subst ty
          cases evaluated with
          | arithmetic _ _ _ a b _ first second operation =>
              have aEqual : a=u64 i := by
                cases first with
                | «variable» _ _ _ binding =>
                    exact Option.some.inj (congrArg Prod.snd (Option.some.inj (binding.symm.trans counter)))
              subst a
              cases second
              have vEqual := KeygenNttLoopSupport.add_one_literal i hi v operation
              rw [vEqual]
              rfl
theorem u_decrement (s : State) (out : Result) (i : Nat) (hi : i<2^64) (positive : 0 < i)
    (counter : USlot s "u" i)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.squareIncrement s out) :
    out=⟨bindValue s "u".toList .uint64 (u64 (i-1)),.normal⟩ := by
  cases source with
  | scalar _ _ env executed =>
      cases executed with
      | assign _ _ _ ty old v declared evaluated =>
          have typeEqual : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans counter))
          subst ty
          cases evaluated with
          | arithmetic _ _ _ a b _ first second operation =>
              have aEqual : a=u64 i := by
                cases first with
                | «variable» _ _ _ binding =>
                    exact Option.some.inj (congrArg Prod.snd (Option.some.inj (binding.symm.trans counter)))
              subst a
              cases second
              have vEqual := sub_one_u64 i hi positive v operation
              rw [vEqual]
              rfl

/- Executed word values of the initializers and both guards. -/
theorem logn_minus_two (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s (.bin .sub (KeygenPublicTableAtoms.var "logn")
      (KeygenPublicTableAtoms.literal 2)) v) : v=.uint32 8 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicTableAtoms.variable_value [] s "logn" 10 a profile left
      have bv := KeygenPublicTableAtoms.literal_value [] s 2 b right
      subst a; subst b
      exact ((C99IntegerReference.arithmetic_iff _ _ _ _).mp op).2
theorem k_plus_one (s : State) (v : Value) (key : Slot s "k" 8)
    (source : KeygenPublicWord.Eval [] s (.bin .add (KeygenPublicTableAtoms.var "k")
      (KeygenPublicTableAtoms.literal 1)) v) : v=.uint32 9 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicTableAtoms.variable_value [] s "k" 8 a key left
      have bv := KeygenPublicTableAtoms.literal_value [] s 1 b right
      subst a; subst b
      exact ((C99IntegerReference.arithmetic_iff _ _ _ _).mp op).2
theorem power_value (s : State) (v : Value) (key : Slot s "k" 8)
    (source : KeygenPublicWord.Eval [] s KeygenPublicUpperProgram.powerK v) : v=u64 256 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicLastEntry.size_one s a left
      have bv := KeygenPublicTableAtoms.variable_value [] s "k" 8 b key right
      subst a; subst b
      obtain ⟨n,hn,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ v op
      have eight : n=8 := by change (8 : Int)=(n : Int) at hn; omega
      subst n
      exact equal
theorem cube_limit_value (s : State) (v : Value) (key : Slot s "k" 8)
    (source : KeygenPublicWord.Eval [] s KeygenPublicUpperProgram.upper v) : v=u64 512 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicLastEntry.size_one s a left
      have bv := k_plus_one s b key right
      subst a; subst b
      obtain ⟨n,hn,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ v op
      have nine : n=9 := by change (9 : Int)=(n : Int) at hn; omega
      subst n
      exact equal
theorem square_start_value (s : State) (v : Value) (key : Slot s "k" 8)
    (source : KeygenPublicWord.Eval [] s (.bin .sub KeygenPublicUpperProgram.powerK
      (KeygenPublicTableAtoms.literal 1)) v) : v=u64 255 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := power_value s a key left
      have bv := KeygenPublicTableAtoms.literal_value [] s 1 b right
      subst a; subst b
      exact sub_one_u64 256 (by decide) (by decide) v op

theorem init_k_result (s : State) (out : Result) (profile : Slot s "logn" 10) (key : Slot s "k" 1)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.initK s out) :
    out=⟨bindValue s "k".toList .uint32 (.uint32 8),.normal⟩ :=
  KeygenPublicTableAtoms.assign_result _ _ _ "k" _ 8 out ⟨some (.uint32 1),key⟩
    (fun v hv => logn_minus_two s v profile hv) source
theorem init_cube_result (s : State) (out : Result) (key : Slot s "k" 8)
    (declared : ∃ old, s.locals "u".toList=some (.uint64,old))
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.initCube s out) :
    out=⟨bindValue s "u".toList .uint64 (u64 256),.normal⟩ :=
  KeygenPublicLastEntry.assign64_result _ out "u" KeygenPublicUpperProgram.powerK (u64 256) declared
    (fun z hz => power_value s z key hz) source
theorem init_square_result (s : State) (out : Result) (key : Slot s "k" 8)
    (declared : ∃ old, s.locals "u".toList=some (.uint64,old))
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.initSquare s out) :
    out=⟨bindValue s "u".toList .uint64 (u64 255),.normal⟩ :=
  KeygenPublicLastEntry.assign64_result _ out "u"
    (.bin .sub KeygenPublicUpperProgram.powerK (KeygenPublicTableAtoms.literal 1)) (u64 255) declared
    (fun z hz => square_start_value s z key hz) source

theorem cube_guard_value (s : State) (i : Nat) (hi : i<2^64) (counter : USlot s "u" i)
    (key : Slot s "k" 8) (v : Value)
    (source : KeygenPublicWord.Eval [] s KeygenPublicUpperProgram.cubeCondition v) :
    v=C99ScalarReference.boolean (decide (i<512)) := by
  cases source with
  | cmp _ _ _ a c _ first second op =>
      have av := KeygenPublicTableIndex.word64 s "u" i a counter first
      have cv := cube_limit_value s c key second
      subst a; subst c
      have equal := C99CountedWords.comparison_result _ _ _ v op
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .lt
        (C99IntegerReference.convert .uint64 (u64 i).integer).integer
        (C99IntegerReference.convert .uint64 (u64 512).integer).integer) at equal
      rw [KeygenNttLoopSupport.convert_u64_self i hi,
        KeygenNttLoopSupport.convert_u64_self 512 (by decide),
        KeygenNttLoopSupport.u64_integer i hi,
        KeygenNttLoopSupport.u64_integer 512 (by decide)] at equal
      have comparison : (((i : Nat) : Int)<((512 : Nat) : Int)) ↔ i<512 := by omega
      simpa only [C99IntegerReference.compare,comparison] using equal
theorem square_guard_value (s : State) (i : Nat) (hi : i<2^64) (counter : USlot s "u" i)
    (v : Value)
    (source : KeygenPublicWord.Eval [] s KeygenPublicUpperProgram.squareCondition v) :
    v=C99ScalarReference.boolean (decide (0 < i)) := by
  cases source with
  | cmp _ _ _ a c _ first second op =>
      have av := KeygenPublicTableIndex.word64 s "u" i a counter first
      have cv := KeygenPublicTableAtoms.literal_value [] s 0 c second
      subst a; subst c
      have equal := C99CountedWords.comparison_result _ _ _ v op
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .gt
        (C99IntegerReference.convert .uint64 (u64 i).integer).integer
        (C99IntegerReference.convert .int32 0).integer) at equal
      have zero : (C99IntegerReference.convert .int32 0).integer=(0 : Int) := by decide
      rw [KeygenNttLoopSupport.convert_u64_self i hi,
        KeygenNttLoopSupport.u64_integer i hi,zero] at equal
      have comparison : (((0 : Int))<((i : Nat) : Int)) ↔ 0 < i := by omega
      simpa only [C99IntegerReference.compare,comparison] using equal

/- Loop invariants: the filled domain grows with the counter and every byte
   outside the two full table ranges survives each iteration. -/
structure CubeInv (gm igm : ArrayPointer) (initial : Memory) (i : Nat) (s : State) : Prop where
  common : Common gm igm s
  lower : 256 ≤ i
  upper : i ≤ 512
  counter : USlot s "u" i
  filled : ∀ j<1024, 512 ≤ j ∨ (256 ≤ j ∧ j < i) → PairCell s.heap gm igm j
  frame : UpperFrame gm igm initial s.heap
structure SquareInv (gm igm : ArrayPointer) (initial : Memory) (i : Nat) (s : State) : Prop where
  common : Common gm igm s
  upper : i ≤ 255
  counter : USlot s "u" i
  filled : ∀ j<1024, i < j → PairCell s.heap gm igm j
  frame : UpperFrame gm igm initial s.heap

theorem cube_progress (gm igm : ArrayPointer) (i : Nat) (before after : Memory)
    (old : ∀ j<1024, 512 ≤ j ∨ (256 ≤ j ∧ j < i) → PairCell before gm igm j)
    (update : RowUpdate gm igm i before after) :
    ∀ j<1024, 512 ≤ j ∨ (256 ≤ j ∧ j < i+1) → PairCell after gm igm j := by
  intro j hj choice
  by_cases eq : j=i
  · subst j
    exact ⟨update.1.1,update.2.1⟩
  · have oldCell : PairCell before gm igm j := by
      apply old j hj
      rcases choice with top | mid
      · exact Or.inl top
      · exact Or.inr ⟨mid.1,by omega⟩
    exact ⟨update.1.2 j hj (Ne.symm eq) _ oldCell.1,update.2.2 j hj (Ne.symm eq) _ oldCell.2⟩
theorem square_progress (gm igm : ArrayPointer) (i : Nat) (before after : Memory)
    (old : ∀ j<1024, i < j → PairCell before gm igm j)
    (update : RowUpdate gm igm i before after) :
    ∀ j<1024, i-1 < j → PairCell after gm igm j := by
  intro j hj bound
  by_cases eq : j=i
  · subst j
    exact ⟨update.1.1,update.2.1⟩
  · have oldCell : PairCell before gm igm j := old j hj (by omega)
    exact ⟨update.1.2 j hj (Ne.symm eq) _ oldCell.1,update.2.2 j hj (Ne.symm eq) _ oldCell.2⟩

theorem cube_step (before middle next : State) (gm igm : ArrayPointer) (initial : Memory)
    (i : Nat) (active : i<512) (inv : CubeInv gm igm initial i before)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (bodyExec : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.cubeBody before ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.cubeIncrement middle ⟨next,.normal⟩) :
    CubeInv gm igm initial (i+1) next := by
  have lowerI : 256 ≤ i := inv.lower
  have upperI : i ≤ 512 := inv.upper
  have input : PairCell before.heap gm igm (2*i) := inv.filled (2*i) (by omega) (Or.inl (by omega))
  have body := KeygenPublicUpperBody.cube_body before ⟨middle,.normal⟩ gm igm i lowerI active
    gw iw separate inv.common.pointers inv.counter input bodyExec
  have localsM : middle.locals=before.locals := body.2.1
  have arraysM : middle.arrays=before.arrays := body.2.2.1
  have cells : RowUpdate gm igm i before.heap middle.heap := body.2.2.2
  have commonM : Common gm igm middle := common_same gm igm before middle localsM arraysM inv.common
  have counterM : USlot middle "u" i := by
    show middle.locals "u".toList=some (.uint64,some (u64 i))
    rw [localsM]
    exact inv.counter
  have bodyFrame : UpperFrame gm igm before.heap middle.heap :=
    KeygenPublicUpperFrames.cube_frame before ⟨middle,.normal⟩ gm igm i (by omega) gw iw
      inv.common.pointers inv.counter bodyExec
  have equal := congrArg Result.state (u_increment middle ⟨next,.normal⟩ i (by omega) counterM update)
  dsimp only at equal
  rw [equal]
  refine ⟨common_bind gm igm middle .uint64 (u64 (i+1)) commonM,by omega,by omega,?_,?_,?_⟩
  · exact bind_counter middle (i+1) (by omega)
  · intro j hj choice
    simp only [KeygenPublicLastEntry.bind_heap]
    exact cube_progress gm igm i before.heap middle.heap inv.filled cells j hj choice
  · simp only [KeygenPublicLastEntry.bind_heap]
    exact KeygenPublicUpperFrames.frame_trans gm igm initial before.heap middle.heap
      inv.frame bodyFrame

theorem square_step (before middle next : State) (gm igm : ArrayPointer) (initial : Memory)
    (i : Nat) (positive : 0 < i) (active : i<256) (inv : SquareInv gm igm initial i before)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (bodyExec : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.squareBody before ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.squareIncrement middle ⟨next,.normal⟩) :
    SquareInv gm igm initial (i-1) next := by
  have upperI : i ≤ 255 := inv.upper
  have input : PairCell before.heap gm igm (2*i) := inv.filled (2*i) (by omega) (by omega)
  have body := KeygenPublicUpperBody.square_body before ⟨middle,.normal⟩ gm igm i (by omega) active
    gw iw separate inv.common.pointers inv.counter input bodyExec
  have localsM : middle.locals=before.locals := body.2.1
  have arraysM : middle.arrays=before.arrays := body.2.2.1
  have cells : RowUpdate gm igm i before.heap middle.heap := body.2.2.2
  have commonM : Common gm igm middle := common_same gm igm before middle localsM arraysM inv.common
  have counterM : USlot middle "u" i := by
    show middle.locals "u".toList=some (.uint64,some (u64 i))
    rw [localsM]
    exact inv.counter
  have bodyFrame : UpperFrame gm igm before.heap middle.heap :=
    KeygenPublicUpperFrames.square_frame before ⟨middle,.normal⟩ gm igm i (by omega) gw iw
      inv.common.pointers inv.counter bodyExec
  have equal := congrArg Result.state
    (u_decrement middle ⟨next,.normal⟩ i (by omega) positive counterM update)
  dsimp only at equal
  rw [equal]
  refine ⟨common_bind gm igm middle .uint64 (u64 (i-1)) commonM,by omega,?_,?_,?_⟩
  · exact bind_counter middle (i-1) (by omega)
  · intro j hj bound
    simp only [KeygenPublicLastEntry.bind_heap]
    exact square_progress gm igm i before.heap middle.heap inv.filled cells j hj bound
  · simp only [KeygenPublicLastEntry.bind_heap]
    exact KeygenPublicUpperFrames.frame_trans gm igm initial before.heap middle.heap
      inv.frame bodyFrame

theorem cube_source_loop (s : State) (out : Result) (gm igm : ArrayPointer) (initial : Memory)
    (i : Nat) (inv : CubeInv gm igm initial i s)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.cubeLoop s out) :
    out.flow=.normal ∧ CubeInv gm igm initial 512 out.state := by
  generalize shape : KeygenPublicUpperProgram.cubeLoop=code at source
  generalize signedShape : ([] : List C99ArrayReference.Name)=signed at source
  induction source generalizing i with
  | loopFalse _ _ _ before v evaluated zero =>
      cases shape
      cases signedShape
      have upperI : i ≤ 512 := inv.upper
      rw [cube_guard_value before i (by omega) inv.counter inv.common.key v evaluated] at zero
      have done : i=512 := by
        by_cases h : i<512
        · simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero
        · omega
      subst i
      exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v evaluated nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      cases signedShape
      have upperI : i ≤ 512 := inv.upper
      rw [cube_guard_value before i (by omega) inv.counter inv.common.key v evaluated] at nonzero
      have active : i<512 := by
        by_contra h
        simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
      exact ih3 (i+1)
        (cube_step before middle next gm igm initial i active inv gw iw separate iteration update) rfl rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem square_source_loop (s : State) (out : Result) (gm igm : ArrayPointer) (initial : Memory)
    (i : Nat) (inv : SquareInv gm igm initial i s)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.squareLoop s out) :
    out.flow=.normal ∧ SquareInv gm igm initial 0 out.state := by
  generalize shape : KeygenPublicUpperProgram.squareLoop=code at source
  generalize signedShape : ([] : List C99ArrayReference.Name)=signed at source
  induction source generalizing i with
  | loopFalse _ _ _ before v evaluated zero =>
      cases shape
      cases signedShape
      have upperI : i ≤ 255 := inv.upper
      rw [square_guard_value before i (by omega) inv.counter v evaluated] at zero
      have done : i=0 := by
        by_cases h : 0 < i
        · simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero
        · omega
      subst i
      exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v evaluated nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      cases signedShape
      have upperI : i ≤ 255 := inv.upper
      rw [square_guard_value before i (by omega) inv.counter v evaluated] at nonzero
      have positive : 0 < i := by
        by_contra h
        simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
      exact ih3 (i-1)
        (square_step before middle next gm igm initial i positive (by omega) inv gw iw separate
          iteration update) rfl rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

/- Consume the SAME afterRows execution: both whole loops run and fill the
   tables at 1..1023; only the actual `finish` statement remains. -/
theorem source_upper (after : State) (out : Result) (gm igm : ArrayPointer)
    (profile : Slot after "logn" 10) (pointers : Pointers after gm igm)
    (wSlot : after.locals "w".toList=some (.uint32,none))
    (counter : USlot after "u" 512) (key : Slot after "k" 1)
    (images : PairCells gm igm after.heap 512)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.afterRows after out) :
    ∃ final, Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.finish final out ∧
      PairCells gm igm final.heap 1 ∧ Common gm igm final ∧ USlot final "u" 0 ∧
      UpperFrame gm igm after.heap final.heap := by
  obtain ⟨s1,kinit,rest1⟩ := seq_inv KeygenPublicUpperProgram.initK _ after out (by decide) source
  obtain ⟨s2,loops1,rest2⟩ := seq_inv (.seq KeygenPublicUpperProgram.initCube
    KeygenPublicUpperProgram.cubeLoop) _ s1 out (by decide) rest1
  obtain ⟨s3,cinit,cloop⟩ := seq_inv KeygenPublicUpperProgram.initCube
    KeygenPublicUpperProgram.cubeLoop s1 ⟨s2,.normal⟩ (by decide) loops1
  obtain ⟨s4,loops2,finishing⟩ := seq_inv (.seq KeygenPublicUpperProgram.initSquare
    KeygenPublicUpperProgram.squareLoop) KeygenPublicUpperProgram.finish s2 out (by decide) rest2
  obtain ⟨s5,sinit,sloop⟩ := seq_inv KeygenPublicUpperProgram.initSquare
    KeygenPublicUpperProgram.squareLoop s2 ⟨s4,.normal⟩ (by decide) loops2
  have kEqual := congrArg Result.state (init_k_result after ⟨s1,.normal⟩ profile key kinit)
  dsimp only at kEqual
  have hK : s1.heap=after.heap := KeygenPublicTableControl.assign_heap _ _ after ⟨s1,.normal⟩ kinit
  have commonS1 : Common gm igm s1 := by
    rw [kEqual]
    exact common_key gm igm after pointers profile wSlot
  have counterS1 : USlot s1 "u" 512 := by
    rw [kEqual]
    exact bind_uslot after .uint32 (.uint32 8) "k" "u" 512 (by decide) counter
  have cEqual := congrArg Result.state (init_cube_result s1 ⟨s3,.normal⟩ commonS1.key
    (uslot_declared s1 512 counterS1) cinit)
  dsimp only at cEqual
  have hU : s3.heap=s1.heap := KeygenPublicTableControl.assign_heap _ _ s1 ⟨s3,.normal⟩ cinit
  have commonS3 : Common gm igm s3 := by rw [cEqual]; exact common_bind gm igm s1 .uint64 (u64 256) commonS1
  have counterS3 : USlot s3 "u" 256 := by rw [cEqual]; exact bind_counter s1 256 (by decide)
  have images3 : PairCells gm igm s3.heap 512 := by rw [hU,hK]; exact images
  have cubeInitial : CubeInv gm igm after.heap 256 s3 := by
    refine ⟨commonS3,by decide,by decide,counterS3,?_,?_⟩
    · intro j hj choice
      rcases choice with top | mid
      · exact images3 j top hj
      · exact absurd mid.2 (by omega)
    · rw [hU,hK]
      exact KeygenPublicUpperFrames.frame_refl gm igm after.heap
  have cubeResult := cube_source_loop s3 ⟨s2,.normal⟩ gm igm after.heap 256 cubeInitial
    gw iw separate cloop
  have inv512 : CubeInv gm igm after.heap 512 s2 := cubeResult.2
  have sEqual := congrArg Result.state (init_square_result s2 ⟨s5,.normal⟩ inv512.common.key
    (uslot_declared s2 512 inv512.counter) sinit)
  dsimp only at sEqual
  have hS : s5.heap=s2.heap := KeygenPublicTableControl.assign_heap _ _ s2 ⟨s5,.normal⟩ sinit
  have commonS5 : Common gm igm s5 := by rw [sEqual]; exact common_bind gm igm s2 .uint64 (u64 255) inv512.common
  have counterS5 : USlot s5 "u" 255 := by rw [sEqual]; exact bind_counter s2 255 (by decide)
  have squareInitial : SquareInv gm igm after.heap 255 s5 := by
    refine ⟨commonS5,by decide,counterS5,?_,?_⟩
    · intro j hj bound
      rw [hS]
      by_cases h : j<512
      · exact inv512.filled j hj (Or.inr ⟨by omega,by omega⟩)
      · exact inv512.filled j hj (Or.inl (by omega))
    · rw [hS]
      exact inv512.frame
  have squareResult := square_source_loop s5 ⟨s4,.normal⟩ gm igm after.heap 255 squareInitial
    gw iw separate sloop
  have inv0 : SquareInv gm igm after.heap 0 s4 := squareResult.2
  exact ⟨s4,finishing,fun i hi hj => inv0.filled i hj (by omega),inv0.common,inv0.counter,inv0.frame⟩

/- Complete generate execution through both loops; only `finish` remains. -/
theorem source_tables (s : State) (out : Result) (gm igm : ArrayPointer)
    (profile : Slot s "logn" 10) (pointers : Pointers s gm igm)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate) s out) :
    ∃ after final, Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.afterRows after out ∧
      Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.finish final out ∧
      PairCells gm igm final.heap 1 ∧ Common gm igm final ∧ USlot final "u" 0 ∧
      UpperFrame gm igm s.heap final.heap := by
  obtain ⟨after,executed,images,bytes,pointersA,profileA,counterA,keyA,wA⟩ :=
    KeygenPublicLastRow.source_last_row s out gm igm profile pointers gw iw separate source
  have cells : PairCells gm igm after.heap 512 := by
    intro i lower upper
    exact ⟨(images i lower upper).1,(images i lower upper).2⟩
  obtain ⟨final,finishing,filled,common,counter,frame⟩ := source_upper after out gm igm
    profileA pointersA wA counterA keyA cells gw iw separate executed
  exact ⟨after,final,executed,finishing,filled,common,counter,
    KeygenPublicUpperFrames.frame_trans gm igm s.heap after.heap final.heap
      (KeygenPublicUpperFrames.from_last gm igm s.heap after.heap bytes) frame⟩

end FT1536.Source3.KeygenPublicUpperLoops
