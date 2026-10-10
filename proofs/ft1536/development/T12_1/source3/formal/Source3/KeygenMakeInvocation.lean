import Source3.KeygenMakeStatementMachine
import Source3.KeygenMakeArguments
import Source3.KeygenMakeCertChronology

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE whole-invocation statement-machine execution of the encoding tail to
   the ACTUAL encoder call sites. The 18 statements of
   `KeygenMakeProgram.encoding` execute in source order on the caller state
   (typed assignments, byte stores, the `ske` pointer-array stores, the
   four-segment loop and the public dispatch), reaching the actual
   `falcon_encode_small`/`falcon_encode_18433`/`falcon_encode_12289` call
   sites with their evaluated argument cells. The output-capacity events
   (`klen<1` twice, `elen==0` in the segment loop, `klen==0` after the
   public call) are exposed as named return-0 edges; the complete teardown
   (`KeygenMakeLifetime.close`: outer scope restore + disposal of the six
   automatic blocks) closes EVERY return edge of the invocation, including
   the attempt-cap edge.

   Call-site boundary: the codec BODIES are B1.08/09. Each encoder call
   event carries its open return value and heap effect; the write frame of
   the codec bodies (persistence of the stored length words and of the
   source arrays through subsequent calls) is the named B1.08 obligation,
   not a premise here. The source pointer at each `falcon_encode_small`
   site is read from the actual `ske[i]` cell; `small_site_material` ties
   it to the material array of segment `i` whenever the stored pointer
   word is readable at the call boundary (`read_unique` + the legal
   virtual map).

   Residue of the plan phrase "globals/common call ID/snapshots": the
   instantiated package `cert_package_of_call` already carries the
   concrete pinned globals, the prefix/reverse source snapshots, the
   bad-flag lifetime and the shared call material (gate trace + good event
   stream of the same call). `CertPackage`/`invocation_certificate` tie
   that package to the SAME whole invocation through the accepted gate
   call of its final attempt — the derivation reading of "identyfikator
   tej samej inwokacji" (PLAN `FullCertificateWitness`). If the phrase
   intends an EXPLICIT identifier value beyond the shared derivation — a
   call-ID field identifying the certificate's internal prefix/Gate00/
   suffix snapshots as one body execution independent of the derivation —
   that composition is pinned as OPEN in the batch notes with its intended
   shape; no such field is derived or assumed here. Not a review, not a
   codec claim and not a law claim; B1.08/09 and B4/B5 stay outside. -/
namespace FT1536.Source3.KeygenMakeInvocation
open C99ArrayReference (State Name bindPointer)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result Flow)
open KeygenSearchContext (Context)
open KeygenMakeSyntax
open KeygenMakeProgram (varExpr number)

/-! ## 1. The fixed data of one invocation (definitions first) -/

/-- The fixed data of ONE `falcon_keygen_make` invocation: the external
    arguments, the six automatic-object blocks, the fk context and the
    virtual address map used for LP64 pointer words. -/
structure Env where
  args : KeygenMakeArguments.Arguments
  blocks : Fin 6 → Nat
  ctx : Context
  vb : Nat → Nat

def inputOf (env : Env) : Fin 4 → ArrayPointer := KeygenMakeEntry.input env.blocks
def publicOf (env : Env) : ArrayPointer := KeygenMakeEntry.publicPointer env.blocks
def skePtr (env : Env) : ArrayPointer := KeygenMakeObjects.pointer env.blocks 5
def skeElem (env : Env) (i : Fin 4) : ArrayPointer := {skePtr env with index := i.val}
def skeName (i : Fin 4) : Name := KeygenMakeObjects.name ⟨i.val,by have := i.isLt; omega⟩

/-- The typed scalar assignment of the tail's statement forms: the named
    local receives the evaluated value at its declared width (the typed
    conversion is the identity at that width). -/
def assign (s : State) (name : Name) (ty : C99IntegerReference.Ty) (v : Value) : State :=
  {s with locals := C99ScalarReference.set s.locals name (ty,some v)}

/-- A byte view of a pointer advanced by `n` bytes (the `unsigned char *`
    arithmetic of the tail). -/
def byteOff (p : ArrayPointer) (n : Nat) : ArrayPointer :=
  ⟨p.block,p.base,p.count*p.elementBytes,1,p.offset+n-p.base⟩

/-- One-byte object store (the `unsigned char` lvalues of the tail); the
    stored value is the low byte of the evaluated expression (C99 6.3.1.3
    modulo-2^8 conversion). -/
def StoreByte (before : Memory) (p : ArrayPointer) (w : BitVec 8) (after : Memory) : Prop :=
  Allocated before p ∧ p.elementBytes=1 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  after.bytes p.block p.offset=some w ∧
  (∀ block offset, block≠p.block ∨ offset≠p.offset →
    after.bytes block offset=before.bytes block offset)

/-! ## 2. Pointer words in the legal allocation environment -/

/-- The LP64 pointer word of `p` in the virtual map `vb` (pointer
    representation belongs to the legal allocation environment; the
    physical compiler layout is checked by the pinned C controls). -/
def wordOf (vb : Nat → Nat) (p : ArrayPointer) : BitVec 64 :=
  BitVec.ofNat 64 (vb p.block+p.offset)

/-- Legality of the virtual address map: every live block has a
    sub-2^64 base and distinct blocks have distinct virtual bases. -/
structure VirtualLegal (vb : Nat → Nat) : Prop where
  bounded : ∀ block, vb block<2^64
  distinct : ∀ b c : Nat, vb b=vb c → b=c

/-- The canonical small-array pointer shape held in the `ske` cells. -/
structure Canonical (p : ArrayPointer) : Prop where
  zeroBase : p.base=0
  zeroIndex : p.index=0
  smallCount : p.count=3072
  smallWidth : p.elementBytes=2

def WritePointer (vb : Nat → Nat) (heap : Memory) (cell : ArrayPointer)
    (p : ArrayPointer) (after : Memory) : Prop :=
  Canonical p ∧ Store64 heap cell (wordOf vb p) after

/-- A pointer value read from memory: the loaded 64-bit word is the
    pointer's LP64 object representation, at the canonical small-array
    shape of the `ske` cells. -/
structure ReadPointer (vb : Nat → Nat) (heap : Memory) (cell : ArrayPointer)
    (p : ArrayPointer) : Prop where
  canonical : Canonical p
  load : Load64 heap cell (wordOf vb p)

theorem load64_after_store (before after : Memory) (p : ArrayPointer) (w w' : BitVec 64)
    (store : Store64 before p w after) (load : Load64 after p w') : w'=w := by
  cases load with
  | load b allocated typeSize initialized =>
    have content := store.2.2.2.2.2.1
    have same : b=byte64 w := by
      funext i
      exact Option.some.inj ((initialized i).symm.trans (content i))
    have joined : le64 b=le64 (byte64 w) := congrArg le64 same
    exact joined.trans (B20.Word.LE.join_byteOf w)

theorem load64_of_store (before after : Memory) (p : ArrayPointer) (w : BitVec 64)
    (store : Store64 before p w after) : Load64 after p w := by
  obtain ⟨allocated,width,_,same,_,content,_⟩ := store
  obtain ⟨positive,aligned,inside,extent,bounded⟩ := allocated
  rw [← B20.Word.LE.join_byteOf w]
  refine Load64.load after p (byte64 w) ⟨positive,aligned,inside,?_,?_⟩ width ?_
  · rw [same]; exact extent
  · rw [same]; exact bounded
  · intro i
    exact content i

/-- Two pointer words of canonical shape decide the pointer: the word is
    the virtual base of the block, and the legal map is injective. -/
theorem canonical_word_eq (vb : Nat → Nat) (legal : VirtualLegal vb)
    (p q : ArrayPointer) (cp : Canonical p) (cq : Canonical q)
    (words : wordOf vb p=wordOf vb q) : p=q := by
  cases p with | mk pb pbase pcount pwidth pindex =>
  cases q with | mk qb qbase qcount qwidth qindex =>
  have zeroBase : pbase=0 := cp.zeroBase
  have zeroIndex : pindex=0 := cp.zeroIndex
  have smallCount : pcount=3072 := cp.smallCount
  have smallWidth : pwidth=2 := cp.smallWidth
  have qBase : qbase=0 := cq.zeroBase
  have qIndex : qindex=0 := cq.zeroIndex
  have qCount : qcount=3072 := cq.smallCount
  have qWidth : qwidth=2 := cq.smallWidth
  have hp : (ArrayPointer.mk pb pbase pcount pwidth pindex).offset=0 := by
    simp only [ArrayPointer.offset,zeroBase,zeroIndex,Nat.mul_zero,Nat.add_zero]
  have hq : (ArrayPointer.mk qb qbase qcount qwidth qindex).offset=0 := by
    simp only [ArrayPointer.offset,qBase,qIndex,Nat.mul_zero,Nat.add_zero]
  rw [wordOf,wordOf,hp,hq] at words
  have mods : (vb pb)%2^64=(vb qb)%2^64 := by
    have eq := congrArg BitVec.toNat words
    simpa [BitVec.toNat_ofNat] using eq
  have bp := Nat.mod_eq_of_lt (legal.bounded pb)
  have bq := Nat.mod_eq_of_lt (legal.bounded qb)
  rw [bp,bq] at mods
  have blocks : pb=qb := legal.distinct pb qb mods
  subst blocks
  subst zeroBase zeroIndex smallCount smallWidth qBase qIndex qCount qWidth
  rfl

theorem read_unique (vb : Nat → Nat) (legal : VirtualLegal vb) (heap : Memory)
    (cell p q : ArrayPointer) (first : ReadPointer vb heap cell p)
    (second : ReadPointer vb heap cell q) : p=q :=
  canonical_word_eq vb legal p q first.canonical second.canonical
    (load64_deterministic heap cell (wordOf vb p) (wordOf vb q) first.load second.load)

theorem input_canonical (env : Env) (i : Fin 4) : Canonical (inputOf env i) := by
  refine ⟨rfl,rfl,?_,?_⟩
  · show KeygenMakeObjects.count ⟨i.val,_⟩=3072
    have different : i.val≠5 := by omega
    simp [KeygenMakeObjects.count,different]
  · show KeygenMakeObjects.width ⟨i.val,_⟩=2
    have different : i.val≠5 := by omega
    simp [KeygenMakeObjects.width,different]

theorem skeElem_offset (env : Env) (i : Fin 4) : (skeElem env i).offset=8*i.val := by
  simp [skeElem,skePtr,KeygenMakeObjects.pointer,ArrayPointer.offset,KeygenMakeObjects.width]

/-! ## 3. The actual encoder call sites -/

/-- THE `falcon_encode_small` call site of segment `i`
    (`elen = falcon_encode_small(skbuf+skoff, klen-skoff, comp,
    ter?18433:12289, ske[i], logn)`): the evaluated argument cells at the
    call boundary and the open codec effect (return value + resulting
    heap). The evaluated arguments are determined by these cells: the
    destination is `byteOff args.privkey skoff`, the capacity `klen-skoff`,
    the modulus word follows the `ter` dispatch and the source is the
    pointer read from `ske[i]`. The callee body is B1.08; nothing about its
    correctness, its write frame or its return value is a premise. -/
structure SmallSite (env : Env) (before : State) (i : Fin 4)
    (after : Memory) (ret : BitVec 64) where
  src : ArrayPointer
  skbufCell : before.arrays "skbuf".toList=some env.args.privkey
  srcCell : ReadPointer env.vb before.heap (skeElem env i) src
  klen : BitVec 64
  klenCell : before.locals "klen".toList=some (.uint64,some (.uint64 klen))
  skoff : BitVec 64
  skoffCell : before.locals "skoff".toList=some (.uint64,some (.uint64 skoff))
  comp : BitVec 32
  compCell : before.locals "comp".toList=some (.int32,some (.int32 env.args.comp))
  ter : BitVec 32
  terCell : before.locals "ter".toList=some (.uint32,some (.uint32 ter))
  logn : BitVec 32
  lognCell : before.locals "logn".toList=some (.uint32,some (.uint32 logn))

/-- THE public-key encoder call site (`klen = falcon_encode_18433(...)` /
    `falcon_encode_12289(...)`): the evaluated argument cells at the call
    boundary — the destination is `byteOff args.pubkey 1`, the capacity
    `klen-1`, the source the `h` array — with the destination fixed by the
    dispatch arm. -/
structure PublicSite (env : Env) (destination : Callee) (before : State)
    (after : Memory) (ret : BitVec 64) where
  pubkeyCell : before.arrays "pubkey".toList=some env.args.pubkey
  hCell : before.arrays "h".toList=some (publicOf env)
  klen : BitVec 64
  klenCell : before.locals "klen".toList=some (.uint64,some (.uint64 klen))
  logn : BitVec 32
  lognCell : before.locals "logn".toList=some (.uint32,some (.uint32 logn))

/-- THE source tie at a segment call site: when the stored `ske[i]` pointer
    word is readable at the call boundary, the source argument IS the
    material array of segment `i` (write-then-read uniqueness of the legal
    pointer representation). The persistence of that word through earlier
    codec calls is the B1.08 source-preservation item. -/
theorem small_site_material (env : Env) (before : State) (i : Fin 4)
    (after : Memory) (ret : BitVec 64) (site : SmallSite env before i after ret)
    (legal : VirtualLegal env.vb)
    (word : Load64 before.heap (skeElem env i) (wordOf env.vb (inputOf env i))) :
    site.src=inputOf env i :=
  read_unique env.vb legal before.heap (skeElem env i) site.src (inputOf env i)
    site.srcCell ⟨input_canonical env i,word⟩

/-! ## 4. The four-segment loop statement -/

/-- The executed four-segment loop body (`KeygenMakeProgram.secretLoop`):
    iterations `i..3`, each with its actual `falcon_encode_small` call site,
    the `elen==0` output-capacity event and the `skoff += elen` update. The
    `elen` local is declared, assigned from the call return and restored at
    the iteration scope exit, so the machine records the call return as the
    iteration value. -/
inductive Segments (env : Env) : Nat → State → Result → Prop where
  | done (i : Nat) (s : State) (bound : 4 ≤ i)
      (counter : s.locals "i".toList=some (.int32,some (.int32 (BitVec.ofNat 32 i)))) :
      Segments env i s ⟨s,.normal⟩
  | capacity (i : Nat) (s : State) (after : Memory) (lt : i<4) (ret : BitVec 64)
      (counter : s.locals "i".toList=some (.int32,some (.int32 (BitVec.ofNat 32 i))))
      (site : SmallSite env s ⟨i,by omega⟩ after ret) (zero : ret=0) :
      Segments env i s ⟨{s with heap := after},.returned (some (.int32 0))⟩
  | next (i : Nat) (s : State) (after : Memory) (lt : i<4) (ret : BitVec 64)
      (counter : s.locals "i".toList=some (.int32,some (.int32 (BitVec.ofNat 32 i))))
      (site : SmallSite env s ⟨i,by omega⟩ after ret) (nonzero : ret≠0)
      (skoff : BitVec 64)
      (skoffCell : s.locals "skoff".toList=some (.uint64,some (.uint64 skoff)))
      (rest : Segments env (i+1)
        (assign (assign {s with heap := after} "skoff".toList .uint64 (.uint64 (skoff+ret)))
          "i".toList .int32 (.int32 (BitVec.ofNat 32 (i+1)))) out) :
      Segments env i s out

/-- The segment loop statement executes after its `i = 0` initialization. -/
def initCounter (s : State) : State := assign s "i".toList .int32 (.int32 0)

theorem segments_flow (env : Env) (i : Nat) (s : State) (out : Result)
    (source : Segments env i s out) :
    out.flow=.normal ∨ out.flow=.returned (some (.int32 0)) := by
  induction source with
  | done i s bound counter => exact Or.inl rfl
  | capacity i s after lt ret counter site zero => exact Or.inr rfl
  | next i s after lt ret counter site nonzero skoff skoffCell rest ih =>
    rcases ih with h | h
    · exact Or.inl h
    · exact Or.inr h

/-! ## 5. The typed statement machine of the encoding tail -/

def privkeyLenRead : Stmt :=
  .write (varExpr "klen") .set (.unary .dereference (varExpr "privkey_len"))
def skbufAssign : Stmt := .write (varExpr "skbuf") .set (varExpr "privkey")
def skHeader : Stmt := .write (.index (varExpr "skbuf") (number 0)) .set
  (.binary .add (.binary .add (.binary .shl (varExpr "ter") (number 7))
    (.binary .shl (varExpr "comp") (number 5))) (varExpr "logn"))
def skoffOne : Stmt := .write (varExpr "skoff") .set (number 1)
def skeBind (i : Nat) (name : Name) : Stmt :=
  .write (.index (varExpr "ske") (number i)) .set (.variable name)
def privkeyLenWrite : Stmt :=
  .write (.unary .dereference (varExpr "privkey_len")) .set (varExpr "skoff")
def pubkeyLenRead : Stmt :=
  .write (varExpr "klen") .set (.unary .dereference (varExpr "pubkey_len"))
def pkHeader : Stmt := .write (.index (.cast (.pointer .byte) (varExpr "pubkey")) (number 0))
  .set (.binary .add (.binary .shl (varExpr "ter") (number 7)) (varExpr "logn"))
def zeroCapacity : Stmt := .branch (.binary .eq (varExpr "klen") (number 0))
  (.scope (.seq (.ret (number 0)) .skip)) .skip
def pubkeyLenWrite : Stmt :=
  .write (.unary .dereference (varExpr "pubkey_len")) .set (.binary .add (varExpr "klen") (number 1))
def retOne : Stmt := .ret (number 1)

/-- The last statement of a statement list (the tail of the caller body
    ends in `return 1`). -/
def lastStmt : List Stmt → Option Stmt
  | [] => none
  | [a] => some a
  | _::b::l => lastStmt (b::l)

theorem last_cons (a b : Stmt) (l : List Stmt) : lastStmt (a::b::l)=lastStmt (b::l) := rfl

theorem tail_source :
    KeygenMakeProgram.encoding=
      [privkeyLenRead,skbufAssign,KeygenMakeProgram.capacityReturn,skHeader,skoffOne,
       skeBind 0 "f".toList,skeBind 1 "g".toList,skeBind 2 "F".toList,skeBind 3 "G".toList,
       KeygenMakeProgram.secretLoop,privkeyLenWrite,pubkeyLenRead,
       KeygenMakeProgram.capacityReturn,pkHeader,KeygenMakeProgram.publicDispatch,
       zeroCapacity,pubkeyLenWrite,retOne] := by decide +kernel

theorem tail_last : lastStmt KeygenMakeProgram.encoding=some retOne := by
  rw [tail_source]
  rfl

/-- The typed execution of ONE encoding-tail statement on the caller
    state; `Head` constructors are named after the source statements whose
    shapes are pinned above. Branch rejections execute the actual
    `return 0`; the codec calls appear only as the call-site events of
    section 3. -/
inductive Head (env : Env) : Stmt → State → Result → Prop where
  | readPrivate (s : State) (word : BitVec 64)
      (load : Load64 s.heap env.args.privkeyLen word) :
      Head env privkeyLenRead s ⟨assign s "klen".toList .uint64 (.uint64 word),.normal⟩
  | bindSkbuf (s : State) :
      Head env skbufAssign s ⟨bindPointer s "skbuf".toList env.args.privkey,.normal⟩
  | privatePass (s : State) (klen : BitVec 64)
      (cell : s.locals "klen".toList=some (.uint64,some (.uint64 klen)))
      (ge : 1≤klen.toNat) :
      Head env KeygenMakeProgram.capacityReturn s ⟨s,.normal⟩
  | privateReject (s : State) (klen : BitVec 64)
      (cell : s.locals "klen".toList=some (.uint64,some (.uint64 klen)))
      (lt : klen.toNat<1) :
      Head env KeygenMakeProgram.capacityReturn s ⟨s,.returned (some (.int32 0))⟩
  | storeSkHeader (s : State) (ter comp logn : BitVec 32) (byte : BitVec 8) (after : Memory)
      (terCell : s.locals "ter".toList=some (.uint32,some (.uint32 ter)))
      (compCell : s.locals "comp".toList=some (.int32,some (.int32 comp)))
      (lognCell : s.locals "logn".toList=some (.uint32,some (.uint32 logn)))
      (skbufCell : s.arrays "skbuf".toList=some env.args.privkey)
      (value : byte=BitVec.setWidth 8 ((ter<<<7)+(comp<<<5)+logn))
      (store : StoreByte s.heap (byteOff env.args.privkey 0) byte after) :
      Head env skHeader s ⟨{s with heap := after},.normal⟩
  | bindSkoff (s : State) :
      Head env skoffOne s ⟨assign s "skoff".toList .uint64 (.uint64 1),.normal⟩
  | bindSke (i : Fin 4) (s : State) (src : ArrayPointer) (after : Memory)
      (cell : s.arrays (skeName i)=some src)
      (store : WritePointer env.vb s.heap (skeElem env i) src after) :
      Head env (skeBind i.val (skeName i)) s ⟨{s with heap := after},.normal⟩
  | segmentsNormal (s : State) (seg : Result)
      (run : Segments env 0 (initCounter s) seg) (normal : seg.flow=.normal) :
      Head env KeygenMakeProgram.secretLoop s ⟨seg.state,.normal⟩
  | segmentsReturn (s : State) (seg : Result)
      (run : Segments env 0 (initCounter s) seg)
      (returned : seg.flow=.returned (some (.int32 0))) :
      Head env KeygenMakeProgram.secretLoop s ⟨seg.state,.returned (some (.int32 0))⟩
  | storePrivkeyLen (s : State) (skoff : BitVec 64) (after : Memory)
      (skoffCell : s.locals "skoff".toList=some (.uint64,some (.uint64 skoff)))
      (store : Store64 s.heap env.args.privkeyLen skoff after) :
      Head env privkeyLenWrite s ⟨{s with heap := after},.normal⟩
  | readPubKlen (s : State) (word : BitVec 64)
      (load : Load64 s.heap env.args.pubkeyLen word) :
      Head env pubkeyLenRead s ⟨assign s "klen".toList .uint64 (.uint64 word),.normal⟩
  | publicPass (s : State) (klen : BitVec 64)
      (cell : s.locals "klen".toList=some (.uint64,some (.uint64 klen)))
      (ge : 1≤klen.toNat) :
      Head env KeygenMakeProgram.capacityReturn s ⟨s,.normal⟩
  | publicReject (s : State) (klen : BitVec 64)
      (cell : s.locals "klen".toList=some (.uint64,some (.uint64 klen)))
      (lt : klen.toNat<1) :
      Head env KeygenMakeProgram.capacityReturn s ⟨s,.returned (some (.int32 0))⟩
  | storePkHeader (s : State) (ter logn : BitVec 32) (byte : BitVec 8) (after : Memory)
      (terCell : s.locals "ter".toList=some (.uint32,some (.uint32 ter)))
      (lognCell : s.locals "logn".toList=some (.uint32,some (.uint32 logn)))
      (pubkeyCell : s.arrays "pubkey".toList=some env.args.pubkey)
      (value : byte=BitVec.setWidth 8 ((ter<<<7)+logn))
      (store : StoreByte s.heap (byteOff env.args.pubkey 0) byte after) :
      Head env pkHeader s ⟨{s with heap := after},.normal⟩
  | publicTernary (s : State) (after : Memory) (ret : BitVec 64)
      (ter : BitVec 32) (terCell : s.locals "ter".toList=some (.uint32,some (.uint32 ter)))
      (nonzero : ter≠0) (site : PublicSite env .encodeT s after ret) :
      Head env KeygenMakeProgram.publicDispatch s
        ⟨assign {s with heap := after} "klen".toList .uint64 (.uint64 ret),.normal⟩
  | publicBinary (s : State) (after : Memory) (ret : BitVec 64)
      (ter : BitVec 32) (terCell : s.locals "ter".toList=some (.uint32,some (.uint32 ter)))
      (zero : ter=0) (site : PublicSite env .encodeB s after ret) :
      Head env KeygenMakeProgram.publicDispatch s
        ⟨assign {s with heap := after} "klen".toList .uint64 (.uint64 ret),.normal⟩
  | zeroPass (s : State) (klen : BitVec 64)
      (cell : s.locals "klen".toList=some (.uint64,some (.uint64 klen)))
      (nonzero : klen≠0) : Head env zeroCapacity s ⟨s,.normal⟩
  | zeroReject (s : State) (klen : BitVec 64)
      (cell : s.locals "klen".toList=some (.uint64,some (.uint64 klen)))
      (zero : klen=0) :
      Head env zeroCapacity s ⟨s,.returned (some (.int32 0))⟩
  | storePubkeyLen (s : State) (klen : BitVec 64) (after : Memory)
      (klenCell : s.locals "klen".toList=some (.uint64,some (.uint64 klen)))
      (store : Store64 s.heap env.args.pubkeyLen (klen+1) after) :
      Head env pubkeyLenWrite s ⟨{s with heap := after},.normal⟩
  | returnOne (s : State) : Head env retOne s ⟨s,.returned (some (.int32 1))⟩

/-- THE encoding-tail statement machine: the statement list executes in
    source order; a non-normal head edge exits the tail with its flow. -/
inductive Encoding (env : Env) : List Stmt → State → Result → Prop where
  | done (s : State) : Encoding env [] s ⟨s,.normal⟩
  | step (stmt : Stmt) (rest : List Stmt) (s middle : State) (out : Result)
      (head : Head env stmt s ⟨middle,.normal⟩) (tail : Encoding env rest middle out) :
      Encoding env (stmt::rest) s out
  | exit (stmt : Stmt) (rest : List Stmt) (s : State) (out : Result)
      (head : Head env stmt s out) (flow : out.flow≠.normal) :
      Encoding env (stmt::rest) s out

theorem segments_tables (env : Env) (i : Nat) (s : State) (out : Result)
    (source : Segments env i s out) : out.state.tables=s.tables := by
  induction source with
  | done i s bound counter => rfl
  | capacity i s after lt ret counter site zero => rfl
  | next i s after lt ret counter site nonzero skoff skoffCell rest ih => exact ih

theorem segments_arrays (env : Env) (i : Nat) (s : State) (out : Result)
    (source : Segments env i s out) : out.state.arrays=s.arrays := by
  induction source with
  | done i s bound counter => rfl
  | capacity i s after lt ret counter site zero => rfl
  | next i s after lt ret counter site nonzero skoff skoffCell rest ih => exact ih

theorem head_flow (env : Env) (stmt : Stmt) (s : State) (out : Result)
    (source : Head env stmt s out) :
    out.flow=.normal ∨ out.flow=.returned (some (.int32 0)) ∨
      out.flow=.returned (some (.int32 1)) := by
  cases source <;> first | exact Or.inl rfl | exact Or.inr (Or.inl rfl) | exact Or.inr (Or.inr rfl)

theorem head_tables (env : Env) (stmt : Stmt) (s : State) (out : Result)
    (source : Head env stmt s out) : out.state.tables=s.tables := by
  induction source with
  | readPrivate s word load => rfl
  | bindSkbuf s => rfl
  | privatePass s klen cell ge => rfl
  | privateReject s klen cell lt => rfl
  | storeSkHeader s ter comp logn byte after terCell compCell lognCell skbufCell value store => rfl
  | bindSkoff s => rfl
  | bindSke i s src after cell store => rfl
  | segmentsNormal s seg run normal => exact segments_tables env 0 (initCounter s) seg run
  | segmentsReturn s seg run returned => exact segments_tables env 0 (initCounter s) seg run
  | storePrivkeyLen s skoff after skoffCell store => rfl
  | readPubKlen s word load => rfl
  | publicPass s klen cell ge => rfl
  | publicReject s klen cell lt => rfl
  | storePkHeader s ter logn byte after terCell lognCell pubkeyCell value store => rfl
  | publicTernary s after ret ter terCell nonzero site => rfl
  | publicBinary s after ret ter terCell zero site => rfl
  | zeroPass s klen cell nonzero => rfl
  | zeroReject s klen cell zero => rfl
  | storePubkeyLen s klen after klenCell store => rfl
  | returnOne s => rfl

/-- The encoding tail keeps every pointer cell except `skbuf` (bound once
    by `skbuf = privkey`); the codec call events change only the heap. -/
theorem head_cells (env : Env) (stmt : Stmt) (s : State) (out : Result)
    (source : Head env stmt s out) (name : Name) (different : name≠"skbuf".toList) :
    out.state.arrays name=s.arrays name := by
  induction source with
  | readPrivate s word load => rfl
  | bindSkbuf s => simp only [bindPointer,different,ite_false]
  | privatePass s klen cell ge => rfl
  | privateReject s klen cell lt => rfl
  | storeSkHeader s ter comp logn byte after terCell compCell lognCell skbufCell value store => rfl
  | bindSkoff s => rfl
  | bindSke i s src after cell store => rfl
  | segmentsNormal s seg run normal =>
    exact congrFun (segments_arrays env 0 (initCounter s) seg run) name
  | segmentsReturn s seg run returned =>
    exact congrFun (segments_arrays env 0 (initCounter s) seg run) name
  | storePrivkeyLen s skoff after skoffCell store => rfl
  | readPubKlen s word load => rfl
  | publicPass s klen cell ge => rfl
  | publicReject s klen cell lt => rfl
  | storePkHeader s ter logn byte after terCell lognCell pubkeyCell value store => rfl
  | publicTernary s after ret ter terCell nonzero site => rfl
  | publicBinary s after ret ter terCell zero site => rfl
  | zeroPass s klen cell nonzero => rfl
  | zeroReject s klen cell zero => rfl
  | storePubkeyLen s klen after klenCell store => rfl
  | returnOne s => rfl

/-- Any tail execution whose last statement is `return 1` exits through
    exactly one of the named return edges. -/
theorem encoding_exit (env : Env) (ss : List Stmt) (s : State) (out : Result)
    (source : Encoding env ss s out) (last : lastStmt ss=some retOne) :
    out.flow=.returned (some (.int32 1)) ∨ out.flow=.returned (some (.int32 0)) := by
  revert last
  induction source with
  | done s =>
    intro last
    simp [lastStmt] at last
  | step stmt rest s middle out head tail ih =>
    intro last
    cases rest with
    | nil =>
      simp [lastStmt] at last
      subst last
      cases head
    | cons head' tail' =>
      exact ih (by rw [last_cons] at last; exact last)
  | exit stmt rest s out head flow =>
    intro last
    rcases head_flow env stmt s out head with normal | rejected | accepted
    · exact (flow normal).elim
    · exact Or.inr rejected
    · exact Or.inl accepted

/-- THE exit characterization of the encoding tail of the pinned caller
    source: every execution of the 18 statements ends in `return 1` or one
    of the four output-capacity `return 0` edges. -/
theorem tail_exit (env : Env) (s : State) (out : Result)
    (source : Encoding env KeygenMakeProgram.encoding s out) :
    out.flow=.returned (some (.int32 1)) ∨ out.flow=.returned (some (.int32 0)) :=
  encoding_exit env KeygenMakeProgram.encoding s out source
    (by rw [tail_source]; rfl)

/-! ## 6. The whole-invocation execution and the complete teardown -/

/-- The cell facts read by the encoding tail at its entry state (the
    accepted-break state): the arrays cells of the external parameters and
    the six automatic objects, the M0 scalar cells and the `comp`
    parameter. Their derivation across the per-retry loop chronology is the
    loop-trace item. -/
structure TailCells (env : Env) (s : State) : Prop where
  privkey : s.arrays "privkey".toList=some env.args.privkey
  privkeyLen : s.arrays "privkey_len".toList=some env.args.privkeyLen
  pubkey : s.arrays "pubkey".toList=some env.args.pubkey
  pubkeyLen : s.arrays "pubkey_len".toList=some env.args.pubkeyLen
  comp : s.locals "comp".toList=some (.int32,some (.int32 env.args.comp))
  logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))
  ter : s.locals "ter".toList=some (.uint32,some (.uint32 1))
  material : ∀ slot : Fin 4, s.arrays (skeName slot)=some (inputOf env slot)
  publicCell : s.arrays "h".toList=some (publicOf env)
  ske : s.arrays "ske".toList=some (skePtr env)

/-- THE whole-invocation statement-machine execution: the external
    argument binding, the readiness prefix, the capped attempt loop (the
    accepted break consumed by the loop statement, or the attempt-cap
    edge), the 18-statement encoding tail and the COMPLETE outer teardown
    (`KeygenMakeLifetime.close`) on every return edge. -/
inductive Invocation (env : Env) (caller : State) :
    List KeygenEntropySource.Event → Result → Prop where
  | encoded (events : List KeygenEntropySource.Event) (bound after : State)
      (loopOut : Result) (attempts : List (KeygenMakeCertChronology.AttemptExecution env.ctx))
      (tailOut : Result)
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params
        (KeygenMakeArguments.values env.args) bound)
      (readyPrefix : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩)
      (loop : KeygenMakeCertChronology.LoopTrace env.ctx after loopOut attempts)
      (succeeded : loopOut.flow=.normal)
      (cells : TailCells env loopOut.state)
      (legal : VirtualLegal env.vb)
      (tail : Encoding env KeygenMakeProgram.encoding loopOut.state tailOut) :
      Invocation env caller events (KeygenMakeLifetime.close bound env.blocks tailOut)
  | capped (events : List KeygenEntropySource.Event) (bound after : State)
      (loopOut : Result) (attempts : List (KeygenMakeCertChronology.AttemptExecution env.ctx))
      (binding : KeygenMakeArguments.Bind caller KeygenMakeArguments.params
        (KeygenMakeArguments.values env.args) bound)
      (readyPrefix : KeygenMakeReady.Prefix env.ctx bound env.blocks events ⟨after,.normal⟩)
      (loop : KeygenMakeCertChronology.LoopTrace env.ctx after loopOut attempts)
      (aborted : loopOut.flow=KeygenCapExecution.abortFlow) :
      Invocation env caller events (KeygenMakeLifetime.close bound env.blocks loopOut)

/-- Every return edge of the invocation is `return 1` or `return 0`. -/
theorem invocation_flow (env : Env) (caller : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : Invocation env caller events out) :
    out.flow=.returned (some (.int32 1)) ∨ out.flow=.returned (some (.int32 0)) := by
  cases source with
  | encoded bound after loopOut attempts tailOut binding readyPrefix loop succeeded cells legal
      tail =>
    rw [KeygenMakeLifetime.close_flow]
    exact tail_exit env loopOut.state tailOut tail
  | capped bound after loopOut attempts binding readyPrefix loop aborted =>
    rw [KeygenMakeLifetime.close_flow,aborted]
    exact Or.inr rfl

/-- THE complete teardown: every automatic-object block is disposed on
    every return edge of the invocation. -/
theorem invocation_teardown (env : Env) (caller : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : Invocation env caller events out) :
    ∀ slot : Fin 6, out.state.heap.size (env.blocks slot)=0 := by
  cases source with
  | encoded bound after loopOut attempts tailOut binding readyPrefix loop succeeded cells legal
      tail =>
    intro slot
    exact (KeygenMakeLifetime.close_object bound env.blocks tailOut slot).1.trans
      (KeygenMakeLifetime.prefix_empty env.ctx bound env.blocks events ⟨after,.normal⟩ readyPrefix
        slot)
  | capped bound after loopOut attempts binding readyPrefix loop aborted =>
    intro slot
    exact (KeygenMakeLifetime.close_object bound env.blocks loopOut slot).1.trans
      (KeygenMakeLifetime.prefix_empty env.ctx bound env.blocks events ⟨after,.normal⟩ readyPrefix
        slot)

/-- THE gate call of the same invocation: a successful invocation accepted
    its final attempt through the actual mandatory leaf-certificate gate;
    under the gate profile the accepted break is the executed certificate
    call, never the profile-false skip. -/
theorem invocation_gate (env : Env) (caller : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : Invocation env caller events out)
    (success : out.flow=.returned (some (.int32 1))) :
    ∃ (rawState : State) (gateOut : Result),
      KeygenMakeCertCall.CertificateGate env.ctx rawState gateOut ∧
      gateOut.flow=.breakLoop ∧
      (KeygenMakeCertCall.Profile rawState →
        ∃ (afterState : State) (v : Value),
          KeygenMakeCertCall.Call env.ctx rawState afterState v true) := by
  cases source with
  | capped bound after loopOut attempts binding readyPrefix loop aborted =>
    rw [KeygenMakeLifetime.close_flow,aborted] at success
    have different : (KeygenCapExecution.abortFlow : Flow)≠.returned (some (.int32 1)) :=
      by decide
    exact (different success).elim
  | encoded bound after loopOut attempts tailOut binding readyPrefix loop succeeded cells legal
      tail =>
    obtain ⟨_,final,_,_,accepted⟩ :=
      KeygenMakeCertChronology.successful_loop_last_attempt env.ctx after loopOut attempts loop
        succeeded
    obtain ⟨before,attemptOut,attemptSource⟩ := final
    have acceptedFlow : attemptOut.flow=.breakLoop := accepted
    revert acceptedFlow
    induction attemptSource with
    | earlyRejected raw sample rejected =>
      intro acceptedFlow
      rw [rejected] at acceptedFlow
      cases acceptedFlow
    | throughCertificate raw sample atCert gateOut gate =>
      intro acceptedFlow
      refine ⟨raw.state,gateOut,gate,acceptedFlow,?_⟩
      intro profile
      obtain ⟨afterState,v,call,_⟩ :=
        KeygenMakeCertCall.accepted_break_requires_call env.ctx raw.state gateOut gate profile
          acceptedFlow
      exact ⟨afterState,v,call⟩

/-- The certificate package (`cert_package_of_call`) at the gate call of
    this same invocation: its concrete pinned globals, the prefix/reverse
    source snapshots, the bad-flag lifetime and the shared call material. -/
def CertPackage (ctx : Context) (before after : State) : Prop :=
  ∃ (args : CertificateFunctionReference.Arguments) (gateTrace : List (BitVec 64))
    (events : List CertificateEffects.Event),
    KeygenMakeCertCall.CertBind before ctx args ∧
    CertificateFunctionSyntax.Bound ∧
    CertificateFunctionOutcome.StoredBounds args before.heap after.heap ∧
    gateTrace.length=768 ∧
    (∀ event∈events, CertificateEffects.Good event) ∧
    (∀ w : BitVec 32, ¬Load32 after.heap (C99Automatic32.pointer before.heap) w) ∧
    (∃ snapshot : CertificateFunctionWitness.Witness args before.heap after.heap
        gateTrace events true,
      StableBinaryByteView.flagRead (C99MemoryBridge.encode snapshot.edge)
        (CertificateFunctionWitness.layout args before.heap).bad=some 0) ∧
    ∃ (topState reverseState : CertificateEffects.State) (words : Fin 768 → BitVec 64),
      CertificateReverse.Snapshot (CertificateFunctionWitness.layout args before.heap)
        words topState ∧
      CertificateReverse.Snapshot (CertificateFunctionWitness.layout args before.heap)
        words reverseState

theorem cert_package (ctx : Context) (before after : State) (v : Value)
    (call : KeygenMakeCertCall.Call ctx before after v true)
    (dimensions : KeygenMakeSearchPrefix.Dimensions before)
    (workspace : KeygenMakeCertMaterial.LegalWorkspace before ctx) :
    CertPackage ctx before after :=
  KeygenMakeStatementMachine.cert_package_of_call ctx before after v call dimensions workspace

/-- THE same-invocation certificate identification (the derivation reading
    of the PLAN phrase "identyfikator tej samej inwokacji"): the complete
    mandatory certificate package instantiated at the accepted gate call of
    THIS invocation. If an EXPLICIT identifier value beyond this shared
    derivation is intended, that composition stays OPEN and is pinned in
    the batch notes. -/
theorem invocation_certificate (env : Env) (caller : State)
    (events : List KeygenEntropySource.Event) (out : Result)
    (source : Invocation env caller events out)
    (success : out.flow=.returned (some (.int32 1)))
    (dimensions : (s : State) → KeygenMakeSearchPrefix.Dimensions s)
    (workspace : (s : State) → KeygenMakeCertMaterial.LegalWorkspace s env.ctx) :
    ∃ (rawState afterState : State) (v : Value),
      KeygenMakeCertCall.Call env.ctx rawState afterState v true ∧
      CertPackage env.ctx rawState afterState := by
  obtain ⟨rawState,gateOut,gate,_,underProfile⟩ :=
    invocation_gate env caller events out source success
  have profile : KeygenMakeCertCall.Profile rawState :=
    KeygenMakeCertCall.profile_of_dimensions rawState (dimensions rawState)
  obtain ⟨afterState,v,call⟩ := underProfile profile
  exact ⟨rawState,afterState,v,call,
    cert_package env.ctx rawState afterState v call (dimensions rawState) (workspace rawState)⟩

end FT1536.Source3.KeygenMakeInvocation
