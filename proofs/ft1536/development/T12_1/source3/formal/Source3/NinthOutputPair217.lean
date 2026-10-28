import Source3.NinthInverseZero217
import Source3.NttInverseSides203
import Source3.MakeFgGsShape194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The true d9 !out_ntt branch executes both original inverse calls at
   logn-1=0. Their actual callee early returns preserve the caller state. -/
namespace FT1536.Source3.NinthOutputPair217
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (ArrayPointer)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open SecondStepCopy203 (Side)

 def empty (s : State) : State := NttInverseCall202.empty s
 def withI (s : State) (p0i : BitVec 32) := bindValue (empty s) "p0i".toList .uint32 (.uint32 p0i)
 def withP (s : State) (p p0i : BitVec 32) := bindValue (withI s p0i) "p".toList .uint32 (.uint32 p)
 def withFull (s : State) (p p0i : BitVec 32) := bindValue (withP s p p0i) "full".toList .uint32 (.int32 0)
 def withLogn (s : State) (p p0i : BitVec 32) := bindValue (withFull s p p0i) "logn".toList .uint32 (.uint32 0)
 def withIgm (s : State) (igm : ArrayPointer) (p p0i : BitVec 32) := bindPointer (withLogn s p p0i) "igm".toList igm
 def withStride (s : State) (igm : ArrayPointer) (p p0i : BitVec 32) := bindValue (withIgm s igm p p0i) "stride".toList .uint64 (u64 335)
 def entry (s : State) (a igm : ArrayPointer) (p p0i : BitVec 32) := bindPointer (withStride s igm p p0i) "a".toList a

def name : Side → String | .f => "fd" | .g => "gd"
def root : Side → ArrayPointer → ArrayPointer → ArrayPointer | .f, fd, _ => fd | .g, _, gd => gd
def args : Side → List KeygenLevelCalls.Arg | .f => MakeFgGsShape194.fdArgs | .g => MakeFgGsShape194.gdArgs
def code (side : Side) : KeygenMakeFgSource.Stmt := .level (.call .inverse (args side))

structure Input (s : State) (fd gd igm : ArrayPointer) (u : Nat) (p p0i : BitVec 32) : Prop where
  uCell : USlot s "u" u
  tlenCell : USlot s "tlen" 335
  lognCell : Slot s "logn" 1
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  fdBinding : s.arrays "fd".toList=some fd
  gdBinding : s.arrays "gd".toList=some gd
  iBinding : s.arrays "igm".toList=some igm
  bound : u<335
  fdCapacity : fd.index+u ≤ fd.count
  gdCapacity : gd.index+u ≤ gd.count
  iCapacity : igm.index ≤ igm.count
  terCell : Slot s "ter" 1
  outCell : s.locals "out_ntt".toList=some (.int32,some (.int32 0))

theorem logn_expr (s : State) (cell : Slot s "logn" 1) :
    C99ArrayReference.scalar s MakeFgGsShape194.lognMinus1 (.uint32 0) :=
  .arithmetic .minus _ _ _ _ _ (.variable _ _ _ cell) (.literal .int32 1)
    (.step .minus (.uint32 1) (.int32 1) .uint32 rfl (.uint32 1) (.uint32 1) rfl rfl
      (by intro h; cases h))

theorem binding (side : Side) (s : State) (fd gd igm : ArrayPointer) (u : Nat) (p p0i : BitVec 32)
    (h : Input s fd gd igm u p p0i) :
    KeygenLevelCalls.Bind s (KeygenLevelCalls.params .inverse) (args side)
      (entry s (element (root side fd gd) u) igm p p0i) := by
  have ub : u<2^64 := by have b:=h.bound; omega
  have cap : (root side fd gd).index+u≤(root side fd gd).count := by
    cases side <;> first | exact h.fdCapacity | exact h.gdCapacity
  have rootBinding : s.arrays (name side).toList=some (root side fd gd) := by
    cases side <;> first | exact h.fdBinding | exact h.gdBinding
  have address : C99ArrayReference.Pointer s (name side).toList MakeFgGsShape194.varU
      (element (root side fd gd) u) :=
    .add _ _ _ _ (u64 u) rootBinding (.variable _ _ _ h.uCell)
      (by rw [KeygenNttLoopSupport.u64_integer u ub]; omega)
      (by rw [KeygenNttLoopSupport.u64_toNat u ub]; exact .within _ u cap)
  cases side <;> exact .pointer "a".toList _ _ _ _ _ _ address
    (.scalar .uint64 "stride".toList _ _ _ _ (u64 335) (.modular _ _ (.scalar _ _ (.variable _ _ _ h.tlenCell)))
      (.pointer "igm".toList "igm".toList C99ProcedureParser.zero igm _ _ _
        (RootBinding175.zero s "igm" igm h.iBinding (by simpa using h.iCapacity))
        (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 0) (.modular _ _ (.scalar _ _ (logn_expr s h.lognCell)))
          (.scalar .uint32 "full".toList _ _ _ _ (.int32 0) (.modular _ _ (.scalar _ _ (.literal .int32 0)))
            (.scalar .uint32 "p".toList _ _ _ _ (.uint32 p) (.modular _ _ (.scalar _ _ (.variable _ _ _ h.pCell)))
              (.scalar .uint32 "p0i".toList _ [] [] (empty s) (.uint32 p0i)
                (.modular _ _ (.scalar _ _ (.variable _ _ _ h.iCell))) .nil))))))

theorem call (side : Side) (s : State) (fd gd igm : ArrayPointer) (u : Nat) (p p0i : BitVec 32)
    (h : Input s fd gd igm u p p0i) : Exec (code side) s ⟨s,.normal⟩ := by
  let e := entry s (element (root side fd gd) u) igm p p0i
  have lc : Slot e "logn" 0 := by rfl
  have run := NinthInverseZero217.source e lc
  have callRun : KeygenLevelCalls.Call .inverse s (args side) s := by
    have actual := KeygenLevelCalls.Call.run e ⟨NinthInverseZero217.returned e,.returned none⟩
      (binding side s fd gd igm u p p0i h) run .voidReturn
    have same : {s with heap:=e.heap}=s := by cases s; rfl
    simpa only [NinthInverseZero217.heap,same] using actual
  exact .level _ _ _ (.call _ _ _ _ callRun)

theorem source (s : State) (fd gd igm : ArrayPointer) (u : Nat) (p p0i : BitVec 32)
    (h : Input s fd gd igm u p p0i) : Exec MakeFgTailShape190.s8 s ⟨s,.normal⟩ := by
  have pair : Exec (.seq MakeFgGsShape194.pairCallFd (.seq MakeFgGsShape194.pairCallGd KeygenMakeFgSource.skip)) s ⟨s,.normal⟩ :=
    .seqNormal _ _ s s _ (call .f s fd gd igm u p p0i h)
      (.seqNormal _ _ s s _ (call .g s fd gd igm u p p0i h) (SelectedStepAddPrime195.skip_run s))
  have yes : Exec MakeFgGsShape194.terYes8 s ⟨s,.normal⟩ := by
    rw [MakeFgGsShape194.terYes8_split,MakeFgGsShape194.pairFirst_shape,MakeFgGsShape194.pairRest_shape]
    exact MakeFgScope187.source _ _ _ pair
  have ternary : Exec MakeFgGsShape194.terBranch8 s ⟨s,.normal⟩ := by
    rw [MakeFgGsShape194.terBranch8_shape]
    exact .branchTrue _ _ _ _ _ (.uint32 1) (.variable _ _ _ h.terCell) (by decide) yes
  have outerYes : Exec MakeFgTailShape190.s8Yes s ⟨s,.normal⟩ := by
    rw [MakeFgGsShape194.s8Yes_shape,MakeFgGsShape194.inner8_shape]
    exact MakeFgScope187.source _ _ _ (.seqNormal _ _ s s _ ternary (SelectedStepAddPrime195.skip_run s))
  rw [MakeFgTailShape190.s8_shape]
  exact .branchTrue _ _ _ _ _ (.int32 1)
    (.logicalNot _ (.int32 0) (.variable _ _ _ h.outCell)) (by decide) outerYes

end FT1536.Source3.NinthOutputPair217
