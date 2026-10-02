import Source3.KeygenNttLoopSupport

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Loop counters and pointer positions of the forward-NTT FIRST pass,
   extracted from an Exec derivation of the parsed `firstLoop` (B1.02
   remainder 2.1.1, first bullet): after k iterations `u ↦ k`,
   `r1 = a + k*stride`, `r2 = a + (hn+k)*stride` with k ≤ 768, where hn=768
   comes from the prologue `ready` state. No value/range/polynomial
   invariant belongs to this module (those are B1.04); the increments are
   `bindPtr` advances and the body only writes its own block locals and the
   heap. The stride magnitude σ is a symbolic premise with the single
   non-overflow condition 768*σ < 2^64 for the executed `hn*stride` index
   product; nothing here instantiates stride=1 (B1.07 call frame). -/
namespace FT1536.Source3.KeygenNttFirstLoop
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open C99MemoryReference (ArrayPointer)
open KeygenNttLoopSupport (u64 USlot PSlot contains_iff)

def firstGuard : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "hn".toList)

structure FirstInv (aP : ArrayPointer) (σ k : Nat) (s : State) : Prop where
  counter : USlot s "u" k
  low : PSlot s "r1" {aP with index := aP.index+k*σ}
  high : PSlot s "r2" {aP with index := aP.index+(768+k)*σ}
  bound : k≤768

inductive FirstTrace (aP : ArrayPointer) (σ : Nat) : Nat → State → State → Prop where
  | done (k : Nat) (s : State) (stop : ¬k<768) (inv : FirstInv aP σ k s) :
      FirstTrace aP σ k s s
  | next (k : Nat) (before mid after fin : State) (guard : k<768)
      (inv : FirstInv aP σ k before)
      (iteration : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody)
        before ⟨mid,.normal⟩)
      (update : Exec (KeygenNttForwardPrograms.step "u") mid ⟨after,.normal⟩)
      (rest : FirstTrace aP σ (k+1) after fin) :
      FirstTrace aP σ k before fin

/- Slot transports along frame-preserving bodies. -/
theorem slot_keep {s s' : State} (h : s'.locals=s.locals) (name : String) (n : Nat)
    (hh : USlot s name n) : USlot s' name n := by
  show s'.locals name.toList=_
  rw [h]
  exact hh

theorem ptr_keep {s s' : State} (h : s'.arrays=s.arrays) (name : String) (p : ArrayPointer)
    (hh : PSlot s name p) : PSlot s' name p := by
  show s'.arrays name.toList=_
  rw [h]
  exact hh

/- Guard evaluation for `u < hn` on the M0 path. -/
theorem guard_value (s : State) (x l : Nat) (v : Value)
    (hx : x<2^64) (hl : l<2^64) (c : USlot s "u" x) (lm : USlot s "hn" l)
    (source : C99ArrayReference.scalar s firstGuard v) :
    v=C99ScalarReference.boolean (decide (x<l)) := by
  change C99ScalarReference.Eval _ _
    (.compare .lt (.variable "u".toList) (.variable "hn".toList)) v at source
  obtain ⟨a,b,ha,hb,hop⟩ := KeygenNttForwardExec.eval_compare s.locals .lt _ _ v source
  have ha1 := KeygenNttLoopSupport.variable_u64 s "u" x a c ha
  have hb1 := KeygenNttLoopSupport.variable_u64 s "hn" l b lm hb
  subst a
  subst b
  rw [C99CountedWords.uint64_comparison .lt (BitVec.ofNat 64 x) (BitVec.ofNat 64 l) v hop]
  have h1 : (BitVec.ofNat 64 x).toNat=x := Nat.mod_eq_of_lt hx
  have h2 : (BitVec.ofNat 64 l).toNat=l := Nat.mod_eq_of_lt hl
  rw [h1,h2]
  change C99ScalarReference.boolean (C99IntegerReference.compare .lt (x : Int) (l : Int))=
    C99ScalarReference.boolean (decide (x<l))
  have hlt : C99IntegerReference.compare .lt (x : Int) (l : Int)=decide (x<l) := by
    simp [C99IntegerReference.compare]
  rw [hlt]

theorem guard_true (s : State) (x l : Nat) (v : Value)
    (hx : x<2^64) (hl : l<2^64) (c : USlot s "u" x) (lm : USlot s "hn" l)
    (source : C99ArrayReference.scalar s firstGuard v) (nonzero : v.integer≠0) : x<l := by
  rw [guard_value s x l v hx hl c lm source] at nonzero
  by_contra h
  simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero

theorem guard_false (s : State) (x l : Nat) (v : Value)
    (hx : x<2^64) (hl : l<2^64) (c : USlot s "u" x) (lm : USlot s "hn" l)
    (source : C99ArrayReference.scalar s firstGuard v) (zero : v.integer=0) : ¬x<l := by
  rw [guard_value s x l v hx hl c lm source] at zero
  intro h
  simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero

/- Pointer binds and advances: positions come from the executed bindPtr
   chain (`pointer_root`), with the evaluated stride offset. -/
theorem bind_stride (name : String) (s : State) (p : ArrayPointer) (σ : Nat) (out : Result)
    (hσ : σ<2^64) (slot : PSlot s name p) (st : USlot s "stride" σ)
    (source : Exec (.base (.bindPtr name.toList name.toList (.var "stride".toList))) s out) :
    PSlot out.state name {p with index := p.index+σ} := by
  obtain ⟨q,ptr,he⟩ := KeygenNttLoopSupport.bindPtr_result name.toList name.toList
    (.var "stride".toList) s out source
  subst out
  obtain ⟨i,ev,hroot⟩ := KeygenNttLoopSupport.pointer_root s name.toList
    (.var "stride".toList) p q slot ptr
  have hi : i=u64 σ := KeygenNttLoopSupport.variable_u64 s "stride" σ i st ev
  subst i
  rw [hroot,KeygenNttLoopSupport.u64_toNat σ hσ]
  simp [PSlot,C99ArrayReference.bindPointer]

theorem bind_a_zero (s : State) (aP : ArrayPointer) (out : Result)
    (slot : PSlot s "a" aP)
    (source : Exec (KeygenNttForwardPrograms.bind "r1" "a" KeygenNttButterflyPrograms.zero) s out) :
    PSlot out.state "r1" {aP with index := aP.index} := by
  obtain ⟨q,ptr,he⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "a".toList
    KeygenNttButterflyPrograms.zero s out source
  subst out
  obtain ⟨i,ev,hroot⟩ := KeygenNttLoopSupport.pointer_root s "a".toList
    KeygenNttButterflyPrograms.zero aP q slot ptr
  have hi : i=C99IntegerReference.convert .uint64 0 :=
    KeygenNttForwardExec.literal_value s B20.C.Ty.u64 0 i ev
  subst i
  have hz : (C99IntegerReference.convert .uint64 0).integer.toNat=0 := by decide
  rw [hroot,hz]
  simp [PSlot,C99ArrayReference.bindPointer]

theorem bind_a_hn (s : State) (aP : ArrayPointer) (σ : Nat) (out : Result)
    (hσ : σ<2^64) (fit : 768*σ<2^64) (slot : PSlot s "a" aP)
    (hn : USlot s "hn" 768) (st : USlot s "stride" σ)
    (source : Exec (KeygenNttForwardPrograms.bind "r2" "a"
      (.bin .mul (KeygenNttForwardPrograms.var "hn") (KeygenNttForwardPrograms.var "stride"))) s out) :
    PSlot out.state "r2" {aP with index := aP.index+768*σ} := by
  obtain ⟨q,ptr,he⟩ := KeygenNttLoopSupport.bindPtr_result "r2".toList "a".toList
    _ s out source
  subst out
  obtain ⟨i,ev,hroot⟩ := KeygenNttLoopSupport.pointer_root s "a".toList _ aP q slot ptr
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .times _ _ i ev
  have hx1 : x=u64 768 := KeygenNttLoopSupport.variable_u64 s "hn" 768 x hn hx
  have hy1 : y=u64 σ := KeygenNttLoopSupport.variable_u64 s "stride" σ y st hy
  subst x
  subst y
  have hi : i=u64 (768*σ) := KeygenNttLoopSupport.times_u64 768 σ (by decide) hσ i hop
  subst i
  rw [hroot,KeygenNttLoopSupport.u64_toNat (768*σ) fit]
  simp [PSlot,C99ArrayReference.bindPointer]

/- The firstInit chain: u := 0, r1 := a + 0, r2 := a + hn*stride. -/
theorem init_result (aP : ArrayPointer) (σ : Nat) (before : State) (out : Result)
    (hσ : σ<2^64) (fit : 768*σ<2^64)
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (hn : USlot before "hn" 768) (st : USlot before "stride" σ) (ap : PSlot before "a" aP)
    (source : Exec KeygenNttForwardPrograms.firstInit before out) :
    out.flow=.normal ∧ FirstInv aP σ 0 out.state ∧ USlot out.state "stride" σ ∧
      USlot out.state "hn" 768 := by
  obtain ⟨mid1,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before out source).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.assign_result "u".toList _ before out hr
    exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨ty,old,v,declared,evaluated,he⟩ :=
    KeygenNttLoopSupport.assign_result "u".toList _ before ⟨mid1,.normal⟩ head
  obtain ⟨oldu,ucl⟩ := uc
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans ucl))
  subst ty
  have hv : v=C99IntegerReference.convert .int32 0 := by
    have inner := KeygenNttForwardExec.eval_scalar before _ v evaluated
    exact KeygenNttLoopSupport.literal_i32 before 0 v inner
  rw [hv] at he
  have hm1 : mid1=C99ArrayReference.bindValue before "u".toList .uint64
      (C99IntegerReference.convert .int32 0) := congrArg Result.state he
  subst mid1
  have hu : USlot (C99ArrayReference.bindValue before "u".toList .uint64
      (C99IntegerReference.convert .int32 0)) "u" 0 := by
    have hcell : C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer=u64 0 := by decide
    show (C99ScalarReference.set before.locals "u".toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer))) "u".toList=some (.uint64,some (u64 0))
    rw [hcell]
    simp [C99ScalarReference.set]
  set m1 := C99ArrayReference.bindValue before "u".toList .uint64
    (C99IntegerReference.convert .int32 0)
  have hst1 : USlot m1 "stride" σ := by
    show (C99ScalarReference.set before.locals "u".toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer))) "stride".toList=_
    simp [C99ScalarReference.set]
    exact st
  have hhn1 : USlot m1 "hn" 768 := by
    show (C99ScalarReference.set before.locals "u".toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer))) "hn".toList=_
    simp [C99ScalarReference.set]
    exact hn
  have hap1 : PSlot m1 "a" aP := by
    show m1.arrays "a".toList=_
    exact ap
  obtain ⟨mid2,head2,tail2⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 out tail).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨p,_,he2⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "a".toList
      KeygenNttButterflyPrograms.zero m1 out hr
    exact hexit (congrArg C99ProcedureReference.Result.flow he2))
  have h1 := bind_a_zero m1 aP _ hap1 head2
  have hm2f := KeygenNttLoopSupport.bindPtr_result "r1".toList "a".toList
    KeygenNttButterflyPrograms.zero m1 ⟨mid2,.normal⟩ head2
  obtain ⟨p1b,ptr1b,he1b⟩ := hm2f
  have hm2 : mid2=C99ArrayReference.bindPointer m1 "r1".toList p1b := congrArg Result.state he1b
  subst mid2
  have hst2 : USlot (C99ArrayReference.bindPointer m1 "r1".toList p1b) "stride" σ := hst1
  have hhn2 : USlot (C99ArrayReference.bindPointer m1 "r1".toList p1b) "hn" 768 := hhn1
  have hap2 : PSlot (C99ArrayReference.bindPointer m1 "r1".toList p1b) "a" aP := by
    have ne : "a".toList≠"r1".toList := by decide
    simpa [PSlot,C99ArrayReference.bindPointer,ne] using hap1
  have h2 := bind_a_hn (C99ArrayReference.bindPointer m1 "r1".toList p1b) aP σ out hσ fit hap2
    hhn2 hst2 tail2
  obtain ⟨p2b,ptr2b,he2b⟩ := KeygenNttLoopSupport.bindPtr_result "r2".toList "a".toList
    _ (C99ArrayReference.bindPointer m1 "r1".toList p1b) out tail2
  subst out
  have hst3 : USlot (C99ArrayReference.bindPointer
      (C99ArrayReference.bindPointer m1 "r1".toList p1b) "r2".toList p2b) "stride" σ := hst2
  have hhn3 : USlot (C99ArrayReference.bindPointer
      (C99ArrayReference.bindPointer m1 "r1".toList p1b) "r2".toList p2b) "hn" 768 := hhn2
  refine ⟨rfl,?_,hst3,hhn3⟩
  refine ⟨?_,?_,?_,by decide⟩
  · exact hu
  · have key : {aP with index := aP.index+0*σ}={aP with index := aP.index} := by simp
    rw [key]
    exact h1
  · have key : {aP with index := aP.index+(768+0)*σ}={aP with index := aP.index+768*σ} := by
      simp
    rw [key]
    exact h2

/- The first butterfly body writes only its block locals and the heap. -/
def firstDecls : List B20.C.Name := ["a0","a1","b"].map String.toList
theorem first_decls : C99ModularParser.declarations
    KeygenNttButterflyPrograms.firstBody=firstDecls := by decide

theorem first_each : ∀ a ∈ KeygenNttButterflyPrograms.firstAtoms, ∀ s out,
    Exec a s out → ∃ ws : List B20.C.Name,
      KeygenNttLoopSupport.localOnly a=some ws ∧ KeygenNttLoopSupport.FrameOk ws s out ∧
        ∀ n, ws.contains n → firstDecls.contains n := by
  intro a hin s out source
  simp [KeygenNttButterflyPrograms.firstAtoms,List.mem_cons] at hin
  rcases hin with rfl|rfl|rfl|rfl|rfl|rfl
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact hn
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="a0".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="a1".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="b".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (contains_iff.mp hn)).elim
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (contains_iff.mp hn)).elim

theorem body_result (before : State) (result : Result)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody)
      before result) :
    result.flow=.normal ∧ result.state.arrays=before.arrays ∧ result.state.locals=before.locals :=
  KeygenNttLoopSupport.block_frame
    (C99ModularParser.declarations KeygenNttButterflyPrograms.firstBody)
    KeygenNttButterflyPrograms.firstAtoms before result source
    (by
      intro a hin s out hs
      obtain ⟨ws,hl,hf,hc⟩ := first_each a hin s out hs
      refine ⟨ws,hl,hf,?_⟩
      intro n hn
      rw [first_decls]
      exact hc n hn)

/- The loop increment `u ++, r1 += stride, r2 += stride`. -/
theorem u_update (s : State) (k : Nat) (out : Result)
    (hk : k+1<2^64) (counter : USlot s "u" k)
    (source : Exec (KeygenNttForwardPrograms.update "u" .add (KeygenNttForwardPrograms.num 1)) s out) :
    USlot out.state "u" (k+1) ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠"u".toList → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ := KeygenNttLoopSupport.update_result "u".toList .add
    (KeygenNttForwardPrograms.num 1) s out source
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans counter))
  subst ty
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v evaluated
  have hx1 : x=u64 k := KeygenNttLoopSupport.variable_u64 s "u" k x counter hx
  have hy1 : y=C99IntegerReference.convert .int32 1 :=
    KeygenNttLoopSupport.literal_i32 s 1 y hy
  subst x
  subst y
  have hv : v=u64 (k+1) := KeygenNttLoopSupport.add_one_literal k (by omega) v hop
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ ["u".toList] s out source rfl
  refine ⟨?_,frame.2.1,?_⟩
  · rw [he]
    have hcell : C99IntegerReference.convert .uint64 (u64 (k+1)).integer=u64 (k+1) :=
      KeygenNttLoopSupport.convert_u64_self (k+1) hk
    show (C99ScalarReference.set s.locals "u".toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 (k+1)).integer))) "u".toList=
      some (.uint64,some (u64 (k+1)))
    rw [hcell]
    simp [C99ScalarReference.set]
  · intro n hn
    exact frame.2.2 n (fun hh => hn (List.mem_singleton.mp (contains_iff.mp hh)))

theorem advance_result (s : State) (p1 p2 : ArrayPointer) (σ : Nat) (out : Result)
    (hσ : σ<2^64) (low : PSlot s "r1" p1) (high : PSlot s "r2" p2) (st : USlot s "stride" σ)
    (source : Exec KeygenNttForwardPrograms.pointerAdvance s out) :
    out.flow=.normal ∧ PSlot out.state "r1" {p1 with index := p1.index+σ} ∧
      PSlot out.state "r2" {p2 with index := p2.index+σ} ∧ out.state.locals=s.locals := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ s out source).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨p,_,he⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "r1".toList
      (.var "stride".toList) s out hr
    exact hexit (congrArg C99ProcedureReference.Result.flow he))
  have h1 := bind_stride "r1" s p1 σ ⟨mid,.normal⟩ hσ low st head
  obtain ⟨pb,pbnd,pbe⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "r1".toList
    (.var "stride".toList) s ⟨mid,.normal⟩ head
  have hm : mid=C99ArrayReference.bindPointer s "r1".toList pb := congrArg Result.state pbe
  subst mid
  have hst2 : USlot (C99ArrayReference.bindPointer s "r1".toList pb) "stride" σ := st
  have hhi2 : PSlot (C99ArrayReference.bindPointer s "r1".toList pb) "r2" p2 := by
    have ne : "r2".toList≠"r1".toList := by decide
    simpa [PSlot,C99ArrayReference.bindPointer,ne] using high
  have h2 := bind_stride "r2" (C99ArrayReference.bindPointer s "r1".toList pb) p2 σ out hσ
    hhi2 hst2 tail
  obtain ⟨p2b,pb2nd,pbe2⟩ := KeygenNttLoopSupport.bindPtr_result "r2".toList "r2".toList
    (.var "stride".toList) (C99ArrayReference.bindPointer s "r1".toList pb) out tail
  subst out
  exact ⟨rfl,h1,h2,rfl⟩

theorem step_result (s : State) (k σ : Nat) (p1 p2 : ArrayPointer) (out : Result)
    (hσ : σ<2^64) (hk1 : k+1<2^64)
    (counter : USlot s "u" k) (st : USlot s "stride" σ)
    (low : PSlot s "r1" p1) (high : PSlot s "r2" p2)
    (source : Exec (KeygenNttForwardPrograms.step "u") s out) :
    out.flow=.normal ∧ USlot out.state "u" (k+1) ∧
      PSlot out.state "r1" {p1 with index := p1.index+σ} ∧
      PSlot out.state "r2" {p2 with index := p2.index+σ} ∧
      ∀ n, n≠"u".toList → out.state.locals n=s.locals n := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ s out source).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.update_result "u".toList .add
      (KeygenNttForwardPrograms.num 1) s out hr
    exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨hu,harr,hloc⟩ := u_update s k ⟨mid,.normal⟩ hk1 counter head
  have st2 : USlot mid "stride" σ := (hloc "stride".toList (by decide)).trans st
  have low2 : PSlot mid "r1" p1 := ptr_keep harr "r1" p1 low
  have high2 : PSlot mid "r2" p2 := ptr_keep harr "r2" p2 high
  obtain ⟨flow,h1,h2,hadv⟩ := advance_result mid p1 p2 σ out hσ low2 high2 st2 tail
  exact ⟨flow,slot_keep hadv "u" (k+1) hu,h1,h2,
    fun n hn => (congrFun hadv n).trans (hloc n hn)⟩

theorem ptr_step (aP : ArrayPointer) (m d : Nat) :
    {{aP with index := m} with index := m+d}={aP with index := m+d} := by cases aP; rfl

/- The loop: after k iterations the counters and positions hold, with
   k ≤ 768 derived from the executed guard. The statement is kept general
   in `code` with an explicit `shape` equation (var-major inversion style),
   so the induction motive covers the recursive fields. -/
theorem loop_trace (aP : ArrayPointer) (σ : Nat) (code : Stmt) (before : State) (result : Result)
    (hσ : σ<2^64)
    (source : Exec code before result)
    (shape : code=.loop firstGuard
      (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody)
      (KeygenNttForwardPrograms.step "u"))
    (k : Nat) (hk : k≤768) (inv : FirstInv aP σ k before)
    (st : USlot before "stride" σ) (hn : USlot before "hn" 768) :
    result.flow=.normal ∧ FirstTrace aP σ k before result.state := by
  induction source generalizing k with
  | base | assign | store32 | seqNormal | seqExit | scope | branchTrue | branchFalse | ret | retVoid =>
      cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      refine ⟨rfl,.done k before (guard_false before k 768 v (by omega) (by decide)
        inv.counter hn guard zero) inv⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      have strict := guard_true before k 768 v (by omega) (by decide) inv.counter hn guard nonzero
      obtain ⟨bflow,barr,bloc⟩ := body_result before ⟨middle,.normal⟩ iteration
      have invm : FirstInv aP σ k middle := by
        refine ⟨?_,?_,?_,inv.bound⟩
        · exact slot_keep bloc "u" k inv.counter
        · exact ptr_keep barr "r1" _ inv.low
        · exact ptr_keep barr "r2" _ inv.high
      have st2 : USlot middle "stride" σ := slot_keep bloc "stride" σ st
      have hn2 : USlot middle "hn" 768 := slot_keep bloc "hn" 768 hn
      obtain ⟨sflow,hu,h1,h2,hlocal⟩ := step_result middle k σ _ _ ⟨next,.normal⟩ hσ
        (by omega : k+1<2^64) invm.counter st2 invm.low invm.high update
      have invn : FirstInv aP σ (k+1) next := by
        refine ⟨hu,?_,?_,by omega⟩
        · have key : {aP with index := aP.index+(k+1)*σ}=
              {{aP with index := aP.index+k*σ} with index := aP.index+k*σ+σ} := by
            have hz : aP.index+(k+1)*σ=aP.index+k*σ+σ := by ring
            cases aP
            simp [hz]
          rw [key,ptr_step]
          exact h1
        · have key : {aP with index := aP.index+(768+(k+1))*σ}=
              {{aP with index := aP.index+(768+k)*σ} with index := aP.index+(768+k)*σ+σ} := by
            have hz : aP.index+(768+(k+1))*σ=aP.index+(768+k)*σ+σ := by ring
            cases aP
            simp [hz]
          rw [key,ptr_step]
          exact h2
      have stn : USlot next "stride" σ := (hlocal "stride".toList (by decide)).trans st2
      have hnn : USlot next "hn" 768 := (hlocal "hn".toList (by decide)).trans hn2
      obtain ⟨flow,tail⟩ := ih3 rfl (k+1) (by omega) invn stn hnn
      exact ⟨flow,.next k before middle next result.state strict inv iteration update tail⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      cases shape
      obtain ⟨bflow,_,_⟩ := body_result before ⟨after,.returned (some value)⟩ iteration
      cases bflow

theorem first_result (aP : ArrayPointer) (σ : Nat) (before : State) (result : Result)
    (hσ : σ<2^64) (fit : 768*σ<2^64)
    (source : Exec KeygenNttForwardPrograms.firstLoop before result)
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (hn : USlot before "hn" 768) (st : USlot before "stride" σ) (ap : PSlot before "a" aP) :
    result.flow=.normal ∧
      ∃ s0, FirstInv aP σ 0 s0 ∧ FirstTrace aP σ 0 s0 result.state := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before result source).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨flow,_,_,_⟩ := init_result aP σ before _ hσ fit uc hn st ap hr
    exact hexit flow)
  obtain ⟨iflow,inv0,st0,hn0⟩ := init_result aP σ before _ hσ fit uc hn st ap head
  obtain ⟨flow,trace⟩ := loop_trace aP σ _ mid result hσ tail rfl 0 (by decide) inv0 st0 hn0
  exact ⟨flow,mid,inv0,trace⟩

end FT1536.Source3.KeygenNttFirstLoop
