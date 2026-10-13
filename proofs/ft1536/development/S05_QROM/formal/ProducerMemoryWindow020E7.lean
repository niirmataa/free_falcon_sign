import ProducerMemoryRead020E7
import ProducerActValue020E7

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerMemoryWindow020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreView020E6
open ProducerWordLaws020E6 ProducerEval020E7 ProducerMemoryRead020E7 ProducerAddress020E7

theorem value_some (w : Word) : ProducerSnapshot020E6.value (Option.some w)=w := rfl

theorem ram_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.cells 43)=ProducerSnapshot020E6.memoryValue d 0 := by
  change eval (sources d fresh) (choose (and (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).present
    (validAddress ramSize (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value))
    (.load 0 (add (lit ramBase) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value)) (lit 0))=_
  have hp := (ProducerActValue020E7.first_correct d fresh).1
  have hv := (ProducerActValue020E7.first_correct d fresh).2
  simp only [choose_eval,and_eval,hp,valid_eval (sources d fresh) ramSize (by norm_num [ramSize]),hv]
  cases ha : ProducerSnapshot020E6.actValue d 0 with
  | none =>
    simp [ha,ProducerSnapshot020E6.present,ProducerSnapshot020E6.memoryValue,ProducerSnapshot020E6.value,
      WordCodec020E5.boolWord,word_zero]
  | some w =>
    simp only [ha,ProducerSnapshot020E6.present,value_some,Option.isSome_some,
      WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,
      ProducerSnapshot020E6.memoryValue,Option.bind_some]
    change (if WordCodec020E5.boolWord (address ramSize w).isSome=0 then word 0 else
      eval (sources d fresh) (.load 0 (add (lit ramBase) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value)))=
      ((address ramSize w).map (read d.core.state.ram)).getD 0
    cases hj : address ramSize w with
    | none => rfl
    | some j =>
      simp only [Option.isSome_some,WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,
        Option.map_some,Option.getD_some]
      have he : eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value=word j.val := by
        simpa only [ha,ProducerSnapshot020E6.value,Option.getD_some,some_word w j hj] using hv
      simp only [load_eval,add_eval,literal,he,ramBase,
        add_nat (a:=32) (b:=j.val) (by norm_num) (lt_trans j.isLt (by norm_num [ramSize]))]
      exact ram_word d fresh j

theorem rom_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.cells 44)=ProducerSnapshot020E6.memoryValue d 1 := by
  change eval (sources d fresh) (choose (and (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).present
    (validAddress romSize (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value))
    (.load 3 (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value) (lit 0))=_
  have hp := (ProducerActValue020E7.first_correct d fresh).1
  have hv := (ProducerActValue020E7.first_correct d fresh).2
  simp only [choose_eval,and_eval,hp,valid_eval (sources d fresh) romSize (by norm_num [romSize]),hv]
  cases ha : ProducerSnapshot020E6.actValue d 0 with
  | none =>
    simp [ha,ProducerSnapshot020E6.present,ProducerSnapshot020E6.memoryValue,ProducerSnapshot020E6.value,
      WordCodec020E5.boolWord,word_zero]
  | some w =>
    simp only [ha,ProducerSnapshot020E6.present,value_some,Option.isSome_some,
      WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,
      ProducerSnapshot020E6.memoryValue,Option.bind_some]
    change (if WordCodec020E5.boolWord (address romSize w).isSome=0 then word 0 else
      eval (sources d fresh) (.load 3 (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value))=
      ((address romSize w).map (read d.rom.bank)).getD 0
    cases hj : address romSize w with
    | none => rfl
    | some j =>
      simp only [Option.isSome_some,WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,
        Option.map_some,Option.getD_some]
      have he : eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value=word j.val := by
        simpa only [ha,ProducerSnapshot020E6.value,Option.getD_some,some_word w j hj] using hv
      simp only [load_eval,he]
      exact rom_word d fresh j

theorem tape_correct (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (sources d fresh) (ProducerWindow020E6.cells 45)=ProducerSnapshot020E6.memoryValue d 2 := by
  change eval (sources d fresh) (choose (and (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).present
    (validAddress tapeSize (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value))
    (.load 2 (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value) (lit 0))=_
  have hp := (ProducerActValue020E7.first_correct d fresh).1
  have hv := (ProducerActValue020E7.first_correct d fresh).2
  simp only [choose_eval,and_eval,hp,valid_eval (sources d fresh) tapeSize (by norm_num [tapeSize]),hv]
  cases ha : ProducerSnapshot020E6.actValue d 0 with
  | none =>
    simp [ha,ProducerSnapshot020E6.present,ProducerSnapshot020E6.memoryValue,ProducerSnapshot020E6.value,
      WordCodec020E5.boolWord,word_zero]
  | some w =>
    simp only [ha,ProducerSnapshot020E6.present,value_some,Option.isSome_some,
      WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,
      ProducerSnapshot020E6.memoryValue,Option.bind_some]
    change (if WordCodec020E5.boolWord (address tapeSize w).isSome=0 then word 0 else
      eval (sources d fresh) (.load 2 (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value))=
      ((address tapeSize w).map (fun j => WordCodec020E5.boolWord (read d.tape.bank j))).getD 0
    cases hj : address tapeSize w with
    | none => rfl
    | some j =>
      simp only [Option.isSome_some,WordCodec020E5.boolWord,ite_true,show (1 : Word)≠0 by decide,ite_false,
        Option.map_some,Option.getD_some]
      have he : eval (sources d fresh) (ProducerWindow020E6.actGuarded ProducerWindow020E6.actFirst).value=word j.val := by
        simpa only [ha,ProducerSnapshot020E6.value,Option.getD_some,some_word w j hj] using hv
      simp only [load_eval,he]
      exact tape_word d fresh j

end FT1536.S05.ProducerMemoryWindow020E7
