import Source3.NttTripleSquare184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTriplePass184
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open NttFirstFixed182 (Fixed)

theorem full (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (sep : NttMiddleTable183.Separate a gm) (reads : NttMiddleTable183.Reads s.heap gm)
    (logn : Slot s "logn" 10) (fc : Slot s "full" 1) (oldU oldR : Option C99IntegerReference.Value)
    (du : s.locals "u".toList=some (.uint64,oldU)) (dr : s.locals "r".toList=some (.uint64,oldR)) :
    ∃ out wNew, Exec KeygenNttForwardPrograms.triplePass s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i wNew ∧
      USlot out "u" 1536 ∧ USlot out "r" 1024 ∧ NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  obtain ⟨x,read⟩ := reads 1 (by decide)
  let ready := NttTripleSquare184.after s x p p0i
  let wNew := NttTripleSquare184.square x p p0i
  have squareRun := NttTripleSquare184.source s a gm p p0i w x fixed read
  obtain ⟨out,run,fo,uo,ro,frame⟩ := NttTripleLoop184.full ready a gm p p0i wNew
    (NttTripleSquare184.fixed s a gm p p0i w x fixed) sep reads logn oldU oldR du dr
  have inner : Exec KeygenNttForwardPrograms.tripleInner s ⟨out,.normal⟩ :=
    .seqNormal _ _ s ready _ squareRun (.seqNormal _ _ ready out _ run (.base .skip out out (.skip out)))
  have scopedRun : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.tripleInner) s ⟨out,.normal⟩ :=
    .scope [] _ s ⟨out,.normal⟩ inner
  have branch : Exec (.branch (KeygenNttForwardPrograms.var "full")
      (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.tripleInner) (.base .skip)) s ⟨out,.normal⟩ :=
    .branchTrue _ _ _ s ⟨out,.normal⟩ (.uint32 1) (.variable _ _ _ fc) (by decide) scopedRun
  exact ⟨out,wNew,.seqNormal _ _ s out _ branch (.base .skip out out (.skip out)),fo,uo,ro,frame⟩

end FT1536.Source3.NttTriplePass184
