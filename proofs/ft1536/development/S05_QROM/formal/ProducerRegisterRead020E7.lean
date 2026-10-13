import ProducerScanValue020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerRegisterRead020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerEval020E7 ProducerReads020E7 ProducerScanValue020E7 ProducerScanRead020E7

theorem clamp_bound (w : Word) : w.toInt.toNat<2^511 := by
  have h := BitVec.toInt_lt (x:=w)
  norm_num at h ⊢
  omega

theorem register_decode (s : ArrayState020E4.State) (c : SyntaxCells020E.Cell) :
    ProducerSnapshot020E6.value ((SyntaxCells020E.decode c).bind (fun t => match t with
      | .register r => Option.some (read s.reg r) | _ => Option.none))=
    if c.1.val=1 then if h : c.2.toInt.toNat<32 then read s.reg ⟨c.2.toInt.toNat,h⟩ else 0 else 0 := by
  rcases c with ⟨tag,w⟩
  fin_cases tag <;> simp [SyntaxCells020E.decode,SyntaxCells020E.regOf,ProducerSnapshot020E6.value]
  all_goals first | (split <;> rfl) | (cases SyntaxCells020E.opOf w.toInt.toNat <;> rfl)

theorem register_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.cells 30)=ProducerSnapshot020E6.regValue d := by
  change eval (sources d fresh) (choose (and ProducerWindow020E6.scanPresent
    (and (eq (nodeAt cursor 0) (lit 1)) (lt (natClamp (nodeAt cursor 1)) (lit 32))))
    (.load 0 (natClamp (nodeAt cursor 1))) (lit 0))=_
  cases hn : ProducerSnapshot020E6.scanNode d with
  | none =>
    simp [choose_eval,and_eval,scan_present,hn,ProducerSnapshot020E6.regValue,ProducerSnapshot020E6.present,
      ProducerSnapshot020E6.value,WordCodec020E5.boolWord,word_zero]
  | some n =>
    have h0 := node_some d fresh n hn 0
    have h1 := node_some d fresh n hn 1
    change eval (sources d fresh) (nodeAt cursor 0)=word n.cell.1.val at h0
    change eval (sources d fresh) (nodeAt cursor 1)=n.cell.2 at h1
    have ht : n.cell.1.val<2^511 := lt_trans n.cell.1.isLt (by norm_num)
    have hw := clamp_bound n.cell.2
    simp only [choose_eval,and_eval,scan_present,hn,ProducerSnapshot020E6.regValue,Option.bind_some,
      eq_eval,lt_eval,clamp_eval,h0,h1,literal,
      eq_nat (a:=n.cell.1.val) (b:=1) ht (by norm_num),lt_nat (a:=n.cell.2.toInt.toNat) (b:=32) hw (by norm_num),
      ProducerSnapshot020E6.present,Option.isSome_some,WordCodec020E5.boolWord,ite_true,
      show (1 : Word)≠0 by decide,ite_false]
    apply Eq.trans ?_ (register_decode d.core.state n.cell).symm
    by_cases ht' : n.cell.1.val=1
    · by_cases hw' : n.cell.2.toInt.toNat<32
      · simp only [ht',hw',ite_true,show (1 : Word)≠0 by decide,ite_false,load_eval,clamp_eval,h1]
        exact reg_word d fresh ⟨n.cell.2.toInt.toNat,hw'⟩
      · simp [ht',hw',word_zero]
    · simp [ht',word_zero]

end FT1536.S05.ProducerRegisterRead020E7
