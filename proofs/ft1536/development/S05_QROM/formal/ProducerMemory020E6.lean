import ProducerFetchTrace020E6
import ProducerProgram020E6

namespace FT1536.S05.ProducerMemory020E6
open WordRAM020 ArrayBank020E4 WordCodec020E5 VerifiedPatch020E5 RegionRam020E5

/-- Actual resident source arrays, with one directory entry per array. -/
def sourceHeap {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent) : Heap :=
  Array.ofFn (fun r => ⟨(sources r).cells⟩)

theorem source_read {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent) (r : Fin regions) :
    (sourceHeap sources)[r.val]'(by simp only [sourceHeap,Array.size_ofFn];exact r.isLt)=⟨(sources r).cells⟩ := by
  simp only [sourceHeap,Array.getElem_ofFn]

theorem source_words {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent) :
    words (sourceHeap sources)=(List.ofFn extent).sum := by
  simp only [words,sourceHeap,Array.toList_ofFn,List.map_ofFn,Function.comp_def,ArrayBank020E4.fixed_size]

theorem source_live {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent) :
    live (sourceHeap sources)=(List.ofFn extent).sum+2*regions := by
  rw [live,source_words]
  simp only [sourceHeap,Array.size_ofFn]

def codeImage {regions codeSize : Nat} (hr : regions≤2^511)
    (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize) :=
  pack (bank (ProducerCodec020E6.instruction regions codeSize hr) codeSize) code

def context {regions codeSize : Nat} {extent : Fin regions → Nat} (hr : regions≤2^511)
    (sources : ProducerMachine020E6.Sources extent) (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize) : Heap :=
  (RegionRam020E5.allocate (sourceHeap sources) (codeImage hr code).cells).1

theorem context_live {regions codeSize : Nat} {extent : Fin regions → Nat} (hr : regions≤2^511)
    (sources : ProducerMachine020E6.Sources extent) (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize) :
    live (context hr sources code)=(List.ofFn extent).sum+2*regions+22*codeSize+2 := by
  rw [context,allocate_live,source_live,ArrayBank020E4.fixed_size]
  omega

/-- The input and code context is instantiated with actual stored arrays.
    The186-word machine payload includes instruction-fetch storage; its
    directory entry costs two more words in the inherited region model. -/
theorem complete_peak {regions codeSize : Nat} {extent : Fin regions → Nat} (hr : regions≤2^511) (hc : codeSize<2^511)
    (sources : ProducerMachine020E6.Sources extent) (code : Bank (ProducerMachine020E6.Instruction regions codeSize) codeSize)
    (fuel : Nat) (q : ProducerFetch020E6.State regions codeSize) :
    ∃ hist,Steps (RegionFrame020E5.heap (context hr sources code) (ProducerFetchStore020E6.image hr hc q)) hist
      (RegionFrame020E5.heap (context hr sources code)
        (ProducerFetchStore020E6.image hr hc (ProducerFetch020E6.run sources code fuel q))) ∧
      ∀ heap∈RegionFrame020E5.heap (context hr sources code) (ProducerFetchStore020E6.image hr hc q)::hist,
        live heap=(List.ofFn extent).sum+2*regions+22*codeSize+190 := by
  obtain ⟨hist,ht,hp⟩ := ProducerFetchTrace020E6.run_peak hr hc sources code fuel q (context hr sources code)
  refine ⟨hist,ht,?_⟩
  intro heap hh
  rw [hp heap hh,context_live]
  omega

end FT1536.S05.ProducerMemory020E6
