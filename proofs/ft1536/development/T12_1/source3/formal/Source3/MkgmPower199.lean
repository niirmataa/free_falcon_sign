import Source3.MkgmRowPreludeFacts199

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmPower199
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open ModularAtoms178 (set cell mont assign outside slot)
open MkgmControl199 (word)
open MkgmParams198 (Level logn)

def square (g p p0i : BitVec 32) := KeygenModpWord.montgomery g g p p0i
def words (g p p0i : BitVec 32) : Nat → BitVec 32
  | 0 => g
  | n+1 => words (square g p p0i) p p0i n

def loopBody : C99ModularReference.Stmt := .seq (KeygenMkgm3Program.inc "k")
  (.scope [] (C99ModularReference.chainOf [.assign "g".toList KeygenMkgm3Program.montGG]))
def loop : C99ModularReference.Stmt := .loop
  (.cmp .lt (KeygenMkgm3Program.var "k") (KeygenMkgm3Program.num 11)) loopBody (.base .skip)

theorem remaining (n k : Nat) (finish : k+n=11) (s : State) (g p p0i : BitVec 32)
    (kc : Slot s "k" (word k)) (gc : Slot s "g" g) (pc : Slot s "p" p) (ic : Slot s "p0i" p0i) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Slot out "k" (word 11) ∧
      Slot out "g" (words g p p0i n) ∧ Slot out "p" p ∧ Slot out "p0i" p0i := by
  induction n generalizing k s g with
  | zero =>
    have same : k=11 := by omega
    subst k
    have guard : C99ArrayReference.scalar s
        (.cmp .lt (KeygenMkgm3Program.var "k") (KeygenMkgm3Program.num 11)) (.int32 0) := by
      simpa [C99ScalarReference.boolean] using MkgmControl199.guard s 11 (by decide) kc
    exact ⟨s,.loopFalse _ _ _ _ (.int32 0) guard rfl,kc,gc,pc,ic⟩
  | succ n ih =>
    have bound : k<11 := by omega
    let inc := set s "k" (word (k+1))
    let squared := set inc "g" (square g p p0i)
    have incRun : Exec (KeygenMkgm3Program.inc "k") s ⟨inc,.normal⟩ :=
      MkgmControl199.increment s k (by omega) kc
    have gp : Slot inc "g" g := (outside s "k" "g" (word (k+1)) (by decide)).trans gc
    have pp : Slot inc "p" p := (outside s "k" "p" (word (k+1)) (by decide)).trans pc
    have ip : Slot inc "p0i" p0i := (outside s "k" "p0i" (word (k+1)) (by decide)).trans ic
    have squareRun : Exec (.assign "g".toList KeygenMkgm3Program.montGG) inc ⟨squared,.normal⟩ :=
      assign inc "g" (some (.uint32 g)) _ (square g p p0i) gp
        (mont inc _ _ g g p p0i (cell inc "g" g gp) (cell inc "g" g gp) pp ip)
    have scopedRun : Exec (.scope [] (C99ModularReference.chainOf
        [.assign "g".toList KeygenMkgm3Program.montGG])) inc ⟨squared,.normal⟩ := by
      have run := C99ModularReference.GenExec.scope [] _ inc ⟨squared,.normal⟩
        (.seqNormal _ _ inc squared ⟨squared,.normal⟩ squareRun (.base .skip _ _ (.skip _)))
      simpa only [C99ModularReference.chainOf,KeygenPublicForwardCall.restore_empty] using run
    have iteration : Exec loopBody s ⟨squared,.normal⟩ := .seqNormal _ _ s inc _ incRun scopedRun
    have nk : Slot squared "k" (word (k+1)) :=
      (outside inc "g" "k" (square g p p0i) (by decide)).trans (slot s "k" (word (k+1)))
    have ng : Slot squared "g" (square g p p0i) := slot inc "g" (square g p p0i)
    have np : Slot squared "p" p := (outside inc "g" "p" (square g p p0i) (by decide)).trans pp
    have ni : Slot squared "p0i" p0i := (outside inc "g" "p0i" (square g p p0i) (by decide)).trans ip
    obtain ⟨out,rest,outK,outG,outP,outI⟩ := ih (k+1) (by omega) squared (square g p p0i) nk ng np ni
    have nonzero : (C99ScalarReference.boolean (decide (k<11))).integer≠0 := by
      simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact ⟨out,.loopNormal _ _ _ s squared squared ⟨out,.normal⟩ _
      (MkgmControl199.guard s k (by omega) kc) nonzero iteration (.base .skip _ _ (.skip _)) rest,
      outK,outG,outP,outI⟩

theorem source (l : Level) (s : State) (g p p0i : BitVec 32)
    (kc : Slot s "k" (word (logn l+1))) (gc : Slot s "g" g)
    (pc : Slot s "p" p) (ic : Slot s "p0i" p0i) :
    ∃ out, Exec KeygenMkgm3Program.whileK s ⟨out,.normal⟩ ∧ Slot out "k" (word 12) ∧
      Slot out "g" (words g p p0i (10-logn l)) ∧ Slot out "p" p ∧ Slot out "p0i" p0i := by
  have range := MkgmParams198.logn_range l
  obtain ⟨middle,run,mk,mg,mp,mi⟩ := remaining (10-logn l) (logn l+1) (by omega) s g p p0i kc gc pc ic
  let out := set middle "k" (word 12)
  have increment : Exec (KeygenMkgm3Program.inc "k") middle ⟨out,.normal⟩ :=
    MkgmControl199.increment middle 11 (by decide) mk
  exact ⟨out,.seqNormal _ _ s middle _ run increment,slot middle "k" (word 12),
    (outside middle "k" "g" (word 12) (by decide)).trans mg,
    (outside middle "k" "p" (word 12) (by decide)).trans mp,
    (outside middle "k" "p0i" (word 12) (by decide)).trans mi⟩

end FT1536.Source3.MkgmPower199
