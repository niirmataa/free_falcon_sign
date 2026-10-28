import Source3.CrtPrimePrefix214
import Source3.MkgmCallKeep203
import Source3.RxSection210
import Source3.FourthStepLayout216
import Source3.ThirdStepGenerator215

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The d=4 body row/invariant layer and its modp_mkgm3 generator call
   (Level 5 = logn 6, count 64). The PRIMES3 rows 0..5 word layer gives
   the executed table words and the words returned by the actual
   modp_ninv31 / modp_R2 / modp_Rx source bodies (Rx at this step is the
   slen = 6 instance). The generator executes the actual ter branch of
   the loop bodies at any loop index u whose row is v, with the exact
   gm/igm table reads and outside-read keeps. Values stay executed
   words: no transform, table, root or NTT law is claimed here. -/
namespace FT1536.Source3.FourthStepGenerator216
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Allocated Load32)
open KeygenMakeFgSource (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open KeygenStaticTables (values rows row)
open KeygenFullData127 (primes rev)
open FourthStepLayout216 (fd gd fs gs gm igm t1)
open MkgmParams198 (Level count lognWord)
open KeygenSmallOutput (element)
open CrtPrimePrefix214 (pVal sVal iVal rVal)

/- Executed words of the u-th PRIMES3 row v beyond the p/s pair: the g
   table word and the Rx correction word at this step's slen = 6. -/
def gVal (v : Nat×Nat×Nat) : BitVec 32 := BitVec.ofNat 32 (KeygenStaticTables.fieldValue v .g)
def rxVal (v : Nat×Nat×Nat) : BitVec 32 := RxModel210.resultWord 6 (pVal v) (iVal v) (rVal v)

/- The six PRIMES3 rows used by the d=4 first-prime loop, indexed 0..5. -/
theorem row0 : ((rows .ternary)[0]?).bind row=some (2147355649,1907584673,127999) :=
  KeygenStaticReads.first_source .ternary
theorem row0_value : (values .ternary)[0]?=some (2147355649,1907584673,127999) :=
  KeygenStaticReads.first_value .ternary
theorem row1 : ((rows .ternary)[1]?).bind row=some (2147346433,1119654270,238827065) := by decide +kernel
theorem row1_value : (values .ternary)[1]?=some (2147346433,1119654270,238827065) :=
  (KeygenStaticReads.indexed_source .ternary 1).symm.trans row1
theorem row2 : ((rows .ternary)[2]?).bind row=some (2147309569,686923925,434763914) := by decide +kernel
theorem row2_value : (values .ternary)[2]?=some (2147309569,686923925,434763914) :=
  (KeygenStaticReads.indexed_source .ternary 2).symm.trans row2
theorem row3 : ((rows .ternary)[3]?).bind row=some (2147281921,658779219,742235228) := by decide +kernel
theorem row3_value : (values .ternary)[3]?=some (2147281921,658779219,742235228) :=
  (KeygenStaticReads.indexed_source .ternary 3).symm.trans row3
theorem row4 : ((rows .ternary)[4]?).bind row=some (2147235841,1567830083,1964117354) := by decide +kernel
theorem row4_value : (values .ternary)[4]?=some (2147235841,1567830083,1964117354) :=
  (KeygenStaticReads.indexed_source .ternary 4).symm.trans row4
theorem row5 : ((rows .ternary)[5]?).bind row=some (2147217409,273379403,890663385) := by decide +kernel
theorem row5_value : (values .ternary)[5]?=some (2147217409,273379403,890663385) :=
  (KeygenStaticReads.indexed_source .ternary 5).symm.trans row5

/- The d=4 loop state outside the per-iteration scope: n = 64,
   hn = 32, slen = 6, tlen = 12, logn = 6, ter/in_ntt/out_ntt = 1 and the
   seven pointer binds of the d=4 layout. -/
structure Outer (s : State) (u : Nat) : Prop where
  nCell : USlot s "n" 64
  hnCell : USlot s "hn" 32
  slenCell : USlot s "slen" 6
  tlenCell : USlot s "tlen" 12
  uCell : USlot s "u" u
  lognCell : Slot s "logn" 6
  terCell : Slot s "ter" 1
  inCell : s.locals "in_ntt".toList=some (.int32,some (.int32 1))
  outCell : s.locals "out_ntt".toList=some (.int32,some (.int32 1))
  fdBinding : s.arrays "fd".toList=some fd
  gdBinding : s.arrays "gd".toList=some gd
  fsBinding : s.arrays "fs".toList=some fs
  gsBinding : s.arrays "gs".toList=some gs
  gmBinding : s.arrays "gm".toList=some gm
  igmBinding : s.arrays "igm".toList=some igm
  t1Binding : s.arrays "t1".toList=some t1
  primesBinding : s.arrays "primes".toList=some primes
  writable : s.heap.writable 31=true
  allocated : ∀ index<71680, Allocated s.heap (⟨31,0,71680,4,index⟩ : ArrayPointer)

/- The d=4 per-iteration state: Outer plus the executed p/p0i/R2 words
   of the current PRIMES3 row. -/
structure Basic (s : State) (u : Nat) (p p0i r2 : BitVec 32) : Prop where
  nCell : USlot s "n" 64
  hnCell : USlot s "hn" 32
  slenCell : USlot s "slen" 6
  tlenCell : USlot s "tlen" 12
  uCell : USlot s "u" u
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  r2Cell : Slot s "R2" r2
  lognCell : Slot s "logn" 6
  terCell : Slot s "ter" 1
  inCell : s.locals "in_ntt".toList=some (.int32,some (.int32 1))
  outCell : s.locals "out_ntt".toList=some (.int32,some (.int32 1))
  fdBinding : s.arrays "fd".toList=some fd
  gdBinding : s.arrays "gd".toList=some gd
  fsBinding : s.arrays "fs".toList=some fs
  gsBinding : s.arrays "gs".toList=some gs
  gmBinding : s.arrays "gm".toList=some gm
  igmBinding : s.arrays "igm".toList=some igm
  t1Binding : s.arrays "t1".toList=some t1
  primesBinding : s.arrays "primes".toList=some primes
  writable : s.heap.writable 31=true
  allocated : ∀ index<71680, Allocated s.heap (⟨31,0,71680,4,index⟩ : ArrayPointer)

theorem outer {s : State} {u : Nat} {p p0i r2 : BitVec 32} (h : Basic s u p p0i r2) : Outer s u :=
  ⟨h.nCell,h.hnCell,h.slenCell,h.tlenCell,h.uCell,h.lognCell,h.terCell,h.inCell,h.outCell,
    h.fdBinding,h.gdBinding,h.fsBinding,h.gsBinding,h.gmBinding,h.igmBinding,h.t1Binding,
    h.primesBinding,h.writable,h.allocated⟩

theorem basic_of {s : State} {u : Nat} {p p0i r2 : BitVec 32} (o : Outer s u)
    (pc : Slot s "p" p) (ic : Slot s "p0i" p0i) (rc : Slot s "R2" r2) : Basic s u p p0i r2 :=
  ⟨o.nCell,o.hnCell,o.slenCell,o.tlenCell,o.uCell,pc,ic,rc,o.lognCell,o.terCell,o.inCell,o.outCell,
    o.fdBinding,o.gdBinding,o.fsBinding,o.gsBinding,o.gmBinding,o.igmBinding,o.t1Binding,
    o.primesBinding,o.writable,o.allocated⟩

theorem transport {s out : State} {code : KeygenMakeFgSource.Stmt} {u : Nat} {p p0i r2 : BitVec 32}
    (h : Basic s u p p0i r2) (run : Exec code s ⟨out,.normal⟩)
    (locals : ∀ name : Name, name≠"v".toList → out.locals name=s.locals name)
    (arrays : ∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) : Basic out u p p0i r2 := by
  have stable:=KeygenHelperStability.make _ _ _ run
  have size : out.heap.size=s.heap.size := stable.size
  have writable : out.heap.writable=s.heap.writable := stable.writable
  refine ⟨(locals _ (by decide)).trans h.nCell,(locals _ (by decide)).trans h.hnCell,
    (locals _ (by decide)).trans h.slenCell,(locals _ (by decide)).trans h.tlenCell,
    (locals _ (by decide)).trans h.uCell,(locals _ (by decide)).trans h.pCell,
    (locals _ (by decide)).trans h.iCell,(locals _ (by decide)).trans h.r2Cell,
    (locals _ (by decide)).trans h.lognCell,(locals _ (by decide)).trans h.terCell,
    (locals _ (by decide)).trans h.inCell,(locals _ (by decide)).trans h.outCell,
    (arrays _ (by decide)).trans h.fdBinding,(arrays _ (by decide)).trans h.gdBinding,
    (arrays _ (by decide)).trans h.fsBinding,(arrays _ (by decide)).trans h.gsBinding,
    (arrays _ (by decide)).trans h.gmBinding,(arrays _ (by decide)).trans h.igmBinding,
    (arrays _ (by decide)).trans h.t1Binding,(arrays _ (by decide)).trans h.primesBinding,?_,?_⟩
  · rw [writable]; exact h.writable
  · intro index bound; simpa only [Allocated,size] using h.allocated index bound

theorem transport_full {s out : State} {code : KeygenMakeFgSource.Stmt} {u : Nat} {p p0i r2 : BitVec 32}
    (h : Basic s u p p0i r2) (run : Exec code s ⟨out,.normal⟩)
    (locals : out.locals=s.locals) (arrays : out.arrays=s.arrays) : Basic out u p p0i r2 :=
  transport h run (fun name _ => congrFun locals name) (fun name _ => congrFun arrays name)

/- The g word read of the current row through the actual PrimeObject at
   the loop index u, for any state with the same row domain. -/
theorem g_read (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : CrtPrimePrefix214.Input s u v) :
    KeygenLevelCalls.PrimeRead s "primes".toList (FirstStepEntry187.var "u") .g (.uint32 (gVal v)) :=
  CrtPrimePrefix214.primeRead s u v input .g s input.primesBinding input.uCell rfl

theorem generator_input (s : State) (u : Nat) (v : Nat×Nat×Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (input : CrtPrimePrefix214.Input s u v)
    (revBinding : s.tables "REV10".toList=some rev)
    (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev) :
    MkgmCall200.Input 5 s gm igm rev (gVal v) p p0i :=
  ⟨h.pCell,h.iCell,by exact h.lognCell,g_read s u v input,h.gmBinding,h.igmBinding,revBinding,revSource,
    rfl,rfl,
    fun j bound => h.allocated (2206+j) (by change j<64 at bound; omega),
    fun j bound => h.allocated (2270+j) (by change j<64 at bound; omega),
    h.writable,h.writable⟩

/- The actual modp_mkgm3 generator branch of any d=4 loop body at loop
   index u and row v: exact gm/igm reads (count 5 = 64 words each) and
   outside-read keeps; all caller cells/bindings survive. -/
theorem generator (s : State) (u : Nat) (v : Nat×Nat×Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (input : CrtPrimePrefix214.Input s u v)
    (revBinding : s.tables "REV10".toList=some rev)
    (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev) :
    ∃ (out : State) (gvs ivs : Fin 64 → BitVec 32),
      Exec StepPrimeShape188.generateBranch s ⟨out,.normal⟩ ∧
      Basic out u p p0i r2 ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ i : Fin 64, Load32 out.heap (element gm i.val) (gvs i)) ∧
      (∀ i : Fin 64, Load32 out.heap (element igm i.val) (ivs i)) ∧
      (∀ q : ArrayPointer, MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨out,run,locals,arrays,reads,keeps⟩ := MkgmCallKeep203.branch_source 5 s gm igm rev
    (gVal v) p p0i (generator_input s u v p p0i r2 h input revBinding revSource) h.terCell
  have gRead (i : Fin 64) : ∃ w, Load32 out.heap (element gm i.val) w := (reads i.val i.isLt).1
  have iRead (i : Fin 64) : ∃ w, Load32 out.heap (element igm i.val) w := (reads i.val i.isLt).2
  refine ⟨out,(fun i => Classical.choose (gRead i)),(fun i => Classical.choose (iRead i)),run,
    transport_full h run locals arrays,locals,arrays,
    (fun i => Classical.choose_spec (gRead i)),(fun i => Classical.choose_spec (iRead i)),keeps⟩

/- The same generator for the additional-prime loop body, whose parsed
   branch is the separately named MakeFgAddPrimeShape194 statement. -/
theorem generator_args : MakeFgAddPrimeShape194.generateArgs=StepPrimeShape188.args := by decide

theorem generator_call : MakeFgAddPrimeShape194.generateCall=StepPrimeShape188.generate := by decide

theorem generatorT (s : State) (u : Nat) (v : Nat×Nat×Nat) (p p0i r2 : BitVec 32)
    (h : Basic s u p p0i r2) (input : CrtPrimePrefix214.Input s u v)
    (revBinding : s.tables "REV10".toList=some rev)
    (revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev) :
    ∃ (out : State) (gvs ivs : Fin 64 → BitVec 32),
      Exec MakeFgAddPrimeShape194.generateBranchT s ⟨out,.normal⟩ ∧
      Basic out u p p0i r2 ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ i : Fin 64, Load32 out.heap (element gm i.val) (gvs i)) ∧
      (∀ i : Fin 64, Load32 out.heap (element igm i.val) (ivs i)) ∧
      (∀ q : ArrayPointer, MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
        ∀ w, Load32 s.heap q w → Load32 out.heap q w) := by
  obtain ⟨out,run,locals,arrays,reads,keeps⟩ := MkgmCallKeep203.source 5 s gm igm rev
    (gVal v) p p0i (generator_input s u v p p0i r2 h input revBinding revSource)
  have call : Exec MakeFgAddPrimeShape194.generateCall s ⟨out,.normal⟩ := by
    rw [generator_call]
    exact run
  have body : Exec (.scope [] [] (.seq MakeFgAddPrimeShape194.generateCall KeygenMakeFgSource.skip))
      s ⟨out,.normal⟩ :=
    MakeFgScope187.source _ s out
      (.seqNormal _ _ s out _ call (MakeFgDeclarations176.array_source .skip out out (.skip out)))
  have gRead (i : Fin 64) : ∃ w, Load32 out.heap (element gm i.val) w := (reads i.val i.isLt).1
  have iRead (i : Fin 64) : ∃ w, Load32 out.heap (element igm i.val) w := (reads i.val i.isLt).2
  refine ⟨out,(fun i => Classical.choose (gRead i)),(fun i => Classical.choose (iRead i)),?_,
    transport_full h run locals arrays,locals,arrays,
    (fun i => Classical.choose_spec (gRead i)),(fun i => Classical.choose_spec (iRead i)),keeps⟩
  exact .branchTrue _ _ _ s _ (.uint32 1) (.variable _ _ _ h.terCell) (by decide) body

end FT1536.Source3.FourthStepGenerator216
