import ProducerScalar020E6

set_option maxRecDepth 16384
namespace FT1536.S05.ProducerCoreCircuit020E6
open WordRAM020 ProducerScalar020E6

abbrev C := E 1
def w (j : Nat) : C := cell 0 j
def isPhase (p : Nat) := eq (w 0) (lit p)
def isToken (t : Nat) := eq (w 32) (lit t)
def payloadNat := natClamp (w 33)
def isAgain := eq (w 18) (lit 1)
def remaining := choose isAgain (w 20) payloadNat

def binaryResult (opcode x y : C) : C :=
  choose (eq opcode (lit 0)) (.binary .add x y)
  (choose (eq opcode (lit 1)) (.binary .sub x y)
  (choose (eq opcode (lit 2)) (.binary .mul x y)
  (choose (eq opcode (lit 3)) (.binary .div x y)
  (choose (eq opcode (lit 4)) (.binary .mod x y)
  (choose (eq opcode (lit 5)) (.binary .lt x y) (.binary .eq x y))))))

def scanPresent := and (w 46)
  (or (eq (w 21) (lit 0)) (or (and (eq (w 21) (lit 1)) (lt (natClamp (w 22)) (lit 32)))
    (and (eq (w 21) (lit 2)) (and (lt (natClamp (w 22)) (lit 7)) (and (w 26) (w 28))))))
def scanValue := choose scanPresent
  (choose (eq (w 21) (lit 0)) (w 22) (choose (eq (w 21) (lit 1)) (w 30) (binaryResult (natClamp (w 22)) (w 29) (w 27)))) (lit 0)

def loopContinues := and (not (eq remaining (lit 0))) (not (eq (w 40) (lit 0)))
def loopOK := or (eq remaining (lit 0)) (w 39)
def ordinaryOK :=
  choose (isToken 9) (lit 1)
  (choose (isToken 10) (w 41)
  (choose (isToken 11) loopOK
    (and (lt payloadNat (lit 32))
      (and (and (not (lt (w 32) (lit 3))) (lt (w 32) (lit 7))) (w 37)))))

/-- Store and emit have distinct checked address extents. -/
def actionOK := and (w 31)
  (choose isAgain (and (isToken 11) (and (not (lt payloadNat (w 20))) loopOK))
    (choose (isToken 7) (and (w 39) (or (not (validAddress ramSize (w 40))) (w 37)))
      (choose (isToken 8) (and (w 39) (or (not (validAddress outputSize (w 40))) (w 37))) ordinaryOK)))

def memFault := or (and (isToken 4) (not (validAddress romSize (w 38))))
  (or (and (isToken 5) (not (validAddress ramSize (w 38))))
  (or (and (isToken 6) (not (validAddress tapeSize (w 38))))
  (or (and (isToken 7) (not (validAddress ramSize (w 40))))
      (and (isToken 8) (not (validAddress outputSize (w 40)))))))

/-- 0 keep, 1 fault, 2 register, 3 RAM, 4 output. -/
def editTag := choose isAgain (lit 0)
  (choose memFault (lit 1)
    (choose (and (not (lt (w 32) (lit 3))) (lt (w 32) (lit 7))) (lit 2)
      (choose (isToken 7) (lit 3) (choose (isToken 8) (lit 4) (lit 0)))))
def editAddress := choose (eq editTag (lit 2)) payloadNat (w 40)
def editValue := choose (isToken 4) (w 44) (choose (isToken 5) (w 43) (choose (isToken 6) (w 45)
  (choose (isToken 8) (not (eq (w 38) (lit 0))) (w 38))))

/-- Eleven-word pending encoding inherited from CoreEncoding020E5. -/
def actionPending (j : Nat) : C :=
  let two := or (and (not isAgain) (isToken 9)) (and (isToken 11) loopContinues)
  let one := and (not isAgain) (isToken 10)
  match j with
  | 0 => or two one
  | 1 => two
  | 2 => lit 0
  | 3 => choose one (choose (eq (w 42) (lit 0)) (w 34) (w 35)) (lit 0)
  | 4 => lit 0
  | 5 => lit 0
  | 6 => choose two (choose (isToken 9) (w 35) (w 34)) (lit 0)
  | 7 => lit 0
  | 8 => choose (and two (isToken 11)) (lit 1) (lit 0)
  | 9 => choose two (choose (isToken 9) (w 34) (w 19)) (lit 0)
  | 10 => choose (and two (isToken 11)) (pred remaining) (lit 0)
  | _ => lit 0

def pushRoom := lt (w 3) (lit 28941)
def pendingPresent := not (eq (w 4) (lit 0))
def pendingTwo := not (eq (w 5) (lit 0))
def pushPending (j : Nat) : C :=
  choose pendingTwo (match j with
    | 0 => lit 1 | 1 => lit 0 | 2 => w 9 | 3 => w 10 | 4 => w 11 | _ => lit 0) (lit 0)

def nextPhase :=
  choose (isPhase 0) (choose (eq (w 3) (lit 0)) (lit 5) (choose (eq (w 2) (lit 0)) (lit 6) (lit 1)))
  (choose (isPhase 1) (choose (lt (w 1) (lit 877)) (lit 1) (lit 2))
  (choose (isPhase 2) (choose (lt (w 1) (lit 877)) (lit 2) (lit 3))
  (choose (isPhase 3) (choose actionOK (lit 4) (lit 6))
  (choose (isPhase 4) (choose pendingPresent (choose pushRoom (lit 4) (lit 6)) (lit 0)) (w 0)))))

def nextCursor := choose (and (isPhase 0) (and (not (eq (w 3) (lit 0))) (not (eq (w 2) (lit 0))))) (lit 0)
  (choose (isPhase 1) (choose (lt (w 1) (lit 877)) (add (w 1) (lit 1)) (lit 0))
    (choose (and (isPhase 2) (lt (w 1) (lit 877))) (add (w 1) (lit 1)) (w 1)))

def nextMeta (j : Nat) : C := match j with
  | 0 => nextPhase
  | 1 => nextCursor
  | 2 => choose (and (isPhase 3) actionOK) (pred (w 2)) (w 2)
  | 3 => choose (and (isPhase 3) actionOK) (pred (w 3))
      (choose (and (isPhase 4) (and pendingPresent pushRoom)) (add (w 3) (lit 1)) (w 3))
  | 15 => choose (and (isPhase 3) (and actionOK (eq editTag (lit 1)))) (lit 1) (w 15)
  | _ => choose (and (isPhase 3) actionOK) (actionPending (j-4))
      (choose (and (isPhase 4) (and pendingPresent pushRoom)) (pushPending (j-4)) (w j))

end FT1536.S05.ProducerCoreCircuit020E6
