import ZeroCodec020E5
import CostInput020E4

namespace FT1536.S05.BoundaryFill020E5
open WordRAM020 ArrayBank020E4 JointInterface019

/-- Generic loop specification: the length remains abstract when the kernel
    checks the refinement, avoiding evaluation of a closed enormous loop. -/
def fill {A : Type} {n : Nat} (f : Fin n → A) (d : A) : Bank A n :=
  (FillMachine020E5.run f n (FillMachine020E5.start (zero n d))).bank

theorem fill_eq {A : Type} {n : Nat} (f : Fin n → A) (d : A) : fill f d=load f :=
  FillMachine020E5.fills f (zero n d)

theorem fill_read {A : Type} {n : Nat} (b : Bank A n) (d : A) : fill (read b) d=b :=
  (fill_eq (read b) d).trans (load_read b)

def tape (coins : Bits tapeSize) : Bank Bool tapeSize := fill coins false

def rom (k : CostInput020E4.Key) : Bank Word romSize := fill (fun j => (CostInput020E4.romCell k j).value) 0

def inputs (k : CostInput020E4.Key) (coins : Bits tapeSize) : ArrayState020E4.Input := ⟨tape coins,rom k⟩

def output (b : Bank Bool outputSize) : Bank Bool outputSize := fill (read b) false

theorem tape_eq (coins : Bits tapeSize) : tape coins=load coins := fill_eq coins false

theorem rom_eq (k : CostInput020E4.Key) : rom k=load (InputLayout020.image (CostInput020E4.key k)) :=
  (fill_eq (fun j => (CostInput020E4.romCell k j).value) (0 : Word)).trans
    (congrArg load (funext (CostInput020E4.rom_value k)))

theorem inputs_eq (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    inputs k coins=ArrayState020E4.loadInput (InputLayout020.encode (CostInput020E4.key k) coins) := by
  rw [inputs,tape_eq,rom_eq]
  rfl

theorem output_eq (b : Bank Bool outputSize) : output b=b := fill_read b false

end FT1536.S05.BoundaryFill020E5
