import Source3.ShakeProcessEvents128

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ShakeExtractTrace128
open C99CompactState115 (State)
open ShakeExtractSource (Layout Stmt field)
open ShakeProcessEvents128 (Proposal Result)

def ordinary (computation : Option State) : Option Result := computation.map (fun state => (state,[]))

/-- Same source control and ordinary operations as120. Only process calls
    may be proposed; every one is logged and needs its own source proof. -/
def run (ctx : Layout) (propose : Proposal) : Nat → Stmt → State → Option Result
  | 0, _, _ => none
  | _+1, .scalar code, state => ordinary (ShakeBlockCompute116.scalar state code)
  | _+1, .declarePointer name, state => some (C99CompactPointer115.declarePointer state name,[])
  | _+1, .pointer dst src index, state => ordinary (ShakeSeedBasic118.pointer state dst src index)
  | _+1, .fieldPointer dst member, state => some (C99CompactState115.bindPointer state dst (field ctx member),[])
  | _+1, .fieldRead dst member, state => ordinary (ShakeSeedBasic118.readLocal ctx state dst member)
  | _+1, .fieldStore member value, state => ordinary (ShakeExtractBasic120.fieldStore ctx state member value)
  | _+1, .process name, state => (propose state name).map (fun after => (after,[⟨state,name,after⟩]))
  | _+1, .encode dst index value, state => ordinary (ShakeExtractCalls120.encode state dst index value)
  | _+1, .copy dst index count, state => ordinary (ShakeExtractCopy120.copy ctx state dst index count)
  | _+1, .skip, state => some (state,[])
  | fuel+1, .seq first second, state => do
      let (middle,firstEvents) ← run ctx propose fuel first state
      let (after,secondEvents) ← run ctx propose fuel second middle
      pure (after,firstEvents++secondEvents)
  | fuel+1, .scope locals pointers body, state =>
      (run ctx propose fuel body state).map (fun (after,events) =>
        (C99CompactState115.restoreScope state after locals pointers,events))
  | fuel+1, .branch condition yes no, state => do
      let value ← ShakeBlockComputeRead116.evaluate state condition
      run ctx propose fuel (if value.integer=0 then no else yes) state
  | fuel+1, .loop condition body, state => do
      let value ← ShakeBlockComputeRead116.evaluate state condition
      if value.integer=0 then pure (state,[]) else do
        let (middle,headEvents) ← run ctx propose fuel body state
        let (after,tailEvents) ← run ctx propose fuel (.loop condition body) middle
        pure (after,headEvents++tailEvents)

end FT1536.Source3.ShakeExtractTrace128
