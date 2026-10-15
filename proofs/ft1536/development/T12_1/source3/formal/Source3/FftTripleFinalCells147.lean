import Source3.FftTripleArithmetic147

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftTripleFinalCells147
open C99ArrayReference (State)
open FftTripleWords147 (Inputs storeWords)
open FftTripleArithmetic147 (Entry state10)
open FftTripleAddShape146 (storeParameters)

theorem ar (s : State) (x : Inputs) (entry : Entry s x) (i : Fin 3) :
    (state10 s x).locals (storeParameters i).inputs.ar=some (.uint64,some (.uint64 (storeWords x i).ar)) := by
  fin_cases i
  all_goals exact FftTripleArithmetic147.final_aR s x entry

theorem ai (s : State) (x : Inputs) (entry : Entry s x) (i : Fin 3) :
    (state10 s x).locals (storeParameters i).inputs.ai=some (.uint64,some (.uint64 (storeWords x i).ai)) := by
  fin_cases i
  all_goals exact FftTripleArithmetic147.final_aI s x entry

theorem br (s : State) (x : Inputs) (i : Fin 3) :
    (state10 s x).locals (storeParameters i).inputs.br=some (.uint64,some (.uint64 (storeWords x i).br)) := by
  fin_cases i
  · exact FftTripleArithmetic147.final_b0R s x
  · exact FftTripleArithmetic147.final_b1R s x
  · exact FftTripleArithmetic147.final_b2R s x

theorem bi (s : State) (x : Inputs) (i : Fin 3) :
    (state10 s x).locals (storeParameters i).inputs.bi=some (.uint64,some (.uint64 (storeWords x i).bi)) := by
  fin_cases i
  · exact FftTripleArithmetic147.final_b0I s x
  · exact FftTripleArithmetic147.final_b1I s x
  · exact FftTripleArithmetic147.final_b2I s x

end FT1536.Source3.FftTripleFinalCells147
