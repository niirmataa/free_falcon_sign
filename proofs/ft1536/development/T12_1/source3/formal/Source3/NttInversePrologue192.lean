import Source3.NttInversePrograms192
import Source3.NttPrologue182
import Source3.StepProductBody191

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Prologue execution of the accepted modp_iNTT3_ext corpus at the entry
   state of the call: the size/word/pointer declarations, the false logn0
   guard and the MKN assignments at logn 9 / full 0, giving n=512 and
   hn=256. Values are only the executed integer operations; no transform
   property or table law is assumed. -/
namespace FT1536.Source3.NttInversePrologue192
open C99ArrayReference (State Name bindValue)
open C99ModularReference (Exec)
open C99IntegerReference (Value Ty)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)

def names : List Name := ["n","hn","u","r","m","t"].map String.toList
def wordNames : List Name := ["w","ni","R"].map String.toList
def pointerNames : List Name := ["r1".toList,"r2".toList]

def afterSize (s : State) : State := C99DeclarationStatements.effect .u64 names s
def afterW (s : State) : State := C99DeclarationStatements.effect .u32 ["w".toList] (afterSize s)
def afterNi (s : State) : State := C99DeclarationStatements.effect .u32 ["ni".toList] (afterW s)
def afterR (s : State) : State := C99DeclarationStatements.effect .u32 ["R".toList] (afterNi s)
def afterR1 (s : State) : State := DeepestDeclarations175.clear (afterR s) "r1".toList
def afterMixed (s : State) : State := DeepestDeclarations175.clear (afterR1 s) "r2".toList
def withN (s : State) : State := bindValue (afterMixed s) "n".toList .uint64 (u64 512)
def ready (s : State) : State := bindValue (withN s) "hn".toList .uint64 (u64 256)

theorem effect_outside (ty : B20.C.Ty) (list : List Name) (s : State) (name : Name)
    (absent : name∉list) :
    (C99DeclarationStatements.effect ty list s).locals name=s.locals name :=
  StepProductBody191.cells_outside (C99ValueBridge.type ty) list s.locals name absent

theorem distinct (name : Name) (absent : name∉names++wordNames) :
    name≠"n".toList ∧ name≠"hn".toList ∧ name≠"w".toList ∧ name≠"ni".toList ∧ name≠"R".toList := by
  refine ⟨?_,?_,?_,?_,?_⟩ <;>
    intro same <;> apply absent <;> simp [names,wordNames,same]

theorem mixed_locals_outside (s : State) (name : Name)
    (absent : name∉names++wordNames) : (afterMixed s).locals name=s.locals name := by
  obtain ⟨_,_,wDiff,niDiff,rDiff⟩ := distinct name absent
  have sizeOut : (afterSize s).locals name=s.locals name :=
    effect_outside .u64 names s name (fun hit => absent (List.mem_append_left _ hit))
  have wOut : (afterW s).locals name=(afterSize s).locals name :=
    effect_outside .u32 ["w".toList] (afterSize s) name
      (fun hit => wDiff (by simpa [List.mem_singleton] using hit))
  have niOut : (afterNi s).locals name=(afterW s).locals name :=
    effect_outside .u32 ["ni".toList] (afterW s) name
      (fun hit => niDiff (by simpa [List.mem_singleton] using hit))
  have rOut : (afterR s).locals name=(afterNi s).locals name :=
    effect_outside .u32 ["R".toList] (afterNi s) name
      (fun hit => rDiff (by simpa [List.mem_singleton] using hit))
  have clear1 : (afterR1 s).locals name=(afterR s).locals name := rfl
  have clear2 : (afterMixed s).locals name=(afterR1 s).locals name := rfl
  exact clear2.trans (clear1.trans (rOut.trans (niOut.trans (wOut.trans sizeOut))))

theorem locals_outside (s : State) (name : Name)
    (absent : name∉names++wordNames) : (ready s).locals name=s.locals name := by
  obtain ⟨nDiff,hnDiff,_,_,_⟩ := distinct name absent
  have step : (ready s).locals name=(withN s).locals name := by
    simp only [ready,bindValue,C99ScalarReference.set,hnDiff,ite_false]
  have stepN : (withN s).locals name=(afterMixed s).locals name := by
    simp only [withN,bindValue,C99ScalarReference.set,nDiff,ite_false]
  rw [step,stepN]
  exact mixed_locals_outside s name absent

theorem arrays_outside (s : State) (name : Name) (first : name≠"r1".toList)
    (second : name≠"r2".toList) : (ready s).arrays name=s.arrays name := by
  have chain : (ready s).arrays name=(afterMixed s).arrays name := rfl
  have clear2 : (afterMixed s).arrays name=(afterR1 s).arrays name := by
    simp only [afterMixed,DeepestDeclarations175.clear,second,ite_false]
  have clear1 : (afterR1 s).arrays name=(afterR s).arrays name := by
    simp only [afterR1,DeepestDeclarations175.clear,first,ite_false]
  rw [chain,clear2,clear1]
  rfl
theorem r1_cleared (s : State) : (ready s).arrays "r1".toList=none := by
  have chain : (ready s).arrays "r1".toList=(afterMixed s).arrays "r1".toList := rfl
  rw [chain]
  have different : "r1".toList≠"r2".toList := by decide
  have clear2 : (afterMixed s).arrays "r1".toList=(afterR1 s).arrays "r1".toList := by
    simp only [afterMixed,DeepestDeclarations175.clear,different,ite_false]
  rw [clear2]
  simp only [afterR1,DeepestDeclarations175.clear]
  rfl

theorem r2_cleared (s : State) : (ready s).arrays "r2".toList=none := by
  have chain : (ready s).arrays "r2".toList=(afterMixed s).arrays "r2".toList := rfl
  rw [chain]
  simp only [afterMixed,DeepestDeclarations175.clear]
  rfl

theorem size_value (s : State)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 9)))
    (full : s.locals "full".toList=some (.uint32,some (.uint32 0))) :
    C99ArrayReference.scalar s (C99ArrayParser.mkn (.var "logn".toList) (.var "full".toList))
      (.uint64 512) := by
  have l : C99ArrayReference.scalar s (.var "logn".toList) (.uint32 9) := .variable _ _ _ logn
  have t : C99ArrayReference.scalar s (.var "full".toList) (.uint32 0) := .variable _ _ _ full
  have shifted : C99ArrayReference.scalar s
      (.bin .shl (.var "full".toList) (.literal .i32 1)) (.uint32 0) :=
    .shift .left _ _ _ _ _ t (.literal .int32 1)
      (.unsignedLeft (.uint32 0) (.int32 1) 1 rfl rfl (by decide))
  have sum : C99ArrayReference.scalar s (.bin .add (.literal .i32 1)
      (.bin .shl (.var "full".toList) (.literal .i32 1))) (.uint32 1) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shifted
      (.step .plus (.int32 1) (.uint32 0) .uint32 rfl (.uint32 1) (.uint32 0) rfl rfl
        (by intro impossible; cases impossible))
  have difference : C99ArrayReference.scalar s
      (.bin .sub (.var "logn".toList) (.var "full".toList)) (.uint32 9) :=
    .arithmetic .minus _ _ _ _ _ l t
      (.step .minus (.uint32 9) (.uint32 0) .uint32 rfl (.uint32 9) (.uint32 0) rfl rfl
        (by intro impossible; cases impossible))
  exact .shift .left _ _ _ _ _ (.cast .uint64 _ (.uint32 1) sum) difference
    (.unsignedLeft (.uint64 1) (.uint32 9) 9 rfl rfl (by decide))

theorem size_run (s : State) : Exec NttInversePrograms192.sizeCode s ⟨afterSize s,.normal⟩ :=
  .seqNormal _ _ s (afterSize s) _
    (.base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u64 names s))
    (.base _ _ _ (.skip (afterSize s)))

theorem mixed_run (s : State) :
    Exec NttInversePrograms192.mixedCode (afterSize s) ⟨afterMixed s,.normal⟩ := by
  have w : Exec (NttInversePrograms192.declareU32 ["w"]) (afterSize s) ⟨afterW s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
      ["w".toList] (afterSize s))
  have ni : Exec (NttInversePrograms192.declareU32 ["ni"]) (afterW s) ⟨afterNi s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
      ["ni".toList] (afterW s))
  have r : Exec (NttInversePrograms192.declareU32 ["R"]) (afterNi s) ⟨afterR s,.normal⟩ :=
    .base _ _ _ (C99DeclarationStatements.source_exists FftLeafPrograms.program .u32
      ["R".toList] (afterNi s))
  have r1 : Exec (NttInversePrograms192.declarePtr "r1") (afterR s) ⟨afterR1 s,.normal⟩ :=
    .base _ _ _ (.declarePtr (afterR s) "r1".toList)
  have r2 : Exec (NttInversePrograms192.declarePtr "r2") (afterR1 s) ⟨afterMixed s,.normal⟩ :=
    .base _ _ _ (.declarePtr (afterR1 s) "r2".toList)
  exact .seqNormal _ _ (afterSize s) (afterW s) _ w
    (.seqNormal _ _ (afterW s) (afterNi s) _ ni
      (.seqNormal _ _ (afterNi s) (afterR s) _ r
        (.seqNormal _ _ (afterR s) (afterR1 s) _ r1
          (.seqNormal _ _ (afterR1 s) (afterMixed s) _ r2
            (.base _ _ _ (.skip (afterMixed s)))))))

theorem logn_ready (s : State) (logn : Slot s "logn" 9) :
    Slot (afterMixed s) "logn" 9 :=
  (mixed_locals_outside s "logn".toList (by simp [names,wordNames])).trans logn

theorem full_ready (s : State) (full : Slot s "full" 0) :
    Slot (afterMixed s) "full" 0 :=
  (mixed_locals_outside s "full".toList (by simp [names,wordNames])).trans full

theorem guard_run (s : State) (logn : Slot s "logn" 9) (full : Slot s "full" 0) :
    Exec NttInversePrograms192.guardPart (afterMixed s) ⟨ready s,.normal⟩ := by
  have lognAfter := logn_ready s logn
  have fullAfter := full_ready s full
  have exitGuard : Exec NttInversePrograms192.earlyExit (afterMixed s) ⟨afterMixed s,.normal⟩ :=
    .branchFalse _ _ _ (afterMixed s) ⟨afterMixed s,.normal⟩ (.int32 0)
      (.compare .eq _ _ _ _ _ (.variable _ _ _ lognAfter) (.literal .int32 0)
        (.step .eq (.uint32 9) (.int32 0) .uint32 rfl (.uint32 9) (.uint32 0) rfl rfl)) rfl
      (.base .skip (afterMixed s) (afterMixed s) (.skip (afterMixed s)))
  have n : Exec NttInversePrograms192.nAssign (afterMixed s) ⟨withN s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.uint64 512) rfl
      (.scalar _ _ (size_value (afterMixed s) lognAfter fullAfter))
  have hn : Exec NttInversePrograms192.hnAssign (withN s) ⟨ready s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.uint64 256) rfl (.scalar _ _
      (.shift .right _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
        (.right (.uint64 512) (.int32 1) 1 rfl (by decide))))
  exact .seqNormal _ _ (afterMixed s) (afterMixed s) _ exitGuard
    (.seqNormal _ _ (afterMixed s) (withN s) _ n
      (.seqNormal _ _ (withN s) (ready s) _ hn (.base _ _ _ (.skip (ready s)))))

theorem source (s : State) (logn : Slot s "logn" 9) (full : Slot s "full" 0) :
    Exec NttInversePrograms192.prologue s ⟨ready s,.normal⟩ :=
  .seqNormal _ _ s (afterSize s) _ (size_run s)
    (.seqNormal _ _ (afterSize s) (afterMixed s) _ (mixed_run s)
      (.seqNormal _ _ (afterMixed s) (ready s) _ (guard_run s logn full)
        (.base _ _ _ (.skip (ready s)))))

theorem heap (s : State) : (ready s).heap=s.heap := rfl

theorem n_cell (s : State) : USlot (ready s) "n" 512 := rfl
theorem hn_cell (s : State) : USlot (ready s) "hn" 256 := rfl

theorem u_declared (s : State) : (ready s).locals "u".toList=some (.uint64,none) := rfl
theorem r_declared (s : State) : (ready s).locals "r".toList=some (.uint64,none) := rfl
theorem m_declared (s : State) : (ready s).locals "m".toList=some (.uint64,none) := rfl
theorem t_declared (s : State) : (ready s).locals "t".toList=some (.uint64,none) := rfl
theorem w_declared (s : State) : (ready s).locals "w".toList=some (.uint32,none) := rfl
theorem ni_declared (s : State) : (ready s).locals "ni".toList=some (.uint32,none) := rfl
theorem R_declared (s : State) : (ready s).locals "R".toList=some (.uint32,none) := rfl

theorem slot_keep (s : State) (name : String) (w : BitVec 32) (fresh : name.toList∉names++wordNames)
    (cell : Slot s name w) : Slot (ready s) name w :=
  (locals_outside s name.toList fresh).trans cell

theorem uslot_keep (s : State) (name : String) (n : Nat) (fresh : name.toList∉names++wordNames)
    (cell : USlot s name n) : USlot (ready s) name n :=
  (locals_outside s name.toList fresh).trans cell

end FT1536.Source3.NttInversePrologue192
