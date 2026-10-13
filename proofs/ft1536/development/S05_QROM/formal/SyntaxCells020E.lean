import SyntaxTape020E
import InputLayout020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.SyntaxCells020E
open WordRAM020 SyntaxTape020E

/-- A tag padded to one512-bit word plus one512-bit payload. -/
abbrev Cell := Fin 16 × Word

def opIndex : Op → Nat
  | .add => 0 | .sub => 1 | .mul => 2 | .div => 3 | .mod => 4 | .lt => 5 | .eq => 6

def opOf : Nat → Option Op
  | 0 => some .add | 1 => some .sub | 2 => some .mul | 3 => some .div
  | 4 => some .mod | 5 => some .lt | 6 => some .eq | _ => none

def regOf (w : Word) : Option Reg :=
  if h : w.toInt.toNat<32 then some ⟨w.toInt.toNat,h⟩ else none

def encode : Token → Cell
  | .literal w => (0,w) | .register r => (1,word (r.val:Int))
  | .binary o => (2,word (opIndex o:Int)) | .setter r => (3,word (r.val:Int))
  | .rom r => (4,word (r.val:Int)) | .ram r => (5,word (r.val:Int))
  | .bit r => (6,word (r.val:Int)) | .store => (7,0) | .emit => (8,0)
  | .seq => (9,0) | .branch => (10,0) | .loop n => (11,word (n:Int))

def decode (c : Cell) : Option Token := match c.1.val with
  | 0 => some (.literal c.2)
  | 1 => (regOf c.2).map Token.register
  | 2 => (opOf c.2.toInt.toNat).map Token.binary
  | 3 => (regOf c.2).map Token.setter
  | 4 => (regOf c.2).map Token.rom
  | 5 => (regOf c.2).map Token.ram
  | 6 => (regOf c.2).map Token.bit
  | 7 => some .store | 8 => some .emit | 9 => some .seq | 10 => some .branch
  | 11 => some (.loop c.2.toInt.toNat)
  | _ => none

def Legal : Token → Prop
  | .loop n => n<2^511
  | _ => True

theorem reg_roundtrip (r : Reg) : regOf (word (r.val:Int))=some r := by
  have hr : r.val<2^511 := lt_trans r.isLt (by norm_num)
  unfold regOf
  rw [InputLayout020.nat_word_exact _ hr]
  simp

theorem op_roundtrip (o : Op) : opOf (word (opIndex o:Int)).toInt.toNat=some o := by
  have ho : opIndex o<2^511 := by cases o <;> norm_num [opIndex]
  rw [InputLayout020.nat_word_exact _ ho]
  cases o <;> rfl

theorem roundtrip (t : Token) (ht : Legal t) : decode (encode t)=some t := by
  cases t with
  | literal w => rfl
  | register r => exact congrArg (Option.map Token.register) (reg_roundtrip r)
  | binary o => exact congrArg (Option.map Token.binary) (op_roundtrip o)
  | setter r => exact congrArg (Option.map Token.setter) (reg_roundtrip r)
  | rom r => exact congrArg (Option.map Token.rom) (reg_roundtrip r)
  | ram r => exact congrArg (Option.map Token.ram) (reg_roundtrip r)
  | bit r => exact congrArg (Option.map Token.bit) (reg_roundtrip r)
  | store => rfl
  | emit => rfl
  | seq => rfl
  | branch => rfl
  | loop n =>
    change some (Token.loop (word (n:Int)).toInt.toNat)=some (.loop n)
    rw [InputLayout020.nat_word_exact n ht]
    rfl

theorem injective_on_legal (a b : Token) (ha : Legal a) (hb : Legal b) (he : encode a=encode b) : a=b :=
  Option.some.inj ((roundtrip a ha).symm.trans ((congrArg decode he).trans (roundtrip b hb)))

end FT1536.S05.SyntaxCells020E
