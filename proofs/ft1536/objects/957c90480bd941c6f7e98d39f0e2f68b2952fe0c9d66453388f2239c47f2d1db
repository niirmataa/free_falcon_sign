import Source3.KeygenMkgm3Loops

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMkgm3Prelude
open C99ModularReference (Stmt Expr Exec Eval chainOf)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open KeygenMkgm3Program
open KeygenMkgm3Atoms
open KeygenMkgm3Counters (single_value)
open KeygenMkgm3Control (frame chain_inv)
open KeygenNttButterflyCalls (U32Slot U32Declared)
open KeygenMkgm3Rows (Scaled generator root)
open KeygenNttWordAlgebra (radix value)

def Declared (s : State) (name : String) (ty : Ty) : Prop := ∃ old, s.locals name.toList=some (ty,old)
def set32 (s : State) (name : String) (w : BitVec 32) : State :=
  C99ArrayReference.bindValue s name.toList .uint32 (.uint32 w)

theorem set32_slot (s : State) (name : String) (w : BitVec 32) : U32Slot (set32 s name w) name w := by
  simp [U32Slot,set32,C99ArrayReference.bindValue,C99ScalarReference.set,KeygenNttButterflyCalls.convert_u32]

theorem assign32 (s : State) (out : Result) (name : String) (e : Expr) (w : BitVec 32)
    (declared : U32Declared s name) (rhs : ∀ v, Eval s e v → v=.uint32 w)
    (source : Exec (.assign name.toList e) s out) : out=⟨set32 s name w,.normal⟩ := by
  obtain ⟨old,hd⟩ := declared
  obtain ⟨ty,previous,v,has,ev,he⟩ := KeygenNttForwardExec.assign_inv s _ _ out source
  have ht := congrArg Prod.fst (Option.some.inj (has.symm.trans hd))
  change ty=Ty.uint32 at ht
  subst ty
  rw [he,rhs v ev]
  rfl

theorem declare_result (s : State) (out : Result) (ty : B20.C.Ty) (names : List String)
    (source : Exec (.base (.scalar (.declare ty (names.map String.toList)))) s out) :
    out=⟨{s with locals := ((names.map String.toList).foldl
      (fun env n => C99ScalarReference.set env n (C99ValueBridge.type ty,none)) s.locals)},.normal⟩ := by
  obtain ⟨mid,body,he⟩ := KeygenNttForwardExec.base_inv _ s out source
  obtain ⟨env,exec,hm⟩ := KeygenNttForwardExec.scalar_inv _ s mid body
  have hd := KeygenNttForwardExec.declarations_result s.locals (C99ValueBridge.type ty)
    (names.map String.toList) (.normal env) exec
  cases hd
  rw [he,hm]

theorem declared_transport (code : Stmt) (s : State) (out : Result) (name : String) (ty : Ty)
    (support : KeygenMkgm3Control.supported code=true) (keep : name.toList∉KeygenMkgm3Control.writes code)
    (declared : Declared s name ty) (source : Exec code s out) : Declared out.state name ty := by
  obtain ⟨old,hd⟩ := declared
  exact ⟨old,((frame code s out support source).2.2 _ keep).trans hd⟩

theorem slot_transport (code : Stmt) (s : State) (out : Result) (name : String) (w : BitVec 32)
    (support : KeygenMkgm3Control.supported code=true) (keep : name.toList∉KeygenMkgm3Control.writes code)
    (slot : U32Slot s name w) (source : Exec code s out) : U32Slot out.state name w :=
  ((frame code s out support source).2.2 _ keep).trans slot

theorem cut (pre rest : List Stmt) (s : State) (out : Result)
    (support : KeygenMkgm3Control.supported (chainOf pre)=true)
    (source : Exec (chainOf (pre++rest)) s out) :
    ∃ middle, Exec (chainOf pre) s ⟨middle,.normal⟩ ∧ Exec (chainOf rest) middle out := by
  induction pre generalizing s with
  | nil => exact ⟨s,.base .skip s s (.skip s),source⟩
  | cons a as ih =>
      obtain ⟨m,head,tail⟩ := chain_inv a (as++rest) s out (Bool.and_eq_true_iff.mp support).1 source
      obtain ⟨n,hp,hr⟩ := ih m (Bool.and_eq_true_iff.mp support).2 tail
      exact ⟨n,.seqNormal a (chainOf as) s m ⟨n,.normal⟩ head hp,hr⟩

def RawWord (s : State) : Prop := ∃ w, U32Slot s "g" w ∧
  w.toNat<KeygenNinv31.prime.toNat ∧ value w=radix*generator

theorem raw_transport (code : Stmt) (s : State) (out : Result)
    (support : KeygenMkgm3Control.supported code=true) (keep : "g".toList∉KeygenMkgm3Control.writes code)
    (raw : RawWord s) (source : Exec code s out) : RawWord out.state := by
  obtain ⟨w,slot,law⟩ := raw
  exact ⟨w,slot_transport code s out "g" w support keep slot source,law⟩

theorem r2_assignment (s : State) (out : Result) (p0i : BitVec 32) (params : Params s p0i)
    (declared : U32Declared s "R2") (source : Exec r2Assign s out) :
    ∃ r2, U32Slot out.state "R2" r2 ∧ C99ModularReference.ModCall "modp_R2".toList
      [.uint32 KeygenNinv31.prime,.uint32 p0i] (.uint32 r2) := by
  obtain ⟨ty,previous,v,has,ev,he⟩ := KeygenNttForwardExec.assign_inv s _ _ out source
  obtain ⟨old,hd⟩ := declared
  have ht := congrArg Prod.fst (Option.some.inj (has.symm.trans hd))
  change ty=Ty.uint32 at ht
  subst ty
  cases ev with
  | call2 nm a b x y v first second call =>
      have hx := KeygenNttButterflyCalls.variable_u32 s "p" KeygenNinv31.prime x params.1
        (KeygenNttForwardExec.eval_scalar s _ x first)
      have hy := KeygenNttButterflyCalls.variable_u32 s "p0i" p0i y params.2
        (KeygenNttForwardExec.eval_scalar s _ y second)
      subst x; subst y
      have hv : v=.uint32 (KeygenModpR2Word.word KeygenNinv31.prime p0i) := by
        cases call with
        | r2 args out body => exact KeygenModpR2Exec.source_exact _ _ _ body
      refine ⟨_,?_,by rw [hv] at call; exact call⟩
      rw [he,hv]
      exact set32_slot s "R2" _

theorem conversion (s : State) (out : Result) (p0i r2 : BitVec 32) (params : Params s p0i)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (g : U32Slot s "g" KeygenFirstPrime.generator) (r : U32Slot s "R2" r2)
    (rcall : C99ModularReference.ModCall "modp_R2".toList
      [.uint32 KeygenNinv31.prime,.uint32 p0i] (.uint32 r2))
    (source : Exec gConvert s out) : RawWord out.state := by
  obtain ⟨ty,previous,v,has,ev,he⟩ := KeygenNttForwardExec.assign_inv s _ _ out source
  have ht := congrArg Prod.fst (Option.some.inj (has.symm.trans g))
  change ty=Ty.uint32 at ht
  subst ty
  obtain ⟨w,hv,body⟩ := KeygenNttButterflyCalls.mont_result s "g" "R2" KeygenFirstPrime.generator r2 p0i v
    g r params.1 params.2 ev
  obtain ⟨range,law⟩ := KeygenModpR2.initialized_to_montgomery KeygenFirstPrime.generator r2 p0i w
    (by decide) initialization rcall body
  rw [he,hv]
  exact ⟨w,set32_slot s "g" w,range,law⟩

theorem raw_square (s : State) (out : Result) (p0i : BitVec 32) (params : Params s p0i)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (raw : RawWord s) (source : Exec (.assign "g".toList montGG) s out) : Word out.state "g" 1 := by
  obtain ⟨g,slot,range,law⟩ := raw
  apply (assign_word s out "g" montGG 1 ⟨some (.uint32 g),slot⟩ _ source).1
  intro v ev
  obtain ⟨w,hv,body⟩ := KeygenNttButterflyCalls.mont_result s "g" "g" g g p0i v slot slot params.1 params.2 ev
  obtain ⟨bound,scaled⟩ := KeygenNttWordAlgebra.source_scaled_product g g p0i w generator generator
    range range initialization law law body
  exact ⟨w,hv,bound,by simpa only [root,pow_one,pow_two] using scaled⟩

theorem branch_zero (condition : CLogic.Expr) (yes : Stmt) (s : State) (out : Result)
    (zero : ∀ v, C99ArrayReference.scalar s condition v → v.integer=0)
    (source : Exec (.branch condition yes (.base .skip)) s out) : out=⟨s,.normal⟩ := by
  cases source with
  | branchTrue _ _ _ _ _ v guard nonzero body => exact (nonzero (zero v guard)).elim
  | branchFalse _ _ _ _ _ v guard hz body => exact C99ModularReference.skip_result s out body

theorem loop_zero (condition : CLogic.Expr) (body increment : Stmt) (s : State) (out : Result)
    (zero : ∀ v, C99ArrayReference.scalar s condition v → v.integer=0)
    (source : Exec (.loop condition body increment) s out) : out=⟨s,.normal⟩ := by
  cases source with
  | loopFalse => rfl
  | loopNormal _ _ _ _ _ _ _ v guard nonzero iteration update rest => exact (nonzero (zero v guard)).elim
  | loopReturn _ _ _ _ _ v value guard nonzero iteration => exact (nonzero (zero v guard)).elim

theorem not_full (s : State) (out : Result) (full : U32Slot s "full" 1)
    (source : Exec ifNotFull s out) : out=⟨s,.normal⟩ := by
  apply branch_zero _ _ s out _ source
  intro v ev
  have hv := single_value s "full" 1 (.lnot (var "full")) .i32 (.i32 0) v full rfl rfl (by decide) ev
  rw [hv]
  rfl

theorem k_increment (s : State) (out : Result) (k next : BitVec 32) (slot : U32Slot s "k" k)
    (model : ExpressionFuel.unbounded CertificatePrologue.emptyCalls
      (KeygenMkgm3Counters.single "k" k).values (.bin .add (var "k") (num 1))=some (.u32 next))
    (source : Exec (inc "k") s out) : out=⟨set32 s "k" next,.normal⟩ := by
  obtain ⟨ty,old,v,declared,ev,he⟩ := KeygenNttLoopSupport.update_result _ _ _ s out source
  have ht := congrArg Prod.fst (Option.some.inj (declared.symm.trans slot))
  change ty=Ty.uint32 at ht
  subst ty
  have hv := single_value s "k" k (.bin .add (var "k") (num 1)) .u32 (.u32 next) v slot rfl rfl model ev
  rw [he,hv]
  rfl

def kLoop : Stmt := .loop (.cmp .lt (var "k") (num 11))
  (.seq (inc "k") (.scope [] (chainOf [.assign "g".toList montGG]))) (.base .skip)

theorem k10_true (s : State) (v : Value) (slot : U32Slot s "k" 10)
    (guard : C99ArrayReference.scalar s (.cmp .lt (var "k") (num 11)) v) : v.integer≠0 := by
  have hv := single_value s "k" 10 (.cmp .lt (var "k") (num 11)) .i32 (.i32 1) v slot rfl rfl (by decide) guard
  rw [hv]
  decide
theorem k11_false (s : State) (v : Value) (slot : U32Slot s "k" 11)
    (guard : C99ArrayReference.scalar s (.cmp .lt (var "k") (num 11)) v) : v.integer=0 := by
  have hv := single_value s "k" 11 (.cmp .lt (var "k") (num 11)) .i32 (.i32 0) v slot rfl rfl (by decide) guard
  rw [hv]
  rfl

theorem k_body (s : State) (out : Result) (p0i : BitVec 32) (slot : U32Slot s "k" 10)
    (params : Params s p0i) (raw : RawWord s)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (.seq (inc "k") (.scope [] (chainOf [.assign "g".toList montGG]))) s out) :
    U32Slot out.state "k" 11 ∧ Word out.state "g" 1 := by
  have tail := C99ModularReference.continuation _ _ s (set32 s "k" 11) out
    (fun r h => k_increment s r 10 11 slot (by decide) h) source
  obtain ⟨inner,body,he⟩ := KeygenNttLoopSupport.scope_result _ _ _ out tail
  obtain ⟨middle,head,last⟩ := chain_inv _ _ _ inner (by decide) body
  have hend := C99ModularReference.skip_result middle inner last
  have params' : Params (set32 s "k" 11) p0i := by
    simpa [Params,U32Slot,set32,C99ArrayReference.bindValue,C99ScalarReference.set] using params
  have raw' : RawWord (set32 s "k" 11) := by
    simpa [RawWord,U32Slot,set32,C99ArrayReference.bindValue,C99ScalarReference.set] using raw
  have word := raw_square _ ⟨middle,.normal⟩ p0i params' initialization raw' head
  have ks := slot_transport _ _ ⟨middle,.normal⟩ "k" 11 (by decide) (by decide) (set32_slot s "k" 11) head
  rw [he,hend]
  exact ⟨ks,word⟩

theorem k_loop (s : State) (out : Result) (p0i : BitVec 32) (slot : U32Slot s "k" 10)
    (params : Params s p0i) (raw : RawWord s)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec kLoop s out) : U32Slot out.state "k" 11 ∧ Word out.state "g" 1 := by
  cases source with
  | loopFalse condition body increment before v guard zero => exact (k10_true s v slot guard zero).elim
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest =>
      obtain ⟨k,g⟩ := k_body s ⟨middle,.normal⟩ p0i slot params raw initialization iteration
      have hn := C99ModularReference.skip_result middle ⟨next,.normal⟩ update
      have hn' : next=middle := congrArg Result.state hn
      subst next
      have he := loop_zero _ _ _ middle out (fun v h => k11_false middle v k h) rest
      rw [he]
      exact ⟨k,g⟩
  | loopReturn condition body increment before after v value guard nonzero iteration =>
      have normal := (frame _ s ⟨after,.returned (some value)⟩ (by decide) iteration).1
      cases normal

theorem while_root (s : State) (out : Result) (p0i : BitVec 32) (slot : U32Slot s "k" 10)
    (params : Params s p0i) (raw : RawWord s)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec whileK s out) : Word out.state "g" 1 := by
  cases source with
  | seqNormal first second before middle result head tail =>
      obtain ⟨k,g⟩ := k_loop s ⟨middle,.normal⟩ p0i slot params raw initialization head
      exact word_transport _ middle out "g" 1 (by decide) (by decide) g tail
  | seqExit first second before result head exit => exact (exit (frame kLoop s out (by decide) head).1).elim

theorem while_k (s : State) (out : Result) (p0i : BitVec 32) (slot : U32Slot s "k" 10)
    (params : Params s p0i) (raw : RawWord s)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec whileK s out) : U32Slot out.state "k" 12 := by
  cases source with
  | seqNormal first second before middle result head tail =>
      have k := (k_loop s ⟨middle,.normal⟩ p0i slot params raw initialization head).1
      rw [k_increment middle out 11 12 k (by decide) tail]
      exact set32_slot middle "k" 12
  | seqExit first second before result head exit => exact (exit (frame kLoop s out (by decide) head).1).elim

def initialList : List Stmt := declarations++[rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]
def initialCode : Stmt := chainOf initialList

structure Ready (p0i : BitVec 32) (s : State) : Prop where
  params : Params s p0i
  logn : U32Slot s "logn" 10
  full : U32Slot s "full" 1
  g : Word s "g" 1
  u : Declared s "u" .uint64
  k : Declared s "k" .uint32

theorem initial_result (s : State) (out : Result) (p0i : BitVec 32)
    (params : Params s p0i) (logn : U32Slot s "logn" 10) (full : U32Slot s "full" 1)
    (g : U32Slot s "g" KeygenFirstPrime.generator)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec initialCode s out) : Ready p0i out.state := by
  obtain ⟨s1,du,tail1⟩ := chain_inv _ _ s out (by decide) source
  obtain ⟨s2,dk,tail2⟩ := chain_inv _ _ s1 out (by decide) tail1
  obtain ⟨s3,dw,tail3⟩ := chain_inv _ _ s2 out (by decide) tail2
  obtain ⟨s4,ra,tail4⟩ := chain_inv _ _ s3 out (by decide) tail3
  obtain ⟨s5,r2a,tail5⟩ := chain_inv _ _ s4 out (by decide) tail4
  obtain ⟨s6,gc,tail6⟩ := chain_inv _ _ s5 out (by decide) tail5
  obtain ⟨s7,ka,tail7⟩ := chain_inv _ _ s6 out (by decide) tail6
  obtain ⟨s8,nf,tail8⟩ := chain_inv _ _ s7 out (by decide) tail7
  obtain ⟨s9,squares,tail9⟩ := chain_inv _ _ s8 out (by decide) tail8
  obtain ⟨s10,ia,last⟩ := chain_inv _ _ s9 out (by decide) tail9
  have hend := C99ModularReference.skip_result s10 out last
  have p1 := params_transport _ s ⟨s1,.normal⟩ p0i (by decide) (by decide) (by decide) params du
  have p2 := params_transport _ s1 ⟨s2,.normal⟩ p0i (by decide) (by decide) (by decide) p1 dk
  have p3 := params_transport _ s2 ⟨s3,.normal⟩ p0i (by decide) (by decide) (by decide) p2 dw
  have p4 := params_transport _ s3 ⟨s4,.normal⟩ p0i (by decide) (by decide) (by decide) p3 ra
  have p5 := params_transport _ s4 ⟨s5,.normal⟩ p0i (by decide) (by decide) (by decide) p4 r2a
  have p6 := params_transport _ s5 ⟨s6,.normal⟩ p0i (by decide) (by decide) (by decide) p5 gc
  have p7 := params_transport _ s6 ⟨s7,.normal⟩ p0i (by decide) (by decide) (by decide) p6 ka
  have p8 := params_transport _ s7 ⟨s8,.normal⟩ p0i (by decide) (by decide) (by decide) p7 nf
  have g1 := slot_transport _ s ⟨s1,.normal⟩ "g" _ (by decide) (by decide) g du
  have g2 := slot_transport _ s1 ⟨s2,.normal⟩ "g" _ (by decide) (by decide) g1 dk
  have g3 := slot_transport _ s2 ⟨s3,.normal⟩ "g" _ (by decide) (by decide) g2 dw
  have g4 := slot_transport _ s3 ⟨s4,.normal⟩ "g" _ (by decide) (by decide) g3 ra
  have g5 := slot_transport _ s4 ⟨s5,.normal⟩ "g" _ (by decide) (by decide) g4 r2a
  have hdecl := declare_result s2 ⟨s3,.normal⟩ .u32 ["R","R2","w","ig"] dw
  have r2decl : U32Declared s3 "R2" := by
    have hs := congrArg Result.state hdecl
    change s3=_ at hs
    rw [hs]
    exact ⟨none,by simp [C99ScalarReference.set,C99ValueBridge.type]⟩
  have r2decl4 := declared_transport _ s3 ⟨s4,.normal⟩ "R2" .uint32 (by decide) (by decide) r2decl ra
  obtain ⟨r2,r2slot,rcall⟩ := r2_assignment s4 ⟨s5,.normal⟩ p0i p4 r2decl4 r2a
  have raw6 := conversion s5 ⟨s6,.normal⟩ p0i r2 p5 initialization g5 r2slot rcall gc
  have kd : Declared s2 "k" .uint32 := by
    have hs := congrArg Result.state (declare_result s1 ⟨s2,.normal⟩ .u32 ["k"] dk)
    change s2=_ at hs
    rw [hs]
    exact ⟨none,by simp [C99ScalarReference.set,C99ValueBridge.type]⟩
  have kd3 := declared_transport _ s2 ⟨s3,.normal⟩ "k" .uint32 (by decide) (by decide) kd dw
  have kd4 := declared_transport _ s3 ⟨s4,.normal⟩ "k" .uint32 (by decide) (by decide) kd3 ra
  have kd5 := declared_transport _ s4 ⟨s5,.normal⟩ "k" .uint32 (by decide) (by decide) kd4 r2a
  have kd6 := declared_transport _ s5 ⟨s6,.normal⟩ "k" .uint32 (by decide) (by decide) kd5 gc
  have ln1 := slot_transport _ s ⟨s1,.normal⟩ "logn" 10 (by decide) (by decide) logn du
  have ln2 := slot_transport _ s1 ⟨s2,.normal⟩ "logn" 10 (by decide) (by decide) ln1 dk
  have ln3 := slot_transport _ s2 ⟨s3,.normal⟩ "logn" 10 (by decide) (by decide) ln2 dw
  have ln4 := slot_transport _ s3 ⟨s4,.normal⟩ "logn" 10 (by decide) (by decide) ln3 ra
  have ln5 := slot_transport _ s4 ⟨s5,.normal⟩ "logn" 10 (by decide) (by decide) ln4 r2a
  have ln6 := slot_transport _ s5 ⟨s6,.normal⟩ "logn" 10 (by decide) (by decide) ln5 gc
  have kset := assign32 s6 ⟨s7,.normal⟩ "k" _ 10 kd6
    (fun v h => KeygenNttButterflyCalls.variable_u32 s6 "logn" 10 v ln6
      (KeygenNttForwardExec.eval_scalar s6 _ v h)) ka
  have k7 : U32Slot s7 "k" 10 := by
    have hs := congrArg Result.state kset
    change s7=_ at hs
    rw [hs]
    exact set32_slot s6 "k" 10
  have raw7 := raw_transport _ s6 ⟨s7,.normal⟩ (by decide) (by decide) raw6 ka
  have initialHead : Exec (chainOf [indexDecl ["u"],.base (.scalar (.declare .u32 ["k".toList])),
      wordDecl ["R","R2","w","ig"],rAssign,r2Assign,gConvert,kFromLogn0]) s ⟨s7,.normal⟩ :=
    .seqNormal _ _ _ _ _ du (.seqNormal _ _ _ _ _ dk (.seqNormal _ _ _ _ _ dw
      (.seqNormal _ _ _ _ _ ra (.seqNormal _ _ _ _ _ r2a (.seqNormal _ _ _ _ _ gc
        (.seqNormal _ _ _ _ _ ka (.base .skip s7 s7 (.skip s7))))))))
  have full7 := slot_transport _ s ⟨s7,.normal⟩ "full" 1 (by decide) (by decide) full initialHead
  have hs8 : s8=s7 := congrArg Result.state (not_full s7 ⟨s8,.normal⟩ full7 nf)
  have k8 : U32Slot s8 "k" 10 := hs8 ▸ k7
  have raw8 : RawWord s8 := hs8 ▸ raw7
  have groot9 := while_root s8 ⟨s9,.normal⟩ p0i k8 p8 raw8 initialization squares
  have k9 := while_k s8 ⟨s9,.normal⟩ p0i k8 p8 raw8 initialization squares
  have groot10 := word_transport _ s9 ⟨s10,.normal⟩ "g" 1 (by decide) (by decide) groot9 ia
  have k10 := slot_transport _ s9 ⟨s10,.normal⟩ "k" 12 (by decide) (by decide) k9 ia
  have ud : Declared s1 "u" .uint64 := by
    have hs := congrArg Result.state (declare_result s ⟨s1,.normal⟩ .u64 ["u"] du)
    change s1=_ at hs
    rw [hs]
    exact ⟨none,by simp [C99ScalarReference.set,C99ValueBridge.type]⟩
  have ukeep := declared_transport _ s1 out "u" .uint64 (by decide) (by decide) ud tail1
  refine ⟨params_transport _ s out p0i (by decide) (by decide) (by decide) params source,
    slot_transport _ s out "logn" 10 (by decide) (by decide) logn source,
    slot_transport _ s out "full" 1 (by decide) (by decide) full source,?_,ukeep,?_⟩
  · rw [hend]; exact groot10
  · rw [hend]; exact ⟨some (.uint32 12),k10⟩

end FT1536.Source3.KeygenMkgm3Prelude
