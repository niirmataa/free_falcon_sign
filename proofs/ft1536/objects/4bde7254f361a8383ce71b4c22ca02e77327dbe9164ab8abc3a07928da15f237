import Source3.KeygenNttMiddleLoops

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Loop counters of the forward-NTT INTERMEDIATE passes, part 2 of the
   second bullet of B1.02 remainder 2.1.1: the u1-loop counters
   (u1 ↦ j, v1 ↦ j*t per round with j ≤ m) and the doubling outer rounds
   (m ↦ 2^(i+1), t ↦ 768/2^i with the executed t = ht = t >> 1 halving),
   with the guards `u1 < m` and `mGuard : t > 1+(full<<1)`, and the
   derived bounds m ≤ 2^8, t ≤ 768 (round count from the t halving) and
   the 2^18 class of v1 = j*t so that ONE premise 2^18*σ < 2^64
   discharges the two non-overflow premises (v1*σ < 2^64 and
   ht*σ < 2^64) of the nested u1Inner runs at the pass level. The
   compositions u1_result, round_result and intermediate_result close
   2.1.1-second; their traces carry the nested v-loop runs per round.
   The relation t*m=n is B1.04 and is NOT used here; no value/range/
   polynomial invariant (B1.04) and no stride=1 claim (B1.07) either. -/
namespace FT1536.Source3.KeygenNttMiddleRounds
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open C99MemoryReference (ArrayPointer)
open KeygenNttLoopSupport (u64 USlot PSlot contains_iff)

/- ## Bounds from the round count (the t halving), never t*m=n

   At an active round the executed guard reads 3 < t with t = 768/2^i,
   hence 4*2^i ≤ 768 and i ≤ 7. With the doubling m = 2^(i+1) and the
   halving t = 768/2^i this yields m ≤ 2^8, t ≤ 768 and the 2^18 class
   for every v1 = j*t with j ≤ m and for ht = t/2. -/
theorem div_mul_le (a b : Nat) : a/b*b≤a := Nat.div_mul_le_self a b

theorem round_index_bound (i : Nat) (h : 3<768/2^i) : i≤7 := by
  by_contra hi
  have hi8 : 8 ≤ i := by omega
  have hpow : 2^8 ≤ 2^i := Nat.pow_le_pow_right (by decide) hi8
  have hlit : (2^8 : Nat)=256 := by decide
  rw [hlit] at hpow
  have hm : (4:Nat)*256 ≤ 4*2^i := Nat.mul_le_mul_left 4 hpow
  have h1024 : (4*256 : Nat)=1024 := by decide
  rw [h1024] at hm
  have h4 : (4:Nat)≤768/2^i := by omega
  have hmul : 4*2^i≤(768/2^i)*2^i := Nat.mul_le_mul_right _ h4
  have hle : (768/2^i)*2^i≤768 := div_mul_le 768 (2^i)
  omega

theorem m_round_bound (i : Nat) (h : 3<768/2^i) : 2^(i+1)≤2^8 :=
  Nat.pow_le_pow_right (by decide) (by
    have hi : i≤7 := round_index_bound i h
    omega)

theorem t_round_bound (i : Nat) : 768/2^i≤768 := Nat.div_le_self 768 (2^i)

theorem ht_round_bound (i : Nat) : (768/2^i)/2≤2^18 := by
  have h1 : (768/2^i)/2≤768/2^i := Nat.div_le_self (768/2^i) 2
  have h2 : 768/2^i≤768 := t_round_bound i
  have h3 : (768:Nat)≤2^18 := by decide
  omega

theorem v1_class (mVal tVal j : Nat) (hm : mVal≤2^8) (ht : tVal≤768) (hj : j≤mVal) :
    j*tVal≤2^18 :=
  calc j*tVal ≤ mVal*tVal := Nat.mul_le_mul_right _ hj
    _ ≤ mVal*768 := Nat.mul_le_mul_left _ ht
    _ ≤ 2^8*768 := Nat.mul_le_mul_right _ hm
    _ ≤ 2^18 := by decide

theorem v1_round_bound (i j : Nat) (h : 3<768/2^i) (hj : j≤2^(i+1)) :
    j*(768/2^i)≤2^18 :=
  v1_class (2^(i+1)) (768/2^i) j (m_round_bound i h) (t_round_bound i) hj

theorem fit18 (a σ : Nat) (ha : a≤2^18) (h18 : 2^18*σ<2^64) : a*σ<2^64 := by
  have hle : a*σ≤2^18*σ := Nat.mul_le_mul_right σ ha
  omega

theorem lt64_18 (a : Nat) (ha : a≤2^18) : a<2^64 := by
  have h : (2^18:Nat)<2^64 := by decide
  omega

theorem halve_eq (i : Nat) : (768/2^i)/2=768/2^(i+1) := by
  rw [Nat.div_div_eq_div_mul]
  have hp : 2^(i+1)=2^i*2 := Nat.pow_succ 2 i
  rw [← hp]

theorem pow_double (i : Nat) : 2^(i+1)*2=2^((i+1)+1) := (Nat.pow_succ 2 (i+1)).symm

theorem mul_two_fit (i : Nat) (h : 3<768/2^i) : 2^(i+1)*2<2^64 := by
  have hle : 2^(i+1)*2≤2^8*2 := Nat.mul_le_mul_right 2 (m_round_bound i h)
  have h8 : (2^8*2:Nat)<2^64 := by decide
  omega

theorem base_half_bound (i : Nat) : (768/2^i)<2^64 :=
  lt64_18 _ (le_trans (t_round_bound i) (by decide : (768:Nat)≤2^18))

theorem ht_half_bound (i : Nat) : ((768/2^i)/2)<2^64 := lt64_18 _ (ht_round_bound i)

theorem m_u64_bound (i : Nat) (h : 3<768/2^i) : 2^(i+1)<2^64 :=
  lt64_18 _ (le_trans (m_round_bound i h) (by decide : (2^8:Nat)≤2^18))

/- ## The mGuard `t > 1+(full<<1)` on the M0 path (full=1: `t > 3`) -/
theorem mguard_value (s : State) (T : Nat) (v : Value)
    (hT : T<2^64) (tc : USlot s "t" T) (full : KeygenNttForwardExec.fullAt s)
    (source : C99ArrayReference.scalar s KeygenNttForwardPrograms.mGuard v) :
    v=C99ScalarReference.boolean (decide (3<T)) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (.compare .gt (.variable "t".toList)
      (.arithmetic .plus (.literal .int32 1)
        (.shift .left (.variable "full".toList) (.literal .int32 1)))) v at source
  obtain ⟨a,b,ha,hb,hop⟩ := KeygenNttForwardExec.eval_compare s.locals .gt _ _ v source
  have ha1 : a=u64 T := KeygenNttLoopSupport.variable_u64 s "t" T a tc ha
  have hb1 : b=C99IntegerReference.convert .uint32 3 :=
    KeygenNttForwardExec.plus_three_value s b full hb
  subst a
  subst b
  rw [C99CountedWords.comparison_result .gt (u64 T)
    (C99IntegerReference.convert .uint32 3) v hop]
  have husual : C99IntegerReference.usual (u64 T).type
      (C99IntegerReference.convert .uint32 3).type=.uint64 := rfl
  rw [husual]
  have hx : C99IntegerReference.convert .uint64 (u64 T).integer=u64 T :=
    KeygenNttLoopSupport.convert_u64_self T hT
  rw [hx,KeygenNttLoopSupport.u64_integer T hT]
  have hy : C99IntegerReference.convert .uint64
      (C99IntegerReference.convert .uint32 3).integer=u64 3 := by decide
  rw [hy,KeygenNttLoopSupport.u64_integer 3 (by decide)]
  show C99ScalarReference.boolean
      (C99IntegerReference.compare .gt (T:Int) (3:Int))=
    C99ScalarReference.boolean (decide (3<T))
  have hgt : C99IntegerReference.compare .gt (T:Int) (3:Int)=decide (3<T) := by
    simp [C99IntegerReference.compare]
  rw [hgt]

theorem mguard_true (s : State) (T : Nat) (v : Value)
    (hT : T<2^64) (tc : USlot s "t" T) (full : KeygenNttForwardExec.fullAt s)
    (source : C99ArrayReference.scalar s KeygenNttForwardPrograms.mGuard v)
    (nonzero : v.integer≠0) : 3<T := by
  rw [mguard_value s T v hT tc full source] at nonzero
  by_contra h
  simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero

theorem mguard_false (s : State) (T : Nat) (v : Value)
    (hT : T<2^64) (tc : USlot s "t" T) (full : KeygenNttForwardExec.fullAt s)
    (source : C99ArrayReference.scalar s KeygenNttForwardPrograms.mGuard v)
    (zero : v.integer=0) : ¬3<T := by
  rw [mguard_value s T v hT tc full source] at zero
  intro h
  simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero

theorem full_keep {s s' : State} (h : s'.locals "full".toList=s.locals "full".toList)
    (full : KeygenNttForwardExec.fullAt s) : KeygenNttForwardExec.fullAt s' :=
  h.trans full

/- ## Counter and assignment steps of the two loop levels -/
theorem add_var_result (name other : String) (x y : Nat) (s : State) (out : Result)
    (hx : x<2^64) (hy : y<2^64) (hxy : x+y<2^64)
    (slot : USlot s name x) (src : USlot s other y)
    (source : Exec (KeygenNttForwardPrograms.update name .add
      (KeygenNttForwardPrograms.var other)) s out) :
    out.flow=.normal ∧ USlot out.state name (x+y) ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠name.toList → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ := KeygenNttLoopSupport.update_result name.toList .add
    (KeygenNttForwardPrograms.var other) s out source
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
  subst ty
  obtain ⟨a,b,ha,hb,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v evaluated
  have ha1 : a=u64 x := KeygenNttLoopSupport.variable_u64 s name x a slot ha
  have hb1 : b=u64 y := KeygenNttLoopSupport.variable_u64 s other y b src hb
  subst a
  subst b
  have hv : v=u64 (x+y) := KeygenNttLoopSupport.plus_u64 x y hx hy v hop
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ [name.toList] s out source rfl
  refine ⟨congrArg C99ProcedureReference.Result.flow he,?_,frame.2.1,?_⟩
  · rw [he]
    have hcell : C99IntegerReference.convert .uint64 (u64 (x+y)).integer=u64 (x+y) :=
      KeygenNttLoopSupport.convert_u64_self (x+y) hxy
    show (C99ScalarReference.set s.locals name.toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 (x+y)).integer))) name.toList=
      some (.uint64,some (u64 (x+y)))
    rw [hcell]
    simp [C99ScalarReference.set]
  · intro n hn
    exact frame.2.2 n (fun hh => hn (List.mem_singleton.mp (contains_iff.mp hh)))

theorem u1_step_result (s : State) (j T : Nat) (out : Result)
    (hj1 : j+1<2^64) (hT : T<2^64) (hprod : j*T<2^64) (hsum : j*T+T<2^64)
    (u1c : USlot s "u1" j) (v1c : USlot s "v1" (j*T)) (tc : USlot s "t" T)
    (source : Exec KeygenNttForwardPrograms.u1Step s out) :
    out.flow=.normal ∧ USlot out.state "u1" (j+1) ∧ USlot out.state "v1" ((j+1)*T) ∧
      out.state.arrays=s.arrays ∧
      ∀ n, n≠"u1".toList ∧ n≠"v1".toList → out.state.locals n=s.locals n := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ s out source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.update_result "u1".toList .add
          (KeygenNttForwardPrograms.num 1) s out hr
        exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨hu,harr,hloc⟩ := KeygenNttMiddleLoops.counter_update "u1" s j ⟨mid,.normal⟩ hj1 u1c head
  have v1m : USlot mid "v1" (j*T) := (hloc "v1".toList (by decide)).trans v1c
  have tm : USlot mid "t" T := (hloc "t".toList (by decide)).trans tc
  obtain ⟨tflow,htv,harr2,hloc2⟩ := add_var_result "v1" "t" (j*T) T mid out hprod hT hsum
    v1m tm tail
  refine ⟨tflow,KeygenNttButterflyCalls.u64_keep (hloc2 "u1".toList (by decide)) hu,?_,
    harr2.trans harr,?_⟩
  · have key : j*T+T=(j+1)*T := by ring
    rw [← key]
    exact htv
  · intro n hn
    exact (hloc2 n hn.2).trans (hloc n hn.1)

theorem shift_update (name : String) (x : Nat) (s : State) (out : Result)
    (hx : x<2^64) (hxy : x*2<2^64) (slot : USlot s name x)
    (source : Exec (KeygenNttForwardPrograms.update name .shl
      (KeygenNttForwardPrograms.num 1)) s out) :
    out.flow=.normal ∧ USlot out.state name (x*2) ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠name.toList → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ := KeygenNttLoopSupport.update_result name.toList .shl
    (KeygenNttForwardPrograms.num 1) s out source
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
  subst ty
  obtain ⟨a,b,ha,hb,hop⟩ := KeygenNttForwardExec.eval_shift s.locals .left _ _ v evaluated
  have ha1 : a=u64 x := KeygenNttLoopSupport.variable_u64 s name x a slot ha
  have hb1 : b=C99IntegerReference.convert .int32 1 :=
    KeygenNttLoopSupport.literal_i32 s 1 b hb
  subst a
  subst b
  have hv : v=u64 (x*2) := KeygenNttLoopSupport.shl_one_u64 x hx v hop
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ [name.toList] s out source rfl
  refine ⟨congrArg C99ProcedureReference.Result.flow he,?_,frame.2.1,?_⟩
  · rw [he]
    have hcell : C99IntegerReference.convert .uint64 (u64 (x*2)).integer=u64 (x*2) :=
      KeygenNttLoopSupport.convert_u64_self (x*2) hxy
    show (C99ScalarReference.set s.locals name.toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 (x*2)).integer))) name.toList=
      some (.uint64,some (u64 (x*2)))
    rw [hcell]
    simp [C99ScalarReference.set]
  · intro n hn
    exact frame.2.2 n (fun hh => hn (List.mem_singleton.mp (contains_iff.mp hh)))

theorem mstep_result (s : State) (M : Nat) (out : Result)
    (hM : M<2^64) (h2 : M*2<2^64) (mc : USlot s "m" M)
    (source : Exec KeygenNttForwardPrograms.mStep s out) :
    out.flow=.normal ∧ USlot out.state "m" (M*2) ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠"m".toList → out.state.locals n=s.locals n :=
  shift_update "m" M s out hM h2 mc source

theorem assign_nat_result (name : String) (n : Nat) (s : State) (out : Result)
    (cell : ∃ old, s.locals name.toList=some (.uint64,old))
    (hconv : C99IntegerReference.convert .uint64
      (C99IntegerReference.convert .int32 n).integer=u64 n)
    (source : Exec (.assign name.toList (.scalar (KeygenNttForwardPrograms.num n))) s out) :
    out.flow=.normal ∧ USlot out.state name n ∧ out.state.arrays=s.arrays ∧
      ∀ m, m≠name.toList → out.state.locals m=s.locals m := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ :=
    KeygenNttLoopSupport.assign_result name.toList _ s out source
  obtain ⟨oldv,hcell⟩ := cell
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans hcell))
  subst ty
  have hv : v=C99IntegerReference.convert .int32 n := by
    have inner := KeygenNttForwardExec.eval_scalar s _ v evaluated
    exact KeygenNttLoopSupport.literal_i32 s n v inner
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ [name.toList] s out source rfl
  refine ⟨congrArg C99ProcedureReference.Result.flow he,?_,frame.2.1,?_⟩
  · rw [he]
    show (C99ScalarReference.set s.locals name.toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 n).integer))) name.toList=
      some (.uint64,some (u64 n))
    rw [hconv]
    simp [C99ScalarReference.set]
  · intro m hm
    exact frame.2.2 m (fun hh => hm (List.mem_singleton.mp (contains_iff.mp hh)))

theorem assign_var_result (name other : String) (y : Nat) (s : State) (out : Result)
    (hy : y<2^64) (cell : ∃ old, s.locals name.toList=some (.uint64,old))
    (src : USlot s other y)
    (source : Exec (.assign name.toList (.scalar (KeygenNttForwardPrograms.var other))) s out) :
    out.flow=.normal ∧ USlot out.state name y ∧ out.state.arrays=s.arrays ∧
      ∀ m, m≠name.toList → out.state.locals m=s.locals m := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ :=
    KeygenNttLoopSupport.assign_result name.toList _ s out source
  obtain ⟨oldv,hcell⟩ := cell
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans hcell))
  subst ty
  have hv : v=u64 y := by
    have inner := KeygenNttForwardExec.eval_scalar s _ v evaluated
    exact KeygenNttLoopSupport.variable_u64 s other y v src inner
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ [name.toList] s out source rfl
  refine ⟨congrArg C99ProcedureReference.Result.flow he,?_,frame.2.1,?_⟩
  · rw [he]
    have hcell2 : C99IntegerReference.convert .uint64 (u64 y).integer=u64 y :=
      KeygenNttLoopSupport.convert_u64_self y hy
    show (C99ScalarReference.set s.locals name.toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 y).integer))) name.toList=
      some (.uint64,some (u64 y))
    rw [hcell2]
    simp [C99ScalarReference.set]
  · intro m hm
    exact frame.2.2 m (fun hh => hm (List.mem_singleton.mp (contains_iff.mp hh)))

theorem ht_assign_result (s : State) (T : Nat) (out : Result)
    (hT : T<2^64) (htc : s.locals "ht".toList=some (.uint64,none)) (tc : USlot s "t" T)
    (source : Exec KeygenNttForwardPrograms.htAssign s out) :
    out.flow=.normal ∧ USlot out.state "ht" (T/2) ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠"ht".toList → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ :=
    KeygenNttLoopSupport.assign_result "ht".toList _ s out source
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans htc))
  subst ty
  have hv : v=u64 (T/2) := by
    have inner := KeygenNttForwardExec.eval_scalar s _ v evaluated
    obtain ⟨a,b,ha,hb,hop⟩ := KeygenNttForwardExec.eval_shift s.locals .right _ _ v inner
    have ha1 : a=u64 T := KeygenNttLoopSupport.variable_u64 s "t" T a tc ha
    have hb1 : b=C99IntegerReference.convert .int32 1 :=
      KeygenNttLoopSupport.literal_i32 s 1 b hb
    subst a
    subst b
    exact KeygenNttLoopSupport.shr_one_u64 T hT v hop
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ ["ht".toList] s out source rfl
  refine ⟨congrArg C99ProcedureReference.Result.flow he,?_,frame.2.1,?_⟩
  · rw [he]
    have hhalf : T/2<2^64 := by
      have h := Nat.div_le_self T 2
      omega
    have hcell : C99IntegerReference.convert .uint64 (u64 (T/2)).integer=u64 (T/2) :=
      KeygenNttLoopSupport.convert_u64_self (T/2) hhalf
    show (C99ScalarReference.set s.locals "ht".toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 (T/2)).integer))) "ht".toList=
      some (.uint64,some (u64 (T/2)))
    rw [hcell]
    simp [C99ScalarReference.set]
  · intro n hn
    exact frame.2.2 n (fun hh => hn (List.mem_singleton.mp (contains_iff.mp hh)))

/- ## `a`-slot survival along the walks

   The u1Inner chain binds only r1/r2 and the v-loop bodies write only
   their block locals and the heap, so the `a` root of the derived
   positions survives every u1 round and every outer round. Each keeper
   also reports the normal flow of the walked atom. -/
theorem ptr_bind_keep (s : State) (name : String) (other : B20.C.Name) (q p : ArrayPointer)
    (hne : name.toList≠other) (slot : PSlot s name p) :
    PSlot (C99ArrayReference.bindPointer s other q) name p := by
  simpa [PSlot,C99ArrayReference.bindPointer,hne] using slot

theorem a_update_keep (name : String) (op : B20.C.BinOp) (e : CLogic.Expr)
    (s : State) (out : Result) (p : ArrayPointer) (slot : PSlot s "a" p)
    (source : Exec (KeygenNttForwardPrograms.update name op e) s out) :
    out.flow=.normal ∧ PSlot out.state "a" p := by
  obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.update_result name.toList op e s out source
  subst out
  refine ⟨rfl,?_⟩
  show s.arrays "a".toList=some p
  exact slot

theorem a_assign_keep (name : B20.C.Name) (e : C99ModularReference.Expr)
    (s : State) (out : Result) (p : ArrayPointer) (slot : PSlot s "a" p)
    (source : Exec (.assign name e) s out) : out.flow=.normal ∧ PSlot out.state "a" p := by
  obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.assign_result name e s out source
  subst out
  refine ⟨rfl,?_⟩
  show s.arrays "a".toList=some p
  exact slot

theorem a_declare_keep (t : B20.C.Ty) (names : List B20.C.Name)
    (s : State) (out : Result) (p : ArrayPointer) (slot : PSlot s "a" p)
    (source : Exec (.base (.scalar (CLogic.Stmt.declare t names))) s out) :
    out.flow=.normal ∧ PSlot out.state "a" p := by
  obtain ⟨flowE,arraysE,_,_,_⟩ := KeygenNttButterflyCalls.declaration_result t names s out source
  exact ⟨flowE,KeygenNttFirstLoop.ptr_keep arraysE "a" p slot⟩

theorem a_bind_keep (target sourceN : B20.C.Name) (index : CLogic.Expr)
    (s : State) (out : Result) (p : ArrayPointer) (slot : PSlot s "a" p)
    (hne : "a".toList≠target)
    (exec : Exec (.base (.bindPtr target sourceN index)) s out) :
    out.flow=.normal ∧ PSlot out.state "a" p := by
  obtain ⟨q,ptr,he⟩ := KeygenNttLoopSupport.bindPtr_result target sourceN index s out exec
  subst out
  refine ⟨rfl,?_⟩
  exact ptr_bind_keep s "a" target q p hne slot

theorem a_step_keep (name : String) (s : State) (out : Result) (p : ArrayPointer)
    (slot : PSlot s "a" p)
    (source : Exec (KeygenNttForwardPrograms.step name) s out) :
    out.flow=.normal ∧ PSlot out.state "a" p := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ s out source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.update_result name.toList .add
          (KeygenNttForwardPrograms.num 1) s out hr
        exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨_,am1⟩ := a_update_keep name .add _ s ⟨mid,.normal⟩ p slot head
  obtain ⟨mid2,head2,tail2⟩ := (KeygenNttForwardExec.seq_inv _ _ mid out tail).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨q,_,he⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "r1".toList
          (.var "stride".toList) mid out hr
        exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨_,am2⟩ := a_bind_keep "r1".toList "r1".toList _ mid ⟨mid2,.normal⟩ p am1
    (by decide) head2
  exact a_bind_keep "r2".toList "r2".toList _ mid2 out p am2 (by decide) tail2

theorem a_loop_keep (cond : CLogic.Expr) (body inc : Stmt) (code : Stmt)
    (before : State) (result : Result)
    (source : Exec code before result)
    (shape : code=.loop cond body inc)
    (hbody : ∀ s out, Exec body s out → ∀ q, PSlot s "a" q →
      out.flow=.normal ∧ PSlot out.state "a" q)
    (hinc : ∀ s out, Exec inc s out → ∀ q, PSlot s "a" q →
      out.flow=.normal ∧ PSlot out.state "a" q)
    (p : ArrayPointer) (slot : PSlot before "a" p) :
    result.flow=.normal ∧ PSlot result.state "a" p := by
  induction source generalizing p with
  | base | assign | store32 | storeRev | seqNormal | seqExit | scope | branchTrue | branchFalse
  | ret | retVoid =>
      cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      exact ⟨rfl,slot⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update
      rest ih1 ih2 ih3 =>
      cases shape
      obtain ⟨_,am1⟩ := hbody before ⟨middle,.normal⟩ iteration p slot
      obtain ⟨_,am2⟩ := hinc middle ⟨next,.normal⟩ update p am1
      exact ih3 rfl p am2
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      cases shape
      obtain ⟨flowE,_⟩ := hbody before ⟨after,.returned (some value)⟩ iteration p slot
      cases flowE

theorem a_vloop_keep (before : State) (result : Result) (p : ArrayPointer)
    (slot : PSlot before "a" p)
    (source : Exec KeygenNttForwardPrograms.vLoop before result) :
    result.flow=.normal ∧ PSlot result.state "a" p := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before result source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨_,am1⟩ := a_assign_keep "v".toList _ before ⟨mid,.normal⟩ p slot head
  exact a_loop_keep (.cmp .lt (KeygenNttForwardPrograms.var "v")
    (KeygenNttForwardPrograms.var "ht")) (KeygenNttForwardPrograms.block
      KeygenNttButterflyPrograms.binaryBody) (KeygenNttForwardPrograms.step "v") _
    mid result tail rfl
    (fun s out hs q hq => by
      obtain ⟨flowE,arraysE,_⟩ := KeygenNttButterflyCalls.binary_body_result s out hs
      exact ⟨flowE,KeygenNttFirstLoop.ptr_keep arraysE "a" q hq⟩)
    (fun s out hs q hq => a_step_keep "v" s out q hq hs) p am1

theorem a_u1_inner_keep (before : State) (result : Result) (p : ArrayPointer)
    (slot : PSlot before "a" p)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner)
      before result) : result.flow=.normal ∧ PSlot result.state "a" p := by
  obtain ⟨inner,innerExec,hout⟩ := KeygenNttLoopSupport.scope_result
    (C99ModularParser.declarations KeygenNttForwardPrograms.u1Inner)
    KeygenNttForwardPrograms.u1Inner before result source
  obtain ⟨m1,hd1,ht1⟩ := (KeygenNttForwardExec.seq_inv _ _ before inner innerExec).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨_,a1⟩ := a_declare_keep .u64 (["v"].map String.toList)
    before ⟨m1,.normal⟩ p slot hd1
  obtain ⟨m2,hd2,ht2⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 inner ht1).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨_,a2⟩ := a_declare_keep .u32 (["s"].map String.toList)
    m1 ⟨m2,.normal⟩ p a1 hd2
  obtain ⟨m3,hsA,ht3⟩ := (KeygenNttForwardExec.seq_inv _ _ m2 inner ht2).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨_,a3⟩ := a_assign_keep "s".toList _ m2 ⟨m3,.normal⟩ p a2 hsA
  obtain ⟨m4,hb1,ht4⟩ := (KeygenNttForwardExec.seq_inv _ _ m3 inner ht3).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨_,a4⟩ := a_bind_keep "r1".toList "a".toList _ m3 ⟨m4,.normal⟩ p a3
    (by decide) hb1
  obtain ⟨m5,hb2,ht5⟩ := (KeygenNttForwardExec.seq_inv _ _ m4 inner ht4).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨_,a5⟩ := a_bind_keep "r2".toList "r1".toList _ m4 ⟨m5,.normal⟩ p a4
    (by decide) hb2
  obtain ⟨m6,hvL,ht6⟩ := (KeygenNttForwardExec.seq_inv _ _ m5 inner ht5).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨flowE,_⟩ := a_vloop_keep m5 inner p a5 hr
        exact hexit flowE)
  obtain ⟨_,a6⟩ := a_vloop_keep m5 ⟨m6,.normal⟩ p a5 hvL
  rw [C99ModularReference.skip_result m6 inner ht6] at hout
  rw [hout]
  refine ⟨rfl,?_⟩
  show m6.arrays "a".toList=some p
  exact a6

theorem a_u1step_keep (before : State) (result : Result) (p : ArrayPointer)
    (slot : PSlot before "a" p)
    (source : Exec KeygenNttForwardPrograms.u1Step before result) :
    result.flow=.normal ∧ PSlot result.state "a" p := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before result source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨_,a1⟩ := a_update_keep "u1" .add _ before ⟨mid,.normal⟩ p slot head
  exact a_update_keep "v1" .add _ mid result p a1 tail

theorem a_u1_loop_keep (before : State) (result : Result) (p : ArrayPointer)
    (slot : PSlot before "a" p)
    (source : Exec KeygenNttForwardPrograms.u1Loop before result) :
    result.flow=.normal ∧ PSlot result.state "a" p := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before result source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨mid0,h0,t0⟩ := (KeygenNttForwardExec.seq_inv _ _ before result hr).resolve_right
          (by rintro ⟨r2,hr2,hexit2,heq2⟩
              subst r2
              exact hexit2 (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr2))
        exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ t0))
  obtain ⟨mid1,head1,tail1⟩ :=
    (KeygenNttForwardExec.seq_inv _ _ before ⟨mid,.normal⟩ head).resolve_right
      (by rintro ⟨r,hr,hexit,heq⟩
          subst r
          exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨_,a1⟩ := a_assign_keep "u1".toList _ before ⟨mid1,.normal⟩ p slot head1
  obtain ⟨_,a2⟩ := a_assign_keep "v1".toList _ mid1 ⟨mid,.normal⟩ p a1 tail1
  exact a_loop_keep (KeygenNttMiddleLoops.ltGuard "u1" "m")
    (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner)
    KeygenNttForwardPrograms.u1Step _ mid result tail rfl
    (fun s out hs q hq => a_u1_inner_keep s out q hq hs)
    (fun s out hs q hq => a_u1step_keep s out q hq hs) p a2

/- ## The u1 loop: u1 ↦ j, v1 ↦ j*t with j ≤ m, nested v-runs per round -/
structure U1Run (aP : ArrayPointer) (σ v1p htp : Nat) (before after : State) : Prop where
  nested : ∃ s0 fin, KeygenNttMiddleLoops.VInv aP σ v1p htp 0 s0 ∧
    KeygenNttMiddleLoops.VTrace aP σ v1p htp 0 s0 fin ∧
    after.heap=fin.heap ∧ after.arrays=fin.arrays
  locals : after.locals=before.locals

theorem u1_inner_run (aP : ArrayPointer) (σ v1p htp : Nat) (before : State) (result : Result)
    (hσ : σ<2^64) (hv1 : v1p<2^64) (hhtp : htp<2^64) (fit1 : v1p*σ<2^64) (fit2 : htp*σ<2^64)
    (v1c : USlot before "v1" v1p) (ht : USlot before "ht" htp)
    (st : USlot before "stride" σ) (ap : PSlot before "a" aP)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner)
      before result) :
    result.flow=.normal ∧ U1Run aP σ v1p htp before result.state := by
  obtain ⟨flow,s0,fin,inv0,trace,heq1,heq2,heq3⟩ :=
    KeygenNttMiddleLoops.u1_inner_result aP σ v1p htp before result
      hσ hv1 hhtp fit1 fit2 v1c ht st ap source
  exact ⟨flow,⟨⟨s0,fin,inv0,trace,heq1,heq2⟩,heq3⟩⟩

structure U1Inv (mVal tVal : Nat) (j : Nat) (s : State) : Prop where
  u1Slot : USlot s "u1" j
  v1Slot : USlot s "v1" (j*tVal)
  bound : j≤mVal

inductive U1Trace (aP : ArrayPointer) (σ mVal tVal htp : Nat) : Nat → State → State → Prop where
  | done (j : Nat) (s : State) (stop : ¬j<mVal) (inv : U1Inv mVal tVal j s) :
      U1Trace aP σ mVal tVal htp j s s
  | next (j : Nat) (before mid after fin : State) (guard : j<mVal)
      (inv : U1Inv mVal tVal j before)
      (iteration : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner)
        before ⟨mid,.normal⟩)
      (run : U1Run aP σ (j*tVal) htp before mid)
      (update : Exec KeygenNttForwardPrograms.u1Step mid ⟨after,.normal⟩)
      (rest : U1Trace aP σ mVal tVal htp (j+1) after fin) :
      U1Trace aP σ mVal tVal htp j before fin

theorem u1_loop_trace (aP : ArrayPointer) (σ mVal tVal htp : Nat) (code : Stmt)
    (before : State) (result : Result)
    (hσ : σ<2^64) (hm64 : mVal<2^64) (ht64 : tVal<2^64) (hhtp : htp<2^64)
    (hv1 : ∀ j, j≤mVal → j*tVal<2^64) (fit1 : ∀ j, j≤mVal → (j*tVal)*σ<2^64)
    (fit2 : htp*σ<2^64)
    (source : Exec code before result)
    (shape : code=.loop (KeygenNttMiddleLoops.ltGuard "u1" "m")
      (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner)
      KeygenNttForwardPrograms.u1Step)
    (j : Nat) (inv : U1Inv mVal tVal j before)
    (mc : USlot before "m" mVal) (tc : USlot before "t" tVal) (ht : USlot before "ht" htp)
    (st : USlot before "stride" σ) (ap : PSlot before "a" aP) :
    result.flow=.normal ∧
      (∀ n, n≠"u1".toList ∧ n≠"v1".toList → result.state.locals n=before.locals n) ∧
      U1Trace aP σ mVal tVal htp j before result.state := by
  induction source generalizing j with
  | base | assign | store32 | storeRev | seqNormal | seqExit | scope | branchTrue | branchFalse
  | ret | retVoid =>
      cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      have hjle : j≤mVal := inv.bound
      refine ⟨rfl,?_,.done j before
        (KeygenNttMiddleLoops.guard_false before "u1" "m" j mVal v (by omega) hm64
          inv.u1Slot mc guard zero) inv⟩
      intro n hn
      rfl
  | loopNormal condition body increment before middle next result v guard nonzero iteration update
      rest ih1 ih2 ih3 =>
      cases shape
      have hjle : j≤mVal := inv.bound
      have strict : j<mVal := KeygenNttMiddleLoops.guard_true before "u1" "m" j mVal v
        (by omega) hm64 inv.u1Slot mc guard nonzero
      have hprod : j*tVal<2^64 := hv1 j inv.bound
      have hsum : j*tVal+tVal<2^64 := by
        have key : j*tVal+tVal=(j+1)*tVal := by ring
        rw [key]
        exact hv1 (j+1) (by omega)
      obtain ⟨iflow,run⟩ := u1_inner_run aP σ (j*tVal) htp before ⟨middle,.normal⟩
        hσ hprod hhtp (fit1 j inv.bound) fit2 inv.v1Slot ht st ap iteration
      have u1m : USlot middle "u1" j := KeygenNttFirstLoop.slot_keep run.locals "u1" j inv.u1Slot
      have v1m : USlot middle "v1" (j*tVal) :=
        KeygenNttFirstLoop.slot_keep run.locals "v1" (j*tVal) inv.v1Slot
      have tcm : USlot middle "t" tVal := KeygenNttFirstLoop.slot_keep run.locals "t" tVal tc
      have hmm : USlot middle "m" mVal := KeygenNttFirstLoop.slot_keep run.locals "m" mVal mc
      have htm : USlot middle "ht" htp := KeygenNttFirstLoop.slot_keep run.locals "ht" htp ht
      have stm : USlot middle "stride" σ := KeygenNttFirstLoop.slot_keep run.locals "stride" σ st
      obtain ⟨sflow,hu1,hv1s,harr,hloc⟩ := u1_step_result middle j tVal ⟨next,.normal⟩
        (by omega : j+1<2^64) ht64 hprod hsum u1m v1m tcm update
      have invn : U1Inv mVal tVal (j+1) next := ⟨hu1,hv1s,by omega⟩
      obtain ⟨_,amid⟩ := a_u1_inner_keep before ⟨middle,.normal⟩ aP ap iteration
      obtain ⟨_,anext⟩ := a_u1step_keep middle ⟨next,.normal⟩ aP amid update
      have mcn : USlot next "m" mVal := (hloc "m".toList (by decide)).trans hmm
      have tcn : USlot next "t" tVal := (hloc "t".toList (by decide)).trans tcm
      have htn : USlot next "ht" htp := (hloc "ht".toList (by decide)).trans htm
      have stn : USlot next "stride" σ := (hloc "stride".toList (by decide)).trans stm
      obtain ⟨flow,keep,trace⟩ := ih3 rfl (j+1) invn mcn tcn htn stn anext
      refine ⟨flow,?_,.next j before middle next result.state strict inv iteration run update trace⟩
      intro n hn
      refine ((keep n hn).trans (hloc n hn)).trans ?_
      exact congrFun run.locals n
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      cases shape
      obtain ⟨flowE,_⟩ := u1_inner_run aP σ (j*tVal) htp before ⟨after,.returned (some value)⟩
        hσ (hv1 j inv.bound) hhtp (fit1 j inv.bound) fit2 inv.v1Slot ht st ap iteration
      cases flowE

theorem u1_result (aP : ArrayPointer) (σ mVal tVal htp : Nat) (before : State) (result : Result)
    (hσ : σ<2^64) (hm64 : mVal<2^64) (ht64 : tVal<2^64) (hhtp : htp<2^64)
    (hv1 : ∀ j, j≤mVal → j*tVal<2^64) (fit1 : ∀ j, j≤mVal → (j*tVal)*σ<2^64)
    (fit2 : htp*σ<2^64)
    (u1c : ∃ old, before.locals "u1".toList=some (.uint64,old))
    (v1c : ∃ old, before.locals "v1".toList=some (.uint64,old))
    (mc : USlot before "m" mVal) (tc : USlot before "t" tVal) (ht : USlot before "ht" htp)
    (st : USlot before "stride" σ) (ap : PSlot before "a" aP)
    (source : Exec KeygenNttForwardPrograms.u1Loop before result) :
    result.flow=.normal ∧
      (∀ n, n≠"u1".toList ∧ n≠"v1".toList → result.state.locals n=before.locals n) ∧
      ∃ s0, U1Inv mVal tVal 0 s0 ∧ U1Trace aP σ mVal tVal htp 0 s0 result.state := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before result source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨mid0,h0,t0⟩ := (KeygenNttForwardExec.seq_inv _ _ before result hr).resolve_right
          (by rintro ⟨r2,hr2,hexit2,heq2⟩
              subst r2
              exact hexit2 (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr2))
        exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ t0))
  obtain ⟨mid1,head1,tail1⟩ :=
    (KeygenNttForwardExec.seq_inv _ _ before ⟨mid,.normal⟩ head).resolve_right
      (by rintro ⟨r,hr,hexit,heq⟩
          subst r
          exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨cflow,u1z,ar1,f1⟩ := assign_nat_result "u1" 0 before ⟨mid1,.normal⟩ u1c
    (by decide) head1
  obtain ⟨ov1,hv1cell⟩ := v1c
  have v1c1 : ∃ old, mid1.locals "v1".toList=some (.uint64,old) :=
    ⟨ov1,(f1 "v1".toList (by decide)).trans hv1cell⟩
  obtain ⟨c2flow,v1z,ar2,f2⟩ := assign_nat_result "v1" 0 mid1 ⟨mid,.normal⟩ v1c1
    (by decide) tail1
  have u1zm : USlot mid "u1" 0 := (f2 "u1".toList (by decide)).trans u1z
  have hz : (0*tVal : Nat)=0 := Nat.zero_mul tVal
  have inv0 : U1Inv mVal tVal 0 mid := by
    refine ⟨u1zm,?_,Nat.zero_le _⟩
    rw [hz]
    exact v1z
  have mcm : USlot mid "m" mVal := (f2 "m".toList (by decide)).trans
    ((f1 "m".toList (by decide)).trans mc)
  have tcm : USlot mid "t" tVal := (f2 "t".toList (by decide)).trans
    ((f1 "t".toList (by decide)).trans tc)
  have htm : USlot mid "ht" htp := (f2 "ht".toList (by decide)).trans
    ((f1 "ht".toList (by decide)).trans ht)
  have stm : USlot mid "stride" σ := (f2 "stride".toList (by decide)).trans
    ((f1 "stride".toList (by decide)).trans st)
  have apm : PSlot mid "a" aP := KeygenNttFirstLoop.ptr_keep (ar2.trans ar1) "a" aP ap
  obtain ⟨flow,keep,trace⟩ := u1_loop_trace aP σ mVal tVal htp _ mid result hσ hm64 ht64 hhtp
    hv1 fit1 fit2 tail rfl 0 inv0 mcm tcm htm stm apm
  refine ⟨flow,?_,⟨mid,inv0,trace⟩⟩
  intro n hn
  refine (keep n hn).trans ?_
  exact (f2 n hn.2).trans (f1 n hn.1)

/- ## The outer doubling rounds: m ↦ 2^(i+1), t ↦ 768/2^i -/
structure MInv (i : Nat) (s : State) : Prop where
  mSlot : USlot s "m" (2^(i+1))
  tSlot : USlot s "t" (768/2^i)

structure RoundRun (aP : ArrayPointer) (σ : Nat) (i : Nat) (before after : State) : Prop where
  nested : ∃ s0 fin, U1Inv (2^(i+1)) (768/2^i) 0 s0 ∧
    U1Trace aP σ (2^(i+1)) (768/2^i) ((768/2^i)/2) 0 s0 fin
  halves : USlot after "t" (768/2^(i+1))

inductive MTrace (aP : ArrayPointer) (σ : Nat) : Nat → State → State → Prop where
  | done (i : Nat) (s : State) (stop : ¬3<768/2^i) (inv : MInv i s) : MTrace aP σ i s s
  | next (i : Nat) (before mid after fin : State) (guard : 3<768/2^i) (inv : MInv i before)
      (iteration : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.mInner)
        before ⟨mid,.normal⟩)
      (round : RoundRun aP σ i before mid)
      (update : Exec KeygenNttForwardPrograms.mStep mid ⟨after,.normal⟩)
      (rest : MTrace aP σ (i+1) after fin) : MTrace aP σ i before fin

theorem round_result (aP : ArrayPointer) (σ : Nat) (i : Nat) (before : State) (result : Result)
    (hσ : σ<2^64) (h18 : 2^18*σ<2^64) (guard : 3<768/2^i)
    (inv : MInv i before) (st : USlot before "stride" σ) (ap : PSlot before "a" aP)
    (full : KeygenNttForwardExec.fullAt before)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.mInner)
      before result) :
    result.flow=.normal ∧ RoundRun aP σ i before result.state ∧
      USlot result.state "m" (2^(i+1)) ∧ USlot result.state "stride" σ ∧
      PSlot result.state "a" aP ∧ KeygenNttForwardExec.fullAt result.state := by
  obtain ⟨inner,innerExec,hout⟩ := KeygenNttLoopSupport.scope_result
    (C99ModularParser.declarations KeygenNttForwardPrograms.mInner)
    KeygenNttForwardPrograms.mInner before result source
  have declsEq : C99ModularParser.declarations KeygenNttForwardPrograms.mInner=
      (["ht","u1","v1"].map String.toList) := rfl
  obtain ⟨m1,hd1,ht1⟩ := (KeygenNttForwardExec.seq_inv _ _ before inner innerExec).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨dflow,darr,_,dloc,dframe⟩ := KeygenNttButterflyCalls.declaration_result .u64
    (["ht","u1","v1"].map String.toList) before ⟨m1,.normal⟩ hd1
  have htCell : m1.locals "ht".toList=some (.uint64,none) := by rw [dloc]; rfl
  have u1Cell : m1.locals "u1".toList=some (.uint64,none) := by rw [dloc]; rfl
  have v1Cell : m1.locals "v1".toList=some (.uint64,none) := by rw [dloc]; rfl
  have t1 : USlot m1 "t" (768/2^i) :=
    KeygenNttButterflyCalls.u64_keep (dframe "t".toList (by decide)) inv.tSlot
  have m1m : USlot m1 "m" (2^(i+1)) :=
    KeygenNttButterflyCalls.u64_keep (dframe "m".toList (by decide)) inv.mSlot
  have st1 : USlot m1 "stride" σ :=
    KeygenNttButterflyCalls.u64_keep (dframe "stride".toList (by decide)) st
  have ap1 : PSlot m1 "a" aP := KeygenNttFirstLoop.ptr_keep darr "a" aP ap
  have full1 : KeygenNttForwardExec.fullAt m1 :=
    full_keep (dframe "full".toList (by decide)) full
  obtain ⟨m2,hta,ht2⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 inner ht1).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨hflow,htSlot2,arr2,frame2⟩ := ht_assign_result m1 (768/2^i) ⟨m2,.normal⟩
    (base_half_bound i) htCell t1 hta
  have t2s : USlot m2 "t" (768/2^i) := (frame2 "t".toList (by decide)).trans t1
  have m2m : USlot m2 "m" (2^(i+1)) := (frame2 "m".toList (by decide)).trans m1m
  have st2 : USlot m2 "stride" σ := (frame2 "stride".toList (by decide)).trans st1
  have ap2 : PSlot m2 "a" aP := KeygenNttFirstLoop.ptr_keep arr2 "a" aP ap1
  have full2 : KeygenNttForwardExec.fullAt m2 :=
    full_keep (frame2 "full".toList (by decide)) full1
  have u1Cell2 : ∃ old, m2.locals "u1".toList=some (.uint64,old) :=
    ⟨none,(frame2 "u1".toList (by decide)).trans u1Cell⟩
  have v1Cell2 : ∃ old, m2.locals "v1".toList=some (.uint64,old) :=
    ⟨none,(frame2 "v1".toList (by decide)).trans v1Cell⟩
  obtain ⟨m3,u1l,ht3⟩ := (KeygenNttForwardExec.seq_inv _ _ m2 inner ht2).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨flowE,_,_⟩ := u1_result aP σ (2^(i+1)) (768/2^i) ((768/2^i)/2) m2 inner
          hσ (m_u64_bound i guard) (base_half_bound i) (ht_half_bound i)
          (fun j hj => lt64_18 _ (v1_round_bound i j guard hj))
          (fun j hj => fit18 _ σ (v1_round_bound i j guard hj) h18)
          (fit18 _ σ (ht_round_bound i) h18)
          u1Cell2 v1Cell2 m2m t2s htSlot2 st2 ap2 hr
        exact hexit flowE)
  obtain ⟨uflow,uk,s0,u1inv0,u1trace⟩ := u1_result aP σ (2^(i+1)) (768/2^i) ((768/2^i)/2) m2
    ⟨m3,.normal⟩
    hσ (m_u64_bound i guard) (base_half_bound i) (ht_half_bound i)
    (fun j hj => lt64_18 _ (v1_round_bound i j guard hj))
    (fun j hj => fit18 _ σ (v1_round_bound i j guard hj) h18)
    (fit18 _ σ (ht_round_bound i) h18)
    u1Cell2 v1Cell2 m2m t2s htSlot2 st2 ap2 u1l
  have t3s : USlot m3 "t" (768/2^i) := (uk "t".toList (by decide)).trans t2s
  have ht3s : USlot m3 "ht" ((768/2^i)/2) := (uk "ht".toList (by decide)).trans htSlot2
  have st3 : USlot m3 "stride" σ := (uk "stride".toList (by decide)).trans st2
  have full3 : KeygenNttForwardExec.fullAt m3 :=
    full_keep (uk "full".toList (by decide)) full2
  have tCell3 : ∃ old, m3.locals "t".toList=some (.uint64,old) :=
    ⟨some (u64 (768/2^i)),t3s⟩
  obtain ⟨m4,t2h,ht4⟩ := (KeygenNttForwardExec.seq_inv _ _ m3 inner ht3).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨flowE,_,_,_⟩ := assign_var_result "t" "ht" ((768/2^i)/2) m3 inner
          (ht_half_bound i) tCell3 ht3s hr
        exact hexit flowE)
  obtain ⟨tflow,t4,arr4,frame4⟩ := assign_var_result "t" "ht" ((768/2^i)/2) m3 ⟨m4,.normal⟩
    (ht_half_bound i) tCell3 ht3s t2h
  have m4m : USlot m4 "m" (2^(i+1)) := (frame4 "m".toList (by decide)).trans
    ((uk "m".toList (by decide)).trans m2m)
  have st4 : USlot m4 "stride" σ := (frame4 "stride".toList (by decide)).trans st3
  have full4 : KeygenNttForwardExec.fullAt m4 :=
    full_keep (frame4 "full".toList (by decide)) full3
  obtain ⟨_,a3⟩ := a_u1_loop_keep m2 ⟨m3,.normal⟩ aP ap2 u1l
  have ap4 : PSlot m4 "a" aP := KeygenNttFirstLoop.ptr_keep arr4 "a" aP a3
  rw [C99ModularReference.skip_result m4 inner ht4] at hout
  rw [hout]
  refine ⟨rfl,?_,?_,?_,?_,?_⟩
  · refine ⟨⟨s0,m3,u1inv0,u1trace⟩,?_⟩
    show m4.locals "t".toList = some (.uint64,some (u64 (768/2^(i+1))))
    have key : 768/2^(i+1)=(768/2^i)/2 := (halve_eq i).symm
    rw [key]
    exact t4
  · show m4.locals "m".toList = some (.uint64,some (u64 (2^(i+1))))
    exact m4m
  · show m4.locals "stride".toList = some (.uint64,some (u64 σ))
    exact st4
  · show m4.arrays "a".toList = some aP
    exact ap4
  · show m4.locals "full".toList = some (.uint32,some (.uint32 1))
    exact full4

theorem m_loop_trace (aP : ArrayPointer) (σ : Nat) (code : Stmt) (before : State) (result : Result)
    (hσ : σ<2^64) (h18 : 2^18*σ<2^64)
    (source : Exec code before result)
    (shape : code=.loop KeygenNttForwardPrograms.mGuard
      (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.mInner)
      KeygenNttForwardPrograms.mStep)
    (i : Nat) (inv : MInv i before)
    (full : KeygenNttForwardExec.fullAt before) (st : USlot before "stride" σ)
    (ap : PSlot before "a" aP) :
    result.flow=.normal ∧ MTrace aP σ i before result.state := by
  induction source generalizing i with
  | base | assign | store32 | storeRev | seqNormal | seqExit | scope | branchTrue | branchFalse
  | ret | retVoid =>
      cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      exact ⟨rfl,.done i before
        (mguard_false before (768/2^i) v (base_half_bound i) inv.tSlot full guard zero) inv⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update
      rest ih1 ih2 ih3 =>
      cases shape
      have strict : 3<768/2^i := mguard_true before (768/2^i) v (base_half_bound i) inv.tSlot
        full guard nonzero
      obtain ⟨rflow,round,mkeep,stkeep,apkeep,fullkeep⟩ :=
        round_result aP σ i before ⟨middle,.normal⟩ hσ h18 strict inv st ap full iteration
      obtain ⟨sflow,mslot2,arrE,locE⟩ := mstep_result middle (2^(i+1)) ⟨next,.normal⟩
        (m_u64_bound i strict) (mul_two_fit i strict) mkeep update
      have key : 2^(i+1)*2=2^((i+1)+1) := pow_double i
      have mnext : USlot next "m" (2^((i+1)+1)) := by
        rw [← key]
        exact mslot2
      have tnext : USlot next "t" (768/2^(i+1)) :=
        (locE "t".toList (by decide)).trans round.halves
      have invn : MInv (i+1) next := ⟨mnext,tnext⟩
      have stn : USlot next "stride" σ := (locE "stride".toList (by decide)).trans stkeep
      obtain ⟨_,apn⟩ := a_update_keep "m" .shl _ middle ⟨next,.normal⟩ aP apkeep update
      have fulln : KeygenNttForwardExec.fullAt next :=
        full_keep (locE "full".toList (by decide)) fullkeep
      obtain ⟨flow,trace⟩ := ih3 rfl (i+1) invn fulln stn apn
      exact ⟨flow,.next i before middle next result.state strict inv iteration round update trace⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      cases shape
      obtain ⟨rflow,_,_,_,_,_⟩ := round_result aP σ i before ⟨after,.returned (some value)⟩
        hσ h18 (mguard_true before (768/2^i) v (base_half_bound i) inv.tSlot full guard nonzero)
        inv st ap full iteration
      cases rflow

/- ## The composition: the whole intermediate pass -/
theorem intermediate_result (aP : ArrayPointer) (σ : Nat) (before : State) (result : Result)
    (hσ : σ<2^64) (h18 : 2^18*σ<2^64)
    (hn : USlot before "hn" 768)
    (tc : ∃ old, before.locals "t".toList=some (.uint64,old))
    (mc : ∃ old, before.locals "m".toList=some (.uint64,old))
    (full : KeygenNttForwardExec.fullAt before) (st : USlot before "stride" σ)
    (ap : PSlot before "a" aP)
    (source : Exec KeygenNttForwardPrograms.intermediatePass before result) :
    result.flow=.normal ∧ ∃ s0, MInv 0 s0 ∧ MTrace aP σ 0 s0 result.state := by
  obtain ⟨omc,hmc⟩ := mc
  obtain ⟨m1,head,rest1⟩ := (KeygenNttForwardExec.seq_inv _ _ before result source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨tflow,t1,arr1,frame1⟩ := assign_var_result "t" "hn" 768 before ⟨m1,.normal⟩
    (by decide) tc hn head
  have full1 : KeygenNttForwardExec.fullAt m1 := full_keep (frame1 "full".toList (by decide)) full
  have st1 : USlot m1 "stride" σ := (frame1 "stride".toList (by decide)).trans st
  have mCell1 : ∃ old, m1.locals "m".toList=some (.uint64,old) :=
    ⟨omc,(frame1 "m".toList (by decide)).trans hmc⟩
  obtain ⟨m2,head2,rest2⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 result rest1).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨midX,hX,tX⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 result hr).resolve_right
          (by rintro ⟨r2,hr2,hexit2,heq2⟩
              subst r2
              exact hexit2 (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr2))
        obtain ⟨_,mSlotX,arrX,frameX⟩ := assign_nat_result "m" 2 m1 ⟨midX,.normal⟩
          mCell1 (by decide) hX
        have invX : MInv 0 midX := by
          refine ⟨?_,?_⟩
          · show USlot midX "m" 2
            exact mSlotX
          · show USlot midX "t" 768
            exact (frameX "t".toList (by decide)).trans t1
        have fullX : KeygenNttForwardExec.fullAt midX :=
          full_keep (frameX "full".toList (by decide)) full1
        have stX : USlot midX "stride" σ := (frameX "stride".toList (by decide)).trans st1
        have apX : PSlot midX "a" aP := KeygenNttFirstLoop.ptr_keep (arrX.trans arr1) "a" aP ap
        obtain ⟨flowE,_⟩ := m_loop_trace aP σ _ midX result hσ h18 tX rfl 0 invX fullX stX apX
        exact hexit flowE)
  obtain ⟨mid3,head3,tail3⟩ :=
    (KeygenNttForwardExec.seq_inv _ _ m1 ⟨m2,.normal⟩ head2).resolve_right
      (by rintro ⟨r,hr,hexit,heq⟩
          subst r
          exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨mflow,mSlot3,arr3,frame3⟩ := assign_nat_result "m" 2 m1 ⟨mid3,.normal⟩
    mCell1 (by decide) head3
  have inv0 : MInv 0 mid3 := by
    refine ⟨?_,?_⟩
    · show USlot mid3 "m" 2
      exact mSlot3
    · show USlot mid3 "t" 768
      exact (frame3 "t".toList (by decide)).trans t1
  have full3 : KeygenNttForwardExec.fullAt mid3 :=
    full_keep (frame3 "full".toList (by decide)) full1
  have st3 : USlot mid3 "stride" σ := (frame3 "stride".toList (by decide)).trans st1
  have ap3 : PSlot mid3 "a" aP := KeygenNttFirstLoop.ptr_keep (arr3.trans arr1) "a" aP ap
  obtain ⟨lflow,trace⟩ := m_loop_trace aP σ _ mid3 ⟨m2,.normal⟩ hσ h18 tail3 rfl 0 inv0
    full3 st3 ap3
  rw [C99ModularReference.skip_result m2 result rest2]
  exact ⟨rfl,⟨mid3,inv0,trace⟩⟩

end FT1536.Source3.KeygenNttMiddleRounds
