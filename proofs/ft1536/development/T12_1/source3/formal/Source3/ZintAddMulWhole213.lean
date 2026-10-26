import Source3.ZintAddMulLoop213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintAddMulWhole213
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open CrtState205 (set32 set64)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open ZintAddMulFixed213 (Fixed Pending Written carryWord outputWord)
open ZintMulWord205 (s1 s2 s3 s4)
open KeygenWordExec (Exec)
open ZintNormWalkFlat208 (Data)

def words (av bv : Nat → BitVec 32) (c : BitVec 32) (n i : Nat) :=
  if i<n then outputWord av bv c i else carryWord av bv c n

theorem source (s : State) (pa pb : ArrayPointer) (n : Nat) (av bv : Nat → BitVec 32) (c : BitVec 32)
    (fixed : Fixed s pa pb n bv c) (initial : ∀ i, i < n → Load32 s.heap (elem pa i) (av i)) :
    ∃ out : State, Exec (KeygenZintLeaves.code .addMul) s ⟨out,.normal⟩ ∧ Data out pa (n+1) (words av bv c n) ∧
      (∀ name : Name, name≠ZintMulWord205.u → name≠ZintMulWord205.cc → out.locals name=s.locals name) ∧
      out.arrays=s.arrays ∧
      (∀ q old, (∀ i, i ≤ n → Separate (elem pa i) q) → Load32 s.heap q old → Load32 out.heap q old) := by
  have h1 : Exec ZintMulWord205.declU s ⟨s1 s,.normal⟩ := ZintSubWord194.declare_run .u64 [ZintMulWord205.u] s
  have h2 : Exec ZintMulWord205.declCC (s1 s) ⟨s2 s,.normal⟩ := ZintSubWord194.declare_run .u32 [ZintMulWord205.cc] (s1 s)
  have h3 : Exec ZintMulWord205.cc0 (s2 s) ⟨s3 s,.normal⟩ :=
    .assign _ _ _ .uint32 none (.int32 0) (ZintSubWord194.effect_one_cell .u32 ZintMulWord205.cc (s1 s)) (WordAtoms205.literal _ 0)
  have ud : (s3 s).locals ZintMulWord205.u=some (.uint64,none) := by
    change (set32 (s2 s) "cc" 0).locals "u".toList=_
    rw [CrtState205.keep32 _ "cc" "u" 0 (by decide)]
    unfold s2
    rw [ZintSubWord194.effect_one_other .u32 "cc".toList "u".toList (s1 s) (by decide)]
    exact ZintSubWord194.effect_one_cell .u64 "u".toList s
  have h4 : Exec ZintMulWord205.u0 (s3 s) ⟨s4 s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.int32 0) ud (WordAtoms205.literal _ 0)
  have startFixed : Fixed (s4 s) pa pb n bv c := by
    refine ⟨fixed.nBound,fixed.width,fixed.capacity,fixed.writable,fixed.aBinding,fixed.bBinding,?_,?_,fixed.tailAllocated,fixed.bRead,fixed.apart⟩
    · exact (ZintAddMulWord205.before4 s ZintAddMulWord205.len (by decide) (by decide)).trans fixed.lenCell
    · exact (ZintAddMulWord205.before4 s "s".toList (by decide) (by decide)).trans fixed.sCell
  have uStart : Cell (s4 s) ZintMulWord205.u 0 := ZintMulWord205.u4 s
  have ccStart : Slot (s4 s) "cc" (carryWord av bv c 0) :=
    (CrtState205.keep64 (s3 s) "u" "cc" 0 (by decide)).trans (CrtState205.cell32 _ _ _)
  obtain ⟨mid,loopRun,finalFixed,_,ccFinal,written,locals,arrays,keep⟩:=
    ZintAddMulLoop213.remaining n 0 (s4 s) pa pb n av bv c startFixed uStart ccStart
      (fun i _ bound => initial i bound) (fun i h => by omega) (by omega)
  let out : State := {mid with heap:=Word32Memory176.write mid.heap (elem pa n) (carryWord av bv c n)}
  have ptr : C99ArrayReference.Pointer mid ZintAddMulWord205.x (.var ZintAddMulWord205.len) (elem pa n) := by
    refine .add _ _ pa _ (.uint64 (C99NatWord141.word n)) finalFixed.aBinding (.variable _ _ _ finalFixed.lenCell) ?_ ?_
    · rw [C99NatWord141.integer n fixed.nBound]; omega
    · rw [C99NatWord141.integer n fixed.nBound]; exact .within pa n (by have cap:=fixed.capacity; omega)
  have store : Exec (.store ZintAddMulWord205.x (.var ZintAddMulWord205.len) (.scalar (.var ZintMulWord205.cc))) mid ⟨out,.normal⟩ :=
    .store _ _ _ _ _ (elem pa n) (.uint32 (carryWord av bv c n)) ptr (CrtState205.expr32 mid "cc" _ ccFinal) (by
      change C99MemoryReference.Store32 mid.heap (elem pa n) (BitVec.ofInt 32 ((carryWord av bv c n).toNat : Int)) _
      rw [ZintSubWord194.ofInt_word]
      exact Word32Memory176.source _ _ _ finalFixed.tailAllocated finalFixed.width finalFixed.writable)
  have tail : Exec ZintAddMulWord205.tail mid ⟨out,.normal⟩ := .seqNormal _ _ _ _ _ store (ZintSubWord194.skip_run out)
  have full : Exec ZintAddMulWord205.body s ⟨out,.normal⟩ :=
    .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3
      (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ h4 loopRun) tail)))
  refine ⟨out,by rw [ZintAddMulWord205.shape]; exact full,?_,?_,arrays,?_⟩
  · intro i bound
    by_cases low : i<n
    · simp only [words,low,ite_true]
      exact Word32Memory176.outside mid.heap (elem pa n) (elem pa i) _ _
        (StepCopyFixed203.elem_separate pa fixed.width n i (by omega)) (written i low)
    · have eq : i=n := by omega
      subst i
      simp only [words,Nat.lt_irrefl,ite_false]
      exact Word32Memory176.here mid.heap (elem pa n) _ finalFixed.tailAllocated finalFixed.width finalFixed.writable
  · intro name nu nc
    exact (locals name nu nc).trans (ZintAddMulWord205.before4 s name nu nc)
  · intro q old apart read
    exact Word32Memory176.outside mid.heap (elem pa n) q _ old (apart n (Nat.le_refl n))
      (keep q old (fun i bound => apart i (by omega)) read)

end FT1536.Source3.ZintAddMulWhole213
