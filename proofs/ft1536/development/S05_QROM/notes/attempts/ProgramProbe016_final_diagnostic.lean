import SamplerSupport016
import ProductLaw016
open FT1536.S05
attribute [local irreducible] CapExecution016.first SamplerCode016.normTrial
#check @CapExecution016.finish
#check @CapExecution016.first
#print SamplerCode016.selected
#print CapExecution016.finish
#check @SamplerCode016.seedFintype
#check @SamplerCode016.normSeedFintype
private theorem helper {A B : Type} (f : B → A) (o : Option A) (b : B) :
    (match o with | some a => a | none => f b)=CapExecution016.finish f (o,b) := by cases o <;> rfl
example (t : SamplerCode016.Tables) (input : SamplerCode016.Seed) :
    SamplerCode016.selected t input=CapExecution016.finish SamplerCode016.cube
      (CapExecution016.first (SamplerCode016.normTrial t) 196 input.1,input.2) := by
  unfold SamplerCode016.selected CapExecution016.finish
  generalize he : CapExecution016.first (SamplerCode016.normTrial t) 196 input.1=o
  cases o <;> rfl
