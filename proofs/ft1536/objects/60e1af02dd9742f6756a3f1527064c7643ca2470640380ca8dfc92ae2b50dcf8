import B20.Fpr.Spec
import B20.Fpr.FloorExec

namespace B20.Fpr

open B20.C.Scalar
open B20.C (Name Val Ty BinOp)

/-- Uniform primitive-call obligation interface: the exact pinned call
evaluates to the claimed value. Shift callees discharge this through
`ulsh_call_of_toNat` and friends once the caller proves the count domain;
`fpr_add/mul/div/sqrt` obligations are currently assumed (no instances). -/
structure PrimObligation (fn : Name) (args : List Val) (res : Val) : Prop where
  eval : shiftCalls fn args = some res

/-- The only side condition of the three shift helpers: count `< 64`. -/
def ShiftCountDomain (c : BitVec 32) : Prop := c.toNat < 64

/-- Named caller domains per callee (definitionally the count bound). -/
def UlshDomain (m : BitVec 64) (c : BitVec 32) : Prop := ShiftCountDomain c
def UrshDomain (m : BitVec 64) (c : BitVec 32) : Prop := ShiftCountDomain c
def IrshDomain (a : BitVec 64) (c : BitVec 32) : Prop := ShiftCountDomain c

/-- `fpr_rint` S5 (`fpr_ulsh(m, 63-e)`): proved from the caller's `e2` range.
Premise is the current `he2int`, not any historical mixed proof. -/
theorem rint_ulsh_domain (x : BitVec 64)
    (he2 : 0 ≤ (rint_e2 x).toInt ∧ (rint_e2 x).toInt ≤ 63) :
    UlshDomain (rint_m1 x) (63#32 - rint_e2 x) :=
  rint_sub63_count _ he2

/-- `fpr_rint` S8 (`fpr_ursh(m, e)`): unconditional (`e &&& 63 < 64`). -/
theorem rint_ursh_domain (x : BitVec 64) : UrshDomain (rint_m1 x) (rint_e2 x) := by
  simpa [UrshDomain, ShiftCountDomain, rint_e2] using (rint_e2_range (rint_e x)).1

/-- `fpr_floor` S9 (`fpr_irsh(xi, cc &&& 63)`): unconditional, same count. -/
theorem floor_irsh_domain (x : BitVec 64) : IrshDomain (floor_xi0 x) (rint_e2 x) := by
  simpa [IrshDomain, ShiftCountDomain, rint_e2] using (rint_e2_range (rint_e x)).1

/-- Exact unresolved obligation types with pinned call shapes
(`typedef uint64_t fpr`, header lines 16,58–60). No instances are proved:
`fpr_add` is assumed by `sub`, `mul/div/sqrt` have no parsed call sites. -/
def AddCallObligation (x y w : BitVec 64) : Prop :=
  PrimObligation "fpr_add".toList [.u64 x, .u64 y] (.u64 w)

def MulObligation (x y w : BitVec 64) : Prop :=
  PrimObligation "fpr_mul".toList [.u64 x, .u64 y] (.u64 w)

def DivObligation (x y w : BitVec 64) : Prop :=
  PrimObligation "fpr_div".toList [.u64 x, .u64 y] (.u64 w)

def SqrtObligation (x w : BitVec 64) : Prop :=
  PrimObligation "fpr_sqrt".toList [.u64 x] (.u64 w)

/-- `fpr_sub` consumes the add obligation: the historical conditional
`sub_execution` restated through the interface (proved, no new axioms). -/
theorem sub_refines_via_add_obligation (x y w : BitVec 64)
    (h : AddCallObligation x (y ^^^ ((1 : BitVec 64) <<< 63)) w) :
    B20.C.Scalar.execute shiftCalls Parsed.subProgram [.u64 x, .u64 y] =
      some (.u64 w) :=
  sub_execution shiftCalls x y w h.eval

/-- Caller → callee registry for the four parsed call sites. -/
def parsedCallSites : List (Name × Name) :=
  [("fpr_rint".toList, "fpr_ulsh".toList),
   ("fpr_rint".toList, "fpr_ursh".toList),
   ("fpr_floor".toList, "fpr_irsh".toList),
   ("fpr_sub".toList, "fpr_add".toList)]

end B20.Fpr
