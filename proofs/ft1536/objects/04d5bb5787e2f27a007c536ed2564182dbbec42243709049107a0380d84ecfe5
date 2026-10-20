import Source3.KeygenMkgm3Counters

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMkgm3Loops
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer)
open KeygenMkgm3Program
open KeygenMkgm3Atoms
open KeygenMkgm3Control (frame Hoare hoare_loop)
open KeygenMkgm3Counters
open KeygenMkgm3LastRow (Context PairUpdates)
open KeygenMkgm3Upward (Pointers)
open KeygenMkgm3Table (Cell)
open KeygenMkgm3Indices (lastIndex)
open KeygenMkgm3Rows (exponent)
open KeygenNttLoopSupport (USlot)
open KeygenNttButterflyCalls (U32Slot)

def Filled (heap : C99MemoryReference.Memory) (gm : ArrayPointer) (lo : Nat) : Prop :=
  ∀ j<1024, lo ≤ j → Cell heap gm j

theorem advance_word (s : State) (name : String) (e i : Nat) (ne : name≠"u") (h : Word s name e) :
    Word (advanced s i) name e := by
  obtain ⟨w,slot,law⟩ := h
  refine ⟨w,?_,law⟩
  change (if name.toList="u".toList then _ else s.locals name.toList)=_
  split_ifs with h
  · exact (ne (String.toList_inj.mp h)).elim
  · exact slot

theorem advance_context (s : State) (i : Nat) (p0i : BitVec 32) (gm igm rev : ArrayPointer)
    (h : Context p0i gm igm rev s) : Context p0i gm igm rev (advanced s i) := by
  refine ⟨?_,⟨h.pointers.forward,h.pointers.inverse⟩,h.table,?_,?_,advance_word s "g2" 2 i (by decide) h.g2,
    advance_word s "g4" 4 i (by decide) h.g4⟩
  · simpa [Params,U32Slot,advanced,C99ArrayReference.bindValue,C99ScalarReference.set] using h.params
  · simpa [U32Slot,advanced,C99ArrayReference.bindValue,C99ScalarReference.set] using h.k
  · simpa [USlot,advanced,C99ArrayReference.bindValue,C99ScalarReference.set] using h.b

def LastInv (p0i : BitVec 32) (gm igm rev : ArrayPointer) (s : State) : Prop :=
  Context p0i gm igm rev s ∧ ∃ j, j ≤ 256 ∧ USlot s "u" (2*j) ∧ Word s "x" (exponent (2*j)) ∧
    ∀ u<2*j, Cell s.heap gm (lastIndex u)
def lastLoop : Stmt := .loop (.cmp .lt (var "u") (var "b")) (.scope [] lastRowBody)
  (.base (.scalar (.update "u".toList .add (num 2))))

theorem last_progress (gm : ArrayPointer) (j : Nat) (hj : j<256)
    (before after : C99MemoryReference.Memory)
    (old : ∀ u<2*j, Cell before gm (lastIndex u)) (step : PairUpdates gm (2*j) before after) :
    ∀ u<2*(j+1), Cell after gm (lastIndex u) := by
  intro u hu
  by_cases h0 : u=2*j
  · subst u; exact step.1
  by_cases h1 : u=2*j+1
  · subst u; exact step.2.1
  have earlier : u<2*j := by omega
  apply step.2.2 (lastIndex u) (KeygenMkgm3Table.last_range u (by omega)).2
  · intro h
    exact h0 (KeygenMkgm3Table.last_injective (2*j) u (by omega) (by omega) h).symm
  · intro h
    exact h1 (KeygenMkgm3Table.last_injective (2*j+1) u (by omega) (by omega) h).symm
  · exact old u earlier

theorem last_loop (p0i : BitVec 32) (gm igm rev : ArrayPointer)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i)) :
    Hoare lastLoop (LastInv p0i gm igm rev) (fun s => Filled s.heap gm 512 ∧ USlot s "u" 512) := by
  apply hoare_loop _ _ _ _ _ _ _ (by decide)
  · intro before out v invariant guard nonzero source
    obtain ⟨ctx,j,hj,counter,x,filled⟩ := invariant
    have test := less_value before (var "b") (2*j) 512 v (by omega) (by decide) counter
      (fun w h => KeygenNttLoopSupport.variable_u64 before "b" 512 w ctx.b h) guard
    have strict : j<256 := by have := boolean_true _ v test nonzero; omega
    cases source with
    | seqNormal _ _ _ middle _ body update =>
        obtain ⟨inner,body0,hm⟩ := KeygenNttLoopSupport.scope_result _ _ before ⟨middle,.normal⟩ body
        have result := KeygenMkgm3LastRow.body_result before inner p0i gm igm rev j strict ctx counter
          gw iw separate initialization x body0
        have xm : Word middle "x" (exponent (2*(j+1))) := by
          have hs := congrArg Result.state hm
          change middle=inner.state at hs
          rw [hs]
          exact result.1
        have cells : PairUpdates gm (2*j) before.heap middle.heap := by
          have hs := congrArg Result.state hm
          change middle=inner.state at hs
          rw [hs]
          exact result.2
        have ctxm := KeygenMkgm3LastRow.context_after _ before ⟨middle,.normal⟩ p0i gm igm rev ctx
          (by decide) (by decide) body
        have um := KeygenMkgm3Upward.counter_after _ before ⟨middle,.normal⟩ (2*j)
          (by decide) (by decide) counter body
        have hout := increment_two middle out (2*j) (by omega) um update
        rw [hout]
        refine ⟨rfl,advance_context middle (2*j+2) p0i gm igm rev ctxm,j+1,by omega,?_,?_,?_⟩
        · convert advanced_counter middle (2*j+2) (by omega) using 1
        · exact advance_word middle "x" _ _ (by decide) xm
        · exact last_progress gm j strict _ _ filled cells
    | seqExit _ _ _ _ body exit => exact (exit (frame _ before out (by decide) body).1).elim
  · intro before v invariant guard zero
    obtain ⟨ctx,j,hj,counter,_,filled⟩ := invariant
    have test := less_value before (var "b") (2*j) 512 v (by omega) (by decide) counter
      (fun w h => KeygenNttLoopSupport.variable_u64 before "b" 512 w ctx.b h) guard
    have eq : j=256 := by have := boolean_false _ v test zero; omega
    subst j
    refine ⟨?_,counter⟩
    intro i hi hlo
    obtain ⟨u,hu,he⟩ := KeygenMkgm3Table.last_covers i hlo hi
    rw [← he]
    exact filled u hu

structure Common (p0i : BitVec 32) (gm igm : ArrayPointer) (s : State) : Prop where
  params : Params s p0i
  pointers : Pointers s gm igm
  k : U32Slot s "k" 8

theorem common_same (p0i : BitVec 32) (gm igm : ArrayPointer) (s t : State)
    (locals : t.locals=s.locals) (arrays : t.arrays=s.arrays) (h : Common p0i gm igm s) : Common p0i gm igm t := by
  refine ⟨?_,⟨?_,?_⟩,?_⟩
  · simpa only [Params,U32Slot,locals] using h.params
  · rw [arrays]; exact h.pointers.forward
  · rw [arrays]; exact h.pointers.inverse
  · simpa only [U32Slot,locals] using h.k

theorem advance_common (s : State) (i : Nat) (p0i : BitVec 32) (gm igm : ArrayPointer)
    (h : Common p0i gm igm s) : Common p0i gm igm (advanced s i) := by
  refine ⟨?_,⟨h.pointers.forward,h.pointers.inverse⟩,?_⟩
  · simpa [Params,U32Slot,advanced,C99ArrayReference.bindValue,C99ScalarReference.set] using h.params
  · simpa [U32Slot,advanced,C99ArrayReference.bindValue,C99ScalarReference.set] using h.k

def CubeInv (p0i : BitVec 32) (gm igm : ArrayPointer) (s : State) : Prop :=
  Common p0i gm igm s ∧ ∃ i, 256 ≤ i ∧ i ≤ 512 ∧ USlot s "u" i ∧
    ∀ j<1024, 512 ≤ j ∨ (256 ≤ j ∧ j < i) → Cell s.heap gm j
def cubeInner : Stmt := .loop (.cmp .lt (var "u") cubeLimit) cubeBody (inc "u")

theorem cube_loop (p0i : BitVec 32) (gm igm : ArrayPointer)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i)) :
    Hoare cubeInner (CubeInv p0i gm igm) (fun s => Filled s.heap gm 256 ∧ USlot s "u" 512) := by
  apply hoare_loop _ _ _ _ _ _ _ (by decide)
  · intro before out v invariant guard nonzero source
    obtain ⟨ctx,i,lo,hi,counter,filled⟩ := invariant
    have test := less_value before cubeLimit i 512 v (by omega) (by decide) counter
      (fun w h => cube_limit before w ctx.k h) guard
    have strict := boolean_true _ v test nonzero
    cases source with
    | seqNormal _ _ _ middle _ body update =>
        obtain ⟨_,locals,arrays,cells⟩ := KeygenMkgm3Upward.cube_body before ⟨middle,.normal⟩ gm igm p0i i lo strict
          gw iw separate ctx.pointers counter ctx.params initialization (filled (2*i) (by omega) (Or.inl (by omega))) body
        have ctxm := common_same p0i gm igm before middle locals arrays ctx
        change middle.locals=before.locals at locals
        have um : USlot middle "u" i := by simpa only [USlot,locals] using counter
        rw [increment_one middle out i (by omega) um update]
        refine ⟨rfl,advance_common middle (i+1) p0i gm igm ctxm,i+1,by omega,by omega,
          advanced_counter middle (i+1) (by omega),?_⟩
        intro j hj hfill
        by_cases eq : j=i
        · subst j; exact cells.1
        · exact cells.2 j hj (Ne.symm eq) (filled j hj (by omega))
    | seqExit _ _ _ _ body exit => exact (exit (frame _ before out (by decide) body).1).elim
  · intro before v invariant guard zero
    obtain ⟨ctx,i,lo,hi,counter,filled⟩ := invariant
    have test := less_value before cubeLimit i 512 v (by omega) (by decide) counter
      (fun w h => cube_limit before w ctx.k h) guard
    have eq : i=512 := by have := boolean_false _ v test zero; omega
    subst i
    refine ⟨?_,counter⟩
    intro j hj hlo
    exact filled j hj (by omega)

def SquareInv (p0i : BitVec 32) (gm igm : ArrayPointer) (s : State) : Prop :=
  Common p0i gm igm s ∧ ∃ i, i ≤ 255 ∧ USlot s "u" i ∧ ∀ j<1024, i<j → Cell s.heap gm j
def squareInner : Stmt := .loop (.cmp .gt (var "u") (num 0)) squareBody (dec "u")

theorem square_loop (p0i : BitVec 32) (gm igm : ArrayPointer)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i)) :
    Hoare squareInner (SquareInv p0i gm igm) (fun s => Filled s.heap gm 1 ∧ USlot s "u" 0) := by
  apply hoare_loop _ _ _ _ _ _ _ (by decide)
  · intro before out v invariant guard nonzero source
    obtain ⟨ctx,i,hi,counter,filled⟩ := invariant
    have positive := boolean_true _ v (positive_value before i v (by omega) counter guard) nonzero
    cases source with
    | seqNormal _ _ _ middle _ body update =>
        obtain ⟨_,locals,arrays,cells⟩ := KeygenMkgm3Upward.square_body before ⟨middle,.normal⟩ gm igm p0i i positive
          (by omega) gw iw separate ctx.pointers counter ctx.params initialization (filled (2*i) (by omega) (by omega)) body
        have ctxm := common_same p0i gm igm before middle locals arrays ctx
        change middle.locals=before.locals at locals
        have um : USlot middle "u" i := by simpa only [USlot,locals] using counter
        rw [decrement_one middle out i (by omega) positive um update]
        refine ⟨rfl,advance_common middle (i-1) p0i gm igm ctxm,i-1,by omega,
          advanced_counter middle (i-1) (by omega),?_⟩
        intro j hj hfill
        by_cases eq : j=i
        · subst j; exact cells.1
        · exact cells.2 j hj (Ne.symm eq) (filled j hj (by omega))
    | seqExit _ _ _ _ body exit => exact (exit (frame _ before out (by decide) body).1).elim
  · intro before v invariant guard zero
    obtain ⟨ctx,i,hi,counter,filled⟩ := invariant
    have eq : i=0 := by have := boolean_false _ v (positive_value before i v (by omega) counter guard) zero; omega
    subst i
    refine ⟨?_,counter⟩
    intro j hj hlo
    exact filled j hj hlo

end FT1536.Source3.KeygenMkgm3Loops
