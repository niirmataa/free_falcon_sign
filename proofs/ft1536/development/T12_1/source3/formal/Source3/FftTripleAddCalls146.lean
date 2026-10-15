import Source3.FftTripleAddShape146

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleAddCalls146
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Allocated)
open FftMulStates140 (Words)
open FftPairShape140 (temporaries)
open FftTripleAddShape146 (localParameters storeParameters realIndex imagIndex)

def NamesSafe (p : FpcAddCompute146.Inputs) : Prop :=
  p.ar∉temporaries ∧ p.ai∉temporaries ∧ p.br∉temporaries ∧ p.bi∉temporaries

theorem local_names (i : Fin 3) : NamesSafe (localParameters i).inputs ∧
    (localParameters i).dr∉temporaries ∧ (localParameters i).di∉temporaries ∧
    (localParameters i).dr≠(localParameters i).di := by
  fin_cases i
  all_goals unfold NamesSafe; decide +kernel

theorem store_names (i : Fin 3) : NamesSafe (storeParameters i).inputs := by
  fin_cases i
  all_goals unfold NamesSafe; decide +kernel

theorem local_source (i : Fin 3) (s : State) (x : Words)
    (ar : s.locals (localParameters i).inputs.ar=some (.uint64,some (.uint64 x.ar)))
    (ai : s.locals (localParameters i).inputs.ai=some (.uint64,some (.uint64 x.ai)))
    (br : s.locals (localParameters i).inputs.br=some (.uint64,some (.uint64 x.br)))
    (bi : s.locals (localParameters i).inputs.bi=some (.uint64,some (.uint64 x.bi))) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part (19+i.val)) s
      ⟨FpcAddLocal146.output s (localParameters i) x,.normal⟩ := by
  obtain ⟨⟨arSafe,aiSafe,brSafe,biSafe⟩,drSafe,diSafe,distinct⟩ := local_names i
  rw [FftTripleAddShape146.local_shape]
  apply C99ProcedureReference.Exec.base
  apply FpcAddLocal146.source
  refine ⟨⟨ar,ai,br,bi,arSafe,aiSafe,brSafe,biSafe⟩,?_,?_,drSafe,diSafe,distinct⟩
  · refine ⟨some (.uint64 x.ar),?_⟩
    rw [FftTripleAddShape146.local_real]
    exact ar
  · refine ⟨some (.uint64 x.ai),?_⟩
    rw [FftTripleAddShape146.local_imag]
    exact ai

theorem store_source (i : Fin 3) (s : State) (x : Words) (r q : ArrayPointer)
    (ar : s.locals (storeParameters i).inputs.ar=some (.uint64,some (.uint64 x.ar)))
    (ai : s.locals (storeParameters i).inputs.ai=some (.uint64,some (.uint64 x.ai)))
    (br : s.locals (storeParameters i).inputs.br=some (.uint64,some (.uint64 x.br)))
    (bi : s.locals (storeParameters i).inputs.bi=some (.uint64,some (.uint64 x.bi)))
    (realAddress : Pointer s "a".toList (realIndex i) r) (imagAddress : Pointer s "a".toList (imagIndex i) q)
    (realAllocated : Allocated s.heap r) (imagAllocated : Allocated s.heap q)
    (realWidth : r.elementBytes=8) (imagWidth : q.elementBytes=8)
    (realWritable : s.heap.writable r.block=true) (imagWritable : s.heap.writable q.block=true) :
    C99ProcedureReference.Exec KeygenSearchFft.program (FftTripleShape145.part (22+i.val)) s
      ⟨FpcAddStore146.output s x r q,.normal⟩ := by
  obtain ⟨arSafe,aiSafe,brSafe,biSafe⟩ := store_names i
  rw [FftTripleAddShape146.store_shape]
  exact .base _ _ _ (FpcAddStore146.source FftLeafPrograms.program s (storeParameters i) x r q
    ⟨⟨ar,ai,br,bi,arSafe,aiSafe,brSafe,biSafe⟩,realAddress,imagAddress,realAllocated,imagAllocated,
      realWidth,imagWidth,realWritable,imagWritable,FftTripleAddShape146.real_safe i,FftTripleAddShape146.imag_safe i⟩)

end FT1536.Source3.FftTripleAddCalls146
