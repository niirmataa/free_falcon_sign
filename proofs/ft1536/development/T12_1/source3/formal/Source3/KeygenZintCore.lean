import Source3.KeygenZintCall
import Source3.KeygenMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source bindings of the signed/reduction/CRT bigint closure used by
   make_fg_step and zint_bezout: zint_mod_small_signed, zint_norm_zero,
   zint_exact_length, zint_rshift1_mod, zint_sub_mod and the complete
   zint_rebuild_CRT body. Every callee executes its pinned body; the
   seven sealed leaves are shared through KeygenZintLeaves. These are
   operational/frame results: no CRT correctness, normalization or
   Bezout claim is made here. -/
namespace FT1536.Source3.KeygenZintCore
open C99ArrayReference (State Name Param Arg)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenZintCall (Callee)

def region := KeygenLevelNtt.region

theorem mod_signed_header : region 3422 3 = ["static uint32_t\n",
  "zint_mod_small_signed(const uint32_t *d, size_t dlen,\n",
  "\tuint32_t p, uint32_t p0i, uint32_t R2, uint32_t Rx)\n"] := by decide
theorem mod_signed_close : Pinned.keygenLines[3433]?=some "}\n" := by decide
theorem mod_signed_audit : (KeygenZintCall.calleeParsed .modSigned).map
    (KeygenZintCall.only (KeygenZintCall.writable .modSigned))=some true := by decide
theorem mod_signed_shape : (KeygenZintCall.calleeParsed .modSigned).map KeygenZintCall.callShape
    =some (1,0,0,0) := by decide

theorem norm_zero_header : region 3539 2 = ["static void\n",
  "zint_norm_zero(uint32_t *restrict x, const uint32_t *restrict p, size_t len)\n"] := by decide
theorem norm_zero_close : Pinned.keygenLines[3559]?=some "}\n" := by decide
theorem norm_zero_audit : (KeygenZintCall.calleeParsed .normZero).map
    (KeygenZintCall.only (KeygenZintCall.writable .normZero))=some true := by decide
theorem norm_zero_shape : (KeygenZintCall.calleeParsed .normZero).map KeygenZintCall.callShape
    =some (1,0,0,2) := by decide

theorem exact_len_header : region 3640 2 = ["static size_t\n",
  "zint_exact_length(const uint32_t *x, size_t xlen)\n"] := by decide
theorem exact_len_close : Pinned.keygenLines[3649]?=some "}\n" := by decide
theorem exact_len_audit : (KeygenZintCall.calleeParsed .exactLen).map
    (KeygenZintCall.only (KeygenZintCall.writable .exactLen))=some true := by decide
theorem exact_len_shape : (KeygenZintCall.calleeParsed .exactLen).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide

theorem rshift_mod_header : region 3486 2 = ["static void\n",
  "zint_rshift1_mod(uint32_t *restrict x, const uint32_t *restrict p, size_t len)\n"] := by decide
theorem rshift_mod_close : Pinned.keygenLines[3497]?=some "}\n" := by decide
theorem rshift_mod_audit : (KeygenZintCall.calleeParsed .rshiftMod).map
    (KeygenZintCall.only (KeygenZintCall.writable .rshiftMod))=some true := by decide
theorem rshift_mod_shape : (KeygenZintCall.calleeParsed .rshiftMod).map KeygenZintCall.callShape
    =some (2,0,0,0) := by decide

theorem sub_mod_header : region 3503 3 = ["static void\n",
  "zint_sub_mod(uint32_t *restrict x, const uint32_t *restrict y,\n",
  "\tconst uint32_t *restrict p, size_t len)\n"] := by decide
theorem sub_mod_close : Pinned.keygenLines[3509]?=some "}\n" := by decide
theorem sub_mod_audit : (KeygenZintCall.calleeParsed .subMod).map
    (KeygenZintCall.only (KeygenZintCall.writable .subMod))=some true := by decide
theorem sub_mod_shape : (KeygenZintCall.calleeParsed .subMod).map KeygenZintCall.callShape
    =some (1,1,0,0) := by decide

theorem rebuild_crt_header : region 3576 4 = ["static void\n",
  "zint_rebuild_CRT(uint32_t *restrict xx, size_t xlen, size_t xstride,\n",
  "\tsize_t num, const small_prime *primes, int normalize_signed,\n",
  "\tuint32_t *restrict tmp)\n"] := by decide
theorem rebuild_crt_close : Pinned.keygenLines[3633]?=some "}\n" := by decide
/- The member-access tokenization rule (KeygenZintCall.tokens, trap 110)
   reaches the checked primeRead/storePrime productions, so the COMPLETE
   zint_rebuild_CRT body region 3581-3633 now parses: declarations, both
   loops, prime-struct reads, zint leaf calls, word-embedded modp calls
   (modp_ninv31/modp_R2/modp_montymul with nested modp_sub) and the
   normalization guard. The shape (4,0,3,0) counts the four zint-family call
   statements, no call-conditions and the three prime accesses; a silent
   word-fallback of any zint call site would lower these counts (trap 108). -/
theorem rebuild_crt_shape : (KeygenZintCall.calleeParsed .rebuildCrt).map KeygenZintCall.callShape
    =some (4,0,3,0) := by decide
theorem rebuild_crt_audit : (KeygenZintCall.calleeParsed .rebuildCrt).map
    (KeygenZintCall.only (KeygenZintCall.writable .rebuildCrt))=some true := by decide

theorem parsed_of (kind : Callee)
    (audit : (KeygenZintCall.calleeParsed kind).map (KeygenZintCall.only (KeygenZintCall.writable kind))=some true) :
    KeygenZintCall.calleeParsed kind=some (KeygenZintCall.calleeBody kind) := by
  cases hp : KeygenZintCall.calleeParsed kind with
  | none => simp only [hp,Option.map_none] at audit; cases audit
  | some p => simp only [KeygenZintCall.calleeBody,hp,Option.getD_some]

theorem checked_of (kind : Callee)
    (audit : (KeygenZintCall.calleeParsed kind).map (KeygenZintCall.only (KeygenZintCall.writable kind))=some true) :
    KeygenZintCall.only (KeygenZintCall.writable kind) (KeygenZintCall.calleeBody kind)=true := by
  have parsed := parsed_of kind audit
  rw [parsed] at audit
  exact Option.some.inj audit

theorem code_checked : ∀ kind : Callee,
    KeygenZintCall.only (KeygenZintCall.writable kind) (KeygenZintCall.calleeBody kind)=true := by
  intro kind
  cases kind with
  | leaf leaf => exact KeygenZintLeaves.code_checked leaf
  | modSigned => exact checked_of .modSigned mod_signed_audit
  | normZero => exact checked_of .normZero norm_zero_audit
  | exactLen => exact checked_of .exactLen exact_len_audit
  | rshiftMod => exact checked_of .rshiftMod rshift_mod_audit
  | subMod => exact checked_of .subMod sub_mod_audit
  | rebuildCrt => exact checked_of .rebuildCrt rebuild_crt_audit

theorem material (kind : Callee) (before after : State) (args : List Arg) (v : Option Value)
    (source : KeygenZintCall.Call kind before args after v) (names : List Name)
    (allowed : C99PointerFootprint.arguments names (KeygenZintCall.writable kind)
      (KeygenZintCall.params kind) args=true)
    (input : ArrayPointer) (separate : ∀ name∈names, ∀ p, before.arrays name=some p → p.block≠input.block)
    (tables : ∀ name p, before.tables name=some p → p.block≠input.block)
    (vector : Geometry.Vec) (represented : KeygenMaterial.Represents before.heap input vector) :
    KeygenMaterial.Represents after.heap input vector := by
  have keep (offset : Nat) : after.heap.bytes input.block offset=before.heap.bytes input.block offset := by
    apply KeygenZintCall.call_frame kind before after args v source names input.block offset allowed
      code_checked
    · intro name member p hp
      exact Or.inl (Ne.symm (separate name member p hp))
    · intro name p hp
      exact Or.inl (Ne.symm (tables name p hp))
  intro i
  constructor
  · intro byte; exact (keep _).trans ((represented i).1 byte)
  · intro byte; exact (keep _).trans ((represented i).2 byte)

end FT1536.Source3.KeygenZintCore
