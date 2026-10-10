import Source3.KeygenPublicReverseRows

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- All eight executed reverse stages. Source t doubles while m halves;
   the explicit unnormalized image is derived, not a round-trip premise. -/
namespace FT1536.Source3.KeygenPublicReverseStages
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R)
open KeygenPublicInputCells (Cells)
open KeygenPublicInverseTables (Table)
open KeygenPublicSizeOps (Declared)
open KeygenPublicTableAtoms (Slot var literal)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableControl (frame seq_inv)
open KeygenPublicReverseProgram

def size (k : Nat) : Nat := 6*2^k
def count (k : Nat) : Nat := 256/2^k
def image (a : Nat → R) : Nat → Nat → R
  | 0 => a
  | k+1 => KeygenPublicReverseRows.image (image a k) (count k) (size k/2) (count k)

theorem dimensions (k : Nat) (hk : k<8) :
    0 < size k/2 ∧ count k≤256 ∧ count k*(2*(size k/2))=1536 ∧ size k=2*(size k/2) ∧
    size (k+1)=size k*2 ∧ count (k+1)=count k/2 ∧ size k<1536 := by
  have cert : ∀ i : Fin 8,
      0 < size i.val/2 ∧ count i.val≤256 ∧ count i.val*(2*(size i.val/2))=1536 ∧ size i.val=2*(size i.val/2) ∧
      size (i.val+1)=size i.val*2 ∧ count (i.val+1)=count i.val/2 ∧ size i.val<1536 := by decide
  exact cert ⟨k,hk⟩
theorem size_bound (k : Nat) (hk : k≤8) : size k≤1536 := by
  have cert : ∀ i : Fin 9, size i.val≤1536 := by decide
  exact cert ⟨k,by omega⟩
theorem count_bound (k : Nat) : count k≤256 := Nat.div_le_self _ _
theorem terminal (k : Nat) (hk : k≤8) : ¬size k<1536 ↔ k=8 := by
  have cert : ∀ i : Fin 9, ¬size i.val<1536 ↔ i.val=8 := by decide
  exact cert ⟨k,by omega⟩

theorem logn_minus_two (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s (.bin .sub (var "logn") (literal 2)) v) : v=.uint32 8 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicTableAtoms.variable_value [] s "logn" 10 a profile left
      have bv := KeygenPublicTableAtoms.literal_value [] s 2 b right
      subst a; subst b
      exact ((C99IntegerReference.arithmetic_iff _ _ _ _).mp op).2
theorem m_value (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s
      (.bin .shl (.cast .uint64 (literal 1)) (.bin .sub (var "logn") (literal 2))) v) : v=u64 256 := by
  cases source with
  | bin _ _ _ a b _ left right op =>
      have av := KeygenPublicLastEntry.size_one s a left
      have bv := logn_minus_two s b profile right
      subst a; subst b
      obtain ⟨n,hn,_,equal⟩ := KeygenNttForwardExec.shift_left_value _ _ v op
      have eight : n=8 := by change (8 : Int)=(n : Int) at hn; omega
      subst n
      exact equal

theorem double_t (s : State) (out : Result) (n : Nat) (hn : n≤768) (slot : USlot s "t" n)
    (source : Exec KeygenPublicSource.program [] tSet s out) :
    USlot out.state "t" (n*2) ∧ out.state.heap=s.heap := by
  cases source with
  | scalar _ before env executed =>
      cases executed with
      | assign _ _ _ ty old v declared evaluated =>
          have te := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
          dsimp only at te
          subst ty
          cases evaluated with
          | shift _ _ _ a b _ left right operation =>
              have ae := KeygenPublicTableIndex.variable64 s "t" n a slot left
              subst a
              cases right
              rw [KeygenNttLoopSupport.shl_one_u64 n (by omega) v operation]
              refine ⟨?_,rfl⟩
              simp only [USlot,C99ScalarReference.set,ite_true]
              rw [KeygenNttLoopSupport.convert_u64_self (n*2) (by omega)]

structure Fixed (p igm : ArrayPointer) (s : State) : Prop where
  width : p.elementBytes=2
  separate : p.block≠igm.block
  pointer : s.arrays "a".toList=some p
  square : s.arrays "igm_square".toList=some igm
  table : Table s.heap igm
  n : USlot s "n" 1536
structure Inv (a : Nat → R) (p igm : ArrayPointer) (k : Nat) (s : State) : Prop
    extends Fixed p igm s where
  counterBound : k≤8
  counter : USlot s "m" (count k)
  currentSize : USlot s "t" (size k)
  vType : Declared s "v"
  cells : Cells s.heap p 1536 (image a k)

theorem fixed_after (code : Stmt) (s : State) (out : Result) (p igm : ArrayPointer)
    (ok : KeygenPublicTableControl.supported code=true) (only : KeygenPublicValueFrames.onlyA code=true)
    (keepN : "n".toList∉KeygenPublicTableControl.writes code)
    (fixed : Fixed p igm s) (source : Exec KeygenPublicSource.program [] code s out) : Fixed p igm out.state := by
  have f := frame _ [] code s out ok source
  exact ⟨fixed.width,fixed.separate,by rw [f.2.1]; exact fixed.pointer,by rw [f.2.1]; exact fixed.square,
    KeygenPublicInverseTables.table_after code s out p igm ok only fixed.separate fixed.pointer fixed.table source,
    (f.2.2 _ keepN).trans fixed.n⟩

theorem source_stage (a : Nat → R) (p igm : ArrayPointer) (k : Nat) (s : State) (out : Result)
    (active : k<8) (inv : Inv a p igm k s)
    (source : Exec KeygenPublicSource.program [] stageBody s out) :
    Cells out.state.heap p 1536 (image a (k+1)) ∧ USlot out.state "t" (size (k+1)) ∧ Declared out.state "v" := by
  obtain ⟨positive,bound,extent,twice,doubled,_,small⟩ := dimensions k active
  cases source with
  | scope _ _ _ _ result executed =>
      obtain ⟨s1,d,rest1⟩ := seq_inv _ _ s result (by decide) executed
      obtain ⟨s2,setHalf,rest2⟩ := seq_inv _ _ s1 result (by decide) rest1
      obtain ⟨s3,rowExec,rest3⟩ := seq_inv _ _ s2 result (by decide) rest2
      obtain ⟨s4,setSize,last⟩ := seq_inv _ _ s3 result (by decide) rest3
      cases last
      have state1 := congrArg Result.state
        (KeygenPublicTableAtoms.declaration_result _ [] s .u64 stageNames ⟨s1,.normal⟩ d)
      dsimp only at state1
      have f1 := frame _ [] (.scalar (.declare .u64 stageNames)) s ⟨s1,.normal⟩ (by decide) d
      have t1 : USlot s1 "t" (size k) := (f1.2.2 _ (by decide)).trans inv.currentSize
      have ht := (KeygenPublicSizeOps.assign s1 ⟨s2,.normal⟩ "ht" _ (size k/2) (by omega)
        ⟨none,by rw [state1]; rfl⟩ (KeygenPublicSizeOps.half s1 "t" (size k) (by omega) t1) setHalf).2
      have f2 := frame _ [] htSet s1 ⟨s2,.normal⟩ (by decide) setHalf
      have heap2 : s2.heap=s.heap := by rw [KeygenPublicTableControl.assign_heap _ _ _ _ setHalf,state1]
      have fixed : KeygenPublicReverseRows.Fixed p igm (count k) (size k/2) s2 := by
        refine ⟨positive,bound,extent,inv.width,inv.separate,?_,?_,?_,?_,ht,?_⟩
        · rw [f2.2.1,f1.2.1]; exact inv.pointer
        · rw [f2.2.1,f1.2.1]; exact inv.square
        · rw [heap2]; exact inv.table
        · exact (f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans inv.counter)
        · rw [← twice]; exact (f2.2.2 _ (by decide)).trans t1
      have rowType : Declared s2 "u1" := by
        refine ⟨none,?_⟩; rw [f2.2.2 _ (by decide),state1]; rfl
      have baseType : Declared s2 "v1" := by
        refine ⟨none,?_⟩; rw [f2.2.2 _ (by decide),state1]; rfl
      have vType : Declared s2 "v" := by
        rw [Declared,f2.2.2 _ (by decide),f1.2.2 _ (by decide)]; exact inv.vType
      have rowsFinal := (KeygenPublicReverseRows.source_rows (image a k) p igm (count k) (size k/2) s2 ⟨s3,.normal⟩
        fixed rowType baseType vType (by rw [heap2]; exact inv.cells) rowExec).2
      have t3 : USlot s3 "t" (size k) := by rw [twice]; exact rowsFinal.size
      have sizeBound : size k≤768 := by
        have cert : ∀ i : Fin 8, size i.val≤768 := by decide
        exact cert ⟨k,active⟩
      obtain ⟨t4,heap4⟩ := double_t s3 ⟨s4,.normal⟩ (size k) sizeBound t3 setSize
      refine ⟨?_,?_,?_⟩
      · change Cells s4.heap p 1536 (image a (k+1))
        rw [heap4]; exact rowsFinal.cells
      · change USlot s4 "t" (size (k+1))
        rw [doubled]; exact t4
      · change Declared s4 "v"
        rw [Declared,(frame _ [] tSet _ _ (by decide) setSize).2.2 _ (by decide)]
        exact rowsFinal.vType

theorem step (a : Nat → R) (p igm : ArrayPointer) (k : Nat) (s middle next : State)
    (active : k<8) (inv : Inv a p igm k s)
    (iteration : Exec KeygenPublicSource.program [] stageBody s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] stageStep middle ⟨next,.normal⟩) : Inv a p igm (k+1) next := by
  obtain ⟨cells,t,vType⟩ := source_stage a p igm k s ⟨middle,.normal⟩ active inv iteration
  have bound := count_bound k
  have countM : USlot middle "m" (count k) :=
    (frame _ [] stageBody _ _ (by decide) iteration).2.2 _ (by decide) |>.trans inv.counter
  have countN := (KeygenPublicSizeOps.assign middle ⟨next,.normal⟩ "m" _ (count k/2) (by omega)
    ⟨_,countM⟩ (KeygenPublicSizeOps.half middle "m" _ (by omega) countM) update).2
  have fm := fixed_after stageBody s ⟨middle,.normal⟩ p igm (by decide) (by decide) (by decide) inv.toFixed iteration
  have fn := fixed_after stageStep middle ⟨next,.normal⟩ p igm (by decide) (by decide) (by decide) fm update
  refine ⟨fn,by omega,?_,?_,?_,?_⟩
  · rw [(dimensions k active).2.2.2.2.2.1]; exact countN
  · exact (frame _ [] stageStep _ _ (by decide) update).2.2 _ (by decide) |>.trans t
  · rw [Declared,(frame _ [] stageStep _ _ (by decide) update).2.2 _ (by decide)]; exact vType
  · rw [KeygenPublicTableControl.assign_heap _ _ _ _ update]; exact cells

theorem loop_result (a : Nat → R) (p igm : ArrayPointer) (code : Stmt) (before : State) (result : Result)
    (source : Exec KeygenPublicSource.program [] code before result) (shape : code=stageLoop)
    (k : Nat) (inv : Inv a p igm k before) : result.flow=.normal ∧ Inv a p igm 8 result.state := by
  generalize sgnEq : ([] : List Name)=sgn at source
  induction source generalizing k with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases sgnEq
      have sb := size_bound k inv.counterBound
      rw [KeygenPublicSizeOps.lt before "t" "n" (size k) 1536 sb (by decide) v inv.currentSize inv.n guard] at zero
      have no : ¬size k<1536 := by
        by_contra active
        simp [active,C99ScalarReference.boolean,Value.integer] at zero
      have eq := (terminal k inv.counterBound).mp no
      subst k; exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases sgnEq
      have sb := size_bound k inv.counterBound
      rw [KeygenPublicSizeOps.lt before "t" "n" (size k) 1536 sb (by decide) v inv.currentSize inv.n guard] at nonzero
      have active : k<8 := by
        have bound := inv.counterBound
        by_contra no
        have eq : k=8 := by omega
        subst k
        norm_num [size,C99ScalarReference.boolean,Value.integer] at nonzero
      exact ih3 rfl (k+1) (step a p igm k before middle next active inv iteration update) rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem source_stages (a : Nat → R) (p igm : ArrayPointer) (s : State) (out : Result)
    (fixed : Fixed p igm s) (profile : Slot s "logn" 10) (t : USlot s "t" 6)
    (mType : Declared s "m") (vType : Declared s "v")
    (input : Cells s.heap p 1536 a) (source : Exec KeygenPublicSource.program [] stages s out) :
    out.flow=.normal ∧ Inv a p igm 8 out.state := by
  obtain ⟨entry,init,loop⟩ := seq_inv _ _ s out (by decide) source
  have m := (KeygenPublicSizeOps.assign s ⟨entry,.normal⟩ "m" _ 256 (by decide) mType
    (fun v ev => m_value s v profile ev) init).2
  have heap := KeygenPublicTableControl.assign_heap _ _ _ _ init
  have f := frame _ [] initM s ⟨entry,.normal⟩ (by decide) init
  have inv : Inv a p igm 0 entry := by
    refine ⟨fixed_after _ s ⟨entry,.normal⟩ p igm (by decide) (by decide) (by decide) fixed init,by decide,m,?_,?_,?_⟩
    · exact (f.2.2 _ (by decide)).trans t
    · rw [Declared,f.2.2 _ (by decide)]; exact vType
    · rw [heap]; exact input
  exact loop_result a p igm stageLoop entry out loop rfl 0 inv

end FT1536.Source3.KeygenPublicReverseStages
