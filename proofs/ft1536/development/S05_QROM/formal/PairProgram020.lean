import WordRAM020

/-! Actual closed program candidate for019. Universal time bound follows
    from its syntax. Every-tape refinement/no-fault is a separate obligation. -/
namespace FT1536.S05.PairProgram020
open WordRAM020

def lit (n : Int) : Expr := .lit (word n)
def r (i : Fin 32) : Expr := .reg i
def add := Expr.bin Op.add
def sub := Expr.bin Op.sub
def mul := Expr.bin Op.mul
def div := Expr.bin Op.div
def mod := Expr.bin Op.mod
def lt := Expr.bin Op.lt
def eq := Expr.bin Op.eq

def set (i : Reg) (e : Expr) : Code := .atom (.set i e)
def loadROM (i : Reg) (e : Expr) : Code := .atom (.loadROM i e)
def loadRAM (i : Reg) (e : Expr) : Code := .atom (.loadRAM i e)
def store (a v : Expr) : Code := .atom (.store a v)
def skip : Code := set 31 (r 31)
def seqs : List Code → Code := List.foldr Code.seq skip

def inc (i : Reg) : Code := set i (add (r i) (lit 1))
def nz (i : Reg) : Expr := lt (lit 0) (r i)

/-- Reads little-endian bits by descending addresses. Clobbers4,5,6,dst. -/
def readWord (dst : Reg) (base : Expr) (width : Nat) : Code := seqs [
  set 5 (lit 0), set 4 (lit width),
  .loop width (nz 4) (seqs [
    set 4 (sub (r 4) (lit 1)),
    .atom (.loadBit 6 (add base (r 4))),
    set 5 (add (mul (r 5) (lit 2)) (r 6))]),
  set dst (r 5)]

/-- The saturated lookup matches extended019, not a free table function. -/
def coordinate (dst : Reg) (base : Expr) : Code := seqs [
  readWord 7 base 384, loadROM 12 (lit 30720),
  set 7 (mod (r 7) (r 12)), set 8 (lit 0), set 9 (lit 30721),
  .loop 15 (nz 9) (seqs [
    set 10 (div (r 9) (lit 2)), set 11 (add (r 8) (r 10)),
    .branch (lt (r 11) (lit 30721)) (set 30 (r 11)) (set 30 (lit 30720)),
    loadROM 12 (r 30),
    .branch (lt (r 7) (r 12)) (set 9 (r 10))
      (seqs [set 8 (add (r 11) (lit 1)),set 9 (sub (sub (r 9) (r 10)) (lit 1))])]),
  .branch (lt (r 8) (lit 30721)) (set dst (r 8)) (set dst (lit 30720))]

/-- Norm trial0, pair1, retry2; both coordinates retained across word reads. -/
def trial : Code := seqs [
  set 3 (mul (add (mul (add (mul (r 0) (lit 1536)) (r 1)) (lit 80)) (r 2)) (lit 1024)),
  coordinate 13 (r 3), coordinate 14 (add (r 3) (lit 384)),
  readWord 7 (add (r 3) (lit 768)) 256,
  loadROM 12 (add (lit 30721) (add (r 13) (r 14))),
  .branch (lt (r 7) (r 12)) (seqs [
    set 15 (lit 1), set 13 (sub (r 13) (lit 15360)),set 14 (sub (r 14) (lit 15360))]) skip,
  inc 2]

/-- Signed coordinates in RAM[2p,2p+1]. Full q2 includes the cross term. -/
def pair : Code := seqs [
  set 15 (lit 0),set 2 (lit 0),
  .loop 80 (eq (r 15) (lit 0)) trial,
  .branch (eq (r 15) (lit 0)) (seqs [set 13 (lit 0),set 14 (lit 0)]) skip,
  store (mul (r 1) (lit 2)) (r 13),store (add (mul (r 1) (lit 2)) (lit 1)) (r 14),
  set 17 (add (add (mul (r 13) (r 13)) (mul (r 13) (r 14))) (mul (r 14) (r 14))),
  set 16 (add (r 16) (r 17)),inc 1]

def normTrial : Code := seqs [
  set 1 (lit 0),set 16 (lit 0),.loop 1536 (lit 1) pair,
  .branch (lt (r 16) (lit 2093922385)) (set 20 (lit 1)) skip,
  inc 0]

/-- Fresh suffix: address196*1536*80*1024, after ALL norm tapes. -/
def cube : Code := seqs [set 1 (lit 0),
  .loop 1536 (lit 1) (seqs [
    set 3 (add (lit (196*1536*80*1024)) (mul (r 1) (lit 20))),
    readWord 13 (r 3) 10, readWord 14 (add (r 3) (lit 10)) 10,
    store (mul (r 1) (lit 2)) (sub (r 13) (lit 512)),
    store (add (mul (r 1) (lit 2)) (lit 1)) (sub (r 14) (lit 512)),inc 1])]

def select : Code := seqs [set 0 (lit 0),set 20 (lit 0),
  .loop 196 (eq (r 20) (lit 0)) normTrial,
  .branch (eq (r 20) (lit 0)) cube skip]

/-- Fin768×Bool order is interleaved, exactly as Scatter.indices019. -/
def exponent (i : Reg) : Expr := add (div (r i) (lit 2)) (mul (mod (r i) (lit 2)) (lit 768))

/-- RAM coefficient buffer begins at3072, updated in place, canonical modq. -/
def update (index delta : Expr) : Code := seqs [
  set 26 (add (lit 3072) index),loadRAM 27 (r 26),
  store (r 26) (mod (add (r 27) delta) (lit 18433))]

def scatterTerm : Code := seqs [
  set 24 (exponent 22),loadRAM 19 (add (lit 1536) (r 22)),
  set 19 (mod (r 19) (lit 18433)),set 25 (mod (mul (r 18) (r 19)) (lit 18433)),
  set 17 (add (r 23) (r 24)),
  .branch (lt (r 17) (lit 1536)) (update (r 17) (r 25))
    (.branch (lt (r 17) (lit 2304))
      (seqs [update (sub (r 17) (lit 768)) (r 25),
        update (sub (r 17) (lit 1536)) (sub (lit 0) (r 25))])
      (update (sub (r 17) (lit 2304)) (sub (lit 0) (r 25)))),
  inc 22]

def multiply : Code := seqs [
  set 21 (lit 0),.loop 1536 (lit 1) (seqs [store (add (lit 3072) (r 21)) (lit 0),inc 21]),
  set 21 (lit 0),.loop 1536 (lit 1) (seqs [
    set 23 (exponent 21),loadROM 18 (add (lit 92162) (r 23)),
    set 22 (lit 0),.loop 1536 (lit 1) scatterTerm,inc 21])]

/-- Emits low bits of30 at output cursor28; clobbers4,30,28.
    Per-bit output writes and final caller-visible copy are distinct. -/
def emitWord (width : Nat) : Code := seqs [
  set 4 (lit width),.loop width (nz 4) (seqs [
    .atom (.emit (r 28) (mod (r 30) (lit 2))),
    set 30 (div (r 30) (lit 2)),inc 28,set 4 (sub (r 4) (lit 1))])]

/-- Full challenge, interleaved1536 canonical16-bit field coefficients;
    one presence bit;1536 box coordinates encoded as signed+65535 in17bits. -/
def emitPair : Code := seqs [
  set 28 (lit 0),set 21 (lit 0),
  .loop 1536 (lit 1) (seqs [
    set 23 (exponent 21),loadRAM 18 (r 21),loadRAM 19 (add (lit 3072) (r 23)),
    set 30 (mod (add (r 18) (r 19)) (lit 18433)),emitWord 16,inc 21]),
  .atom (.emit (r 28) (lit 1)),inc 28,
  set 21 (lit 0),.loop 1536 (lit 1) (seqs [
    loadRAM 30 (add (lit 1536) (r 21)),set 30 (add (r 30) (lit 65535)),emitWord 17,inc 21])]

def program : Code := seqs [select,multiply,emitPair]

/-- Genuine universal operational bound for this candidate. It does not
    assert that this candidate computes019 or succeeds without fault. -/
theorem operational_bound (i : Input) (s : State) :
    (run i program s).2 ≤ bound program := run_bound i program s

end FT1536.S05.PairProgram020
