import Source3.KeygenMakeInvocation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE `ske` cell history and the derived call-site liveness of the
   B1.07 source tie. The 061 shape of `small_site_material` carried the
   side condition `site.src.block∈env.live` as an explicit hypothesis. The
   liveness is now DERIVED (`small_site_src_live`) from two facts:

   * the write-then-read history of the `ske` cells -- the `SkeCellWord`
     class below, CREATED by the executed `ske[i]=...` pointer-array store
     (`ske_word_of_bind`, the `Head.bindSke` step of the encoding tail)
     and TRANSPORTED across every foreign-cell store
     (`ske_word_of_store_frame` over the byte-extent store frame);
   * the pinned explicit live-set extension of the 061 module ("consumers
     needing a further block extend the live set explicitly"): the map
     legality is taken on `site.src.block::env.live`, so the word
     round-trip decides the read pointer and the liveness FOLLOWS
     (`small_site_src_live`, `small_site_material_extended`).

   Word-level aliasing outside the live set is real: `VirtualLegal` leaves
   such blocks unconstrained, so no consumer may decode a pointer word
   into a non-live block without extending the legality domain -- this is
   exactly why the extension is explicit and not hidden. The extension
   class is achievable (`KeygenMakeInvocation.virtualLegal_identity`/
   `virtualLegal_exists` on the extended list).

   The remaining extraction of `SkeCellWord` along the concrete
   statement-chain of the tail (the nine pre-loop statements reaching the
   four-segment loop entry) and the persistence of the cell words through
   the earlier codec calls of segments 1-3 (the codec write-frame item)
   stay with the named B1.08 obligations; no codec outcome, exact encoded
   length or codec write frame is a premise here. Not a review, not a
   codec claim and not a law claim. -/
namespace FT1536.Source3.KeygenMakeSkeCells
open C99ArrayReference (State Name)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenMakeInvocation (Env SmallSite VirtualLegal skeElem skeName inputOf wordOf WritePointer
  load64_of_store canonical_word_eq input_canonical inputOf_mem_live virtualLegal_exists
  skeElem_offset)

/-! ## 1. The ske-cell word history -/

/-- The write-then-read content of the `ske` cell of segment `i`: the cell
    holds the LP64 object representation of the material pointer of that
    segment. The class is created by the executed `ske[i]` store and is
    the "ske cell history" input of the call-site liveness. -/
def SkeCellWord (env : Env) (i : Fin 4) (s : State) : Prop :=
  Load64 s.heap (skeElem env i) (wordOf env.vb (inputOf env i))

/-- A 64-bit load survives any store whose byte extent misses the loaded
    cell (the byte-extent store frame of `Store64`). -/
theorem load64_of_store_frame (before after : Memory) (p q : ArrayPointer) (w w' : BitVec 64)
    (load : Load64 before p w) (store : Store64 before q w' after)
    (disjoint : q.block≠p.block ∨ q.offset+8≤p.offset ∨ p.offset+8≤q.offset) :
    Load64 after p w := by
  cases load with
  | load b allocated typeSize initialized =>
    obtain ⟨_,_,_,same,_,_,frame⟩ := store
    refine Load64.load after p b ?_ typeSize ?_
    · obtain ⟨positive,aligned,inside,extent,bounded⟩ := allocated
      refine ⟨positive,aligned,inside,?_,?_⟩
      · rw [same]; exact extent
      · rw [same]; exact bounded
    · intro i
      have hi := i.isLt
      have preserved : after.bytes p.block (p.offset+i.val)=before.bytes p.block (p.offset+i.val) :=
        frame p.block (p.offset+i.val) (by
          rcases disjoint with block | earlier | later
          · exact Or.inl (Ne.symm block)
          · exact Or.inr (Or.inr (by omega))
          · exact Or.inr (Or.inl (by omega)))
      rw [preserved]
      exact initialized i

/-- The byte extents of two distinct `ske` cells are disjoint (the cells
    sit at `8*i` in the same ske block). -/
theorem skeElem_disjoint (env : Env) (i j : Fin 4) (different : i.val≠j.val) :
    (skeElem env j).block≠(skeElem env i).block ∨
      (skeElem env j).offset+8≤(skeElem env i).offset ∨
      (skeElem env i).offset+8≤(skeElem env j).offset := by
  right
  rcases Nat.lt_or_gt_of_ne different with earlier | later
  · right
    rw [skeElem_offset,skeElem_offset]
    omega
  · left
    rw [skeElem_offset,skeElem_offset]
    omega

/-- THE store creation of the cell history: the executed `ske[i]` store of
    the tail writes the material pointer of segment `i` into the cell, so
    the cell word holds at the post-store state (`Head.bindSke` with the
    material cell of the `TailCells` class). -/
theorem ske_word_of_bind (env : Env) (i : Fin 4) (s : State) (after : Memory) (src : ArrayPointer)
    (material : s.arrays (skeName i)=some (inputOf env i))
    (cell : s.arrays (skeName i)=some src)
    (store : WritePointer env.vb s.heap (skeElem env i) src after) :
    SkeCellWord env i {s with heap := after} := by
  have same : src=inputOf env i := Option.some.inj (cell.symm.trans material)
  subst same
  exact load64_of_store s.heap after (skeElem env i) (wordOf env.vb (inputOf env i)) store.2

/-- THE store-frame transport of the cell history: a foreign `ske` store
    (a different segment's cell) leaves the cell word untouched. -/
theorem ske_word_of_store_frame (env : Env) (i j : Fin 4) (s : State) (src : ArrayPointer)
    (after : Memory) (different : i.val≠j.val) (word : SkeCellWord env i s)
    (store : WritePointer env.vb s.heap (skeElem env j) src after) :
    SkeCellWord env i {s with heap := after} :=
  load64_of_store_frame s.heap after (skeElem env i) (skeElem env j)
    (wordOf env.vb (inputOf env i)) (wordOf env.vb src) word store.2
    (skeElem_disjoint env i j different)

/-! ## 2. The derived call-site liveness -/

/-- THE derived call-site liveness: when the `ske` cell history holds at
    the call boundary and the map legality covers the read block (the
    explicit live-set extension of the 061 module), the read pointer's
    block IS live -- the 061 side condition is no longer a hypothesis.
    The word round-trip decides the pointer on the extended set and the
    liveness follows from `inputOf_mem_live`. -/
theorem small_site_src_live (env : Env) (before : State) (i : Fin 4) (after : Memory)
    (ret : BitVec 64) (site : SmallSite env before i after ret)
    (legal : VirtualLegal (site.src.block::env.live) env.vb)
    (history : SkeCellWord env i before) : site.src.block∈env.live := by
  have words : wordOf env.vb site.src=wordOf env.vb (inputOf env i) :=
    load64_deterministic before.heap (skeElem env i) (wordOf env.vb site.src)
      (wordOf env.vb (inputOf env i)) site.srcCell.load history
  have tie := canonical_word_eq env.vb (site.src.block::env.live) legal site.src (inputOf env i)
    site.srcCell.canonical (input_canonical env i)
    (List.mem_cons.mpr (Or.inl rfl))
    (List.mem_cons.mpr (Or.inr (inputOf_mem_live env i))) words
  rw [tie]
  exact inputOf_mem_live env i

/-- THE source tie under the explicit live-set extension: the call-site
    source argument IS the material array of segment `i`, derived from the
    `ske` cell history and the extended map legality -- no readable-word
    hypothesis and no liveness side condition. -/
theorem small_site_material_extended (env : Env) (before : State) (i : Fin 4) (after : Memory)
    (ret : BitVec 64) (site : SmallSite env before i after ret)
    (legal : VirtualLegal (site.src.block::env.live) env.vb)
    (history : SkeCellWord env i before) : site.src=inputOf env i := by
  have words : wordOf env.vb site.src=wordOf env.vb (inputOf env i) :=
    load64_deterministic before.heap (skeElem env i) (wordOf env.vb site.src)
      (wordOf env.vb (inputOf env i)) site.srcCell.load history
  exact canonical_word_eq env.vb (site.src.block::env.live) legal site.src (inputOf env i)
    site.srcCell.canonical (input_canonical env i)
    (List.mem_cons.mpr (Or.inl rfl))
    (List.mem_cons.mpr (Or.inr (inputOf_mem_live env i))) words

/-- The extended legality class is ACHIEVABLE at any canonical call site:
    the identity map is legal on the extended live set of sub-2^64 blocks
    (the read block is canonical with a sub-2^64 live word), so the
    repaired liveness premise is satisfiable -- never an impossible
    premise. -/
theorem small_site_legal_exists (env : Env) (before : State) (i : Fin 4) (after : Memory)
    (ret : BitVec 64) (site : SmallSite env before i after ret)
    (small : ∀ b, b∈site.src.block::env.live → b<2^64) :
    ∃ vb, VirtualLegal (site.src.block::env.live) vb :=
  virtualLegal_exists (site.src.block::env.live) small

end FT1536.Source3.KeygenMakeSkeCells
