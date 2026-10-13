import ProducerReference020E7
import CoreStore020E5

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerSlotLayout020E7
open WordRAM020 ArrayBank020E4 ScriptBuffer020E5

/-- Proof-only concatenation; the runtime producer emits into fixed slots. -/
def join {A : Type} {n m : Nat} (a : Bank A n) (b : Bank A m) : Bank A (n+m) :=
  load (Fin.addCases (read a) (read b))

theorem execute_join {n a b : Nat} (x : Buffer n a) (y : Buffer n b) (q : Bank Word n) :
    execute (join x y) q=execute y (execute x q) := by
  simp only [execute,join,read_load,List.ofFn_add]
  have hx : (fun i : Fin a => Fin.addCases (read x) (read y) (i.castLE (Nat.le_add_right a b)))=read x := by
    funext i
    exact Fin.addCases_left i
  have hy : (fun i : Fin b => Fin.addCases (read x) (read y) (i.natAdd a))=read y := by
    funext i
    exact Fin.addCases_right i
  rw [hx,hy,scan_append]

/-- Three data slots, sixteen control slots, thirteen explicit empty slots. -/
def layout {n : Nat} (xs ys : List (WordPatch020E5.Write n)) : Buffer n 32 :=
  join (buffer 3 xs) (join (buffer 16 ys) (buffer 13 []))

theorem layout_effect {n : Nat} (xs ys : List (WordPatch020E5.Write n))
    (hx : xs.length≤3) (hy : ys.length≤16) (q : Bank Word n) :
    execute (layout xs ys) q=WordPatch020E5.apply (xs++ys) q := by
  rw [layout,execute_join,execute_join,executes xs hx,executes ys hy,executes [] (by simp)]
  exact (VerifiedPatch020E5.append_apply xs ys q).symm

abbrev Data := BoundaryPayload020E5.Data

def input (d : Data) : ArrayState020E4.Input := {tape:=d.tape.bank,rom:=d.rom.bank}

def reference (d : Data) : Buffer 143922 32 :=
  layout (CoreDataPatch020E5.program ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl
    d.parser.arena (input d) d.core).val.code
    (ControlStore020E5.code ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl
      (CoreControl020E5.next d.parser.arena (input d) d.core))

/-- Universal old-step effect of the fixed-slot reference layout. This
    does not assume or assert equality to the E6 scalar circuit's output. -/
theorem reference_effect (d : Data) :
    execute (reference d) (CoreFieldPatch020E5.image ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl d.core)=
      CoreFieldPatch020E5.image ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl
        (CoreStep020E5.step d.parser.arena (input d) d.core) := by
  let p := CoreDataPatch020E5.program ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl
    d.parser.arena (input d) d.core
  let c := ControlStore020E5.code ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl
    (CoreControl020E5.next d.parser.arena (input d) d.core)
  have hc : c.length≤16 := by unfold c;rw [ControlStore020E5.length]
  exact (layout_effect p.val.code c p.property hc _).trans
    (CoreStore020E5.realizes ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl
      d.parser.arena (input d) d.core)

def encodedReference (d : Data) : Bank Word 96 :=
  VerifiedPatch020E5.pack (WordCodec020E5.bank (ScriptStore020E5.writeCodec 143922 (by norm_num)) 32) (reference d)

/-- An explicit target equality for the remaining scalar proof; not a new
    premise supplied to a completed refinement or sampler certificate. -/
def RemainingEquality (d : Data) : Prop :=
  load (fun j => ProducerExpr020E6.eval (ProducerReference020E7.env d) (ProducerCoreSlots020E6.cells j))=encodedReference d

end FT1536.S05.ProducerSlotLayout020E7
