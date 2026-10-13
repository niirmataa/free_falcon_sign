import ScriptStore020E5

namespace FT1536.S05.ProducerMachine020E6
open WordRAM020 ArrayBank020E4

abbrev Register := Fin 64
abbrev OutputCell := Fin 96

/-- Borrowed, already resident word banks. The producer never receives a
    host callback as an instruction; a load addresses one of these arrays. -/
abbrev Sources {regions : Nat} (extent : Fin regions → Nat) := (r : Fin regions) → Bank Word (extent r)

inductive Instruction (regions codeSize : Nat) where
  | literal (dst : Register) (value : Word)
  | copy (dst src : Register)
  | binary (dst : Register) (op : Op) (lhs rhs : Register)
  | load (dst : Register) (region : Fin regions) (address : Register)
  | output (dst : OutputCell) (src : Register)
  | select (dst condition zero nonzero : Register)

structure State (codeSize : Nat) where
  regs : Bank Word 64
  output : Bank Word 96
  pc : Fin (codeSize+1)
  fault : Bool

def next {codeSize : Nat} (pc : Fin (codeSize+1)) : Fin (codeSize+1) := ⟨min codeSize (pc.val+1),by omega⟩

def execute {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (ins : Instruction regions codeSize) (q : State codeSize) : State codeSize :=
  let r := {q with pc:=next q.pc}
  match ins with
  | .literal dst value => {r with regs:=write q.regs dst value}
  | .copy dst src => {r with regs:=write q.regs dst (read q.regs src)}
  | .binary dst op lhs rhs => {r with regs:=write q.regs dst (WordRAM020.op op (read q.regs lhs) (read q.regs rhs))}
  | .load dst region addr => match WordRAM020.address (extent region) (read q.regs addr) with
      | none => {r with regs:=write q.regs dst 0,fault:=true}
      | some j => {r with regs:=write q.regs dst (read (sources region) j)}
  | .output dst src => {r with output:=write q.output dst (read q.regs src)}
  | .select dst condition zero nonzero =>
      {r with regs:=write q.regs dst (read q.regs (if read q.regs condition=0 then zero else nonzero))}

def step {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) (q : State codeSize) : State codeSize :=
  if h : q.pc.val<codeSize then execute sources (read code ⟨q.pc.val,h⟩) q else q

/-- Fuel bounds the mathematical trace. Runtime control is the stored pc;
    the machine has no call stack, closure heap, or dynamically grown list. -/
def run {regions codeSize : Nat} {extent : Fin regions → Nat} (sources : Sources extent)
    (code : Bank (Instruction regions codeSize) codeSize) : Nat → State codeSize → State codeSize
  | 0,q => q
  | fuel+1,q => if q.pc.val=codeSize then q else run sources code fuel (step sources code q)

def initial (codeSize : Nat) : State codeSize := ⟨zero 64 0,zero 96 0,0,false⟩

end FT1536.S05.ProducerMachine020E6
