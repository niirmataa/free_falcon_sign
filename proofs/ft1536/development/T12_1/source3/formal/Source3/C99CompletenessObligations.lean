import Source3.C99Frontend
import Source3.C99MemoryBridge
import Source3.C99ArithmeticBridge
import Source3.C99BitwiseBridge
import Source3.C99ShiftBridge
import Source3.C99UnaryBridge
import Source3.HelperAllTotal

/- Explicit remaining proof obligations, not axioms, hypotheses of the
   A-outcome, or instances of reference execution. Compiling a Prop here
   is NOT a proof of it. -/
namespace FT1536.Source3.C99CompletenessObligations

def HeaderCompleteness : Prop :=
  ∀ (name : B20.C.Name) (args : List B20.C.Val) (z : B20.C.Val),
    name ∈ [['F','P','R'],['f','p','r','_','u','l','s','h'],['f','p','r','_','u','r','s','h']] →
    C99Frontend.headerCalls name (args.map C99ValueBridge.value) (C99ValueBridge.value z) →
    FprPrimitives.headerCalls name args=some z

def PrimitiveCompleteness : Prop :=
  ∀ (name : B20.C.Name) (x y z : BitVec 64),
    name ∈ [['f','p','r','_','a','d','d'],['f','p','r','_','m','u','l'],['f','p','r','_','d','i','v']] →
    C99Frontend.primitiveCall name [.uint64 x,.uint64 y] (.uint64 z) →
    (if name=['f','p','r','_','a','d','d'] then FprPrimitives.add x y
     else if name=['f','p','r','_','m','u','l'] then FprPrimitives.mul x y
     else FprPrimitives.div x y)=some z

/- The pointer-taking helper's independent reference control relation is
   not defined by any existing interpreter's `some`. Building that judgment
   (including side-effecting stable-positive calls and their argument-order
   proof) and then proving its completeness remains an additional obligation.
   No placeholder C99Exec relation is introduced to fabricate that result. -/

end FT1536.Source3.C99CompletenessObligations

#check FT1536.Source3.C99CompletenessObligations.HeaderCompleteness
#check FT1536.Source3.C99CompletenessObligations.PrimitiveCompleteness
