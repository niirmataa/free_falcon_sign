import Source3.ThirdStepProduct215

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The first slen = 3 prime loop of the d=3 body (the marsze layer):
   the original `for (u = 0; u < slen; u ++)` over the PRIMES3 rows 0..2
   at n = 128 / hn = 64, with its copy marches at stride 3, the false
   !in_ntt skips, the fd/gd Montgomery product marches, the taken in_ntt
   modp_iNTT3_ext column visits at Level 6 (logn 7) and the modp_mkgm3
   generator of ThirdStepGenerator215. All words are executed words of
   the actual table rows and source bodies; no NTT/root/table law is
   claimed. -/
namespace FT1536.Source3.ThirdStepMarch215
open C99ArrayReference (State Name bindValue bindPointer restoreScope)
open C99MemoryReference (ArrayPointer Allocated Load32)
open Word32Memory176 (Separate)
open KeygenMakeFgSource (Exec)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open StepCopyFixed203 (PrefixImage)
open StepProductFixed203 (Image)
open ThirdStepLayout215 (fd gd fs gs gm igm t1)
open ThirdStepGenerator215 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open SecondStepProduct203 (root)

/- Geometry of the d=3 march layers. -/
def croot : Side → ArrayPointer | .f => fs | .g => gs
def scratch (index : Nat) : ArrayPointer := ⟨31,0,71680,4,index⟩

theorem ordered (a b : Nat) (less : a<b) : Separate (scratch a) (scratch b) := by
  right; left
  change 0+4*a+4 ≤ 0+4*b
  omega

theorem copy_shape (side : Side) (u j : Nat) : addr (croot side) u j 3=
    scratch ((croot side).index+u+j*3) := by cases side <;> rfl

theorem product_shape (side : Side) (u j : Nat) : addr (root side) u j 6=
    scratch ((root side).index+u+j*6) := by cases side <;> rfl

theorem copy_bounds (side : Side) (u j : Nat) (bound : u<3) (slot : j<128) :
    1438 ≤ (croot side).index+u+j*3 ∧ (croot side).index+u+j*3<2206 := by
  have range : 1438 ≤ (croot side).index ∧ (croot side).index ≤ 1822 := by
    cases side <;> decide
  omega

theorem product_bound (side : Side) (u j : Nat) (bound : u<3) (slot : j<64) :
    (root side).index+u+j*6<1438 := by
  have range : (root side).index ≤ 1054 := by cases side <;> decide
  omega

theorem copy_data (side : Side) (u j : Nat) (bound : u<3) (slot : j<128) (i : Fin 128) :
    Separate (elem t1 i.val) (addr (croot side) u j 3) := by
  apply StepCopyFixed190.separate_symm
  rw [copy_shape]
  change Separate (scratch ((croot side).index+u+j*3)) (scratch (2462+i.val))
  exact ordered _ _ (by have h:=copy_bounds side u j bound slot; omega)

theorem copy_twiddle (k : Nat) (slot : k<128) (i : Fin 128) : Separate (elem t1 i.val) (elem igm k) := by
  apply StepCopyFixed190.separate_symm
  change Separate (scratch (2334+k)) (scratch (2462+i.val))
  exact ordered _ _ (by omega)

theorem product_data (destination source : Side) (u j v k : Nat) (bound : u<3) (slot : j<64) :
    Separate (addr (root destination) u j 6) (addr (croot source) v k 3) := by
  rw [product_shape,copy_shape]
  have low:=product_bound destination u j bound slot
  have high : 1438 ≤ (croot source).index := by cases source <;> decide
  exact ordered _ _ (by omega)

theorem product_twiddle (side : Side) (u j k : Nat) (bound : u<3) (slot : j<64) :
    Separate (addr (root side) u j 6) (elem igm k) := by
  rw [product_shape]
  change Separate (scratch ((root side).index+u+j*6)) (scratch (2334+k))
  exact ordered _ _ (by have h:=product_bound side u j bound slot; omega)

theorem fs_gs (u j v k : Nat) (bound : u<3) (slot : j<128) : Separate (addr fs u j 3) (addr gs v k 3) := by
  change Separate (scratch (1438+u+j*3)) (scratch (1822+v+k*3))
  exact ordered _ _ (by have a:=slot; have b:=k; omega)

theorem product_t1 (side : Side) (u i j : Nat) (bound : u<3) (slot : i<64) (tb : j<128) :
    Separate (addr (root side) u i 6) (elem t1 j) := by
  cases side
  · change 31≠31 ∨ 0+4*(670+u+i*6)+4 ≤ 0+4*(2462+j) ∨
      0+4*(2462+j)+4 ≤ 0+4*(670+u+i*6)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1054+u+i*6)+4 ≤ 0+4*(2462+j) ∨
      0+4*(2462+j)+4 ≤ 0+4*(1054+u+i*6)
    right; left; omega

theorem product_cross (u v i j : Nat) (bu : u<3) (bv : v<3) (si : i<64) (sj : j<64) :
    Separate (addr fd u i 6) (addr gd v j 6) := by
  change 31≠31 ∨ 0+4*(670+u+i*6)+4 ≤ 0+4*(1054+v+j*6) ∨
      0+4*(1054+v+j*6)+4 ≤ 0+4*(670+u+i*6)
  right; left; omega

/- The copy marches: x = fs/gs + u over n = 128 words into t1. -/
def midC (side : Side) (s : State) (u : Nat) :=
  bindPointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "x".toList (addr (croot side) u 0 3)

theorem midC_locals (side : Side) (s : State) (u : Nat) (name : Name) (different : name≠"v".toList) :
    (midC side s u).locals name=s.locals name := FftLocalCells140.outside s "v".toList name _ different

theorem midC_arrays (side : Side) (s : State) (u : Nat) (name : Name) (different : name≠"x".toList) :
    (midC side s u).arrays name=s.arrays name := StepCopyFixed190.bindPointer_arrays _ _ _ _ different

theorem bindingC (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    s.arrays (SecondStepCopy203.name side).toList=some (croot side) := by
  cases side <;> first | exact h.fsBinding | exact h.gsBinding

theorem initialC_source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<3) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) :
    Exec (SecondStepCopy203.initial side) s ⟨midC side s u,.normal⟩ := by
  have assign : C99ModularReference.Exec (.assign "v".toList (.scalar (MakeFgTailShape190.num 0))) s
      ⟨FftLocalCells140.put s "v".toList (C99NatWord141.word 0),.normal⟩ := by
    rw [FftLocalCells140.put_bind]
    exact .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))
  have uCell : Cell (FftLocalCells140.put s "v".toList (C99NatWord141.word 0)) "u".toList u :=
    (FftLocalCells140.outside s "v".toList "u".toList _ (by decide)).trans h.uCell
  have capacity : (croot side).index+u ≤ (croot side).count := by
    cases side
    · change 1438+u ≤ 71680; omega
    · change 1822+u ≤ 71680; omega
  have address : C99ArrayReference.Pointer (FftLocalCells140.put s "v".toList (C99NatWord141.word 0))
      (SecondStepCopy203.name side).toList MakeFgTailShape190.varU (addr (croot side) u 0 3) :=
    .add _ _ (croot side) _ (u64 u) (bindingC side s u p p0i r2 h)
      (C99LoopScalar141.read _ _ _ uCell) (by rw [KeygenNttLoopSupport.u64_integer u (by omega)]; omega)
      (by rw [KeygenNttLoopSupport.u64_toNat u (by omega)]; exact .within (croot side) u capacity)
  exact .level _ _ _ (.modular _ _ _ (.seqNormal _ _ _ _ _ assign (.base _ _ _ (.bindPtr _ _ _ _ _ address))))

theorem fixedC (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<3) (fv : Fin 128 → BitVec 32)
    (data : ∀ i, Load32 s.heap (addr (croot side) u i.val 3) (fv i)) :
    StepCopyFixed203.Fixed (midC side s u) (croot side) t1 u 3 128 fv := by
  refine ⟨by decide,by decide,by omega,?_,rfl,?_,by decide,h.writable,?_,?_,?_,?_,?_,?_,data⟩
  · cases side <;> rfl
  · cases side
    · change 1438+u+128*3 ≤ 71680; omega
    · change 1822+u+128*3 ≤ 71680; omega
  · exact (midC_arrays side s u "t1".toList (by decide)).trans h.t1Binding
  · exact (midC_locals side s u "n".toList (by decide)).trans h.nCell
  · exact (midC_locals side s u "slen".toList (by decide)).trans h.slenCell
  · intro i
    exact h.allocated (2462+i.val) (by have a:=i.isLt; omega)
  · intro v i
    cases side
    · change 31≠31 ∨ 0+4*(2462+v.val)+4 ≤ 0+4*(1438+u+i.val*3) ∨
        0+4*(1438+u+i.val*3)+4 ≤ 0+4*(2462+v.val)
      right; right; have a:=v.isLt; have b:=i.isLt; omega
    · change 31≠31 ∨ 0+4*(2462+v.val)+4 ≤ 0+4*(1822+u+i.val*3) ∨
        0+4*(1822+u+i.val*3)+4 ≤ 0+4*(2462+v.val)
      right; right; have a:=v.isLt; have b:=i.isLt; omega
  · intro i j different
    exact StepCopyFixed190.elem_separate t1 rfl i.val j.val (fun equal => different (Fin.ext equal))

theorem sourceC (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<3) (fv : Fin 128 → BitVec 32)
    (data : ∀ i, Load32 s.heap (addr (croot side) u i.val 3) (fv i))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (SecondStepCopy203.code side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      Cell out "v".toList 128 ∧ PrefixImage out t1 fv 128 ∧
      (∀ name : Name, name≠"v".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q : ArrayPointer, (∀ i : Fin 128, Separate (elem t1 i.val) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  have init := initialC_source side s u p p0i r2 h bound old declared
  obtain ⟨out,loopRun,outFixed,v,x,copied,locals,arrays,keeps⟩ := StepCopyAllKeep203.source
    (midC side s u) (croot side) t1 u 3 128 fv (fixedC side s u p p0i r2 h bound fv data)
    (FftLocalCells140.cell_at s "v".toList (C99NatWord141.word 0)) rfl
    (fun _ impossible => absurd impossible (by omega))
  have run : Exec (SecondStepCopy203.code side) s ⟨out,.normal⟩ := .seqNormal _ _ s (midC side s u) _ init loopRun
  have loc (name : Name) (different : name≠"v".toList) : out.locals name=s.locals name :=
    (locals name different).trans (midC_locals side s u name different)
  have arr (name : Name) (different : name≠"x".toList) : out.arrays name=s.arrays name :=
    (arrays name different).trans (midC_arrays side s u name different)
  exact ⟨out,run,ThirdStepGenerator215.transport h run loc arr,v,copied,loc,arr,keeps⟩

theorem skipC_source (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    Exec (SecondStepCopy203.skipped side) s ⟨s,.normal⟩ := by
  have guard : C99ArrayReference.scalar s (.lnot MakeFgTailShape190.inNtt) (.int32 0) :=
    .logicalNot _ (.int32 1) (.variable _ _ _ h.inCell)
  have run : Exec KeygenMakeFgSource.skip s ⟨s,.normal⟩ := SelectedStepAddPrime195.skip_run s
  cases side
  · rw [SecondStepCopy203.skipped,MakeFgTailShape190.s1_shape]
    exact .branchFalse _ _ _ s _ (.int32 0) guard rfl run
  · rw [SecondStepCopy203.skipped,MakeFgGsShape194.s5_shape]
    exact .branchFalse _ _ _ s _ (.int32 0) guard rfl run

/- The iNTT3_ext column visits at Level 6 / stride 3. -/
theorem sepI (side : Side) (u j k : Nat) (different : j≠k) :
    Separate (walk (elem (croot side) u) j 3) (walk (elem (croot side) u) k 3) := by
  cases side
  · change 31≠31 ∨ 0+4*(1438+u+j*3)+4 ≤ 0+4*(1438+u+k*3) ∨
      0+4*(1438+u+k*3)+4 ≤ 0+4*(1438+u+j*3)
    omega
  · change 31≠31 ∨ 0+4*(1822+u+j*3)+4 ≤ 0+4*(1822+u+k*3) ∨
      0+4*(1822+u+k*3)+4 ≤ 0+4*(1822+u+j*3)
    omega

theorem tw_sepI (side : Side) (u j k : Nat) (bound : u<3) (slot : j<128) :
    Separate (walk (elem (croot side) u) j 3) (elem igm k) := by
  cases side
  · change 31≠31 ∨ 0+4*(1438+u+j*3)+4 ≤ 0+4*(2334+k) ∨
      0+4*(2334+k)+4 ≤ 0+4*(1438+u+j*3)
    right; left; omega
  · change 31≠31 ∨ 0+4*(1822+u+j*3)+4 ≤ 0+4*(2334+k) ∨
      0+4*(2334+k)+4 ≤ 0+4*(1822+u+j*3)
    right; left; omega

theorem inputI (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<3) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<128, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<128, Load32 s.heap (addr (croot side) u j 3) (F j)) :
    NttInverseSides203.Input side 6 s (croot side) igm u 3 p p0i tws F := by
  refine ⟨h.uCell,h.slenCell,by exact h.lognCell,h.pCell,h.iCell,?_,h.igmBinding,by omega,by decide,by decide,
    ?_,?_,by decide,?_,?_,?_,twLoads,data⟩
  · cases side <;> first | exact h.fsBinding | exact h.gsBinding
  · cases side <;> rfl
  · cases side
    · change 1438+u+128*3 ≤ 71680; omega
    · change 1822+u+128*3 ≤ 71680; omega
  · cases side <;> exact h.writable
  · intro j k _ _ different
    exact sepI side u j k different
  · intro k _ j slot
    exact tw_sepI side u j k bound slot

theorem sourceI (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<3) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<128, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<128, Load32 s.heap (addr (croot side) u j 3) (F j)) :
    ∃ out, Exec (NttInverseSides203.branch side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ j<128, Load32 out.heap (addr (croot side) u j 3) (scaledWord 6 F tws p p0i j)) ∧
      (∀ q : ArrayPointer, (∀ j<128, Separate (addr (croot side) u j 3) q) →
        ∀ z, Load32 s.heap q z → Load32 out.heap q z) := by
  obtain ⟨out,run,locals,arrays,image,keeps⟩ := NttInverseSides203.branch_source side 6 s (croot side) igm u 3 p p0i tws F
    (inputI side s u p p0i r2 h bound tws F twLoads data) h.inCell h.terCell
  exact ⟨out,run,ThirdStepGenerator215.transport h run
    (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name),locals,arrays,image,keeps⟩

/- One side of the loop tail: copy march, skipped !in_ntt branch, product
   march and the iNTT column visit. -/
theorem sourceCol (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<3) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<128, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<128, Load32 s.heap (addr (croot side) u j 3) (F j))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (SecondStepColumn203.code side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      Cell out "v".toList 64 ∧ Image out (root side) u 6 64 p p0i r2 F 64 ∧
      (∀ j<128, Load32 out.heap (addr (croot side) u j 3) (scaledWord 6 F tws p p0i j)) ∧
      (∀ q : ArrayPointer,
        (∀ i : Fin 128, Separate (elem t1 i.val) q) →
        (∀ i : Fin 64, Separate (addr (root side) u i.val 6) q) →
        (∀ j<128, Separate (addr (croot side) u j 3) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨copied,copyRun,copyBasic,copyV,copiedImage,copyLocals,copyArrays,copyKeep⟩ :=
    sourceC side s u p p0i r2 h bound (fun i => F i.val) (fun i => data i.val i.isLt) old declared
  have skipped := skipC_source side copied u p p0i r2 copyBasic
  have copyTw : ∀ k<128, Load32 copied.heap (elem igm k) (tws k) := by
    intro k slot
    exact copyKeep (elem igm k) (copy_twiddle k slot) (tws k) (twLoads k slot)
  have copyData : ∀ j<128, Load32 copied.heap (addr (croot side) u j 3) (F j) := by
    intro j slot
    exact copyKeep _ (copy_data side u j bound slot) (F j) (data j slot)
  obtain ⟨products,productRun,productBasic,productV,productImage,productLocals,productArrays,productKeep⟩ :=
    ThirdStepProduct215.source side copied u p p0i r2 copyBasic bound F
      (fun i => copiedImage i i.isLt) (some (u64 128)) copyV
  have productTw : ∀ k<128, Load32 products.heap (elem igm k) (tws k) := by
    intro k slot
    exact productKeep _ (fun i => product_twiddle side u i.val k bound i.isLt) _ (copyTw k slot)
  have productData : ∀ j<128, Load32 products.heap (addr (croot side) u j 3) (F j) := by
    intro j slot
    exact productKeep _ (fun i => product_data side side u i.val u j bound i.isLt) _ (copyData j slot)
  obtain ⟨out,inverseRun,outBasic,inverseLocals,inverseArrays,image,inverseKeep⟩ :=
    sourceI side products u p p0i r2 productBasic bound tws F productTw productData
  have run : Exec (SecondStepColumn203.code side) s ⟨out,.normal⟩ :=
    .seqNormal _ _ s copied _ copyRun (.seqNormal _ _ copied copied _ skipped
      (.seqNormal _ _ copied products _ productRun (.seqNormal _ _ products out _ inverseRun (SelectedStepAddPrime195.skip_run out))))
  refine ⟨out,run,outBasic,(congrFun inverseLocals "v".toList).trans productV,?_,image,?_⟩
  · intro i slot
    exact inverseKeep _ (fun j _ => StepCopyFixed190.separate_symm
      (product_data side side u i.val u j bound i.isLt)) _ (productImage i slot)
  · intro q copySep productSep dataSep w loaded
    exact inverseKeep q dataSep w (productKeep q productSep w (copyKeep q copySep w loaded))

/- Both sides and the false !out_ntt skip: the complete loop tail. -/
theorem tail_shape : MakeFgTailShape190.r0=MakeFgSequence187.append SecondStepPair203.fSteps
    (MakeFgSequence187.append SecondStepPair203.gSteps (.seq MakeFgTailShape190.s8 KeygenMakeFgSource.skip)) :=
  SecondStepPair203.tail_shape

theorem out_skip (s : State) (p p0i r2 : BitVec 32) (h : Basic s u p p0i r2) :
    Exec MakeFgTailShape190.s8 s ⟨s,.normal⟩ := by
  rw [MakeFgTailShape190.s8_shape]
  exact SelectedStepOutNtt194.source s h.outCell

theorem sourcePair (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<3) (tws F G : Nat → BitVec 32)
    (twLoads : ∀ k<128, Load32 s.heap (elem igm k) (tws k))
    (fData : ∀ j<128, Load32 s.heap (addr fs u j 3) (F j))
    (gData : ∀ j<128, Load32 s.heap (addr gs u j 3) (G j))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec MakeFgTailShape190.r0 s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧ Cell out "v".toList 64 ∧
      Image out fd u 6 64 p p0i r2 F 64 ∧ Image out gd u 6 64 p p0i r2 G 64 ∧
      (∀ j<128, Load32 out.heap (addr fs u j 3) (scaledWord 6 F tws p p0i j)) ∧
      (∀ j<128, Load32 out.heap (addr gs u j 3) (scaledWord 6 G tws p p0i j)) ∧
      (∀ k<128, Load32 out.heap (elem igm k) (tws k)) ∧
      (∀ q : ArrayPointer,
        (∀ i : Fin 128, Separate (elem t1 i.val) q) →
        (∀ i : Fin 64, Separate (addr fd u i.val 6) q) →
        (∀ i : Fin 64, Separate (addr gd u i.val 6) q) →
        (∀ j<128, Separate (addr fs u j 3) q) →
        (∀ j<128, Separate (addr gs u j 3) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨first,fRun,fBasic,fV,fProduct,fImage,fKeep⟩ :=
    sourceCol .f s u p p0i r2 h bound tws F twLoads fData old declared
  have twFirst : ∀ k<128, Load32 first.heap (elem igm k) (tws k) := by
    intro k slot
    exact fKeep _ (copy_twiddle k slot) (fun i => product_twiddle .f u i.val k bound i.isLt)
      (fun j jb => tw_sepI .f u j k bound jb) _ (twLoads k slot)
  have gFirst : ∀ k<128, Load32 first.heap (addr gs u k 3) (G k) := by
    intro k slot
    exact fKeep _ (copy_data .g u k bound slot) (fun i => product_data .f .g u i.val u k bound i.isLt)
      (fun j jb => fs_gs u j u k bound jb) _ (gData k slot)
  obtain ⟨out,gRun,outBasic,outV,gProduct,gImage,gKeep⟩ :=
    sourceCol .g first u p p0i r2 fBasic bound tws G twFirst gFirst (some (u64 64)) fV
  have skipped := out_skip out p p0i r2 outBasic
  have gRaw : Exec (MakeFgSequence187.append SecondStepPair203.gSteps KeygenMakeFgSource.skip) first ⟨out,.normal⟩ := by
    simpa only [SecondStepPair203.gSteps,SecondStepColumn203.g_shape] using gRun
  have gTail := MakeFgSplice203.append SecondStepPair203.gSteps (.seq MakeFgTailShape190.s8 KeygenMakeFgSource.skip)
    first out ⟨out,.normal⟩ gRaw
    (.seqNormal _ _ out out _ skipped (SelectedStepAddPrime195.skip_run out))
  have fRaw : Exec (MakeFgSequence187.append SecondStepPair203.fSteps KeygenMakeFgSource.skip) s ⟨first,.normal⟩ := by
    simpa only [SecondStepPair203.fSteps,SecondStepColumn203.f_shape] using fRun
  have run : Exec MakeFgTailShape190.r0 s ⟨out,.normal⟩ := by
    rw [tail_shape]
    exact MakeFgSplice203.append SecondStepPair203.fSteps _ s first _ fRaw gTail
  refine ⟨out,run,outBasic,outV,?_,gProduct,?_,gImage,?_,?_⟩
  · intro i bound'
    exact gKeep _ (fun j => StepCopyFixed190.separate_symm (product_t1 .f u i.val j.val bound i.isLt j.isLt))
      (fun j => StepCopyFixed190.separate_symm (product_cross u u i.val j.val bound bound i.isLt j.isLt))
      (fun j _ => StepCopyFixed190.separate_symm (product_data .f .g u i.val u j bound i.isLt))
      _ (fProduct i bound')
  · intro j bound'
    exact gKeep _ (fun i => copy_data .f u j bound bound' i)
      (fun i => product_data .g .f u i.val u j bound i.isLt)
      (fun i _ => StepCopyFixed190.separate_symm (fs_gs u j u i bound bound')) _ (fImage j bound')
  · intro k slot
    exact gKeep _ (fun i => copy_twiddle k slot i)
      (fun i => product_twiddle .g u i.val k bound i.isLt)
      (fun j b => tw_sepI .g u j k bound b) _ (twFirst k slot)
  · intro q tSep fdSep gdSep fsSep gsSep w loaded
    exact gKeep q tSep (fun i => gdSep i) (fun j => gsSep j) w (fKeep q tSep (fun i => fdSep i) (fun j => fsSep j) w loaded)

end FT1536.Source3.ThirdStepMarch215
