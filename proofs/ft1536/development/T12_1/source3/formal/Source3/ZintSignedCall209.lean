import Source3.ZintSignedWhole209

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSignedCall209
open C99ArrayReference (State Name Arg Pointer Bind bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64)
open C99NatWord141 (word)
open StepCopyBody190 (elem)
open ZintModSignedWord194 (msFresh msRx msR2 msP0i msP)
open KeygenZintCall (Exec)

def args (dataName lenName : String) : List Arg := [.pointer dataName.toList C99ProcedureParser.zero,
  .scalar (.var lenName.toList),.scalar (.var "p".toList),.scalar (.var "p0i".toList),.scalar (.var "R2".toList),.scalar (.var "Rx".toList)]
 def withLen (s : State) (n : Nat) (p pi r2 rx : BitVec 32) := set64 (msP s p pi r2 rx) "dlen" (word n)
 def entry (s : State) (pd : ArrayPointer) (n : Nat) (p pi r2 rx : BitVec 32) := bindPointer (withLen s n p pi r2 rx) "d".toList pd

theorem cells (s : State) (pd : ArrayPointer) (n : Nat) (p pi r2 rx : BitVec 32) :
    (entry s pd n p pi r2 rx).arrays "d".toList=some pd ∧ Cell (entry s pd n p pi r2 rx) "dlen".toList n ∧
      Slot (entry s pd n p pi r2 rx) "p" p ∧ Slot (entry s pd n p pi r2 rx) "p0i" pi ∧
      Slot (entry s pd n p pi r2 rx) "R2" r2 ∧ Slot (entry s pd n p pi r2 rx) "Rx" rx := by
  refine ⟨?_,?_,?_,?_,?_,?_⟩
  · simp only [entry,bindPointer,ite_true]
  · change Cell (withLen s n p pi r2 rx) "dlen".toList n
    exact CrtState205.cell64 _ _ _
  · change Slot (withLen s n p pi r2 rx) "p" p
    exact (CrtState205.keep64 (msP s p pi r2 rx) "dlen" "p" (word n) (by decide)).trans
      (CrtState205.cell32 (msP0i s pi r2 rx) "p" p)
  · change Slot (withLen s n p pi r2 rx) "p0i" pi
    exact (CrtState205.keep64 (msP s p pi r2 rx) "dlen" "p0i" (word n) (by decide)).trans
      ((CrtState205.keep32 (msP0i s pi r2 rx) "p" "p0i" p (by decide)).trans (CrtState205.cell32 (msR2 s r2 rx) "p0i" pi))
  · change Slot (withLen s n p pi r2 rx) "R2" r2
    exact (CrtState205.keep64 (msP s p pi r2 rx) "dlen" "R2" (word n) (by decide)).trans
      ((CrtState205.keep32 (msP0i s pi r2 rx) "p" "R2" p (by decide)).trans
        ((CrtState205.keep32 (msR2 s r2 rx) "p0i" "R2" pi (by decide)).trans (CrtState205.cell32 (msRx s rx) "R2" r2)))
  · change Slot (withLen s n p pi r2 rx) "Rx" rx
    exact (CrtState205.keep64 (msP s p pi r2 rx) "dlen" "Rx" (word n) (by decide)).trans
      ((CrtState205.keep32 (msP0i s pi r2 rx) "p" "Rx" p (by decide)).trans
        ((CrtState205.keep32 (msR2 s r2 rx) "p0i" "Rx" pi (by decide)).trans
          ((CrtState205.keep32 (msRx s rx) "R2" "Rx" r2 (by decide)).trans (CrtState205.cell32 (msFresh s) "Rx" rx))))

theorem binding (dataName lenName : String) (s : State) (pd : ArrayPointer) (n : Nat) (p pi r2 rx : BitVec 32)
    (db : s.arrays dataName.toList=some pd) (lc : Cell s lenName.toList n)
    (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (rc : Slot s "R2" r2) (rxc : Slot s "Rx" rx) (cap : pd.index+0 ≤ pd.count) :
    Bind s (KeygenZintCall.params .modSigned) (args dataName lenName) (entry s pd n p pi r2 rx) := by
  have ptr : Pointer s dataName.toList C99ProcedureParser.zero pd :=
    .add _ _ pd pd (.uint64 0) db (.literal .uint64 0) (by decide) (.within pd 0 cap)
  refine .pointer _ _ _ _ _ _ _ ptr ?_
  refine .scalar .uint64 "dlen".toList (.var lenName.toList) _ _ _ (.uint64 (word n)) (.variable _ _ _ lc) ?_
  refine .scalar .uint32 "p".toList (.var "p".toList) _ _ _ (.uint32 p) (.variable _ _ _ pc) ?_
  refine .scalar .uint32 "p0i".toList (.var "p0i".toList) _ _ _ (.uint32 pi) (.variable _ _ _ ic) ?_
  refine .scalar .uint32 "R2".toList (.var "R2".toList) _ _ _ (.uint32 r2) (.variable _ _ _ rc) ?_
  exact .scalar .uint32 "Rx".toList (.var "Rx".toList) _ _ _ (.uint32 rx) (.variable _ _ _ rxc) .nil

theorem source (dataName lenName destination : String) (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32)
    (p pi r2 rx : BitVec 32) (old : Option C99IntegerReference.Value)
    (db : s.arrays dataName.toList=some pd) (lc : Cell s lenName.toList n)
    (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (rc : Slot s "R2" r2) (rxc : Slot s "Rx" rx)
    (declared : s.locals destination.toList=some (.uint32,old)) (nb : n < 2^64) (cap : pd.index+n ≤ pd.count)
    (data : ∀ i, i < n → Load32 s.heap (elem pd i) (W i)) :
    Exec (.call .modSigned (args dataName lenName) (.into destination.toList)) s
      ⟨set32 s destination (ZintSignedWhole209.resultWord W n p pi r2 rx),.normal⟩ := by
  have holds:=cells s pd n p pi r2 rx
  have fixed : ZintReduceLoop209.Fixed (entry s pd n p pi r2 rx) pd n W p pi r2 :=
    ⟨nb,holds.1,holds.2.1,holds.2.2.1,holds.2.2.2.1,holds.2.2.2.2.1,cap,data⟩
  obtain ⟨out,run,returned,heap,_,_⟩:=ZintSignedWhole209.source (entry s pd n p pi r2 rx) pd n W p pi r2 rx fixed holds.2.2.2.2.2
  refine .call s .modSigned (args dataName lenName) (.into destination.toList) (entry s pd n p pi r2 rx) out
    (some (.uint32 (ZintSignedWhole209.resultWord W n p pi r2 rx))) _
    (binding dataName lenName s pd n p pi r2 rx db lc pc ic rc rxc (by omega)) run returned ?_
  rw [heap]
  exact .into _ _ .uint32 old _ declared

end FT1536.Source3.ZintSignedCall209
