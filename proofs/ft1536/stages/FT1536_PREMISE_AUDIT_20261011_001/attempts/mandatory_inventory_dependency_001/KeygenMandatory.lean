import Source3.KeygenCPP
import B20.C.ByteMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenMandatory
open B20.C

/- Caller-local control-flow fragment. The local and struct-field bindings
are supplied by the enclosing execution frame. Callees are parameterized
by their execution function, not by an assumed successful postcondition.
This lemma does not instantiate that function for the full KeyGen prefix,
or prove its memory frame / encoding / NTRU properties. -/
inductive Argument where
  | word (value : Val)
  | pointer (value : B20.C.Byte.Pointer)

inductive ArgTerm where
  | variable (name : B20.C.Name)
  | fprField (object field : B20.C.Name)
  deriving DecidableEq, Repr

structure Frame where
  locals : B20.C.Name → Option Argument
  field : B20.C.Byte.Pointer → B20.C.Name → Option Argument

def scalarEnv (frame : Frame) : Env := fun name => do
  match ← frame.locals name with
  | .word v => pure v
  | _ => none

def resolve (frame : Frame) : ArgTerm → Option Argument
  | .variable name => frame.locals name
  | .fprField object field => do
      match ← frame.locals object with
      | .pointer p =>
          match ← frame.field p field with
          | .pointer q => if q.offset%8=0 then some (.pointer q) else none
          | _ => none
      | _ => none

def parseArg : List Token → Option (ArgTerm × List Token)
  | ['(']::ty::['*']::[')']::object::['-']::['>']::field::rest =>
      if ty="fpr".toList then some (.fprField object field,rest) else none
  | name::rest => if !name.isEmpty && name.all wordChar then some (.variable name,rest) else none
  | [] => none

def parseArgs : Nat → List Token → Option (List ArgTerm × List Token)
  | 0,_ => none
  | fuel+1,ts => do
      let (arg,rest) ← parseArg ts
      match rest with
      | [')']::tail => pure ([arg],tail)
      | [',']::tail => do
          let (args,rest) ← parseArgs fuel tail
          pure (arg::args,rest)
      | _ => none

structure Flow where
  guard : CLogic.Expr
  callee : B20.C.Name
  args : List ArgTerm
  deriving DecidableEq, Repr

/- Grammar of a conditional failure-continue followed by break. The
condition is parsed/evaluated as an expression, not replaced with true. -/
def parse : List Token → Option Flow
  | ifTk::['(']::ts => do
      if ifTk≠"if".toList then none else do
        let (guard,rest) ← CLogicParser.expression 16 ts
        match rest with
        | [')']::['{']::innerIf::['(']::['!']::callee::['(']::rest => do
            let (args,tail) ← parseArgs 16 rest
            match tail with
            | [')']::['{']::cont::[';']::['}']::['}']::brk::[';']::[] =>
                if innerIf="if".toList ∧ cont="continue".toList ∧ brk="break".toList then
                  pure ⟨guard,callee,args⟩ else none
            | _ => none
        | _ => none
  | _ => none

def source : Option Flow :=
  ((KeygenCPP.preprocess (fun _ => false) KeygenCPP.mandatoryLines).bind KeygenCPP.tokens).bind parse

def program : Flow where
  guard := .land (.land (.var "ter".toList)
    (.cmp .eq (.var "logn".toList) (.literal .i32 10)))
    (.cmp .eq (.var "n".toList) (.literal .i32 1536))
  callee := "ft_keygen_leaf_certificate".toList
  args := [.fprField "fk".toList "tmp".toList,
    .variable "f".toList,.variable "g".toList,.variable "F".toList,.variable "G".toList,
    .variable "logn".toList,.variable "ter".toList]

theorem source_parses : source=some program := by
  rw [source,KeygenCPP.mandatory_tokens]
  decide

inductive Exit where
  | nextAttempt | acceptedBreak
  deriving DecidableEq, Repr

abbrev Calls (Memory : Type) := B20.C.Name → List Argument → Memory → Option (Val × Memory)

def execute {Memory : Type} (calls : Calls Memory) (frame : Frame) (flow : Flow)
    (memory : Memory) : Option (Exit × Memory) := do
  let g ← CLogic.eval (fun _ _ => none) (scalarEnv frame) 32 flow.guard
  if CLogic.truth g then do
    let args ← flow.args.mapM (resolve frame)
    let (value,after) ← calls flow.callee args memory
    if CLogic.truth value then pure (.acceptedBreak,after) else pure (.nextAttempt,after)
  else pure (.acceptedBreak,memory)

def LegalProfile (frame : Frame) : Prop :=
  frame.locals "ter".toList=some (.word (.u32 1#32)) ∧
  frame.locals "logn".toList=some (.word (.u32 10#32)) ∧
  frame.locals "n".toList=some (.word (.u64 1536#64))

theorem profile_guard (frame : Frame) (h : LegalProfile frame) :
    CLogic.eval (fun _ _ => none) (scalarEnv frame) 32 program.guard=some (CLogic.boolean true) := by
  obtain ⟨ht,hl,hn⟩:=h
  change frame.locals ['t','e','r']=some (.word (.u32 1#32)) at ht
  change frame.locals ['l','o','g','n']=some (.word (.u32 10#32)) at hl
  change frame.locals ['n']=some (.word (.u64 1536#64)) at hn
  simp [program,CLogic.eval,scalarEnv,ht,hl,hn,B20.C.literalValue,CLogic.compare,
    B20.C.commonTy,B20.C.Val.ty,B20.C.cast,CLogic.boolean,CLogic.truth,B20.C.Val.integer]

theorem break_requires_call {Memory : Type} (calls : Calls Memory) (frame : Frame)
    (before after : Memory) (hp : LegalProfile frame)
    (hexec : execute calls frame program before=some (.acceptedBreak,after)) :
    ∃ args value, program.args.mapM (resolve frame)=some args ∧
      calls "ft_keygen_leaf_certificate".toList args before=some (value,after) ∧
      CLogic.truth value=true := by
  unfold execute at hexec
  rw [profile_guard frame hp] at hexec
  simp only [bind,Option.bind,CLogic.truth_boolean,ite_true] at hexec
  cases ha : program.args.mapM (resolve frame) with
  | none => simp [ha] at hexec
  | some args =>
      rw [ha] at hexec
      dsimp only at hexec
      cases hc : calls program.callee args before with
      | none => simp [hc] at hexec
      | some pair =>
          rcases pair with ⟨value,mem⟩
          rw [hc] at hexec
          dsimp only at hexec
          cases hv : CLogic.truth value
          · simp [hv] at hexec
          · have hm : mem=after := by simpa [hv] using hexec
            subst mem
            exact ⟨args,value,rfl,hc,hv⟩

theorem source_break_requires_gate_call {Memory : Type} (calls : Calls Memory) (frame : Frame)
    (before after : Memory) (hp : LegalProfile frame)
    (hexec : source.bind (fun flow => execute calls frame flow before)=some (.acceptedBreak,after)) :
    ∃ args value, program.args.mapM (resolve frame)=some args ∧
      calls "ft_keygen_leaf_certificate".toList args before=some (value,after) ∧
      CLogic.truth value=true := by
  rw [source_parses,Option.bind_some] at hexec
  exact break_requires_call calls frame before after hp hexec

end FT1536.Source3.KeygenMandatory

#print FT1536.Source3.KeygenMandatory.source_break_requires_gate_call
#print axioms FT1536.Source3.KeygenMandatory.source_parses
#print axioms FT1536.Source3.KeygenMandatory.source_break_requires_gate_call
