import Source3.KeygenMakeLifetime

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Typed external argument binding for the SAME complete source header.
   Arguments and static input memory are not desired body postconditions.
   The invocation below stops at the complete readiness prefix; there is no
   rule for an arbitrary remaining body, an encoder or successful KeyGen. -/
namespace FT1536.Source3.KeygenMakeArguments
open C99MemoryReference
open C99ArrayReference (State Name Param bindValue bindPointer)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open C99ProcedureReference (Result)

structure Arguments where
  fk : ArrayPointer
  comp : BitVec 32
  privkey : ArrayPointer
  privkeyLen : ArrayPointer
  pubkey : ArrayPointer
  pubkeyLen : ArrayPointer

inductive Argument where
  | scalar (value : Value)
  | pointer (value : ArrayPointer)

def params : List Param := [.pointer "fk".toList,.scalar .int32 "comp".toList,
  .pointer "privkey".toList,.pointer "privkey_len".toList,
  .pointer "pubkey".toList,.pointer "pubkey_len".toList]
def values (args : Arguments) : List Argument := [.pointer args.fk,.scalar (.int32 args.comp),
  .pointer args.privkey,.pointer args.privkeyLen,.pointer args.pubkey,.pointer args.pubkeyLen]
def fromHeader (p : KeygenMakeSyntax.Object) : Option Param :=
  match p.type with
  | .pointer _ => some (.pointer p.name)
  | .i32 => some (.scalar .int32 p.name)
  | _ => none
def parsedParams : List (Option Param) := KeygenMakeSyntax.expectedHeader.parameters.map fromHeader
theorem header_params : parsedParams=params.map some := by decide +kernel
theorem header_source : KeygenMakeGrammar.Whole KeygenMakeTokens.all
    KeygenMakeSyntax.expectedHeader KeygenMakeProgram.code := KeygenMakeProgram.source_bound

def base (caller : State) : State :=
  ⟨caller.heap,caller.globals,caller.tables,caller.globals,caller.tables⟩
inductive Bind (caller : State) : List Param → List Argument → State → Prop where
  | nil : Bind caller [] [] (base caller)
  | scalar (ty : C99IntegerReference.Ty) (name : Name) (ps : List Param)
      (value : Value) (args : List Argument) (out : State) (rest : Bind caller ps args out) :
      Bind caller (.scalar ty name::ps) (.scalar value::args) (bindValue out name ty value)
  | pointer (name : Name) (ps : List Param) (value : ArrayPointer)
      (args : List Argument) (out : State) (rest : Bind caller ps args out) :
      Bind caller (.pointer name::ps) (.pointer value::args) (bindPointer out name value)

def entry (caller : State) (args : Arguments) : State :=
  bindPointer (bindValue (bindPointer (bindPointer (bindPointer (bindPointer
    (base caller) "pubkey_len".toList args.pubkeyLen) "pubkey".toList args.pubkey)
    "privkey_len".toList args.privkeyLen) "privkey".toList args.privkey)
    "comp".toList .int32 (.int32 args.comp)) "fk".toList args.fk
theorem bind_exact (caller : State) (args : Arguments) (out : State)
    (source : Bind caller params (values args) out) : out=entry caller args := by
  cases source
  cases ‹Bind caller _ _ _›
  cases ‹Bind caller _ _ _›
  cases ‹Bind caller _ _ _›
  cases ‹Bind caller _ _ _›
  cases ‹Bind caller _ _ _›
  cases ‹Bind caller _ _ _›
  rfl
theorem bind_exists (caller : State) (args : Arguments) : Bind caller params (values args) (entry caller args) :=
  .pointer _ _ _ _ _ (.scalar _ _ _ _ _ _ (.pointer _ _ _ _ _
    (.pointer _ _ _ _ _ (.pointer _ _ _ _ _ (.pointer _ _ _ _ _ .nil)))))
theorem actual_cells (caller : State) (args : Arguments) (out : State)
    (source : Bind caller params (values args) out) :
    out.arrays "fk".toList=some args.fk ∧ out.locals "comp".toList=some (.int32,some (.int32 args.comp)) ∧
    out.arrays "privkey".toList=some args.privkey ∧ out.arrays "privkey_len".toList=some args.privkeyLen ∧
    out.arrays "pubkey".toList=some args.pubkey ∧ out.arrays "pubkey_len".toList=some args.pubkeyLen ∧
    out.heap=caller.heap ∧ out.globals=caller.globals ∧ out.tables=caller.tables := by
  rw [bind_exact caller args out source]
  refine ⟨rfl,?_,rfl,rfl,rfl,rfl,rfl,rfl,rfl⟩
  change some (C99IntegerReference.Ty.int32,some (C99IntegerReference.convert
    (Value.int32 args.comp).type (Value.int32 args.comp).integer))=_
  rw [C99CountedWords.convert_self]

inductive PrefixInvocation (args : Arguments) (ctx : Context) (caller : State) (blocks : Fin 6 → Nat) :
    List KeygenEntropySource.Event → Result → Prop where
  | run (bound : State) (events : List KeygenEntropySource.Event) (raw : Result)
      (binding : Bind caller params (values args) bound)
      (source : KeygenMakeReady.Prefix ctx bound blocks events raw) :
      PrefixInvocation args ctx caller blocks events raw
theorem normal_entry (args : Arguments) (ctx : Context) (caller after : State)
    (blocks : Fin 6 → Nat) (events : List KeygenEntropySource.Event) (primes rev : ArrayPointer)
    (original : KeygenMakeEntry.Original ctx (entry caller args) primes rev)
    (source : PrefixInvocation args ctx caller blocks events ⟨after,.normal⟩) :
    KeygenCapWords.Count after 0 ∧
    KeygenCallerEntry.Initial ctx after (KeygenMakeEntry.input blocks) (KeygenMakeEntry.publicPointer blocks) primes rev ∧
    KeygenReadyResult.flagPresent ctx after.heap .seeded ∧ KeygenReadyResult.flagPresent ctx after.heap .flipped := by
  cases source with
  | run bound events raw binding source =>
    have equal := bind_exact caller args bound binding
    subst bound
    exact KeygenMakeReady.normal_prefix ctx _ after blocks primes rev original events source

end FT1536.Source3.KeygenMakeArguments
