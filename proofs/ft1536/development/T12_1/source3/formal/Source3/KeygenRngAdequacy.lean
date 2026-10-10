import Source3.KeygenMakeReadySampling

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Additional exact lowering checks. Live source bytes, compiler macro
   values and the Linux fragments are externally hash-bound by native Sage;
   these kernel equalities check their declared grammar, not the compiler. -/
namespace FT1536.Source3.KeygenRngAdequacy
open B20.C (Token)

def decodeUnary (sub : CLogicParser.Parser) : Nat → CLogicParser.Parser
  | 0,_ => none
  | fuel+1,['(']::ty::[')']::rest =>
      match B20.C.Scalar.typeToken ty with
      | some t => (decodeUnary sub fuel rest).map (fun (e,tail) => (.cast t e,tail))
      | none => do
          let (e,tail) ← sub (ty::[')']::rest)
          match tail with | [')']::tail => pure (e,tail) | _ => none
  | _+1,['(']::rest => do
      let (e,tail) ← sub rest
      match tail with | [')']::tail => pure (e,tail) | _ => none
  | _+1,['b','u','f']::['[']::rest => do
      let (index,tail) ← sub rest
      match tail with | [']']::tail => pure (.call1 "$seed_byte".toList index,tail) | _ => none
  | _+1,t::rest =>
      if t.isEmpty then none
      else if B20.C.digit t.head! then (CLogicParser.number t).map (fun e => (e,rest))
      else if t.all B20.C.wordChar then pure (.var t,rest) else none
  | _+1,[] => none
def decodeAt : Nat → Nat → CLogicParser.Parser
  | 0,_,_ => none
  | fuel+1,precedence,ts => do
      let sub := fun prec => decodeAt fuel prec
      let (head,rest) ← decodeUnary (sub 1) fuel ts
      CLogicParser.parseMore sub precedence fuel head rest
def parsedDecode : Option CLogic.Expr := do
  let tokens ← C99ProcedureParser.tokens (((ShakeSource.sourceLines.drop 62).take 8).flatMap String.toList)
  match tokens with
  | ['r','e','t','u','r','n']::rest => do
      let (expression,tail) ← decodeAt 32 1 rest
      if tail=[[';']] then pure expression else none
  | _ => none
def decodedByte (i : Nat) : CLogic.Expr := .cast .u64 (.call1 "$seed_byte".toList (.literal .i32 i))
def shiftedByte (i : Nat) : CLogic.Expr :=
  if i=0 then decodedByte i else .bin .shl (decodedByte i) (.literal .i32 (8*i))
def decoderTree : CLogic.Expr := .bin .bor (.bin .bor (.bin .bor (.bin .bor (.bin .bor
  (.bin .bor (.bin .bor (shiftedByte 0) (shiftedByte 1)) (shiftedByte 2)) (shiftedByte 3))
  (shiftedByte 4)) (shiftedByte 5)) (shiftedByte 6)) (shiftedByte 7)
theorem decoder_source_tree : parsedDecode=some decoderTree := by decide
theorem decoder_lowering : C99Frontend.expression decoderTree=ShakeSeedMemory.decodeExpr := by rfl

def LinuxPreprocess : Nat → Bool → Bool → List String → Option (List String)
  | _,_,_,[] => some []
  | depth,enabled,parent,line::rest =>
    if line="#if USE_URANDOM\n" then
      if depth=0 then LinuxPreprocess 1 true enabled rest else none
    else if line="#if USE_WIN32_RAND\n" then
      if depth=0 then LinuxPreprocess 1 false enabled rest else none
    else if line="#endif\n" then
      if depth=1 then LinuxPreprocess 0 parent true rest else none
    else if line="\t/* (NIST_API_REMOVE_BEGIN) */\n" || line="\t/* (NIST_API_REMOVE_END) */\n" then
      LinuxPreprocess depth enabled parent rest
    else do
      let tail ← LinuxPreprocess depth enabled parent rest
      pure (if enabled then line::tail else tail)
theorem linux_wrapper_source : LinuxPreprocess 0 true true KeygenEntropySource.wrapperLines=
    some KeygenEntropySource.linuxWrapper := by decide
theorem linux_urandom_source : LinuxPreprocess 0 true true KeygenEntropySource.urandomLines=
    some (KeygenEntropySource.urandomLines.drop 1 |>.take 29) := by decide
theorem actual_rng_offsets (ctx : KeygenSearchContext.Context) :
    (KeygenSamplerContext.rng ctx).base=ctx.object.offset+8 ∧
    (KeygenReadyFast.field ctx .seeded).base=ctx.object.offset+424 ∧
    (KeygenReadyFast.field ctx .flipped).base=ctx.object.offset+428 ∧
    (KeygenSearchContext.field ctx 432 8).base=ctx.object.offset+432 := by
  exact ⟨rfl,rfl,rfl,rfl⟩
theorem both_tmp_extents (before : C99ArrayReference.State) (block : Nat) :
    (KeygenRngReference.entered before block).heap.size block=32 ∧
    (KeygenRngReference.entered before block).heap.writable block=true ∧
    (KeygenRngReference.entered before block).arrays "tmp".toList=some ⟨block,0,32,1,0⟩ ∧
    ∀ o, (KeygenRngReference.entered before block).heap.bytes block o=none := by
  simp [KeygenRngReference.entered,KeygenMakeObjects.allocated,C99ArrayReference.bindPointer]
theorem disposal_before_or_after_return (before : C99ArrayReference.State) (out : C99ProcedureReference.Result) (block : Nat) :
    (KeygenRngReference.closed before out block).flow=out.flow ∧
    (KeygenRngReference.closed before out block).state.heap.size block=before.heap.size block ∧
    (KeygenRngReference.closed before out block).state.heap.writable block=before.heap.writable block ∧
    ∀ o, (KeygenRngReference.closed before out block).state.heap.bytes block o=before.heap.bytes block o := by
  simp [KeygenRngReference.closed,KeygenRngSource.disposed]

end FT1536.Source3.KeygenRngAdequacy
