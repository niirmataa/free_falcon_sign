import ProducerCoreView020E6

set_option maxRecDepth 8192
namespace FT1536.S05.ProducerWindow020E6
open ProducerScalar020E6 ProducerCoreView020E6

/-- Runtime inputs for the scalar circuit are fetched by closed expressions;
    there is no precomputed action/metadata supplied by a host function. -/
def top := pred sp
def topTag := frameAt top 0
def topPC := frameAt top 1
def topCount := frameAt top 2

def scanFirst := nodeAt cursor 2
def scanSecond := nodeAt cursor 3

def scanValue (p : E 7) : Optional 7 :=
  let v := valueAt p
  guarded (and (lt p cursor) v.present) v.value

def actFirst := nodeAt topPC 2
def actSecond := nodeAt topPC 3
def actThird := nodeAt topPC 4

def topPresent := not (eq sp (lit 0))
def scanPresent := and (lt cursor (lit 877)) (lt cursor used)
def actPresent := and topPresent (lt topPC used)
def scanGuarded (p : E 7) : Optional 7 :=
  let v := scanValue p
  guarded (and scanPresent v.present) v.value
def actGuarded (p : E 7) : Optional 7 :=
  let v := valueAt p
  guarded (and actPresent v.present) v.value

def cells (j : Fin 96) : E 7 :=
  if j.val<16 then control j.val else match j.val with
  | 16 => used
  | 17 => topPresent
  | 18 => choose topPresent topTag (lit 0)
  | 19 => choose topPresent topPC (lit 0)
  | 20 => choose topPresent topCount (lit 0)
  | 21 => choose scanPresent (nodeAt cursor 0) (lit 0)
  | 22 => choose scanPresent (nodeAt cursor 1) (lit 0)
  | 23 => choose scanPresent (scanFirst) (lit 0)
  | 24 => choose scanPresent (scanSecond) (lit 0)
  | 25 => choose scanPresent (nodeAt cursor 4) (lit 0)
  | 26 => (scanGuarded scanFirst).present
  | 27 => (scanGuarded scanFirst).value
  | 28 => (scanGuarded scanSecond).present
  | 29 => (scanGuarded scanSecond).value
  | 30 => choose (and scanPresent (and (eq (nodeAt cursor 0) (lit 1)) (lt (natClamp (nodeAt cursor 1)) (lit 32)))) (.load 0 (natClamp (nodeAt cursor 1))) (lit 0)
  | 31 => actPresent
  | 32 => choose actPresent (nodeAt topPC 0) (lit 0)
  | 33 => choose actPresent (nodeAt topPC 1) (lit 0)
  | 34 => choose actPresent (actFirst) (lit 0)
  | 35 => choose actPresent (actSecond) (lit 0)
  | 36 => choose actPresent (actThird) (lit 0)
  | 37 => (actGuarded actFirst).present
  | 38 => (actGuarded actFirst).value
  | 39 => (actGuarded actSecond).present
  | 40 => (actGuarded actSecond).value
  | 41 => (actGuarded actThird).present
  | 42 => (actGuarded actThird).value
  | 43 => choose (and (actGuarded actFirst).present (validAddress WordRAM020.ramSize (actGuarded actFirst).value)) (.load 0 (add (lit ramBase) (actGuarded actFirst).value)) (lit 0)
  | 44 => choose (and (actGuarded actFirst).present (validAddress WordRAM020.romSize (actGuarded actFirst).value)) (.load 3 (actGuarded actFirst).value) (lit 0)
  | 45 => choose (and (actGuarded actFirst).present (validAddress WordRAM020.tapeSize (actGuarded actFirst).value)) (.load 2 (actGuarded actFirst).value) (lit 0)
  | 46 => scanPresent
  | _ => lit 0

theorem workspace : ∀ j,ProducerExpr020E6.need (cells j)≤64 := by decide +kernel

end FT1536.S05.ProducerWindow020E6
