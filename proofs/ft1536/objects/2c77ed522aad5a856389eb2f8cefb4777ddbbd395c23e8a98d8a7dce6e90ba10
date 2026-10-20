import Source3.KeygenPublicTableStore
import Source3.KeygenMkgm3Table

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicLastBody
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt chain)
open KeygenPublicTableControl (supported writes frame seq_inv)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableStore
open KeygenPublicLastProgram (store advance u nextU)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicRoots (root)
open KeygenMkgm3Rows (exponent)
open KeygenMkgm3Indices (lastIndex)

structure Fixed (gm igm : ArrayPointer) (s : State) : Prop where
  pointers : Pointers s gm igm
  k : Slot s "k" 1
  b : USlot s "b" 512
  g2 : Word s "g2" (root^2)
  g4 : Word s "g4" (root^4)
  ig2 : Word s "ig2" ((root⁻¹)^2)
  ig4 : Word s "ig4" ((root⁻¹)^4)
theorem fixed_after (code : Stmt) (s : State) (out : Result) (gm igm : ArrayPointer)
    (ctx : Fixed gm igm s) (ok : supported code=true)
    (limited : writes code ⊆ ["x".toList,"ix".toList,"u".toList])
    (source : Exec KeygenPublicSource.program [] code s out) : Fixed gm igm out.state := by
  have keep (n : C99ArrayReference.Name) (h : n∉["x".toList,"ix".toList,"u".toList]) : n∉writes code := fun hn => h (limited hn)
  have hf := (frame _ _ code s out ok source).2.2
  exact ⟨pointers_after code s out gm igm ok ctx.pointers source,
    (hf _ (keep _ (by decide))).trans ctx.k,(hf _ (keep _ (by decide))).trans ctx.b,
    word_after code s out _ _ ok (keep _ (by decide)) ctx.g2 source,
    word_after code s out _ _ ok (keep _ (by decide)) ctx.g4 source,
    word_after code s out _ _ ok (keep _ (by decide)) ctx.ig2 source,
    word_after code s out _ _ ok (keep _ (by decide)) ctx.ig4 source⟩
theorem counter_after (code : Stmt) (s : State) (out : Result) (i : Nat)
    (counter : USlot s "u" i) (ok : supported code=true) (keep : "u".toList∉writes code)
    (source : Exec KeygenPublicSource.program [] code s out) : USlot out.state "u" i :=
  ((frame _ _ code s out ok source).2.2 _ keep).trans counter

def halfSteps (e : CLogic.Expr) (factor inverseFactor : String) : List Stmt :=
  [store "gm" "x" e,store "igm" "ix" e,advance "x" factor,advance "ix" inverseFactor]
def half (e : CLogic.Expr) (factor inverseFactor : String) : Stmt := chain (halfSteps e factor inverseFactor)
theorem half_supported (e : CLogic.Expr) (a b : String) : supported (half e a b)=true := rfl
theorem half_writes (e : CLogic.Expr) (a b : String) : writes (half e a b)=["x".toList,"ix".toList] := rfl

theorem stores (s middle after : State) (gm igm : ArrayPointer) (i : Nat) (hi : i<512)
    (e : CLogic.Expr) (a b : KeygenPublicAlgebra.R) (ctx : Fixed gm igm s)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (x : Word s "x" a) (ix : Word s "ix" b)
    (input : ∀ v, KeygenPublicWord.scalar s e v → v=u64 i)
    (first : Exec KeygenPublicSource.program [] (store "gm" "x" e) s ⟨middle,.normal⟩)
    (second : Exec KeygenPublicSource.program [] (store "igm" "ix" e) middle ⟨after,.normal⟩) :
    PairUpdate gm igm (lastIndex i) a b s.heap after.heap ∧ LastFrame gm igm s.heap after.heap := by
  obtain ⟨w,scaled,write⟩ := source_store s ⟨middle,.normal⟩ "gm" "x" e gm i hi a
    ctx.pointers.1 ctx.k ctx.b input x first
  have cm := fixed_after _ s ⟨middle,.normal⟩ gm igm ctx rfl (by simp [writes,store]) first
  have ixm := word_after _ s ⟨middle,.normal⟩ "ix" b rfl (by simp [writes,store]) ix first
  have locals : middle.locals=s.locals := by
    funext n
    exact (frame _ _ _ s ⟨middle,.normal⟩ rfl first).2.2 n (by simp [writes,store])
  have inputm : ∀ v, KeygenPublicWord.scalar middle e v → v=u64 i := by
    intro v hv
    exact input v (by simpa only [KeygenPublicWord.scalar,locals] using hv)
  obtain ⟨w',scaled',write'⟩ := source_store middle ⟨after,.normal⟩ "igm" "ix" e igm i hi b
    cm.pointers.2 cm.k cm.b inputm ixm second
  have bounds := KeygenMkgm3Table.last_range i hi
  exact ⟨paired_writes s.heap middle.heap after.heap gm igm gw iw separate (lastIndex i)
    bounds.2 w w' a b scaled scaled' write write',
    frame_trans gm igm _ _ _
      (last_write_frame gm igm gm (by simp) gw _ bounds.1 bounds.2 _ _ _ write)
      (last_write_frame gm igm igm (by simp) iw _ bounds.1 bounds.2 _ _ _ write')⟩

theorem half_result (s : State) (out : Result) (gm igm : ArrayPointer)
    (i exponent step : Nat) (hi : i<512) (e : CLogic.Expr) (factor inverseFactor : String)
    (inverseDistinct : inverseFactor≠"x") (ctx : Fixed gm igm s)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (x : Word s "x" (root^exponent)) (ix : Word s "ix" ((root⁻¹)^exponent))
    (g : Word s factor (root^step)) (ig : Word s inverseFactor ((root⁻¹)^step))
    (input : ∀ v, KeygenPublicWord.scalar s e v → v=u64 i)
    (source : Exec KeygenPublicSource.program [] (half e factor inverseFactor) s out) :
    Word out.state "x" (root^(exponent+step)) ∧ Word out.state "ix" ((root⁻¹)^(exponent+step)) ∧
      PairUpdate gm igm (lastIndex i) (root^exponent) ((root⁻¹)^exponent) s.heap out.state.heap ∧
      LastFrame gm igm s.heap out.state.heap := by
  obtain ⟨s1,first,tail1⟩ := seq_inv _ _ s out rfl source
  obtain ⟨s2,second,tail2⟩ := seq_inv _ _ s1 out rfl tail1
  obtain ⟨s3,mul,tail3⟩ := seq_inv _ _ s2 out rfl tail2
  obtain ⟨s4,imul,tail4⟩ := seq_inv _ _ s3 out rfl tail3
  have x1 := word_after _ s ⟨s1,.normal⟩ "x" _ rfl (by simp [writes,store]) x first
  have x2 := word_after _ s1 ⟨s2,.normal⟩ "x" _ rfl (by simp [writes,store]) x1 second
  have ix1 := word_after _ s ⟨s1,.normal⟩ "ix" _ rfl (by simp [writes,store]) ix first
  have ix2 := word_after _ s1 ⟨s2,.normal⟩ "ix" _ rfl (by simp [writes,store]) ix1 second
  have g1 := word_after _ s ⟨s1,.normal⟩ factor _ rfl (by simp [writes,store]) g first
  have g2 := word_after _ s1 ⟨s2,.normal⟩ factor _ rfl (by simp [writes,store]) g1 second
  have ig1 := word_after _ s ⟨s1,.normal⟩ inverseFactor _ rfl (by simp [writes,store]) ig first
  have ig2 := word_after _ s1 ⟨s2,.normal⟩ inverseFactor _ rfl (by simp [writes,store]) ig1 second
  have ig3 := word_after _ s2 ⟨s3,.normal⟩ inverseFactor _ rfl
    (by simpa [writes,advance] using fun h => inverseDistinct (String.toList_injective h)) ig2 mul
  have ix3 := word_after _ s2 ⟨s3,.normal⟩ "ix" _ rfl (by simp [writes,advance]) ix2 mul
  have x3 := advance_word s2 ⟨s3,.normal⟩ "x" factor _ _ x2 g2 mul
  have x4 := word_after _ s3 ⟨s4,.normal⟩ "x" _ rfl (by simp [writes,advance]) x3 imul
  have ix4 := advance_word s3 ⟨s4,.normal⟩ "ix" inverseFactor _ _ ix3 ig3 imul
  have image := stores s s1 s2 gm igm i hi e _ _ ctx gw iw separate x ix input first second
  have heap : s4.heap=s2.heap :=
    (KeygenPublicTableControl.assign_heap _ _ s3 _ imul).trans (KeygenPublicTableControl.assign_heap _ _ s2 _ mul)
  cases tail4
  exact ⟨by simpa only [pow_add] using x4,by simpa only [pow_add] using ix4,by simpa only [heap] using image⟩

theorem split_prepend (codes : List Stmt) (tail : Stmt) (s : State) (out : Result)
    (ok : ∀ c∈codes, supported c=true)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicTableSeed.prepend codes tail) s out) :
    ∃ middle, Exec KeygenPublicSource.program [] (chain codes) s ⟨middle,.normal⟩ ∧
      Exec KeygenPublicSource.program [] tail middle out := by
  induction codes generalizing s with
  | nil => exact ⟨s,.skip s,source⟩
  | cons c cs ih =>
      obtain ⟨next,first,rest⟩ := seq_inv c _ s out (ok c (by simp)) source
      obtain ⟨middle,head,tail⟩ := ih next (fun d hd => ok d (by simp [hd])) rest
      exact ⟨middle,.seqNormal c (chain cs) s next ⟨middle,.normal⟩ first head,tail⟩

def PairImages (gm igm : ArrayPointer) (i : Nat) (before after : Memory) : Prop :=
  (∀ p∈[gm,igm], ∀ j<1024, lastIndex i≠j → lastIndex (i+1)≠j →
    ∀ z, KeygenPublicTableCells.Cell before p j z → KeygenPublicTableCells.Cell after p j z) ∧
  KeygenPublicTableCells.Cell after gm (lastIndex i) (root^exponent i) ∧
  KeygenPublicTableCells.Cell after igm (lastIndex i) ((root⁻¹)^exponent i) ∧
  KeygenPublicTableCells.Cell after gm (lastIndex (i+1)) (root^exponent (i+1)) ∧
  KeygenPublicTableCells.Cell after igm (lastIndex (i+1)) ((root⁻¹)^exponent (i+1))
theorem pair_images (gm igm : ArrayPointer) (i : Nat) (hi : i+1<512) (before middle after : Memory)
    (first : PairUpdate gm igm (lastIndex i) (root^exponent i) ((root⁻¹)^exponent i) before middle)
    (second : PairUpdate gm igm (lastIndex (i+1)) (root^exponent (i+1)) ((root⁻¹)^exponent (i+1)) middle after) :
    PairImages gm igm i before after := by
  have ne : lastIndex (i+1)≠lastIndex i := by
    intro equal
    have := KeygenMkgm3Table.last_injective (i+1) i hi (by omega) equal
    omega
  refine ⟨?_,second.1.2 _ (KeygenMkgm3Table.last_range i (by omega)).2 ne _ first.1.1,
    second.2.2 _ (KeygenMkgm3Table.last_range i (by omega)).2 ne _ first.2.1,second.1.1,second.2.1⟩
  intro p hp j hj h1 h2 z old
  rcases List.mem_cons.mp hp with rfl | hp
  · exact second.1.2 j hj h2 z (first.1.2 j hj h1 z old)
  · have equal := List.mem_singleton.mp hp
    subst p
    exact second.2.2 j hj h2 z (first.2.2 j hj h1 z old)

theorem body_result (s : State) (out : Result) (gm igm : ArrayPointer) (j : Nat) (hj : j<256)
    (ctx : Fixed gm igm s) (counter : USlot s "u" (2*j))
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (x : Word s "x" (root^exponent (2*j))) (ix : Word s "ix" ((root⁻¹)^exponent (2*j)))
    (source : Exec KeygenPublicSource.program [] KeygenPublicLastProgram.body s out) :
    Word out.state "x" (root^exponent (2*(j+1))) ∧ Word out.state "ix" ((root⁻¹)^exponent (2*(j+1))) ∧
      PairImages gm igm (2*j) s.heap out.state.heap ∧ LastFrame gm igm s.heap out.state.heap := by
  obtain ⟨middle,first,second⟩ := split_prepend (halfSteps u "g4" "ig4") (half nextU "g2" "ig2") s out
    (by intro c hc; simp only [halfSteps,List.mem_cons,List.not_mem_nil,or_false] at hc
        rcases hc with rfl | rfl | rfl | rfl <;> rfl) source
  obtain ⟨xm,ixm,im,fm⟩ := half_result s ⟨middle,.normal⟩ gm igm (2*j) (exponent (2*j)) 4 (by omega)
    u "g4" "ig4" (by decide) ctx gw iw separate x ix ctx.g4 ctx.ig4
    (KeygenPublicTableIndex.variable64 s "u" (2*j) · counter) first
  change Exec KeygenPublicSource.program [] (half u "g4" "ig4") s ⟨middle,.normal⟩ at first
  have cm := fixed_after _ s ⟨middle,.normal⟩ gm igm ctx rfl (by rw [half_writes]; simp) first
  have um := counter_after _ s ⟨middle,.normal⟩ (2*j) counter rfl (by rw [half_writes]; decide) first
  have odd : exponent (2*j)+4=exponent (2*j+1) := by
    rw [KeygenMkgm3Rows.exponent_even,KeygenMkgm3Rows.exponent_odd]
  rw [odd] at xm ixm
  obtain ⟨xo,ixo,io,fo⟩ := half_result middle out gm igm (2*j+1) (exponent (2*j+1)) 2 (by omega)
    nextU "g2" "ig2" (by decide) cm gw iw separate xm ixm cm.g2 cm.ig2
    (KeygenPublicTableIndex.next_value middle (2*j) (by omega) · um) second
  have next : exponent (2*j+1)+2=exponent (2*(j+1)) := by
    rw [KeygenMkgm3Rows.exponent_odd,KeygenMkgm3Rows.exponent_even]
    omega
  rw [next] at xo ixo
  exact ⟨xo,ixo,pair_images gm igm (2*j) (by omega) _ _ _ im io,frame_trans gm igm _ _ _ fm fo⟩

end FT1536.Source3.KeygenPublicLastBody
