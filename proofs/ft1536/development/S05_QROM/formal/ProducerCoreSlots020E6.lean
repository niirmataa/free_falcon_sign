import ProducerCoreCircuit020E6

set_option maxRecDepth 32768
namespace FT1536.S05.ProducerCoreSlots020E6
open ProducerScalar020E6 ProducerCoreCircuit020E6

def valueStep := and (or (isPhase 1) (isPhase 2)) (lt (w 1) (lit 877))
def actStore := and (isPhase 3) (and actionOK (not (lt editTag (lit 2))))
def pushStore := and (isPhase 4) (and pendingPresent pushRoom)

def dataPresent (slot : Nat) : C := or (and valueStep (if slot<2 then lit 1 else lit 0))
  (or (and actStore (if slot=0 then lit 1 else lit 0)) pushStore)

def dataAddress (slot : Nat) : C :=
  choose valueStep (add (lit (142152+slot)) (mul (lit 2) (w 1)))
  (choose actStore (add editAddress (choose (eq editTag (lit 2)) (lit 0) (choose (eq editTag (lit 3)) (lit 32) (lit 4640))))
    (add (lit (55329+slot)) (mul (lit 3) (w 3))))

def dataValue (slot : Nat) : C :=
  choose valueStep (choose (isPhase 1) (lit 0) (if slot=0 then scanPresent else scanValue))
    (choose actStore editValue (choose pendingTwo (w (12+slot)) (w (6+slot))))

/-- Slots0..2 are fixed optional data writes;3..18 are control writes.
    Inactive slots are explicitly three zero words. No list is constructed
    during execution. -/
def cells (j : Fin 96) : C :=
  let slot := j.val/3
  let field := j.val%3
  if slot<3 then
    choose (dataPresent slot) (match field with | 0 => lit 1 | 1 => dataAddress slot | _ => dataValue slot) (lit 0)
  else if slot<19 then
    match field with | 0 => lit 1 | 1 => lit (143906+(slot-3)) | _ => nextMeta (slot-3)
  else lit 0

theorem workspace : ∀ j,ProducerExpr020E6.need (cells j)≤64 := by decide +kernel

end FT1536.S05.ProducerCoreSlots020E6
