import TargetFrame
namespace InitialTarget
structure Ops (Challenge Vector Word : Type) where
  convert : Challenge → Option Vector
  fft : Vector → Option Vector
  reciprocal : Option Word
  copy : Vector → Option Vector
  multiply : Vector → Vector → Option Vector
  scale : Vector → Word → Option Vector
  negate : Word → Word
def execute {C V W : Type} (o : Ops C V W) (c : C) (b01 b11 : V) : Option (V×V×W) := do
  let a←o.convert c
  let f←o.fft a
  let ni←o.reciprocal
  let copied←o.copy f
  let p1←o.multiply copied b01
  let t1←o.scale p1 (o.negate ni)
  let p0←o.multiply f b11
  let t0←o.scale p0 ni
  pure (t0,t1,ni)
theorem source_word_match {C V W : Type} (o : Ops C V W) (c : C) (b01 b11 a f p0 p1 t0 t1 : V) (ni : W)
    (ha : o.convert c=some a) (hf : o.fft a=some f) (hn : o.reciprocal=some ni)
    (hc : o.copy f=some f) (hp1 : o.multiply f b01=some p1) (ht1 : o.scale p1 (o.negate ni)=some t1)
    (hp0 : o.multiply f b11=some p0) (ht0 : o.scale p0 ni=some t0) :
    execute o c b01 b11=some (t0,t1,ni) := by simp [execute,ha,hf,hn,hc,hp1,ht1,hp0,ht0]
theorem defined_prefix_from_local_domains {C V W : Type} (o : Ops C V W) (canonical : C → Prop)
    (b01 b11 : V)
    (domains : ∀c,canonical c → ∃a f ni p1 t1 p0 t0,
      o.convert c=some a ∧ o.fft a=some f ∧ o.reciprocal=some ni ∧ o.copy f=some f ∧
      o.multiply f b01=some p1 ∧ o.scale p1 (o.negate ni)=some t1 ∧ o.multiply f b11=some p0 ∧ o.scale p0 ni=some t0) :
    ∀c,canonical c → ∃out,execute o c b01 b11=some out := by
  intro c hc
  obtain ⟨a,f,ni,p1,t1,p0,t0,ha,hf,hn,hcopy,hp1,ht1,hp0,ht0⟩:=domains c hc
  exact ⟨(t0,t1,ni),source_word_match o c b01 b11 a f p0 p1 t0 t1 ni ha hf hn hcopy hp1 ht1 hp0 ht0⟩
end InitialTarget
