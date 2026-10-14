import Source3.KeygenBezoutArity098

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenZintCall098
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenZintCall

theorem source_parsed (kind : Callee) : calleeParsed kind = some (calleeBody kind) := by
  cases kind
  case leaf => rfl
  case modSigned => exact KeygenZintCore.parsed_of .modSigned KeygenZintCore.mod_signed_audit
  case normZero => exact KeygenZintCore.parsed_of .normZero KeygenZintCore.norm_zero_audit
  case exactLen => exact KeygenZintCore.parsed_of .exactLen KeygenZintCore.exact_len_audit
  case rshiftMod => exact KeygenZintCore.parsed_of .rshiftMod KeygenZintCore.rshift_mod_audit
  case subMod => exact KeygenZintCore.parsed_of .subMod KeygenZintCore.sub_mod_audit
  case rebuildCrt => exact KeygenZintCore.parsed_of .rebuildCrt KeygenZintCore.rebuild_crt_audit
  case coReduce => exact KeygenZintCore.parsed_of .coReduce KeygenZintCore.co_reduce_audit
  case coReduceMod => exact KeygenZintCore.parsed_of .coReduceMod KeygenZintCore.co_reduce_mod_audit
  case reduce => exact KeygenZintCore.parsed_of .reduce KeygenZintCore.reduce_k_audit
  case reduceMod => exact KeygenZintCore.parsed_of .reduceMod KeygenZintCore.reduce_mod_audit
  case bezout | bitlength | signedBitLength => rfl

theorem leaf_parsed (kind : KeygenZintLeaves.Kind) : KeygenZintLeaves.parsed kind = some (KeygenZintLeaves.code kind) :=
  KeygenZintLeaves.parsed_source kind

theorem bezout_parsed (i : Fin 8) : bezoutParsed i.val = some (bezoutPart i.val) := by
  fin_cases i
  · exact KeygenZintCore.bezout_parsed_part 0 KeygenZintCore.bezout_audit0
  · exact KeygenZintCore.bezout_parsed_part 1 KeygenZintCore.bezout_audit1
  · exact KeygenZintCore.bezout_parsed_part 2 KeygenZintCore.bezout_audit2
  · exact KeygenZintCore.bezout_parsed_part 3 KeygenZintCore.bezout_audit3
  · exact KeygenZintCore.bezout_parsed_part 4 KeygenZintCore.bezout_audit4
  · exact KeygenZintCore.bezout_parsed_part 5 KeygenZintCore.bezout_audit5
  · exact KeygenZintCore.bezout_parsed_part 6 KeygenZintCore.bezout_audit6
  · exact KeygenZintCore.bezout_parsed_part 7 KeygenZintCore.bezout_audit7

theorem bitlength_parsed (i : Fin 3) : extractParsed .bitlength i.val = some (extractPart .bitlength i.val) := by
  fin_cases i
  · exact KeygenZintExtract.parsed_part .bitlength 0 KeygenZintExtract.bitlength_audit0
  · exact KeygenZintExtract.parsed_part .bitlength 1 KeygenZintExtract.bitlength_audit1
  · exact KeygenZintExtract.parsed_part .bitlength 2 KeygenZintExtract.bitlength_audit2

theorem signed_parsed (i : Fin 5) : extractParsed .signedBitLength i.val = some (extractPart .signedBitLength i.val) := by
  fin_cases i
  · exact KeygenZintExtract.parsed_part .signedBitLength 0 KeygenZintExtract.signed_audit0
  · exact KeygenZintExtract.parsed_part .signedBitLength 1 KeygenZintExtract.signed_audit1
  · exact KeygenZintExtract.parsed_part .signedBitLength 2 KeygenZintExtract.signed_audit2
  · exact KeygenZintExtract.parsed_part .signedBitLength 3 KeygenZintExtract.signed_audit3
  · exact KeygenZintExtract.parsed_part .signedBitLength 4 KeygenZintExtract.signed_audit4

theorem closed (kind : Callee) : KeygenZintDeterminism098.checkedCode (calleeBody kind) = true := by
  cases kind
  case leaf kind => exact KeygenZintCoreArity098.leaf kind
  case modSigned => exact KeygenZintCoreArity098.modSigned
  case normZero => exact KeygenZintCoreArity098.normZero
  case exactLen => exact KeygenZintCoreArity098.exactLen
  case rshiftMod => exact KeygenZintCoreArity098.rshiftMod
  case subMod => exact KeygenZintCoreArity098.subMod
  case rebuildCrt => exact KeygenZintCoreArity098.rebuildCrt
  case coReduce => exact KeygenZintCoreArity098.coReduce
  case coReduceMod => exact KeygenZintCoreArity098.coReduceMod
  case reduce => exact KeygenZintCoreArity098.reduce
  case reduceMod => exact KeygenZintCoreArity098.reduceMod
  case bezout => exact KeygenBezoutArity098.body
  case bitlength => exact KeygenZintExtractArity098.bitlength
  case signedBitLength => exact KeygenZintExtractArity098.signedBitLength

theorem body_unique (kind : Callee) (before : State) (a b : Result)
    (first : Exec (calleeBody kind) before a) (second : Exec (calleeBody kind) before b) : a = b :=
  KeygenZintDeterminism098.execution closed _ before a b (closed kind) first second

theorem call_unique (kind : Callee) (before a b : State) (args : List C99ArrayReference.Arg) (x y : Option Value)
    (first : Call kind before args a x) (second : Call kind before args b y) : a = b ∧ x = y := by
  obtain ⟨entry1, out1, binding1, source1, returned1, state1⟩ := first
  obtain ⟨entry2, out2, binding2, source2, returned2, state2⟩ := second
  have entries := C99ArrayDeterminism089.parameters before _ args entry1 entry2 binding1 binding2
  subst entry2
  have outcomes := body_unique kind entry1 out1 out2 source1 source2
  subst out2
  exact ⟨state1.trans state2.symm, C99ProcedureDeterminism094.returned _ _ x y returned1 returned2⟩

/-- Exact partial denotation of the complete existing bigint source family.
    Both failure returns and defined normal returns remain source results. -/
noncomputable def runCall (kind : Callee) (before : State) (args : List C99ArrayReference.Arg) : Part (State × Option Value) where
  Dom := ∃ result : State × Option Value, Call kind before args result.1 result.2
  get domain := Classical.choose domain

theorem runCall_spec (kind : Callee) (before : State) (args : List C99ArrayReference.Arg) (out : State × Option Value) :
    out ∈ runCall kind before args ↔ Call kind before args out.1 out.2 := by
  constructor
  · rintro ⟨domain, equal⟩
    have source := Classical.choose_spec domain
    rw [← equal]
    exact source
  · intro source
    let domain : ∃ result : State × Option Value, Call kind before args result.1 result.2 := ⟨out, source⟩
    have same := call_unique kind before (Classical.choose domain).1 out.1 args (Classical.choose domain).2 out.2
      (Classical.choose_spec domain) source
    exact ⟨domain, Prod.ext same.1 same.2⟩

end FT1536.Source3.KeygenZintCall098
