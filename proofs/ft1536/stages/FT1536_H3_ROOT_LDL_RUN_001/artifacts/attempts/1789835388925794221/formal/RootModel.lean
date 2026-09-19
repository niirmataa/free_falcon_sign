import RootBounds
set_option maxRecDepth 16384
namespace RootLDL
open ZeroScalar
def signedZero (s : Bool) : Word := ⟨if s then 9223372036854775808 else 0,by split <;> decide⟩
def packed (s : Bool) (b : Int) (m : Nat) : Word :=
  if b<0 then signedZero s else packNormal s b.toNat (roundMant m)
def mulC (x y : Word) : Word :=
  let p := (4503599627370496+frac x)*(4503599627370496+frac y)
  let z := (p/1125899906842624) ||| (if p%1125899906842624=0 then 0 else 1)
  let w := z/36028797018963968
  let m := if w=0 then z else (z/2)|||(z%2)
  if ex x=0 ∨ ex y=0 then signedZero (sg x != sg y)
  else packed (sg x != sg y) ((ex x:Int)+(ex y:Int)-1024+(w:Int)) m
def divC (x y : Word) : Word :=
  let s := loop (4503599627370496+frac y) 55 (4503599627370496+frac x,0)
  let q := s.2 ||| (if s.1=0 then 0 else 1)
  let w := q/36028797018963968
  let m := if w=0 then q else (q/2)|||(q%2)
  if ex x=0 then signedZero false
  else packed (sg x != sg y) ((ex x:Int)-(ex y:Int)+1021+(w:Int)) m
end RootLDL
def main : IO Unit := do
  let args←IO.getArgs
  let text←IO.FS.readFile args[0]!
  let mut out := ""
  for line in text.splitOn "\n" do
    if line.isEmpty then continue
    let fields := line.splitOn " "
    let xn := fields[0]!.toNat!;let yn := fields[1]!.toNat!
    let x : ZeroScalar.Word := ⟨xn%18446744073709551616,Nat.mod_lt _ (by decide)⟩
    let y : ZeroScalar.Word := ⟨yn%18446744073709551616,Nat.mod_lt _ (by decide)⟩
    out := out++s!"{(RootLDL.mulC x y).val} {(RootLDL.divC x y).val}\n"
  IO.FS.writeFile args[1]! out
