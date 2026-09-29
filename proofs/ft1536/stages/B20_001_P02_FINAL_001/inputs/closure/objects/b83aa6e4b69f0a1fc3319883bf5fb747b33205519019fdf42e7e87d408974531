import Sqrt54
def main (args : List String) : IO Unit := do
  let text←IO.FS.readFile args[0]!
  let mut output := ""
  for line in text.splitOn "\n" do
    if line.isEmpty then continue
    let a:=line.toNat!
    let z:=StableSqrt.runBits 53 0 (2*a)
    output:=output++s!"{z.1} {z.2}\n"
  IO.FS.writeFile args[1]! output
