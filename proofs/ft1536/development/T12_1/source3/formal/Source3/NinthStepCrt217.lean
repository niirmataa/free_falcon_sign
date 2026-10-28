import Source3.NinthStepCrtBody217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The make_fg part3 pair: the two original zint_rebuild_CRT call
   statements over fs and gs at the d=2 instance (xlen = xstride = 166
   from the slen cell, num = 2 from the n cell, tmp = gm), executed
   through the actual call frames (Bind of the seven parameters into
   the fresh callee scope) and the NinthStepCrtBody217 body engine.
   The pair consumes the moved/iNTTized fs/gs rows of the first loop
   and produces the exact words166 reassembled row images; only the fs/gs
   words and the first166 gm scratch words are written. No CRT or
   centering law is claimed. -/
namespace FT1536.Source3.NinthStepCrt217
open C99ArrayReference (State Name Bind Pointer bindPointer bindValue)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open C99NatWord141 (word)
open KeygenFullData127 (primes rev)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open KeygenMakeFgSource (Exec)
open ZintNormWalkFlat208 (Data)
open NinthStepLayout217 (fd gd fs gs gm igm t1)
open SecondStepGeometry203 (scratch ordered)
open NinthStepCrtBody217 (words166)

/- Word-granular separation inside the d=2 scratch block. -/
theorem sep_at {a b : Nat} (h : a≠b) : Separate (scratch a) (scratch b) := by
  by_cases lt : a<b
  · exact ordered a b lt
  · exact CrtRound214.sep_symm (ordered b a (by omega))

theorem fs_word (i : Nat) : elem fs i = scratch (1340+i) := rfl
theorem gs_word (i : Nat) : elem gs i = scratch (1672+i) := rfl
theorem gm_word (j : Nat) : elem gm j = scratch (2004+j) := rfl

theorem fs_gm {i j : Nat} (ib : i < 332) (jb : j ≤ 166) : Separate (elem fs i) (elem gm j) := by
  rw [fs_word,gm_word]; exact sep_at (by omega)

theorem gs_gm {i j : Nat} (ib : i < 332) (jb : j ≤ 166) : Separate (elem gs i) (elem gm j) := by
  rw [gs_word,gm_word]; exact sep_at (by omega)

theorem fs_gs {i k : Nat} (ib : i < 332) (kb : k < 332) : Separate (elem fs i) (elem gs k) := by
  rw [fs_word,gs_word]; exact sep_at (by omega)

/- The fresh-scope call frame of one rebuild call, mirroring the
   original seven-argument zint_rebuild_CRT Bind at the d=2 words. -/
def withTmp (s : State) (tmp : ArrayPointer) := bindPointer (CrtAddMulCall205.fresh s) "tmp".toList tmp
def withSign (s : State) (tmp : ArrayPointer) := bindValue (withTmp s tmp) "normalize_signed".toList .int32 (.int32 1)
def withPrimes (s : State) (tmp : ArrayPointer) := bindPointer (withSign s tmp) "primes".toList primes
def withNum (s : State) (tmp : ArrayPointer) := set64 (withPrimes s tmp) "num" (word 2)
def withStride (s : State) (tmp : ArrayPointer) := set64 (withNum s tmp) "xstride" (word 166)
def withLen (s : State) (tmp : ArrayPointer) := set64 (withStride s tmp) "xlen" (word 166)
def entry (s : State) (root tmp : ArrayPointer) := bindPointer (withLen s tmp) "xx".toList root

structure Domain (s : State) (root tmp : ArrayPointer) : Prop where
  object : KeygenStaticTables.PrimeObject s.heap primes .ternary
  width : root.elementBytes=4
  capacity : root.index+332 ≤ root.count
  writable : s.heap.writable root.block=true
  tmpAllocated : Allocated s.heap tmp
  tmpWidth : tmp.elementBytes=4
  tmpCapacity : tmp.index+167 ≤ tmp.count
  tmpWritable : s.heap.writable tmp.block=true
  apart : ∀ i j, i < 332 → j ≤ 166 → Separate (elem root i) (elem tmp j)

theorem input (s : State) (root tmp : ArrayPointer) (domain : Domain s root tmp) :
    NinthStepCrtBody217.CrtInput (entry s root tmp) root tmp := by
  refine ⟨rfl,rfl,rfl,rfl,rfl,rfl,rfl,domain.object,domain.width,domain.capacity,domain.writable,
    domain.tmpAllocated,domain.tmpWidth,domain.tmpCapacity,domain.tmpWritable,domain.apart⟩

theorem binding (src : String) (s : State) (root tmp : ArrayPointer)
    (sourceBinding : s.arrays src.toList=some root) (tmpBinding : s.arrays "gm".toList=some tmp)
    (primesBinding : s.arrays "primes".toList=some primes)
    (slen : Cell s "slen".toList 166) (num : Cell s "n".toList 2)
    (rootCap : root.index+0 ≤ root.count) (tmpCap : tmp.index+0 ≤ tmp.count) :
    Bind s (KeygenZintCall.params .rebuildCrt) (MakeFgCrtShape194.crtArgs src) (entry s root tmp) := by
  have zero:=C99ScalarReference.Eval.literal (calls:=FprPrefixCalls.calls) (env:=s.locals) .uint64 0
  have first : Pointer s src.toList C99ProcedureParser.zero root :=
    .add _ _ root root (.uint64 0) sourceBinding zero (by decide) (.within root 0 rootCap)
  have table : Pointer s "primes".toList C99ProcedureParser.zero primes :=
    .add _ _ primes primes (.uint64 0) primesBinding zero (by decide) (.within primes 0 (by decide))
  have scratch : Pointer s "gm".toList C99ProcedureParser.zero tmp :=
    .add _ _ tmp tmp (.uint64 0) tmpBinding zero (by decide) (.within tmp 0 tmpCap)
  refine .pointer _ _ _ _ _ _ _ first ?_
  refine .scalar .uint64 "xlen".toList (.var "slen".toList) _ _ _ (.uint64 (word 166)) (.variable _ _ _ slen) ?_
  refine .scalar .uint64 "xstride".toList (.var "slen".toList) _ _ _ (.uint64 (word 166)) (.variable _ _ _ slen) ?_
  refine .scalar .uint64 "num".toList (.var "n".toList) _ _ _ (.uint64 (word 2)) (.variable _ _ _ num) ?_
  refine .pointer _ _ _ _ _ _ _ table ?_
  refine .scalar .int32 "normalize_signed".toList (.literal .i32 1) _ _ _ (.int32 1) (.literal .int32 1) ?_
  exact .pointer _ _ _ _ _ _ _ scratch .nil

/- One original rebuild call statement at the make_fg level. -/
theorem call_source (src : String) (s : State) (root tmp : ArrayPointer) (W0 : Nat → BitVec 32)
    (sourceBinding : s.arrays src.toList=some root) (tmpBinding : s.arrays "gm".toList=some tmp)
    (primesBinding : s.arrays "primes".toList=some primes)
    (slen : Cell s "slen".toList 166) (num : Cell s "n".toList 2)
    (domain : Domain s root tmp) (data : Data s root 332 W0) :
    ∃ out, KeygenZintCall.Exec (.call .rebuildCrt (MakeFgCrtShape194.crtArgs src) .discard) s ⟨out,.normal⟩ ∧
      Data out root 332 (words166 W0) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      out.tables=s.tables ∧
      (∀ q old, (∀ i, i < 332 → Separate (elem root i) q) → (∀ j, j < 166 → Separate (elem tmp j) q) →
        Load32 s.heap q old → Load32 out.heap q old) := by
  obtain ⟨out,run,image,keep⟩ :=
    NinthStepCrtBody217.source (entry s root tmp) root tmp W0 (input s root tmp domain) data
  refine ⟨{s with heap:=out.heap},?_,image,rfl,rfl,rfl,keep⟩
  exact KeygenZintCall.Exec.call s .rebuildCrt (MakeFgCrtShape194.crtArgs src) .discard
    (entry s root tmp) ⟨out,.normal⟩ none _
    (binding src s root tmp sourceBinding tmpBinding primesBinding slen num
      (by have h:=domain.capacity; omega) (by have h:=domain.tmpCapacity; omega)) run .voidEnd (.discard _ _)

/- Readonly transports across one call (kept words of the caller). -/
theorem object_keep {s out : State} {root tmp : ArrayPointer}
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (rootWritable : s.heap.writable root.block=true) (tmpWritable : s.heap.writable tmp.block=true)
    (writableEq : out.heap.writable=s.heap.writable) (sizeEq : out.heap.size=s.heap.size)
    (keep : ∀ q old, (∀ i, i < 332 → Separate (elem root i) q) →
      (∀ j, j < 166 → Separate (elem tmp j) q) → Load32 s.heap q old → Load32 out.heap q old) :
    KeygenStaticTables.PrimeObject out.heap primes .ternary := by
  have nroot : primes.block≠root.block := by
    intro eq
    rw [← eq] at rootWritable
    have flip := object.2.2.2.1
    rw [rootWritable] at flip
    cases flip
  have ntmp : primes.block≠tmp.block := by
    intro eq
    rw [← eq] at tmpWritable
    have flip := object.2.2.2.1
    rw [tmpWritable] at flip
    cases flip
  refine ⟨object.1,object.2.1,object.2.2.1,?_,?_,?_,?_⟩
  · rw [writableEq]; exact object.2.2.2.1
  · rw [sizeEq]; exact object.2.2.2.2.1
  · rw [sizeEq]; exact object.2.2.2.2.2.1
  · intro i v hv field
    apply keep (KeygenStaticTables.primeField primes i field) _
      (fun _ _ => Or.inl (Ne.symm nroot)) (fun _ _ => Or.inl (Ne.symm ntmp))
    exact object.2.2.2.2.2.2 i v hv field

theorem rev_keep {s out : State} (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (stable : KeygenMemoryStability.Stable s.heap out.heap) :
    KeygenMkgm3RevMemory.SourceTable out.heap rev := by
  have block : KeygenMakeObjects.Block s.heap out.heap rev.block :=
    ⟨congrFun stable.size _,congrFun stable.writable _,fun offset => stable.readonly _ offset revS.1⟩
  exact KeygenMakeEntry.rev_block _ _ rev block revS

/- Outer state transport across one call. -/
theorem outer_keep {s out : State} (o : NinthStepGenerator217.Outer s 166)
    (locals : out.locals=s.locals) (arrays : out.arrays=s.arrays)
    (stable : KeygenMemoryStability.Stable s.heap out.heap) : NinthStepGenerator217.Outer out 166 := by
  refine ⟨(congrFun locals "n".toList).trans o.nCell,(congrFun locals "hn".toList).trans o.hnCell,
    (congrFun locals "slen".toList).trans o.slenCell,(congrFun locals "tlen".toList).trans o.tlenCell,
    (congrFun locals "u".toList).trans o.uCell,(congrFun locals "logn".toList).trans o.lognCell,
    (congrFun locals "ter".toList).trans o.terCell,(congrFun locals "in_ntt".toList).trans o.inCell,
    (congrFun locals "out_ntt".toList).trans o.outCell,(congrFun arrays "fd".toList).trans o.fdBinding,
    (congrFun arrays "gd".toList).trans o.gdBinding,(congrFun arrays "fs".toList).trans o.fsBinding,
    (congrFun arrays "gs".toList).trans o.gsBinding,(congrFun arrays "gm".toList).trans o.gmBinding,
    (congrFun arrays "igm".toList).trans o.igmBinding,(congrFun arrays "t1".toList).trans o.t1Binding,
    (congrFun arrays "primes".toList).trans o.primesBinding,?_,?_⟩
  · rw [stable.writable]; exact o.writable
  · intro index bound; simpa only [Allocated,stable.size] using o.allocated index bound

/- The combined keep of the pair: only fs/gs words and the first166 gm
   words change. -/
def Keeps (before after : State) : Prop :=
  ∀ q old, (∀ i, i < 332 → Separate (elem fs i) q) → (∀ i, i < 332 → Separate (elem gs i) q) →
    (∀ j, j < 166 → Separate (elem gm j) q) → Load32 before.heap q old → Load32 after.heap q old

theorem load_keep {s out : State} {q : ArrayPointer} {w : BitVec 32} (keep : Keeps s out)
    (fsSep : ∀ k, k < 332 → Separate (elem fs k) q) (gsSep : ∀ k, k < 332 → Separate (elem gs k) q)
    (gmSep : ∀ j, j < 166 → Separate (elem gm j) q) (read : Load32 s.heap q w) : Load32 out.heap q w :=
  keep q w fsSep gsSep gmSep read

theorem data_keep {s out : State} {p : ArrayPointer} {n : Nat} {W : Nat → BitVec 32}
    (keep : Keeps s out) (data : Data s p n W)
    (fsSep : ∀ i k, i < n → k < 332 → Separate (elem p i) (elem fs k))
    (gsSep : ∀ i k, i < n → k < 332 → Separate (elem p i) (elem gs k))
    (gmSep : ∀ i j, i < n → j < 166 → Separate (elem p i) (elem gm j)) :
    Data out p n W := by
  intro i bound
  exact keep (elem p i) (W i) (fun k kb => CrtRound214.sep_symm (fsSep i k bound kb))
    (fun k kb => CrtRound214.sep_symm (gsSep i k bound kb))
    (fun j jb => CrtRound214.sep_symm (gmSep i j bound jb)) (data i bound)

/- The two actual d=2 rebuild calls over fs and gs at one heap. -/
theorem source (s : State) (FW GW : Nat → BitVec 32) (outer : NinthStepGenerator217.Outer s 166)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revB : s.tables "REV10".toList=some rev)
    (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fdata : Data s fs 332 FW) (gdata : Data s gs 332 GW) :
    ∃ out, Exec MakeFgCrtShape194.part3 s ⟨out,.normal⟩ ∧
      NinthStepGenerator217.Outer out 166 ∧
      Data out fs 332 (words166 FW) ∧ Data out gs 332 (words166 GW) ∧
      KeygenStaticTables.PrimeObject out.heap primes .ternary ∧
      out.tables "REV10".toList=some rev ∧
      KeygenMkgm3RevMemory.SourceTable out.heap rev ∧
      Keeps s out := by
  have domainF : Domain s fs gm := ⟨object,by decide,by decide,outer.writable,
    outer.allocated 2004 (by decide),by decide,by decide,outer.writable,
    fun i j ib jb => fs_gm ib jb⟩
  obtain ⟨fOut,fCall,fImage,fLocals,fArrays,fTables,fKeep⟩ := call_source "fs" s fs gm FW
    outer.fsBinding outer.gmBinding outer.primesBinding outer.slenCell outer.nCell domainF fdata
  have fStable := KeygenMemoryStability.zint _ _ _ fCall
  have fOuter : NinthStepGenerator217.Outer fOut 166 := outer_keep outer fLocals fArrays fStable
  have fObject := object_keep object outer.writable outer.writable fStable.writable fStable.size fKeep
  have fRev := rev_keep revS fStable
  have gDataAtF : Data fOut gs 332 GW := by
    intro i bound
    exact fKeep (elem gs i) (GW i) (fun k kb => fs_gs kb bound)
      (fun j jb => CrtRound214.sep_symm (gs_gm bound (by omega))) (gdata i bound)
  have domainG : Domain fOut gs gm := ⟨fObject,by decide,by decide,fOuter.writable,
    (fOuter.allocated 2004 (by decide)),by decide,by decide,fOuter.writable,
    fun i j ib jb => gs_gm ib jb⟩
  obtain ⟨out,gCall,gImage,gLocals,gArrays,gTables,gKeep⟩ := call_source "gs" fOut gs gm GW
    fOuter.gsBinding fOuter.gmBinding fOuter.primesBinding fOuter.slenCell fOuter.nCell domainG gDataAtF
  have gStable := KeygenMemoryStability.zint _ _ _ gCall
  have finalOuter : NinthStepGenerator217.Outer out 166 := outer_keep fOuter gLocals gArrays gStable
  have fDataAtG : Data out fs 332 (words166 FW) := by
    intro i bound
    exact gKeep (elem fs i) (words166 FW i) (fun k kb => CrtRound214.sep_symm (fs_gs bound kb))
      (fun j jb => CrtRound214.sep_symm (fs_gm bound (by omega))) (fImage i bound)
  have first : Exec MakeFgCrtShape194.first3 s ⟨fOut,.normal⟩ := by
    rw [MakeFgCrtShape194.first3_shape]
    exact .zint _ _ _ fCall
  have second : Exec MakeFgCrtShape194.second3 fOut ⟨out,.normal⟩ := by
    rw [MakeFgCrtShape194.second3_shape]
    exact .zint _ _ _ gCall
  have last : Exec MakeFgCrtShape194.tail3 out ⟨out,.normal⟩ := by
    rw [MakeFgCrtShape194.tail3_skip]
    exact MakeFgDeclarations176.array_source .skip out out (.skip out)
  have full : Exec MakeFgCrtShape194.part3 s ⟨out,.normal⟩ := by
    rw [MakeFgCrtShape194.part3_split,MakeFgCrtShape194.rest3_split]
    exact .seqNormal _ _ _ _ _ first (.seqNormal _ _ _ _ _ second last)
  refine ⟨out,full,finalOuter,fDataAtG,gImage,?_,?_,?_,?_⟩
  · exact object_keep fObject fOuter.writable fOuter.writable gStable.writable gStable.size gKeep
  · exact (congrFun gTables "REV10".toList).trans ((congrFun fTables "REV10".toList).trans revB)
  · exact rev_keep fRev gStable
  · intro q old fsSep gsSep gmSep read
    exact gKeep q old gsSep gmSep (fKeep q old fsSep gmSep read)

end FT1536.Source3.NinthStepCrt217
