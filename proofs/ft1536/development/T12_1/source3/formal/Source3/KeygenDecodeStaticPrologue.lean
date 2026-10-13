import Source3.KeygenDecodeStaticPrologueProfile

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Every actual function-prologue declaration and assignment, deriving all
   reader seams from the real parameters instead of assuming loop readiness. -/
namespace FT1536.Source3.KeygenDecodeStaticPrologue
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticPrologueProfile

def pieces : List Stmt := [KeygenDecodeStaticBinding.node000,KeygenDecodeStaticBinding.node001,
  KeygenDecodeStaticBinding.node002,KeygenDecodeStaticBinding.node003,KeygenDecodeStaticBinding.node016,
  KeygenDecodeStaticBinding.node017,KeygenDecodeStaticBinding.node018,KeygenDecodeStaticBinding.node019,
  KeygenDecodeStaticBinding.node020,KeygenDecodeStaticBinding.node021,KeygenDecodeStaticBinding.node022]
def code : Stmt := KeygenDecodeStaticSequence.chain pieces .skip

theorem source_partition : KeygenDecodeStaticBinding.node124=
    KeygenDecodeStaticSequence.chain pieces KeygenDecodeStaticBinding.node113 := rfl

def freshBuf (s : State) : State := ⟨s.heap,s.locals,none⟩
def freshNUV (s : State) : State := ⟨s.heap,
  localSet (localSet (localSet s.locals "n".toList .uint64 none) "u".toList .uint64 none) "v".toList .uint64 none,s.buf⟩
def freshDBMask (s : State) : State := ⟨s.heap,
  localSet (localSet s.locals "db".toList .uint32 none) "mask".toList .uint32 none,s.buf⟩
def freshLenJ (s : State) : State := ⟨s.heap,
  localSet (localSet s.locals "db_len".toList .uint32 none) "j".toList .uint32 none,s.buf⟩
def boundBuf (args : Args) (s : State) : State := {s with buf := some args.data}

theorem zero32 (args : Args) (s : State) (name : String)
    (notBuf : name.toList≠"buf".toList) (notData : name.toList≠"data".toList)
    (cell : s.locals.scalars name.toList=some (.uint32,none)) :
    Checked args (.write (.variable name.toList) .set (.number .i32 0)) s (set32 s name 0) .normal := by
  have source := assign args s name.toList .uint32 none (.number .i32 0) (.int32 0) s.locals notBuf notData cell
    (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
  have cast : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.int32 0).integer=.uint32 0 := by decide +kernel
  simpa only [cast,set32] using source

theorem zero64 (args : Args) (s : State) (name : String)
    (notBuf : name.toList≠"buf".toList) (notData : name.toList≠"data".toList)
    (cell : s.locals.scalars name.toList=some (.uint64,none)) :
    Checked args (.write (.variable name.toList) .set (.number .i32 0)) s (set64 s name 0) .normal := by
  have source := assign args s name.toList .uint64 none (.number .i32 0) (.int32 0) s.locals notBuf notData cell
    (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
  have cast : C99IntegerReference.convert .uint64 (C99IntegerReference.Value.int32 0).integer=.uint64 0 := by decide +kernel
  simpa only [cast,set64] using source

theorem complete (args : Args) (before : Memory) (src dst : ArrayPointer)
    (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst) :
    ∃ after, Checked args code (initial args before) after .normal ∧
      Ready args src dst 0 0 0 after ∧ Cell "u" .uint64 (.uint64 0) after.locals ∧ after.heap=before := by
  let s0 := initial args before
  let s1 := freshBuf s0
  let s2 := freshNUV s1
  let s3 := freshDBMask s2
  let s4 := freshLenJ s3
  let s5 := profiled s4
  let s6 := set32 s5 "mask" 255
  let s7 := boundBuf args s6
  let s8 := set64 s7 "u" 0
  let s9 := set64 s8 "v" 0
  let s10 := set32 s9 "db" 0
  let s11 := set32 s10 "db_len" 0
  have d0 : Checked args KeygenDecodeStaticBinding.node000 s0 s1 .normal :=
    KeygenDecodeStaticCertified.declare args s0 [⟨"buf".toList,.pointer (.readonly .byte),none⟩] s0.locals rfl
  have d1 : Checked args KeygenDecodeStaticBinding.node001 s1 s2 .normal :=
    KeygenDecodeStaticCertified.declare args s1 [⟨"n".toList,.size,none⟩,⟨"u".toList,.size,none⟩,⟨"v".toList,.size,none⟩] s2.locals rfl
  have d2 : Checked args KeygenDecodeStaticBinding.node002 s2 s3 .normal :=
    KeygenDecodeStaticCertified.declare args s2 [⟨"db".toList,.u32,none⟩,⟨"mask".toList,.u32,none⟩] s3.locals rfl
  have d3 : Checked args KeygenDecodeStaticBinding.node003 s3 s4 .normal :=
    KeygenDecodeStaticCertified.declare args s3 [⟨"db_len".toList,.u32,none⟩,⟨"j".toList,.u32,none⟩] s4.locals rfl
  have q4 : Cell "q" .uint32 (.uint32 18433) s4.locals := by
    change some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.Value.uint32 args.q))=
      some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.Value.uint32 18433))
    rw [qM0]
  have logn4 : Cell "logn" .uint32 (.uint32 10) s4.locals := by
    change some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.Value.uint32 args.logn))=
      some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.Value.uint32 10))
    rw [lognM0]
  have profile : Checked args KeygenDecodeStaticBinding.node016 s4 s5 .normal :=
    q_branch args s4 q4 logn4 rfl rfl
  have j5 : Cell "j" .uint32 (.uint32 8) s5.locals := by rfl
  have mask : Checked args KeygenDecodeStaticBinding.node017 s5 s6 .normal := by
    have source := assign args s5 "mask".toList .uint32 none KeygenDecodeStaticPrologueCalculations.maskRhs (.uint32 255) s5.locals
      (by decide +kernel) (by decide +kernel) rfl
      (.pure _ _ _ (KeygenDecodeStaticPrologueCalculations.mask_calculation args s5 j5))
    simpa only [KeygenDecodeWordOps.self32,KeygenDecodeStaticPrologueCalculations.source_mask,set32,s6] using source
  have bound : Checked args KeygenDecodeStaticBinding.node018 s6 s7 .normal := KeygenDecodeStaticCertified.bind args s6
  have u0 : Checked args KeygenDecodeStaticBinding.node019 s7 s8 .normal :=
    zero64 args s7 "u" (by decide +kernel) (by decide +kernel) rfl
  have v0 : Checked args KeygenDecodeStaticBinding.node020 s8 s9 .normal :=
    zero64 args s8 "v" (by decide +kernel) (by decide +kernel) rfl
  have db0 : Checked args KeygenDecodeStaticBinding.node021 s9 s10 .normal :=
    zero32 args s9 "db" (by decide +kernel) (by decide +kernel) rfl
  have p0 : Checked args KeygenDecodeStaticBinding.node022 s10 s11 .normal :=
    zero32 args s10 "db_len" (by decide +kernel) (by decide +kernel) rfl
  have full : Checked args code s0 s11 .normal :=
    seq args _ _ s0 s1 s11 .normal d0 (seq args _ _ s1 s2 s11 .normal d1
      (seq args _ _ s2 s3 s11 .normal d2 (seq args _ _ s3 s4 s11 .normal d3
        (seq args _ _ s4 s5 s11 .normal profile (seq args _ _ s5 s6 s11 .normal mask
          (seq args _ _ s6 s7 s11 .normal bound (seq args _ _ s7 s8 s11 .normal u0
            (seq args _ _ s8 s9 s11 .normal v0 (seq args _ _ s9 s10 s11 .normal db0
              (seq args _ _ s10 s11 s11 .normal p0 (skip args s11)))))))))))
  have ready : Ready args src dst 0 0 0 s11 := by
    refine ⟨⟨by rfl,by rfl,by rfl,by rfl,?_,?_⟩,by rfl,by rfl,by rfl⟩
    · change some args.data=some (some src)
      rw [data]
    · change args.x=some dst
      exact destination
  exact ⟨s11,full,ready,by rfl,rfl⟩

end FT1536.Source3.KeygenDecodeStaticPrologue
