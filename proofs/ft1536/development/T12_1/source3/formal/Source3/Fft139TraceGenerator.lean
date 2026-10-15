import Source3.FftMiddle139Generator
import Source3.FprCached138

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted cache proposal extraction only. Every proposed event is separately
   checked against source-proved word arithmetic. Missing events merely use
   the source-sound fallback in FprCached138. -/
namespace FT1536.Source3.Fft139TraceGenerator
open C99CompactState115 (State)
open FprBoundEvents135 (Event)

def expression (before : State) : C99ArrayReference.Expr → Option (B20.C.Val × List Event)
  | .call1 name arg => do
    let (x,events) ← expression before arg
    let out ← FprFastCalls137.calls name [x]
    pure (out,events++[⟨name,[x],out⟩])
  | .call2 name left right => do
    let (x,first) ← expression before left
    let (y,second) ← expression before right
    let out ← FprFastCalls137.calls name [x,y]
    pure (out,first++second++[⟨name,[x,y],out⟩])
  | expr => (C99ArrayCompute136.evaluate FprFastCalls137.calls before expr).map (fun value => (value,[]))

def array : Nat → C99ArrayReference.Stmt → State → Option (List Event)
  | 0,_,_ => none
  | fuel+1,.seq first second,before => do
    let head ← array fuel first before
    let middle ← C99ArrayRun138.run FprFastCalls137.calls 96 first before
    let tail ← array fuel second middle
    pure (head++tail)
  | fuel+1,.scope _ _ body,before => array fuel body before
  | _+1,.assign _ expr,before | _+1,.store64 _ _ expr,before => (expression before expr).map Prod.snd
  | _+1,_,_ => some []

def procedure : Nat → C99ProcedureReference.Stmt → State → Option (List Event)
  | 0,_,_ => none
  | fuel+1,.seq first second,before => do
    let head ← procedure fuel first before
    let middle ← C99ProcedureRun138.run FprFastCalls137.calls 96 first before
    let tail ← procedure fuel second middle
    pure (head++tail)
  | fuel+1,.scope _ _ body,before => procedure fuel body before
  | fuel+1,.base code,before => array fuel code before
  | _+1,_,_ => some []

def collect : Nat → State → Option (List Event)
  | 0,_ => some []
  | count+1,before => do
    let head ← procedure 96 FftMiddleShape139.butterflyBody before
    let after ← C99ProcedureSegments138.run FprFastCalls137.calls 96 FftMiddleShape139.butterflyCondition
      FftMiddleShape139.butterflyBody FftMiddleShape139.butterflyIncrement 1 before
    let tail ← collect count after
    pure (head++tail)

def emit (moduleName : String) (events : List Event) : IO Unit := do
  let mut text := "import Source3.FprCached138\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3."++moduleName++"\n\n"
  for event in events, i in [:events.length] do
    let name := "event"++toString i
    text := text++"def "++name++" : FprBoundEvents135.Event :=\n  "++(reprStr event).replace "\n" "\n  "++"\n\n"
    text := text++"theorem checked"++toString i++" : FprFastCalls137.calls "++name++".name "++name++".args=some "++name++".out := by decide +kernel\n\n"
    text := text++"theorem valid"++toString i++" : FprTable138.Valid "++name++" := FprTable138.checked "++name++" checked"++toString i++"\n\n"
  text := text++"def events : List FprBoundEvents135.Event := ["++String.intercalate "," ((List.range events.length).map (fun i => "event"++toString i))++"]\n\n"
  text := text++"theorem valid : ∀ event∈events, FprTable138.Valid event := by\n  intro event member\n  simp only [events,List.mem_cons,List.not_mem_nil,or_false] at member\n  rcases member with "++String.intercalate "|" ((List.range events.length).map (fun _ => "rfl"))++"\n"
  for i in List.range events.length do text := text++"  · exact valid"++toString i++"\n"
  text := text++"\ndef calls := FprCached138.calls events\n\ntheorem sound : C99ExpressionSound.CallsSound FprPrefixCalls.calls calls := FprCached138.sound events valid\n"
  text := text++"\nend FT1536.Source3."++moduleName++"\n"
  IO.FS.writeFile ("../"++moduleName++".lean") text

end FT1536.Source3.Fft139TraceGenerator
