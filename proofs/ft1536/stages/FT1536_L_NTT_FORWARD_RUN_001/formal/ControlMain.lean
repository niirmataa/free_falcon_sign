import CheckerControls
open FT1536Global FT1536Forward

def main (args : List String) : IO Unit := do
  unless args.length=1 do throw (IO.userError "output path required")
  let out←IO.FS.Handle.mk args[0]! IO.FS.Mode.write
  for b in ([0,1,255,256,511] : List Nat) do
    for j in ([0,1,2] : List (Fin 3)) do
      out.putStrLn s!"node {b} {j.val} {gmAt (512+b)} {node b j} {nodeCheck (512+b) (gmAt (512+b)) j}"
    out.putStrLn s!"root {b} {rootLabel (3*b)}"
    for p in forwardSchedule 9 2 768 do
      out.putStrLn s!"label {b} {p.1} {p.2/2} {splitLabel p.1 (p.2/2) (3*b)}"
  for k in ([0,1,767,768,1535,1536,1537,2303,2304,2305,3070] : List Nat) do
    out.putStrLn (String.intercalate " " (["rem",toString k]++(List.range 1536).map (fun j => toString (FT1536Composition.remMonomial k j))))
  out.putStrLn (String.intercalate " " (["badrem","2304"]++(List.range 1536).map (fun j => toString (badRem 2304 j))))
  out.putStrLn s!"control noop {nodeCheck 512 ((gmAt 512+18433)%18433) 0}"
  out.putStrLn s!"control word {nodeCheck 512 ((gmAt 512+1)%18433) 0}"
  out.putStrLn s!"control index {nodeCheck 513 (gmAt 512) 0}"
  out.putStrLn s!"control sign {decide (powFast (node 0 0) 384=(-splitLabel 2 384 0)%18433)}"
  out.putStrLn s!"control cubic {cubicCheckAt (gmAt 512) 1 0}"
  out.flush
  IO.println "new node/reduction controls emitted"
