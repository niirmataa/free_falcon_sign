import Source3.StepAddBasic195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepAddOps195
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open SelectedStepLayout187 (fd gd fs gs gm igm t1)
open SelectedStepAddPrime195 (p1 p0i1 r21 rx1)
open StepCopyBody190 (addr elem)
open StepAddBasic195 (Basic marchWords)

theorem tables_scratch {s : State} (b : Basic s) (offset : Nat) :
    C99PointerFootprint.TablesOutside s 31 offset := by
  intro name p binding
  rw [b.tables] at binding
  have blocks := KeygenFullFacts127.table_blocks name p binding
  simp only [List.mem_cons,List.not_mem_nil,or_false] at blocks
  left
  omega

theorem forward_keep {s after : State} (b : Basic s)
    (call : KeygenLevelCalls.Call .forward s MakeFgAddPrimeShape194.forwardArgs after)
    (q : ArrayPointer) (block : q.block=31) (low : q.offset+4≤t1.offset)
    (w : BitVec 32) (read : Load32 s.heap q w) : Load32 after.heap q w := by
  have stable := StepNttForwardImage195.call_stable call
  apply Gate00Memory.load32_transport _ _ q w read stable.size
  intro byte
  apply KeygenLevelCalls.call_frame .forward s after MakeFgAddPrimeShape194.forwardArgs call
    ["t1".toList] q.block (q.offset+byte.val) (by decide)
  · intro name member pointer binding
    have same : name="t1".toList := List.mem_singleton.mp member
    subst name
    have equal := Option.some.inj (binding.symm.trans b.t1Binding)
    subst pointer
    right; left
    have hb:=byte.isLt
    omega
  · rw [block]
    exact tables_scratch b _

theorem walk_fs (s : State) (b : Basic s) (F : Fin 512 → BitVec 32)
    (loads : ∀ i : Fin 512, Load32 s.heap (elem fs i.val) (F i)) :
    ∃ out, KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.walkFs s ⟨out,.normal⟩ ∧
      Basic out ∧ StepNttImage195.Image out t1 (marchWords F) ∧
      (∀ q : ArrayPointer, (∀ i : Nat, i<512 → Separate (elem t1 i) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨out,run,fixed,image,vCell,xCell,locals,arrays,keep⟩ := StepWalkKeep195.walk_run
    s "fs".toList fs t1 512 F p1 p0i1 r21 rx1 (StepAddBasic195.fs_fixed s b F loads) b.vDeclared
  have walk : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.walkFs s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.walkFs_shape,StepWalkLoop195.walk_shape]
    exact run
  have outBasic : Basic out := StepAddBasic195.transport b walk (by decide) locals arrays
    ⟨some (.uint64 (C99NatWord141.word 512)),vCell⟩
  refine ⟨out,walk,outBasic,?_,keep⟩
  intro j bound
  have read := image ⟨j,bound⟩ bound
  rw [← StepAddBasic195.march_word F ⟨j,bound⟩] at read
  exact read

theorem walk_gs (s : State) (b : Basic s) (F : Fin 512 → BitVec 32)
    (loads : ∀ i : Fin 512, Load32 s.heap (elem gs i.val) (F i)) :
    ∃ out, KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.walkGs s ⟨out,.normal⟩ ∧
      Basic out ∧ StepNttImage195.Image out t1 (marchWords F) ∧
      (∀ q : ArrayPointer, (∀ i : Nat, i<512 → Separate (elem t1 i) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨out,run,fixed,image,vCell,xCell,locals,arrays,keep⟩ := StepWalkKeep195.walk_run
    s "gs".toList gs t1 512 F p1 p0i1 r21 rx1 (StepAddBasic195.gs_fixed s b F loads) b.vDeclared
  have walk : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.walkGs s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.walkGs_shape,StepWalkLoop195.walk_shape]
    exact run
  have outBasic : Basic out := StepAddBasic195.transport b walk (by decide) locals arrays
    ⟨some (.uint64 (C99NatWord141.word 512)),vCell⟩
  refine ⟨out,walk,outBasic,?_,keep⟩
  intro j bound
  have read := image ⟨j,bound⟩ bound
  rw [← StepAddBasic195.march_word F ⟨j,bound⟩] at read
  exact read

theorem fd_section (s : State) (b : Basic s) (W : Nat → BitVec 32)
    (image : StepNttImage195.Image s t1 W) (gvs : Fin 512 → BitVec 32)
    (gmLoads : ∀ i : Fin 512, Load32 s.heap (elem gm i.val) (gvs i)) :
    ∃ out, KeygenMakeFgSource.Exec (.seq MakeFgAddPrimeShape194.nttFs MakeFgAddPrimeShape194.productFd)
        s ⟨out,.normal⟩ ∧ Basic out ∧
      StepProductFixed191.Image out fd 1 2 256 p1 p0i1 r21 (StepAddForwardProduct195.words W gvs) 256 ∧
      StepNttImage195.Image out t1 (StepAddForwardProduct195.words W gvs) ∧
      (∀ q : ArrayPointer, q.block=31 → q.offset+4≤t1.offset →
        (∀ i : Nat, i<256 → Separate (addr fd 1 i 2) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨after,call,ntt,nextInput,locals,arrays⟩ := StepAddForwardProduct195.forward
    s W gvs (StepAddBasic195.product_input b W image) b.gmBinding gmLoads b.lognSlot b.terSlot
  obtain ⟨out,product,productImage,sourceImage,vCell,finalLocals,finalArrays,keep⟩ :=
    StepAddProductKeep195.fd_source after (StepAddForwardProduct195.words W gvs) nextInput
  have nttRun : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttFs s ⟨after,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.nttFs_shape]
    exact ntt
  have whole : KeygenMakeFgSource.Exec
      (.seq MakeFgAddPrimeShape194.nttFs MakeFgAddPrimeShape194.productFd) s ⟨out,.normal⟩ :=
    .seqNormal _ _ s after _ nttRun product
  have outBasic : Basic out := StepAddBasic195.transport b whole (by decide)
    (fun name different => (finalLocals name different).trans (congrFun locals name))
    (fun name different => (finalArrays name different).trans (congrFun arrays name))
    ⟨some (.uint64 (C99NatWord141.word 256)),vCell⟩
  refine ⟨out,whole,outBasic,productImage,sourceImage,?_⟩
  intro q block low separate w read
  exact keep q separate w (forward_keep b call q block low w read)

theorem gd_section (s : State) (b : Basic s) (W : Nat → BitVec 32)
    (image : StepNttImage195.Image s t1 W) (gvs : Fin 512 → BitVec 32)
    (gmLoads : ∀ i : Fin 512, Load32 s.heap (elem gm i.val) (gvs i)) :
    ∃ out, KeygenMakeFgSource.Exec (.seq MakeFgAddPrimeShape194.nttGs MakeFgAddPrimeShape194.productGd)
        s ⟨out,.normal⟩ ∧ Basic out ∧
      StepProductFixed191.Image out gd 1 2 256 p1 p0i1 r21 (StepAddForwardProduct195.words W gvs) 256 ∧
      StepNttImage195.Image out t1 (StepAddForwardProduct195.words W gvs) ∧
      (∀ q : ArrayPointer, q.block=31 → q.offset+4≤t1.offset →
        (∀ i : Nat, i<256 → Separate (addr gd 1 i 2) q) →
        ∀ w : BitVec 32, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨after,call,ntt,nextInput,locals,arrays⟩ := StepAddForwardProduct195.forward
    s W gvs (StepAddBasic195.product_input b W image) b.gmBinding gmLoads b.lognSlot b.terSlot
  obtain ⟨out,product,productImage,sourceImage,vCell,finalLocals,finalArrays,keep⟩ :=
    StepAddProductKeep195.gd_source after (StepAddForwardProduct195.words W gvs) nextInput
  have nttRun : KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.nttGs s ⟨after,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.nttGs_shape]
    exact ntt
  have whole : KeygenMakeFgSource.Exec
      (.seq MakeFgAddPrimeShape194.nttGs MakeFgAddPrimeShape194.productGd) s ⟨out,.normal⟩ :=
    .seqNormal _ _ s after _ nttRun product
  have outBasic : Basic out := StepAddBasic195.transport b whole (by decide)
    (fun name different => (finalLocals name different).trans (congrFun locals name))
    (fun name different => (finalArrays name different).trans (congrFun arrays name))
    ⟨some (.uint64 (C99NatWord141.word 256)),vCell⟩
  refine ⟨out,whole,outBasic,productImage,sourceImage,?_⟩
  intro q block low separate w read
  exact keep q separate w (forward_keep b call q block low w read)

end FT1536.Source3.StepAddOps195
