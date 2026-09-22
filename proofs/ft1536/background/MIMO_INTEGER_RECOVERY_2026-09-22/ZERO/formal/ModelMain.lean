import LiteralAdd
open ZeroScalar
def main (args : List String) : IO Unit := do
  unless args.length=2 do throw (IO.userError "jobs output")
  let text←IO.FS.readFile args[0]!
  let out←IO.FS.Handle.mk args[1]! IO.FS.Mode.write
  for line in text.splitOn "\n" do
    if line.isEmpty then continue
    let a:=line.splitOn " "
    let n:=a[0]!.toNat!;let z:=a[1]!.toInt!
    if hn : n<18446744073709551616 then
      let x:Word:=⟨n,hn⟩;let s:=floorC x
      out.putStrLn s!"{n} {z} {s} {(ofC s).val} {(ofC (s+z)).val} {(rC x).val} {(resC x z).val} {(deltaC x).val}"
    else throw (IO.userError "not a word")
  out.flush
  IO.println "kernel model values emitted"
