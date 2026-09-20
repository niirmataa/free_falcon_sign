import RawLayout
set_option maxRecDepth 16384
namespace RawAssembly
-- Partial operations: source/array domains are not silently assumed total.
structure Ops (P B G C D E W : Type) where
  prefix : P → Option (B×G)
  top0 : G → Option C
  root : G → Option (List W×D)
  top1 : D → Option C
  cubic : C → Option (List W×(Fin 3 → D))
  lower : D → Option E
  binary : Tower.Ops E W
def depth {P B G C D E W : Type} (o : Ops P B G C D E W) (c : C) : Option (List W) := do
  let z←o.cubic c
  let a←o.lower (z.2 0)
  let left←Tower.execute o.binary 7 a
  let b←o.lower (z.2 1)
  let middle←Tower.execute o.binary 7 b
  let d←o.lower (z.2 2)
  let right←Tower.execute o.binary 7 d
  pure (z.1++left++middle++right)
def top {P B G C D E W : Type} (o : Ops P B G C D E W) (g : G) : Option (List W) := do
  let c←o.top0 g
  let left←depth o c
  let z←o.root g
  let d←o.top1 z.2
  let right←depth o d
  pure (z.1++left++right)
def prefix {P B G C D E W : Type} (o : Ops P B G C D E W) (p : P) : Option (B×List W) := do
  let bg←o.prefix p
  let tree←top o bg.2
  pure (bg.1,tree)
-- These are the individually consumed local domains, not a completed raw prefix.
structure LocalDomains {P B G C D E W : Type} (o : Ops P B G C D E W) (Pkey : P → Prop) where
  rootGood : G → Prop
  cubicGood : C → Prop
  rootDGood : D → Prop
  nodeDiagGood : D → Prop
  eightGood : E → Prop
  sevenGood : E → Prop
  prefix_domain : ∀p,Pkey p → ∃bg,o.prefix p=some bg ∧ rootGood bg.2
  first_top_domain : ∀g,rootGood g → ∃c,o.top0 g=some c ∧ cubicGood c
  root_domain : ∀g,rootGood g → ∃z,o.root g=some z ∧ rootDGood z.2
  second_top_domain : ∀d,rootDGood d → ∃c,o.top1 d=some c ∧ cubicGood c
  cubic_domain : ∀c,cubicGood c → ∃z,o.cubic c=some z ∧ ∀i,nodeDiagGood (z.2 i)
  lower_domain : ∀d,nodeDiagGood d → ∃e,o.lower d=some e ∧ eightGood e
  eight_domain : ∀e,eightGood e → ∃a z b,
    o.binary.first e=some a ∧ sevenGood a ∧ o.binary.ldl e=some z ∧ o.binary.second z.2=some b ∧ sevenGood b
  inherited_seven : ∀e,sevenGood e → ∃t,Tower.execute o.binary 6 e=some t
theorem inner8_from_actual_inner7 {P B G C D E W : Type} (o : Ops P B G C D E W)
    (Pkey : P → Prop) (h : LocalDomains o Pkey) (e : E) (he : h.eightGood e) :
    ∃t,Tower.execute o.binary 7 e=some t := by
  obtain ⟨a,z,b,ha,hga,hz,hb,hgb⟩:=h.eight_domain e he
  obtain ⟨l,hl⟩:=h.inherited_seven a hga
  obtain ⟨r,hr⟩:=h.inherited_seven b hgb
  exact ⟨z.1++l++r,by simp only [Tower.execute,ha,hl,hz,hb,hr,Option.bind_some,Option.pure_def]⟩
theorem depth_from_local_domains {P B G C D E W : Type} (o : Ops P B G C D E W)
    (Pkey : P → Prop) (h : LocalDomains o Pkey) (c : C) (hc : h.cubicGood c) :
    ∃t,depth o c=some t := by
  obtain ⟨z,hz,hg⟩:=h.cubic_domain c hc
  obtain ⟨a,ha,hga⟩:=h.lower_domain (z.2 0) (hg 0)
  obtain ⟨b,hb,hgb⟩:=h.lower_domain (z.2 1) (hg 1)
  obtain ⟨d,hd,hgd⟩:=h.lower_domain (z.2 2) (hg 2)
  obtain ⟨l,hl⟩:=inner8_from_actual_inner7 o Pkey h a hga
  obtain ⟨m,hm⟩:=inner8_from_actual_inner7 o Pkey h b hgb
  obtain ⟨r,hr⟩:=inner8_from_actual_inner7 o Pkey h d hgd
  exact ⟨z.1++l++m++r,by simp [depth,hz,ha,hb,hd,hl,hm,hr]⟩
theorem top_from_local_domains {P B G C D E W : Type} (o : Ops P B G C D E W)
    (Pkey : P → Prop) (h : LocalDomains o Pkey) (g : G) (hg : h.rootGood g) :
    ∃t,top o g=some t := by
  obtain ⟨c,hc,hgc⟩:=h.first_top_domain g hg
  obtain ⟨left,hl⟩:=depth_from_local_domains o Pkey h c hgc
  obtain ⟨z,hz,hgz⟩:=h.root_domain g hg
  obtain ⟨d,hd,hgd⟩:=h.second_top_domain z.2 hgz
  obtain ⟨right,hr⟩:=depth_from_local_domains o Pkey h d hgd
  exact ⟨z.1++left++right,by simp [top,hc,hl,hz,hd,hr]⟩
theorem raw_prefix_totality_from_local_domains {P B G C D E W : Type} (o : Ops P B G C D E W)
    (Pkey : P → Prop) (h : LocalDomains o Pkey) (p : P) (hp : Pkey p) :
    ∃out,prefix o p=some out := by
  obtain ⟨bg,hbg,hg⟩:=h.prefix_domain p hp
  obtain ⟨t,ht⟩:=top_from_local_domains o Pkey h bg.2 hg
  exact ⟨(bg.1,t),by simp [prefix,hbg,ht]⟩
theorem emitted_corollary {P B G C D E W Env Bytes : Type} (o : Ops P B G C D E W)
    (Pkey : P → Prop) (h : LocalDomains o Pkey) (Emitted : Env → Bytes → Bytes → Prop)
    (decode : Bytes → Option P)
    (binding : ∀e sk pk p,Emitted e sk pk → decode sk=some p → Pkey p)
    (e : Env) (sk pk : Bytes) (p : P) (he : Emitted e sk pk) (hd : decode sk=some p) :
    ∃out,prefix o p=some out := by
  exact raw_prefix_totality_from_local_domains o Pkey h p (binding e sk pk p he hd)
end RawAssembly
