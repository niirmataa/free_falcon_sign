import Source3.KeygenPrivateValues106

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicValues106
open C99MemoryReference
open KeygenCodecSyntax
open KeygenPublicEncodeValues077
open KeygenCodecAtoms106 (Clean)

theorem clean (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (e : Expr) (before after : Locals) (v : Value)
    (source : Eval args heap buf e before v after) (start : Clean before) : Clean after := by
  revert start
  induction source <;> intro start
  all_goals grind only [→ KeygenCodecAtoms106.update_clean]

theorem expression (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (e : Expr) (before a b : Locals) (x y : Value) (start : Clean before)
    (first : Eval args heap buf e before x a) (second : Eval args heap buf e before y b) : a = b ∧ x = y := by
  revert start
  induction first generalizing b y <;> intro start <;> cases second
  all_goals have pointers := start
  all_goals simp only [Clean] at pointers
  all_goals grind (ematch := 8) only [→ clean, → KeygenCodecAtoms106.update,
    KeygenCodecAtoms106.load16, KeygenCodecAtoms106.unary, KeygenCodecAtoms106.binary,
    → KeygenCodecAtoms106.no_and, → KeygenCodecAtoms106.no_or, → KeygenCodecAtoms106.no_dereference]

end FT1536.Source3.KeygenPublicValues106
