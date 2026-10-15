import PublicCall020E12

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.PublicCallFailures020E12
open WordRAM020 JointInterface019 FT1536.Relation
attribute [local irreducible] PublicCoreCall020E12.fromRoot

theorem no_transport_failure (d : PublicData020E5.Data) (coins : Bits tapeSize) : PublicCall020E12.run d coins≠none := by
  rw [PublicCall020E12.run_eq]
  simp

theorem parser_reject (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877) (h : p.bad=true) :
    PublicCall020E12.fromParser d coins p=some none := by
  simp only [PublicCall020E12.fromParser,h,ite_true]

theorem root_reject (d : PublicData020E5.Data) (coins : Bits tapeSize) (p : ParserMachine020E5.State 877 877)
    (h : p.bad=false) (hs : p.arena.sp.val≠1) : PublicCall020E12.fromParser d coins p=some none := by
  simp only [PublicCall020E12.fromParser,h,Bool.false_eq_true,ite_false,PublicCoreCall020E12.fromArena,hs,Option.map_some,Option.map_none]

theorem prepared_total (k : CostInput020E4.Key) (coins : Bits tapeSize) :
    ∃ response,PublicCall020E12.run (PublicData020E5.prepared k) coins=some (some response) :=
  ⟨_,PublicCall020E12.every_tape k coins⟩

/-- Algorithmic abort remains a full response with its challenge; it is not
    filtered out as a transport failure or an unreachable wrapper fallback. -/
theorem abort_retained (h : Rq) (coins : Bits tapeSize) (c : Rq)
    (ha : (StandaloneRuntime019.publicCode h).code coins=(c,none)) :
    PublicCall020E12.run (PublicData020E5.prepared (ArrayBank020E4.load h)) coins=some (some (WireFormat020D.wire (c,none))) := by
  have he := PublicCall020E12.full_response (ArrayBank020E4.load h) coins
  rw [CostInput020E4.same_key,ha] at he
  exact he

end FT1536.S05.PublicCallFailures020E12
