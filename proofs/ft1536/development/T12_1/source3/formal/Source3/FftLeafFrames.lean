import Source3.FftLeafPrograms
import Source3.C99ArrayFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FftLeafFrames
open C99ArrayReference FftLeafPrograms

def destinations : List Name := ["a".toList]

theorem add_footprint : (source .add).map (fun p => C99ArrayFrame.only destinations p.body)=some true := by decide
theorem sub_footprint : (source .sub).map (fun p => C99ArrayFrame.only destinations p.body)=some true := by decide
theorem neg_footprint : (source .neg).map (fun p => C99ArrayFrame.only destinations p.body)=some true := by decide
theorem adj_footprint : (source .adj).map (fun p => C99ArrayFrame.only destinations p.body)=some true := by decide
theorem selfAdj_footprint : (source .selfAdj).map (fun p => C99ArrayFrame.only destinations p.body)=some true := by decide
theorem mulAuto_footprint : (source .mulAuto).map (fun p => C99ArrayFrame.only destinations p.body)=some true := by decide
theorem divAuto_footprint : (source .divAuto).map (fun p => C99ArrayFrame.only destinations p.body)=some true := by decide

theorem footprint (op : Operation) : (source op).map (fun p => C99ArrayFrame.only destinations p.body)=some true := by
  cases op
  · exact add_footprint
  · exact sub_footprint
  · exact neg_footprint
  · exact adj_footprint
  · exact selfAdj_footprint
  · exact mulAuto_footprint
  · exact divAuto_footprint

theorem parsed_body_frame (op : Operation) (code : C99ArrayParser.Parsed)
    (bound : source op=some code) (before after : State)
    (execution : C99ArrayReference.Exec program code.body before after) :
    after.arrays=before.arrays ∧
    ∀ block offset, C99ArrayFrame.Outside before destinations block offset →
      after.heap.bytes block offset=before.heap.bytes block offset := by
  have hc := footprint op
  rw [bound] at hc
  have hcheck : C99ArrayFrame.only destinations code.body=true := Option.some.inj hc
  exact C99ArrayFrame.body_frame program code.body before after execution destinations hcheck

end FT1536.Source3.FftLeafFrames
