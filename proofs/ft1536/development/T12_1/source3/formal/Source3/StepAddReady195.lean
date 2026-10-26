import Source3.StepAddGenerator195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepAddReady195
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open SelectedStepLayout187 (fd gd fs gs gm igm t1)
open KeygenFullData127 (primes rev)
open SelectedStepAddPrime195 (p1 p0i1 r21 rx1)
open StepAddBasic195 (Basic)
open StepCopyBody190 (elem)

structure Entry (s : State) (F G : Fin 512 → BitVec 32) : Prop where
  tables : s.tables=(C99CompactState115.reference KeygenFullData127.base).tables
  outside : C99ArrayFrame.Outside s KeygenMakeFgSource.writable 0 0
  writable : s.heap.writable 31=true
  allocated : ∀ i : Nat, i<71680 → Allocated s.heap {KeygenFullData127.env.ctx.scratch with index:=i}
  prime : KeygenStaticTables.PrimeObject s.heap primes .ternary
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  rawInit : GeneratorSquareDomains181.From s.heap gm igm 0
  fLoads : ∀ i : Fin 512, Load32 s.heap (elem fs i.val) (F i)
  gLoads : ∀ i : Fin 512, Load32 s.heap (elem gs i.val) (G i)
  nCell : Cell s "n".toList 512
  hnCell : Cell s "hn".toList 256
  slenCell : Cell s "slen".toList 1
  tlenCell : Cell s "tlen".toList 2
  uCell : Cell s "u".toList 1
  lognSlot : Slot s "logn" 9
  terSlot : Slot s "ter" 1
  outCell : s.locals "out_ntt".toList=some (.int32,some (.int32 1))
  fdBinding : s.arrays "fd".toList=some fd
  gdBinding : s.arrays "gd".toList=some gd
  fsBinding : s.arrays "fs".toList=some fs
  gsBinding : s.arrays "gs".toList=some gs
  gmBinding : s.arrays "gm".toList=some gm
  igmBinding : s.arrays "igm".toList=some igm
  t1Binding : s.arrays "t1".toList=some t1
  primesBinding : s.arrays "primes".toList=some primes

def prefixState (s : State) : State := SelectedStepAddPrime195.after (SelectedStepAddPrime195.u1 s)

theorem prime_locals (s : State) (name : Name)
    (absent : name∉["p".toList,"p0i".toList,"R2".toList,"Rx".toList,"v".toList]) :
    (SelectedStepAddPrime195.after s).locals name=s.locals name := by
  have hp : name≠"p".toList := by intro h; subst name; simp at absent
  have hp0i : name≠"p0i".toList := by intro h; subst name; simp at absent
  have hR2 : name≠"R2".toList := by intro h; subst name; simp at absent
  have hRx : name≠"Rx".toList := by intro h; subst name; simp at absent
  have hv : name≠"v".toList := by intro h; subst name; simp at absent
  change (C99ArrayReference.bindValue (SelectedStepAddPrime195.withR s) "Rx".toList .uint32
    (.uint32 rx1)).locals name=s.locals name
  rw [SelectedStepAddPrime195.locals_keep _ _ _ _ name hRx]
  change (C99ArrayReference.bindValue (SelectedStepAddPrime195.withI s) "R2".toList .uint32
    (.uint32 r21)).locals name=s.locals name
  rw [SelectedStepAddPrime195.locals_keep _ _ _ _ name hR2]
  change (C99ArrayReference.bindValue (SelectedStepAddPrime195.withP s) "p0i".toList .uint32
    (.uint32 p0i1)).locals name=s.locals name
  rw [SelectedStepAddPrime195.locals_keep _ _ _ _ name hp0i]
  change (C99ArrayReference.bindValue (SelectedStepAddPrime195.withX s) "p".toList .uint32
    (.uint32 p1)).locals name=s.locals name
  rw [SelectedStepAddPrime195.locals_keep _ _ _ _ name hp]
  change (SelectedStepAddPrime195.withV s).locals name=s.locals name
  rw [SelectedStepAddPrime195.withV,SelectedStepAddPrime195.effect_locals .u64 ["v".toList] _ name
    (by simpa only [List.mem_singleton] using hv)]
  exact SelectedStepAddPrime195.effect_locals .u32
    ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s name (by
      simp only [List.mem_cons,List.not_mem_nil,or_false,not_or]
      exact ⟨hp,hp0i,hR2,hRx⟩)


theorem prefix_locals (s : State) (name : Name)
    (absent : name∉["p".toList,"p0i".toList,"R2".toList,"Rx".toList,"v".toList])
    (different : name≠"u".toList) : (prefixState s).locals name=s.locals name :=
  (prime_locals _ name absent).trans
    (SelectedStepAddPrime195.locals_keep s "u".toList .uint64 (.uint64 (C99NatWord141.word 1)) name different)

theorem prefix_arrays (s : State) (name : Name) (different : name≠"x".toList) :
    (prefixState s).arrays name=s.arrays name := by
  change (SelectedStepAddPrime195.withX (SelectedStepAddPrime195.u1 s)).arrays name=s.arrays name
  rw [SelectedStepAddPrime195.withX,SelectedStepAddPrime195.clear_arrays _ "x".toList name different]
  rfl


theorem prefix_heap (s : State) : (prefixState s).heap=s.heap :=
  (SelectedStepAddPrime195.after_heap _).trans (SelectedStepAddPrime195.u1_heap s)

theorem prefix_tables (s : State) : (prefixState s).tables=s.tables := rfl

theorem prefix_v (s : State) : (prefixState s).locals "v".toList=some (.uint64,none) := by
  simp [prefixState,SelectedStepAddPrime195.after,SelectedStepAddPrime195.withR,SelectedStepAddPrime195.withI,
    SelectedStepAddPrime195.withP,SelectedStepAddPrime195.withX,SelectedStepAddPrime195.withV,
    C99DeclarationStatements.effect,C99DeclarationCells.declareCells,C99ValueBridge.type,DeepestDeclarations175.clear,
    C99ArrayReference.bindValue,C99ScalarReference.set]

theorem entry_runs (s : State) (F G : Fin 512 → BitVec 32) (e : Entry s F G) :
    KeygenMakeFgSource.Exec MakeFgAddPrimeShape194.initU s ⟨SelectedStepAddPrime195.u1 s,.normal⟩ ∧
    KeygenMakeFgSource.Exec
      (MakeFgSequence187.append MakeFgAddPrimeShape194.prefixSteps KeygenMakeFgSource.skip)
      (SelectedStepAddPrime195.u1 s) ⟨prefixState s,.normal⟩ := by
  have h := SelectedStepAddPrime195.body_entry s (some (.uint64 (C99NatWord141.word 1)))
    e.uCell e.slenCell e.tlenCell e.primesBinding (SelectedStepAddPrime195.object_word s e.prime)
  exact ⟨h.1,h.2.2.1⟩

theorem basic (s : State) (F G : Fin 512 → BitVec 32) (e : Entry s F G) : Basic (prefixState s) := by
  obtain ⟨initRun,prefixRun⟩ := entry_runs s F G e
  have initFrame := KeygenMakeFgSource.frame _ _ _ initRun KeygenMakeFgSource.writable
    (by decide) 0 0 e.outside (StepAddEntry195.tables_zero s e.tables)
  have frame := KeygenMakeFgSource.frame _ _ _ prefixRun KeygenMakeFgSource.writable
    (by decide) 0 0 initFrame.1 (StepAddEntry195.tables_zero _ (initFrame.2.1.trans e.tables))
  refine ⟨(prefix_tables s).trans e.tables,frame.1,?_,?_,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_,⟨none,prefix_v s⟩,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ,?_ ⟩
  · rw [prefix_heap]; exact e.writable
  · intro i bound; rw [prefix_heap]; exact e.allocated i bound
  · exact (prefix_locals s "n".toList (by decide) (by decide)).trans e.nCell
  · exact (prefix_locals s "hn".toList (by decide) (by decide)).trans e.hnCell
  · exact (prefix_locals s "slen".toList (by decide) (by decide)).trans e.slenCell
  · exact (prefix_locals s "tlen".toList (by decide) (by decide)).trans e.tlenCell
  · exact (prime_locals _ "u".toList (by decide)).trans (SelectedStepAddPrime195.u1_cell s)
  · exact SelectedStepAddPrime195.p_cell _
  · exact SelectedStepAddPrime195.i_cell _
  · exact SelectedStepAddPrime195.r2_cell _
  · exact SelectedStepAddPrime195.rx_cell _
  · exact (prefix_locals s "logn".toList (by decide) (by decide)).trans e.lognSlot
  · exact (prefix_locals s "ter".toList (by decide) (by decide)).trans e.terSlot
  · exact (prefix_locals s "out_ntt".toList (by decide) (by decide)).trans e.outCell
  · exact (prefix_arrays s "fd".toList (by decide)).trans e.fdBinding
  · exact (prefix_arrays s "gd".toList (by decide)).trans e.gdBinding
  · exact (prefix_arrays s "fs".toList (by decide)).trans e.fsBinding
  · exact (prefix_arrays s "gs".toList (by decide)).trans e.gsBinding
  · exact (prefix_arrays s "gm".toList (by decide)).trans e.gmBinding
  · exact (prefix_arrays s "igm".toList (by decide)).trans e.igmBinding
  · exact (prefix_arrays s "t1".toList (by decide)).trans e.t1Binding
  · exact (prefix_arrays s "primes".toList (by decide)).trans e.primesBinding

theorem generator_input (s : State) (F G : Fin 512 → BitVec 32) (e : Entry s F G) :
    StepU1Entry195.Input (prefixState s) := by
  have b := basic s F G e
  refine ⟨b.pSlot,b.p0iSlot,b.lognSlot,b.uCell,b.terSlot,b.gmBinding,b.igmBinding,b.primesBinding,
    ?_,?_,?_,b.allocated,b.writable,?_⟩
  · rw [b.tables]; rfl
  · rw [prefix_heap]
    exact StepU1Entry195.g_object_word s e.prime
  · rw [prefix_heap]; exact e.revSource
  · rw [prefix_heap]; exact e.rawInit

end FT1536.Source3.StepAddReady195
