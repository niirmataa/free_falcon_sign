import Source3.SelectedRootContext175

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RootBinding175
open C99ArrayReference (State Bind Pointer bindPointer)
open C99MemoryReference (ArrayPointer)
open KeygenSearchContext (Context)

theorem zero (s : State) (name : String) (p : ArrayPointer)
    (binding : s.arrays name.toList=some p) (capacity : p.index≤p.count) :
    Pointer s name.toList C99ProcedureParser.zero p :=
  .add name.toList C99ProcedureParser.zero p p (.uint64 0) binding (.literal .uint64 0) (by decide)
    (.within p 0 (by simpa only [Nat.add_zero] using capacity))

theorem source (ctx : Context) (s : State) (input : Fin 4 → ArrayPointer) (primes rev : ArrayPointer)
    (legal : KeygenRootCaller.Legal ctx s input primes rev)
    (ctxCapacity : ctx.object.index≤ctx.object.count)
    (inputCapacity : ∀ i, (input i).index≤(input i).count) :
    Bind s KeygenRootSource.params KeygenRootSource.arguments (KeygenRootCaller.bound s ctx input) :=
  .pointer "fk".toList "fk".toList C99ProcedureParser.zero ctx.object _ _ _
    (zero s "fk" ctx.object legal.context ctxCapacity)
    (.pointer "F".toList "F".toList C99ProcedureParser.zero (input 2) _ _ _
      (zero s "F" (input 2) (legal.inputs 2) (inputCapacity 2))
      (.pointer "G".toList "G".toList C99ProcedureParser.zero (input 3) _ _ _
        (zero s "G" (input 3) (legal.inputs 3) (inputCapacity 3))
        (.pointer "f".toList "f".toList C99ProcedureParser.zero (input 0) _ _ _
          (zero s "f" (input 0) (legal.inputs 0) (inputCapacity 0))
          (.pointer "g".toList "g".toList C99ProcedureParser.zero (input 1) _ _ _
            (zero s "g" (input 1) (legal.inputs 1) (inputCapacity 1)) .nil))))

end FT1536.Source3.RootBinding175
