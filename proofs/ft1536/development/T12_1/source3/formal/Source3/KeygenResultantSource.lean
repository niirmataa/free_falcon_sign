import Source3.KeygenWordParser
import Source3.KeygenRngSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete mod2_res_ternary: automatic b[96], memset, packing loop, all
   source switch labels/fallthroughs, break and actual return. The arithmetic
   resultant interpretation is not needed to retain sampled f/g. -/
namespace FT1536.Source3.KeygenResultantSource
open C99ArrayReference (State Name Param Arg bindPointer)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenWordExec

def region := KeygenLevelNtt.region
def types : KeygenWordExpr.Types := [("b".toList,4),("f".toList,2)]
def setup : C99ModularReference.Stmt := (C99ModularParser.region 561 6).getD (.base .skip)
def parsedPacking : Option Stmt := KeygenWordParser.region types 568 13
def packing : Stmt := parsedPacking.getD skip
def ranges : Fin 9 → Nat×Nat
  | 0 => (583,55)
  | 1 => (639,32)
  | 2 => (672,19)
  | 3 => (692,13)
  | 4 => (706,11)
  | 5 => (718,11)
  | 6 => (730,10)
  | 7 => (741,10)
  | 8 => (752,10)
def parsedPart (i : Fin 9) : Option Stmt := KeygenWordParser.region types (ranges i).1 (ranges i).2
def part (i : Fin 9) : Stmt := (parsedPart i).getD skip
def writable : List Name := ["b".toList]
def audit (i : Fin 9) : Option Bool := (parsedPart i).map (only writable)
def switchCode (word : BitVec 32) : Stmt :=
  if 2≤word.toNat ∧ word.toNat≤11 then chain ((List.ofFn part).drop (11-word.toNat)) else skip
def parsedTail : Option Stmt := KeygenWordParser.region types 765 7
def tailCode : Stmt := parsedTail.getD skip

theorem signature_source : region 541 3 = ["static unsigned\n",
  "mod2_res_ternary(const int16_t *f, unsigned logn)\n","{\n"] := by decide
theorem opening_comment : C99ProcedureParser.tokens ((region 544 16).flatMap String.toList)=some [] := by decide
theorem array_source : region 560 1=["\tuint32_t b[96];\n"] := by decide
theorem setup_source : C99ModularParser.region 561 6=some setup := by decide
theorem memset_source : region 567 1=["\tmemset(b, 0, sizeof b);\n"] := by decide
theorem switch_partition : region 581 184 = ["\tswitch (logn) {\n","\tcase 11:\n"] ++
  region 583 55 ++ ["\tcase 10:\n"] ++ region 639 32 ++ ["\tcase 9:\n"] ++
  region 672 19 ++ ["\tcase 8:\n"] ++ region 692 13 ++ ["\tcase 7:\n"] ++
  region 706 11 ++ ["\tcase 6:\n"] ++ region 718 11 ++ ["\tcase 5:\n"] ++
  region 730 10 ++ ["\tcase 4:\n"] ++ region 741 10 ++ ["\tcase 3:\n"] ++
  region 752 10 ++ ["\tcase 2:\n","\t\tbreak;\n","\t}\n"] := by decide
theorem closing_source : region 772 1=["}\n"] := by decide
theorem setup_checked : KeygenLevelModularFrame.only writable setup=true := by decide
theorem packing_audit : parsedPacking.map (only writable)=some true := by decide
theorem tail_audit : parsedTail.map (only writable)=some true := by decide
theorem audit0 : audit 0=some true := by decide
theorem audit1 : audit 1=some true := by decide
theorem audit2 : audit 2=some true := by decide
theorem audit3 : audit 3=some true := by decide
theorem audit4 : audit 4=some true := by decide
theorem audit5 : audit 5=some true := by decide
theorem audit6 : audit 6=some true := by decide
theorem audit7 : audit 7=some true := by decide
theorem audit8 : audit 8=some true := by decide
theorem audit_all (i : Fin 9) : audit i=some true := by
  fin_cases i
  · exact audit0
  · exact audit1
  · exact audit2
  · exact audit3
  · exact audit4
  · exact audit5
  · exact audit6
  · exact audit7
  · exact audit8
theorem from_audit (parsed : Option Stmt) (h : parsed.map (only writable)=some true) :
    parsed=some (parsed.getD skip) ∧ only writable (parsed.getD skip)=true := by
  cases parsed with
  | none => cases h
  | some code => exact ⟨rfl,Option.some.inj h⟩
theorem packing_source : parsedPacking=some packing := (from_audit parsedPacking packing_audit).1
theorem packing_checked : only writable packing=true := (from_audit parsedPacking packing_audit).2
theorem part_source (i : Fin 9) : parsedPart i=some (part i) := (from_audit _ (audit_all i)).1
theorem part_checked (i : Fin 9) : only writable (part i)=true := (from_audit _ (audit_all i)).2
theorem tail_source : parsedTail=some tailCode := (from_audit _ tail_audit).1
theorem tail_checked : only writable tailCode=true := (from_audit _ tail_audit).2
theorem chain_checked (parts : List Stmt) (h : ∀ p∈parts, only writable p=true) : only writable (chain parts)=true := by
  induction parts with
  | nil => rfl
  | cons p ps ih => exact Bool.and_eq_true_iff.mpr ⟨h p (by simp),ih (fun x hx => h x (by simp [hx]))⟩
theorem switch_checked (w : BitVec 32) : only writable (switchCode w)=true := by
  unfold switchCode
  split
  · apply chain_checked
    intro p member
    have original := List.mem_of_mem_drop member
    obtain ⟨i,rfl⟩ := List.mem_ofFn.mp original
    exact part_checked i
  · rfl

def allocated (heap : Memory) (block : Nat) : Memory :=
  { bytes := fun b offset => if b=block then none else heap.bytes b offset
    size := fun b => if b=block then 384 else heap.size b
    writable := fun b => if b=block then true else heap.writable b }
def object (block : Nat) : ArrayPointer := ⟨block,0,96,4,0⟩
/- memset's literal count is sizeof(uint32_t[96])=384. It writes bytes, not
   a guessed mathematical vector; the destination must be a live writable object. -/
def zeroed (heap : Memory) (block : Nat) : Memory :=
  {heap with bytes := fun b offset => if b=block ∧ offset<384 then some 0 else heap.bytes b offset}
def ZeroLegal (heap : Memory) (block : Nat) : Prop :=
  384≤heap.size block ∧ heap.size block<2^64 ∧ heap.writable block=true
def entry (s : State) (block : Nat) : State :=
  bindPointer {s with heap := allocated s.heap block} "b".toList (object block)
def params : List Param := [.pointer "f".toList,.scalar .uint32 "logn".toList]
inductive Call (before : State) (args : List Arg) : State → Value → Prop where
  | run (bound ready packed reduced : State) (out : Result) (block : Nat) (word : BitVec 32) (v : Value)
      (binding : C99ArrayReference.Bind before params args bound)
      (fresh : KeygenRngSource.Fresh bound.heap block)
      (initial : C99ModularReference.Exec setup (entry bound block) ⟨ready,.normal⟩)
      (legal : ZeroLegal ready.heap block)
      (pack : Exec packing {ready with heap := zeroed ready.heap block} ⟨packed,.normal⟩)
      (read : C99ArrayReference.scalar packed (.var "logn".toList) (.uint32 word))
      (fallthrough : Exec (switchCode word) packed ⟨reduced,.normal⟩)
      (tail : Exec tailCode reduced out)
      (returned : C99ProcedureReference.ReturnValue (some .uint32) out.flow (some v)) :
      Call before args {before with heap := KeygenRngSource.disposed before.heap out.state.heap block} v

theorem bytes (before after : State) (args : List Arg) (v : Value) (source : Call before args after v) :
    after.heap.bytes=before.heap.bytes := by
  cases source with
  | run bound ready packed reduced out localBlock word v binding fresh initial legal pack read fallthrough tail returned =>
    funext block offset
    by_cases equal : block=localBlock
    · simp only [KeygenRngSource.disposed,equal,ite_true]
    · have outside : C99ArrayFrame.Outside (entry bound localBlock) writable block offset := by
        intro name member p hp
        have same : name="b".toList := by simpa only [writable,List.mem_singleton] using member
        subst name
        have ptr : p=object localBlock := (Option.some.inj (by simpa [entry,bindPointer] using hp)).symm
        subst p
        exact Or.inl equal
      obtain ⟨oa,_,fa⟩ := KeygenLevelModularFrame.body_frame setup (entry bound localBlock)
        ⟨ready,.normal⟩ initial writable setup_checked block offset outside
      obtain ⟨ob,_,fb⟩ := body_frame packing {ready with heap := zeroed ready.heap localBlock}
        ⟨packed,.normal⟩ pack writable packing_checked block offset oa
      obtain ⟨oc,_,fc⟩ := body_frame (switchCode word) packed ⟨reduced,.normal⟩ fallthrough
        writable (switch_checked word) block offset ob
      have fd := (body_frame tailCode reduced out tail writable tail_checked block offset oc).2.2
      have heap := C99ArrayReference.bind_heap before params args bound binding
      have fb' : packed.heap.bytes block offset=ready.heap.bytes block offset := by
        simpa only [zeroed,equal,false_and,ite_false] using fb
      simpa only [KeygenRngSource.disposed,entry,bindPointer,allocated,zeroed,equal,ite_false,
        false_and,heap] using fd.trans (fc.trans (fb'.trans fa))

end FT1536.Source3.KeygenResultantSource
