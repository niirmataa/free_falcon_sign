import ExprStack020E

namespace FT1536.S05.CompilerAssociation020E
open WordRAM020 ExprStack020E

theorem bin_shape (o : Op) (a b : Expr) :
    compile (.bin o a b)=(compile a ++ compile b) ++ [.binary o] := rfl

end FT1536.S05.CompilerAssociation020E
