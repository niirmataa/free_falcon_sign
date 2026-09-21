import Half
def halfMain (args : List String) : IO Unit := do
  let text←IO.FS.readFile args[0]!
  let mut out := ""
  for line in text.splitOn "\n" do
    if line.isEmpty then continue
    let n := line.toNat!
    let x : ZeroScalar.Word := ⟨n%18446744073709551616,Nat.mod_lt _ (by decide)⟩
    out := out++s!"{(Node2.halfC x).val}\n"
  IO.FS.writeFile args[1]! out
