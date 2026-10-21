import Source3.ZintRebuildCrt194
import Source3.SelectedStepCrtWord194

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- DIAGNOSTIC probe (not proof evidence): isolates the record-update
   heap projection bridge that the SelectedStepCrtRun194 drafts could
   not discharge. -/
namespace FT1536.Source3.CrtBridgeProbe194
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32 Memory)
open ZintNormWalk194 (elem walkImage walkState xlenName tmpName)
open ZintRebuildCrt194 (xxName primesName normSignedName word_one word_zero)
open KeygenFullData127 (primes)
open SelectedStepLayout187 (fs gs gm t1)
open C99NatWord141 (word)

abbrev p0 : BitVec 32 := SelectedTopInit178.p
noncomputable def fsWords : Nat -> BitVec 32 :=
  fun j => NttInverseWholeBridges192.scaledWord SelectedStepProduct191.fvs
    SelectedStepChain193.tws SelectedTopInit178.p SelectedTopInit178.p0i j
noncomputable def heapFsOf (next : State) : Memory :=
  walkImage (Word32Memory176.write next.heap gm p0) fs p0 fsWords 512

theorem probe1 (next : State) : ({next with heap := heapFsOf next}).heap=heapFsOf next := rfl

end FT1536.Source3.CrtBridgeProbe194
