import Source3.SelectedGeneratorInverseCall178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedGeneratorInverse178
open C99ArrayReference (State)
open C99ModularReference (Exec ModCall chainOf)
open KeygenMkgm3Program
open ModularAtoms178 (set cell assign)
open SelectedTopInit178 (p p0i r2)
open SelectedGeneratorScalar178 (r)
open SelectedGeneratorSquare178 (g1)

open SelectedGeneratorInverseCall178 (ig before after source)

def steps := declarations++[rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]
def remaining := [rowSelect,kFromLogn,ifFull,squareLoop]++topElements

theorem append_source (tail : List C99ModularReference.Stmt) (out : C99ProcedureReference.Result)
    (rest : Exec (chainOf tail) after out) :
    Exec (chainOf (steps++tail)) SelectedGeneratorEntry178.entry out :=
  ModularSequence178.source ModCall declarations SelectedGeneratorEntry178.entry SelectedGeneratorScalar178.before
    (GeneratorDeclarations178.source SelectedGeneratorEntry178.entry)
    ([rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]++tail) out
    (ModularSequence178.source ModCall [rAssign,r2Assign,gConvert,kFromLogn0]
      SelectedGeneratorScalar178.before SelectedGeneratorSquare178.before SelectedGeneratorScalar178.source
      ([ifNotFull,whileK,igAssign]++tail) out
      (ModularSequence178.source ModCall [ifNotFull,whileK]
        SelectedGeneratorSquare178.before before SelectedGeneratorSquare178.source (igAssign::tail) out
        (.seqNormal igAssign (chainOf tail) before after out source rest)))

theorem prefix_source : Exec (chainOf steps) SelectedGeneratorEntry178.entry ⟨after,.normal⟩ := by
  have run := append_source [] ⟨after,.normal⟩ (.base .skip after after (.skip after))
  simpa only [List.append_nil] using run

theorem continue_generator (out : C99ProcedureReference.Result) (rest : Exec (chainOf remaining) after out) :
    Exec KeygenMkgm3Program.code SelectedGeneratorEntry178.entry out :=
  append_source remaining out rest


end FT1536.Source3.SelectedGeneratorInverse178
