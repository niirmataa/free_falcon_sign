import Source3.KeygenPublicValueExpr

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual first-pass butterfly, with ordinary coefficient values and a
   separately scaled source r. The complete first-loop fold remains separate. -/
namespace FT1536.Source3.KeygenPublicFirstValues
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt chain)
open KeygenPublicValueExpr (Evaluates Local meaning add sub)
open KeygenPublicInputCells (Cell)
open KeygenPublicTableAtoms (var mont)
open KeygenPublicAlgebra (R radix)
open KeygenNttLoopSupport (USlot)

def lowIndex : CLogic.Expr := .var "u".toList
def highIndex : CLogic.Expr := .bin .add lowIndex (.var "hn".toList)
def names : List C99ArrayReference.Name := ["a0".toList,"a1".toList,"b".toList]
def declaration : Stmt := .scalar (.declare .u32 names)
def readLow : Stmt := .assign "a0".toList (.load16 "a".toList lowIndex)
def readHigh : Stmt := .assign "a1".toList (.load16 "a".toList highIndex)
def multiply : Stmt := .assign "b".toList (mont (var "a1") (var "r"))
def storeLow : Stmt := .store "a".toList lowIndex false (add (var "a0") (var "b"))
def storeHigh : Stmt := .store "a".toList highIndex false (sub (add (var "a0") (var "a1")) (var "b"))
def inner : Stmt := chain [declaration,readLow,readHigh,multiply,storeLow,storeHigh]
def body : Stmt := .scope names [] inner
def firstLoop : Stmt := .loop (.cmp .lt (var "u") (var "hn")) body
  (.scalar (.update "u".toList .add (.literal .i32 1)))
def pass : Stmt := .seq (.assign "u".toList (KeygenPublicTableAtoms.literal 0)) firstLoop
def seed : Stmt := .assign "r".toList (.load16 "gm_square".toList (.literal .i32 1))
def remaining : Stmt := KeygenPublicForwardProgram.fragment 1015 47

theorem source_first_pass : KeygenPublicForwardProgram.tail=.seq seed (.seq pass remaining) := by decide
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide

structure Fixed (s : State) (a : ArrayPointer) (i : Nat) : Prop where
  pointer : s.arrays "a".toList=some a
  u : USlot s "u" i
  hn : USlot s "hn" 768
def PairUpdate (before after : Memory) (a : ArrayPointer) (i : Nat) (x y z : R) : Prop :=
  Cell after a i (x+y*z) ∧ Cell after a (i+768) (x+y-y*z) ∧
    ∃ (middle : Memory) (low high : BitVec 16),
      KeygenSmallOutput.Store16 before (KeygenSmallOutput.element a i) low middle ∧
      KeygenSmallOutput.Store16 middle (KeygenSmallOutput.element a (i+768)) high after

theorem fixed_after (code : Stmt) (s : State) (out : Result) (a : ArrayPointer) (i : Nat)
    (fixed : Fixed s a i) (ok : KeygenPublicTableControl.supported code=true)
    (keep : "u".toList∉KeygenPublicTableControl.writes code ∧ "hn".toList∉KeygenPublicTableControl.writes code)
    (source : Exec KeygenPublicSource.program [] code s out) : Fixed out.state a i := by
  obtain ⟨_,arrays,locals⟩ := KeygenPublicTableControl.frame _ _ _ _ _ ok source
  exact ⟨by rw [arrays]; exact fixed.pointer,(locals _ keep.1).trans fixed.u,(locals _ keep.2).trans fixed.hn⟩

theorem low_value (s : State) (i : Nat) (hi : i<768) (v : C99IntegerReference.Value) (u : USlot s "u" i)
    (source : KeygenPublicWord.scalar s lowIndex v) : v.integer.toNat=i := by
  rw [KeygenPublicTableIndex.variable64 s "u" i v u source]
  exact KeygenNttLoopSupport.u64_toNat i (by omega)

theorem high_value (s : State) (i : Nat) (hi : i<768) (v : C99IntegerReference.Value)
    (u : USlot s "u" i) (hn : USlot s "hn" 768) (source : KeygenPublicWord.scalar s highIndex v) : v.integer.toNat=i+768 := by
  cases source with
  | arithmetic _ _ _ av bv _ first second operation =>
      have ae := KeygenPublicTableIndex.variable64 s "u" i av u first
      have be := KeygenPublicTableIndex.variable64 s "hn" 768 bv hn second
      subst av; subst bv
      rw [KeygenNttLoopSupport.plus_u64 i 768 (by omega) (by decide) v operation]
      exact KeygenNttLoopSupport.u64_toNat (i+768) (by omega)

theorem load_value (s : State) (a : ArrayPointer) (e : CLogic.Expr) (i : Nat) (z : R)
    (binding : s.arrays "a".toList=some a) (index : ∀ v, KeygenPublicWord.scalar s e v → v.integer.toNat=i)
    (cell : Cell s.heap a i z) : Evaluates s (.load16 "a".toList e) z := by
  intro v source
  cases source with
  | load16 _ _ actual w address read =>
      rw [KeygenPublicTableIndex.address s "a" e a actual i binding index address] at read
      obtain ⟨old,loaded,range,eq⟩ := cell
      have we := C99NarrowReads.load16_deterministic _ _ _ _ read loaded
      subst w
      refine ⟨?_,?_⟩
      · change KeygenPublicRangeExpr.Ranged (C99NarrowReads.unsignedPromotion old)
        unfold KeygenPublicRangeExpr.Ranged
        rw [C99NarrowReads.unsigned_promotion_exact]
        exact ⟨Int.natCast_nonneg _,by exact_mod_cast range⟩
      · change ((C99NarrowReads.unsignedPromotion old).integer : R)=z
        rw [C99NarrowReads.unsigned_promotion_exact,Int.cast_natCast]
        exact eq

theorem store_value (s : State) (out : Result) (a : ArrayPointer) (e : CLogic.Expr) (i : Nat) (expr : KeygenWordExpr.Expr) (z : R)
    (binding : s.arrays "a".toList=some a) (index : ∀ v, KeygenPublicWord.scalar s e v → v.integer.toNat=i)
    (value : Evaluates s expr z) (source : Exec KeygenPublicSource.program [] (.store "a".toList e false expr) s out) :
    Cell out.state.heap a i z ∧ ∃ w, KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element a i) w out.state.heap := by
  cases source with
  | store _ _ _ _ before heap actual v address evaluated write =>
      rw [KeygenPublicTableIndex.address s "a" e a actual i binding index address] at write
      obtain ⟨range,eq⟩ := value v evaluated
      have cast : (v.integer.toNat : Int)=v.integer := Int.toNat_of_nonneg range.1
      have small : v.integer.toNat<18433 := by unfold KeygenPublicRangeExpr.Ranged at range; omega
      have exactNat : (KeygenPublicWord.narrow v).toNat=v.integer.toNat := by
        change (BitVec.ofInt 16 v.integer).toNat=_
        rw [← cast,BitVec.ofInt_natCast,BitVec.toNat_ofNat]
        exact Nat.mod_eq_of_lt (by omega)
      refine ⟨⟨_,KeygenPublicTableCells.stored_load _ _ _ _ write,KeygenPublicRangeExpr.narrowed_range v range,?_⟩,_,write⟩
      rw [exactNat]
      exact ((Int.cast_natCast _).symm.trans (congrArg (fun z : Int => (z : R)) cast)).trans eq

theorem source_body (s : State) (out : Result) (a : ArrayPointer) (i : Nat) (x y z : R)
    (hi : i<768) (width : a.elementBytes=2) (fixed : Fixed s a i)
    (first : Cell s.heap a i x) (second : Cell s.heap a (i+768) y)
    (r : Local s "r" (radix*z)) (source : Exec KeygenPublicSource.program [] body s out) :
    PairUpdate s.heap out.state.heap a i x y z := by
  cases source with
  | scope _ _ _ _ result executed =>
      obtain ⟨s1,decl,rest1⟩ := KeygenPublicTableControl.seq_inv _ _ s result (by decide) executed
      obtain ⟨s2,read0,rest2⟩ := KeygenPublicTableControl.seq_inv _ _ s1 result (by decide) rest1
      obtain ⟨s3,read1,rest3⟩ := KeygenPublicTableControl.seq_inv _ _ s2 result (by decide) rest2
      obtain ⟨s4,mult,rest4⟩ := KeygenPublicTableControl.seq_inv _ _ s3 result (by decide) rest3
      obtain ⟨s5,low,rest5⟩ := KeygenPublicTableControl.seq_inv _ _ s4 result (by decide) rest4
      obtain ⟨s6,high,last⟩ := KeygenPublicTableControl.seq_inv _ _ s5 result (by decide) rest5
      cases last
      have declared := congrArg Result.state (KeygenPublicTableAtoms.declaration_result _ [] s .u32 names ⟨s1,.normal⟩ decl)
      dsimp only at declared
      have f1 := fixed_after declaration s ⟨s1,.normal⟩ a i fixed (by decide) (by decide) decl
      have f2 := fixed_after readLow s1 ⟨s2,.normal⟩ a i f1 (by decide) (by decide) read0
      have f3 := fixed_after readHigh s2 ⟨s3,.normal⟩ a i f2 (by decide) (by decide) read1
      have f4 := fixed_after multiply s3 ⟨s4,.normal⟩ a i f3 (by decide) (by decide) mult
      have f5 := fixed_after storeLow s4 ⟨s5,.normal⟩ a i f4 (by decide) (by decide) low
      have heap1 : s1.heap=s.heap := by rw [declared]
      have heap2 : s2.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read0).trans heap1
      have heap3 : s3.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read1).trans heap2
      have heap4 : s4.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ mult).trans heap3
      have a0 := KeygenPublicValueExpr.assign_value s1 ⟨s2,.normal⟩ "a0" _ x
        ⟨none,by rw [declared]; rfl⟩
        (load_value s1 a lowIndex i x f1.pointer (fun v ev => low_value s1 i hi v f1.u ev) (by rw [heap1]; exact first)) read0
      have a1Declared : ∃ old, s2.locals "a1".toList=some (.uint32,old) := by
        refine ⟨none,?_⟩
        rw [(KeygenPublicTableControl.frame _ _ _ _ _ (by decide) read0).2.2 _ (by decide),declared]
        rfl
      have a1 := KeygenPublicValueExpr.assign_value s2 ⟨s3,.normal⟩ "a1" _ y a1Declared
        (load_value s2 a highIndex (i+768) y f2.pointer (fun v ev => high_value s2 i hi v f2.u f2.hn ev)
          (by rw [heap2]; exact second)) read1
      have a03 := KeygenPublicValueExpr.local_after readHigh s2 ⟨s3,.normal⟩ "a0" x (by decide) (by decide) a0 read1
      have r1 := KeygenPublicValueExpr.local_after declaration s ⟨s1,.normal⟩ "r" _ (by decide) (by decide) r decl
      have r2 := KeygenPublicValueExpr.local_after readLow s1 ⟨s2,.normal⟩ "r" _ (by decide) (by decide) r1 read0
      have r3 := KeygenPublicValueExpr.local_after readHigh s2 ⟨s3,.normal⟩ "r" _ (by decide) (by decide) r2 read1
      have bDeclared : ∃ old, s3.locals "b".toList=some (.uint32,old) := by
        refine ⟨none,?_⟩
        rw [(KeygenPublicTableControl.frame _ _ _ _ _ (by decide) read1).2.2 _ (by decide),
          (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) read0).2.2 _ (by decide),declared]
        rfl
      have b := KeygenPublicValueExpr.assign_value s3 ⟨s4,.normal⟩ "b" _ (y*z) bDeclared
        (KeygenPublicValueExpr.twiddle_value s3 _ _ y z
          (KeygenPublicValueExpr.local_value s3 "a1" y a1) (KeygenPublicValueExpr.local_value s3 "r" _ r3)) mult
      have a04 := KeygenPublicValueExpr.local_after multiply s3 ⟨s4,.normal⟩ "a0" x (by decide) (by decide) a03 mult
      have a14 := KeygenPublicValueExpr.local_after multiply s3 ⟨s4,.normal⟩ "a1" y (by decide) (by decide) a1 mult
      obtain ⟨lowCell,lw,lowStore⟩ := store_value s4 ⟨s5,.normal⟩ a lowIndex i _ (x+y*z) f4.pointer
        (fun v ev => low_value s4 i hi v f4.u ev)
        (KeygenPublicValueExpr.add_value s4 _ _ x (y*z)
          (KeygenPublicValueExpr.local_value _ "a0" _ a04) (KeygenPublicValueExpr.local_value _ "b" _ b)) low
      have a05 := KeygenPublicValueExpr.local_after storeLow s4 ⟨s5,.normal⟩ "a0" x (by decide) (by decide) a04 low
      have a15 := KeygenPublicValueExpr.local_after storeLow s4 ⟨s5,.normal⟩ "a1" y (by decide) (by decide) a14 low
      have b5 := KeygenPublicValueExpr.local_after storeLow s4 ⟨s5,.normal⟩ "b" (y*z) (by decide) (by decide) b low
      obtain ⟨highCell,hw,highStore⟩ := store_value s5 ⟨s6,.normal⟩ a highIndex (i+768) _ (x+y-y*z) f5.pointer
        (fun v ev => high_value s5 i hi v f5.u f5.hn ev)
        (KeygenPublicValueExpr.sub_value s5 _ _ (x+y) (y*z)
          (KeygenPublicValueExpr.add_value s5 _ _ x y
            (KeygenPublicValueExpr.local_value _ "a0" _ a05) (KeygenPublicValueExpr.local_value _ "a1" _ a15))
          (KeygenPublicValueExpr.local_value _ "b" _ b5)) high
      have finalLow := KeygenPublicInputCells.preserves _ _ a width (i+768) i (by omega) hw _ highStore lowCell
      rw [heap4] at lowStore
      exact ⟨finalLow,highCell,s5.heap,lw,hw,lowStore,highStore⟩

end FT1536.Source3.KeygenPublicFirstValues
