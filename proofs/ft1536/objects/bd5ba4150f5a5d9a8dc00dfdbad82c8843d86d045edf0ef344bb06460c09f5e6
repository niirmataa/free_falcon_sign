import Source3.KeygenNttTripleLoop
import Source3.KeygenNttButterflyAlgebra

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Butterfly call-observation extraction (B1.02 remainder 2.1.2, old 2.4).
   The FirstCalls/BinaryCalls/TripleCalls call-observation structures of
   KeygenNttButterflyAlgebra become CONCLUSIONS of executions of the parsed
   memory/control bodies firstBody/binaryBody/tripleBody: each fixed chain
   is walked with evaluation inversions and store32_result, assembling the
   pinned source-call structures with Load32/Store32 witnesses at the
   current r1/r2 (and gm) positions, which the pass modules pin per
   iteration. Until this module those call observations were interface
   premises only (call-premise leakage). No value/range/polynomial
   invariant appears here (B1.04 scope); all words stay symbolic. -/
namespace FT1536.Source3.KeygenNttButterflyCalls
open C99ModularReference (Stmt Exec Eval)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open C99MemoryReference (ArrayPointer)
open KeygenNttLoopSupport (u64 USlot PSlot contains_iff)

abbrev BMul := KeygenNttButterflyAlgebra.Mul
abbrev BAdd := KeygenNttButterflyAlgebra.Add
abbrev BSub := KeygenNttButterflyAlgebra.Sub

def U32Slot (s : State) (name : String) (w : BitVec 32) : Prop :=
  s.locals name.toList=some (Ty.uint32,some (Value.uint32 w))
def U32Declared (s : State) (name : String) : Prop :=
  ∃ old : Option Value, s.locals name.toList=some (Ty.uint32,old)

/- Value-level roundtrips: storing a uint32 word writes that exact word. -/
theorem ofInt_u32 (w : BitVec 32) : BitVec.ofInt 32 (Value.uint32 w).integer=w := by
  show BitVec.ofInt 32 (w.toNat : Int)=w
  rw [BitVec.ofInt_natCast]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ofNat]
  exact Nat.mod_eq_of_lt w.isLt

theorem convert_u32 (w : BitVec 32) :
    C99IntegerReference.convert Ty.uint32 (Value.uint32 w).integer=Value.uint32 w := by
  show Value.uint32 (BitVec.ofInt 32 (w.toNat : Int))=Value.uint32 w
  rw [BitVec.ofInt_natCast]
  congr 1
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_ofNat]
  exact Nat.mod_eq_of_lt w.isLt

theorem variable_u32 (s : State) (name : String) (w : BitVec 32) (v : Value)
    (slot : U32Slot s name w) (source : C99ArrayReference.scalar s (.var name.toList) v) : v=.uint32 w :=
  C99CountedWords.variable_exact s name.toList .uint32 (.uint32 w) v slot source

theorem u32_keep {s s' : State} {name : String} {w : BitVec 32}
    (h : s'.locals name.toList=s.locals name.toList) (hh : U32Slot s name w) : U32Slot s' name w :=
  h.trans hh

theorem u64_keep {s s' : State} {name : String} {n : Nat}
    (h : s'.locals name.toList=s.locals name.toList) (hh : USlot s name n) : USlot s' name n :=
  h.trans hh

theorem declared_keep {s s' : State} {name : String}
    (h : s'.locals name.toList=s.locals name.toList) (hh : U32Declared s name) :
    U32Declared s' name := by
  obtain ⟨old,ho⟩ := hh
  exact ⟨old,h.trans ho⟩

/- Evaluation inversions for the read atoms. -/
theorem load_exists (s : State) (name : String) (index : CLogic.Expr) (v : Value)
    (source : Eval s (KeygenNttButterflyPrograms.read name index) v) :
    ∃ q w, C99ArrayReference.Pointer s name.toList index q ∧
      C99MemoryReference.Load32 s.heap q w ∧ v=.uint32 w := by
  cases source with
  | load32 _ _ q w address loaded => exact ⟨q,w,address,loaded,rfl⟩

theorem zero_value (s : State) (i : Value)
    (source : C99ArrayReference.scalar s KeygenNttButterflyPrograms.zero i) : i=u64 0 := by
  have h := KeygenNttForwardExec.literal_value s B20.C.Ty.u64 0 i source
  rw [h]
  exact KeygenNttLoopSupport.convert_u64_nat 0

theorem var_value (s : State) (idxName : String) (ρ : Nat) (i : Value)
    (slot : USlot s idxName ρ) (source : C99ArrayReference.scalar s (.var idxName.toList) i) :
    i=u64 ρ :=
  KeygenNttLoopSupport.variable_u64 s idxName ρ i slot source

/- The executed `2*stride` index product of the triple-pass accesses. -/
theorem times_two (y : Nat) (hy : y<2^64) (v : Value)
    (h : C99IntegerReference.ArithmeticExec .times (C99IntegerReference.convert .int32 2)
      (u64 y) v) : v=u64 (2*y) := by
  obtain ⟨safe,he⟩ := (C99IntegerReference.arithmetic_iff _ _ _ _ |>.mp h)
  have htype : C99IntegerReference.usual
      (C99IntegerReference.promote (C99IntegerReference.convert .int32 2).type)
      (C99IntegerReference.promote (u64 y).type)=.uint64 := rfl
  rw [htype] at he
  have hc : (C99IntegerReference.convert .int32 2).integer=(2 : Int) := by decide
  have hinner : C99IntegerReference.convert .uint64
      (C99IntegerReference.convert .int32 2).integer=u64 2 := by decide
  rw [hinner,KeygenNttLoopSupport.convert_u64_self y hy] at he
  rw [KeygenNttLoopSupport.u64_integer 2 (by decide),KeygenNttLoopSupport.u64_integer y hy,
    KeygenNttLoopSupport.exact_times] at he
  rw [he,← Int.natCast_mul,KeygenNttLoopSupport.convert_u64_nat]

theorem twice_value (s : State) (σ : Nat) (i : Value) (hσ : σ<2^64)
    (st : USlot s "stride" σ)
    (source : C99ArrayReference.scalar s KeygenNttButterflyPrograms.twiceStride i) :
    i=u64 (2*σ) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (.arithmetic .times (.literal .int32 2) (.variable "stride".toList)) i at source
  obtain ⟨x,y,hx,hy,hop⟩ := KeygenNttForwardExec.eval_arith s.locals .times _ _ i source
  have hx1 : x=C99IntegerReference.convert .int32 2 := KeygenNttLoopSupport.literal_i32 s 2 x hx
  have hy1 : y=u64 σ := KeygenNttLoopSupport.variable_u64 s "stride" σ y st hy
  subst x
  subst y
  exact times_two σ hσ i hop

/- Generic position extraction: the executed bind is the root plus the
   evaluated index, at the u64-exact magnitude k. -/
theorem pointer_at (s : State) (name : String) (index : CLogic.Expr) (root q : ArrayPointer)
    (k : Nat) (slot : PSlot s name root)
    (value : ∀ i, C99ArrayReference.scalar s index i → i=u64 k) (hk : k<2^64)
    (source : C99ArrayReference.Pointer s name.toList index q) :
    q={root with index := root.index+k} := by
  obtain ⟨i,ev,hroot⟩ := KeygenNttLoopSupport.pointer_root s name.toList index root q slot source
  have hi := value i ev
  subst i
  rw [hroot,KeygenNttLoopSupport.u64_toNat k hk]

theorem load_at (s : State) (name : String) (index : CLogic.Expr) (root : ArrayPointer)
    (k : Nat) (v : Value) (slot : PSlot s name root)
    (value : ∀ i, C99ArrayReference.scalar s index i → i=u64 k) (hk : k<2^64)
    (source : Eval s (KeygenNttButterflyPrograms.read name index) v) :
    ∃ w, v=.uint32 w ∧ C99MemoryReference.Load32 s.heap {root with index := root.index+k} w := by
  obtain ⟨q,w,hp,hl,hv⟩ := load_exists s name index v source
  rw [pointer_at s name index root q k slot value hk hp] at hl
  exact ⟨w,hv,hl⟩

/- Call inversions without case-binder absorption: the fixed table pins
   one constructor per callee name; fields that unify with the surrounding
   derivation are referenced directly. -/
theorem mont_inv {args : List Value} {out : Value}
    (h : C99ModularReference.ModCall "modp_montymul".toList args out) :
    C99ScalarReference.FunctionExec C99Frontend.noCalls
      (C99Frontend.headerFunction KeygenModpWord.montgomeryCode) args out := by
  cases h with
  | montgomery args out body => exact body

theorem add_inv {args : List Value} {out : Value}
    (h : C99ModularReference.ModCall "modp_add".toList args out) :
    C99ScalarReference.FunctionExec C99Frontend.noCalls
      (C99Frontend.headerFunction (KeygenModpAddSub.code .add)) args out := by
  cases h with
  | add args out body => exact body

theorem sub_inv {args : List Value} {out : Value}
    (h : C99ModularReference.ModCall "modp_sub".toList args out) :
    C99ScalarReference.FunctionExec C99Frontend.noCalls
      (C99Frontend.headerFunction (KeygenModpAddSub.code .sub)) args out := by
  cases h with
  | sub args out body => exact body

/- Call-observation extraction for the fixed primitive-call shapes. -/
theorem mont_result (s : State) (leftName rightName : String) (a b p0i : BitVec 32) (v : Value)
    (left : U32Slot s leftName a) (right : U32Slot s rightName b)
    (prime : U32Slot s "p" KeygenNinv31.prime) (inverse : U32Slot s "p0i" p0i)
    (source : Eval s (KeygenNttButterflyPrograms.mont
      (KeygenNttButterflyPrograms.scalar leftName)
      (KeygenNttButterflyPrograms.scalar rightName)) v) :
    ∃ product, v=.uint32 product ∧ BMul p0i a b product := by
  cases source with
  | call4 nm e1 e2 e3 e4 x1 x2 x3 x4 vout first second third fourth invoked =>
      have hx1 : x1=.uint32 a :=
        variable_u32 s leftName a x1 left (KeygenNttForwardExec.eval_scalar s _ x1 first)
      have hx2 : x2=.uint32 b :=
        variable_u32 s rightName b x2 right (KeygenNttForwardExec.eval_scalar s _ x2 second)
      have hx3 : x3=.uint32 KeygenNinv31.prime :=
        variable_u32 s "p" KeygenNinv31.prime x3 prime
          (KeygenNttForwardExec.eval_scalar s _ x3 third)
      have hx4 : x4=.uint32 p0i :=
        variable_u32 s "p0i" p0i x4 inverse (KeygenNttForwardExec.eval_scalar s _ x4 fourth)
      subst x1
      subst x2
      subst x3
      subst x4
      have callBody := mont_inv invoked
      have hex := KeygenModpWord.source_exact a b KeygenNinv31.prime p0i v callBody
      refine ⟨KeygenModpWord.montgomery a b KeygenNinv31.prime p0i,hex,?_⟩
      rw [hex] at callBody
      exact callBody

theorem add_result (s : State) (leftName rightName : String) (a b : BitVec 32) (v : Value)
    (left : U32Slot s leftName a) (right : U32Slot s rightName b)
    (prime : U32Slot s "p" KeygenNinv31.prime)
    (source : Eval s (KeygenNttButterflyPrograms.add
      (KeygenNttButterflyPrograms.scalar leftName)
      (KeygenNttButterflyPrograms.scalar rightName)) v) :
    ∃ sum, v=.uint32 sum ∧ BAdd a b sum := by
  cases source with
  | call3 nm e1 e2 e3 x1 x2 x3 vout first second third invoked =>
      have hx1 : x1=.uint32 a :=
        variable_u32 s leftName a x1 left (KeygenNttForwardExec.eval_scalar s _ x1 first)
      have hx2 : x2=.uint32 b :=
        variable_u32 s rightName b x2 right (KeygenNttForwardExec.eval_scalar s _ x2 second)
      have hx3 : x3=.uint32 KeygenNinv31.prime :=
        variable_u32 s "p" KeygenNinv31.prime x3 prime
          (KeygenNttForwardExec.eval_scalar s _ x3 third)
      subst x1
      subst x2
      subst x3
      have callBody := add_inv invoked
      have hex := KeygenModpAddSub.source_exact .add a b KeygenNinv31.prime v callBody
      refine ⟨KeygenModpAddSub.result .add a b KeygenNinv31.prime,hex,?_⟩
      rw [hex] at callBody
      exact callBody

theorem sub_result (s : State) (leftName rightName : String) (a b : BitVec 32) (v : Value)
    (left : U32Slot s leftName a) (right : U32Slot s rightName b)
    (prime : U32Slot s "p" KeygenNinv31.prime)
    (source : Eval s (KeygenNttButterflyPrograms.sub
      (KeygenNttButterflyPrograms.scalar leftName)
      (KeygenNttButterflyPrograms.scalar rightName)) v) :
    ∃ d, v=.uint32 d ∧ BSub a b d := by
  cases source with
  | call3 nm e1 e2 e3 x1 x2 x3 vout first second third invoked =>
      have hx1 : x1=.uint32 a :=
        variable_u32 s leftName a x1 left (KeygenNttForwardExec.eval_scalar s _ x1 first)
      have hx2 : x2=.uint32 b :=
        variable_u32 s rightName b x2 right (KeygenNttForwardExec.eval_scalar s _ x2 second)
      have hx3 : x3=.uint32 KeygenNinv31.prime :=
        variable_u32 s "p" KeygenNinv31.prime x3 prime
          (KeygenNttForwardExec.eval_scalar s _ x3 third)
      subst x1
      subst x2
      subst x3
      have callBody := sub_inv invoked
      have hex := KeygenModpAddSub.source_exact .sub a b KeygenNinv31.prime v callBody
      refine ⟨KeygenModpAddSub.result .sub a b KeygenNinv31.prime,hex,?_⟩
      rw [hex] at callBody
      exact callBody

/- `*dst = modp_sub(modp_add(x, y, p), z, p)` of the first butterfly. -/
theorem sub_add_result (s : State) (xName yName zName : String) (a b c : BitVec 32) (v : Value)
    (x : U32Slot s xName a) (y : U32Slot s yName b) (z : U32Slot s zName c)
    (prime : U32Slot s "p" KeygenNinv31.prime)
    (source : Eval s (KeygenNttButterflyPrograms.sub
      (KeygenNttButterflyPrograms.add
        (KeygenNttButterflyPrograms.scalar xName)
        (KeygenNttButterflyPrograms.scalar yName))
      (KeygenNttButterflyPrograms.scalar zName)) v) :
    ∃ sum d, v=.uint32 d ∧ BAdd a b sum ∧ BSub sum c d := by
  cases source with
  | call3 nm e1 e2 e3 x1 x2 x3 vout first second third invoked =>
      obtain ⟨sum,hsum,hadd⟩ := add_result s xName yName a b x1 x y prime first
      have hx2 : x2=.uint32 c :=
        variable_u32 s zName c x2 z (KeygenNttForwardExec.eval_scalar s _ x2 second)
      have hx3 : x3=.uint32 KeygenNinv31.prime :=
        variable_u32 s "p" KeygenNinv31.prime x3 prime
          (KeygenNttForwardExec.eval_scalar s _ x3 third)
      subst x1
      subst x2
      subst x3
      have callBody := sub_inv invoked
      have hex := KeygenModpAddSub.source_exact .sub sum c KeygenNinv31.prime v callBody
      refine ⟨sum,KeygenModpAddSub.result .sub sum c KeygenNinv31.prime,hex,hadd,?_⟩
      rw [hex] at callBody
      exact callBody

/- `*dst = modp_add(x, modp_add(y, z, p), p)` of the triple butterfly. -/
theorem add_add_right_result (s : State) (xName yName zName : String) (a b c : BitVec 32)
    (v : Value)
    (x : U32Slot s xName a) (y : U32Slot s yName b) (z : U32Slot s zName c)
    (prime : U32Slot s "p" KeygenNinv31.prime)
    (source : Eval s (KeygenNttButterflyPrograms.add
      (KeygenNttButterflyPrograms.scalar xName)
      (KeygenNttButterflyPrograms.add
        (KeygenNttButterflyPrograms.scalar yName)
        (KeygenNttButterflyPrograms.scalar zName))) v) :
    ∃ sum d, v=.uint32 d ∧ BAdd b c sum ∧ BAdd a sum d := by
  cases source with
  | call3 nm e1 e2 e3 x1 x2 x3 vout first second third invoked =>
      have hx1 : x1=.uint32 a :=
        variable_u32 s xName a x1 x (KeygenNttForwardExec.eval_scalar s _ x1 first)
      obtain ⟨sum,hsum,hadd⟩ := add_result s yName zName b c x2 y z prime second
      have hx3 : x3=.uint32 KeygenNinv31.prime :=
        variable_u32 s "p" KeygenNinv31.prime x3 prime
          (KeygenNttForwardExec.eval_scalar s _ x3 third)
      subst x1
      subst x2
      subst x3
      have callBody := add_inv invoked
      have hex := KeygenModpAddSub.source_exact .add a sum KeygenNinv31.prime v callBody
      refine ⟨sum,KeygenModpAddSub.result .add a sum KeygenNinv31.prime,hex,hadd,?_⟩
      rw [hex] at callBody
      exact callBody

/- Chain-walk support: per-atom result packages in a uniform shape. -/
theorem normal_base (code : C99ArrayReference.Stmt) (s : State) (r : Result)
    (h : Exec (.base code) s r) : r.flow=.normal := by
  obtain ⟨mid,execution,he⟩ := KeygenNttForwardExec.base_inv code s r h
  exact congrArg C99ProcedureReference.Result.flow he

theorem normal_assign (name : B20.C.Name) (e : C99ModularReference.Expr) (s : State)
    (r : Result) (h : Exec (.assign name e) s r) : r.flow=.normal := by
  obtain ⟨ty,old,v,_,_,he⟩ := KeygenNttLoopSupport.assign_result name e s r h
  exact congrArg C99ProcedureReference.Result.flow he

theorem normal_store32 (name : B20.C.Name) (index : CLogic.Expr) (e : C99ModularReference.Expr)
    (s : State) (r : Result) (h : Exec (.store32 name index e) s r) : r.flow=.normal := by
  obtain ⟨after,p,v,_,_,_,he⟩ := KeygenNttLoopSupport.store32_result name index e s r h
  exact congrArg C99ProcedureReference.Result.flow he

theorem declaration_result (t : B20.C.Ty) (names : List B20.C.Name) (s : State) (out : Result)
    (source : Exec (.base (.scalar (CLogic.Stmt.declare t names))) s out) :
    out.flow=.normal ∧ out.state.arrays=s.arrays ∧ out.state.heap=s.heap ∧
      out.state.locals=names.foldl
        (fun e n => C99ScalarReference.set e n (C99ValueBridge.type t,none)) s.locals ∧
      ∀ n, ¬names.contains n → out.state.locals n=s.locals n := by
  obtain ⟨mid,execution,he⟩ := KeygenNttForwardExec.base_inv _ s out source
  obtain ⟨env,body,hmid⟩ := KeygenNttForwardExec.scalar_inv _ s mid execution
  have hd := KeygenNttForwardExec.declarations_result s.locals (C99ValueBridge.type t) names
    (C99ScalarReference.Result.normal env) body
  have henv : env=names.foldl
      (fun e n => C99ScalarReference.set e n (C99ValueBridge.type t,none)) s.locals :=
    C99ScalarReference.Result.normal.inj hd
  have hframe := KeygenNttLoopSupport.declarations_frame (C99ValueBridge.type t) names s.locals
    env body
  subst env
  rw [he,hmid]
  refine ⟨rfl,rfl,rfl,rfl,?_⟩
  intro n hn
  exact hframe n hn

theorem assign32_result (Q : BitVec 32 → Prop) (s : State) (name : String)
    (e : C99ModularReference.Expr) (out : Result)
    (declared : U32Declared s name)
    (source : Exec (.assign name.toList e) s out)
    (extract : ∀ v, Eval s e v → ∃ w : BitVec 32, v=.uint32 w ∧ Q w) :
    ∃ w, Q w ∧ U32Slot out.state name w ∧ out.state.arrays=s.arrays ∧
      out.state.heap=s.heap ∧ out.state.locals=C99ScalarReference.set s.locals name.toList
        (Ty.uint32,some (Value.uint32 w)) ∧
      ∀ n, ¬[name.toList].contains n → out.state.locals n=s.locals n := by
  obtain ⟨ty,old,v,pre,evaluated,he⟩ :=
    KeygenNttLoopSupport.assign_result name.toList e s out source
  obtain ⟨oldv,hcell⟩ := declared
  have hty : ty=.uint32 := congrArg Prod.fst (Option.some.inj (pre.symm.trans hcell))
  subst ty
  obtain ⟨w,hv,hq⟩ := extract v evaluated
  subst v
  subst out
  refine ⟨w,hq,?_,rfl,rfl,?_,?_⟩
  · show C99ScalarReference.set s.locals name.toList
      (Ty.uint32,some (C99IntegerReference.convert Ty.uint32 (Value.uint32 w).integer))
      name.toList=_
    rw [convert_u32]
    simp [C99ScalarReference.set]
  · show (C99ScalarReference.set s.locals name.toList
      (Ty.uint32,some (C99IntegerReference.convert Ty.uint32 (Value.uint32 w).integer)))=
      C99ScalarReference.set s.locals name.toList (Ty.uint32,some (Value.uint32 w))
    rw [convert_u32]
  · intro n hn
    have hnn : n≠name.toList := by
      intro h
      subst n
      exact hn (contains_iff.mpr (List.mem_singleton.mpr rfl))
    show (if n=name.toList then
      some (Ty.uint32,some (C99IntegerReference.convert Ty.uint32 (Value.uint32 w).integer))
      else s.locals n)=s.locals n
    rw [convert_u32]
    split_ifs with h
    · exact (hnn h).elim
    · rfl

theorem store_result (Q : BitVec 32 → Prop) (s : State) (name : String) (index : CLogic.Expr)
    (e : C99ModularReference.Expr) (pos : ArrayPointer) (out : Result)
    (position : ∀ q, C99ArrayReference.Pointer s name.toList index q → q=pos)
    (extract : ∀ v, Eval s e v → ∃ w : BitVec 32, v=.uint32 w ∧ Q w)
    (source : Exec (.store32 name.toList index e) s out) :
    ∃ h w, Q w ∧ C99MemoryReference.Store32 s.heap pos w h ∧ out.flow=.normal ∧
      out.state.heap=h ∧ out.state.locals=s.locals ∧ out.state.arrays=s.arrays := by
  obtain ⟨after,p,v,address,evaluated,write,he⟩ :=
    KeygenNttLoopSupport.store32_result name.toList index e s out source
  obtain ⟨w,hv,hq⟩ := extract v evaluated
  subst v
  have hp : p=pos := position p address
  subst p
  have hw : BitVec.ofInt 32 (Value.uint32 w).integer=w := ofInt_u32 w
  subst out
  refine ⟨after,w,hq,?_,rfl,rfl,rfl,rfl⟩
  rw [hw] at write
  exact write

/- Static butterfly contexts: the pointer slots and the parameter words
   read by the bodies. Positions are the per-iteration pins of the pass
   modules. FCtx covers the first/binary bodies (r1/r2 and a twiddle word
   under the caller-chosen local name); TCtx adds the triple body's gm
   pointer and stride/r counters. -/
structure FCtx (twName : String) (p1 p2 : ArrayPointer) (w p0i : BitVec 32) (s : State) : Prop where
  low : PSlot s "r1" p1
  high : PSlot s "r2" p2
  twSlot : U32Slot s twName w
  prime : U32Slot s "p" KeygenNinv31.prime
  inverse : U32Slot s "p0i" p0i

structure TCtx (p1 gmP : ArrayPointer) (σ ρ : Nat) (w p0i : BitVec 32) (s : State) : Prop where
  base : PSlot s "r1" p1
  gm : PSlot s "gm" gmP
  st : USlot s "stride" σ
  rv : USlot s "r" ρ
  wSlot : U32Slot s "w" w
  prime : U32Slot s "p" KeygenNinv31.prime
  inverse : U32Slot s "p0i" p0i

theorem fctx_keep {twName : String} {p1 p2 : ArrayPointer} {w p0i : BitVec 32} {s s' : State}
    (fTw : s'.locals twName.toList=s.locals twName.toList)
    (fP : s'.locals "p".toList=s.locals "p".toList)
    (fP0i : s'.locals "p0i".toList=s.locals "p0i".toList)
    (arrays : s'.arrays=s.arrays)
    (hh : FCtx twName p1 p2 w p0i s) : FCtx twName p1 p2 w p0i s' := by
  refine ⟨?_,?_,?_,?_,?_⟩
  · show s'.arrays "r1".toList=some p1
    rw [arrays]
    exact hh.low
  · show s'.arrays "r2".toList=some p2
    rw [arrays]
    exact hh.high
  · exact u32_keep fTw hh.twSlot
  · exact u32_keep fP hh.prime
  · exact u32_keep fP0i hh.inverse

theorem tctx_keep {p1 gmP : ArrayPointer} {σ ρ : Nat} {w p0i : BitVec 32} {s s' : State}
    (fW : s'.locals "w".toList=s.locals "w".toList)
    (fP : s'.locals "p".toList=s.locals "p".toList)
    (fP0i : s'.locals "p0i".toList=s.locals "p0i".toList)
    (fSt : s'.locals "stride".toList=s.locals "stride".toList)
    (fR : s'.locals "r".toList=s.locals "r".toList)
    (arrays : s'.arrays=s.arrays)
    (hh : TCtx p1 gmP σ ρ w p0i s) : TCtx p1 gmP σ ρ w p0i s' := by
  refine ⟨?_,?_,?_,?_,?_,?_,?_⟩
  · show s'.arrays "r1".toList=some p1
    rw [arrays]
    exact hh.base
  · show s'.arrays "gm".toList=some gmP
    rw [arrays]
    exact hh.gm
  · exact u64_keep fSt hh.st
  · exact u64_keep fR hh.rv
  · exact u32_keep fW hh.wSlot
  · exact u32_keep fP hh.prime
  · exact u32_keep fP0i hh.inverse

theorem fresh_single (name other : B20.C.Name) (h : name≠other) : ¬[name].contains other := by
  intro hh
  have mem : other ∈ [name] := contains_iff.mp hh
  exact h (List.mem_singleton.mp mem).symm

/- Probe lemmas for the declaration-step slot derivations. -/
theorem probe_foldl_rfl (env : C99ScalarReference.Env) :
    (["a0","a1","b"].map String.toList).foldl
      (fun e n => C99ScalarReference.set e n (Ty.uint32,none)) env "a0".toList=
      some (Ty.uint32,none) := by
  rfl

theorem probe_foldl_frame (env : C99ScalarReference.Env) :
    (["a0","a1","b"].map String.toList).foldl
      (fun e n => C99ScalarReference.set e n (Ty.uint32,none)) env "w".toList=
      env "w".toList := by
  rfl

theorem probe_foldl_simp (env : C99ScalarReference.Env) :
    (["a0","a1","b"].map String.toList).foldl
      (fun e n => C99ScalarReference.set e n (Ty.uint32,none)) env "a1".toList=
      some (Ty.uint32,none) := by
  simp [C99ScalarReference.set]


/- First butterfly body: the full chain walk. The word observations and
   the FirstCalls structure are extracted from the executed chain; the
   loads sit at the pinned r1/r2 positions and the two stores chain the
   resulting heaps. -/
theorem first_chain (before : State) (out : Result) (p1 p2 : ArrayPointer) (w p0i : BitVec 32)
    (inputs : FCtx "w" p1 p2 w p0i before)
    (source : Exec KeygenNttButterflyPrograms.firstBody before out) :
    ∃ a0 a1 low high h1 h2,
      ∃ _calls : KeygenNttButterflyAlgebra.FirstCalls a0 a1 w p0i low high,
      C99MemoryReference.Load32 before.heap p1 a0 ∧
      C99MemoryReference.Load32 before.heap p2 a1 ∧
      C99MemoryReference.Store32 before.heap p1 low h1 ∧
      C99MemoryReference.Store32 h1 p2 high h2 ∧
      out.flow=.normal ∧ out.state.heap=h2 := by
  obtain ⟨m1,hd,ht1⟩ := (KeygenNttForwardExec.seq_inv _ _ before out source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_base _ _ _ hr))
  obtain ⟨flowD,arrD,heapD,foldD,frameD⟩ := declaration_result .u32
    (["a0","a1","b"].map String.toList) before ⟨m1,.normal⟩ hd
  have in1 : FCtx "w" p1 p2 w p0i m1 :=
    fctx_keep (by rw [foldD]; rfl) (by rw [foldD]; rfl) (by rw [foldD]; rfl) arrD inputs
  have dA0 : U32Declared m1 "a0" := ⟨none,by rw [foldD]; rfl⟩
  have dA1 : U32Declared m1 "a1" := ⟨none,by rw [foldD]; rfl⟩
  have dB : U32Declared m1 "b" := ⟨none,by rw [foldD]; rfl⟩
  obtain ⟨m2,ha0,ht2⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 out ht1).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨a0w,la0,slotA0,arrM2,heapM2,localsM2,frameM2⟩ := assign32_result
    (fun x => C99MemoryReference.Load32 m1.heap p1 x) m1 "a0"
    (KeygenNttButterflyPrograms.read "r1") ⟨m2,.normal⟩ dA0 ha0
    (fun v ev => load_at m1 "r1" KeygenNttButterflyPrograms.zero p1 0 v in1.low
      (fun i hi => zero_value m1 i hi) (by decide) ev)
  have in2 : FCtx "w" p1 p2 w p0i m2 :=
    fctx_keep (frameM2 "w".toList (fresh_single "a0".toList "w".toList (by decide)))
      (frameM2 "p".toList (fresh_single "a0".toList "p".toList (by decide)))
      (frameM2 "p0i".toList (fresh_single "a0".toList "p0i".toList (by decide))) arrM2 in1
  have dA1' : U32Declared m2 "a1" :=
    declared_keep (frameM2 "a1".toList (fresh_single "a0".toList "a1".toList (by decide))) dA1
  have dB' : U32Declared m2 "b" :=
    declared_keep (frameM2 "b".toList (fresh_single "a0".toList "b".toList (by decide))) dB
  obtain ⟨m3,ha1,ht3⟩ := (KeygenNttForwardExec.seq_inv _ _ m2 out ht2).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨a1w,la1,slotA1,arrM3,heapM3,localsM3,frameM3⟩ := assign32_result
    (fun x => C99MemoryReference.Load32 m2.heap p2 x) m2 "a1"
    (KeygenNttButterflyPrograms.read "r2") ⟨m3,.normal⟩ dA1' ha1
    (fun v ev => load_at m2 "r2" KeygenNttButterflyPrograms.zero p2 0 v in2.high
      (fun i hi => zero_value m2 i hi) (by decide) ev)
  have in3 : FCtx "w" p1 p2 w p0i m3 :=
    fctx_keep (frameM3 "w".toList (fresh_single "a1".toList "w".toList (by decide)))
      (frameM3 "p".toList (fresh_single "a1".toList "p".toList (by decide)))
      (frameM3 "p0i".toList (fresh_single "a1".toList "p0i".toList (by decide))) arrM3 in2
  have dB'' : U32Declared m3 "b" :=
    declared_keep (frameM3 "b".toList (fresh_single "a1".toList "b".toList (by decide))) dB'
  have slotA0m3 : U32Slot m3 "a0" a0w :=
    u32_keep (frameM3 "a0".toList (fresh_single "a1".toList "a0".toList (by decide))) slotA0
  obtain ⟨m4,hb,ht4⟩ := (KeygenNttForwardExec.seq_inv _ _ m3 out ht3).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨product,hmul,slotB,arrM4,heapM4,localsM4,frameM4⟩ := assign32_result
    (fun x => BMul p0i a1w w x) m3 "b"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "a1")
      (KeygenNttButterflyPrograms.scalar "w")) ⟨m4,.normal⟩ dB'' hb
    (fun v ev => mont_result m3 "a1" "w" a1w w p0i v slotA1 in3.twSlot in3.prime in3.inverse ev)
  have in4 : FCtx "w" p1 p2 w p0i m4 :=
    fctx_keep (frameM4 "w".toList (fresh_single "b".toList "w".toList (by decide)))
      (frameM4 "p".toList (fresh_single "b".toList "p".toList (by decide)))
      (frameM4 "p0i".toList (fresh_single "b".toList "p0i".toList (by decide))) arrM4 in3
  have slotA0m4 : U32Slot m4 "a0" a0w :=
    u32_keep (frameM4 "a0".toList (fresh_single "b".toList "a0".toList (by decide))) slotA0m3
  have slotA1m4 : U32Slot m4 "a1" a1w :=
    u32_keep (frameM4 "a1".toList (fresh_single "b".toList "a1".toList (by decide))) slotA1
  obtain ⟨m5,hs1,ht5⟩ := (KeygenNttForwardExec.seq_inv _ _ m4 out ht4).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_store32 _ _ _ _ _ hr))
  obtain ⟨h1,low,hlow,stLow,flowS1,heapS1,localsS1,arrS1⟩ := store_result
    (fun x => BAdd a0w product x) m4 "r1" KeygenNttButterflyPrograms.zero
    (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
      (KeygenNttButterflyPrograms.scalar "b")) p1 ⟨m5,.normal⟩
    (fun q hp => pointer_at m4 "r1" KeygenNttButterflyPrograms.zero p1 q 0 in4.low
      (fun i hi => zero_value m4 i hi) (by decide) hp)
    (fun v ev => add_result m4 "a0" "b" a0w product v slotA0m4 slotB in4.prime ev) hs1
  have in5 : FCtx "w" p1 p2 w p0i m5 :=
    fctx_keep (congrFun localsS1 "w".toList) (congrFun localsS1 "p".toList)
      (congrFun localsS1 "p0i".toList) arrS1 in4
  have slotA0m5 : U32Slot m5 "a0" a0w := u32_keep (congrFun localsS1 "a0".toList) slotA0m4
  have slotA1m5 : U32Slot m5 "a1" a1w := u32_keep (congrFun localsS1 "a1".toList) slotA1m4
  have slotBm5 : U32Slot m5 "b" product := u32_keep (congrFun localsS1 "b".toList) slotB
  obtain ⟨m6,hs2,ht6⟩ := (KeygenNttForwardExec.seq_inv _ _ m5 out ht5).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_store32 _ _ _ _ _ hr))
  obtain ⟨h2,high,hhigh,stHigh,flowS2,heapS2,localsS2,arrS2⟩ := store_result
    (fun x => ∃ sum, BAdd a0w a1w sum ∧ BSub sum product x) m5 "r2"
    KeygenNttButterflyPrograms.zero
    (KeygenNttButterflyPrograms.sub
      (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "a0")
        (KeygenNttButterflyPrograms.scalar "a1"))
      (KeygenNttButterflyPrograms.scalar "b")) p2 ⟨m6,.normal⟩
    (fun q hp => pointer_at m5 "r2" KeygenNttButterflyPrograms.zero p2 q 0 in5.high
      (fun i hi => zero_value m5 i hi) (by decide) hp)
    (fun v ev => by
      obtain ⟨sum,d,hv,ha,hs⟩ := sub_add_result m5 "a0" "a1" "b" a0w a1w product v
        slotA0m5 slotA1m5 slotBm5 in5.prime ev
      exact ⟨d,hv,sum,ha,hs⟩) hs2
  obtain ⟨sum,hsum,hsub⟩ := hhigh
  rw [C99ModularReference.skip_result m6 out ht6]
  refine ⟨a0w,a1w,low,high,h1,h2,⟨product,sum,hmul,hlow,hsum,hsub⟩,?_,?_,?_,?_,rfl,?_⟩
  · rw [heapD] at la0
    exact la0
  · rw [heapM2,heapD] at la1
    exact la1
  · rw [heapM4,heapM3,heapM2,heapD] at stLow
    exact stLow
  · rw [heapS1] at stHigh
    exact stHigh
  · exact heapS2

theorem first_calls (before : State) (result : Result) (p1 p2 : ArrayPointer) (w p0i : BitVec 32)
    (inputs : FCtx "w" p1 p2 w p0i before)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.firstBody)
      before result) :
    ∃ a0 a1 low high h1 h2,
      ∃ _calls : KeygenNttButterflyAlgebra.FirstCalls a0 a1 w p0i low high,
      C99MemoryReference.Load32 before.heap p1 a0 ∧
      C99MemoryReference.Load32 before.heap p2 a1 ∧
      C99MemoryReference.Store32 before.heap p1 low h1 ∧
      C99MemoryReference.Store32 h1 p2 high h2 ∧
      result.flow=.normal ∧ result.state.heap=h2 := by
  obtain ⟨inner,innerExec,hout⟩ := KeygenNttLoopSupport.scope_result
    (C99ModularParser.declarations KeygenNttButterflyPrograms.firstBody)
    KeygenNttButterflyPrograms.firstBody before result source
  obtain ⟨a0,a1,low,high,h1,h2,calls,la,lb,st1,st2,fflow,fheap⟩ :=
    first_chain before inner p1 p2 w p0i inputs innerExec
  subst result
  refine ⟨a0,a1,low,high,h1,h2,calls,la,lb,st1,st2,fflow,?_⟩
  show inner.state.heap=h2
  exact fheap

/- Binary butterfly body: the chain walk yields BinaryCalls. -/
theorem binary_chain (before : State) (out : Result) (p1 p2 : ArrayPointer) (tw p0i : BitVec 32)
    (inputs : FCtx "s" p1 p2 tw p0i before)
    (source : Exec KeygenNttButterflyPrograms.binaryBody before out) :
    ∃ x y low high h1 h2,
      ∃ _calls : KeygenNttButterflyAlgebra.BinaryCalls x y tw p0i low high,
      C99MemoryReference.Load32 before.heap p1 x ∧
      C99MemoryReference.Load32 before.heap p2 y ∧
      C99MemoryReference.Store32 before.heap p1 low h1 ∧
      C99MemoryReference.Store32 h1 p2 high h2 ∧
      out.flow=.normal ∧ out.state.heap=h2 := by
  obtain ⟨m1,hd,ht1⟩ := (KeygenNttForwardExec.seq_inv _ _ before out source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_base _ _ _ hr))
  obtain ⟨flowD,arrD,heapD,foldD,frameD⟩ := declaration_result .u32
    (["x","y"].map String.toList) before ⟨m1,.normal⟩ hd
  have in1 : FCtx "s" p1 p2 tw p0i m1 :=
    fctx_keep (by rw [foldD]; rfl) (by rw [foldD]; rfl) (by rw [foldD]; rfl) arrD inputs
  have dX : U32Declared m1 "x" := ⟨none,by rw [foldD]; rfl⟩
  have dY : U32Declared m1 "y" := ⟨none,by rw [foldD]; rfl⟩
  obtain ⟨m2,ha0,ht2⟩ := (KeygenNttForwardExec.seq_inv _ _ m1 out ht1).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨xw,lx,slotX,arrM2,heapM2,localsM2,frameM2⟩ := assign32_result
    (fun x => C99MemoryReference.Load32 m1.heap p1 x) m1 "x"
    (KeygenNttButterflyPrograms.read "r1") ⟨m2,.normal⟩ dX ha0
    (fun v ev => load_at m1 "r1" KeygenNttButterflyPrograms.zero p1 0 v in1.low
      (fun i hi => zero_value m1 i hi) (by decide) ev)
  have in2 : FCtx "s" p1 p2 tw p0i m2 :=
    fctx_keep (frameM2 "s".toList (fresh_single "x".toList "s".toList (by decide)))
      (frameM2 "p".toList (fresh_single "x".toList "p".toList (by decide)))
      (frameM2 "p0i".toList (fresh_single "x".toList "p0i".toList (by decide))) arrM2 in1
  have dY' : U32Declared m2 "y" :=
    declared_keep (frameM2 "y".toList (fresh_single "x".toList "y".toList (by decide))) dY
  obtain ⟨m3,ha1,ht3⟩ := (KeygenNttForwardExec.seq_inv _ _ m2 out ht2).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨yw,ly,slotY,arrM3,heapM3,localsM3,frameM3⟩ := assign32_result
    (fun x => C99MemoryReference.Load32 m2.heap p2 x) m2 "y"
    (KeygenNttButterflyPrograms.read "r2") ⟨m3,.normal⟩ dY' ha1
    (fun v ev => load_at m2 "r2" KeygenNttButterflyPrograms.zero p2 0 v in2.high
      (fun i hi => zero_value m2 i hi) (by decide) ev)
  have in3 : FCtx "s" p1 p2 tw p0i m3 :=
    fctx_keep (frameM3 "s".toList (fresh_single "y".toList "s".toList (by decide)))
      (frameM3 "p".toList (fresh_single "y".toList "p".toList (by decide)))
      (frameM3 "p0i".toList (fresh_single "y".toList "p0i".toList (by decide))) arrM3 in2
  have slotXm3 : U32Slot m3 "x" xw :=
    u32_keep (frameM3 "x".toList (fresh_single "y".toList "x".toList (by decide))) slotX
  obtain ⟨m4,hm,ht4⟩ := (KeygenNttForwardExec.seq_inv _ _ m3 out ht3).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨product,hmul,slotY4,arrM4,heapM4,localsM4,frameM4⟩ := assign32_result
    (fun x => BMul p0i yw tw x) m3 "y"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "y")
      (KeygenNttButterflyPrograms.scalar "s")) ⟨m4,.normal⟩
    (⟨some (Value.uint32 yw),slotY⟩ : U32Declared m3 "y") hm
    (fun v ev => mont_result m3 "y" "s" yw tw p0i v slotY in3.twSlot in3.prime in3.inverse ev)
  have in4 : FCtx "s" p1 p2 tw p0i m4 :=
    fctx_keep (frameM4 "s".toList (fresh_single "y".toList "s".toList (by decide)))
      (frameM4 "p".toList (fresh_single "y".toList "p".toList (by decide)))
      (frameM4 "p0i".toList (fresh_single "y".toList "p0i".toList (by decide))) arrM4 in3
  have slotXm4 : U32Slot m4 "x" xw :=
    u32_keep (frameM4 "x".toList (fresh_single "y".toList "x".toList (by decide))) slotXm3
  obtain ⟨m5,hs1,ht5⟩ := (KeygenNttForwardExec.seq_inv _ _ m4 out ht4).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_store32 _ _ _ _ _ hr))
  obtain ⟨h1,low,hlow,stLow,flowS1,heapS1,localsS1,arrS1⟩ := store_result
    (fun x => BAdd xw product x) m4 "r1" KeygenNttButterflyPrograms.zero
    (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "x")
      (KeygenNttButterflyPrograms.scalar "y")) p1 ⟨m5,.normal⟩
    (fun q hp => pointer_at m4 "r1" KeygenNttButterflyPrograms.zero p1 q 0 in4.low
      (fun i hi => zero_value m4 i hi) (by decide) hp)
    (fun v ev => add_result m4 "x" "y" xw product v slotXm4 slotY4 in4.prime ev) hs1
  have in5 : FCtx "s" p1 p2 tw p0i m5 :=
    fctx_keep (congrFun localsS1 "s".toList) (congrFun localsS1 "p".toList)
      (congrFun localsS1 "p0i".toList) arrS1 in4
  have slotXm5 : U32Slot m5 "x" xw := u32_keep (congrFun localsS1 "x".toList) slotXm4
  have slotYm5 : U32Slot m5 "y" product := u32_keep (congrFun localsS1 "y".toList) slotY4
  obtain ⟨m6,hs2,ht6⟩ := (KeygenNttForwardExec.seq_inv _ _ m5 out ht5).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_store32 _ _ _ _ _ hr))
  obtain ⟨h2,high,hhigh,stHigh,flowS2,heapS2,localsS2,arrS2⟩ := store_result
    (fun x => BSub xw product x) m5 "r2" KeygenNttButterflyPrograms.zero
    (KeygenNttButterflyPrograms.sub (KeygenNttButterflyPrograms.scalar "x")
      (KeygenNttButterflyPrograms.scalar "y")) p2 ⟨m6,.normal⟩
    (fun q hp => pointer_at m5 "r2" KeygenNttButterflyPrograms.zero p2 q 0 in5.high
      (fun i hi => zero_value m5 i hi) (by decide) hp)
    (fun v ev => sub_result m5 "x" "y" xw product v slotXm5 slotYm5 in5.prime ev) hs2
  rw [C99ModularReference.skip_result m6 out ht6]
  refine ⟨xw,yw,low,high,h1,h2,⟨product,hmul,hlow,hhigh⟩,?_,?_,?_,?_,rfl,?_⟩
  · rw [heapD] at lx
    exact lx
  · rw [heapM2,heapD] at ly
    exact ly
  · rw [heapM4,heapM3,heapM2,heapD] at stLow
    exact stLow
  · rw [heapS1] at stHigh
    exact stHigh
  · exact heapS2


/- Triple butterfly body: the chain walk yields TripleCalls, with the
   gm[r] input word and the three r1-relative loads/stores at the pinned
   stride positions. -/
theorem triple_chain (before : State) (out : Result) (p1 gmP : ArrayPointer) (σ ρ : Nat)
    (w p0i : BitVec 32) (hσ : σ<2^64) (fit : 2*σ<2^64) (hρ : ρ<2^64)
    (inputs : TCtx p1 gmP σ ρ w p0i before)
    (source : Exec KeygenNttButterflyPrograms.tripleBody before out) :
    ∃ x a b c out0 out1 out2 h1 h2 h3,
      ∃ _calls : KeygenNttButterflyAlgebra.TripleCalls a b c x w p0i out0 out1 out2,
      C99MemoryReference.Load32 before.heap {gmP with index := gmP.index+ρ} x ∧
      C99MemoryReference.Load32 before.heap p1 a ∧
      C99MemoryReference.Load32 before.heap {p1 with index := p1.index+σ} b ∧
      C99MemoryReference.Load32 before.heap {p1 with index := p1.index+2*σ} c ∧
      C99MemoryReference.Store32 before.heap p1 out0 h1 ∧
      C99MemoryReference.Store32 h1 {p1 with index := p1.index+σ} out1 h2 ∧
      C99MemoryReference.Store32 h2 {p1 with index := p1.index+2*σ} out2 h3 ∧
      out.flow=.normal ∧ out.state.heap=h3 := by
  obtain ⟨s1,h1a,ht1⟩ := (KeygenNttForwardExec.seq_inv _ _ before out source).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_base _ _ _ hr))
  obtain ⟨f1,a1x,h1g,l1,fr1⟩ := declaration_result .u32
    (["fA","fB","fC","fB0","fB1","fB2","fC0","fC1","fC2"].map String.toList)
    before ⟨s1,.normal⟩ h1a
  have ctx1 : TCtx p1 gmP σ ρ w p0i s1 :=
    tctx_keep (by rw [l1]; rfl) (by rw [l1]; rfl) (by rw [l1]; rfl) (by rw [l1]; rfl)
      (by rw [l1]; rfl) a1x inputs
  obtain ⟨s2,h2a,ht2⟩ := (KeygenNttForwardExec.seq_inv _ _ s1 out ht1).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_base _ _ _ hr))
  obtain ⟨f2,a2x,h2g,l2,fr2⟩ := declaration_result .u32 (["x","x2"].map String.toList)
    s1 ⟨s2,.normal⟩ h2a
  have ctx2 : TCtx p1 gmP σ ρ w p0i s2 :=
    tctx_keep (by rw [l2]; rfl) (by rw [l2]; rfl) (by rw [l2]; rfl) (by rw [l2]; rfl)
      (by rw [l2]; rfl) a2x ctx1
  have dX : U32Declared s2 "x" := ⟨none,by rw [l2,l1]; rfl⟩
  have dX2 : U32Declared s2 "x2" := ⟨none,by rw [l2,l1]; rfl⟩
  obtain ⟨s3,hx,ht3⟩ := (KeygenNttForwardExec.seq_inv _ _ s2 out ht2).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨xw,lx,slotX,a3x,h3g,l3,fr3⟩ := assign32_result
    (fun q => C99MemoryReference.Load32 before.heap {gmP with index := gmP.index+ρ} q) s2 "x"
    (KeygenNttButterflyPrograms.read "gm" (.var "r".toList)) ⟨s3,.normal⟩ dX hx
    (fun v ev => by
      obtain ⟨q,hv,hl⟩ := load_at s2 "gm" (.var "r".toList) gmP ρ v ctx2.gm
        (fun i hi => var_value s2 "r" ρ i ctx2.rv hi) hρ ev
      rw [h2g,h1g] at hl
      exact ⟨q,hv,hl⟩)
  have ctx3 : TCtx p1 gmP σ ρ w p0i s3 :=
    tctx_keep (fr3 "w".toList (fresh_single "x".toList "w".toList (by decide)))
      (fr3 "p".toList (fresh_single "x".toList "p".toList (by decide)))
      (fr3 "p0i".toList (fresh_single "x".toList "p0i".toList (by decide)))
      (fr3 "stride".toList (fresh_single "x".toList "stride".toList (by decide)))
      (fr3 "r".toList (fresh_single "x".toList "r".toList (by decide))) a3x ctx2
  obtain ⟨s4,hx2,ht4⟩ := (KeygenNttForwardExec.seq_inv _ _ s3 out ht3).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨x2w,hmulXX,slotX2,a4x,h4g,l4,fr4⟩ := assign32_result
    (fun q => BMul p0i xw xw q) s3 "x2"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "x")
      (KeygenNttButterflyPrograms.scalar "x")) ⟨s4,.normal⟩
    (⟨none,by rw [l3,l2,l1]; rfl⟩ : U32Declared s3 "x2") hx2
    (fun v ev => mont_result s3 "x" "x" xw xw p0i v slotX slotX ctx3.prime ctx3.inverse ev)
  have ctx4 : TCtx p1 gmP σ ρ w p0i s4 :=
    tctx_keep (fr4 "w".toList (fresh_single "x2".toList "w".toList (by decide)))
      (fr4 "p".toList (fresh_single "x2".toList "p".toList (by decide)))
      (fr4 "p0i".toList (fresh_single "x2".toList "p0i".toList (by decide)))
      (fr4 "stride".toList (fresh_single "x2".toList "stride".toList (by decide)))
      (fr4 "r".toList (fresh_single "x2".toList "r".toList (by decide))) a4x ctx3
  obtain ⟨s5,hfa,ht5⟩ := (KeygenNttForwardExec.seq_inv _ _ s4 out ht4).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨aw,la,slotA,a5x,h5g,l5,fr5⟩ := assign32_result
    (fun q => C99MemoryReference.Load32 before.heap p1 q) s4 "fA"
    (KeygenNttButterflyPrograms.read "r1") ⟨s5,.normal⟩
    (⟨none,by rw [l4,l3,l2,l1]; rfl⟩ : U32Declared s4 "fA") hfa
    (fun v ev => by
      obtain ⟨q,hv,hl⟩ := load_at s4 "r1" KeygenNttButterflyPrograms.zero p1 0 v ctx4.base
        (fun i hi => zero_value s4 i hi) (by decide) ev
      rw [h4g,h3g,h2g,h1g] at hl
      exact ⟨q,hv,hl⟩)
  have ctx5 : TCtx p1 gmP σ ρ w p0i s5 :=
    tctx_keep (fr5 "w".toList (fresh_single "fA".toList "w".toList (by decide)))
      (fr5 "p".toList (fresh_single "fA".toList "p".toList (by decide)))
      (fr5 "p0i".toList (fresh_single "fA".toList "p0i".toList (by decide)))
      (fr5 "stride".toList (fresh_single "fA".toList "stride".toList (by decide)))
      (fr5 "r".toList (fresh_single "fA".toList "r".toList (by decide))) a5x ctx4
  obtain ⟨s6,hfb,ht6⟩ := (KeygenNttForwardExec.seq_inv _ _ s5 out ht5).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨bw,lb,slotB,a6x,h6g,l6,fr6⟩ := assign32_result
    (fun q => C99MemoryReference.Load32 before.heap {p1 with index := p1.index+σ} q) s5 "fB"
    (KeygenNttButterflyPrograms.read "r1" KeygenNttButterflyPrograms.stride) ⟨s6,.normal⟩
    (⟨none,by rw [l5,l4,l3,l2,l1]; rfl⟩ : U32Declared s5 "fB") hfb
    (fun v ev => by
      obtain ⟨q,hv,hl⟩ := load_at s5 "r1" KeygenNttButterflyPrograms.stride p1 σ v ctx5.base
        (fun i hi => var_value s5 "stride" σ i ctx5.st hi) hσ ev
      rw [h5g,h4g,h3g,h2g,h1g] at hl
      exact ⟨q,hv,hl⟩)
  have ctx6 : TCtx p1 gmP σ ρ w p0i s6 :=
    tctx_keep (fr6 "w".toList (fresh_single "fB".toList "w".toList (by decide)))
      (fr6 "p".toList (fresh_single "fB".toList "p".toList (by decide)))
      (fr6 "p0i".toList (fresh_single "fB".toList "p0i".toList (by decide)))
      (fr6 "stride".toList (fresh_single "fB".toList "stride".toList (by decide)))
      (fr6 "r".toList (fresh_single "fB".toList "r".toList (by decide))) a6x ctx5
  obtain ⟨s7,hfc,ht7⟩ := (KeygenNttForwardExec.seq_inv _ _ s6 out ht6).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨cw,lc,slotC,a7x,h7g,l7,fr7⟩ := assign32_result
    (fun q => C99MemoryReference.Load32 before.heap {p1 with index := p1.index+2*σ} q) s6 "fC"
    (KeygenNttButterflyPrograms.read "r1" KeygenNttButterflyPrograms.twiceStride)
    ⟨s7,.normal⟩
    (⟨none,by rw [l6,l5,l4,l3,l2,l1]; rfl⟩ : U32Declared s6 "fC") hfc
    (fun v ev => by
      obtain ⟨q,hv,hl⟩ := load_at s6 "r1" KeygenNttButterflyPrograms.twiceStride p1 (2*σ) v
        ctx6.base (fun i hi => twice_value s6 σ i hσ ctx6.st hi) fit ev
      rw [h6g,h5g,h4g,h3g,h2g,h1g] at hl
      exact ⟨q,hv,hl⟩)
  have ctx7 : TCtx p1 gmP σ ρ w p0i s7 :=
    tctx_keep (fr7 "w".toList (fresh_single "fC".toList "w".toList (by decide)))
      (fr7 "p".toList (fresh_single "fC".toList "p".toList (by decide)))
      (fr7 "p0i".toList (fresh_single "fC".toList "p0i".toList (by decide)))
      (fr7 "stride".toList (fresh_single "fC".toList "stride".toList (by decide)))
      (fr7 "r".toList (fresh_single "fC".toList "r".toList (by decide))) a7x ctx6
  have slotXm7 : U32Slot s7 "x" xw :=
    u32_keep (by rw [l7,l6,l5,l4]; simp [C99ScalarReference.set]) slotX
  have slotX2m7 : U32Slot s7 "x2" x2w :=
    u32_keep (by rw [l7,l6,l5,l4]; simp [C99ScalarReference.set]) slotX2
  obtain ⟨s8,hb0,ht8⟩ := (KeygenNttForwardExec.seq_inv _ _ s7 out ht7).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨b0w,hmulB0,slotB0,a8x,h8g,l8,fr8⟩ := assign32_result
    (fun q => BMul p0i bw xw q) s7 "fB0"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "fB")
      (KeygenNttButterflyPrograms.scalar "x")) ⟨s8,.normal⟩
    (⟨none,by rw [l7,l6,l5,l4,l3,l2,l1]; rfl⟩ : U32Declared s7 "fB0") hb0
    (fun v ev => mont_result s7 "fB" "x" bw xw p0i v
      (u32_keep (by rw [l7]; simp [C99ScalarReference.set]) slotB) slotXm7
      ctx7.prime ctx7.inverse ev)
  have ctx8 : TCtx p1 gmP σ ρ w p0i s8 :=
    tctx_keep (fr8 "w".toList (fresh_single "fB0".toList "w".toList (by decide)))
      (fr8 "p".toList (fresh_single "fB0".toList "p".toList (by decide)))
      (fr8 "p0i".toList (fresh_single "fB0".toList "p0i".toList (by decide)))
      (fr8 "stride".toList (fresh_single "fB0".toList "stride".toList (by decide)))
      (fr8 "r".toList (fresh_single "fB0".toList "r".toList (by decide))) a8x ctx7
  obtain ⟨s9,hb1,ht9⟩ := (KeygenNttForwardExec.seq_inv _ _ s8 out ht8).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨b1w,hmulB1,slotB1,a9x,h9g,l9,fr9⟩ := assign32_result
    (fun q => BMul p0i b0w w q) s8 "fB1"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "fB0")
      (KeygenNttButterflyPrograms.scalar "w")) ⟨s9,.normal⟩
    (⟨none,by rw [l8,l7,l6,l5,l4,l3,l2,l1]; rfl⟩ : U32Declared s8 "fB1") hb1
    (fun v ev => mont_result s8 "fB0" "w" b0w w p0i v slotB0 ctx8.wSlot ctx8.prime
      ctx8.inverse ev)
  have ctx9 : TCtx p1 gmP σ ρ w p0i s9 :=
    tctx_keep (fr9 "w".toList (fresh_single "fB1".toList "w".toList (by decide)))
      (fr9 "p".toList (fresh_single "fB1".toList "p".toList (by decide)))
      (fr9 "p0i".toList (fresh_single "fB1".toList "p0i".toList (by decide)))
      (fr9 "stride".toList (fresh_single "fB1".toList "stride".toList (by decide)))
      (fr9 "r".toList (fresh_single "fB1".toList "r".toList (by decide))) a9x ctx8
  obtain ⟨s10,hb2,ht10⟩ := (KeygenNttForwardExec.seq_inv _ _ s9 out ht9).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨b2w,hmulB2,slotB2,a10x,h10g,l10,fr10⟩ := assign32_result
    (fun q => BMul p0i b1w w q) s9 "fB2"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "fB1")
      (KeygenNttButterflyPrograms.scalar "w")) ⟨s10,.normal⟩
    (⟨none,by rw [l9,l8,l7,l6,l5,l4,l3,l2,l1]; rfl⟩ : U32Declared s9 "fB2") hb2
    (fun v ev => mont_result s9 "fB1" "w" b1w w p0i v slotB1 ctx9.wSlot ctx9.prime
      ctx9.inverse ev)
  have ctx10 : TCtx p1 gmP σ ρ w p0i s10 :=
    tctx_keep (fr10 "w".toList (fresh_single "fB2".toList "w".toList (by decide)))
      (fr10 "p".toList (fresh_single "fB2".toList "p".toList (by decide)))
      (fr10 "p0i".toList (fresh_single "fB2".toList "p0i".toList (by decide)))
      (fr10 "stride".toList (fresh_single "fB2".toList "stride".toList (by decide)))
      (fr10 "r".toList (fresh_single "fB2".toList "r".toList (by decide))) a10x ctx9
  have slotCm10 : U32Slot s10 "fC" cw :=
    u32_keep (by rw [l10,l9,l8,l7]; simp [C99ScalarReference.set]) slotC
  have slotX2m10 : U32Slot s10 "x2" x2w :=
    u32_keep (by rw [l10,l9,l8,l7,l6,l5,l4]; simp [C99ScalarReference.set]) slotX2
  obtain ⟨s11,hc0,ht11⟩ := (KeygenNttForwardExec.seq_inv _ _ s10 out ht10).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨c0w,hmulC0,slotC0,a11x,h11g,l11,fr11⟩ := assign32_result
    (fun q => BMul p0i cw x2w q) s10 "fC0"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "fC")
      (KeygenNttButterflyPrograms.scalar "x2")) ⟨s11,.normal⟩
    (⟨none,by rw [l10,l9,l8,l7,l6,l5,l4,l3,l2,l1]; rfl⟩ : U32Declared s10 "fC0") hc0
    (fun v ev => mont_result s10 "fC" "x2" cw x2w p0i v slotCm10 slotX2m10 ctx10.prime
      ctx10.inverse ev)
  have ctx11 : TCtx p1 gmP σ ρ w p0i s11 :=
    tctx_keep (fr11 "w".toList (fresh_single "fC0".toList "w".toList (by decide)))
      (fr11 "p".toList (fresh_single "fC0".toList "p".toList (by decide)))
      (fr11 "p0i".toList (fresh_single "fC0".toList "p0i".toList (by decide)))
      (fr11 "stride".toList (fresh_single "fC0".toList "stride".toList (by decide)))
      (fr11 "r".toList (fresh_single "fC0".toList "r".toList (by decide))) a11x ctx10
  obtain ⟨s12,hc1,ht12⟩ := (KeygenNttForwardExec.seq_inv _ _ s11 out ht11).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨c1w,hmulC1,slotC1,a12x,h12g,l12,fr12⟩ := assign32_result
    (fun q => BMul p0i c0w w q) s11 "fC1"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "fC0")
      (KeygenNttButterflyPrograms.scalar "w")) ⟨s12,.normal⟩
    (⟨none,by rw [l11,l10,l9,l8,l7,l6,l5,l4,l3,l2,l1]; rfl⟩ : U32Declared s11 "fC1") hc1
    (fun v ev => mont_result s11 "fC0" "w" c0w w p0i v slotC0 ctx11.wSlot ctx11.prime
      ctx11.inverse ev)
  have ctx12 : TCtx p1 gmP σ ρ w p0i s12 :=
    tctx_keep (fr12 "w".toList (fresh_single "fC1".toList "w".toList (by decide)))
      (fr12 "p".toList (fresh_single "fC1".toList "p".toList (by decide)))
      (fr12 "p0i".toList (fresh_single "fC1".toList "p0i".toList (by decide)))
      (fr12 "stride".toList (fresh_single "fC1".toList "stride".toList (by decide)))
      (fr12 "r".toList (fresh_single "fC1".toList "r".toList (by decide))) a12x ctx11
  obtain ⟨s13,hc2,ht13⟩ := (KeygenNttForwardExec.seq_inv _ _ s12 out ht12).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_assign _ _ _ _ hr))
  obtain ⟨c2w,hmulC2,slotC2,a13x,h13g,l13,fr13⟩ := assign32_result
    (fun q => BMul p0i c1w w q) s12 "fC2"
    (KeygenNttButterflyPrograms.mont (KeygenNttButterflyPrograms.scalar "fC1")
      (KeygenNttButterflyPrograms.scalar "w")) ⟨s13,.normal⟩
    (⟨none,by rw [l12,l11,l10,l9,l8,l7,l6,l5,l4,l3,l2,l1]; rfl⟩ : U32Declared s12 "fC2") hc2
    (fun v ev => mont_result s12 "fC1" "w" c1w w p0i v slotC1 ctx12.wSlot ctx12.prime
      ctx12.inverse ev)
  have ctx13 : TCtx p1 gmP σ ρ w p0i s13 :=
    tctx_keep (fr13 "w".toList (fresh_single "fC2".toList "w".toList (by decide)))
      (fr13 "p".toList (fresh_single "fC2".toList "p".toList (by decide)))
      (fr13 "p0i".toList (fresh_single "fC2".toList "p0i".toList (by decide)))
      (fr13 "stride".toList (fresh_single "fC2".toList "stride".toList (by decide)))
      (fr13 "r".toList (fresh_single "fC2".toList "r".toList (by decide))) a13x ctx12
  have slotAm13 : U32Slot s13 "fA" aw :=
    u32_keep (by rw [l13,l12,l11,l10,l9,l8,l7,l6]; simp [C99ScalarReference.set]) slotA
  have slotB0m13 : U32Slot s13 "fB0" b0w :=
    u32_keep (by rw [l13,l12,l11,l10,l9,l8]; simp [C99ScalarReference.set]) slotB0
  have slotC0m13 : U32Slot s13 "fC0" c0w :=
    u32_keep (by rw [l13,l12,l11]; simp [C99ScalarReference.set]) slotC0
  obtain ⟨s14,ho0,ht14⟩ := (KeygenNttForwardExec.seq_inv _ _ s13 out ht13).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_store32 _ _ _ _ _ hr))
  obtain ⟨hh1,out0w,hres0,st0,fl0,hs0,lo0,ar0⟩ := store_result
    (fun d => ∃ sum, BAdd b0w c0w sum ∧ BAdd aw sum d) s13 "r1"
    KeygenNttButterflyPrograms.zero
    (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "fA")
      (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "fB0")
        (KeygenNttButterflyPrograms.scalar "fC0"))) p1 ⟨s14,.normal⟩
    (fun q hp => pointer_at s13 "r1" KeygenNttButterflyPrograms.zero p1 q 0 ctx13.base
      (fun i hi => zero_value s13 i hi) (by decide) hp)
    (fun v ev => by
      obtain ⟨sum,d,hv,ha,ho⟩ := add_add_right_result s13 "fA" "fB0" "fC0" aw b0w c0w v
        slotAm13 slotB0m13 slotC0m13 ctx13.prime ev
      exact ⟨d,hv,sum,ha,ho⟩) ho0
  obtain ⟨s0sum,hs0sum,ho0call⟩ := hres0
  have ctx14 : TCtx p1 gmP σ ρ w p0i s14 :=
    tctx_keep (congrFun lo0 "w".toList) (congrFun lo0 "p".toList) (congrFun lo0 "p0i".toList)
      (congrFun lo0 "stride".toList) (congrFun lo0 "r".toList) ar0 ctx13
  have slotAm14 : U32Slot s14 "fA" aw := u32_keep (congrFun lo0 "fA".toList) slotAm13
  have slotB1m14 : U32Slot s14 "fB1" b1w :=
    u32_keep (by rw [lo0,l13,l12,l11,l10,l9]; simp [C99ScalarReference.set]) slotB1
  have slotC2m14 : U32Slot s14 "fC2" c2w := u32_keep (congrFun lo0 "fC2".toList) slotC2
  obtain ⟨s15,ho1,ht15⟩ := (KeygenNttForwardExec.seq_inv _ _ s14 out ht14).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_store32 _ _ _ _ _ hr))
  obtain ⟨hh2,out1w,hres1,st1o,fl1,hs1o,lo1,ar1⟩ := store_result
    (fun d => ∃ sum, BAdd b1w c2w sum ∧ BAdd aw sum d) s14 "r1"
    KeygenNttButterflyPrograms.stride
    (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "fA")
      (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "fB1")
        (KeygenNttButterflyPrograms.scalar "fC2")))
    {p1 with index := p1.index+σ} ⟨s15,.normal⟩
    (fun q hp => pointer_at s14 "r1" KeygenNttButterflyPrograms.stride p1 q σ ctx14.base
      (fun i hi => var_value s14 "stride" σ i ctx14.st hi) hσ hp)
    (fun v ev => by
      obtain ⟨sum,d,hv,ha,ho⟩ := add_add_right_result s14 "fA" "fB1" "fC2" aw b1w c2w v
        slotAm14 slotB1m14 slotC2m14 ctx14.prime ev
      exact ⟨d,hv,sum,ha,ho⟩) ho1
  obtain ⟨s1sum,hs1sum,ho1call⟩ := hres1
  have ctx15 : TCtx p1 gmP σ ρ w p0i s15 :=
    tctx_keep (congrFun lo1 "w".toList) (congrFun lo1 "p".toList) (congrFun lo1 "p0i".toList)
      (congrFun lo1 "stride".toList) (congrFun lo1 "r".toList) ar1 ctx14
  have slotAm15 : U32Slot s15 "fA" aw := u32_keep (congrFun lo1 "fA".toList) slotAm14
  have slotB2m15 : U32Slot s15 "fB2" b2w :=
    u32_keep (by rw [lo1,lo0,l13,l12,l11,l10]; simp [C99ScalarReference.set]) slotB2
  have slotC1m15 : U32Slot s15 "fC1" c1w :=
    u32_keep (by rw [lo1,lo0,l13,l12]; simp [C99ScalarReference.set]) slotC1
  rw [hs0] at st1o
  obtain ⟨s16,ho2,ht16⟩ := (KeygenNttForwardExec.seq_inv _ _ s15 out ht15).resolve_right
    (by rintro ⟨r,hr,hexit,heq⟩; subst r; exact hexit (normal_store32 _ _ _ _ _ hr))
  obtain ⟨hh3,out2w,hres2,st2o,fl2,hs2o,lo2,ar2⟩ := store_result
    (fun d => ∃ sum, BAdd b2w c1w sum ∧ BAdd aw sum d) s15 "r1"
    KeygenNttButterflyPrograms.twiceStride
    (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "fA")
      (KeygenNttButterflyPrograms.add (KeygenNttButterflyPrograms.scalar "fB2")
        (KeygenNttButterflyPrograms.scalar "fC1")))
    {p1 with index := p1.index+2*σ} ⟨s16,.normal⟩
    (fun q hp => pointer_at s15 "r1" KeygenNttButterflyPrograms.twiceStride p1 q (2*σ)
      ctx15.base (fun i hi => twice_value s15 σ i hσ ctx15.st hi) fit hp)
    (fun v ev => by
      obtain ⟨sum,d,hv,ha,ho⟩ := add_add_right_result s15 "fA" "fB2" "fC1" aw b2w c1w v
        slotAm15 slotB2m15 slotC1m15 ctx15.prime ev
      exact ⟨d,hv,sum,ha,ho⟩) ho2
  obtain ⟨s2sum,hs2sum,ho2call⟩ := hres2
  rw [hs1o] at st2o
  rw [C99ModularReference.skip_result s16 out ht16]
  refine ⟨xw,aw,bw,cw,out0w,out1w,out2w,hh1,hh2,hh3,
    ⟨x2w,b0w,b1w,b2w,c0w,c1w,c2w,s0sum,s1sum,s2sum,hmulXX,hmulB0,hmulB1,hmulB2,hmulC0,
      hmulC1,hmulC2,hs0sum,hs1sum,hs2sum,ho0call,ho1call,ho2call⟩,?_,?_,?_,?_,?_,?_,?_,rfl,?_⟩
  · exact lx
  · exact la
  · exact lb
  · exact lc
  · rw [h13g,h12g,h11g,h10g,h9g,h8g,h7g,h6g,h5g,h4g,h3g,h2g,h1g] at st0
    exact st0
  · exact st1o
  · exact st2o
  · exact hs2o

theorem triple_calls (before : State) (result : Result) (p1 gmP : ArrayPointer) (σ ρ : Nat)
    (w p0i : BitVec 32) (hσ : σ<2^64) (fit : 2*σ<2^64) (hρ : ρ<2^64)
    (inputs : TCtx p1 gmP σ ρ w p0i before)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.tripleBody)
      before result) :
    ∃ x a b c out0 out1 out2 h1 h2 h3,
      ∃ _calls : KeygenNttButterflyAlgebra.TripleCalls a b c x w p0i out0 out1 out2,
      C99MemoryReference.Load32 before.heap {gmP with index := gmP.index+ρ} x ∧
      C99MemoryReference.Load32 before.heap p1 a ∧
      C99MemoryReference.Load32 before.heap {p1 with index := p1.index+σ} b ∧
      C99MemoryReference.Load32 before.heap {p1 with index := p1.index+2*σ} c ∧
      C99MemoryReference.Store32 before.heap p1 out0 h1 ∧
      C99MemoryReference.Store32 h1 {p1 with index := p1.index+σ} out1 h2 ∧
      C99MemoryReference.Store32 h2 {p1 with index := p1.index+2*σ} out2 h3 ∧
      result.flow=.normal ∧ result.state.heap=h3 := by
  obtain ⟨inner,innerExec,hout⟩ := KeygenNttLoopSupport.scope_result
    (C99ModularParser.declarations KeygenNttButterflyPrograms.tripleBody)
    KeygenNttButterflyPrograms.tripleBody before result source
  obtain ⟨x,a,b,c,out0,out1,out2,h1,h2,h3,calls,lx,la,lb,lc,st0,st1o,st2o,fflow,fheap⟩ :=
    triple_chain before inner p1 gmP σ ρ w p0i hσ fit hρ inputs innerExec
  subst result
  refine ⟨x,a,b,c,out0,out1,out2,h1,h2,h3,calls,lx,la,lb,lc,st0,st1o,st2o,fflow,?_⟩
  show inner.state.heap=h3
  exact fheap

theorem binary_calls (before : State) (result : Result) (p1 p2 : ArrayPointer) (tw p0i : BitVec 32)
    (inputs : FCtx "s" p1 p2 tw p0i before)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody)
      before result) :
    ∃ x y low high h1 h2,
      ∃ _calls : KeygenNttButterflyAlgebra.BinaryCalls x y tw p0i low high,
      C99MemoryReference.Load32 before.heap p1 x ∧
      C99MemoryReference.Load32 before.heap p2 y ∧
      C99MemoryReference.Store32 before.heap p1 low h1 ∧
      C99MemoryReference.Store32 h1 p2 high h2 ∧
      result.flow=.normal ∧ result.state.heap=h2 := by
  obtain ⟨inner,innerExec,hout⟩ := KeygenNttLoopSupport.scope_result
    (C99ModularParser.declarations KeygenNttButterflyPrograms.binaryBody)
    KeygenNttButterflyPrograms.binaryBody before result source
  obtain ⟨x,y,low,high,h1,h2,calls,la,lb,st1,st2,fflow,fheap⟩ :=
    binary_chain before inner p1 p2 tw p0i inputs innerExec
  subst result
  refine ⟨x,y,low,high,h1,h2,calls,la,lb,st1,st2,fflow,?_⟩
  show inner.state.heap=h2
  exact fheap

/- The binary butterfly body writes only its block locals and the heap. -/
def binaryDecls : List B20.C.Name := ["x","y"].map String.toList
theorem binary_decls : C99ModularParser.declarations
    KeygenNttButterflyPrograms.binaryBody=binaryDecls := by decide

theorem binary_each : ∀ a ∈ KeygenNttButterflyPrograms.binaryAtoms, ∀ s out,
    Exec a s out → ∃ ws : List B20.C.Name,
      KeygenNttLoopSupport.localOnly a=some ws ∧ KeygenNttLoopSupport.FrameOk ws s out ∧
        ∀ n, ws.contains n → binaryDecls.contains n := by
  intro a hin s out source
  simp [KeygenNttButterflyPrograms.binaryAtoms,List.mem_cons] at hin
  rcases hin with rfl|rfl|rfl|rfl|rfl|rfl
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact hn
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="x".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="y".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    have h : n="y".toList := by simpa [contains_iff] using hn
    subst n
    decide
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (contains_iff.mp hn)).elim
  · refine ⟨_,rfl,KeygenNttLoopSupport.atom_frame _ _ _ _ source rfl,?_⟩
    intro n hn
    exact (List.not_mem_nil (contains_iff.mp hn)).elim

theorem binary_body_result (before : State) (result : Result)
    (source : Exec (KeygenNttForwardPrograms.block KeygenNttButterflyPrograms.binaryBody)
      before result) :
    result.flow=.normal ∧ result.state.arrays=before.arrays ∧ result.state.locals=before.locals :=
  KeygenNttLoopSupport.block_frame
    (C99ModularParser.declarations KeygenNttButterflyPrograms.binaryBody)
    KeygenNttButterflyPrograms.binaryAtoms before result source
    (by
      intro a hin s out hs
      obtain ⟨ws,hl,hf,hc⟩ := binary_each a hin s out hs
      refine ⟨ws,hl,hf,?_⟩
      intro n hn
      rw [binary_decls]
      exact hc n hn)

end FT1536.Source3.KeygenNttButterflyCalls
