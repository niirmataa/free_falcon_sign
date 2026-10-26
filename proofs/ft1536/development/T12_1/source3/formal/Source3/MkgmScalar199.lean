import Source3.MkgmPower199

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmScalar199
open C99ArrayReference (State)
open C99ModularReference (Exec ModCall chainOf)
open KeygenMkgm3Program
open KeygenModpR2Exec (Slot)
open ModularAtoms178 (set cell assign mont slot outside)
open MkgmParams198 (Level logn lognWord)
open MkgmControl199 (word)

def rWord (p : BitVec 32) := KeygenModpR.word p
def r2Word (p p0i : BitVec 32) := KeygenModpR2Word.word p p0i
def convertedWord (g p p0i : BitVec 32) := KeygenModpWord.montgomery g (r2Word p p0i) p p0i
def cubeWord (g p p0i : BitVec 32) := KeygenModpWord.montgomery (convertedWord g p p0i)
  (KeygenModpWord.montgomery (convertedWord g p p0i) (convertedWord g p p0i) p p0i) p p0i
def gWord (l : Level) (g p p0i : BitVec 32) := MkgmPower199.words (cubeWord g p p0i) p p0i (10-logn l)
def igWord (l : Level) (g p p0i : BitVec 32) := ModpDivTotal178.word (r2Word p p0i) (gWord l g p p0i) p p0i (rWord p)

def declared (s : State) := GeneratorDeclarations178.after s
def withR (s : State) (p : BitVec 32) := set (declared s) "R" (rWord p)
def withR2 (s : State) (p p0i : BitVec 32) := set (withR s p) "R2" (r2Word p p0i)
def converted (s : State) (g p p0i : BitVec 32) := set (withR2 s p p0i) "g" (convertedWord g p p0i)
def withK (l : Level) (s : State) (g p p0i : BitVec 32) := set (converted s g p p0i) "k" (lognWord l)
def cubed (l : Level) (s : State) (g p p0i : BitVec 32) := set (withK l s g p p0i) "g" (cubeWord g p p0i)
def afterCube (l : Level) (s : State) (g p p0i : BitVec 32) := set (cubed l s g p p0i) "k" (word (logn l+1))

def scalarSteps := [rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]
def code := chainOf (declarations++scalarSteps)

structure Input (l : Level) (s : State) (g p p0i : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  gCell : Slot s "g" g
  lognCell : Slot s "logn" (lognWord l)
  fullCell : Slot s "full" 0

structure Ready (l : Level) (s : State) (g p p0i : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  gCell : Slot s "g" (gWord l g p p0i)
  igCell : Slot s "ig" (igWord l g p p0i)
  rCell : Slot s "R" (rWord p)
  r2Cell : Slot s "R2" (r2Word p p0i)
  lognCell : Slot s "logn" (lognWord l)
  fullCell : Slot s "full" 0
  kCell : Slot s "k" (word 12)
  uDeclared : s.locals "u".toList=some (.uint64,none)
  wDeclared : s.locals "w".toList=some (.uint32,none)

theorem declared_input (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) :
    Input l (declared s) g p p0i := by
  have run := ModularSequence178.complete _ _ _ _ (GeneratorDeclarations178.source s)
  have frame := KeygenMkgm3Control.frame _ _ _ (by decide) run
  exact ⟨(frame.2.2 _ (by decide)).trans h.pCell,(frame.2.2 _ (by decide)).trans h.iCell,
    (frame.2.2 _ (by decide)).trans h.gCell,(frame.2.2 _ (by decide)).trans h.lognCell,
    (frame.2.2 _ (by decide)).trans h.fullCell⟩

def headSteps := [rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull]

theorem rRun (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) : Exec rAssign (declared s) ⟨withR s p,.normal⟩ := by
  have d := declared_input l s g p p0i h
  have pp := d.pCell
  exact assign _ "R" none _ (rWord p) rfl (.call1 _ _ _ _ (cell _ "p" p pp) (.r _ _ (KeygenModpR.source_exists p)))

theorem r2Run (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) : Exec r2Assign (withR s p) ⟨withR2 s p p0i,.normal⟩ := by
  have d := declared_input l s g p p0i h
  have pp := d.pCell
  have ip := d.iCell
  exact assign _ "R2" none _ (r2Word p p0i) rfl
      (.call2 _ _ _ _ _ _ (cell _ "p" p pp) (cell _ "p0i" p0i ip)
        (.r2 _ _ (KeygenModpR2Exec.source_exists (withR s p) p p0i)))

theorem gRun (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) : Exec gConvert (withR2 s p p0i) ⟨converted s g p p0i,.normal⟩ := by
  have d := declared_input l s g p p0i h
  have gp := d.gCell
  have pp := d.pCell
  have ip := d.iCell
  exact assign _ "g" (some (.uint32 g)) _ (convertedWord g p p0i) gp
      (mont _ _ _ g (r2Word p p0i) p p0i (cell _ "g" g gp)
        (cell _ "R2" (r2Word p p0i) (slot (withR s p) "R2" _)) pp ip)

theorem kRun (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) : Exec kFromLogn0 (converted s g p p0i) ⟨withK l s g p p0i,.normal⟩ := by
  have d := declared_input l s g p p0i h
  have lp := d.lognCell
  exact assign _ "k" none _ (lognWord l) rfl (cell _ "logn" (lognWord l) lp)

theorem gk (l : Level) (s : State) (g p p0i : BitVec 32) : Slot (withK l s g p p0i) "g" (convertedWord g p p0i) := by
  exact (outside (converted s g p p0i) "k" "g" (lognWord l) (by decide)).trans
      (slot (withR2 s p p0i) "g" _)

theorem cubeRun (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) : Exec (.assign "g".toList tripleGG) (withK l s g p p0i) ⟨cubed l s g p p0i,.normal⟩ := by
  have d := declared_input l s g p p0i h
  have pp := d.pCell
  have ip := d.iCell
  have gk := gk l s g p p0i
  exact assign _ "g" (some (.uint32 (convertedWord g p p0i))) _ (cubeWord g p p0i) gk
      (mont _ _ _ (convertedWord g p p0i) _ p p0i (cell _ "g" _ gk)
        (mont _ _ _ (convertedWord g p p0i) (convertedWord g p p0i) p p0i
          (cell _ "g" _ gk) (cell _ "g" _ gk) pp ip) pp ip)

theorem cubeInc (l : Level) (s : State) (g p p0i : BitVec 32) : Exec (inc "k") (cubed l s g p p0i) ⟨afterCube l s g p p0i,.normal⟩ := by
  exact MkgmControl199.increment _ (logn l) (by have a:=MkgmParams198.logn_range l; omega)
      ((outside (withK l s g p p0i) "g" "k" (cubeWord g p p0i) (by decide)).trans
        (slot (converted s g p p0i) "k" (lognWord l)))

theorem scope_empty (body : C99ModularReference.Stmt) (s out : State)
    (run : Exec body s ⟨out,.normal⟩) : Exec (.scope [] body) s ⟨out,.normal⟩ := by
  have source := C99ModularReference.GenExec.scope [] body s ⟨out,.normal⟩ run
  simpa only [KeygenPublicForwardCall.restore_empty] using source

theorem cubeScoped (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) :
    Exec (.scope [] (chainOf [.assign "g".toList tripleGG,inc "k"]))
      (withK l s g p p0i) ⟨afterCube l s g p p0i,.normal⟩ :=
  scope_empty _ _ _
    (.seqNormal _ _ _ (cubed l s g p p0i) _ (cubeRun l s g p p0i h)
      (.seqNormal _ _ _ (afterCube l s g p p0i) _ (cubeInc l s g p p0i) (.base .skip _ _ (.skip _))))

theorem cube (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) : Exec ifNotFull (withK l s g p p0i) ⟨afterCube l s g p p0i,.normal⟩ := by
  have d := declared_input l s g p p0i h
  have fp := d.fullCell
  have cubeScoped := cubeScoped l s g p p0i h
  exact .branchTrue _ _ _ _ ⟨afterCube l s g p p0i,.normal⟩ (.int32 1)
      (.logicalNot _ (.uint32 0) (.variable _ _ _ fp)) (by decide) cubeScoped

theorem head_source (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) :
    ModularSequence178.Run ModCall headSteps (declared s) (afterCube l s g p p0i) := by
  have rRun := rRun l s g p p0i h
  have r2Run := r2Run l s g p p0i h
  have gRun := gRun l s g p p0i h
  have kRun := kRun l s g p p0i h
  have cube := cube l s g p p0i h
  exact .cons _ _ _ (withR s p) _ rRun
    (.cons _ _ _ (withR2 s p p0i) _ r2Run
      (.cons _ _ _ (converted s g p p0i) _ gRun
        (.cons _ _ _ (withK l s g p p0i) _ kRun
          (.cons _ _ _ (afterCube l s g p p0i) _ cube (.nil _)))))

structure HeadReady (l : Level) (s : State) (g p p0i : BitVec 32) : Prop where
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  gCell : Slot s "g" (cubeWord g p p0i)
  kCell : Slot s "k" (word (logn l+1))
  rCell : Slot s "R" (rWord p)
  r2Cell : Slot s "R2" (r2Word p p0i)
  igDeclared : s.locals "ig".toList=some (.uint32,none)
  lognCell : Slot s "logn" (lognWord l)
  fullCell : Slot s "full" 0
  uDeclared : s.locals "u".toList=some (.uint64,none)
  wDeclared : s.locals "w".toList=some (.uint32,none)

theorem afterCube_keep (l : Level) (s : State) (g p p0i : BitVec 32)
    (name : String) (notK : name.toList≠"k".toList) (notG : name.toList≠"g".toList) :
    (afterCube l s g p p0i).locals name.toList=(withR2 s p p0i).locals name.toList :=
  (outside (cubed l s g p p0i) "k" name _ notK).trans
    ((outside (withK l s g p p0i) "g" name _ notG).trans
      ((outside (converted s g p p0i) "k" name _ notK).trans
        (outside (withR2 s p p0i) "g" name _ notG)))

theorem head_ready (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) :
    HeadReady l (afterCube l s g p p0i) g p p0i := by
  have d := declared_input l s g p p0i h
  have keep (name : String) (notK : name.toList≠"k".toList) (notG : name.toList≠"g".toList)
      (notR : name.toList≠"R".toList) (notR2 : name.toList≠"R2".toList) :
      (afterCube l s g p p0i).locals name.toList=(declared s).locals name.toList :=
    (afterCube_keep l s g p p0i name notK notG).trans
      ((outside (withR s p) "R2" name _ notR2).trans (outside (declared s) "R" name _ notR))
  exact ⟨(keep "p" (by decide) (by decide) (by decide) (by decide)).trans d.pCell,
    (keep "p0i" (by decide) (by decide) (by decide) (by decide)).trans d.iCell,
    (outside (cubed l s g p p0i) "k" "g" (word (logn l+1)) (by decide)).trans (slot _ "g" _),
    slot (cubed l s g p p0i) "k" _,
    (afterCube_keep l s g p p0i "R" (by decide) (by decide)).trans
      ((outside (withR s p) "R2" "R" _ (by decide)).trans (slot (declared s) "R" _)),
    (afterCube_keep l s g p p0i "R2" (by decide) (by decide)).trans (slot (withR s p) "R2" _),
    (keep "ig" (by decide) (by decide) (by decide) (by decide)).trans rfl,
    (keep "logn" (by decide) (by decide) (by decide) (by decide)).trans d.lognCell,
    (keep "full" (by decide) (by decide) (by decide) (by decide)).trans d.fullCell,
    (keep "u" (by decide) (by decide) (by decide) (by decide)).trans rfl,
    (keep "w" (by decide) (by decide) (by decide) (by decide)).trans rfl⟩

theorem power_source (l : Level) (s : State) (g p p0i : BitVec 32) (h : HeadReady l s g p p0i) :
    ∃ out, Exec (chainOf [whileK,igAssign]) s ⟨out,.normal⟩ ∧ Ready l out g p p0i := by
  obtain ⟨power,powerRun,pk,pg,pp,ip⟩ := MkgmPower199.source l s
    (cubeWord g p p0i) p p0i h.kCell h.gCell h.pCell h.iCell
  have powerFrame := KeygenMkgm3Control.frame _ _ _ (by decide) powerRun
  have pr : Slot power "R" (rWord p) := (powerFrame.2.2 _ (by decide)).trans h.rCell
  have pr2 : Slot power "R2" (r2Word p p0i) := (powerFrame.2.2 _ (by decide)).trans h.r2Cell
  have igFree : power.locals "ig".toList=some (.uint32,none) :=
    (powerFrame.2.2 _ (by decide)).trans h.igDeclared
  let out := set power "ig" (igWord l g p p0i)
  have igRun : Exec igAssign power ⟨out,.normal⟩ :=
    assign power "ig" none _ (igWord l g p p0i) igFree
      (.call5 _ _ _ _ _ _ _ _ _ _ _ _ (cell _ "R2" _ pr2) (cell _ "g" _ pg)
        (cell _ "p" p pp) (cell _ "p0i" p0i ip)
        (.call1 _ _ _ _ (cell _ "p" p pp) (.r _ _ (KeygenModpR.source_exists p)))
        (.div _ _ (ModpDivTotal178.source_exists power (r2Word p p0i) (gWord l g p p0i) p p0i (rWord p))))
  have run : Exec (chainOf [whileK,igAssign]) s ⟨out,.normal⟩ :=
    .seqNormal _ _ _ power _ powerRun (.seqNormal _ _ _ out _ igRun (.base .skip _ _ (.skip _)))
  have frame := KeygenMkgm3Control.frame _ _ _ (by decide) run
  refine ⟨out,run,?_,⟩
  exact ⟨(outside power "ig" "p" _ (by decide)).trans pp,
    (outside power "ig" "p0i" _ (by decide)).trans ip,
    (outside power "ig" "g" _ (by decide)).trans pg,slot power "ig" _,
    (outside power "ig" "R" _ (by decide)).trans pr,
    (outside power "ig" "R2" _ (by decide)).trans pr2,
    (frame.2.2 _ (by decide)).trans h.lognCell,(frame.2.2 _ (by decide)).trans h.fullCell,
    (outside power "ig" "k" _ (by decide)).trans pk,
    (frame.2.2 _ (by decide)).trans h.uDeclared,(frame.2.2 _ (by decide)).trans h.wDeclared⟩

theorem source (l : Level) (s : State) (g p p0i : BitVec 32) (h : Input l s g p p0i) :
    ∃ out, Exec code s ⟨out,.normal⟩ ∧ Ready l out g p p0i ∧ out.heap=s.heap ∧ out.arrays=s.arrays := by
  obtain ⟨out,powerRun,ready⟩ := power_source l (afterCube l s g p p0i) g p p0i (head_ready l s g p p0i h)
  have tail : Exec (chainOf scalarSteps) (declared s) ⟨out,.normal⟩ :=
    ModularSequence178.source ModCall headSteps (declared s) (afterCube l s g p p0i)
      (head_source l s g p p0i h) [whileK,igAssign] _ powerRun
  have run : Exec code s ⟨out,.normal⟩ :=
    ModularSequence178.source ModCall declarations s (declared s) (GeneratorDeclarations178.source s) scalarSteps _ tail
  have frame := KeygenMkgm3Control.frame _ _ _ (by decide) run
  exact ⟨out,run,ready,KeygenMkgm3Atoms.pure_heap _ _ _ (by decide) run,frame.2.1⟩

end FT1536.Source3.MkgmScalar199
