import Source3.KeygenResultantSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted AST serialization only; emitted source equalities must be
   checked by the kernel before any literal code is used as source. -/
namespace FT1536.Source3.ResultantSyntax130Generator

def generate : IO Unit := do
  let text := "import Source3.KeygenResultantSource\n\n" ++
    "set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n" ++
    "namespace FT1536.Source3.GeneratedResultantSyntax130\n\n" ++
    "def setup : C99ModularReference.Stmt := " ++ reprStr KeygenResultantSource.setup ++ "\n\n" ++
    "def packing : KeygenWordExec.Stmt := " ++ reprStr KeygenResultantSource.packing ++ "\n\n" ++
    "def parts : List KeygenWordExec.Stmt := " ++ reprStr (List.ofFn KeygenResultantSource.part) ++ "\n\n" ++
    "def ending : KeygenWordExec.Stmt := " ++ reprStr KeygenResultantSource.tailCode ++ "\n\n" ++
    "def reduction (word : BitVec 32) : KeygenWordExec.Stmt := if 2≤word.toNat ∧ word.toNat≤11 then KeygenWordExec.chain (parts.drop (11-word.toNat)) else KeygenWordExec.skip\n\n" ++
    "theorem setup_eq : KeygenResultantSource.setup=setup := by decide +kernel\n" ++
    "theorem packing_eq : KeygenResultantSource.packing=packing := by decide +kernel\n" ++
    "theorem parts_eq : List.ofFn KeygenResultantSource.part=parts := by decide +kernel\n" ++
    "theorem ending_eq : KeygenResultantSource.tailCode=ending := by decide +kernel\n" ++
    "theorem reduction_eq (word : BitVec 32) : KeygenResultantSource.switchCode word=reduction word := by\n  unfold KeygenResultantSource.switchCode reduction\n  rw [parts_eq]\n\n" ++
    "end FT1536.Source3.GeneratedResultantSyntax130\n"
  IO.FS.writeFile "../GeneratedResultantSyntax130.lean" text

end FT1536.Source3.ResultantSyntax130Generator

#eval FT1536.Source3.ResultantSyntax130Generator.generate
