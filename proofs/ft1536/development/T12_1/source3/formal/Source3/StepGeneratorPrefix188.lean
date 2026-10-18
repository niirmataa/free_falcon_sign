import Source3.StepGeneratorInverseCall188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepGeneratorPrefix188
open C99ArrayReference (State)
open C99ModularReference (Exec ModCall chainOf)
open KeygenMkgm3Program
open StepGeneratorInverseCall188 (after)

def steps := declarations++[rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]
def remaining := [rowSelect,kFromLogn,ifFull,squareLoop]++topElements

def scalarSteps := [rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]

theorem scalar_source : Exec (chainOf scalarSteps) StepGeneratorScalar188.before ⟨after,.normal⟩ :=
  ModularSequence178.source ModCall [rAssign,r2Assign,gConvert,kFromLogn0]
    StepGeneratorScalar188.before StepGeneratorScalar188.after StepGeneratorScalar188.source
    [ifNotFull,whileK,igAssign] ⟨after,.normal⟩
    (.seqNormal _ _ StepGeneratorScalar188.after StepGeneratorCube188.after _ StepGeneratorCube188.source
      (.seqNormal _ _ StepGeneratorCube188.after StepGeneratorSquare188.after _ StepGeneratorSquare188.loop_source
        (.seqNormal _ _ StepGeneratorSquare188.after after _ StepGeneratorInverseCall188.source
          (.base .skip after after (.skip after)))))

theorem append_source (tail : List C99ModularReference.Stmt) (out : C99ProcedureReference.Result)
    (rest : Exec (chainOf tail) after out) : Exec (chainOf (steps++tail)) StepGeneratorEntry188.entry out :=
  ModularSequence178.source ModCall declarations StepGeneratorEntry188.entry StepGeneratorScalar188.before
    (GeneratorDeclarations178.source StepGeneratorEntry188.entry)
    ([rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]++tail) out
    (ModularSequence178.source ModCall [rAssign,r2Assign,gConvert,kFromLogn0]
      StepGeneratorScalar188.before StepGeneratorScalar188.after StepGeneratorScalar188.source
      ([ifNotFull,whileK,igAssign]++tail) out
      (.seqNormal _ _ StepGeneratorScalar188.after StepGeneratorCube188.after out StepGeneratorCube188.source
        (.seqNormal _ _ StepGeneratorCube188.after StepGeneratorSquare188.after out StepGeneratorSquare188.loop_source
          (.seqNormal _ _ StepGeneratorSquare188.after after out StepGeneratorInverseCall188.source rest))))

theorem source : Exec (chainOf steps) StepGeneratorEntry188.entry ⟨after,.normal⟩ := by
  have run := append_source [] ⟨after,.normal⟩ (.base .skip after after (.skip after))
  simpa only [List.append_nil] using run

theorem continue_generator (out : C99ProcedureReference.Result) (rest : Exec (chainOf remaining) after out) :
    Exec KeygenMkgm3Program.code StepGeneratorEntry188.entry out := append_source remaining out rest

theorem heap : after.heap=StepGeneratorEntry188.entry.heap := KeygenMkgm3Atoms.pure_heap _ _ _ (by decide) source

end FT1536.Source3.StepGeneratorPrefix188
