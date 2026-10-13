import ArrayBank020E4
import WordRAM020

namespace FT1536.S05.ArrayState020E4
open WordRAM020 ArrayBank020E4

structure Input where
  tape : Bank Bool tapeSize
  rom : Bank Word romSize

structure State where
  reg : Bank Word 32
  ram : Bank Word ramSize
  out : Bank Bool outputSize
  fault : Bool

def input (i : Input) : WordRAM020.Input := ⟨read i.tape,read i.rom⟩
def model (s : State) : WordRAM020.State := ⟨read s.reg,read s.ram,read s.out,s.fault⟩
def loadInput (i : WordRAM020.Input) : Input := ⟨load i.tape,load i.rom⟩
def loadState (s : WordRAM020.State) : State := ⟨load s.reg,load s.ram,load s.out,s.fault⟩
def initial : State := ⟨zero 32 0,zero ramSize 0,zero outputSize false,false⟩

def put (s : State) (r : Reg) (w : Word) : State := {s with reg := write s.reg r w}
def store (s : State) (k : Fin ramSize) (w : Word) : State := {s with ram := write s.ram k w}
def emit (s : State) (k : Fin outputSize) (b : Bool) : State := {s with out := write s.out k b}
def fail (s : State) : State := {s with fault := true}

theorem input_load (i : WordRAM020.Input) : input (loadInput i)=i := by
  cases i;simp only [input,loadInput,read_load]

theorem model_load (s : WordRAM020.State) : model (loadState s)=s := by
  cases s;simp only [model,loadState,read_load]

theorem initial_eq : model initial=WordRAM020.initial := by
  simp only [model,initial,zero,read_load]
  rfl

theorem put_eq (s : State) (r : Reg) (w : Word) : model (put s r w)=WordRAM020.put (model s) r w := by
  simp only [model,put,read_write,WordRAM020.put]

theorem store_eq (s : State) (k : Fin ramSize) (w : Word) :
    model (store s k w)={model s with ram := Function.update (model s).ram k w} := by
  simp only [model,store,read_write]

theorem emit_eq (s : State) (k : Fin outputSize) (b : Bool) :
    model (emit s k b)={model s with out := Function.update (model s).out k b} := by
  simp only [model,emit,read_write]

theorem fail_eq (s : State) : model (fail s)=WordRAM020.fail (model s) := rfl

end FT1536.S05.ArrayState020E4
