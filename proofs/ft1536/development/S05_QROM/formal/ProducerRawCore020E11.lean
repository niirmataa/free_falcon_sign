import CommandConsumerRefinement020E11

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerRawCore020E11
open WordRAM020 ArrayBank020E4 WordCodec020E5 ProducerCoreRead020E6

abbrev Memory := Bank Word 143922
abbrev Core := CoreState020E5.Core 877 28941 1106642201817

/-- Resident immutable ports. The mutable raw core bank is passed separately.
    Neither typed Core nor a saved old state occurs in the operational context. -/
structure Context where
  parser : Bank Word 5266
  tape : Bank Word (tapeSize+1)
  rom : Bank Word (romSize+1)
  publicData : Bank Word 95452
  output : Bank Word (outputSize+1)
  fresh : Bank Word 1

def sources (c : Context) (m : Memory) : ProducerMachine020E6.Sources ProducerCoreView020E6.extent :=
  Fin.cases m (Fin.cases c.parser (Fin.cases c.tape (Fin.cases c.rom
    (Fin.cases c.publicData (Fin.cases c.output (Fin.cases c.fresh (fun j => Fin.elim0 j)))))))

/-- Runs the same two fixed stored code images as E6, against the current raw
    memory. Code loading, transient lifetime and full resources remain separate. -/
def produce (c : Context) (m : Memory) : Bank Word 96 :=
  ProducerStored020E6.pairRun (sources c m) ProducerStored020E6.windowCode ProducerStored020E6.slotCode

def step (c : Context) (m : Memory) : Option Memory :=
  CommandConsumer020E11.consume (capacity:=32) m (produce c m)

/-- Specification/initialization bridge, never called inside step or driver. -/
def ofData (d : BoundaryPayload020E5.Data) (fresh : Bool) : Context :=
  ⟨ParserStore020E5.image (by norm_num) (by norm_num) d.parser,
    FillStore020E5.image boolCodec (by norm_num [tapeSize]) d.tape,
    FillStore020E5.image wordCodec (by norm_num [romSize]) d.rom,
    PublicData020E5.image d.ro,
    FillStore020E5.image boolCodec (by norm_num [outputSize]) d.output,
    VerifiedPatch020E5.pack boolCodec fresh⟩

def image (q : Core) : Memory := CoreEncoding020E5.encode hc hf hl q

theorem ofData_core (d : BoundaryPayload020E5.Data) (fresh : Bool) (q : Core) :
    ofData {d with core:=q} fresh=ofData d fresh := rfl

theorem sources_image (d : BoundaryPayload020E5.Data) (fresh : Bool) (q : Core) :
    sources (ofData d fresh) (image q)=ProducerCoreView020E6.sources {d with core:=q} fresh := rfl

theorem produce_image (d : BoundaryPayload020E5.Data) (fresh : Bool) (q : Core) :
    produce (ofData d fresh) (image q)=ProducerStored020E6.run {d with core:=q} fresh := by
  unfold produce
  rw [sources_image]
  rfl

theorem step_image (d : BoundaryPayload020E5.Data) (fresh : Bool) (q : Core) :
    step (ofData d fresh) (image q)=some (image (CoreStep020E5.step d.parser.arena (ProducerSlotLayout020E7.input d) q)) := by
  obtain ⟨b,hb,he⟩ := ProducerWholeStep020E10.script {d with core:=q} fresh
  have hc' := CommandConsumerRefinement020E11.consumes (n:=143922) (capacity:=32) (by norm_num) (image q) b
  have hw : CommandConsumerRefinement020E11.encode (n:=143922) (by norm_num) b=produce (ofData d fresh) (image q) :=
    hb.trans (produce_image d fresh q).symm
  exact (congrArg (CommandConsumer020E11.consume (capacity:=32) (image q)) hw.symm).trans (hc'.trans (congrArg some he))

end FT1536.S05.ProducerRawCore020E11
