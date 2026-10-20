import Source3.KeygenRootObjects

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-specific natural semantics of the root validation suffix. The
   earlier proved conversion, generator, transform and comparison programs
   run on the actual shared heap. Entry invariants are proved separately. -/
namespace FT1536.Source3.KeygenRootValidationSource
open C99ArrayReference (State Param bindValue bindPointer)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)

theorem uint32_cast (word : BitVec 32) : C99IntegerReference.convert .uint32 (Value.uint32 word).integer=.uint32 word :=
  C99CountedWords.convert_self (.uint32 word)

def aliases (s : State) (root : ArrayPointer) : State :=
  KeygenMkgm3Layout.ready (bindPointer s "ft".toList root) root
def selected (s : State) (root primes : ArrayPointer) : State := bindPointer (aliases s root) "primes".toList primes
def primed (s : State) (root primes : ArrayPointer) (p : Value) : State := bindValue (selected s root primes) "p".toList .uint32 p
def ready (s : State) (root primes : ArrayPointer) (p0i : BitVec 32) : State :=
  bindValue (primed s root primes (.uint32 KeygenNinv31.prime)) "p0i".toList .uint32 (.uint32 p0i)
theorem prepare_source : KeygenRootSearch.tokens 7337 26=KeygenRootSearch.lex
    "if (!poly_big_to_small(F, fk->tmp, logn, fk->ternary) || !poly_big_to_small(G, fk->tmp + n, logn, fk->ternary)) { return 0; } ft = fk->tmp; gt = ft + n; Ft = gt + n; Gt = Ft + n; gm = Gt + n; primes = fk->ternary ? PRIMES3 : PRIMES2; p = primes[0].p; p0i = modp_ninv31(p); if (fk->ternary) {" := by decide +kernel
theorem generation_source : KeygenRootSearch.tokens 7363 4=KeygenRootSearch.lex
    "modp_mkgm3(gm, ft, logn, 1, primes[0].g, p, p0i); } else { modp_mkgm2(gm, ft, logn, primes[0].g, p, p0i); }" := by decide
theorem transform_dispatch : KeygenRootSearch.tokens 7373 1=KeygenRootSearch.lex "if (fk->ternary) {" := by decide
theorem transform_inactive : KeygenRootSearch.tokens 7379 7=KeygenRootSearch.lex
    "} else { modp_NTT2(ft, gm, logn, p, p0i); modp_NTT2(gt, gm, logn, p, p0i); modp_NTT2(Ft, gm, logn, p, p0i); modp_NTT2(Gt, gm, logn, p, p0i); r = modp_montymul(12289, 1, p, p0i); }" := by decide
theorem close : KeygenRootSearch.lines 7396 2=["\treturn 1;\n","}\n"] := by decide

inductive Prepare (ctx : Context) (before : State) : State → Prop where
  | run (root primes : ArrayPointer) (aliased : Result) (ternary : BitVec 32) (p : Value) (p0i : BitVec 32)
      (tmp : KeygenSearchContext.ReadTmp ctx before root)
      (layout : C99ModularReference.Exec KeygenMkgm3Layout.aliasCode (bindPointer before "ft".toList root) aliased)
      (normal : aliased.flow=.normal)
      (member : KeygenSearchContext.ReadTernary ctx aliased.state ternary) (nonzero : ternary.toNat≠0)
      (table : aliased.state.arrays "PRIMES3".toList=some primes)
      (primeRead : KeygenLevelCalls.PrimeRead (bindPointer aliased.state "primes".toList primes)
        "primes".toList (.literal .i32 0) .p p)
      (inverse : KeygenNinv31.SourceExec (BitVec.ofInt 32 p.integer) (.uint32 p0i)) :
      Prepare ctx before (bindValue (bindValue (bindPointer aliased.state "primes".toList primes)
        "p".toList .uint32 p) "p0i".toList .uint32 (.uint32 p0i))
def genArgs : List KeygenLevelCalls.Arg := [
  .pointer "gm".toList C99ProcedureParser.zero,.pointer "ft".toList C99ProcedureParser.zero,
  .scalar (.modular (.scalar (.var "logn".toList))),.scalar (.modular (.scalar (.literal .i32 1))),
  .scalar (.prime "primes".toList (.literal .i32 0) .g),
  .scalar (.modular (.scalar (.var "p".toList))),.scalar (.modular (.scalar (.var "p0i".toList)))]
def returned (before : State) (out : Result) : State := {before with heap := out.state.heap}
inductive Exec (ctx : Context) (before : State) : Result → Prop where
  | run (prepared entry : State) (generated : Result) (converted : Result) (transformed : State) (out : Result)
      (genTernary nttTernary : BitVec 32) (preparation : Prepare ctx before prepared)
      (genMember : KeygenSearchContext.ReadTernary ctx prepared genTernary) (genNonzero : genTernary.toNat≠0)
      (binding : KeygenLevelCalls.Bind prepared (KeygenLevelCalls.params .generate) genArgs entry)
      (generation : C99ModularReference.Exec KeygenMkgm3Program.code entry generated)
      (genReturn : C99ProcedureReference.ReturnValue none generated.flow none)
      (conversion : C99ModularReference.Exec KeygenResidueProgram.code (returned prepared generated) converted)
      (convNormal : converted.flow=.normal)
      (nttMember : KeygenSearchContext.ReadTernary ctx converted.state nttTernary) (nttNonzero : nttTernary.toNat≠0)
      (transforms : KeygenSolverNttCalls.Exec KeygenSolverNttCalls.code converted.state transformed)
      (validation : C99ModularReference.Exec KeygenSolverTarget.code transformed out) : Exec ctx before out

theorem first_read (s : State) (primes : ArrayPointer) (table : KeygenStaticTables.PrimeTable)
    (binding : s.arrays "primes".toList=some primes) (object : KeygenStaticTables.PrimeObject s.heap primes table)
    (field : KeygenLevelCalls.Field) (v : Value)
    (read : KeygenLevelCalls.PrimeRead s "primes".toList (.literal .i32 0) field v) :
    v=.uint32 (BitVec.ofNat 32 (KeygenStaticTables.fieldValue (KeygenStaticReads.first table) field)) := by
  obtain ⟨iv,i,entry,value,index,_,loaded,result⟩ := KeygenStaticReads.prime_read s table _ primes _ field v binding object read
  have he := KeygenNttLoopSupport.literal_i32 s 0 iv value
  subst iv
  have iz : i=0 := index
  subst i
  have actual := Option.some.inj ((KeygenStaticReads.first_value table).symm.trans loaded)
  subst entry
  exact result
theorem prepared (ctx : Context) (before after : State) (primes : ArrayPointer)
    (size : C99CountedWords.Limit before) (table : before.arrays "PRIMES3".toList=some primes)
    (object : KeygenStaticTables.PrimeObject before.heap primes .ternary)
    (source : Prepare ctx before after) : ∃ p0i, after=ready before ctx.scratch primes p0i ∧
      KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i) := by
  cases source with
  | run root actual aliased ternary p p0i tmp layout normal member nonzero binding primeRead inverse =>
    have hr := KeygenSearchContext.tmp_value ctx before root tmp
    subst root
    have ha := KeygenMkgm3Layout.alias_result (bindPointer before "ft".toList ctx.scratch) ctx.scratch aliased rfl size layout
    subst aliased
    have hp : actual=primes := Option.some.inj (binding.symm.trans table)
    subst actual
    have value := first_read (selected before ctx.scratch primes) primes .ternary rfl object .p p primeRead
    change p=.uint32 KeygenNinv31.prime at value
    subst p
    exact ⟨p0i,rfl,inverse⟩

theorem generator_entry (before entry : State) (root primes rev : ArrayPointer) (p0i : BitVec 32)
    (logn : KeygenNttForwardExec.lognAt before) (object : KeygenStaticTables.PrimeObject before.heap primes .ternary)
    (revBinding : before.tables "REV10".toList=some rev) (revSource : KeygenMkgm3RevMemory.SourceTable before.heap rev)
    (legal : KeygenMkgm3Layout.Legal before.heap root)
    (source : KeygenLevelCalls.Bind (ready before root primes p0i) (KeygenLevelCalls.params .generate) genArgs entry) :
    KeygenMkgm3.Entry entry p0i root rev := by
  cases source with
  | pointer _ _ _ gm _ _ _ gmRead rest =>
    cases rest with
    | pointer _ _ _ ft _ _ _ ftRead rest =>
      cases rest with
      | scalar _ _ _ _ _ _ lv lognRead rest =>
        cases rest with
        | scalar _ _ _ _ _ _ full fullRead rest =>
          cases rest with
          | scalar _ _ _ _ _ _ g generatorRead rest =>
            cases rest with
            | scalar _ _ _ _ _ _ p primeRead rest =>
              cases rest with
              | scalar _ _ _ _ _ _ inv inverseRead rest =>
                cases rest
                have hg := KeygenSolverNttCalls.pointer_zero (ready before root primes p0i) "gm" (KeygenMkgm3Layout.gm root) gm rfl gmRead
                have hf := KeygenSolverNttCalls.pointer_zero (ready before root primes p0i) "ft" root ft rfl ftRead
                subst gm ft
                cases lognRead with | modular e v value =>
                  have hv := C99CountedWords.variable_exact (ready before root primes p0i) "logn".toList .uint32 (.uint32 10) lv logn
                    (KeygenNttForwardExec.eval_scalar _ _ _ value)
                  subst lv
                  cases fullRead with | modular e v value =>
                    have hv := KeygenNttLoopSupport.literal_i32 (ready before root primes p0i) 1 full
                      (KeygenNttForwardExec.eval_scalar _ _ _ value)
                    subst full
                    cases generatorRead with | prime name index field v read =>
                      have hg := first_read (ready before root primes p0i) primes .ternary rfl object .g g read
                      subst g
                      cases primeRead with | modular e v value =>
                        have hp := C99CountedWords.variable_exact (ready before root primes p0i) "p".toList .uint32 (.uint32 KeygenNinv31.prime) p rfl
                          (KeygenNttForwardExec.eval_scalar _ _ _ value)
                        subst p
                        cases inverseRead with | modular e v value =>
                          have hi := C99CountedWords.variable_exact (ready before root primes p0i) "p0i".toList .uint32 (.uint32 p0i) inv
                            (by change some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.convert .uint32 (Value.uint32 p0i).integer))=_
                                rw [uint32_cast])
                            (KeygenNttForwardExec.eval_scalar _ _ _ value)
                          subst inv
                          simp only [bindValue,uint32_cast] at *
                          exact ⟨⟨rfl,rfl⟩,rfl,rfl,rfl,⟨rfl,rfl⟩,revBinding,revSource,legal⟩

end FT1536.Source3.KeygenRootValidationSource
