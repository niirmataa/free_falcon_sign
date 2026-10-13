import Source3.KeygenDecodeNoneImages

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual coefficient body and source u++ as one chronological
   iteration, with preserved input bytes and legal future output stores. -/
namespace FT1536.Source3.KeygenDecodeNoneIteration
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeNoneScalar KeygenDecodeNoneReady KeygenDecodeNoneMemory KeygenDecodeNoneImages

def code : Stmt := .seq KeygenDecodeNoneBinding.node041 KeygenDecodeNoneBinding.loop042Update

theorem source_iteration (args : Args) (s t : State) (flow : Flow) (n : Nat) (bound : n<1536)
    (src dst : ArrayPointer) (input : BitVec 16) (rest : List (BitVec 16)) (carrier : Carrier input)
    (ready : Ready args n src dst s) (images : ImagesAt s.heap src n (input::rest))
    (legal : WritableArray s.heap dst 1536) (separate : src.block≠dst.block)
    (source : Exec args code s t flow) :
    flow=.normal ∧ Store16 s.heap (element dst n) input t.heap ∧
      Ready args (n+1) src dst t ∧ WritableArray t.heap dst 1536 ∧ ImagesAt t.heap src (n+1) rest := by
  obtain ⟨hiPtr,loPtr,hiStep,loStep,hiLoad,loLoad⟩ := head _ _ _ _ _ images
  have destination := advance s.heap dst 1536 n legal bound
  obtain ⟨bodyEnd,bodyExec,updateExec⟩ := KeygenDecodeControl.seq_split_given args
    KeygenDecodeNoneBinding.node041 KeygenDecodeNoneBinding.loop042Update s t flow source
    (fun next result actual => (KeygenDecodeNoneCoefficient.source_store args s next result n bound
      src dst hiPtr loPtr (element dst n) input carrier ready hiStep loStep hiLoad loLoad destination actual).1)
  obtain ⟨_,stored,bodyReady⟩ := KeygenDecodeNoneCoefficient.source_store args s bodyEnd .normal n bound
    src dst hiPtr loPtr (element dst n) input carrier ready hiStep loStep hiLoad loLoad destination bodyExec
  obtain ⟨same,normal⟩ := KeygenDecodeNoneCounter.update_source args bodyEnd t flow n bound bodyReady.cursor updateExec
  subst t
  have finalReady := KeygenDecodeNoneCounter.next_ready args bodyEnd n src dst bodyReady
  have finalLegal := legal_preserved s.heap bodyEnd.heap dst (element dst n) 1536 input legal stored
  have finalImages := tail bodyEnd.heap src n input rest
    (preserved s.heap bodyEnd.heap src (element dst n) n input (input::rest) images stored separate)
  exact ⟨normal,stored,finalReady,finalLegal,finalImages⟩

/-- An honest iteration exists from legal memory, with arbitrary initial
    output contents. All operations execute their pinned source statements. -/
theorem iteration_exists (args : Args) (s : State) (n : Nat) (bound : n<1536)
    (src dst : ArrayPointer) (input : BitVec 16) (rest : List (BitVec 16)) (carrier : Carrier input)
    (ready : Ready args n src dst s) (images : ImagesAt s.heap src n (input::rest))
    (legal : WritableArray s.heap dst 1536) (separate : src.block≠dst.block) :
    ∃ after, Exec args code s after .normal ∧ Store16 s.heap (element dst n) input after.heap ∧
      Ready args (n+1) src dst after ∧ WritableArray after.heap dst 1536 ∧ ImagesAt after.heap src (n+1) rest := by
  obtain ⟨hiPtr,loPtr,hiStep,loStep,hiLoad,loLoad⟩ := head _ _ _ _ _ images
  obtain ⟨bodyEnd,bodyExec,stored,bodyReady⟩ := KeygenDecodeNoneCoefficientExists.coefficient_exists
    args s n bound src dst hiPtr loPtr (element dst n) input carrier ready hiStep loStep hiLoad loLoad
    (advance s.heap dst 1536 n legal bound) (legal.2.2 n bound) legal.1 legal.2.1
  let after := KeygenDecodeNoneCounter.next bodyEnd n
  have updateExec := KeygenDecodeNoneCounter.update_exists args bodyEnd n bound bodyReady.cursor
  have full : Exec args code s after .normal := .seq args _ _ s bodyEnd after .normal bodyExec updateExec
  have actual := source_iteration args s after .normal n bound src dst input rest carrier ready images legal separate full
  exact ⟨after,full,actual.2⟩

end FT1536.Source3.KeygenDecodeNoneIteration
