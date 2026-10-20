import Source3.KeygenMkgm3Prelude

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMkgm3RowInit
open C99ModularReference (Stmt Exec Eval chainOf)
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99IntegerReference (Value Ty)
open C99MemoryReference (ArrayPointer)
open KeygenMkgm3Program
open KeygenMkgm3Atoms
open KeygenMkgm3Prelude
open KeygenMkgm3Control (frame chain_inv)
open KeygenMkgm3Counters (single_value advanced advanced_counter)
open KeygenMkgm3LastRow (Context)
open KeygenMkgm3Loops (Filled)
open KeygenNttLoopSupport (USlot u64)
open KeygenNttButterflyCalls (U32Slot U32Declared)

def set64 (s : State) (name : String) (i : Nat) : State :=
  C99ArrayReference.bindValue s name.toList .uint64 (u64 i)

theorem assign64 (s : State) (out : Result) (name : String) (e : C99ModularReference.Expr) (i : Nat)
    (declared : Declared s name .uint64)
    (rhs : ∀ v, Eval s e v → v.integer=(i : Int))
    (source : Exec (.assign name.toList e) s out) : out=⟨set64 s name i,.normal⟩ := by
  obtain ⟨old,hd⟩ := declared
  obtain ⟨ty,previous,v,has,ev,he⟩ := KeygenNttForwardExec.assign_inv s _ _ out source
  have ht := congrArg Prod.fst (Option.some.inj (has.symm.trans hd))
  change ty=Ty.uint64 at ht
  subst ty
  rw [he]
  simp only [set64,C99ArrayReference.bindValue,rhs v ev,KeygenNttLoopSupport.convert_u64_nat,
    show C99IntegerReference.convert .uint64 (u64 i).integer=u64 i from C99CountedWords.convert_self (u64 i)]

theorem set64_slot (s : State) (name : String) (i : Nat) (hi : i<2^64) : USlot (set64 s name i) name i := by
  simp [USlot,set64,C99ArrayReference.bindValue,C99ScalarReference.set,KeygenNttLoopSupport.convert_u64_self i hi]

def rowWords : List String := ["x","ix","g2","g4","ig2","ig4"]
def rowPrelude : List Stmt := [wordDecl rowWords,indexDecl ["b"],
  .assign "x".toList (cell "g"),.assign "ix".toList (cell "ig"),
  .assign "g2".toList montGG,.assign "g4".toList (mont (cell "g2") (cell "g2")),
  .assign "ig2".toList (mont (cell "ig") (cell "ig")),
  .assign "ig4".toList (mont (cell "ig2") (cell "ig2")),
  .assign "k".toList (.scalar (.bin .sub (num 11) (var "logn"))),
  .assign "b".toList (.scalar (.bin .shl (.cast .u64 (num 1)) (.bin .sub (var "logn") (num 1))))]

theorem declaration_word (s : State) (out : Result) (name : String) (member : name∈rowWords)
    (source : Exec (wordDecl rowWords) s out) : U32Declared out.state name := by
  rw [declare_result s out .u32 rowWords source]
  simp only [rowWords,List.mem_cons,List.not_mem_nil,or_false] at member
  rcases member with rfl | rfl | rfl | rfl | rfl | rfl <;>
    exact ⟨none,by simp [rowWords,C99ScalarReference.set,C99ValueBridge.type]⟩

theorem row_prelude (s : State) (out : Result) (p0i : BitVec 32) (gm igm rev : ArrayPointer)
    (ready : Ready p0i s) (pointers : KeygenMkgm3Upward.Pointers s gm igm)
    (table : KeygenMkgm3RevMemory.Rev s rev)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec (chainOf rowPrelude) s out) :
    Context p0i gm igm rev out.state ∧ Word out.state "x" 1 ∧ Declared out.state "u" .uint64 := by
  obtain ⟨s1,dw,tail1⟩ := chain_inv _ _ s out (by decide) source
  obtain ⟨s2,db,tail2⟩ := chain_inv _ _ s1 out (by decide) tail1
  obtain ⟨s3,xcopy,tail3⟩ := chain_inv _ _ s2 out (by decide) tail2
  obtain ⟨s4,ixcopy,tail4⟩ := chain_inv _ _ s3 out (by decide) tail3
  obtain ⟨s5,g2set,tail5⟩ := chain_inv _ _ s4 out (by decide) tail4
  obtain ⟨s6,g4set,tail6⟩ := chain_inv _ _ s5 out (by decide) tail5
  obtain ⟨s7,ig2set,tail7⟩ := chain_inv _ _ s6 out (by decide) tail6
  obtain ⟨s8,ig4set,tail8⟩ := chain_inv _ _ s7 out (by decide) tail7
  obtain ⟨s9,kset,tail9⟩ := chain_inv _ _ s8 out (by decide) tail8
  obtain ⟨s10,bset,last⟩ := chain_inv _ _ s9 out (by decide) tail9
  have hend := C99ModularReference.skip_result s10 out last
  have g1 := word_transport _ s ⟨s1,.normal⟩ "g" 1 (by decide) (by decide) ready.g dw
  have g2 := word_transport _ s1 ⟨s2,.normal⟩ "g" 1 (by decide) (by decide) g1 db
  have g3 := word_transport _ s2 ⟨s3,.normal⟩ "g" 1 (by decide) (by decide) g2 xcopy
  have g4 := word_transport _ s3 ⟨s4,.normal⟩ "g" 1 (by decide) (by decide) g3 ixcopy
  have xd1 := declaration_word s ⟨s1,.normal⟩ "x" (by decide) dw
  have xd2 := declared_transport _ s1 ⟨s2,.normal⟩ "x" .uint32 (by decide) (by decide) xd1 db
  have x3 := (assign_word s2 ⟨s3,.normal⟩ "x" _ 1 xd2 (cell_word s2 "g" 1 g2) xcopy).1
  have xout := word_transport _ s3 out "x" 1 (by decide) (by decide) x3 tail3
  have d2 := declaration_word s ⟨s1,.normal⟩ "g2" (by decide) dw
  have d2b := declared_transport _ s1 ⟨s2,.normal⟩ "g2" .uint32 (by decide) (by decide) d2 db
  have d2c := declared_transport _ s2 ⟨s3,.normal⟩ "g2" .uint32 (by decide) (by decide) d2b xcopy
  have d2d := declared_transport _ s3 ⟨s4,.normal⟩ "g2" .uint32 (by decide) (by decide) d2c ixcopy
  have head4 : Exec (chainOf [wordDecl rowWords,indexDecl ["b"],.assign "x".toList (cell "g"),
      .assign "ix".toList (cell "ig")]) s ⟨s4,.normal⟩ :=
    .seqNormal _ _ _ _ _ dw (.seqNormal _ _ _ _ _ db (.seqNormal _ _ _ _ _ xcopy
      (.seqNormal _ _ _ _ _ ixcopy (.base .skip s4 s4 (.skip s4)))))
  have p4 := params_transport _ s ⟨s4,.normal⟩ p0i (by decide) (by decide) (by decide) ready.params head4
  have g2w5 := (assign_word s4 ⟨s5,.normal⟩ "g2" _ 2 d2d
    (mont_word s4 p0i _ _ 1 1 p4 initialization (cell_word s4 "g" 1 g4) (cell_word s4 "g" 1 g4)) g2set).1
  have g2out := word_transport _ s5 out "g2" 2 (by decide) (by decide) g2w5 tail5
  have d4 := declaration_word s ⟨s1,.normal⟩ "g4" (by decide) dw
  have d4b := declared_transport _ s1 ⟨s2,.normal⟩ "g4" .uint32 (by decide) (by decide) d4 db
  have d4c := declared_transport _ s2 ⟨s3,.normal⟩ "g4" .uint32 (by decide) (by decide) d4b xcopy
  have d4d := declared_transport _ s3 ⟨s4,.normal⟩ "g4" .uint32 (by decide) (by decide) d4c ixcopy
  have d4e := declared_transport _ s4 ⟨s5,.normal⟩ "g4" .uint32 (by decide) (by decide) d4d g2set
  have p5 := params_transport _ s4 ⟨s5,.normal⟩ p0i (by decide) (by decide) (by decide) p4 g2set
  have g4w6 := (assign_word s5 ⟨s6,.normal⟩ "g4" _ 4 d4e
    (mont_word s5 p0i _ _ 2 2 p5 initialization (cell_word s5 "g2" 2 g2w5) (cell_word s5 "g2" 2 g2w5)) g4set).1
  have g4out := word_transport _ s6 out "g4" 4 (by decide) (by decide) g4w6 tail6
  have head8 : Exec (chainOf (rowPrelude.take 8)) s ⟨s8,.normal⟩ :=
    .seqNormal _ _ _ _ _ dw (.seqNormal _ _ _ _ _ db (.seqNormal _ _ _ _ _ xcopy
      (.seqNormal _ _ _ _ _ ixcopy (.seqNormal _ _ _ _ _ g2set (.seqNormal _ _ _ _ _ g4set
        (.seqNormal _ _ _ _ _ ig2set (.seqNormal _ _ _ _ _ ig4set (.base .skip s8 s8 (.skip s8)))))))))
  have logn8 := slot_transport _ s ⟨s8,.normal⟩ "logn" 10 (by decide) (by decide) ready.logn head8
  have kd8 := declared_transport _ s ⟨s8,.normal⟩ "k" .uint32 (by decide) (by decide) ready.k head8
  have kvalue := assign32 s8 ⟨s9,.normal⟩ "k" _ 1 kd8
    (fun v h => single_value s8 "logn" 10 (.bin .sub (num 11) (var "logn")) .u32 (.u32 1) v
      logn8 rfl rfl (by decide) (KeygenNttForwardExec.eval_scalar s8 _ v h)) kset
  have k9 : U32Slot s9 "k" 1 := by
    have hs := congrArg Result.state kvalue
    change s9=_ at hs
    rw [hs]; exact set32_slot s8 "k" 1
  have kout := slot_transport _ s9 out "k" 1 (by decide) (by decide) k9 tail9
  have bd2 : Declared s2 "b" .uint64 := by
    have hs := congrArg Result.state (declare_result s1 ⟨s2,.normal⟩ .u64 ["b"] db)
    change s2=_ at hs
    rw [hs]
    exact ⟨none,by simp [C99ScalarReference.set,C99ValueBridge.type]⟩
  have head7 : Exec (chainOf ((rowPrelude.drop 2).take 7)) s2 ⟨s9,.normal⟩ :=
    .seqNormal _ _ _ _ _ xcopy (.seqNormal _ _ _ _ _ ixcopy (.seqNormal _ _ _ _ _ g2set
      (.seqNormal _ _ _ _ _ g4set (.seqNormal _ _ _ _ _ ig2set (.seqNormal _ _ _ _ _ ig4set
        (.seqNormal _ _ _ _ _ kset (.base .skip s9 s9 (.skip s9))))))))
  have bd9 := declared_transport _ s2 ⟨s9,.normal⟩ "b" .uint64 (by decide) (by decide) bd2 head7
  have ln9 := slot_transport _ s8 ⟨s9,.normal⟩ "logn" 10 (by decide) (by decide) logn8 kset
  have bvalue := assign64 s9 ⟨s10,.normal⟩ "b" _ 512 bd9 (fun v h => by
    have hv := single_value s9 "logn" 10 (.bin .shl (.cast .u64 (num 1)) (.bin .sub (var "logn") (num 1)))
      .u64 (.u64 512) v ln9 rfl rfl (by decide) (KeygenNttForwardExec.eval_scalar s9 _ v h)
    rw [hv]; rfl) bset
  have bout : USlot out.state "b" 512 := by
    have hs := congrArg Result.state bvalue
    change s10=_ at hs
    rw [hend,hs]
    exact set64_slot s9 "b" 512 (by decide)
  exact ⟨⟨params_transport _ s out p0i (by decide) (by decide) (by decide) ready.params source,
    KeygenMkgm3Upward.pointers_after _ s out gm igm (by decide) pointers source,
    KeygenMkgm3RevMemory.transported _ s out rev (by decide) table source,kout,bout,g2out,g4out⟩,
    xout,declared_transport _ s out "u" .uint64 (by decide) (by decide) ready.u source⟩

theorem last_for (s : State) (out : Result) (p0i : BitVec 32) (gm igm rev : ArrayPointer)
    (ctx : Context p0i gm igm rev s) (x : Word s "x" 1) (declared : Declared s "u" .uint64)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec lastRowLoop s out) : Filled out.state.heap gm 512 ∧ USlot out.state "u" 512 := by
  have tail := C99ModularReference.continuation _ _ s (advanced s 0) out
    (fun r h => assign64 s r "u" _ 0 declared (fun v hv => by
      rw [KeygenNttLoopSupport.literal_i32 s 0 v (KeygenNttForwardExec.eval_scalar s _ v hv)]
      rfl) h) source
  apply (KeygenMkgm3Loops.last_loop p0i gm igm rev gw iw separate initialization _ out _ tail).2
  exact ⟨KeygenMkgm3Loops.advance_context s 0 p0i gm igm rev ctx,0,by decide,
    advanced_counter s 0 (by decide),KeygenMkgm3Loops.advance_word s "x" 1 0 (by decide) x,
    fun u hu => by omega⟩

theorem selected_row (s : State) (out : Result) (p0i : BitVec 32) (gm igm rev : ArrayPointer)
    (ready : Ready p0i s) (pointers : KeygenMkgm3Upward.Pointers s gm igm)
    (table : KeygenMkgm3RevMemory.Rev s rev)
    (gw : gm.elementBytes=4) (iw : igm.elementBytes=4)
    (separate : KeygenMkgm3Layout.DisjointBytes gm 4096 igm 4096)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (source : Exec rowSelect s out) :
    Filled out.state.heap gm 512 ∧ USlot out.state "u" 512 ∧ U32Slot out.state "k" 1 := by
  have zero (v : Value) (guard : C99ArrayReference.scalar s lognOne v) : v.integer=0 := by
    have hv := single_value s "logn" 10 lognOne .i32 (.i32 0) v ready.logn rfl rfl (by decide) guard
    rw [hv]; rfl
  obtain ⟨v,guard,hz,branch⟩ := (KeygenNttForwardExec.branch_inv _ _ _ s out source).resolve_left (by
    rintro ⟨v,guard,nonzero,_⟩
    exact nonzero (zero v guard))
  obtain ⟨inner,body,hout⟩ := KeygenNttLoopSupport.scope_result _ _ s out branch
  obtain ⟨mid,pre,tail⟩ := cut rowPrelude [lastRowLoop] s inner (by decide) body
  obtain ⟨ctx,x,declared⟩ := row_prelude s ⟨mid,.normal⟩ p0i gm igm rev ready pointers table initialization pre
  obtain ⟨after,loop,last⟩ := chain_inv _ _ mid inner (by decide) tail
  have hend := C99ModularReference.skip_result after inner last
  obtain ⟨filled,u⟩ := last_for mid ⟨after,.normal⟩ p0i gm igm rev ctx x declared gw iw separate initialization loop
  have k := slot_transport _ mid ⟨after,.normal⟩ "k" 1 (by decide) (by decide) ctx.k loop
  rw [hout,hend]
  exact ⟨filled,u,k⟩

end FT1536.Source3.KeygenMkgm3RowInit
