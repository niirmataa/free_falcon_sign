import Source3.KeygenNttFirstLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Loop counters and pointer positions of the forward-NTT TRIPLE pass,
   extracted from an Exec derivation of the parsed `tripleLoop` (B1.02
   remainder 2.1.1, third bullet): after k iterations `u ↦ 3k`,
   `r ↦ 2^9+k`, `r1 = a + k*(3*stride)` with k ≤ 512. The r initializer is
   the executed `(size_t)1 << (logn - 1)` = 2^9 on the M0 path (logn=10),
   and the guard `u < n` is exactly `C99CountedWords.condition` with
   n=1536. No value/range/polynomial invariant (B1.04). The stride
   magnitude σ stays symbolic under the explicit premise 3*σ < 2^64 for
   the executed `3*stride` index product; stride=1 instantiation remains
   B1.07 work. -/
namespace FT1536.Source3.KeygenNttTripleLoop
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open C99MemoryReference (ArrayPointer)
open KeygenNttLoopSupport (u64 USlot PSlot contains_iff)

def tripleGuard : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "n".toList)
theorem guard_shape : tripleGuard=C99CountedWords.condition := rfl

structure TripleInv (aP : ArrayPointer) (σ k : Nat) (s : State) : Prop where
  counter : USlot s "u" (3*k)
  rev : USlot s "r" (512+k)
  pos : PSlot s "r1" {aP with index := aP.index+k*(3*σ)}
  bound : k≤512

inductive TripleTrace (aP : ArrayPointer) (σ : Nat) : Nat → State → State → Prop where
  | done (k : Nat) (s : State) (stop : ¬3*k<1536) (inv : TripleInv aP σ k s) :
      TripleTrace aP σ k s s
  | next (k : Nat) (before mid after fin : State) (guard : 3*k<1536)
      (inv : TripleInv aP σ k before)
      (iteration : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody)
        before ⟨mid,.normal⟩)
      (update : Exec KeygenNttForwardPrograms.tripleStep mid ⟨after,.normal⟩)
      (rest : TripleTrace aP σ (k+1) after fin) :
      TripleTrace aP σ k before fin

/- The `3*stride` index product of the executed advance. -/
theorem times_three (y : Nat) (hy : y<2^64) (v : Value)
    (h : C99IntegerReference.ArithmeticExec .times (C99IntegerReference.convert .int32 3)
      (u64 y) v) : v=u64 (3*y) := by
  obtain ⟨safe,he⟩ := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp h)
  have htype : C99IntegerReference.usual
      (C99IntegerReference.promote (C99IntegerReference.convert .int32 3).type)
      (C99IntegerReference.promote (u64 y).type)=.uint64 := rfl
  rw [htype] at he
  have hc : (C99IntegerReference.convert .int32 3).integer=(3 : Int) := by decide
  have hinner : C99IntegerReference.convert .uint64 (C99IntegerReference.convert .int32 3).integer=u64 3 := by decide
  rw [hinner,KeygenNttLoopSupport.convert_u64_self y hy] at he
  rw [KeygenNttLoopSupport.u64_integer 3 (by decide),KeygenNttLoopSupport.u64_integer y hy,
    KeygenNttLoopSupport.exact_times] at he
  rw [he,← Int.natCast_mul,KeygenNttLoopSupport.convert_u64_nat]

/- The executed r initializer `(size_t)1 << (logn - 1)` = 2^9 (logn=10). -/
theorem minus_one_value (s : State) (v : Value) (lg : KeygenNttForwardExec.lognAt s)
    (source : C99ArrayReference.scalar s (.bin .sub (KeygenNttForwardPrograms.var "logn")
      (KeygenNttForwardPrograms.num 1)) v) :
    v=C99IntegerReference.convert .uint32 9 := by
  change C99ScalarReference.Eval _ _
    (.arithmetic .minus (.variable "logn".toList) (.literal .int32 1)) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .minus _ _ v source
  have hx1 : x=.uint32 10 :=
    C99CountedWords.variable_exact s "logn".toList .uint32 (.uint32 10) x lg hx
  have hy1 : y=C99IntegerReference.convert .int32 1 :=
    KeygenNttLoopSupport.literal_i32 s 1 y hy
  subst x
  subst y
  have he := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp hop).2
  have hc : (C99IntegerReference.convert .int32 1).integer=(1 : Int) := by decide
  rw [hc] at he
  rw [he]
  decide

theorem rinit_value (s : State) (v : Value) (lg : KeygenNttForwardExec.lognAt s)
    (source : C99ArrayReference.scalar s (.bin .shl (.cast .u64 (KeygenNttForwardPrograms.num 1))
      (.bin .sub (KeygenNttForwardPrograms.var "logn") (KeygenNttForwardPrograms.num 1))) v) :
    v=u64 512 := by
  change C99ScalarReference.Eval _ _
    (.shift .left (.cast .uint64 (.literal .int32 1))
      (.arithmetic .minus (.variable "logn".toList) (.literal .int32 1))) v at source
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_shift s.locals .left _ _ v source
  obtain ⟨u,hsum,hcast⟩ := KeygenNttForwardExec.eval_cast s.locals .uint64 _ x hx
  have hu : u=C99IntegerReference.convert .int32 1 := KeygenNttLoopSupport.literal_i32 s 1 u hsum
  subst u
  have hxc : x=C99IntegerReference.convert .uint64 (C99IntegerReference.convert .int32 1).integer := by
    rw [hcast]
  have hxeq : x=u64 1 := by
    rw [hxc]
    decide
  subst x
  have hy1 : y=C99IntegerReference.convert .uint32 9 := minus_one_value s y lg hy
  subst y
  have hcount : (C99IntegerReference.convert .uint32 9).integer=(9 : Int) := by decide
  obtain ⟨n,hn,hb,he⟩ := KeygenNttForwardExec.shift_left_value _ _ v hop
  rw [hcount] at hn
  have hn9 : n=9 := by omega
  subst n
  rw [he]
  decide

/- tripleStep components. -/
theorem u_update3 (s : State) (k : Nat) (out : Result)
    (hk : 3*k+3<2^64) (counter : USlot s "u" (3*k))
    (source : Exec (KeygenNttForwardPrograms.update "u" .add (KeygenNttForwardPrograms.num 3)) s out) :
    USlot out.state "u" (3*k+3) ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠"u".toList → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ := KeygenNttLoopSupport.update_result "u".toList .add
    (KeygenNttForwardPrograms.num 3) s out source
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans counter))
  subst ty
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v evaluated
  have hx1 : x=u64 (3*k) := KeygenNttLoopSupport.variable_u64 s "u" (3*k) x counter hx
  have hy1 : y=C99IntegerReference.convert .int32 3 :=
    KeygenNttLoopSupport.literal_i32 s 3 y hy
  subst x
  subst y
  have hv : v=u64 (3*k+3) := KeygenNttLoopSupport.add_three_literal (3*k) (by omega) v hop
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ ["u".toList] s out source rfl
  refine ⟨?_,frame.2.1,?_⟩
  · rw [he]
    have hcell : C99IntegerReference.convert .uint64 (u64 (3*k+3)).integer=u64 (3*k+3) :=
      KeygenNttLoopSupport.convert_u64_self (3*k+3) hk
    show (C99ScalarReference.set s.locals "u".toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 (3*k+3)).integer))) "u".toList=
      some (.uint64,some (u64 (3*k+3)))
    rw [hcell]
    simp [C99ScalarReference.set]
  · intro n hn
    exact frame.2.2 n (fun hh => hn (List.mem_singleton.mp (contains_iff.mp hh)))

theorem r_update (s : State) (k : Nat) (out : Result)
    (hk : 512+k+1<2^64) (rev : USlot s "r" (512+k))
    (source : Exec (KeygenNttForwardPrograms.update "r" .add (KeygenNttForwardPrograms.num 1)) s out) :
    USlot out.state "r" (512+k+1) ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠"r".toList → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ := KeygenNttLoopSupport.update_result "r".toList .add
    (KeygenNttForwardPrograms.num 1) s out source
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans rev))
  subst ty
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v evaluated
  have hx1 : x=u64 (512+k) := KeygenNttLoopSupport.variable_u64 s "r" (512+k) x rev hx
  have hy1 : y=C99IntegerReference.convert .int32 1 :=
    KeygenNttLoopSupport.literal_i32 s 1 y hy
  subst x
  subst y
  have hv : v=u64 (512+k+1) := KeygenNttLoopSupport.add_one_literal (512+k) (by omega) v hop
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ ["r".toList] s out source rfl
  refine ⟨?_,frame.2.1,?_⟩
  · rw [he]
    have hcell : C99IntegerReference.convert .uint64 (u64 (512+k+1)).integer=u64 (512+k+1) :=
      KeygenNttLoopSupport.convert_u64_self (512+k+1) hk
    show (C99ScalarReference.set s.locals "r".toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 (512+k+1)).integer))) "r".toList=
      some (.uint64,some (u64 (512+k+1)))
    rw [hcell]
    simp [C99ScalarReference.set]
  · intro n hn
    exact frame.2.2 n (fun hh => hn (List.mem_singleton.mp (contains_iff.mp hh)))

theorem rinit_result (s : State) (out : Result)
    (rc : ∃ old, s.locals "r".toList=some (.uint64,old)) (lg : KeygenNttForwardExec.lognAt s)
    (source : Exec KeygenNttForwardPrograms.rInit s out) :
    USlot out.state "r" 512 ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠"r".toList → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ := KeygenNttLoopSupport.assign_result "r".toList _ s out source
  obtain ⟨oldr,rcl⟩ := rc
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans rcl))
  subst ty
  have hv : v=u64 512 := by
    have inner := KeygenNttForwardExec.eval_scalar s _ v evaluated
    exact rinit_value s v lg inner
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ ["r".toList] s out source rfl
  refine ⟨?_,frame.2.1,?_⟩
  · rw [he]
    have hcell : C99IntegerReference.convert .uint64 (u64 512).integer=u64 512 :=
      KeygenNttLoopSupport.convert_u64_self 512 (by decide)
    show (C99ScalarReference.set s.locals "r".toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 512).integer))) "r".toList=
      some (.uint64,some (u64 512))
    rw [hcell]
    simp [C99ScalarReference.set]
  · intro n hn
    exact frame.2.2 n (fun hh => hn (List.mem_singleton.mp (contains_iff.mp hh)))

theorem bind_three_stride (s : State) (p : ArrayPointer) (σ : Nat) (out : Result)
    (hσ : σ<2^64) (fit : 3*σ<2^64) (slot : PSlot s "r1" p) (st : USlot s "stride" σ)
    (source : Exec (KeygenNttForwardPrograms.bind "r1" "r1"
      (.bin .mul (KeygenNttForwardPrograms.num 3) (KeygenNttForwardPrograms.var "stride"))) s out) :
    PSlot out.state "r1" {p with index := p.index+3*σ} := by
  obtain ⟨q,ptr,he⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "r1".toList _ s out source
  subst out
  obtain ⟨i,ev,hroot⟩ := KeygenNttLoopSupport.pointer_root s "r1".toList _ p q slot ptr
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .times _ _ i ev
  have hx1 : x=C99IntegerReference.convert .int32 3 := KeygenNttLoopSupport.literal_i32 s 3 x hx
  have hy1 : y=u64 σ := KeygenNttLoopSupport.variable_u64 s "stride" σ y st hy
  subst x
  subst y
  have hi : i=u64 (3*σ) := times_three σ hσ i hop
  subst i
  rw [hroot,KeygenNttLoopSupport.u64_toNat (3*σ) fit]
  simp [PSlot,C99ArrayReference.bindPointer]

/- tripleInit chain: u := 0, r := 2^9, r1 := a + 0. -/
theorem init_result (aP : ArrayPointer) (σ : Nat) (before : State) (out : Result)
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (rc : ∃ old, before.locals "r".toList=some (.uint64,old))
    (lg : KeygenNttForwardExec.lognAt before) (st : USlot before "stride" σ)
    (ap : PSlot before "a" aP)
    (source : Exec KeygenNttForwardPrograms.tripleInit before out) :
    out.flow=.normal ∧ TripleInv aP σ 0 out.state ∧ USlot out.state "stride" σ ∧
      KeygenNttForwardExec.lognAt out.state ∧
      ∀ n, n≠"u".toList → n≠"r".toList → out.state.locals n=before.locals n := by
  obtain ⟨mid1,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before out source).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.assign_result "u".toList _ before out hr
    exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨ty,old,v,declared,evaluated,he⟩ :=
    KeygenNttLoopSupport.assign_result "u".toList _ before ⟨mid1,.normal⟩ head
  obtain ⟨oldu,ucl⟩ := uc
  obtain ⟨oldr,rcl⟩ := rc
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
  have hlg1 : KeygenNttForwardExec.lognAt m1 := by
    show (C99ScalarReference.set before.locals "u".toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer))) "logn".toList=_
    simp [C99ScalarReference.set]
    exact lg
  have hrc1 : ∃ old, m1.locals "r".toList=some (.uint64,old) := by
    refine ⟨oldr,?_⟩
    show (C99ScalarReference.set before.locals "u".toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer))) "r".toList=_
    simp [C99ScalarReference.set]
    exact rcl
  have hap1 : PSlot m1 "a" aP := by
    show m1.arrays "a".toList=_
    exact ap
  have hm1keep : ∀ n, n≠"u".toList → m1.locals n=before.locals n := by
    intro n hn
    show (if n="u".toList then
      some (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer)) else before.locals n)=before.locals n
    split_ifs with h
    · exact (hn h).elim
    · rfl
  obtain ⟨mid2,head2,tail2⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 out tail).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨ty,old,v,declared,evaluated,he2⟩ := KeygenNttLoopSupport.assign_result "r".toList _ m1 out hr
    exact hexit (congrArg C99ProcedureReference.Result.flow he2))
  obtain ⟨hrev,harr1,hloc1⟩ := rinit_result m1 ⟨mid2,.normal⟩ hrc1 hlg1 head2
  have hst2 : USlot mid2 "stride" σ := (hloc1 "stride".toList (by decide)).trans hst1
  have hlg2 : KeygenNttForwardExec.lognAt mid2 :=
    (hloc1 "logn".toList (by decide)).trans hlg1
  have hap2 : PSlot mid2 "a" aP := KeygenNttFirstLoop.ptr_keep harr1 "a" aP hap1
  have hu2 : USlot mid2 "u" 0 := (hloc1 "u".toList (by decide)).trans hu
  have h1 := KeygenNttFirstLoop.bind_a_zero mid2 aP out hap2 tail2
  obtain ⟨p2b,ptr2b,he2b⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "a".toList
    KeygenNttButterflyPrograms.zero mid2 out tail2
  subst out
  refine ⟨rfl,?_,hst2,hlg2,?_⟩
  · refine ⟨?_,?_,?_,by decide⟩
    · exact hu2
    · exact hrev
    · have key : {aP with index := aP.index+0*(3*σ)}={aP with index := aP.index} := by simp
      rw [key]
      exact h1
  · intro n hnu hnr
    show (C99ArrayReference.bindPointer mid2 "r1".toList p2b).locals n=_
    exact (hloc1 n hnr).trans (hm1keep n hnu)

/- The triple butterfly body writes only its block locals and the heap. -/
def tripleDecls : List B20.C.Name :=
  ["fA","fB","fC","fB0","fB1","fB2","fC0","fC1","fC2"].map String.toList ++
    ["x","x2"].map String.toList
theorem triple_decls : C99ModularParser.declarations
    KeygenNttButterflyPrograms.tripleBody=tripleDecls := by decide

theorem triple_each : ∀ a ∈ KeygenNttButterflyPrograms.tripleAtoms, ∀ s out,
    Exec a s out → ∃ ws : List B20.C.Name,
      KeygenNttLoopSupport.localOnly a=some ws ∧ KeygenNttLoopSupport.FrameOk ws s out ∧
        ∀ n, ws.contains n → tripleDecls.contains n := by
  intro a hin s out source
  simp [KeygenNttButterflyPrograms.tripleAtoms,List.mem_cons] at hin
  rcases hin with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact contains_iff.mpr (List.mem_append.mpr (Or.inl (contains_iff.mp hn)))
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact contains_iff.mpr (List.mem_append.mpr (Or.inr (contains_iff.mp hn)))
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="x".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="x2".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fA".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fB".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fC".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fB0".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fB1".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fB2".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fC0".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fC1".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="fC2".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (contains_iff.mp hn)).elim
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (contains_iff.mp hn)).elim
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (contains_iff.mp hn)).elim

theorem body_result (before : State) (result : Result)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody)
      before result) :
    result.flow=.normal ∧ result.state.arrays=before.arrays ∧ result.state.locals=before.locals :=
  KeygenNttLoopSupport.block_frame
    (C99ModularParser.declarations KeygenNttButterflyPrograms.tripleBody)
    KeygenNttButterflyPrograms.tripleAtoms before result source
    (by
      intro a hin s out hs
      obtain ⟨ws,hl,hf,hc⟩ := triple_each a hin s out hs
      refine ⟨ws,hl,hf,?_⟩
      intro n hn
      rw [triple_decls]
      exact hc n hn)

/- The tripleStep chain: u += 3, r ++, r1 += 3*stride. -/
theorem step_result (s : State) (k σ : Nat) (p : ArrayPointer) (out : Result)
    (hσ : σ<2^64) (fit : 3*σ<2^64) (hk1 : 3*k+3<2^64) (hr1 : 512+k+1<2^64)
    (counter : USlot s "u" (3*k)) (rev : USlot s "r" (512+k)) (st : USlot s "stride" σ)
    (low : PSlot s "r1" p)
    (source : Exec KeygenNttForwardPrograms.tripleStep s out) :
    out.flow=.normal ∧ USlot out.state "u" (3*k+3) ∧ USlot out.state "r" (512+k+1) ∧
      PSlot out.state "r1" {p with index := p.index+3*σ} ∧
      ∀ n, n≠"u".toList → n≠"r".toList → out.state.locals n=s.locals n := by
  obtain ⟨mid1,head1,tail1⟩ := (KeygenNttForwardExec.seq_inv _ _ s out source).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.update_result "u".toList .add
      (KeygenNttForwardPrograms.num 3) s out hr
    exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨hu,harr1,hloc1⟩ := u_update3 s k ⟨mid1,.normal⟩ hk1 counter head1
  have rev2 : USlot mid1 "r" (512+k) := (hloc1 "r".toList (by decide)).trans rev
  have st2 : USlot mid1 "stride" σ := (hloc1 "stride".toList (by decide)).trans st
  have low2 : PSlot mid1 "r1" p := KeygenNttFirstLoop.ptr_keep harr1 "r1" p low
  obtain ⟨mid2,head2,tail2⟩ := (KeygenNttForwardExec.seq_inv _ _ mid1 out tail1).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.update_result "r".toList .add
      (KeygenNttForwardPrograms.num 1) mid1 out hr
    exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨hrev,harr2,hloc2⟩ := r_update _ k ⟨mid2,.normal⟩ hr1 rev2 head2
  have st3 : USlot mid2 "stride" σ := (hloc2 "stride".toList (by decide)).trans st2
  have low3 : PSlot mid2 "r1" p := KeygenNttFirstLoop.ptr_keep harr2 "r1" p low2
  have hu2 : USlot mid2 "u" (3*k+3) := (hloc2 "u".toList (by decide)).trans hu
  have hkeep2 : ∀ n, n≠"u".toList → n≠"r".toList → mid2.locals n=s.locals n := by
    intro n hnu hnr
    exact (hloc2 n hnr).trans (hloc1 n hnu)
  obtain ⟨p3b,ptr3b,he3b⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "r1".toList
    _ mid2 out tail2
  subst out
  have h1 := bind_three_stride mid2 p σ ⟨C99ArrayReference.bindPointer mid2 "r1".toList p3b,.normal⟩
    hσ fit low3 st3 tail2
  refine ⟨rfl,?_,?_,h1,?_⟩
  · simpa [USlot,C99ArrayReference.bindPointer] using hu2
  · simpa [USlot,C99ArrayReference.bindPointer] using hrev
  · intro n hnu hnr
    simpa [C99ArrayReference.bindPointer] using hkeep2 n hnu hnr

theorem ptr_step (aP : ArrayPointer) (m d : Nat) :
    {{aP with index := m} with index := m+d}={aP with index := m+d} := by cases aP; rfl

/- The loop: after k iterations `u ↦ 3k`, `r ↦ 2^9+k`, `r1 = a + k*(3*stride)`
   with k ≤ 512 from the executed guard. -/
theorem loop_trace (aP : ArrayPointer) (σ : Nat) (code : Stmt) (before : State) (result : Result)
    (hσ : σ<2^64) (fit : 3*σ<2^64)
    (source : Exec code before result)
    (shape : code=.loop tripleGuard (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody)
      KeygenNttForwardPrograms.tripleStep)
    (k : Nat) (hk : k≤512) (inv : TripleInv aP σ k before)
    (st : USlot before "stride" σ) (nSlot : USlot before "n" 1536) :
    result.flow=.normal ∧ TripleTrace aP σ k before result.state := by
  induction source generalizing k with
  | base | assign | store32 | storeRev | seqNormal | seqExit | scope | branchTrue | branchFalse | ret | retVoid =>
      cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      refine ⟨rfl,.done k before (C99CountedWords.guard_false before (3*k) v
        (by omega : 3*k≤1536) inv.counter (by exact nSlot)
        guard zero) inv⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      have strict := C99CountedWords.guard_true before (3*k) v
        (by omega : 3*k≤1536) inv.counter (by exact nSlot)
        guard nonzero
      have hkstrict : k<512 := by omega
      obtain ⟨bflow,barr,bloc⟩ := body_result before ⟨middle,.normal⟩ iteration
      have invm : TripleInv aP σ k middle := by
        refine ⟨?_,?_,?_,inv.bound⟩
        · exact KeygenNttFirstLoop.slot_keep bloc "u" (3*k) inv.counter
        · exact KeygenNttFirstLoop.slot_keep bloc "r" (512+k) inv.rev
        · exact KeygenNttFirstLoop.ptr_keep barr "r1" _ inv.pos
      have st2 : USlot middle "stride" σ := KeygenNttFirstLoop.slot_keep bloc "stride" σ st
      obtain ⟨sflow,hu,hrev,h1,hkeep⟩ := step_result middle k σ _ ⟨next,.normal⟩ hσ fit
        (by omega : 3*k+3<2^64) (by omega : 512+k+1<2^64)
        invm.counter invm.rev st2 invm.pos update
      have invn : TripleInv aP σ (k+1) next := by
        refine ⟨?_,?_,?_,by omega⟩
        · have key : (3*(k+1):Nat)=3*k+3 := by ring
          rw [key]
          exact hu
        · have key : (512+(k+1):Nat)=512+k+1 := by omega
          rw [key]
          exact hrev
        · have key : {aP with index := aP.index+(k+1)*(3*σ)}=
              {{aP with index := aP.index+k*(3*σ)} with index := aP.index+k*(3*σ)+3*σ} := by
            have hz : aP.index+(k+1)*(3*σ)=aP.index+k*(3*σ)+3*σ := by ring
            cases aP
            simp [hz]
          rw [key,ptr_step]
          exact h1
      have stn : USlot next "stride" σ := (hkeep "stride".toList (by decide) (by decide)).trans st2
      have nsn : USlot next "n" 1536 := (hkeep "n".toList (by decide) (by decide)).trans
        (KeygenNttFirstLoop.slot_keep bloc "n" 1536 nSlot)
      obtain ⟨flow,tail⟩ := ih3 rfl (k+1) (by omega) invn stn nsn
      exact ⟨flow,.next k before middle next result.state strict inv iteration update tail⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      cases shape
      obtain ⟨bflow,_,_⟩ := body_result before ⟨after,.returned (some value)⟩ iteration
      cases bflow

theorem triple_result (aP : ArrayPointer) (σ : Nat) (before : State) (result : Result)
    (hσ : σ<2^64) (fit : 3*σ<2^64)
    (source : Exec KeygenNttForwardPrograms.tripleLoop before result)
    (uc : ∃ old, before.locals "u".toList=some (.uint64,old))
    (rc : ∃ old, before.locals "r".toList=some (.uint64,old))
    (lg : KeygenNttForwardExec.lognAt before) (nSlot : USlot before "n" 1536)
    (st : USlot before "stride" σ) (ap : PSlot before "a" aP) :
    result.flow=.normal ∧
      ∃ s0, TripleInv aP σ 0 s0 ∧ TripleTrace aP σ 0 s0 result.state := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before result source).resolve_right (by
    rintro ⟨r,hr,hexit,heq⟩
    subst r
    obtain ⟨flow,_,_,_,_⟩ := init_result aP σ before _ uc rc lg st ap hr
    exact hexit flow)
  obtain ⟨iflow,inv0,st0,lg0,keep0⟩ := init_result aP σ before _ uc rc lg st ap head
  have n0 : USlot mid "n" 1536 := (keep0 "n".toList (by decide) (by decide)).trans nSlot
  obtain ⟨flow,trace⟩ := loop_trace aP σ _ mid result hσ fit tail rfl 0 (by decide) inv0 st0 n0
  exact ⟨flow,mid,inv0,trace⟩

end FT1536.Source3.KeygenNttTripleLoop
