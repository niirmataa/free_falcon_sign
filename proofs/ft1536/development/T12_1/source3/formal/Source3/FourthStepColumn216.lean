import Source3.FourthStepInverse216

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The first slen = 6 prime loop of the d=4 body (the marsze layer):
   the original `for (u = 0; u < slen; u ++)` over the PRIMES3 rows 0..5
   at n = 64 / hn = 32, with its copy marches at stride 6, the false
   !in_ntt skips, the fd/gd Montgomery product marches, the taken in_ntt
   modp_iNTT3_ext column visits at Level 5 (logn 6) and the modp_mkgm3
   generator of FourthStepGenerator216. All words are executed words of
   the actual table rows and source bodies; no NTT/root/table law is
   claimed. -/
namespace FT1536.Source3.FourthStepMarch216
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
open FourthStepLayout216 (fd gd fs gs gm igm t1)
open FourthStepGenerator216 (Basic Outer gVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open NttInverseCorrectionLoop192 (walk)
open NttInverseWholeBridges201 (scaledWord)
open KeygenStaticTables (values)
open KeygenFullData127 (primes rev)
open SecondStepProduct203 (root)

/- One side of the loop tail: copy march, skipped !in_ntt branch, product
   march and the iNTT column visit. -/
theorem sourceCol (side : Side) (s : State) (u : Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (bound : u<6) (tws F : Nat → BitVec 32)
    (twLoads : ∀ k<64, Load32 s.heap (elem igm k) (tws k))
    (data : ∀ j<64, Load32 s.heap (addr (croot side) u j 6) (F j))
    (old : Option C99IntegerReference.Value) (declared : s.locals "v".toList=some (.uint64,old)) :
    ∃ out, Exec (SecondStepColumn203.code side) s ⟨out,.normal⟩ ∧ Basic out u p p0i r2 ∧
      Cell out "v".toList 32 ∧ Image out (root side) u 12 32 p p0i r2 F 32 ∧
      (∀ j<64, Load32 out.heap (addr (croot side) u j 6) (scaledWord 5 F tws p p0i j)) ∧
      (∀ q : ArrayPointer,
        (∀ i : Fin 64, Separate (elem t1 i.val) q) →
        (∀ i : Fin 32, Separate (addr (root side) u i.val 12) q) →
        (∀ j<64, Separate (addr (croot side) u j 6) q) →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨copied,copyRun,copyBasic,copyV,copiedImage,copyLocals,copyArrays,copyKeep⟩ :=
    sourceC side s u p p0i r2 h bound (fun i => F i.val) (fun i => data i.val i.isLt) old declared
  have skipped := skipC_source side copied u p p0i r2 copyBasic
  have copyTw : ∀ k<64, Load32 copied.heap (elem igm k) (tws k) := by
    intro k slot
    exact copyKeep (elem igm k) (copy_twiddle k slot) (tws k) (twLoads k slot)
  have copyData : ∀ j<64, Load32 copied.heap (addr (croot side) u j 6) (F j) := by
    intro j slot
    exact copyKeep _ (copy_data side u j bound slot) (F j) (data j slot)
  obtain ⟨products,productRun,productBasic,productV,productImage,productLocals,productArrays,productKeep⟩ :=
    FourthStepProduct216.source side copied u p p0i r2 copyBasic (by omega) F
      (fun i => copiedImage i i.isLt) (some (u64 64)) copyV
  have productTw : ∀ k<64, Load32 products.heap (elem igm k) (tws k) := by
    intro k slot
    exact productKeep _ (fun i => product_twiddle side u i.val k bound i.isLt) _ (copyTw k slot)
  have productData : ∀ j<64, Load32 products.heap (addr (croot side) u j 6) (F j) := by
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


end FT1536.Source3.FourthStepMarch216
