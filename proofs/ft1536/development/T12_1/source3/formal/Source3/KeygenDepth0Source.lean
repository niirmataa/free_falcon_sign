import Source3.KeygenSearchParser
import Source3.KeygenSearchFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Complete ternary_depth0 source, parsed in five statement-boundary pieces.
   The local macro definition/undef are bound explicitly. Pieces preserve
   the same local state and heap, with no scope reset at a piece boundary. -/
namespace FT1536.Source3.KeygenDepth0Source
open KeygenSearchExec

def types : KeygenSearchParser.Types := [
  ("fk".toList,448),("f".toList,2),("g".toList,2),
  ("Fp".toList,4),("Gp".toList,4),("t1".toList,4),
  ("rt1".toList,8),("rt2".toList,8),("rt3".toList,8),("rt4".toList,8),("rt5".toList,8)]
def region (start count : Nat) : List String := (Pinned.keygenLines.drop (start-1)).take count
def lines : Fin 5 → List String
  | 0 => region 7055 44
  | 1 => region 7099 31
  | 2 => region 7130 2 ++ region 7149 47 ++ region 7197 1
  | 3 => region 7198 69
  | 4 => region 7267 6
def parsed (i : Fin 5) : Option Stmt := do
  let tokens ← C99ProcedureParser.tokens ((lines i).flatMap String.toList++['}'])
  let tokens ← KeygenSearchParser.sizes types tokens
  let (code,_,rest) ← KeygenSearchParser.body types 256 tokens
  if rest.isEmpty then pure code else none
def part (i : Fin 5) : Stmt := (parsed i).getD skip
def code : Stmt := chain [part 0,part 1,part 2,part 3,part 4]
def writable : List C99ArrayReference.Name := ["Fp","Gp","t1","rt1","rt2","rt3","rt4","rt5"].map String.toList
def audit (i : Fin 5) : Option Bool := (parsed i).map (KeygenSearchFrame.only writable)

theorem signature_source : region 7051 4 = ["static int\n",
  "solve_NTRU_ternary_depth0(falcon_keygen *fk,\n","\tconst int16_t *f, const int16_t *g)\n","{\n"] := by decide
theorem macro_header : Pinned.keygenLines[7131]? =
  some "#define FPC_MUL(d_re, d_im, a_re, a_im, b_re, b_im)   do { \\\n" := by decide
theorem macro_body : FT1536.FftBind.FftSem.parseMacro ((region 7133 16).flatMap String.toList)=
  some (FpcSourceExpansion.expected .mul) := by decide
theorem macro_undef : Pinned.keygenLines[7195]?=some "#undef FPC_MUL\n" := by decide
theorem closing_source : Pinned.keygenLines[7272]?=some "}\n" := by decide
theorem source_partition : region 7055 218 =
  lines 0 ++ lines 1 ++ region 7130 2 ++ region 7132 17 ++ region 7149 47 ++
    region 7196 1 ++ region 7197 1 ++ lines 3 ++ lines 4 := by decide

theorem audit0 : audit 0=some true := by decide
theorem audit1 : audit 1=some true := by decide
theorem audit2 : audit 2=some true := by decide
theorem audit3 : audit 3=some true := by decide
theorem audit4 : audit 4=some true := by decide
theorem audit_all (i : Fin 5) : audit i=some true := by
  fin_cases i
  · exact audit0
  · exact audit1
  · exact audit2
  · exact audit3
  · exact audit4

theorem parsed_part (i : Fin 5) : parsed i=some (part i) := by
  have h := audit_all i
  unfold audit at h
  cases hp : parsed i with
  | none => simp only [hp,Option.map_none] at h; cases h
  | some p => simp only [part,hp,Option.getD_some]

theorem part_checked (i : Fin 5) : KeygenSearchFrame.only writable (part i)=true := by
  have h := audit_all i
  rw [audit,parsed_part] at h
  exact Option.some.inj h

theorem sequence_checked (a b : Stmt) (ha : KeygenSearchFrame.only writable a=true)
    (hb : KeygenSearchFrame.only writable b=true) : KeygenSearchFrame.only writable (.seq a b)=true :=
  Bool.and_eq_true_iff.mpr ⟨ha,hb⟩

theorem code_checked : KeygenSearchFrame.only writable code=true :=
  sequence_checked _ _ (part_checked 0) (sequence_checked _ _ (part_checked 1)
    (sequence_checked _ _ (part_checked 2) (sequence_checked _ _ (part_checked 3)
      (sequence_checked _ _ (part_checked 4) rfl))))

end FT1536.Source3.KeygenDepth0Source
