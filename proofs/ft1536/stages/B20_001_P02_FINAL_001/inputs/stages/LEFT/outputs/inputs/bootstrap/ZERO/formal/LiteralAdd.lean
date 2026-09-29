import EndpointFacts
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace ZeroScalar
-- Source-normalized integer machine, NOT ideal/RN addition. The masks are
-- reduced to their two branches using their proved0/1 domains; sticky,
-- normalize, and pack keep the actual source operations.
def addMant (x : Word) : Nat := 8*(frac x+if ex x=0 then 0 else 4503599627370496)
def magBits (x : Word) : Nat := x.val%9223372036854775808
def zeroWord (s : Bool) : Word := ⟨if s then 9223372036854775808 else 0,by cases s <;> decide⟩
def addC (x y : Word) : Word :=
  let swap:=magBits x<magBits y ∨ (magBits x=magBits y ∧ sg x=true)
  let a:=if swap then y else x
  let b:=if swap then x else y
  let gap:=ex a-ex b
  let aligned:=if gap<60 then sticky (addMant b) gap else 0
  let t:=if sg a=sg b then addMant a+aligned else addMant a-aligned
  let ns:=norm64 t
  let m:=sticky ns.1 9
  if t=0 ∨ ex a+7<ns.2 then zeroWord (sg a)
  else packNormal (sg a) (ex a+7-ns.2) (roundMant m)
def negC (x : Word) : Word := ⟨x.val ^^^ 9223372036854775808,Nat.xor_lt_two_pow (n:=64) x.isLt (by decide)⟩
def subC (x y : Word) : Word := addC x (negC y)
def rC (x : Word) : Word := subC x (ofC (floorC x))
def resC (x : Word) (z : Int) : Word := subC x (ofC (floorC x+z))
def deltaC (x : Word) : Word := subC (ofC 1) (rC x)
def finiteWord (x : Word) : Prop := ex x<2047

-- Exact proposition types proved analytically in ANALYTIC_PROOF.md §§2–6.
-- They are definitions, not axioms or kernel declarations of the conclusions.
def SUB_CENTER_CONTRACT (x : Word) : Prop :=
  finiteWord (rC x) ∧ H3Range.Between (valueNum (rC x)-rhoNum x) Eunits
def SUB_RESIDUAL_CONTRACT (x : Word) (z : Int) : Prop :=
  finiteWord (resC x z) ∧ H3Range.Between (valueNum (resC x z)-(valueNum x-D*(floorC x+z))) Eunits
def R_DELTA_DOMAIN (x : Word) : Prop :=
  0≤valueNum (rC x) ∧ valueNum (rC x)≤D ∧ sg (rC x)=false ∧
  0≤valueNum (deltaC x) ∧ valueNum (deltaC x)≤D ∧ sg (deltaC x)=false

theorem zero_raw_endpoints :
    (rC plusZero).val=0 ∧ (rC minusZero).val=4607182418800017408 ∧
    (deltaC plusZero).val=4607182418800017408 ∧ (deltaC minusZero).val=0 ∧
    (resC minusZero 1).val=9223372036854775808 := by decide
theorem endpoint_one_not_exclusive :
    (rC ⟨9223372036854775809,by decide⟩).val=4607182418800017408 := by decide

theorem CONSUME_SUB_RESIDUAL (x : Word) (hx : NumericCenter x) (z : Int) (hz : -365≤z ∧ z≤366)
    (analytic_contract : SUB_RESIDUAL_CONTRACT x z) :
    finiteWord (resC x z) ∧ H3Range.Between (valueNum (resC x z)) (366*D+Eunits) :=
  ⟨analytic_contract.1,MACHINE_RESIDUAL_366 x hx z _ hz analytic_contract.2⟩

#check @SUB_CENTER_CONTRACT
#check @SUB_RESIDUAL_CONTRACT
#check @R_DELTA_DOMAIN
#check @CONSUME_SUB_RESIDUAL
#print axioms zero_raw_endpoints
#print axioms endpoint_one_not_exclusive
#print axioms CONSUME_SUB_RESIDUAL
end ZeroScalar
