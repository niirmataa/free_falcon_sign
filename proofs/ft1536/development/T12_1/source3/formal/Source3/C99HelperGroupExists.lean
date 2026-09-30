import Source3.C99HelperComplete

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HelperGroupExists
open C99HelperReference C99HelperAtoms StableBinaryByteView
local notation "code" => StableBinarySourceSyntax.expected

theorem value_read (l : StableBinary.Layout) (k i : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hi : i<l.length) :
    ∃ w, C99MemoryReference.Load64 (decode s).heap (C99HelperObjects.values l i) w := by
  obtain ⟨w,hw⟩ := Option.isSome_iff_exists.mp ((HelperMemoryTotal.read_some_iff _ _).mpr (legal.valuesReadable i hi))
  refine ⟨w,?_⟩
  apply (C99MemoryAccess.load64_iff _ _ _ rfl
    (C99HelperObjects.values_allocated l k i _ hl (by simpa [decode,C99MemoryBridge.encode_decode] using legal) hi) rfl).mpr
  simpa only [decode,C99MemoryBridge.encode_decode,C99HelperObjects.values_offset] using hw

theorem pair_exists (l : StableBinary.Layout) (k start u hn : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hb : start+2*hn≤l.length) (hu : u<hn) :
    ∃ a b out, Pair l code start u (decode s) a b (decode out) ∧ Legal l out.heap := by
  obtain ⟨x,hx⟩ := value_read l k (start+(u*2+0)) s hl legal (by omega)
  obtain ⟨a,s1,ha,_,_⟩ := HelperMemoryTotal.positive_total l k s x hl legal
  obtain ⟨hra,l1⟩ := positive_sound l k s s1 x a hl legal ha
  obtain ⟨y,hy⟩ := value_read l k (start+(u*2+1)) s1 hl l1 (by omega)
  obtain ⟨b,out,hb',_,_⟩ := HelperMemoryTotal.positive_total l k s1 y hl l1
  obtain ⟨hrb,lout⟩ := positive_sound l k s1 out y b hl l1 hb'
  exact ⟨a,b,out,Pair.step (decode s) (decode s1) (decode out) x a y b hx hra hy hrb,lout⟩

theorem gram_exists (l : StableBinary.Layout) (k : Nat) (s : StableBinaryCExec.State) (a b : Word)
    (hl : l.wellFormed k) (legal : Legal l s.heap) :
    ∃ sum product out, Gram l code a b (decode s) sum product (decode out) ∧ Legal l out.heap := by
  obtain ⟨rawSum,ha⟩ := Option.isSome_iff_exists.mp (FprAddTotal.add_total a b)
  obtain ⟨sum,s1,hs,_,_⟩ := HelperMemoryTotal.positive_total l k s rawSum hl legal
  obtain ⟨hrs,l1⟩ := positive_sound l k s s1 rawSum sum hl legal hs
  obtain ⟨rawProduct,hm⟩ := Option.isSome_iff_exists.mp (FprMulTotal.mul_total a b)
  obtain ⟨product,out,hp,_,_⟩ := HelperMemoryTotal.positive_total l k s1 rawProduct hl l1
  obtain ⟨hrp,lout⟩ := positive_sound l k s1 out rawProduct product hl l1 hp
  exact ⟨sum,product,out,Gram.step (decode s) (decode s1) (decode out) rawSum sum rawProduct product
    (C99PrimitiveExists.add_sound a b rawSum ha) hrs (C99PrimitiveExists.mul_sound a b rawProduct hm) hrp,lout⟩

theorem half_exists (l : StableBinary.Layout) (k u : Nat) (s : StableBinaryCExec.State) (sum : Word)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hu : u<l.length) :
    ∃ out, HalfStore l code u sum (decode s) (decode out) ∧ Legal l out.heap := by
  let raw := StableBinaryInlineTotal.halfWord sum
  obtain ⟨z,mid,hc,_,_⟩ := HelperMemoryTotal.positive_total l k s raw hl legal
  obtain ⟨hrc,lmid⟩ := positive_sound l k s mid raw z hl legal hc
  obtain ⟨out,hw,lout,_,_⟩ := HelperMemoryTotal.store_total l k mid (StableBinary.addr l.scratch u) z
    hl lmid (StableBinaryLoopRefinement.scratch_allowed l u hu)
  have ha := C99HelperObjects.scratch_allocated l k u (decode mid).heap hl
    (by simpa [decode,C99MemoryBridge.encode_decode] using lmid) hu
  have hrw := store_sound (C99HelperObjects.scratch l u) mid out z rfl ha rfl hw
  have hrhalf : Unary "fpr_half".toList sum raw := Or.inl ⟨rfl,
    (C99LeafCalls.half_iff sum raw).mpr (StableBinaryInlineTotal.half_from_pinned_M0 sum)⟩
  exact ⟨out,HalfStore.step (decode s) (decode mid) (decode out) raw z hrhalf hrc hrw,lout⟩

theorem suffix_exists (l : StableBinary.Layout) (k u hn : Nat) (s : StableBinaryCExec.State) (product sum : Word)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hu : u+hn<l.length) :
    ∃ out, Suffix l code u hn product sum (decode s) (decode out) ∧ Legal l out.heap := by
  let twice := StableBinaryInlineTotal.doubleWord product
  obtain ⟨raw,hdiv⟩ := Option.isSome_iff_exists.mp (FprDivTotal.div_total twice sum)
  obtain ⟨z,mid,hc,_,_⟩ := HelperMemoryTotal.positive_total l k s raw hl legal
  obtain ⟨hrc,lmid⟩ := positive_sound l k s mid raw z hl legal hc
  obtain ⟨out,hw,lout,_,_⟩ := HelperMemoryTotal.store_total l k mid (StableBinary.addr l.scratch (u+hn)) z
    hl lmid (StableBinaryLoopRefinement.scratch_allowed l (u+hn) hu)
  have ha := C99HelperObjects.scratch_allocated l k (u+hn) (decode mid).heap hl
    (by simpa [decode,C99MemoryBridge.encode_decode] using lmid) hu
  have hrw := store_sound (C99HelperObjects.scratch l (u+hn)) mid out z rfl ha rfl hw
  have hrdouble : Unary "fpr_double".toList product twice := Or.inr ⟨rfl,
    (C99LeafCalls.double_iff product twice).mpr (StableBinaryInlineTotal.double_from_pinned_M0 product)⟩
  exact ⟨out,Suffix.step (decode s) (decode mid) (decode out) twice raw z hrdouble
    (C99PrimitiveExists.div_sound twice sum raw hdiv) hrc hrw,lout⟩

theorem step_exists (l : StableBinary.Layout) (k start u hn : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hb : start+2*hn≤l.length) (hu : u<hn) :
    ∃ out, Step l code start u hn (decode s) (decode out) ∧ Legal l out.heap := by
  obtain ⟨a,b,sp,hp,lp⟩ := pair_exists l k start u hn s hl legal hb hu
  obtain ⟨sum,product,sg,hg,lg⟩ := gram_exists l k sp a b hl lp
  obtain ⟨sh,hh,lh⟩ := half_exists l k u sg sum hl lg (by omega)
  obtain ⟨out,hs,lout⟩ := suffix_exists l k u hn sh product sum hl lh (by omega)
  exact ⟨out,Step.step (decode s) (decode sp) (decode sg) (decode sh) (decode out) a b sum product hp hg hh hs,lout⟩

theorem loop_exists (l : StableBinary.Layout) (k start hn : Nat) (s : StableBinaryCExec.State)
    (hl : l.wellFormed k) (legal : Legal l s.heap) (hb : start+2*hn≤l.length) :
    ∀ u, u≤hn → ∃ out, Loop l code start hn u (decode s) (decode out) ∧ Legal l out.heap := by
  intro u
  induction u with
  | zero => intro _; exact ⟨s,Loop.zero _,legal⟩
  | succ u ih =>
      intro hu
      obtain ⟨mid,hm,lmid⟩ := ih (by omega)
      obtain ⟨out,ho,lout⟩ := step_exists l k start u hn mid hl lmid hb (by omega)
      exact ⟨out,Loop.next u (decode s) (decode mid) (decode out) (by omega) hm ho,lout⟩

end FT1536.Source3.C99HelperGroupExists

#print axioms FT1536.Source3.C99HelperGroupExists.loop_exists
