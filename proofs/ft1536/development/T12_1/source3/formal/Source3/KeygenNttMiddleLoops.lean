import Source3.KeygenNttButterflyCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Loop counters and pointer positions of the forward-NTT INTERMEDIATE
   passes (B1.02 remainder 2.1.1, second bullet): the v-loop (radix-2
   butterflies) and the u1Inner bindPtr chain that re-derives r2 from r1
   via htBind every u1 round. Per v-iteration the pinned positions are
   r1 = a + v1*stride + v*stride and r2 = r1 + ht*stride + v*stride.
   The stride magnitude σ stays symbolic; the executed products v1*stride
   and ht*stride carry explicit non-overflow premises. The u1/m/t counter
   composition (u1Loop and the doubling outer rounds) is the remaining
   part of this bullet. No value/range/polynomial invariant (B1.04);
   stride=1 stays B1.07 call-frame work. -/
namespace FT1536.Source3.KeygenNttMiddleLoops
open C99ModularReference (Stmt Exec Eval)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open C99MemoryReference (ArrayPointer)
open KeygenNttLoopSupport (u64 USlot PSlot contains_iff)
open KeygenNttButterflyCalls (U32Slot U32Declared u64_keep)

/- Guard evaluation for `x < l` on the M0 path. -/
def ltGuard (xName lName : String) : CLogic.Expr :=
  .cmp .lt (.var xName.toList) (.var lName.toList)

theorem guard_value (s : State) (xName lName : String) (x l : Nat) (v : Value)
    (hx : x<2^64) (hl : l<2^64) (c : USlot s xName x) (lm : USlot s lName l)
    (source : C99ArrayReference.scalar s (ltGuard xName lName) v) :
    v=C99ScalarReference.boolean (decide (x<l)) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (.compare .lt (.variable xName.toList) (.variable lName.toList)) v at source
  obtain ⟨a,b,ha,hb,hop⟩ := KeygenNttForwardExec.eval_compare s.locals .lt _ _ v source
  have ha1 := KeygenNttLoopSupport.variable_u64 s xName x a c ha
  have hb1 := KeygenNttLoopSupport.variable_u64 s lName l b lm hb
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

theorem guard_true (s : State) (xName lName : String) (x l : Nat) (v : Value)
    (hx : x<2^64) (hl : l<2^64) (c : USlot s xName x) (lm : USlot s lName l)
    (source : C99ArrayReference.scalar s (ltGuard xName lName) v) (nonzero : v.integer≠0) :
    x<l := by
  rw [guard_value s xName lName x l v hx hl c lm source] at nonzero
  by_contra h
  simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero

theorem guard_false (s : State) (xName lName : String) (x l : Nat) (v : Value)
    (hx : x<2^64) (hl : l<2^64) (c : USlot s xName x) (lm : USlot s lName l)
    (source : C99ArrayReference.scalar s (ltGuard xName lName) v) (zero : v.integer=0) :
    ¬x<l := by
  rw [guard_value s xName lName x l v hx hl c lm source] at zero
  intro h
  simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero

/- Generic counted increment `name ++` of the loop steps. -/
theorem counter_update (name : String) (s : State) (k : Nat) (out : Result)
    (hk : k+1<2^64) (counter : USlot s name k)
    (source : Exec (KeygenNttForwardPrograms.update name .add
      (KeygenNttForwardPrograms.num 1)) s out) :
    USlot out.state name (k+1) ∧ out.state.arrays=s.arrays ∧
      ∀ n, n≠name.toList → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,declared,evaluated,he⟩ := KeygenNttLoopSupport.update_result name.toList .add
    (KeygenNttForwardPrograms.num 1) s out source
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans counter))
  subst ty
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .plus _ _ v evaluated
  have hx1 : x=u64 k := KeygenNttLoopSupport.variable_u64 s name k x counter hx
  have hy1 : y=C99IntegerReference.convert .int32 1 :=
    KeygenNttLoopSupport.literal_i32 s 1 y hy
  subst x
  subst y
  have hv : v=u64 (k+1) := KeygenNttLoopSupport.add_one_literal k (by omega) v hop
  subst v
  have frame := KeygenNttLoopSupport.atom_frame _ [name.toList] s out source rfl
  refine ⟨?_,frame.2.1,?_⟩
  · rw [he]
    have hcell : C99IntegerReference.convert .uint64 (u64 (k+1)).integer=u64 (k+1) :=
      KeygenNttLoopSupport.convert_u64_self (k+1) hk
    show (C99ScalarReference.set s.locals name.toList
      (.uint64,some (C99IntegerReference.convert .uint64 (u64 (k+1)).integer))) name.toList=
      some (.uint64,some (u64 (k+1)))
    rw [hcell]
    simp [C99ScalarReference.set]
  · intro n hn
    exact frame.2.2 n (fun hh => hn (List.mem_singleton.mp (contains_iff.mp hh)))

/- The loop increment `name ++, r1 += stride, r2 += stride`. -/
theorem step_result (name : String) (s : State) (k σ : Nat) (p1 p2 : ArrayPointer)
    (out : Result)
    (hσ : σ<2^64) (hk1 : k+1<2^64)
    (counter : USlot s name k) (st : USlot s "stride" σ)
    (hne : name.toList≠"stride".toList)
    (low : PSlot s "r1" p1) (high : PSlot s "r2" p2)
    (source : Exec (KeygenNttForwardPrograms.step name) s out) :
    out.flow=.normal ∧ USlot out.state name (k+1) ∧
      PSlot out.state "r1" {p1 with index := p1.index+σ} ∧
      PSlot out.state "r2" {p2 with index := p2.index+σ} ∧
      ∀ n, n≠name.toList → out.state.locals n=s.locals n := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ s out source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.update_result name.toList .add
          (KeygenNttForwardPrograms.num 1) s out hr
        exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨hu,harr,hloc⟩ := counter_update name s k ⟨mid,.normal⟩ hk1 counter head
  have st2 : USlot mid "stride" σ := (hloc "stride".toList hne.symm).trans st
  have low2 : PSlot mid "r1" p1 := KeygenNttFirstLoop.ptr_keep harr "r1" p1 low
  have high2 : PSlot mid "r2" p2 := KeygenNttFirstLoop.ptr_keep harr "r2" p2 high
  obtain ⟨flow,h1,h2,hadv⟩ :=
    KeygenNttFirstLoop.advance_result mid p1 p2 σ out hσ low2 high2 st2 tail
  exact ⟨flow,KeygenNttFirstLoop.slot_keep hadv name (k+1) hu,h1,h2,
    fun n hn => (congrFun hadv n).trans (hloc n hn)⟩

/- Product bind `target = source + xName*stride` of the u1Inner chain. -/
theorem bind_product (target source : String) (xName : String) (xp σ : Nat)
    (s : State) (root : ArrayPointer) (out : Result)
    (hσ : σ<2^64) (hxp : xp<2^64) (fit : xp*σ<2^64)
    (slot : PSlot s source root) (xs : USlot s xName xp) (st : USlot s "stride" σ)
    (exec : Exec (KeygenNttForwardPrograms.bind target source
      (.bin .mul (KeygenNttForwardPrograms.var xName)
        (KeygenNttForwardPrograms.var "stride"))) s out) :
    PSlot out.state target {root with index := root.index+xp*σ} := by
  obtain ⟨q,ptr,he⟩ := KeygenNttLoopSupport.bindPtr_result target.toList source.toList _
    s out exec
  subst out
  obtain ⟨i,ev,hroot⟩ := KeygenNttLoopSupport.pointer_root s source.toList _ root q slot ptr
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .times _ _ i ev
  have hx1 : x=u64 xp := KeygenNttLoopSupport.variable_u64 s xName xp x xs hx
  have hy1 : y=u64 σ := KeygenNttLoopSupport.variable_u64 s "stride" σ y st hy
  subst x
  subst y
  have hi : i=u64 (xp*σ) := KeygenNttLoopSupport.times_u64 xp σ hxp hσ i hop
  subst i
  rw [hroot,KeygenNttLoopSupport.u64_toNat (xp*σ) fit]
  simp [PSlot,C99ArrayReference.bindPointer]

/- The v-loop: radix-2 butterfly iterations with per-iteration positions
   r1 = a + v1*σ + k*σ and r2 = a + v1*σ + ht*σ + k*σ. -/
structure VInv (aP : ArrayPointer) (σ v1 htp : Nat) (k : Nat) (s : State) : Prop where
  counter : USlot s "v" k
  low : PSlot s "r1" {aP with index := aP.index+v1*σ+k*σ}
  high : PSlot s "r2" {aP with index := aP.index+v1*σ+htp*σ+k*σ}
  bound : k≤htp

inductive VTrace (aP : ArrayPointer) (σ v1 htp : Nat) : Nat → State → State → Prop where
  | done (k : Nat) (s : State) (stop : ¬k<htp) (inv : VInv aP σ v1 htp k s) :
      VTrace aP σ v1 htp k s s
  | next (k : Nat) (before mid after fin : State) (guard : k<htp)
      (inv : VInv aP σ v1 htp k before)
      (iteration : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody)
        before ⟨mid,.normal⟩)
      (update : Exec (KeygenNttForwardPrograms.step "v") mid ⟨after,.normal⟩)
      (rest : VTrace aP σ v1 htp (k+1) after fin) : VTrace aP σ v1 htp k before fin

theorem loop_trace (aP : ArrayPointer) (σ v1p htp : Nat) (code : Stmt) (before : State)
    (result : Result)
    (hσ : σ<2^64) (hhtp : htp<2^64)
    (source : Exec code before result)
    (shape : code=.loop (ltGuard "v" "ht")
      (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody)
      (KeygenNttForwardPrograms.step "v"))
    (k : Nat) (hk : k≤htp) (inv : VInv aP σ v1p htp k before)
    (st : USlot before "stride" σ) (ht : USlot before "ht" htp) :
    result.flow=.normal ∧ (∀ n, n≠"v".toList → result.state.locals n=before.locals n) ∧
      VTrace aP σ v1p htp k before result.state := by
  induction source generalizing k with
  | base | assign | store32 | seqNormal | seqExit | scope | branchTrue | branchFalse | ret
  | retVoid =>
      cases shape
  | loopFalse condition body increment before v guard zero =>
      cases shape
      refine ⟨rfl,?_,.done k before (guard_false before "v" "ht" k htp v (by omega) hhtp
        inv.counter ht guard zero) inv⟩
      intro n hn
      rfl
  | loopNormal condition body increment before middle next result v guard nonzero iteration
      update rest ih1 ih2 ih3 =>
      cases shape
      have strict := guard_true before "v" "ht" k htp v (by omega) hhtp inv.counter ht
        guard nonzero
      obtain ⟨bflow,barr,bloc⟩ := KeygenNttButterflyCalls.binary_body_result before
        ⟨middle,.normal⟩ iteration
      have invm : VInv aP σ v1p htp k middle := by
        refine ⟨?_,?_,?_,inv.bound⟩
        · exact KeygenNttFirstLoop.slot_keep bloc "v" k inv.counter
        · exact KeygenNttFirstLoop.ptr_keep barr "r1" _ inv.low
        · exact KeygenNttFirstLoop.ptr_keep barr "r2" _ inv.high
      have st2 : USlot middle "stride" σ := KeygenNttFirstLoop.slot_keep bloc "stride" σ st
      have ht2 : USlot middle "ht" htp := KeygenNttFirstLoop.slot_keep bloc "ht" htp ht
      obtain ⟨sflow,hu,h1,h2,hlocal⟩ := step_result "v" middle k σ _ _ ⟨next,.normal⟩ hσ
        (by omega : k+1<2^64) invm.counter st2 (by decide) invm.low invm.high update
      have invn : VInv aP σ v1p htp (k+1) next := by
        refine ⟨hu,?_,?_,by omega⟩
        · have key : {aP with index := aP.index+v1p*σ+(k+1)*σ}=
              {{aP with index := aP.index+v1p*σ+k*σ} with index :=
                aP.index+v1p*σ+k*σ+σ} := by
            have hz : aP.index+v1p*σ+(k+1)*σ=aP.index+v1p*σ+k*σ+σ := by ring
            cases aP
            simp [hz]
          rw [key,KeygenNttFirstLoop.ptr_step]
          exact h1
        · have key : {aP with index := aP.index+v1p*σ+htp*σ+(k+1)*σ}=
              {{aP with index := aP.index+v1p*σ+htp*σ+k*σ} with index :=
                aP.index+v1p*σ+htp*σ+k*σ+σ} := by
            have hz : aP.index+v1p*σ+htp*σ+(k+1)*σ=aP.index+v1p*σ+htp*σ+k*σ+σ := by ring
            cases aP
            simp [hz]
          rw [key,KeygenNttFirstLoop.ptr_step]
          exact h2
      have stn : USlot next "stride" σ := (hlocal "stride".toList (by decide)).trans st2
      have htn : USlot next "ht" htp := (hlocal "ht".toList (by decide)).trans ht2
      obtain ⟨flow,keep,tail⟩ := ih3 rfl (k+1) (by omega) invn stn htn
      refine ⟨flow,?_,.next k before middle next result.state strict inv iteration update tail⟩
      intro n hn
      exact ((keep n hn).trans (hlocal n hn)).trans (congrFun bloc n)
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      cases shape
      obtain ⟨bflow,_,_⟩ := KeygenNttButterflyCalls.binary_body_result before
        ⟨after,.returned (some value)⟩ iteration
      cases bflow

theorem v_result (aP : ArrayPointer) (σ v1p htp : Nat) (before : State) (result : Result)
    (hσ : σ<2^64) (hhtp : htp<2^64)
    (vc : ∃ old, before.locals "v".toList=some (.uint64,old))
    (ht : USlot before "ht" htp) (st : USlot before "stride" σ)
    (lo : PSlot before "r1" {aP with index := aP.index+v1p*σ})
    (hi : PSlot before "r2" {aP with index := aP.index+v1p*σ+htp*σ})
    (source : Exec KeygenNttForwardPrograms.vLoop before result) :
    result.flow=.normal ∧ (∀ n, n≠"v".toList → result.state.locals n=before.locals n) ∧
      ∃ s0, VInv aP σ v1p htp 0 s0 ∧ VTrace aP σ v1p htp 0 s0 result.state := by
  obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ before result source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨ty,old,v,_,_,he⟩ :=
          KeygenNttLoopSupport.assign_result "v".toList _ before result hr
        exact hexit (congrArg C99ProcedureReference.Result.flow he))
  obtain ⟨ty,old,v,declared,evaluated,he⟩ :=
    KeygenNttLoopSupport.assign_result "v".toList _ before ⟨mid,.normal⟩ head
  obtain ⟨oldv,vcl⟩ := vc
  have hty : ty=.uint64 := congrArg Prod.fst (Option.some.inj (declared.symm.trans vcl))
  subst ty
  have hv : v=C99IntegerReference.convert .int32 0 := by
    have inner := KeygenNttForwardExec.eval_scalar before _ v evaluated
    exact KeygenNttLoopSupport.literal_i32 before 0 v inner
  rw [hv] at he
  have hm1 : mid=C99ArrayReference.bindValue before "v".toList .uint64
      (C99IntegerReference.convert .int32 0) := congrArg Result.state he
  subst mid
  have hu : USlot (C99ArrayReference.bindValue before "v".toList .uint64
      (C99IntegerReference.convert .int32 0)) "v" 0 := by
    have hcell : C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer=u64 0 := by decide
    show (C99ScalarReference.set before.locals "v".toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer))) "v".toList=some (.uint64,some (u64 0))
    rw [hcell]
    simp [C99ScalarReference.set]
  set m1 := C99ArrayReference.bindValue before "v".toList .uint64
    (C99IntegerReference.convert .int32 0)
  have hst1 : USlot m1 "stride" σ := by
    show (C99ScalarReference.set before.locals "v".toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer))) "stride".toList=_
    simp [C99ScalarReference.set]
    exact st
  have hht1 : USlot m1 "ht" htp := by
    show (C99ScalarReference.set before.locals "v".toList
      (.uint64,some (C99IntegerReference.convert .uint64
        (C99IntegerReference.convert .int32 0).integer))) "ht".toList=_
    simp [C99ScalarReference.set]
    exact ht
  have hlo1 : PSlot m1 "r1" {aP with index := aP.index+v1p*σ} := by
    show m1.arrays "r1".toList=_
    exact lo
  have hhi1 : PSlot m1 "r2" {aP with index := aP.index+v1p*σ+htp*σ} := by
    show m1.arrays "r2".toList=_
    exact hi
  have inv0 : VInv aP σ v1p htp 0 m1 := by
    refine ⟨hu,?_,?_,Nat.zero_le _⟩
    · have key : {aP with index := aP.index+v1p*σ+0*σ}=
          {aP with index := aP.index+v1p*σ} := by simp
      rw [key]
      exact hlo1
    · have key : {aP with index := aP.index+v1p*σ+htp*σ+0*σ}=
          {aP with index := aP.index+v1p*σ+htp*σ} := by simp
      rw [key]
      exact hhi1
  obtain ⟨flow,keep,trace⟩ :=
    loop_trace aP σ v1p htp _ m1 result hσ hhtp tail rfl 0 (Nat.zero_le _) inv0 hst1 hht1
  refine ⟨flow,?_,⟨m1,inv0,trace⟩⟩
  intro n hn
  refine (keep n hn).trans ?_
  show (if n="v".toList then
    some (.uint64,some (C99IntegerReference.convert .uint64
      (C99IntegerReference.convert .int32 0).integer)) else before.locals n)=before.locals n
  split_ifs with h
  · exact (hn h).elim
  · rfl

/- u1Inner: the per-round bindPtr chain. v1Bind sets r1 = a + v1*stride
   and htBind re-derives r2 = r1 + ht*stride; the v-loop then runs with
   those entry positions. -/
theorem u1_inner_result (aP : ArrayPointer) (σ v1p htp : Nat) (before : State) (result : Result)
    (hσ : σ<2^64) (hv1 : v1p<2^64) (hhtp : htp<2^64) (fit1 : v1p*σ<2^64) (fit2 : htp*σ<2^64)
    (v1c : USlot before "v1" v1p) (ht : USlot before "ht" htp)
    (st : USlot before "stride" σ) (ap : PSlot before "a" aP)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttForwardPrograms.u1Inner)
      before result) :
    result.flow=.normal ∧
      ∃ s0 fin, VInv aP σ v1p htp 0 s0 ∧ VTrace aP σ v1p htp 0 s0 fin ∧
        result.state.heap=fin.heap ∧ result.state.arrays=fin.arrays ∧
        result.state.locals=before.locals := by
  obtain ⟨inner,innerExec,hout⟩ := KeygenNttLoopSupport.scope_result
    (C99ModularParser.declarations KeygenNttForwardPrograms.u1Inner)
    KeygenNttForwardPrograms.u1Inner before result source
  obtain ⟨m1,hd1,ht1⟩ := (KeygenNttForwardExec.seq_inv _ _ before inner innerExec).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨f1,a1g,heapD1,foldD1,frameD1⟩ := KeygenNttButterflyCalls.declaration_result .u64 (["v"].map String.toList)
    before ⟨m1,.normal⟩ hd1
  have dv1 : ∃ old, m1.locals "v".toList=some (.uint64,old) := ⟨none,by rw [foldD1]; rfl⟩
  obtain ⟨m2,hd2,ht2⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 inner ht1).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨f2,a2g,heapD2,foldD2,frameD2⟩ := KeygenNttButterflyCalls.declaration_result .u32 (["s"].map String.toList)
    m1 ⟨m2,.normal⟩ hd2
  have ds2 : U32Declared m2 "s" := ⟨none,by rw [foldD2]; rfl⟩
  obtain ⟨ov1,hv1s⟩ := dv1
  have dv2 : ∃ old, m2.locals "v".toList=some (.uint64,old) :=
    ⟨ov1,(frameD2 "v".toList (KeygenNttButterflyCalls.fresh_single "s".toList "v".toList
      (by decide))).trans hv1s⟩
  have ht1s : USlot m1 "ht" htp :=
    u64_keep (frameD1 "ht".toList
      (KeygenNttButterflyCalls.fresh_single "v".toList "ht".toList (by decide))) ht
  have st1s : USlot m1 "stride" σ :=
    u64_keep (frameD1 "stride".toList
      (KeygenNttButterflyCalls.fresh_single "v".toList "stride".toList (by decide))) st
  have v1c1 : USlot m1 "v1" v1p :=
    u64_keep (frameD1 "v1".toList
      (KeygenNttButterflyCalls.fresh_single "v".toList "v1".toList (by decide))) v1c
  have ap1 : PSlot m1 "a" aP := KeygenNttFirstLoop.ptr_keep a1g "a" aP ap
  have ht2s : USlot m2 "ht" htp :=
    u64_keep (frameD2 "ht".toList
      (KeygenNttButterflyCalls.fresh_single "s".toList "ht".toList (by decide))) ht1s
  have st2s : USlot m2 "stride" σ :=
    u64_keep (frameD2 "stride".toList
      (KeygenNttButterflyCalls.fresh_single "s".toList "stride".toList (by decide))) st1s
  have v1c2 : USlot m2 "v1" v1p :=
    u64_keep (frameD2 "v1".toList
      (KeygenNttButterflyCalls.fresh_single "s".toList "v1".toList (by decide))) v1c1
  have ap2 : PSlot m2 "a" aP := KeygenNttFirstLoop.ptr_keep a2g "a" aP ap1
  obtain ⟨m3,hsA,ht3⟩ := (KeygenNttForwardExec.seq_inv _ _ m2 inner ht2).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_assign _ _ _ _ hr))
  obtain ⟨sw,_,slotS,arrM3,heapM3,localsM3,frameM3⟩ := KeygenNttButterflyCalls.assign32_result
    (fun _ => True) m2 "s"
    (.load32 "gm".toList (.bin .add (KeygenNttForwardPrograms.var "m")
      (KeygenNttForwardPrograms.var "u1"))) ⟨m3,.normal⟩ ds2 hsA
    (fun v ev => by
      obtain ⟨q,w,_,_,hv⟩ := KeygenNttButterflyCalls.load_exists m2 "gm" _ v ev
      exact ⟨w,hv,trivial⟩)
  have ht3s : USlot m3 "ht" htp :=
    u64_keep (frameM3 "ht".toList
      (KeygenNttButterflyCalls.fresh_single "s".toList "ht".toList (by decide))) ht2s
  have st3s : USlot m3 "stride" σ :=
    u64_keep (frameM3 "stride".toList
      (KeygenNttButterflyCalls.fresh_single "s".toList "stride".toList (by decide))) st2s
  have v1c3 : USlot m3 "v1" v1p :=
    u64_keep (frameM3 "v1".toList
      (KeygenNttButterflyCalls.fresh_single "s".toList "v1".toList (by decide))) v1c2
  obtain ⟨ov2,hv2s⟩ := dv2
  have dv3 : ∃ old, m3.locals "v".toList=some (.uint64,old) :=
    ⟨ov2,(frameM3 "v".toList
      (KeygenNttButterflyCalls.fresh_single "s".toList "v".toList (by decide))).trans hv2s⟩
  have ap3 : PSlot m3 "a" aP := KeygenNttFirstLoop.ptr_keep arrM3 "a" aP ap2
  obtain ⟨m4,hb1,ht4⟩ := (KeygenNttForwardExec.seq_inv _ _ m3 inner ht3).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨q1,ptr1,he1⟩ := KeygenNttLoopSupport.bindPtr_result "r1".toList "a".toList _
    m3 ⟨m4,.normal⟩ hb1
  have hm4 : m4=C99ArrayReference.bindPointer m3 "r1".toList q1 :=
    congrArg Result.state he1
  subst m4
  have r1b : PSlot (C99ArrayReference.bindPointer m3 "r1".toList q1) "r1"
      {aP with index := aP.index+v1p*σ} :=
    bind_product "r1" "a" "v1" v1p σ m3 aP ⟨C99ArrayReference.bindPointer m3 "r1".toList q1,.normal⟩
      hσ hv1 fit1 ap3 v1c3 st3s hb1
  have ht4s : USlot (C99ArrayReference.bindPointer m3 "r1".toList q1) "ht" htp := ht3s
  have st4s : USlot (C99ArrayReference.bindPointer m3 "r1".toList q1) "stride" σ := st3s
  have dv4 : ∃ old, (C99ArrayReference.bindPointer m3 "r1".toList q1).locals "v".toList=
      some (.uint64,old) := dv3
  obtain ⟨m5,hb2,ht5⟩ :=
    (KeygenNttForwardExec.seq_inv _ _ (C99ArrayReference.bindPointer m3 "r1".toList q1) inner
      ht4).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        exact hexit (KeygenNttButterflyCalls.normal_base _ _ _ hr))
  obtain ⟨q2,ptr2,he2⟩ := KeygenNttLoopSupport.bindPtr_result "r2".toList "r1".toList _
    (C99ArrayReference.bindPointer m3 "r1".toList q1) ⟨m5,.normal⟩ hb2
  have hm5 : m5=C99ArrayReference.bindPointer
      (C99ArrayReference.bindPointer m3 "r1".toList q1) "r2".toList q2 :=
    congrArg Result.state he2
  subst m5
  have r2b : PSlot (C99ArrayReference.bindPointer
      (C99ArrayReference.bindPointer m3 "r1".toList q1) "r2".toList q2) "r2"
      {aP with index := aP.index+v1p*σ+htp*σ} := by
    have hraw := bind_product "r2" "r1" "ht" htp σ
      (C99ArrayReference.bindPointer m3 "r1".toList q1)
      {aP with index := aP.index+v1p*σ}
      ⟨C99ArrayReference.bindPointer (C99ArrayReference.bindPointer m3 "r1".toList q1)
        "r2".toList q2,.normal⟩
      hσ hhtp fit2 r1b ht4s st4s hb2
    have key : {({aP with index := aP.index+v1p*σ} : ArrayPointer) with
        index := aP.index+v1p*σ+htp*σ}={aP with index := aP.index+v1p*σ+htp*σ} :=
      KeygenNttFirstLoop.ptr_step aP (aP.index+v1p*σ) (htp*σ)
    rw [key] at hraw
    exact hraw
  have r1c : PSlot (C99ArrayReference.bindPointer
      (C99ArrayReference.bindPointer m3 "r1".toList q1) "r2".toList q2) "r1"
      {aP with index := aP.index+v1p*σ} := r1b
  have ht5s : USlot (C99ArrayReference.bindPointer
      (C99ArrayReference.bindPointer m3 "r1".toList q1) "r2".toList q2) "ht" htp := ht4s
  have st5s : USlot (C99ArrayReference.bindPointer
      (C99ArrayReference.bindPointer m3 "r1".toList q1) "r2".toList q2) "stride" σ := st4s
  have dv5 : ∃ old, (C99ArrayReference.bindPointer
      (C99ArrayReference.bindPointer m3 "r1".toList q1) "r2".toList q2).locals "v".toList=
      some (.uint64,old) := dv4
  obtain ⟨m6,hvL,ht6⟩ :=
    (KeygenNttForwardExec.seq_inv _ _
      (C99ArrayReference.bindPointer (C99ArrayReference.bindPointer m3 "r1".toList q1)
        "r2".toList q2) inner ht5).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨rflow,_,_⟩ := v_result aP σ v1p htp
          (C99ArrayReference.bindPointer (C99ArrayReference.bindPointer m3 "r1".toList q1)
            "r2".toList q2) inner hσ hhtp dv5 ht5s st5s r1c r2b hr
        exact hexit rflow)
  obtain ⟨vflow,vkeep,s0,inv0,trace⟩ :=
    v_result aP σ v1p htp
      (C99ArrayReference.bindPointer (C99ArrayReference.bindPointer m3 "r1".toList q1)
        "r2".toList q2) ⟨m6,.normal⟩ hσ hhtp dv5 ht5s st5s r1c r2b hvL
  rw [C99ModularReference.skip_result m6 inner ht6] at hout
  rw [hout]
  refine ⟨vflow,⟨s0,m6,inv0,trace,rfl,rfl,?_⟩⟩
  funext n
  have localsEq : (C99ArrayReference.restoreScope before m6
      (C99ModularParser.declarations KeygenNttForwardPrograms.u1Inner) []).locals n=
      (if (["v".toList,"s".toList]).contains n then before.locals n else m6.locals n) := by
    show (C99ScalarReference.restore before.locals m6.locals
      (C99ModularParser.declarations KeygenNttForwardPrograms.u1Inner)) n=_
    rw [show C99ModularParser.declarations KeygenNttForwardPrograms.u1Inner=
      ["v".toList,"s".toList] from rfl]
    rfl
  rw [localsEq]
  split_ifs with hif
  · rfl
  · have nvn : n≠"v".toList := fun hh => hif (by rw [hh]; decide)
    have nsn : n≠"s".toList := fun hh => hif (by rw [hh]; decide)
    have step1 : m6.locals n=
        (C99ArrayReference.bindPointer (C99ArrayReference.bindPointer m3 "r1".toList q1)
          "r2".toList q2).locals n := vkeep n nvn
    have step2 : (C99ArrayReference.bindPointer
        (C99ArrayReference.bindPointer m3 "r1".toList q1) "r2".toList q2).locals n=
        m3.locals n := rfl
    have step3 : m3.locals n=m2.locals n := frameM3 n
      (KeygenNttButterflyCalls.fresh_single "s".toList n nsn.symm)
    have step4 : m2.locals n=m1.locals n := frameD2 n
      (KeygenNttButterflyCalls.fresh_single "s".toList n nsn.symm)
    have step5 : m1.locals n=before.locals n := frameD1 n
      (KeygenNttButterflyCalls.fresh_single "v".toList n nvn.symm)
    exact (((step1.trans step2).trans step3).trans step4).trans step5

end FT1536.Source3.KeygenNttMiddleLoops
