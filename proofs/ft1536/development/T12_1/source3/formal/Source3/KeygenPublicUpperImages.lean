import Source3.KeygenPublicUpperFinish

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Execution of the three actual `finish` statements (source 881-884) and the
   complete BOTH table images. The explicit C99NarrowReads promotion bridge
   (trap 190) supplies the narrow and Slot/Value forms of unsignedPromotion:
   Value.integer is toInt for .int32 but toNat for .uint32, so the two forms
   are propositionally equal only. Statement results are phrased on the store
   constructor's heap (trap 188) and definitions are unfolded before
   rewriting (trap 189). Conclusions: PairCells 1..1023, the executed
   gm[0]=gm[1] copy, the exceptional igm[0] with the raw word law
   value = radix/(2*firstRoot-1), Word "w" firstRoot and the caller-visible
   frames. No generated table image, transform result or equation is assumed. -/
namespace FT1536.Source3.KeygenPublicUpperImages
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer Memory)
open KeygenPublicExec (Exec chain)
open KeygenPublicTableAtoms (Slot)
open KeygenPublicTableControl (seq_inv)
open KeygenPublicTableStore (Pointers Separate Word)
open KeygenPublicTableCells (Cell)
open KeygenPublicUpperBody (PairCell)
open KeygenPublicUpperFrames (UpperFrame)
open KeygenPublicUpperLoops (PairCells Common)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicRoots (root firstRoot)
open KeygenMkgm3Indices (tableExponent)
open KeygenPublicAlgebra (R value Canonical radix)
open KeygenPublicMontgomery (modulus)
open KeygenPublicDivisionAlgebra (Scaled)
open KeygenPublicUpperFinish (clit gStore wSet iStore load_two index_zero te_one
  add_field sub_field add_word sub_word div_word division_scaled two_first_root_nonzero)

/- Trap 190: unsignedPromotion w is not unifier-defeq with the .uint32
   Slot/Value form at the narrow argument, because Value.integer maps .int32
   to toInt and .uint32 to toNat. These are the explicit bridges. -/
theorem promotion_convert (w : BitVec 16) :
    C99IntegerReference.convert .uint32 (C99NarrowReads.unsignedPromotion w).integer
      = .uint32 (BitVec.ofNat 32 w.toNat) :=
  KeygenPublicTableCells.unsigned_argument w
theorem promotion_slot (s : State) (w : BitVec 16) :
    Slot (bindValue s "w".toList .uint32 (C99NarrowReads.unsignedPromotion w)) "w"
      (BitVec.ofNat 32 w.toNat) := by
  have converted : C99IntegerReference.convert .uint32 (C99NarrowReads.unsignedPromotion w).integer
      = .uint32 (BitVec.ofNat 32 w.toNat) := KeygenPublicTableCells.unsigned_argument w
  simp [Slot,bindValue,C99ScalarReference.set,converted]
theorem promotion_narrow (w : BitVec 16) :
    KeygenPublicWord.narrow (C99NarrowReads.unsignedPromotion w)
      = KeygenPublicWord.narrow (.uint32 (BitVec.ofNat 32 w.toNat)) := by
  have toNat : (BitVec.ofNat 32 w.toNat).toNat=w.toNat := by
    have bound := w.isLt
    simp only [BitVec.toNat_ofNat]
    omega
  have integer : (C99NarrowReads.unsignedPromotion w).integer
      = (C99IntegerReference.Value.uint32 (BitVec.ofNat 32 w.toNat)).integer := by
    rw [C99NarrowReads.unsigned_promotion_exact]
    show (w.toNat : Int)=((BitVec.ofNat 32 w.toNat).toNat : Int)
    rw [toNat]
  unfold KeygenPublicWord.narrow
  rw [integer]
theorem write_promoted (before after : Memory) (p : ArrayPointer) (i : Nat) (w : BitVec 16)
    (source : KeygenSmallOutput.Store16 before (KeygenSmallOutput.element p i)
      (KeygenPublicWord.narrow (C99NarrowReads.unsignedPromotion w)) after) :
    KeygenSmallOutput.Store16 before (KeygenSmallOutput.element p i)
      (KeygenPublicWord.narrow (.uint32 (BitVec.ofNat 32 w.toNat))) after := by
  rw [promotion_narrow w] at source
  exact source

/- The promoted gm[1] word scales firstRoot: root^tableExponent 1 is firstRoot. -/
theorem exceptional_scaled (w : BitVec 16) (z : R)
    (scaled : Scaled (BitVec.ofNat 32 w.toNat) z) (target : z=root^tableExponent 1) :
    Scaled (BitVec.ofNat 32 w.toNat) firstRoot := by
  have equal : z=firstRoot := by rw [target,te_one]; rfl
  rw [equal] at scaled
  exact scaled

/- The three statement results, phrased on the store constructor's heap. -/
theorem gstore_result (s : State) (out : Result) (gm igm : ArrayPointer)
    (pointers : Pointers s gm igm) (cell : Cell s.heap gm 1 (root^tableExponent 0))
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] gStore s out) :
    out.flow=.normal ∧ out.state.locals=s.locals ∧ out.state.arrays=s.arrays ∧
      Cell out.state.heap gm 0 (root^tableExponent 0) ∧
      (∀ j<1024, j≠0 → ∀ z, Cell s.heap gm j z → Cell out.state.heap gm j z) ∧
      (∀ j<1024, ∀ z, Cell s.heap igm j z → Cell out.state.heap igm j z) ∧
      UpperFrame gm igm s.heap out.state.heap := by
  cases source with
  | store _ _ _ _ before heap actual v address evaluated write =>
      rw [KeygenPublicTableIndex.address s "gm" (clit 0) gm actual 0 pointers.1
        (index_zero s) address] at write
      obtain ⟨w,equal,scaled⟩ := load_two s "gm" gm (root^tableExponent 0) v pointers.1 cell evaluated
      rw [equal] at write
      have written := KeygenPublicTableCells.written_cell s.heap heap gm 0
        (BitVec.ofNat 32 w.toNat) (root^tableExponent 0) scaled
        (write_promoted s.heap heap gm 0 w write)
      have gkeep : ∀ j<1024, j≠0 → ∀ z, Cell s.heap gm j z → Cell heap gm j z :=
        fun j hj ne z old => KeygenPublicTableCells.preserves_cell s.heap heap gm gw
          0 j (Ne.symm ne) _ z write old
      have ikeep : ∀ j<1024, ∀ z, Cell s.heap igm j z → Cell heap igm j z :=
        fun j hj z old => KeygenPublicTableStore.cross_preserves s.heap heap igm gm
          iw gw (KeygenPublicTableStore.separate_symm gm igm separate) 0 j (by decide) hj _ z write old
      have frame : UpperFrame gm igm s.heap heap :=
        KeygenPublicUpperFrames.full_write_frame gm igm gm (by simp) gw 0 (by decide)
          s.heap heap _ write
      exact ⟨rfl,rfl,rfl,written,gkeep,ikeep,frame⟩

theorem wset_result (s : State) (out : Result) (gm : ArrayPointer) (z : R)
    (binding : s.arrays "gm".toList=some gm) (cell : Cell s.heap gm 1 z)
    (declared : ∃ old, s.locals "w".toList=some (.uint32,old))
    (source : Exec KeygenPublicSource.program [] wSet s out) :
    out.flow=.normal ∧ out.state.heap=s.heap ∧ out.state.arrays=s.arrays ∧
      (∃ w : BitVec 16, Slot out.state "w" (BitVec.ofNat 32 w.toNat) ∧
        Scaled (BitVec.ofNat 32 w.toNat) z) ∧
      ∀ name, name≠"w" → out.state.locals name.toList=s.locals name.toList := by
  cases source with
  | assign _ _ _ ty previous v slot evaluated =>
      obtain ⟨w,equal,scaled⟩ := load_two s "gm" gm z v binding cell evaluated
      obtain ⟨old,declaredE⟩ := declared
      have te := congrArg Prod.fst (Option.some.inj (slot.symm.trans declaredE))
      dsimp only at te
      subst ty
      rw [equal]
      refine ⟨rfl,rfl,rfl,⟨w,?_,scaled⟩,?_⟩
      · exact promotion_slot s w
      · intro name ne
        exact KeygenPublicUpperLoops.bind_other s .uint32 (C99NarrowReads.unsignedPromotion w)
          "w" name ne

theorem istore_result (s : State) (out : Result) (gm igm : ArrayPointer) (w : BitVec 16)
    (pointers : Pointers s gm igm) (wSlot : Slot s "w" (BitVec.ofNat 32 w.toNat))
    (scaled : Scaled (BitVec.ofNat 32 w.toNat) firstRoot)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] iStore s out) :
    out.flow=.normal ∧ out.state.locals=s.locals ∧ out.state.arrays=s.arrays ∧
      Cell out.state.heap igm 0 ((2*firstRoot-1)⁻¹) ∧
      (∃ q : BitVec 32, Scaled q ((2*firstRoot-1)⁻¹) ∧ value q=radix/(2*firstRoot-1) ∧
        KeygenSmallOutput.Store16 s.heap (KeygenSmallOutput.element igm 0)
          (KeygenPublicWord.narrow (.uint32 q)) out.state.heap) ∧
      (∀ j<1024, j≠0 → ∀ z, Cell s.heap igm j z → Cell out.state.heap igm j z) ∧
      (∀ j<1024, ∀ z, Cell s.heap gm j z → Cell out.state.heap gm j z) ∧
      UpperFrame gm igm s.heap out.state.heap := by
  have hp : Canonical (BitVec.ofNat 32 w.toNat) := scaled.1
  have scaledP : value (BitVec.ofNat 32 w.toNat)=radix*firstRoot := scaled.2
  cases source with
  | store _ _ _ _ before heap actual v address evaluated write =>
      rw [KeygenPublicTableIndex.address s "igm" (clit 0) igm actual 0 pointers.2
        (index_zero s) address] at write
      cases evaluated with
      | call2 _ _ _ av dv _ first second invokedDiv =>
          have avEq := KeygenPublicTableAtoms.literal_value [] s 4564 av first
          cases second with
          | call3 _ _ _ _ xadd ylit zlit _ addEval litY litZ invokedSub =>
              cases addEval with
              | call3 _ _ _ _ wv1 wv2 qlit _ varE1 varE2 litQ invokedAdd =>
                  have wv1e := KeygenPublicTableAtoms.variable_value [] s "w"
                    (BitVec.ofNat 32 w.toNat) wv1 wSlot varE1
                  have wv2e := KeygenPublicTableAtoms.variable_value [] s "w"
                    (BitVec.ofNat 32 w.toNat) wv2 wSlot varE2
                  have qe := KeygenPublicTableAtoms.literal_value [] s 18433 qlit litQ
                  subst wv1; subst wv2; subst qlit
                  have addLaw := add_field (BitVec.ofNat 32 w.toNat) _ _ _ xadd firstRoot
                    hp scaledP (KeygenPublicArguments.u32_self _) (KeygenPublicArguments.u32_self _)
                    (KeygenPublicArguments.u32_literal 18433) invokedAdd
                  have addWord := add_word (BitVec.ofNat 32 w.toNat) _ _ _ xadd
                    (KeygenPublicArguments.u32_self _) (KeygenPublicArguments.u32_self _)
                    (KeygenPublicArguments.u32_literal 18433) invokedAdd
                  rw [addWord] at invokedSub
                  have ye := KeygenPublicTableAtoms.literal_value [] s 10237 ylit litY
                  have ze := KeygenPublicTableAtoms.literal_value [] s 18433 zlit litZ
                  subst ylit; subst zlit
                  have canon10237 : Canonical (BitVec.ofNat 32 10237) := by
                    unfold Canonical
                    decide
                  have y10237 : value (BitVec.ofNat 32 10237)=radix*(1:R) := by decide
                  have subLaw := sub_field _ _ _ _ _ _ (firstRoot+firstRoot) (1:R) addLaw.1
                    canon10237 addLaw.2 y10237 (KeygenPublicArguments.u32_self _)
                    (KeygenPublicArguments.u32_literal 10237)
                    (KeygenPublicArguments.u32_literal 18433) invokedSub
                  have subWord := sub_word _ _ _ _ _ _
                    (KeygenPublicArguments.u32_self _) (KeygenPublicArguments.u32_literal 10237)
                    (KeygenPublicArguments.u32_literal 18433) invokedSub
                  rw [subWord] at invokedDiv
                  subst av
                  have divWord := div_word (BitVec.ofNat 32 4564) _
                    (C99IntegerReference.convert .int32 4564) _ v
                    (KeygenPublicArguments.u32_literal 4564) (KeygenPublicArguments.u32_self _)
                    invokedDiv
                  have b2 : ((firstRoot+firstRoot-1 : R))=(2*firstRoot-1) := by rw [two_mul]
                  have bnonzero : (firstRoot+firstRoot-1 : R)≠0 := by
                    rw [b2]
                    exact two_first_root_nonzero
                  have rinv := KeygenPublicAlgebra.radix_inverse
                  have rnz : radix≠0 := left_ne_zero_of_mul_eq_one rinv
                  have vnonzero : value (KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add
                      (BitVec.ofNat 32 w.toNat) (BitVec.ofNat 32 w.toNat) modulus)
                      (BitVec.ofNat 32 10237) modulus)≠0 := by
                    rw [subLaw.2]
                    exact mul_ne_zero rnz bnonzero
                  have o2nonzero : (KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add
                      (BitVec.ofNat 32 w.toNat) (BitVec.ofNat 32 w.toNat) modulus)
                      (BitVec.ofNat 32 10237) modulus).toNat≠0 := by
                    intro h
                    have zero : value (KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add
                        (BitVec.ofNat 32 w.toNat) (BitVec.ofNat 32 w.toNat) modulus)
                        (BitVec.ofNat 32 10237) modulus)=(0:R) := by
                      show ((KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add
                        (BitVec.ofNat 32 w.toNat) (BitVec.ofNat 32 w.toNat) modulus)
                        (BitVec.ofNat 32 10237) modulus).toNat : R)=(0:R)
                      rw [h]
                      exact Nat.cast_zero
                    exact vnonzero zero
                  have x4564 : value (BitVec.ofNat 32 4564)=radix^2*(1:R) := by decide
                  have canon4564 : Canonical (BitVec.ofNat 32 4564) := by
                    unfold Canonical
                    decide
                  have divLaw := division_scaled (BitVec.ofNat 32 4564) _ (1:R)
                    (firstRoot+firstRoot-1) canon4564 subLaw.1 x4564 subLaw.2 o2nonzero bnonzero
                  have final : value (KeygenPublicDivisionWords.division (BitVec.ofNat 32 4564)
                      (KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add
                        (BitVec.ofNat 32 w.toNat) (BitVec.ofNat 32 w.toNat) modulus)
                        (BitVec.ofNat 32 10237) modulus))=radix*((2*firstRoot-1)⁻¹) := by
                    rw [divLaw.2,b2,one_mul]
                  have scaledFinal : Scaled
                      (KeygenPublicDivisionWords.division (BitVec.ofNat 32 4564)
                        (KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add
                          (BitVec.ofNat 32 w.toNat) (BitVec.ofNat 32 w.toNat) modulus)
                          (BitVec.ofNat 32 10237) modulus)) ((2*firstRoot-1)⁻¹) :=
                    ⟨divLaw.1,final⟩
                  have rawLaw : value (KeygenPublicDivisionWords.division (BitVec.ofNat 32 4564)
                      (KeygenModpAddSub.result .sub (KeygenModpAddSub.result .add
                        (BitVec.ofNat 32 w.toNat) (BitVec.ofNat 32 w.toNat) modulus)
                        (BitVec.ofNat 32 10237) modulus))=radix/(2*firstRoot-1) := by
                    rw [div_eq_mul_inv]
                    exact final
                  rw [divWord] at write
                  have written := KeygenPublicTableCells.written_cell s.heap heap igm 0
                    _ ((2*firstRoot-1)⁻¹) scaledFinal write
                  have ikeep : ∀ j<1024, j≠0 → ∀ z, Cell s.heap igm j z → Cell heap igm j z :=
                    fun j hj ne z old => KeygenPublicTableCells.preserves_cell s.heap heap
                      igm iw 0 j (Ne.symm ne) _ z write old
                  have gkeep : ∀ j<1024, ∀ z, Cell s.heap gm j z → Cell heap gm j z :=
                    fun j hj z old => KeygenPublicTableStore.cross_preserves s.heap heap
                      gm igm gw iw separate 0 j (by decide) hj _ z write old
                  have frame : UpperFrame gm igm s.heap heap :=
                    KeygenPublicUpperFrames.full_write_frame gm igm igm (by simp) iw 0 (by decide)
                      s.heap heap _ write
                  exact ⟨rfl,rfl,rfl,written,⟨_,scaledFinal,rawLaw,write⟩,ikeep,gkeep,frame⟩

/- The three finish statements compose on the SAME run: complete BOTH images. -/
theorem finish_images (before : Memory) (s : State) (out : Result) (gm igm : ArrayPointer)
    (common : Common gm igm s) (counter : USlot s "u" 0) (images : PairCells gm igm s.heap 1)
    (frame : UpperFrame gm igm before s.heap)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] KeygenPublicUpperProgram.finish s out) :
    out.flow=.normal ∧ PairCells gm igm out.state.heap 1 ∧
      Cell out.state.heap gm 0 (root^tableExponent 0) ∧
      Cell out.state.heap igm 0 ((2*firstRoot-1)⁻¹) ∧
      (∃ q : BitVec 32, Scaled q ((2*firstRoot-1)⁻¹) ∧ value q=radix/(2*firstRoot-1)) ∧
      Word out.state "w" firstRoot ∧
      Pointers out.state gm igm ∧ Slot out.state "logn" 10 ∧ Slot out.state "k" 8 ∧
      USlot out.state "u" 0 ∧ UpperFrame gm igm before out.state.heap := by
  rw [KeygenPublicUpperFinish.source_finish] at source
  obtain ⟨s1,gExec,rest1⟩ := seq_inv gStore (chain [wSet,iStore]) s out (by decide) source
  obtain ⟨s2,wExec,rest2⟩ := seq_inv wSet (chain [iStore]) s1 out (by decide) rest1
  obtain ⟨s3,iExec,rest3⟩ := seq_inv iStore .skip s2 out (by decide) rest2
  cases rest3
  have cellOne : Cell s.heap gm 1 (root^tableExponent 0) := by
    rw [KeygenMkgm3Indices.top_exponent]
    exact (images 1 (by omega) (by omega)).1
  obtain ⟨_,locals1,arrays1,cell0,gkeep1,ikeep1,frame1⟩ :=
    gstore_result s ⟨s1,.normal⟩ gm igm common.pointers cellOne gw iw separate gExec
  have binding1 : s1.arrays "gm".toList=some gm := by rw [arrays1]; exact common.pointers.1
  have cell1 : Cell s1.heap gm 1 (root^tableExponent 1) :=
    gkeep1 1 (by omega) (by decide) _ (images 1 (by omega) (by omega)).1
  have declaredW : ∃ old, s1.locals "w".toList=some (.uint32,old) := by
    rw [locals1]
    exact ⟨none,common.w⟩
  obtain ⟨_,heap2,arrays2,wExist,locals2⟩ :=
    wset_result s1 ⟨s2,.normal⟩ gm (root^tableExponent 1) binding1 cell1 declaredW wExec
  obtain ⟨ww,wslot,wscaled⟩ := wExist
  have firstScaled : Scaled (BitVec.ofNat 32 ww.toNat) firstRoot :=
    exceptional_scaled ww (root^tableExponent 1) wscaled rfl
  have binding2g : s2.arrays "gm".toList=some gm := by rw [arrays2]; exact binding1
  have binding2i : s2.arrays "igm".toList=some igm := by
    rw [arrays2,arrays1]
    exact common.pointers.2
  have pointers2 : Pointers s2 gm igm := ⟨binding2g,binding2i⟩
  obtain ⟨_,locals3,arrays3,cellI0,iExist,ikeep3,gkeep3,frame3⟩ :=
    istore_result s2 ⟨s3,.normal⟩ gm igm ww pointers2 wslot firstScaled gw iw separate iExec
  obtain ⟨q,scaledQ,rawQ,_⟩ := iExist
  have wslot3 : Slot s3 "w" (BitVec.ofNat 32 ww.toNat) := by
    show s3.locals "w".toList=some (.uint32,some (.uint32 (BitVec.ofNat 32 ww.toNat)))
    rw [locals3]
    exact wslot
  have frame12 : UpperFrame gm igm s1.heap s2.heap := by
    rw [heap2]
    exact KeygenPublicUpperFrames.frame_refl gm igm s1.heap
  refine ⟨rfl,?_,?_,?_,⟨q,scaledQ,rawQ⟩,⟨_,wslot3,firstScaled⟩,?_,?_,?_,?_,?_⟩
  · intro i lo hi
    refine ⟨?_,?_⟩
    · have step1 : Cell s1.heap gm i (root^tableExponent i) :=
        gkeep1 i hi (by omega) _ (images i lo hi).1
      have step2 : Cell s2.heap gm i (root^tableExponent i) := by rw [heap2]; exact step1
      exact gkeep3 i hi _ step2
    · have step1 : Cell s1.heap igm i ((root⁻¹)^tableExponent i) :=
        ikeep1 i hi _ (images i lo hi).2
      have step2 : Cell s2.heap igm i ((root⁻¹)^tableExponent i) := by rw [heap2]; exact step1
      exact ikeep3 i hi (by omega) _ step2
  · have step2 : Cell s2.heap gm 0 (root^tableExponent 0) := by rw [heap2]; exact cell0
    exact gkeep3 0 (by decide) _ step2
  · exact cellI0
  · show s3.arrays "gm".toList=some gm ∧ s3.arrays "igm".toList=some igm
    rw [arrays3,arrays2,arrays1]
    exact common.pointers
  · show s3.locals "logn".toList=some (.uint32,some (.uint32 10))
    rw [locals3,locals2 "logn" (by decide),locals1]
    exact common.logn
  · show s3.locals "k".toList=some (.uint32,some (.uint32 8))
    rw [locals3,locals2 "k" (by decide),locals1]
    exact common.key
  · show s3.locals "u".toList=some (.uint64,some (u64 0))
    rw [locals3,locals2 "u" (by decide),locals1]
    exact counter
  · exact KeygenPublicUpperFrames.frame_trans gm igm before s2.heap s3.heap
      (KeygenPublicUpperFrames.frame_trans gm igm before s1.heap s2.heap
        (KeygenPublicUpperFrames.frame_trans gm igm before s.heap s1.heap frame frame1) frame12)
      frame3

/- Complete BOTH images from the SAME generate execution: every pair cell at
   1..1023, the copied gm[0]=root^tableExponent 0, the exceptional
   igm[0]=(2*firstRoot-1)⁻¹ with raw word law radix/(2*firstRoot-1), the
   finished Word "w" firstRoot and all caller-visible frames. -/
theorem source_complete_tables (s : State) (out : Result) (gm igm : ArrayPointer)
    (profile : Slot s "logn" 10) (pointers : Pointers s gm igm)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate) s out) :
    out.flow=.normal ∧ PairCells gm igm out.state.heap 1 ∧
      Cell out.state.heap gm 0 (root^tableExponent 0) ∧
      Cell out.state.heap igm 0 ((2*firstRoot-1)⁻¹) ∧
      (∃ q : BitVec 32, Scaled q ((2*firstRoot-1)⁻¹) ∧ value q=radix/(2*firstRoot-1)) ∧
      Word out.state "w" firstRoot ∧
      Pointers out.state gm igm ∧ Slot out.state "logn" 10 ∧ Slot out.state "k" 8 ∧
      USlot out.state "u" 0 ∧ UpperFrame gm igm s.heap out.state.heap := by
  obtain ⟨_,final,_,finishExec,filled,common,counter,frame⟩ :=
    KeygenPublicUpperLoops.source_tables s out gm igm profile pointers gw iw separate source
  exact finish_images s.heap final out gm igm common counter filled frame
    gw iw separate finishExec

end FT1536.Source3.KeygenPublicUpperImages
