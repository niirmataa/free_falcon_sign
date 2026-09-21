import Initialization
open FT1536Bridge FT1536Global
set_option maxRecDepth 16384

def readBytes (path : String) : IO Bytes := do
  let b←IO.FS.readBinFile path
  return b.data.toList.map (fun x => ⟨x.toNat,x.toNat_lt⟩)
def readIntegers (path : String) : IO (Array Int) := do
  let text←IO.FS.readFile path
  let xs←(text.trimAscii.toString.splitOn " ").mapM (fun s => match s.toInt? with
    | none => throw (IO.userError "bad integer") | some n => pure n)
  return xs.toArray
def emitInts (out : IO.FS.Handle) (head : List String) (xs : List Int) : IO Unit :=
  out.putStrLn (String.intercalate " " (head++xs.map toString))
def main (args : List String) : IO Unit := do
  unless args.length=2 do throw (IO.userError "jobs output")
  let jobs←IO.FS.readFile args[0]!
  let out←IO.FS.Handle.mk args[1]! IO.FS.Mode.write
  for line in jobs.splitOn "\n" do
    if line.isEmpty then continue
    let a:=line.splitOn " "
    let kind:=a[0]!;let name:=a[1]!;let path:=a[2]!
    if kind="sig" then
      let b←readBytes path
      let fb:=(b.head?).getD ⟨0,by decide⟩
      let good:=(signature b).isSome
      match decodeSmall ((fb.val/32)%4) b.tail with
      | none => emitInts out [kind,name,toString good,"0"] []
      | some (xs,n) => emitInts out [kind,name,toString good,toString n] xs
    else if kind="pk" then
      let b←readBytes path
      let fb:=(b.head?).getD ⟨0,by decide⟩
      -- Evaluate the loader's guards/decoder. Preparing H is already a
      -- pinned theorem; avoid evaluating the old functional NTT closures.
      let guard:=b.length>1 && (fb.val/16)%8==0 && fb.val%16==10 && fb.val/128==1
      match decodePK b.tail with
      | none => emitInts out [kind,name,"false","0"] []
      | some (xs,n) => emitInts out [kind,name,toString guard,toString n] xs
    else if kind="norm" then
      let a←readIntegers path
      unless a.size=3072 do throw (IO.userError "norm length")
      let x:Vec:=fun i => a[i.val]!
      let y:Vec:=fun i => a[i.val+1536]!
      emitInts out [kind,name,toString (isShort x y)] [normAcc x y 4608]
    else if kind="center" then
      let d:=path.toInt!
      emitInts out [kind,name] [centerC d,centerCorrection d,centerBits d]
    else throw (IO.userError "unknown job")
  out.flush
  IO.println "new bridge models emitted"
