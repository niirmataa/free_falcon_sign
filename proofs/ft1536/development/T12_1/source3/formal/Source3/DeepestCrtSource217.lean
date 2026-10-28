import Source3.DeepestSelectedCrt217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The selected make_fg images feed the actual first statement of deepest part3. -/
namespace FT1536.Source3.DeepestCrtSource217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes env)
open NinthStepLayout217 (fd gd)
open NinthStepEntry217 (fWords gWords)
open NinthStepFull217 (afterF afterG)
open NinthStepImage217 (flat)
open NinthStepReturn217 (returned advance)
open SelectedMakeFgReturn217 (callerAfter)
open DeepestSelectedCrt217 (tmp pair)
open DeepestUnsignedCrtBody217 (words335)
open ZintNormWalkFlat208 (Data)

def head : KeygenDeepestSource.Stmt := .base (.zint (.call .rebuildCrt DeepestUnsignedCrtCall217.args .discard))
def rest : KeygenDeepestSource.Stmt := match KeygenDeepestSource.part 3 with | .seq _ tail => tail | _ => KeygenDeepestSource.skip

theorem shape : KeygenDeepestSource.part 3=.seq head rest := by decide

theorem split_data (s : State) (W : Nat → BitVec 32) (all : Data s fd 670 W) :
    Data s fd 335 W ∧ Data s gd 335 (fun i => W (335+i)) := by
  constructor
  · intro i bound
    exact all i (by omega)
  · intro i bound
    have address : StepCopyBody190.elem gd i=StepCopyBody190.elem fd (335+i) := by
      change (⟨31,0,71680,4,1005+i⟩ : C99MemoryReference.ArrayPointer)=⟨31,0,71680,4,670+(335+i)⟩
      apply congrArg (fun k : Nat => (⟨31,0,71680,4,k⟩ : C99MemoryReference.ArrayPointer))
      omega
    rw [address]
    exact all (335+i) (by omega)

theorem source : ∃ (callee second third fourth fifth sixth seventh eighth out rebuilt : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32) (first8 extra8 : Nat → Fin 4 → BitVec 32)
    (firstTables extraTables : Nat → Fin 2 → BitVec 32),
    Exec (KeygenMakeFgSource.code .make) SelectedMakeFgEntry175.entry ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ ∧
    KeygenDeepestSource.Exec KeygenFullData127.env.ctx .make SelectedDeepestWorkspace175.after
      ⟨callerAfter callee second third fourth fifth sixth seventh eighth out,.normal⟩ ∧
    KeygenDeepestSource.Exec KeygenFullData127.env.ctx (KeygenDeepestSource.part 2) SelectedDeepestConfig175.after
      ⟨callerAfter callee second third fourth fifth sixth seventh eighth out,.normal⟩ ∧
    Data (callerAfter callee second third fourth fifth sixth seventh eighth out) fd 335
      (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables) ∧
    Data (callerAfter callee second third fourth fifth sixth seventh eighth out) gd 335
      (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables) ∧
    KeygenDeepestSource.Exec KeygenFullData127.env.ctx head (callerAfter callee second third fourth fifth sixth seventh eighth out) ⟨rebuilt,.normal⟩ ∧
    rebuilt.locals=(callerAfter callee second third fourth fifth sixth seventh eighth out).locals ∧
    rebuilt.arrays=(callerAfter callee second third fourth fifth sixth seventh eighth out).arrays ∧
    rebuilt.tables=(callerAfter callee second third fourth fifth sixth seventh eighth out).tables ∧
    Data rebuilt fd 670 (words335 (pair (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables) (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables))) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,makeRun,call,part2,fdata,gdata⟩:=SelectedMakeFgReturn217.source
  let before := callerAfter callee second third fourth fifth sixth seventh eighth out
  have stable := KeygenHelperStability.make _ _ _ makeRun
  change KeygenMemoryStability.Stable SelectedMakeFgEntry175.entry.heap before.heap at stable
  have domain := DeepestSelectedCrt217.selected_domain before stable
  have image := DeepestSelectedCrt217.pair_data before _ _ fdata gdata
  have fp : before.arrays "fp".toList=some fd := SelectedMakeFgReturn217.caller_fp _ _ _ _ _ _ _ _ _
  have scratch : before.arrays "t1".toList=some tmp := by rfl
  have prime : before.arrays "primes".toList=some primes := by rfl
  have len : C99LoopScalar141.Cell before "len".toList 335 := by rfl
  obtain ⟨rebuilt,run,output,locals,arrays,tables,_⟩:=DeepestUnsignedCrtCall217.source before fd tmp _ fp scratch prime len domain image
  have headRun : KeygenDeepestSource.Exec env.ctx head before ⟨rebuilt,.normal⟩ := .base _ _ _ (.zint _ _ _ run)
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,rebuilt,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,makeRun,call,part2,fdata,gdata,headRun,locals,arrays,tables,output⟩

end FT1536.Source3.DeepestCrtSource217
