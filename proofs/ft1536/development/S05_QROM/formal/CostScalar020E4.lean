import CostFlow020E4
import SyntaxCells020E

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.CostScalar020E4
open WordRAM020 SyntaxTape020E CostRun020E4 CostFlow020E4

/-- MODEL: bounded scalar/Word512 interpretation and arithmetic operations. -/
def signed (w : Word) : Run Int := charge 1 1 w.toInt
def natural (z : Int) : Run Nat := charge 1 1 z.toNat

def regOf (w : Word) : Run (Option Reg) :=
  CostRun020E4.bind (signed w) (fun z => CostRun020E4.bind (natural z) (fun n =>
    if h : n<32 then charge 2 2 (some ⟨n,h⟩) else charge 2 2 none))

def opOf (n : Nat) : Run (Option Op) := match n with
  | 0 => charge 1 1 (some .add) | 1 => charge 2 2 (some .sub)
  | 2 => charge 3 3 (some .mul) | 3 => charge 4 4 (some .div)
  | 4 => charge 5 5 (some .mod) | 5 => charge 6 6 (some .lt)
  | 6 => charge 7 7 (some .eq) | _ => charge 8 8 none

def decode (c : SyntaxCells020E.Cell) : Run (Option Token) := overhead 16 (match c.1.val with
  | 0 => charge 1 1 (some (.literal c.2))
  | 1 => CostRun020E4.map (Option.map Token.register) (regOf c.2)
  | 2 => CostRun020E4.bind (signed c.2) (fun z => CostRun020E4.bind (natural z)
      (fun n => CostRun020E4.map (Option.map Token.binary) (opOf n)))
  | 3 => CostRun020E4.map (Option.map Token.setter) (regOf c.2)
  | 4 => CostRun020E4.map (Option.map Token.rom) (regOf c.2)
  | 5 => CostRun020E4.map (Option.map Token.ram) (regOf c.2)
  | 6 => CostRun020E4.map (Option.map Token.bit) (regOf c.2)
  | 7 => charge 1 1 (some .store) | 8 => charge 1 1 (some .emit)
  | 9 => charge 1 1 (some .seq) | 10 => charge 1 1 (some .branch)
  | 11 => CostRun020E4.bind (signed c.2)
      (fun z => CostRun020E4.map (fun n => some (.loop n)) (natural z))
  | _ => charge 1 1 none)

def address (n : Nat) (w : Word) : Run (Option (Fin n)) :=
  CostRun020E4.bind (signed w) (fun z => CostRun020E4.bind (natural z) (fun k =>
    if h : 0≤z ∧ k<n then charge 4 4 (some ⟨k,h.2⟩) else charge 4 4 none))

def operate (o : Op) (a b : Word) : Run Word := charge 1 1 (WordRAM020.op o a b)

theorem reg_value (w : Word) : (regOf w).value=SyntaxCells020E.regOf w := by
  by_cases h : w.toInt.toNat<32
  all_goals simp [regOf,signed,natural,CostRun020E4.bind,charge,SyntaxCells020E.regOf,h]

theorem reg_budget (w : Word) : (regOf w).ticks=4 ∧ (regOf w).allocated=4 := by
  by_cases h : w.toInt.toNat<32
  all_goals simp [regOf,signed,natural,CostRun020E4.bind,charge,h]

theorem op_value (n : Nat) : (opOf n).value=SyntaxCells020E.opOf n := by
  unfold opOf SyntaxCells020E.opOf
  split <;> simp_all [charge]

theorem op_bound (n : Nat) : Bounded (opOf n) 8 8 := by
  unfold opOf
  split <;> norm_num [Bounded,charge]

theorem address_value (n : Nat) (w : Word) : (address n w).value=WordRAM020.address n w := by
  by_cases h : 0≤w.toInt ∧ w.toInt.toNat<n
  all_goals simp [address,signed,natural,CostRun020E4.bind,charge,WordRAM020.address,h]

theorem address_budget (n : Nat) (w : Word) :
    (address n w).ticks=6 ∧ (address n w).allocated=6 := by
  by_cases h : 0≤w.toInt ∧ w.toInt.toNat<n
  all_goals simp [address,signed,natural,CostRun020E4.bind,charge,h]

theorem decode_value (c : SyntaxCells020E.Cell) : (decode c).value=SyntaxCells020E.decode c := by
  rcases c with ⟨⟨tag,ht⟩,w⟩
  interval_cases tag <;>
    simp only [decode,overhead,CostRun020E4.map,CostRun020E4.bind,signed,natural,charge,
      SyntaxCells020E.decode,reg_value,op_value]

theorem decode_bound (c : SyntaxCells020E.Cell) : Bounded (decode c) 32 32 := by
  rcases c with ⟨⟨tag,ht⟩,w⟩
  have hr := reg_budget w
  have ho := op_bound w.toInt.toNat
  rcases hr with ⟨hrt,hrm⟩
  rcases ho with ⟨hot,hom⟩
  interval_cases tag <;>
    simp only [Bounded,decode,overhead,CostRun020E4.map,CostRun020E4.bind,signed,natural,charge]
  all_goals constructor <;> omega


end FT1536.S05.CostScalar020E4
