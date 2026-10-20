import Source3.KeygenPublicFirstMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Actual radix-2 butterfly values at the physical v and v+ht cells.
   Local counter/twiddle domains remain explicit until the nested-loop fold. -/
namespace FT1536.Source3.KeygenPublicRadixValues
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt chain)
open KeygenPublicValueExpr (Local add sub)
open KeygenPublicInputCells (Cell)
open KeygenPublicTableAtoms (var mont)
open KeygenPublicAlgebra (R radix)
open KeygenNttLoopSupport (USlot)

def lowIndex : CLogic.Expr := .var "v".toList
def highIndex : CLogic.Expr := .bin .add lowIndex (.var "ht".toList)
def names : List C99ArrayReference.Name := ["a0".toList,"a1".toList]
def declaration : Stmt := .scalar (.declare .u32 names)
def readLow : Stmt := .assign "a0".toList (.load16 "a".toList lowIndex)
def readHigh : Stmt := .assign "a1".toList (.load16 "a".toList highIndex)
def multiply : Stmt := .assign "a1".toList (mont (var "a1") (var "s"))
def storeLow : Stmt := .store "a".toList lowIndex false (add (var "a0") (var "a1"))
def storeHigh : Stmt := .store "a".toList highIndex false (sub (var "a0") (var "a1"))
def inner : Stmt := chain [declaration,readLow,readHigh,multiply,storeLow,storeHigh]
def body : Stmt := .scope names [] inner

def contains (target : Stmt) : Stmt → Bool
  | code@(.seq a b) | code@(.branch _ a b) | code@(.loop _ a b) =>
      decide (code=target) || contains target a || contains target b
  | code@(.scope _ _ b) | code@(.arrayScope _ _ b) => decide (code=target) || contains target b
  | code => decide (code=target)

theorem source_inner : KeygenPublicForwardProgram.fragment 1027 7=inner := by decide
theorem source_occurrence : contains body KeygenPublicFirstValues.remaining=true := by decide
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide

structure Fixed (s : State) (a : ArrayPointer) (i h : Nat) : Prop where
  pointer : s.arrays "a".toList=some a
  v : USlot s "v" i
  ht : USlot s "ht" h

def PairUpdate (before after : Memory) (a : ArrayPointer) (i h : Nat) (x y z : R) : Prop :=
  Cell after a i (x+y*z) ∧ Cell after a (i+h) (x-y*z) ∧
    ∃ (middle : Memory) (low high : BitVec 16),
      KeygenSmallOutput.Store16 before (KeygenSmallOutput.element a i) low middle ∧
      KeygenSmallOutput.Store16 middle (KeygenSmallOutput.element a (i+h)) high after

theorem fixed_after (code : Stmt) (s : State) (out : Result) (a : ArrayPointer) (i h : Nat)
    (fixed : Fixed s a i h) (ok : KeygenPublicTableControl.supported code=true)
    (keep : "v".toList∉KeygenPublicTableControl.writes code ∧ "ht".toList∉KeygenPublicTableControl.writes code)
    (source : Exec KeygenPublicSource.program [] code s out) : Fixed out.state a i h := by
  obtain ⟨_,arrays,locals⟩ := KeygenPublicTableControl.frame _ _ _ _ _ ok source
  exact ⟨by rw [arrays]; exact fixed.pointer,(locals _ keep.1).trans fixed.v,(locals _ keep.2).trans fixed.ht⟩

theorem low_value (s : State) (i : Nat) (hi : i<1536) (v : Value) (slot : USlot s "v" i)
    (source : KeygenPublicWord.scalar s lowIndex v) : v.integer.toNat=i := by
  rw [KeygenPublicTableIndex.variable64 s "v" i v slot source]
  exact KeygenNttLoopSupport.u64_toNat i (by omega)

theorem high_value (s : State) (i h : Nat) (bound : i+h<1536) (v : Value)
    (slot : USlot s "v" i) (ht : USlot s "ht" h)
    (source : KeygenPublicWord.scalar s highIndex v) : v.integer.toNat=i+h := by
  cases source with
  | arithmetic _ _ _ av bv _ first second operation =>
      have ae := KeygenPublicTableIndex.variable64 s "v" i av slot first
      have be := KeygenPublicTableIndex.variable64 s "ht" h bv ht second
      subst av; subst bv
      rw [KeygenNttLoopSupport.plus_u64 i h (by omega) (by omega) v operation]
      exact KeygenNttLoopSupport.u64_toNat (i+h) (by omega)

theorem source_body (s : State) (out : Result) (a : ArrayPointer) (i h : Nat) (x y z : R)
    (positive : 0<h) (bound : i+h<1536) (width : a.elementBytes=2) (fixed : Fixed s a i h)
    (first : Cell s.heap a i x) (second : Cell s.heap a (i+h) y)
    (twiddle : Local s "s" (radix*z)) (source : Exec KeygenPublicSource.program [] body s out) :
    PairUpdate s.heap out.state.heap a i h x y z := by
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
      have f1 := fixed_after declaration s ⟨s1,.normal⟩ a i h fixed (by decide) (by decide) decl
      have f2 := fixed_after readLow s1 ⟨s2,.normal⟩ a i h f1 (by decide) (by decide) read0
      have f3 := fixed_after readHigh s2 ⟨s3,.normal⟩ a i h f2 (by decide) (by decide) read1
      have f4 := fixed_after multiply s3 ⟨s4,.normal⟩ a i h f3 (by decide) (by decide) mult
      have f5 := fixed_after storeLow s4 ⟨s5,.normal⟩ a i h f4 (by decide) (by decide) low
      have heap1 : s1.heap=s.heap := by rw [declared]
      have heap2 : s2.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read0).trans heap1
      have heap3 : s3.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ read1).trans heap2
      have heap4 : s4.heap=s.heap := (KeygenPublicTableControl.assign_heap _ _ _ _ mult).trans heap3
      have a0 := KeygenPublicValueExpr.assign_value s1 ⟨s2,.normal⟩ "a0" _ x ⟨none,by rw [declared]; rfl⟩
        (KeygenPublicFirstValues.load_value s1 a lowIndex i x f1.pointer (fun v ev => low_value s1 i (by omega) v f1.v ev)
          (by rw [heap1]; exact first)) read0
      have a1Declared : ∃ old, s2.locals "a1".toList=some (.uint32,old) := by
        refine ⟨none,?_⟩
        rw [(KeygenPublicTableControl.frame _ _ _ _ _ (by decide) read0).2.2 _ (by decide),declared]; rfl
      have a1 := KeygenPublicValueExpr.assign_value s2 ⟨s3,.normal⟩ "a1" _ y a1Declared
        (KeygenPublicFirstValues.load_value s2 a highIndex (i+h) y f2.pointer
          (fun v ev => high_value s2 i h bound v f2.v f2.ht ev) (by rw [heap2]; exact second)) read1
      have a03 := KeygenPublicValueExpr.local_after readHigh s2 ⟨s3,.normal⟩ "a0" x (by decide) (by decide) a0 read1
      have z1 := KeygenPublicValueExpr.local_after declaration s ⟨s1,.normal⟩ "s" _ (by decide) (by decide) twiddle decl
      have z2 := KeygenPublicValueExpr.local_after readLow s1 ⟨s2,.normal⟩ "s" _ (by decide) (by decide) z1 read0
      have z3 := KeygenPublicValueExpr.local_after readHigh s2 ⟨s3,.normal⟩ "s" _ (by decide) (by decide) z2 read1
      have declared1 := a1
      obtain ⟨old,slot,_,_⟩ := declared1
      have product := KeygenPublicValueExpr.assign_value s3 ⟨s4,.normal⟩ "a1" _ (y*z) ⟨some (.uint32 old),slot⟩
        (KeygenPublicValueExpr.twiddle_value s3 _ _ y z
          (KeygenPublicValueExpr.local_value s3 "a1" y a1) (KeygenPublicValueExpr.local_value s3 "s" _ z3)) mult
      have a04 := KeygenPublicValueExpr.local_after multiply s3 ⟨s4,.normal⟩ "a0" x (by decide) (by decide) a03 mult
      obtain ⟨lowCell,lw,lowStore⟩ := KeygenPublicFirstValues.store_value s4 ⟨s5,.normal⟩ a lowIndex i _ (x+y*z) f4.pointer
        (fun v ev => low_value s4 i (by omega) v f4.v ev)
        (KeygenPublicValueExpr.add_value s4 _ _ x (y*z)
          (KeygenPublicValueExpr.local_value _ "a0" _ a04) (KeygenPublicValueExpr.local_value _ "a1" _ product)) low
      have a05 := KeygenPublicValueExpr.local_after storeLow s4 ⟨s5,.normal⟩ "a0" x (by decide) (by decide) a04 low
      have a15 := KeygenPublicValueExpr.local_after storeLow s4 ⟨s5,.normal⟩ "a1" (y*z) (by decide) (by decide) product low
      obtain ⟨highCell,hw,highStore⟩ := KeygenPublicFirstValues.store_value s5 ⟨s6,.normal⟩ a highIndex (i+h) _ (x-y*z) f5.pointer
        (fun v ev => high_value s5 i h bound v f5.v f5.ht ev)
        (KeygenPublicValueExpr.sub_value s5 _ _ x (y*z)
          (KeygenPublicValueExpr.local_value _ "a0" _ a05) (KeygenPublicValueExpr.local_value _ "a1" _ a15)) high
      have finalLow := KeygenPublicInputCells.preserves _ _ a width (i+h) i (by omega) hw _ highStore lowCell
      rw [heap4] at lowStore
      exact ⟨finalLow,highCell,s5.heap,lw,hw,lowStore,highStore⟩

end FT1536.Source3.KeygenPublicRadixValues
