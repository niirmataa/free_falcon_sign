import Source3.FprFastCalls137
import Source3.C99ArrayReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FftWordExpressions140
open C99ArrayReference (State Expr Eval)

def add (a b : Expr) : Expr := .call2 "fpr_add".toList a b
def sub (a b : Expr) : Expr := .call2 "fpr_sub".toList a b
def mul (a b : Expr) : Expr := .call2 "fpr_mul".toList a b

theorem add_source (state : State) (a b : Expr) (x y : BitVec 64)
    (left : Eval state a (.uint64 x)) (right : Eval state b (.uint64 y)) :
    Eval state (add a b) (.uint64 (FprAddFast137.word x y)) :=
  .call2 _ _ _ _ _ _ left right (FprAddFast137.source x y)

theorem sub_source (state : State) (a b : Expr) (x y : BitVec 64)
    (left : Eval state a (.uint64 x)) (right : Eval state b (.uint64 y)) :
    Eval state (sub a b) (.uint64 (FprHeadersFast137.sub x y)) :=
  .call2 _ _ _ _ _ _ left right (FprHeadersFast137.sub_source x y)

theorem mul_source (state : State) (a b : Expr) (x y : BitVec 64)
    (left : Eval state a (.uint64 x)) (right : Eval state b (.uint64 y)) :
    Eval state (mul a b) (.uint64 (FprMulFast137.word x y)) :=
  .call2 _ _ _ _ _ _ left right (FprMulFast137.source x y)

def real (ar ai br bi : BitVec 64) : BitVec 64 :=
  FprHeadersFast137.sub (FprMulFast137.word ar br) (FprMulFast137.word ai bi)
def imag (ar ai br bi : BitVec 64) : BitVec 64 :=
  FprAddFast137.word (FprMulFast137.word ar bi) (FprMulFast137.word ai br)

theorem complex_source (state : State) (ar ai br bi : Expr) (xr xi yr yi : BitVec 64)
    (are : Eval state ar (.uint64 xr)) (aim : Eval state ai (.uint64 xi))
    (bre : Eval state br (.uint64 yr)) (bim : Eval state bi (.uint64 yi)) :
    Eval state (sub (mul ar br) (mul ai bi)) (.uint64 (real xr xi yr yi)) ∧
    Eval state (add (mul ar bi) (mul ai br)) (.uint64 (imag xr xi yr yi)) :=
  ⟨sub_source state _ _ _ _ (mul_source state _ _ _ _ are bre) (mul_source state _ _ _ _ aim bim),
   add_source state _ _ _ _ (mul_source state _ _ _ _ are bim) (mul_source state _ _ _ _ aim bre)⟩

end FT1536.Source3.FftWordExpressions140
