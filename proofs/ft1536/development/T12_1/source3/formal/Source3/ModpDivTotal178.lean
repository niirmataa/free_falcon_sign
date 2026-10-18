import Source3.ModpDivSetup178
import Source3.ModpDivLoopWord178
import Source3.ScalarArgumentValues178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModpDivTotal178
open C99ArrayReference (State bindValue)
open C99ModularReference
open KeygenModpR2Exec (Slot cell_exists)
open ModularAtoms178 (set slot)
open ModpDivStep178 (Fixed leaf_mont)

def finishWord (a z p p0i : BitVec 32) := KeygenModpWord.montgomery a (KeygenModpWord.montgomery z 1 p p0i) p p0i
def word (a b p p0i r : BitVec 32) := finishWord a (ModpDivLoopWord178.word b p p0i (p-2) 31 r) p p0i

def normalize : Stmt := .assign "z".toList (.call4 "modp_montymul".toList (.scalar (.var "z".toList))
  (.scalar (.literal .i32 1)) (.scalar (.var "p".toList)) (.scalar (.var "p0i".toList)))
def returnCode : Stmt := .ret (.call4 "modp_montymul".toList (.scalar (.var "a".toList))
  (.scalar (.var "z".toList)) (.scalar (.var "p".toList)) (.scalar (.var "p0i".toList)))
def finish : List Stmt := [normalize,returnCode]

theorem finish_source (s : State) (a b p p0i e z : BitVec 32)
    (fixed : Fixed s a b p p0i e) (hz : Slot s "z" z) :
    ∃ out, GenExec LeafCall (chainOf finish) s ⟨out,.returned (some (.uint32 (finishWord a z p p0i)))⟩ := by
  let normalized := KeygenModpWord.montgomery z 1 p p0i
  let last := set s "z" normalized
  let w := KeygenModpWord.montgomery a normalized p p0i
  have write : GenExec LeafCall normalize s ⟨last,.normal⟩ :=
    .assign _ _ _ .uint32 (some (.uint32 z)) (.uint32 normalized) hz
      (.call4 _ _ _ _ _ _ _ _ _ _ (cell_exists s "z" z hz) (.scalar _ _ (.literal .int32 1))
        (cell_exists s "p" p fixed.2.2.1) (cell_exists s "p0i" p0i fixed.2.2.2.1)
        (.montgomery _ _ (ScalarArgumentValues178.mont_one z p p0i)))
  have returned : GenExec LeafCall returnCode last ⟨last,.returned (some (.uint32 w))⟩ :=
    .ret _ last (.uint32 w) (leaf_mont last _ _ a normalized p p0i
      (cell_exists last "a" a fixed.1) (cell_exists last "z" normalized (slot s "z" normalized))
      fixed.2.2.1 fixed.2.2.2.1)
  exact ⟨last,.seqNormal _ _ s last _ write
    (.seqExit _ _ last _ returned (by intro impossible; cases impossible))⟩

theorem source (s : State) (a b p p0i r : BitVec 32) :
    ∃ out, GenExec LeafCall divCode (ModpDivSetup178.entry s a b p p0i r)
      ⟨out,.returned (some (.uint32 (word a b p p0i r)))⟩ := by
  let initial := ModpDivSetup178.entry s a b p p0i r
  let prepared := ModpDivSetup178.after initial p r
  let counted := bindValue prepared "i".toList .int32 (.int32 30)
  have counter : GenExec LeafCall (.assign "i".toList (.scalar (.literal .i32 30))) prepared ⟨counted,.normal⟩ :=
    .assign _ _ _ .int32 none (.int32 30) (ModpDivSetup178.i_declared initial p r) (.scalar _ _ (.literal .int32 30))
  have params : Fixed counted a b p p0i (p-2) := ModpDivSetup178.fixed s a b p p0i r
  have hz : Slot counted "z" r := ModpDivSetup178.z_slot initial p r
  obtain ⟨middle,loopRun,middleFixed,middleZ,_,_⟩ := ModpDivLoopWord178.source 31 (by decide)
    counted a b p p0i (p-2) r params hz rfl
  obtain ⟨last,tail⟩ := finish_source middle a b p p0i (p-2) (ModpDivLoopWord178.word b p p0i (p-2) 31 r) middleFixed middleZ
  refine ⟨last,?_⟩
  apply ModularSequence178.source LeafCall ModpDivSetup178.steps initial prepared
    (ModpDivSetup178.source initial p r (ModpDivSetup178.entry_p s a b p p0i r)
      (ModpDivSetup178.entry_r s a b p p0i r)) (divLoop::finish) _
  exact .seqNormal _ _ prepared middle _ (.seqNormal _ _ prepared counted _ counter loopRun) tail

theorem source_exists (s : State) (a b p p0i r : BitVec 32) :
    divBody [.uint32 a,.uint32 b,.uint32 p,.uint32 p0i,.uint32 r] (.uint32 (word a b p p0i r)) := by
  obtain ⟨out,run⟩ := source s a b p p0i r
  exact ⟨s,out,run⟩

end FT1536.Source3.ModpDivTotal178
