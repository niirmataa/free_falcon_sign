import Source3.SelectedOuterLoop217
import Source3.SelectedDeepestPrefix175

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual selected make_fg call returns both final images to deepest. -/
namespace FT1536.Source3.SelectedMakeFgReturn217
open C99ArrayReference (State)
open KeygenMakeFgSource (Exec)
open NinthStepLayout217 (fd gd)
open NinthStepEntry217 (fWords gWords)
open NinthStepFull217 (afterF afterG)
open NinthStepImage217 (flat)
open NinthStepReturn217 (returned advance)
open ZintNormWalkFlat208 (Data)

noncomputable def callerAfter (callee second third fourth fifth sixth seventh eighth out : State) : State :=
  {SelectedDeepestWorkspace175.after with heap:=(advance (returned callee second third fourth fifth sixth seventh eighth out)).heap}

theorem fd_is_fp : fd=SelectedDeepestWorkspace175.pointer 2 := rfl
theorem gd_is_gp : gd=SelectedDeepestWorkspace175.pointer 3 := rfl

theorem caller_fp (callee second third fourth fifth sixth seventh eighth out : State) :
    (callerAfter callee second third fourth fifth sixth seventh eighth out).arrays "fp".toList=some fd := by rfl

theorem caller_gp (callee second third fourth fifth sixth seventh eighth out : State) :
    (callerAfter callee second third fourth fifth sixth seventh eighth out).arrays "gp".toList=some gd := by rfl

theorem source : ∃ (callee second third fourth fifth sixth seventh eighth out : State) (old : Fin 512 → BitVec 32)
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
      (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8) (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,_,tailRun,fdata,gdata⟩:=SelectedOuterLoop217.source
  have makeRun : Exec (KeygenMakeFgSource.code .make) SelectedMakeFgEntry175.entry
      ⟨advance (returned callee second third fourth fifth sixth seventh eighth out),.normal⟩ :=
    SelectedTopContinuation186.continue_make _ tailRun
  have call := SelectedMakeFgEntry175.source_call _ makeRun .voidEnd
  have part2 := SelectedDeepestWorkspace175.continue_part _
    (KeygenDeepestSource.Exec.seqNormal _ _ _ _ _ call
      (DeepestDeclarations175.array_source KeygenFullData127.env.ctx .skip _ _ (.skip _)))
  exact ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,makeRun,call,part2,fdata,gdata⟩

end FT1536.Source3.SelectedMakeFgReturn217
