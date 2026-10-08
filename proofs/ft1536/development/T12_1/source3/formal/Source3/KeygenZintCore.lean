import Source3.KeygenZintCall
import Source3.KeygenMaterial

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Source bindings of the signed/reduction/CRT bigint closure used by
   make_fg_step and zint_bezout: zint_mod_small_signed, zint_norm_zero,
   zint_exact_length, zint_rshift1_mod, zint_sub_mod, the complete
   zint_rebuild_CRT body and the co-reduce/reduce family (zint_co_reduce,
   zint_co_reduce_mod, zint_reduce, zint_reduce_mod). Every callee executes
   its pinned body; the
   seven sealed leaves are shared through KeygenZintLeaves. These are
   operational/frame results: no CRT correctness, normalization,
   reduction or Bezout claim is made here. -/
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

/- Co-reduce/reduce family used by zint_bezout. The bodies exercise the
   same-width `*(T*)&local` bitcasts (zint_co_reduce, zint_reduce and both
   mod variants) and the `#define M`/`#undef M` macro scope with token
   substitution (zint_co_reduce_mod). These are operational/frame results:
   no Bezout, reduction or Montgomery claim is made here. -/
theorem co_reduce_header : region 3666 3 = ["static int\n",
  "zint_co_reduce(uint32_t *a, uint32_t *b, size_t len,\n",
  "\tint32_t xa, int32_t xb, int32_t ya, int32_t yb)\n"] := by decide
theorem co_reduce_close : Pinned.keygenLines[3724]?=some "}\n" := by decide
theorem co_reduce_audit : (KeygenZintCall.calleeParsed .coReduce).map
    (KeygenZintCall.only (KeygenZintCall.writable .coReduce))=some true := by decide
theorem co_reduce_shape : (KeygenZintCall.calleeParsed .coReduce).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide
theorem co_reduce_bitcasts : (KeygenZintCall.calleeParsed .coReduce).map KeygenZintCall.bitcastCount
    =some 2 := by decide

theorem co_reduce_mod_header : region 3731 3 = ["static void\n",
  "zint_co_reduce_mod(uint32_t *a, uint32_t *b, const uint32_t *m, size_t len,\n",
  "\tuint32_t m0i, int32_t xa, int32_t xb, int32_t ya, int32_t yb)\n"] := by decide
theorem co_reduce_mod_close : Pinned.keygenLines[3801]?=some "}\n" := by decide
theorem co_reduce_mod_audit : (KeygenZintCall.calleeParsed .coReduceMod).map
    (KeygenZintCall.only (KeygenZintCall.writable .coReduceMod))=some true := by decide
theorem co_reduce_mod_shape : (KeygenZintCall.calleeParsed .coReduceMod).map KeygenZintCall.callShape
    =some (4,2,0,0) := by decide
theorem co_reduce_mod_bitcasts : (KeygenZintCall.calleeParsed .coReduceMod).map
    KeygenZintCall.bitcastCount =some 2 := by decide

theorem reduce_k_header : region 3808 2 = ["static int\n",
  "zint_reduce(uint32_t *a, const uint32_t *b, size_t len, int32_t k)\n"] := by decide
theorem reduce_k_close : Pinned.keygenLines[3844]?=some "}\n" := by decide
theorem reduce_k_audit : (KeygenZintCall.calleeParsed .reduce).map
    (KeygenZintCall.only (KeygenZintCall.writable .reduce))=some true := by decide
theorem reduce_k_shape : (KeygenZintCall.calleeParsed .reduce).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide
theorem reduce_k_bitcasts : (KeygenZintCall.calleeParsed .reduce).map KeygenZintCall.bitcastCount
    =some 1 := by decide

theorem reduce_mod_header : region 3851 3 = ["static void\n",
  "zint_reduce_mod(uint32_t *a, const uint32_t *b, const uint32_t *m,\n",
  "\tsize_t len, uint32_t m0i, int32_t k)\n"] := by decide
theorem reduce_mod_close : Pinned.keygenLines[3888]?=some "}\n" := by decide
theorem reduce_mod_audit : (KeygenZintCall.calleeParsed .reduceMod).map
    (KeygenZintCall.only (KeygenZintCall.writable .reduceMod))=some true := by decide
theorem reduce_mod_shape : (KeygenZintCall.calleeParsed .reduceMod).map KeygenZintCall.callShape
    =some (2,1,0,0) := by decide
theorem reduce_mod_bitcasts : (KeygenZintCall.calleeParsed .reduceMod).map
    KeygenZintCall.bitcastCount =some 1 := by decide

/- Complete zint_bezout body region 3909-4200 (keygenLines body indices
   3908-4198, closing brace index 4199), source-bound in eight
   statement-boundary pieces (KeygenZintCall.bezoutParsed) with the chained
   scaffold `bezoutCode` as the executed body. The window's new grammar
   executes: ternary `?:` assignments lowered to explicit
   branch-of-assignment, memcpy through the sealed byte-copy statement and
   memset through the Memzero zero-byte rule (both with `sizeof *element`
   width-4 limb lowering), `for (;;)` with `continue` loop flow, the
   six-pointer walk declaration with statement-position pointer binds (the
   for-clause binds keep their ending token for `clauses`), `size_t` scalar
   declarations and the `v1[0] &= ~(uint32_t)1` compound store. Its six
   `*(int32_t*)&ux*` pun statements reuse the committed bitcast rule. The
   shape pins (28,2,0,0) count every family call site (the two
   `if (zint_reduce(...))` conditions and all four reduce/reduce_mod/
   co_reduce/co_reduce_mod members included), so no zint call can silently
   fall through to the word grammar (trap 108). The line partition binds
   the pieces to the pinned bytes. These are operational/frame results
   only: no Bezout identity, GCD, parity, range or termination claim. -/
theorem bezout_header : region 3904 4 = ["static int\n",
  "zint_bezout(uint32_t *restrict u, uint32_t *restrict v,\n",
  "\tconst uint32_t *restrict x, const uint32_t *restrict y,\n",
  "\tsize_t len, uint32_t *restrict tmp)\n"] := by decide
theorem bezout_close : Pinned.keygenLines[4199]?=some "}\n" := by decide
theorem bezout_partition : region 3909 291 =
    region 3909 4 ++ region 3913 33 ++ region 3946 7 ++ region 3953 9 ++
    region 3962 17 ++ region 3979 15 ++ region 3994 21 ++ region 4015 185 := by decide

/- Per-piece non-vacuous audits (Depth0 pattern): the `map ... = some`
   statements prove each piece parse SUCCEEDS (a failed parse maps to none),
   so the shape/bitcast values below cannot be the `skip` fallback. -/
def bezoutAudit (index : Nat) : Option Bool :=
  (KeygenZintCall.bezoutParsed index).map (KeygenZintCall.only (KeygenZintCall.writable .bezout))
theorem bezout_audit0 : bezoutAudit 0=some true := by decide
theorem bezout_audit1 : bezoutAudit 1=some true := by decide
theorem bezout_audit2 : bezoutAudit 2=some true := by decide
theorem bezout_audit3 : bezoutAudit 3=some true := by decide
theorem bezout_audit4 : bezoutAudit 4=some true := by decide
theorem bezout_audit5 : bezoutAudit 5=some true := by decide
theorem bezout_audit6 : bezoutAudit 6=some true := by decide
theorem bezout_audit7 : bezoutAudit 7=some true := by decide

theorem bezout_parsed_part (index : Nat) (h : bezoutAudit index=some true) :
    KeygenZintCall.bezoutParsed index=some (KeygenZintCall.bezoutPart index) := by
  cases hp : KeygenZintCall.bezoutParsed index with
  | none => simp only [bezoutAudit,hp,Option.map_none] at h; cases h
  | some p => simp only [KeygenZintCall.bezoutPart,hp,Option.getD_some]

theorem bezout_part_checked (index : Nat) (h : bezoutAudit index=some true) :
    KeygenZintCall.only (KeygenZintCall.writable .bezout) (KeygenZintCall.bezoutPart index)=true := by
  have parsed := bezout_parsed_part index h
  simp only [bezoutAudit,parsed,Option.map_some,Option.some.injEq] at h
  exact h

theorem bezout_part0_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (KeygenZintCall.bezoutPart 0)=true := bezout_part_checked 0 bezout_audit0
theorem bezout_part1_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (KeygenZintCall.bezoutPart 1)=true := bezout_part_checked 1 bezout_audit1
theorem bezout_part2_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (KeygenZintCall.bezoutPart 2)=true := bezout_part_checked 2 bezout_audit2
theorem bezout_part3_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (KeygenZintCall.bezoutPart 3)=true := bezout_part_checked 3 bezout_audit3
theorem bezout_part4_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (KeygenZintCall.bezoutPart 4)=true := bezout_part_checked 4 bezout_audit4
theorem bezout_part5_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (KeygenZintCall.bezoutPart 5)=true := bezout_part_checked 5 bezout_audit5
theorem bezout_part6_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (KeygenZintCall.bezoutPart 6)=true := bezout_part_checked 6 bezout_audit6
theorem bezout_part7_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (KeygenZintCall.bezoutPart 7)=true := bezout_part_checked 7 bezout_audit7

theorem bezout_part_shape (index : Nat) {v : Nat×Nat×Nat×Nat}
    (ha : bezoutAudit index=some true)
    (hs : (KeygenZintCall.bezoutParsed index).map KeygenZintCall.callShape=some v) :
    KeygenZintCall.callShape (KeygenZintCall.bezoutPart index)=v := by
  have parsed := bezout_parsed_part index ha
  have both : (KeygenZintCall.bezoutParsed index).map KeygenZintCall.callShape
      = (some (KeygenZintCall.bezoutPart index)).map KeygenZintCall.callShape :=
    congrArg (Option.map KeygenZintCall.callShape) parsed
  have rhs : (some (KeygenZintCall.bezoutPart index)).map KeygenZintCall.callShape
      = some (KeygenZintCall.callShape (KeygenZintCall.bezoutPart index)) := rfl
  exact Option.some.inj (((both.trans rhs).symm).trans hs)

theorem bezout_part_bits (index : Nat) {v : Nat} (ha : bezoutAudit index=some true)
    (hs : (KeygenZintCall.bezoutParsed index).map KeygenZintCall.bitcastCount=some v) :
    KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart index)=v := by
  have parsed := bezout_parsed_part index ha
  have both : (KeygenZintCall.bezoutParsed index).map KeygenZintCall.bitcastCount
      = (some (KeygenZintCall.bezoutPart index)).map KeygenZintCall.bitcastCount :=
    congrArg (Option.map KeygenZintCall.bitcastCount) parsed
  have rhs : (some (KeygenZintCall.bezoutPart index)).map KeygenZintCall.bitcastCount
      = some (KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart index)) := rfl
  exact Option.some.inj (((both.trans rhs).symm).trans hs)

theorem bezout_shape0_raw : (KeygenZintCall.bezoutParsed 0).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide
theorem bezout_shape1_raw : (KeygenZintCall.bezoutParsed 1).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide
theorem bezout_shape2_raw : (KeygenZintCall.bezoutParsed 2).map KeygenZintCall.callShape
    =some (2,0,0,0) := by decide
theorem bezout_shape3_raw : (KeygenZintCall.bezoutParsed 3).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide
theorem bezout_shape4_raw : (KeygenZintCall.bezoutParsed 4).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide
theorem bezout_shape5_raw : (KeygenZintCall.bezoutParsed 5).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide
theorem bezout_shape6_raw : (KeygenZintCall.bezoutParsed 6).map KeygenZintCall.callShape
    =some (0,0,0,0) := by decide
theorem bezout_shape7_raw : (KeygenZintCall.bezoutParsed 7).map KeygenZintCall.callShape
    =some (26,2,0,0) := by decide

theorem bezout_bits0_raw : (KeygenZintCall.bezoutParsed 0).map KeygenZintCall.bitcastCount
    =some 0 := by decide
theorem bezout_bits1_raw : (KeygenZintCall.bezoutParsed 1).map KeygenZintCall.bitcastCount
    =some 0 := by decide
theorem bezout_bits2_raw : (KeygenZintCall.bezoutParsed 2).map KeygenZintCall.bitcastCount
    =some 0 := by decide
theorem bezout_bits3_raw : (KeygenZintCall.bezoutParsed 3).map KeygenZintCall.bitcastCount
    =some 0 := by decide
theorem bezout_bits4_raw : (KeygenZintCall.bezoutParsed 4).map KeygenZintCall.bitcastCount
    =some 0 := by decide
theorem bezout_bits5_raw : (KeygenZintCall.bezoutParsed 5).map KeygenZintCall.bitcastCount
    =some 0 := by decide
theorem bezout_bits6_raw : (KeygenZintCall.bezoutParsed 6).map KeygenZintCall.bitcastCount
    =some 0 := by decide
theorem bezout_bits7_raw : (KeygenZintCall.bezoutParsed 7).map KeygenZintCall.bitcastCount
    =some 6 := by decide

theorem bezout_part0_shape : KeygenZintCall.callShape (KeygenZintCall.bezoutPart 0)=(0,0,0,0) :=
  bezout_part_shape 0 bezout_audit0 bezout_shape0_raw
theorem bezout_part1_shape : KeygenZintCall.callShape (KeygenZintCall.bezoutPart 1)=(0,0,0,0) :=
  bezout_part_shape 1 bezout_audit1 bezout_shape1_raw
theorem bezout_part2_shape : KeygenZintCall.callShape (KeygenZintCall.bezoutPart 2)=(2,0,0,0) :=
  bezout_part_shape 2 bezout_audit2 bezout_shape2_raw
theorem bezout_part3_shape : KeygenZintCall.callShape (KeygenZintCall.bezoutPart 3)=(0,0,0,0) :=
  bezout_part_shape 3 bezout_audit3 bezout_shape3_raw
theorem bezout_part4_shape : KeygenZintCall.callShape (KeygenZintCall.bezoutPart 4)=(0,0,0,0) :=
  bezout_part_shape 4 bezout_audit4 bezout_shape4_raw
theorem bezout_part5_shape : KeygenZintCall.callShape (KeygenZintCall.bezoutPart 5)=(0,0,0,0) :=
  bezout_part_shape 5 bezout_audit5 bezout_shape5_raw
theorem bezout_part6_shape : KeygenZintCall.callShape (KeygenZintCall.bezoutPart 6)=(0,0,0,0) :=
  bezout_part_shape 6 bezout_audit6 bezout_shape6_raw
theorem bezout_part7_shape : KeygenZintCall.callShape (KeygenZintCall.bezoutPart 7)=(26,2,0,0) :=
  bezout_part_shape 7 bezout_audit7 bezout_shape7_raw

theorem bezout_part0_bits : KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart 0)=0 :=
  bezout_part_bits 0 bezout_audit0 bezout_bits0_raw
theorem bezout_part1_bits : KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart 1)=0 :=
  bezout_part_bits 1 bezout_audit1 bezout_bits1_raw
theorem bezout_part2_bits : KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart 2)=0 :=
  bezout_part_bits 2 bezout_audit2 bezout_bits2_raw
theorem bezout_part3_bits : KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart 3)=0 :=
  bezout_part_bits 3 bezout_audit3 bezout_bits3_raw
theorem bezout_part4_bits : KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart 4)=0 :=
  bezout_part_bits 4 bezout_audit4 bezout_bits4_raw
theorem bezout_part5_bits : KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart 5)=0 :=
  bezout_part_bits 5 bezout_audit5 bezout_bits5_raw
theorem bezout_part6_bits : KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart 6)=0 :=
  bezout_part_bits 6 bezout_audit6 bezout_bits6_raw
theorem bezout_part7_bits : KeygenZintCall.bitcastCount (KeygenZintCall.bezoutPart 7)=6 :=
  bezout_part_bits 7 bezout_audit7 bezout_bits7_raw

theorem only_seq (names : List Name) (a b : KeygenZintCall.Stmt) :
    KeygenZintCall.only names (.seq a b)
      = (KeygenZintCall.only names a && KeygenZintCall.only names b) := rfl
theorem only_skip (names : List Name) : KeygenZintCall.only names KeygenZintCall.skip=true := rfl
theorem callShape_seq (a b : KeygenZintCall.Stmt) :
    KeygenZintCall.callShape (.seq a b)
      = KeygenZintCall.shapeAdd (KeygenZintCall.callShape a) (KeygenZintCall.callShape b) := rfl
theorem callShape_skip : KeygenZintCall.callShape KeygenZintCall.skip=(0,0,0,0) := rfl
theorem bitcastCount_seq (a b : KeygenZintCall.Stmt) :
    KeygenZintCall.bitcastCount (.seq a b)
      = KeygenZintCall.bitcastCount a + KeygenZintCall.bitcastCount b := rfl
theorem bitcastCount_skip : KeygenZintCall.bitcastCount KeygenZintCall.skip=0 := rfl

theorem bezout_code_checked : KeygenZintCall.only (KeygenZintCall.writable .bezout)
    KeygenZintCall.bezoutCode=true := by
  show KeygenZintCall.only (KeygenZintCall.writable .bezout)
    (.seq (KeygenZintCall.bezoutPart 0)
    (.seq (KeygenZintCall.bezoutPart 1)
    (.seq (KeygenZintCall.bezoutPart 2)
    (.seq (KeygenZintCall.bezoutPart 3)
    (.seq (KeygenZintCall.bezoutPart 4)
    (.seq (KeygenZintCall.bezoutPart 5)
    (.seq (KeygenZintCall.bezoutPart 6)
    (.seq (KeygenZintCall.bezoutPart 7) KeygenZintCall.skip))))))))=true
  rw [only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,only_seq,only_seq]
  rw [only_skip,bezout_part0_checked,bezout_part1_checked,bezout_part2_checked,
    bezout_part3_checked,bezout_part4_checked,bezout_part5_checked,
    bezout_part6_checked,bezout_part7_checked]
  decide

theorem bezout_shape_code : KeygenZintCall.callShape KeygenZintCall.bezoutCode=(28,2,0,0) := by
  show KeygenZintCall.callShape
    (.seq (KeygenZintCall.bezoutPart 0)
    (.seq (KeygenZintCall.bezoutPart 1)
    (.seq (KeygenZintCall.bezoutPart 2)
    (.seq (KeygenZintCall.bezoutPart 3)
    (.seq (KeygenZintCall.bezoutPart 4)
    (.seq (KeygenZintCall.bezoutPart 5)
    (.seq (KeygenZintCall.bezoutPart 6)
    (.seq (KeygenZintCall.bezoutPart 7) KeygenZintCall.skip))))))))=(28,2,0,0)
  rw [callShape_seq,callShape_seq,callShape_seq,callShape_seq,callShape_seq,
    callShape_seq,callShape_seq,callShape_seq]
  rw [callShape_skip,bezout_part0_shape,bezout_part1_shape,bezout_part2_shape,
    bezout_part3_shape,bezout_part4_shape,bezout_part5_shape,
    bezout_part6_shape,bezout_part7_shape]
  decide

theorem bezout_bitcasts_code : KeygenZintCall.bitcastCount KeygenZintCall.bezoutCode=6 := by
  show KeygenZintCall.bitcastCount
    (.seq (KeygenZintCall.bezoutPart 0)
    (.seq (KeygenZintCall.bezoutPart 1)
    (.seq (KeygenZintCall.bezoutPart 2)
    (.seq (KeygenZintCall.bezoutPart 3)
    (.seq (KeygenZintCall.bezoutPart 4)
    (.seq (KeygenZintCall.bezoutPart 5)
    (.seq (KeygenZintCall.bezoutPart 6)
    (.seq (KeygenZintCall.bezoutPart 7) KeygenZintCall.skip))))))))=6
  rw [bitcastCount_seq,bitcastCount_seq,bitcastCount_seq,bitcastCount_seq,
    bitcastCount_seq,bitcastCount_seq,bitcastCount_seq,bitcastCount_seq]
  rw [bitcastCount_skip,bezout_part0_bits,bezout_part1_bits,bezout_part2_bits,
    bezout_part3_bits,bezout_part4_bits,bezout_part5_bits,
    bezout_part6_bits,bezout_part7_bits]

theorem bezout_shape : (KeygenZintCall.calleeParsed .bezout).map KeygenZintCall.callShape
    =some (28,2,0,0) := congrArg some bezout_shape_code
theorem bezout_bitcasts : (KeygenZintCall.calleeParsed .bezout).map KeygenZintCall.bitcastCount
    =some 6 := congrArg some bezout_bitcasts_code
theorem bezout_audit : (KeygenZintCall.calleeParsed .bezout).map
    (KeygenZintCall.only (KeygenZintCall.writable .bezout))=some true :=
  congrArg some bezout_code_checked

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
  | coReduce => exact checked_of .coReduce co_reduce_audit
  | coReduceMod => exact checked_of .coReduceMod co_reduce_mod_audit
  | reduce => exact checked_of .reduce reduce_k_audit
  | reduceMod => exact checked_of .reduceMod reduce_mod_audit
  | bezout => exact checked_of .bezout bezout_audit

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
