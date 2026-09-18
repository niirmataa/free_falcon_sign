import SourceModel
set_option maxRecDepth 16384
open FT1536Global

def selected (phase : String) (h n : Nat) : Bool :=
  if phase="froot" || phase="iroot" || phase="fbin" || phase="ibin" then
    [1,h,h+1,767,768].contains n
  else if phase="fcube" || phase="icube" then [1,255,256,511,512].contains n
  else if phase="scale" then [1,767,768,1535,1536].contains n else true
def emit (out : IO.FS.Handle) (phase : String) (m h n : Nat) (s : Mem) : IO Unit := do
  if selected phase h n then
    let fields := [phase,toString m,toString n] ++ (List.range 1536).map (fun i => toString (s i))
    out.putStrLn (String.intercalate " " fields)
def pairs (out : IO.FS.Handle) (phase : String) (m h : Nat)
    (op : Nat → (Bool → Int) → Bool → Int) (input : Mem) : IO Mem := do
  let mut s:=input
  for b in [:768] do
    s:=pairStep (pairAddr h) op b s
    emit out phase m h (b+1) s
  return s
def triples (out : IO.FS.Handle) (phase : String)
    (op : Nat → (Fin 3 → Int) → Fin 3 → Int) (input : Mem) : IO Mem := do
  let mut s:=input
  for b in [:512] do
    s:=tripleStep tripleAddr op b s
    emit out phase 0 0 (b+1) s
  return s
def main (args : List String) : IO Unit := do
  unless args.length=2 do throw (IO.userError "input.txt output.trace")
  let text←IO.FS.readFile args[0]!
  let values←(text.trimAscii.toString.splitOn " ").mapM (fun s =>
    match s.toInt? with | some v => pure v | none => throw (IO.userError "bad integer"))
  unless values.length=1536 do throw (IO.userError "length")
  let input:=values.toArray
  let out←IO.FS.Handle.mk args[1]! IO.FS.Mode.write
  let mut s : Mem:=fun i => input[i]!
  emit out "input" 0 0 0 s
  s←pairs out "froot" 0 768 forwardRootOp s
  for p in forwardSchedule 9 2 768 do
    s←pairs out "fbin" p.1 (p.2/2) (forwardBinaryOp p.1 (p.2/2)) s
  s←triples out "fcube" forwardCubicOp s
  emit out "forward" 0 0 1536 s
  s←triples out "icube" inverseCubicOp s
  for p in inverseSchedule 9 256 6 do
    s←pairs out "ibin" p.1 (p.2/2) (inverseBinaryOp p.1 (p.2/2)) s
  s←pairs out "iroot" 0 768 inverseRootOp s
  for i in [:1536] do
    s:=scaleStep i s
    emit out "scale" 0 0 (i+1) s
  emit out "roundtrip" 0 0 1536 s
  out.flush
  IO.println "source-model prefix trace complete"
