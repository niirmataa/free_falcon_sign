import ScratchRound020E5
import CoreStore020E5
import CoreStartup020E5
import ParserStore020E5

set_option exponentiation.threshold 512
namespace FT1536.S05.ScratchConsumers020E5
open WordRAM020 ArrayBank020E4 VerifiedPatch020E5

/-- This certificate covers a populated script and its physical store
    protocol. It does not charge the producer of p.code or ambient data. -/
theorem checked {n : Nat} (hn : n≤2^511) {a b : Bank Word n} (p : Program a b) (hp : p.code.length≤32)
    (buffer : ScriptBuffer020E5.Buffer n 32) (cursor : Fin 33)
    (context : RegionRam020E5.Heap) (r : Fin context.size) :
    let q : ScriptMachine020E5.State n 32 := ⟨a,buffer,cursor⟩
    (ScratchRound020E5.round q p.code).target=b ∧
    ∃ hist,RegionRam020E5.Steps (RegionSlot020E5.frame context r (ScriptStore020E5.image hn (by norm_num) q)) hist
      (RegionSlot020E5.frame context r (ScriptStore020E5.image hn (by norm_num) (ScratchRound020E5.round q p.code))) ∧
      ∀ h∈RegionSlot020E5.frame context r (ScriptStore020E5.image hn (by norm_num) q)::hist,
        RegionRam020E5.live h=RegionRam020E5.live (RegionSlot020E5.frame context r (ScriptStore020E5.image hn (by norm_num) q)) := by
  dsimp only
  constructor
  · exact (ScratchRound020E5.round_target _ p.code hp).trans p.correct
  · obtain ⟨hist,ht⟩ := ScratchRound020E5.round_heap hn (by norm_num) ⟨a,buffer,cursor⟩ p.code context r
    exact ⟨hist,ht,RegionTrace020E5.peak ht⟩

theorem core {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (q : CoreState020E5.Core cap capacity limit)
    (buffer : ScriptBuffer020E5.Buffer (CoreEncoding020E5.payloadWords cap capacity) 32) (cursor : Fin 33) :
    (ScratchRound020E5.round ⟨CoreEncoding020E5.encode hc hf hl q,buffer,cursor⟩ (CoreStore020E5.code hc hf hl a i q)).target=
      CoreEncoding020E5.encode hc hf hl (CoreStep020E5.step a i q) :=
  (ScratchRound020E5.round_target _ _ (le_trans (CoreStore020E5.length_bound hc hf hl a i q) (by decide))).trans
    (CoreStore020E5.realizes hc hf hl a i q)

theorem parser {cap n : Nat} (hc : cap<2^511) (hn : n<2^511) (c : SyntaxCells020E.Cell) (q : ParserMachine020E5.State cap n)
    (buffer : ScriptBuffer020E5.Buffer (ParserStore020E5.Width cap) 32) (cursor : Fin 33) :
    (ScratchRound020E5.round ⟨ParserStore020E5.image hc hn q,buffer,cursor⟩ (ParserStore020E5.program hc hn c q).code).target=
      ParserStore020E5.image hc hn (ParserMachine020E5.step c q) :=
  (ScratchRound020E5.round_target _ _ (le_trans (ParserStore020E5.length_bound hc hn c q) (by decide))).trans
    (ParserStore020E5.program hc hn c q).correct

theorem fill {A : Type} {n w : Nat} (c : WordCodec020E5.Codec A w) (hn : n<2^511) (hw : w+1≤32)
    (f : Fin n → A) (q : FillMachine020E5.State A n)
    (buffer : ScriptBuffer020E5.Buffer (n*w+1) 32) (cursor : Fin 33) :
    (ScratchRound020E5.round ⟨FillStore020E5.image c hn q,buffer,cursor⟩ (FillStore020E5.code c f q)).target=
      FillStore020E5.image c hn (FillMachine020E5.step f q) :=
  (ScratchRound020E5.round_target _ _ (le_trans (FillStore020E5.length_bound c f q) hw)).trans
    (FillStore020E5.realizes c hn f q)

theorem startup {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (h : 0<capacity) (root : ArenaTypes020E1.Ptr cap)
    (buffer : ScriptBuffer020E5.Buffer (CoreEncoding020E5.payloadWords cap capacity) 32) (cursor : Fin 33) :
    (ScratchRound020E5.round ⟨CoreEncoding020E5.encode hc hf hl (CoreStartup020E5.blank cap capacity limit),buffer,cursor⟩
      (CoreStartup020E5.program hc hf hl h root).code).target=CoreEncoding020E5.encode hc hf hl (CoreStartup020E5.ready h root) :=
  (ScratchRound020E5.round_target _ _ (by rw [CoreStartup020E5.length];decide)).trans
    (CoreStartup020E5.program hc hf hl h root).correct

end FT1536.S05.ScratchConsumers020E5
