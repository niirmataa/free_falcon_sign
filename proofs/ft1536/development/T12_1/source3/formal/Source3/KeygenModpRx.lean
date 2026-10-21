import Source3.C99ModularAnnotation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source binding for the composite modular callee modp_Rx of the
   make_fg_step additional-prime section (the `Rx = modp_Rx(slen, p,
   p0i, R2)` statement, region pinning in the KeygenMkgm3Callees form).
   The hand-built statement rxCode mirrors the pinned source body
   byte-for-byte structure and is checked against the pinned source
   parse below; that equality is its source binding.

   WALL recorded (księga pułapek, do not re-derive): the canonical
   `C99ModularReference.Exec` (= GenExec ModCall) cannot execute the
   call4 `modp_Rx` statement — the closed ModCall stratum covers
   modp_montymul/modp_add/modp_sub/modp_ninv31/modp_set/modp_R/modp_R2/
   modp_div only, and KeygenMakeFgSource.Exec/KeygenLevelExec.Exec/
   KeygenWordExec.Exec all fix that relation. Closing the additional-
   prime part therefore needs a ModCall extension in the PINNED source
   formal/Source3/C99ModularReference.lean (the exact B1.03 precedent of
   the r2/div constructors: rxParams/rxCode/rxBody plus
   `| rx (args out) (body : rxBody args out) : ModCall "modp_Rx" args
   out`), which is an owner decision because that file is in the
   inherited pin set. This module is the ready plug: the transcription
   and the source binding move verbatim into that edit. No execution or
   numerical property is claimed here. -/
namespace FT1536.Source3.KeygenModpRx
open C99ModularReference (Expr Stmt)

def cell (name : String) : Expr := .scalar (.var name.toList)

def rxParams : List (B20.C.Ty×B20.C.Name) :=
  [(.u32,"x".toList),(.u32,"p".toList),(.u32,"p0i".toList),(.u32,"R2".toList)]

/- Original loop shapes: the guard `(1U << i) <= x` and the inner test
   `(x & (1U << i)) != 0`; the literal 1U parses as .u32 1. -/
def shiftI : CLogic.Expr := .bin .shl (.literal .u32 1) (.var "i".toList)
def loopGuard : CLogic.Expr := .cmp .le shiftI (.var "x".toList)
def branchGuard : CLogic.Expr := .cmp .ne (.bin .band (.var "x".toList) shiftI) (.literal .i32 0)

def zMont : Expr := .call4 "modp_montymul".toList (cell "z") (cell "r") (cell "p") (cell "p0i")
def rMont : Expr := .call4 "modp_montymul".toList (cell "r") (cell "r") (cell "p") (cell "p0i")

def zAssign : Stmt := .assign "z".toList zMont
def rAssign : Stmt := .assign "r".toList rMont
def ifBody : Stmt := .scope [] (C99ModularReference.chainOf [zAssign])
def ifStep : Stmt := .branch branchGuard ifBody (.base .skip)
def loopBody : Stmt := .scope [] (C99ModularReference.chainOf [ifStep,rAssign])
def loopStep : Stmt := .base (.scalar (.update "i".toList .add (.literal .i32 1)))
def loop : Stmt := .seq (.assign "i".toList (.scalar (.literal .i32 0)))
  (.loop loopGuard loopBody loopStep)

def rxCode : Stmt := C99ModularReference.chainOf [
  .base (.scalar (.declare .i32 ["i".toList])),
  .base (.scalar (.declare .u32 ["r".toList,"z".toList])),
  .base (.scalar (.update "x".toList .sub (.literal .i32 1))),
  .assign "r".toList (cell "R2"),
  .assign "z".toList (.call1 "modp_R".toList (cell "p")),
  loop,
  .ret (cell "z")]

theorem rx_header :
    Pinned.keygenLines[2606]?=some "modp_Rx(unsigned x, uint32_t p, uint32_t p0i, uint32_t R2)\n" := by
  decide

theorem rx_source_bound : C99ModularParser.region 2609 18=some rxCode := by decide

end FT1536.Source3.KeygenModpRx
