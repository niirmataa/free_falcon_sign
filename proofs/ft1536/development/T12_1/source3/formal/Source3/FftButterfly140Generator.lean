import Source3.C99StraightProcedure140
import Source3.FftMiddleShape139

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Syntax-only proposal generation. The emitted code equality and constructor
   source proofs must be accepted separately by the kernel. -/
namespace FT1536.Source3.FftButterfly140Generator

def array : C99ArrayReference.Stmt → Except String String
  | .seq first second => do
    pure ("(C99StraightArray140.seq "++(← array first)++" "++(← array second)++")")
  | .scope locals pointers body => do
    pure ("(C99StraightArray140.scopedBlock ("++reprStr locals++") ("++reprStr pointers++") "++(← array body)++")")
  | code@(.skip) | code@(.scalar _) | code@(.assign _ _) | code@(.store64 _ _ _) =>
    pure ("(C99StraightArray140.atom ("++reprStr code++"))")
  | _ => .error "Unsupported array statement in straight-line butterfly"

def procedure : C99ProcedureReference.Stmt → Except String String
  | .base code => do pure ("(C99StraightProcedure140.base "++(← array code)++")")
  | .seq first second => do
    pure ("(C99StraightProcedure140.seq "++(← procedure first)++" "++(← procedure second)++")")
  | .scope locals pointers body => do
    pure ("(C99StraightProcedure140.scopedBlock ("++reprStr locals++") ("++reprStr pointers++") "++(← procedure body)++")")
  | _ => .error "Unsupported procedure statement in straight-line butterfly"

def generate : IO Unit := do
  let .ok body := procedure FftMiddleShape139.butterflyBody | throw (IO.userError "Cannot compile source butterfly")
  let .ok increment := procedure FftMiddleShape139.butterflyIncrement | throw (IO.userError "Cannot compile source increment")
  let text := "import Source3.C99StraightProcedure140\nimport Source3.FftMiddleShape139\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.GeneratedFftButterfly140\n\n"++
    "def butterfly : C99StraightProcedure140.Certificate :=\n  "++body.replace "\n" "\n  "++"\n\n"++
    "def increment : C99StraightProcedure140.Certificate :=\n  "++increment.replace "\n" "\n  "++"\n\n"++
    "theorem body_source : butterfly.code=FftMiddleShape139.butterflyBody := by rfl\n\n"++
    "theorem increment_source : increment.code=FftMiddleShape139.butterflyIncrement := by rfl\n\n"++
    "end FT1536.Source3.GeneratedFftButterfly140\n"
  IO.FS.writeFile "../GeneratedFftButterfly140.lean" text

end FT1536.Source3.FftButterfly140Generator
#eval FT1536.Source3.FftButterfly140Generator.generate
