import B20.Word.LESpec
import Source3.CLogicParser

namespace FT1536.Source3.BitcastObjects
open B20.C
abbrev Bytes8 := Fin 8 → BitVec 8

/- The selected FPEMU typedef gives both fpr and uint64_t the same
eight-byte object representation. A fresh local may be uninitialized;
writing it by memcpy is allowed, reading it before initialization is not.
Different declared local names denote disjoint automatic objects here. -/
abbrev Objects := B20.C.Name → Option (Option Bytes8)

def parameter (name : B20.C.Name) (w : BitVec 64) : Objects :=
  fun n => if n=name then some (some (B20.Word.LE.byteOf w)) else none

def declare (env : Objects) (name : B20.C.Name) : Option Objects :=
  if (env name).isSome then none else
    some (fun n => if n=name then some none else env n)

def copyObject (env : Objects) (dst src sizeOf : B20.C.Name) : Option Objects := do
  let _ ← env dst
  let _ ← env sizeOf
  let bytes ← (← env src)
  if dst=src then none else
    pure (fun n => if n=dst then some (some bytes) else env n)

def readObject (env : Objects) (name : B20.C.Name) : Option (BitVec 64) := do
  pure (B20.Word.LE.join (← (← env name)))

structure Function where
  name : B20.C.Name
  param : B20.C.Name
  localName : B20.C.Name
  dest : B20.C.Name
  src : B20.C.Name
  sizeOf : B20.C.Name
  returned : B20.C.Name
  deriving DecidableEq, Repr

def execute (f : Function) (w : BitVec 64) : Option (BitVec 64) := do
  let env ← declare (parameter f.param w) f.localName
  let final ← copyObject env f.dest f.src f.sizeOf
  readObject final f.returned

def wordType (t : Token) : Bool := t="uint64_t".toList || t="fpr".toList

/- A checked C grammar for the actual single-memcpy helpers. It accepts
only word objects, an address of a declared variable and sizeof(variable).
Other source constructs are rejected; function names are not special. -/
def parseCore : List Token → Option Function
  | result::name::['(']::ty::param::[')']::['{']::localTy::localName::[';']::
      memcpy::['(']::['&']::dst::[',']::['&']::src::[',']::sizeof::sizeOf::[')']::[';']::
      ret::returned::[';']::['}']::[] =>
    if wordType result && wordType ty && wordType localTy && memcpy="memcpy".toList &&
        sizeof="sizeof".toList && ret="return".toList then
      some ⟨name,param,localName,dst,src,sizeOf,returned⟩
    else none
  | _ => none

def parseTokens : List Token → Option Function
  | ['s','t','a','t','i','c']::['i','n','l','i','n','e']::ts => parseCore ts
  | ts => parseCore ts

def parse (chars : List Char) : Option Function :=
  (CLogicParser.tokenize (chars.length+1) chars).bind parseTokens

theorem copy_local_roundtrip (name src dst : B20.C.Name) (h : src≠dst) (w : BitVec 64) :
    execute ⟨name,src,dst,dst,src,dst,dst⟩ w=some w := by
  simp [execute,declare,parameter,copyObject,readObject,h,Ne.symm h,B20.Word.LE.join_byteOf]

end FT1536.Source3.BitcastObjects

#print FT1536.Source3.BitcastObjects.copy_local_roundtrip
#print axioms FT1536.Source3.BitcastObjects.copy_local_roundtrip
