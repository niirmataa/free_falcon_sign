import ProducerDataList020E8

set_option maxRecDepth 8192
namespace FT1536.S05.ProducerDataCases020E8
open WordRAM020 CoreState020E5 CoreEncoding020E5

section
variable {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
variable (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input)

def code (q : Core cap capacity limit) := (CoreDataPatch020E5.program hc hf hl a i q).val.code

theorem check (q : Core cap capacity limit) (hp : q.phase=.check) : code hc hf hl a i q=[] := by
  rcases q with ⟨s,f,v,p,c,l,t⟩
  change p=.check at hp
  subst p
  rfl

theorem done (q : Core cap capacity limit) (hp : q.phase=.done) : code hc hf hl a i q=[] := by
  rcases q with ⟨s,f,v,p,c,l,t⟩
  change p=.done at hp
  subst p
  rfl

theorem bad (q : Core cap capacity limit) (hp : q.phase=.bad) : code hc hf hl a i q=[] := by
  rcases q with ⟨s,f,v,p,c,l,t⟩
  change p=.bad at hp
  subst p
  rfl

end
end FT1536.S05.ProducerDataCases020E8
