import Source3.KeygenNttButterflyCalls
import Source3.KeygenMkgm3Table

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- B1.04 memory refinement. Each cell contains a canonical ordinary residue.
   The three contracts consume the existing source executions and retain
   the actual store order, including preservation of earlier output cells. -/
namespace FT1536.Source3.KeygenNttCells
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99ModularReference (Exec Stmt)
open KeygenSmallOutput (element)
open KeygenNttWordAlgebra (R value radix)
open KeygenNttButterflyAlgebra (Canonical)
open KeygenNttButterflyCalls (FCtx TCtx)

def Cell (heap : Memory) (p : ArrayPointer) (x : R) : Prop :=
  ∃ word, Load32 heap p word ∧ Canonical word ∧ value word=x
def Cells (heap : Memory) (p : ArrayPointer) (n : Nat) (a : Nat → R) : Prop :=
  ∀ i<n, Cell heap (element p i) (a i)
def Separate (p q : ArrayPointer) : Prop := KeygenMkgm3Layout.DisjointBytes p 4 q 4
def Preserves (before after : Memory) (positions : List ArrayPointer) : Prop :=
  ∀ q x, (∀ p∈positions, Separate p q) → Cell before q x → Cell after q x

theorem separate_symm {p q : ArrayPointer} (h : Separate p q) : Separate q p := by
  unfold Separate KeygenMkgm3Layout.DisjointBytes at *
  rcases h with h | h | h
  · exact Or.inl (Ne.symm h)
  · exact Or.inr (Or.inr h)
  · exact Or.inr (Or.inl h)

theorem elements_separate (p : ArrayPointer) (width : p.elementBytes=4) (i j : Nat)
    (different : i≠j) : Separate (element p i) (element p j) := by
  unfold Separate KeygenMkgm3Layout.DisjointBytes
  simp only [element,ArrayPointer.offset,width]
  omega

theorem read_cell (heap : Memory) (p : ArrayPointer) (x : R) (word : BitVec 32)
    (h : Cell heap p x) (read : Load32 heap p word) : Canonical word ∧ value word=x := by
  obtain ⟨actual,loaded,range,law⟩ := h
  have equal := Gate00Memory.load32_deterministic heap p word actual read loaded
  subst word
  exact ⟨range,law⟩

theorem store_cell (before after : Memory) (p : ArrayPointer) (word : BitVec 32) (x : R)
    (write : Store32 before p word after) (range : Canonical word) (law : value word=x) :
    Cell after p x := ⟨word,KeygenResidueStore.written_word before after p word write,range,law⟩

theorem store_preserves (before after : Memory) (p q : ArrayPointer) (word : BitVec 32) (x : R)
    (write : Store32 before p word after) (separate : Separate p q) (cell : Cell before q x) :
    Cell after q x := by
  obtain ⟨w,read,range,law⟩ := cell
  refine ⟨w,Gate00Memory.load32_transport before after q w read write.2.2.2.1 ?_,range,law⟩
  intro byte
  apply write.2.2.2.2.2.2
  have hb := byte.isLt
  unfold Separate KeygenMkgm3Layout.DisjointBytes at separate
  omega

theorem two_stores (before h1 after : Memory) (p1 p2 : ArrayPointer) (low high : BitVec 32)
    (x y : R) (separate : Separate p1 p2)
    (s1 : Store32 before p1 low h1) (s2 : Store32 h1 p2 high after)
    (hl : Canonical low ∧ value low=x) (hh : Canonical high ∧ value high=y) :
    Cell after p1 x ∧ Cell after p2 y ∧ Preserves before after [p1,p2] := by
  refine ⟨store_preserves h1 after p2 p1 high x s2 (separate_symm separate)
    (store_cell before h1 p1 low x s1 hl.1 hl.2),store_cell h1 after p2 high y s2 hh.1 hh.2,?_⟩
  intro q z hs hc
  exact store_preserves h1 after p2 q high z s2 (hs p2 (by simp))
    (store_preserves before h1 p1 q low z s1 (hs p1 (by simp)) hc)

theorem first (before : State) (out : Result) (p1 p2 : ArrayPointer)
    (w p0i : BitVec 32) (x y root : R)
    (ctx : FCtx "w" p1 p2 w p0i before) (separate : Separate p1 p2)
    (cx : Cell before.heap p1 x) (cy : Cell before.heap p2 y)
    (twiddle : Canonical w ∧ value w=radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody) before out) :
    out.flow=.normal ∧ Cell out.state.heap p1 (x+y*root) ∧
      Cell out.state.heap p2 (x+y-y*root) ∧ Preserves before.heap out.state.heap [p1,p2] := by
  obtain ⟨a,b,low,high,h1,h2,calls,la,lb,s1,s2,flow,heap⟩ :=
    KeygenNttButterflyCalls.first_calls before out p1 p2 w p0i ctx source
  obtain ⟨ha,va⟩ := read_cell before.heap p1 x a cx la
  obtain ⟨hb,vb⟩ := read_cell before.heap p2 y b cy lb
  obtain ⟨hl,hh,vl,vh⟩ := KeygenNttButterflyAlgebra.first_values a b w p0i low high root
    ha hb twiddle.1 initialization twiddle.2 calls
  rw [va,vb] at vl vh
  rw [heap]
  exact ⟨flow,two_stores before.heap h1 h2 p1 p2 low high _ _ separate s1 s2 ⟨hl,vl⟩ ⟨hh,vh⟩⟩

theorem binary (before : State) (out : Result) (p1 p2 : ArrayPointer)
    (tw p0i : BitVec 32) (x y root : R)
    (ctx : FCtx "s" p1 p2 tw p0i before) (separate : Separate p1 p2)
    (cx : Cell before.heap p1 x) (cy : Cell before.heap p2 y)
    (twiddle : Canonical tw ∧ value tw=radix*root)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody) before out) :
    out.flow=.normal ∧ Cell out.state.heap p1 (x+y*root) ∧
      Cell out.state.heap p2 (x-y*root) ∧ Preserves before.heap out.state.heap [p1,p2] := by
  obtain ⟨a,b,low,high,h1,h2,calls,la,lb,s1,s2,flow,heap⟩ :=
    KeygenNttButterflyCalls.binary_calls before out p1 p2 tw p0i ctx source
  obtain ⟨ha,va⟩ := read_cell before.heap p1 x a cx la
  obtain ⟨hb,vb⟩ := read_cell before.heap p2 y b cy lb
  obtain ⟨hl,hh,vl,vh⟩ := KeygenNttButterflyAlgebra.binary_values a b tw p0i low high root
    ha hb twiddle.1 initialization twiddle.2 calls
  rw [va,vb] at vl vh
  rw [heap]
  exact ⟨flow,two_stores before.heap h1 h2 p1 p2 low high _ _ separate s1 s2 ⟨hl,vl⟩ ⟨hh,vh⟩⟩

def quadratic (a b c z : R) : R := a+b*z+c*z^2

theorem triple (before : State) (out : Result) (p gm : ArrayPointer) (σ ρ : Nat)
    (w p0i : BitVec 32) (a b c root unity : R)
    (positive : 0<σ) (fit : 2*σ<2^64) (hρ : ρ<2^64) (width : p.elementBytes=4)
    (ctx : TCtx p gm σ ρ w p0i before)
    (ca : Cell before.heap p a) (cb : Cell before.heap (element p σ) b)
    (cc : Cell before.heap (element p (2*σ)) c)
    (table : ∃ x, Load32 before.heap (element gm ρ) x ∧ Canonical x ∧ value x=radix*root)
    (twiddle : Canonical w ∧ value w=radix*unity) (cube : unity^3=1)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody) before out) :
    out.flow=.normal ∧ Cell out.state.heap p (quadratic a b c root) ∧
      Cell out.state.heap (element p σ) (quadratic a b c (root*unity)) ∧
      Cell out.state.heap (element p (2*σ)) (quadratic a b c (root*unity^2)) ∧
      Preserves before.heap out.state.heap [p,element p σ,element p (2*σ)] := by
  obtain ⟨x,aw,bw,cw,o0,o1,o2,h1,h2,h3,calls,lx,la,lb,lc,s0,s1,s2,flow,heap⟩ :=
    KeygenNttButterflyCalls.triple_calls before out p gm σ ρ w p0i (by omega) fit hρ ctx source
  obtain ⟨xt,lt,ht,vt⟩ := table
  have he := Gate00Memory.load32_deterministic before.heap (element gm ρ) x xt lx lt
  subst xt
  obtain ⟨ha,va⟩ := read_cell before.heap p a aw ca la
  obtain ⟨hb,vb⟩ := read_cell before.heap (element p σ) b bw cb lb
  obtain ⟨hc,vc⟩ := read_cell before.heap (element p (2*σ)) c cw cc lc
  obtain ⟨h0,h1c,h2c,v0,v1,v2⟩ := KeygenNttButterflyAlgebra.triple_values aw bw cw x w p0i
    o0 o1 o2 root unity ha hb hc ht twiddle.1 initialization vt twiddle.2 cube calls
  rw [va,vb,vc] at v0 v1 v2
  have sep01 : Separate p (element p σ) := by
    simpa only [element,Nat.add_zero] using elements_separate p width 0 σ (by omega)
  have sep02 : Separate p (element p (2*σ)) := by
    simpa only [element,Nat.add_zero] using elements_separate p width 0 (2*σ) (by omega)
  have sep12 := elements_separate p width σ (2*σ) (by omega)
  have c0 := store_cell before.heap h1 p o0 (quadratic a b c root) s0 h0 v0
  have c1 := store_cell h1 h2 (element p σ) o1 (quadratic a b c (root*unity)) s1 h1c v1
  have c2 := store_cell h2 h3 (element p (2*σ)) o2 (quadratic a b c (root*unity^2)) s2 h2c v2
  rw [heap]
  refine ⟨flow,store_preserves h2 h3 _ p o2 _ s2 (separate_symm sep02)
    (store_preserves h1 h2 _ p o1 _ s1 (separate_symm sep01) c0),
    store_preserves h2 h3 _ _ o2 _ s2 (separate_symm sep12) c1,c2,?_⟩
  intro q z hs cz
  exact store_preserves h2 h3 _ q o2 z s2 (hs _ (by simp [element]))
    (store_preserves h1 h2 _ q o1 z s1 (hs _ (by simp [element]))
      (store_preserves before.heap h1 p q o0 z s0 (hs _ (by simp)) cz))

/- The NTT's counter and pointer-only seams do not write memory. This
   recognizer is separate from the existing arrays-preserving frame. -/
def heapControl : Stmt → Bool
  | .base .skip | .base (.scalar _) | .base (.bindPtr _ _ _) | .base (.declarePtr _)
    | .assign _ _ => true
  | .seq a b => heapControl a && heapControl b
  | .scope _ body => heapControl body
  | _ => false

theorem control_heap (code : Stmt) (before : State) (out : Result)
    (source : Exec code before out) (checked : heapControl code=true) :
    out.state.heap=before.heap := by
  induction source with
  | base code before after execution =>
      cases execution
      all_goals first | rfl | cases checked
  | assign => rfl
  | seqNormal a b before middle out head tail ih1 ih2 =>
      have h := Bool.and_eq_true_iff.mp checked
      exact (ih2 h.2).trans (ih1 h.1)
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope names body before result inner ih => exact ih checked
  | store32 | storeRev | branchTrue | branchFalse | loopFalse | loopNormal | loopReturn | ret | retVoid =>
      cases checked

end FT1536.Source3.KeygenNttCells
