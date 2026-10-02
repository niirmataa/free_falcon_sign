import Source3.KeygenNttForwardExec

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Shared machinery for the forward-NTT pass derivations (B1.02 remainder
   2.1.1): statement inversions, uint64 counter/offset arithmetic forced by
   executed evaluations, pointer-position equations and the local-write
   frame fold used by the butterfly loop bodies. The stride magnitude `σ`
   stays symbolic; products of source `size_t` index expressions are kept
   exact by explicit non-overflow (`fit`) premises. Instantiating stride
   through the pinned wrapper call frame belongs to the whole-KeyGen
   control step (B1.07), so nothing here claims `stride = 1`. -/
namespace FT1536.Source3.KeygenNttLoopSupport
open C99ModularReference (Stmt Exec)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open C99MemoryReference (ArrayPointer)

abbrev Name := B20.C.Name

def u64 (n : Nat) : Value := .uint64 (BitVec.ofNat 64 n)
def USlot (s : State) (name : String) (n : Nat) : Prop :=
  s.locals name.toList=some (.uint64,some (u64 n))
def PSlot (s : State) (name : String) (p : ArrayPointer) : Prop :=
  s.arrays name.toList=some p

theorem contains_iff {names : List Name} {n : Name} : names.contains n = true ↔ n ∈ names := by simp

/- Value-level equations forced by executed evaluations. -/
theorem u64_toNat (n : Nat) (h : n<2^64) : (u64 n).integer.toNat=n := by
  have h1 : (BitVec.ofNat 64 n).toNat = n := by
    rw [BitVec.toNat_ofNat]
    exact Nat.mod_eq_of_lt h
  show Int.toNat ((BitVec.ofNat 64 n).toNat : Int)=n
  rw [h1]
  rfl

theorem u64_integer (n : Nat) (h : n<2^64) : (u64 n).integer=(n : Int) := by
  have h1 : (BitVec.ofNat 64 n).toNat = n := by
    rw [BitVec.toNat_ofNat]
    exact Nat.mod_eq_of_lt h
  show ((BitVec.ofNat 64 n).toNat : Int)=(n : Int)
  rw [h1]

theorem convert_u64_nat (n : Nat) : C99IntegerReference.convert .uint64 n=u64 n := by
  show Value.uint64 (BitVec.ofInt 64 ((n : Int)))=u64 n
  rw [BitVec.ofInt_natCast]
  rfl

theorem convert_u64_self (x : Nat) (hx : x<2^64) :
    C99IntegerReference.convert .uint64 (u64 x).integer=u64 x := by
  conv_lhs => rw [u64_integer x hx]
  exact convert_u64_nat x

theorem exact_plus (a b : Int) : C99IntegerReference.exact .plus a b=a+b := rfl
theorem exact_times (a b : Int) : C99IntegerReference.exact .times a b=a*b := rfl

theorem plus_u64 (x y : Nat) (hx : x<2^64) (hy : y<2^64) (v : Value)
    (h : C99IntegerReference.ArithmeticExec .plus (u64 x) (u64 y) v) : v=u64 (x+y) := by
  obtain ⟨safe,he⟩ := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp h)
  have htype : C99IntegerReference.usual (C99IntegerReference.promote (u64 x).type)
      (C99IntegerReference.promote (u64 y).type)=.uint64 := rfl
  rw [htype,convert_u64_self x hx,convert_u64_self y hy,u64_integer x hx,u64_integer y hy,
    exact_plus] at he
  rw [he,← Int.natCast_add,convert_u64_nat]

theorem add_one_literal (x : Nat) (hx : x<2^64) (v : Value)
    (h : C99IntegerReference.ArithmeticExec .plus (u64 x)
      (C99IntegerReference.convert .int32 1) v) : v=u64 (x+1) := by
  obtain ⟨safe,he⟩ := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp h)
  have htype : C99IntegerReference.usual (C99IntegerReference.promote (u64 x).type)
      (C99IntegerReference.promote (C99IntegerReference.convert .int32 1).type)=.uint64 := rfl
  rw [htype,convert_u64_self x hx] at he
  have hc : (C99IntegerReference.convert .int32 1).integer=(1 : Int) := by decide
  have hinner : C99IntegerReference.convert .uint64 (C99IntegerReference.convert .int32 1).integer=u64 1 := by decide
  rw [hinner,u64_integer x hx,u64_integer 1 (by decide),exact_plus] at he
  rw [he,← Int.natCast_add,convert_u64_nat]

theorem add_three_literal (x : Nat) (hx : x<2^64) (v : Value)
    (h : C99IntegerReference.ArithmeticExec .plus (u64 x)
      (C99IntegerReference.convert .int32 3) v) : v=u64 (x+3) := by
  obtain ⟨safe,he⟩ := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp h)
  have htype : C99IntegerReference.usual (C99IntegerReference.promote (u64 x).type)
      (C99IntegerReference.promote (C99IntegerReference.convert .int32 3).type)=.uint64 := rfl
  rw [htype,convert_u64_self x hx] at he
  have hc : (C99IntegerReference.convert .int32 3).integer=(3 : Int) := by decide
  have hinner : C99IntegerReference.convert .uint64 (C99IntegerReference.convert .int32 3).integer=u64 3 := by decide
  rw [hinner,u64_integer x hx,u64_integer 3 (by decide),exact_plus] at he
  rw [he,← Int.natCast_add,convert_u64_nat]

theorem times_u64 (x y : Nat) (hx : x<2^64) (hy : y<2^64) (v : Value)
    (h : C99IntegerReference.ArithmeticExec .times (u64 x) (u64 y) v) : v=u64 (x*y) := by
  obtain ⟨safe,he⟩ := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp h)
  have htype : C99IntegerReference.usual (C99IntegerReference.promote (u64 x).type)
      (C99IntegerReference.promote (u64 y).type)=.uint64 := rfl
  rw [htype,convert_u64_self x hx,convert_u64_self y hy,u64_integer x hx,u64_integer y hy,
    exact_times] at he
  rw [he,← Int.natCast_mul,convert_u64_nat]

theorem convert_div_two (x : Nat) (hx : x<2^64) :
    C99IntegerReference.convert .uint64 ((u64 x).integer/2)=u64 (x/2) := by
  rw [u64_integer x hx]
  have h2 : ((x : Int)/2)=((x/2 : Nat) : Int) := by omega
  rw [h2]
  show Value.uint64 (BitVec.ofInt 64 ((x/2 : Nat) : Int))=u64 (x/2)
  rw [BitVec.ofInt_natCast]
  rfl

theorem convert_mul_two (x : Nat) (hx : x<2^64) :
    C99IntegerReference.convert .uint64 ((u64 x).integer*2)=u64 (x*2) := by
  rw [u64_integer x hx]
  have h2 : ((x : Int)*2)=((x*2 : Nat) : Int) := by omega
  rw [h2]
  show Value.uint64 (BitVec.ofInt 64 ((x*2 : Nat) : Int))=u64 (x*2)
  rw [BitVec.ofInt_natCast]
  rfl

theorem shr_one_u64 (x : Nat) (hx : x<2^64) (v : Value)
    (h : C99IntegerReference.ShiftExec .right (u64 x)
      (C99IntegerReference.convert .int32 1) v) : v=u64 (x/2) := by
  obtain ⟨n,hn,hb,he⟩ := (C99IntegerReference.shift_right_iff _ _ _).mp h
  have hc : (C99IntegerReference.convert .int32 1).integer=(1 : Int) := by decide
  have hn1 : n=1 := by
    rw [hc] at hn
    omega
  subst n
  have hty : (u64 x).type=.uint64 := rfl
  rw [hty] at he
  have h2 : (u64 x).integer/2^1=(u64 x).integer/2 := by simp [pow_one]
  rw [h2,convert_div_two x hx] at he
  exact he

theorem shl_one_u64 (x : Nat) (hx : x<2^64) (v : Value)
    (h : C99IntegerReference.ShiftExec .left (u64 x)
      (C99IntegerReference.convert .int32 1) v) : v=u64 (x*2) := by
  obtain ⟨n,hn,hb,he⟩ := KeygenNttForwardExec.shift_left_value _ _ v h
  have hc : (C99IntegerReference.convert .int32 1).integer=(1 : Int) := by decide
  have hn1 : n=1 := by
    rw [hc] at hn
    omega
  subst n
  have hty : (u64 x).type=.uint64 := rfl
  rw [hty] at he
  have h2 : (u64 x).integer*2^1=(u64 x).integer*2 := by simp [pow_one]
  rw [h2,convert_mul_two x hx] at he
  exact he

/- Variable and literal reads used by the pass guards and index expressions. -/
theorem variable_u64 (s : State) (name : String) (n : Nat) (v : Value)
    (slot : USlot s name n) (source : C99ArrayReference.scalar s (.var name.toList) v) : v=u64 n :=
  C99CountedWords.variable_exact s name.toList .uint64 (u64 n) v slot source

theorem literal_i32 (s : State) (n : Nat) (v : Value)
    (source : C99ArrayReference.scalar s (.literal .i32 n) v) :
    v=C99IntegerReference.convert .int32 n :=
  KeygenNttForwardExec.literal_value s B20.C.Ty.i32 n v source

/- Generic pointer-position equation: the executed bind is the root plus
   the offset evaluated by the pointer's own index evaluation. -/
theorem pointer_root (s : State) (name : Name) (index : CLogic.Expr)
    (root p : ArrayPointer)
    (binding : s.arrays name=some root)
    (source : C99ArrayReference.Pointer s name index p) :
    ∃ i, C99ArrayReference.scalar s index i ∧
      p={root with index := root.index+i.integer.toNat} := by
  cases source with
  | add original _ value bound evaluated nonnegative within =>
      have he : original=root := Option.some.inj (bound.symm.trans binding)
      subst original
      cases within
      exact ⟨value,evaluated,rfl⟩

/- Statement-level inversions (var-major shapes). -/
theorem bindPtr_result (name source : Name) (index : CLogic.Expr) (s : State) (out : Result)
    (h : Exec (.base (.bindPtr name source index)) s out) :
    ∃ p, C99ArrayReference.Pointer s source index p ∧
      out=⟨C99ArrayReference.bindPointer s name p,.normal⟩ := by
  obtain ⟨mid,execution,he⟩ := KeygenNttForwardExec.base_inv _ s out h
  cases execution with
  | bindPtr before name source index p value =>
      exact ⟨p,value,he⟩

theorem store32_result (name : Name) (index : CLogic.Expr) (e : C99ModularReference.Expr)
    (s : State) (out : Result) (h : Exec (.store32 name index e) s out) :
    ∃ after p v, C99ArrayReference.Pointer s name index p ∧
      C99ModularReference.Eval s e v ∧
      C99MemoryReference.Store32 s.heap p (BitVec.ofInt 32 v.integer) after ∧
      out=⟨{s with heap := after},.normal⟩ := by
  cases h with
  | store32 name index e before after p v address value write =>
      exact ⟨after,p,v,address,value,write,rfl⟩

theorem scope_result (names : List Name) (body : Stmt) (s : State) (out : Result)
    (h : Exec (.scope names body) s out) :
    ∃ result, Exec body s result ∧
      out=⟨C99ArrayReference.restoreScope s result.state names [],result.flow⟩ := by
  cases h with
  | scope locals body before result inner => exact ⟨result,inner,rfl⟩

theorem assign_result (name : Name) (e : C99ModularReference.Expr) (s : State) (out : Result)
    (h : Exec (.assign name e) s out) :
    ∃ ty old v, s.locals name=some (ty,old) ∧ C99ModularReference.Eval s e v ∧
      out=⟨C99ArrayReference.bindValue s name ty v,.normal⟩ :=
  KeygenNttForwardExec.assign_inv s name e out h

theorem update_result (name : Name) (op : B20.C.BinOp) (e : CLogic.Expr) (s : State) (out : Result)
    (h : Exec (.base (.scalar (.update name op e))) s out) :
    ∃ ty old v, s.locals name=some (ty,old) ∧
      C99ScalarReference.Eval FprPrefixCalls.calls s.locals
        (C99Frontend.binary op (.variable name) (C99Frontend.expression e)) v ∧
      out=⟨C99ArrayReference.bindValue s name ty v,.normal⟩ := by
  obtain ⟨mid,execution,he⟩ := KeygenNttForwardExec.base_inv _ s out h
  obtain ⟨env,body,hmid⟩ := KeygenNttForwardExec.scalar_inv _ s mid execution
  have key : C99Frontend.scalar (.update name op e)=
      C99ScalarReference.Stmt.assign name
        (C99Frontend.binary op (.variable name) (C99Frontend.expression e)) := rfl
  rw [key] at body
  obtain ⟨ty,old,v,declared,evaluated,henv⟩ := C99ControlInversion.assign_inv _ s.locals _ _ _ body
  have hh : env=C99ScalarReference.set s.locals name
      (ty,some (C99IntegerReference.convert ty v.integer)) :=
    C99ScalarReference.Result.normal.inj henv
  subst env
  rw [he,hmid]
  exact ⟨ty,old,v,declared,evaluated,rfl⟩

/- Local-write frame fold: executing `chain atoms` with local-only atoms
   preserves flow, the pointer map and all locals outside the declared
   write names. Butterfly bodies only write their own block locals and the
   heap; loop counters and pointer slots survive untouched. -/
def FrameOk (names : List Name) (s : State) (out : Result) : Prop :=
  out.flow=.normal ∧ out.state.arrays=s.arrays ∧
    ∀ n, ¬names.contains n → out.state.locals n=s.locals n

def localOnly : Stmt → Option (List Name)
  | .base .skip => some []
  | .base (.scalar (.declare _ names)) => some names
  | .base (.scalar (.assign name _)) => some [name]
  | .base (.scalar (.update name _ _)) => some [name]
  | .assign name _ => some [name]
  | .store32 _ _ _ => some []
  | _ => none

theorem declarations_frame (t : Ty) (names : List Name) (env env' : C99ScalarReference.Env)
    (source : C99ScalarReference.Exec FprPrefixCalls.calls env
      (C99Frontend.declarations t names) (C99ScalarReference.Result.normal env')) :
    ∀ n, ¬names.contains n → env' n=env n := by
  induction names generalizing env env' with
  | nil =>
      intro n hn
      rw [C99ScalarReference.Result.normal.inj
        (C99ControlInversion.skip_inv _ env (C99ScalarReference.Result.normal env') source)]
  | cons name rest ih =>
      obtain ⟨mid,head,tail⟩ := (C99ControlInversion.seq_inv _ env _ _
        (C99ScalarReference.Result.normal env') source).resolve_right (by
        rintro ⟨v,h,he⟩
        cases C99ControlInversion.declare_inv _ env t name (C99ScalarReference.Result.returned v) h)
      have hm := C99ControlInversion.declare_inv _ env t name (C99ScalarReference.Result.normal mid) head
      have hh : mid=C99ScalarReference.set env name (t,none) :=
        C99ScalarReference.Result.normal.inj hm
      subst mid
      intro n hn
      have hnr : ¬rest.contains n := fun hh2 =>
        hn (contains_iff.mpr (List.mem_cons.mpr (Or.inr (contains_iff.mp hh2))))
      have hnn : name≠n := fun hh2 =>
        hn (contains_iff.mpr (List.mem_cons.mpr (Or.inl hh2.symm)))
      have step := ih (C99ScalarReference.set env name (t,none)) env' tail n hnr
      refine step.trans ?_
      show (if n=name then some (t,none) else env n)=env n
      split_ifs with h
      · exact (hnn h.symm).elim
      · rfl

theorem atom_frame (a : Stmt) (writes : List Name) (s : State) (out : Result)
    (source : Exec a s out) (shape : localOnly a=some writes) : FrameOk writes s out := by
  cases source with
  | base code before after execution =>
      cases execution with
      | skip s => exact ⟨rfl,rfl,fun _ _ => rfl⟩
      | scalar before env stmt body =>
          change localOnly (.base (.scalar stmt))=some writes at shape
          cases stmt with
          | declare t names =>
              have hwn : names=writes := by injection shape
              subst writes
              refine ⟨rfl,rfl,?_⟩
              intro n hn
              exact declarations_frame (C99ValueBridge.type t) names s.locals env body n hn
          | assign name rhs =>
              have hwn : [name]=writes := by injection shape
              subst writes
              obtain ⟨ty,old,v,declared,evaluated,henv⟩ := C99ControlInversion.assign_inv
                FprPrefixCalls.calls s.locals name (C99Frontend.expression rhs)
                (C99ScalarReference.Result.normal env) body
              have hh : env=C99ScalarReference.set s.locals name
                  (ty,some (C99IntegerReference.convert ty v.integer)) :=
                C99ScalarReference.Result.normal.inj henv
              subst env
              refine ⟨rfl,rfl,?_⟩
              intro n hn
              have hnn : n≠name := fun hh2 => hn (contains_iff.mpr (by simp [hh2]))
              show (if n=name then some (ty,some (C99IntegerReference.convert ty v.integer)) else s.locals n)=s.locals n
              split_ifs with h
              · exact (hnn h).elim
              · rfl
          | update name op rhs =>
              have hwn : [name]=writes := by injection shape
              subst writes
              obtain ⟨ty,old,v,declared,evaluated,henv⟩ := C99ControlInversion.assign_inv
                FprPrefixCalls.calls s.locals name
                (C99Frontend.binary op (.variable name) (C99Frontend.expression rhs))
                (C99ScalarReference.Result.normal env) body
              have hh : env=C99ScalarReference.set s.locals name
                  (ty,some (C99IntegerReference.convert ty v.integer)) :=
                C99ScalarReference.Result.normal.inj henv
              subst env
              refine ⟨rfl,rfl,?_⟩
              intro n hn
              have hnn : n≠name := fun hh2 => hn (contains_iff.mpr (by simp [hh2]))
              show (if n=name then some (ty,some (C99IntegerReference.convert ty v.integer)) else s.locals n)=s.locals n
              split_ifs with h
              · exact (hnn h).elim
              · rfl
          | ret e =>
              have key : C99Frontend.scalar (.ret e)=
                  C99ScalarReference.Stmt.ret (C99Frontend.expression e) := rfl
              rw [key] at body
              cases body
      | assign before name e ty old v declared value =>
          have hwn : [name]=writes := by injection shape
          subst writes
          refine ⟨rfl,rfl,?_⟩
          intro n hn
          have hnn : n≠name := fun hh2 => hn (contains_iff.mpr (by simp [hh2]))
          show (if n=name then some (ty,some (C99IntegerReference.convert ty v.integer)) else s.locals n)=s.locals n
          split_ifs with h
          · exact (hnn h).elim
          · rfl
      | declarePtr before name => simp [localOnly] at shape
      | bindPtr before name source index p value => simp [localOnly] at shape
      | store64 before after array index e p v address value write => simp [localOnly] at shape
      | store32 before after array index e p v address value write =>
          exact ⟨rfl,rfl,fun _ _ => rfl⟩
      | copy before after dst src di si count p q n destination source length destinationObject sourceObject copied =>
          simp [localOnly] at shape
      | seq a b before middle after first second => simp [localOnly] at shape
      | scope locals pointers body before after inner => simp [localOnly] at shape
      | branchTrue condition yes no before after v guard nonzero body => simp [localOnly] at shape
      | branchFalse condition yes no before after v guard zero body => simp [localOnly] at shape
      | whileFalse condition body s v guard zero => simp [localOnly] at shape
      | whileTrue condition body before middle after v guard nonzero step rest => simp [localOnly] at shape
      | call name args f before entry result source parameters body => simp [localOnly] at shape
  | assign name e before ty old v declared value =>
      have hwn : [name]=writes := by injection shape
      subst writes
      refine ⟨rfl,rfl,?_⟩
      intro n hn
      have hnn : n≠name := fun hh2 => hn (contains_iff.mpr (by simp [hh2]))
      show (if n=name then some (ty,some (C99IntegerReference.convert ty v.integer)) else s.locals n)=s.locals n
      split_ifs with h
      · exact (hnn h).elim
      · rfl
  | store32 name index e before after p v address value write =>
      exact ⟨rfl,rfl,fun _ _ => rfl⟩
  | seqNormal first second before middle result head tail => simp [localOnly] at shape
  | seqExit first second before result head exit => simp [localOnly] at shape
  | scope locals body before result inner => simp [localOnly] at shape
  | branchTrue condition yes no before result v guard nonzero body => simp [localOnly] at shape
  | branchFalse condition yes no before result v guard zero body => simp [localOnly] at shape
  | loopFalse condition body increment before v guard zero => simp [localOnly] at shape
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest =>
      simp [localOnly] at shape
  | loopReturn condition body increment before after v value guard nonzero iteration =>
      simp [localOnly] at shape
  | ret e before v value => simp [localOnly] at shape
  | retVoid before => simp [localOnly] at shape

theorem chain_frame (P : Name → Prop) (atoms : List Stmt) (s : State) (out : Result)
    (source : Exec (KeygenNttButterflyPrograms.chain atoms) s out)
    (each : ∀ a ∈ atoms, ∀ s out, Exec a s out →
      ∃ ws : List Name, localOnly a=some ws ∧ FrameOk ws s out ∧ ∀ n, ws.contains n → P n) :
    ∃ ws : List Name, (∀ n, ¬ws.contains n → out.state.locals n=s.locals n) ∧
      (∀ n, ws.contains n → P n) ∧ out.flow=.normal ∧ out.state.arrays=s.arrays := by
  induction atoms generalizing s out with
  | nil =>
      have he := C99ModularReference.skip_result s out source
      subst out
      exact ⟨[],fun _ _ => rfl,
        fun n hn => (List.not_mem_nil (contains_iff.mp hn)).elim,rfl,rfl⟩
  | cons a rest ih =>
      have eachRest : ∀ x ∈ rest, ∀ s out, Exec x s out →
          ∃ ws : List Name, localOnly x=some ws ∧ FrameOk ws s out ∧ ∀ n, ws.contains n → P n :=
        fun x hin s' out' hs => each x (List.mem_cons.mpr (Or.inr hin)) s' out' hs
      obtain ⟨mid,head,tail⟩ := (KeygenNttForwardExec.seq_inv _ _ s out source).resolve_right (by
        rintro ⟨r,hr,hexit,heq⟩
        subst r
        obtain ⟨ws,shape,frame,_⟩ := each a (by simp) s out hr
        exact hexit frame.1)
      obtain ⟨ws,shape,frame,covered⟩ := each a (by simp) s ⟨mid,.normal⟩ head
      obtain ⟨ws',keep,cover,flow,arrays⟩ := ih mid out tail eachRest
      refine ⟨ws'++ws,?_,?_,flow,arrays.trans frame.2.1⟩
      · intro n hn
        have split : ¬ws'.contains n ∧ ¬ws.contains n := by
          refine ⟨fun hh => hn (contains_iff.mpr (List.mem_append.mpr (Or.inl (contains_iff.mp hh)))),
            fun hh => hn (contains_iff.mpr (List.mem_append.mpr (Or.inr (contains_iff.mp hh))))⟩
        exact (keep n split.1).trans (frame.2.2 n split.2)
      · intro n hn
        have split : ws'.contains n ∨ ws.contains n := by
          have hmem : n ∈ ws' ++ ws := contains_iff.mp hn
          have hsplit : n ∈ ws' ∨ n ∈ ws := List.mem_append.mp hmem
          cases hsplit with
          | inl h => exact Or.inl (contains_iff.mpr h)
          | inr h => exact Or.inr (contains_iff.mpr h)
        cases split with
        | inl h => exact cover n h
        | inr h => exact covered n h

theorem block_frame (decls : List Name) (atoms : List Stmt) (s : State) (out : Result)
    (source : Exec (.scope decls (KeygenNttButterflyPrograms.chain atoms)) s out)
    (each : ∀ a ∈ atoms, ∀ s out, Exec a s out →
      ∃ ws : List Name, localOnly a=some ws ∧ FrameOk ws s out ∧ ∀ n, ws.contains n → decls.contains n) :
    out.flow=.normal ∧ out.state.arrays=s.arrays ∧ out.state.locals=s.locals := by
  obtain ⟨result,inner,hout⟩ := scope_result decls (KeygenNttButterflyPrograms.chain atoms) s out source
  obtain ⟨ws,keep,cover,flow,arrays⟩ := chain_frame (fun n => decls.contains n) atoms s result inner each
  subst out
  refine ⟨flow,?_,?_⟩
  · funext n
    show (if ([].contains n) then s.arrays n else result.state.arrays n)=s.arrays n
    split_ifs with h
    · exact (List.not_mem_nil (contains_iff.mp h)).elim
    · exact congrFun arrays n
  · funext n
    show (if (decls.contains n) then s.locals n else result.state.locals n)=s.locals n
    split_ifs with h
    · rfl
    · have hnws : ¬ws.contains n := fun hh => h (cover n hh)
      exact keep n hnws

end FT1536.Source3.KeygenNttLoopSupport
