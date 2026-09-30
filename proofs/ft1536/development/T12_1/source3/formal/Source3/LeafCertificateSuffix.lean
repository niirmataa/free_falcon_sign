import Source3.LeafScan

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.LeafCertificateSuffix
open B20.C FT1536.Run2.KeygenLeafGate

def returnLine : List Char := (Pinned.keygenLines[7775]!).toList

def returnProgram : CLogic.Stmt := .ret
  (.cmp .eq (.var "bad".toList) (.literal .i32 0))

def parseReturn (chars : List Char) : Option (CLogic.Stmt × List Token) :=
  (CLogicParser.tokenize (chars.length+1) chars).bind CLogicParser.statement

theorem return_source_parses :
    parseReturn returnLine=some (returnProgram,[]) := by decide

def returnEval (stmt : CLogic.Stmt) (flag : Flag) : Option Val :=
  match stmt with
  | .ret expr => CLogic.eval (fun _ _ => none)
    (fun name => if name="bad".toList then some (.u32 flag) else none) 32 expr
  | _ => none

theorem return_bit (flag : Flag) :
    returnEval returnProgram flag=some (CLogic.boolean (decide (flag=0#32))) := by
  simp [returnEval,returnProgram,CLogic.eval,CLogic.compare,CLogic.boolean,
    B20.C.commonTy,B20.C.Val.ty,B20.C.cast,B20.C.literalValue]

def suffix (ws : List Word) (initialBad : Flag) : Option (List Word × Val) := do
  let code ← LeafScan.parse (KeygenHelpers.slice 7764 11)
  let (result,finalBad) ← LeafScan.run code 1536#64 1537 0#64 ws initialBad
  let (ret,rest) ← parseReturn returnLine
  if rest.isEmpty then pure (result,← returnEval ret finalBad) else none

theorem suffix_execution (ws : List Word) (bad : Flag) (hlen : ws.length=1536) :
    suffix ws bad=some ((scan ws bad).1,
      CLogic.boolean (decide ((scan ws bad).2=0#32))) := by
  have hr:=LeafScan.scan_binding ws bad (by rw [hlen]; decide)
  rw [hlen] at hr
  simp [suffix,LeafScan.source_parses,hr,return_source_parses,return_bit]

theorem source_return_one_forces_word_bounds (ws result : List Word) (bad : Flag)
    (hlen : ws.length=1536)
    (hexec : suffix ws bad=some (result,CLogic.boolean true)) :
    bad=0#32 ∧ result=ws ∧ ∀ w∈ws,
      positive w=true ∧ lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat := by
  rw [suffix_execution ws bad hlen] at hexec
  have hh:=Option.some.inj hexec
  have hr : (scan ws bad).2=0#32 := by
    have hv : CLogic.boolean (decide ((scan ws bad).2=0#32))=CLogic.boolean true :=
      congrArg Prod.snd hh
    have ht:=congrArg CLogic.truth hv
    simpa only [CLogic.truth_boolean,decide_eq_true_eq] using ht
  have ha:=((scan_clear ws bad).mp hr)
  exact ⟨ha.1,(congrArg Prod.fst hh).symm.trans (accepted_scan_preserves ws bad hr),ha.2⟩

end FT1536.Source3.LeafCertificateSuffix

#print FT1536.Source3.LeafCertificateSuffix.source_return_one_forces_word_bounds
#print axioms FT1536.Source3.LeafCertificateSuffix.return_source_parses
#print axioms FT1536.Source3.LeafCertificateSuffix.source_return_one_forces_word_bounds
