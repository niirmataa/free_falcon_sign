import B20.C.ScalarParser
set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
namespace B20.Fpr.Parsed
open B20.C (Token)
open B20.C.Scalar
def packStmtTokens0 : List Token := ["fpr", "x", ";"].map String.toList
def packStmt0 : Stmt := .declare .u64 ["x".toList]
theorem packstmt0 (tail : List Token) : statement (packStmtTokens0 ++ tail) = some (packStmt0, tail) := by rfl
def packStmtTokens1 : List Token := ["uint32_t", "t", ";"].map String.toList
def packStmt1 : Stmt := .declare .u32 ["t".toList]
theorem packstmt1 (tail : List Token) : statement (packStmtTokens1 ++ tail) = some (packStmt1, tail) := by rfl
def packStmtTokens2 : List Token := ["unsigned", "f", ";"].map String.toList
def packStmt2 : Stmt := .declare .u32 ["f".toList]
theorem packstmt2 (tail : List Token) : statement (packStmtTokens2 ++ tail) = some (packStmt2, tail) := by rfl
def packStmtTokens3 : List Token := ["e", "+=", "1076", ";"].map String.toList
def packStmt3 : Stmt := .update "e".toList .add (.literal .i32 1076)
theorem packstmt3 (tail : List Token) : statement (packStmtTokens3 ++ tail) = some (packStmt3, tail) := by rfl
def packStmtTokens4 : List Token := ["t", "=", "(", "uint32_t", ")", "e", ">>", "31", ";"].map String.toList
def packStmt4 : Stmt := .assign "t".toList (.bin .shr (.cast .u32 (.var "e".toList)) (.literal .i32 31))
theorem packstmt4 (tail : List Token) : statement (packStmtTokens4 ++ tail) = some (packStmt4, tail) := by rfl
def packStmtTokens5 : List Token := ["m", "&=", "(", "uint64_t", ")", "t", "-", "1", ";"].map String.toList
def packStmt5 : Stmt := .update "m".toList .band (.bin .sub (.cast .u64 (.var "t".toList)) (.literal .i32 1))
theorem packstmt5 (tail : List Token) : statement (packStmtTokens5 ++ tail) = some (packStmt5, tail) := by rfl
def packStmtTokens6 : List Token := ["t", "=", "(", "uint32_t", ")", "(", "m", ">>", "54", ")", ";"].map String.toList
def packStmt6 : Stmt := .assign "t".toList (.cast .u32 (.bin .shr (.var "m".toList) (.literal .i32 54)))
theorem packstmt6 (tail : List Token) : statement (packStmtTokens6 ++ tail) = some (packStmt6, tail) := by rfl
def packStmtTokens7 : List Token := ["e", "&=", "-", "(", "int", ")", "t", ";"].map String.toList
def packStmt7 : Stmt := .update "e".toList .band (.neg (.cast .i32 (.var "t".toList)))
theorem packstmt7 (tail : List Token) : statement (packStmtTokens7 ++ tail) = some (packStmt7, tail) := by rfl
def packStmtTokens8 : List Token := ["x", "=", "(", "(", "(", "uint64_t", ")", "s", "<<", "63", ")", "|", "(", "m", ">>", "2", ")", ")", "+", "(", "(", "uint64_t", ")", "(", "uint32_t", ")", "e", "<<", "52", ")", ";"].map String.toList
def packStmt8 : Stmt := .assign "x".toList (.bin .add (.bin .bor (.bin .shl (.cast .u64 (.var "s".toList)) (.literal .i32 63)) (.bin .shr (.var "m".toList) (.literal .i32 2))) (.bin .shl (.cast .u64 (.cast .u32 (.var "e".toList))) (.literal .i32 52)))
theorem packstmt8 (tail : List Token) : statement (packStmtTokens8 ++ tail) = some (packStmt8, tail) := by rfl
def packStmtTokens9 : List Token := ["f", "=", "(", "unsigned", ")", "m", "&", "7U", ";"].map String.toList
def packStmt9 : Stmt := .assign "f".toList (.bin .band (.cast .u32 (.var "m".toList)) (.literal .u32 7))
theorem packstmt9 (tail : List Token) : statement (packStmtTokens9 ++ tail) = some (packStmt9, tail) := by rfl
def packStmtTokens10 : List Token := ["x", "+=", "(", "0xC8U", ">>", "f", ")", "&", "1", ";"].map String.toList
def packStmt10 : Stmt := .update "x".toList .add (.bin .band (.bin .shr (.literal .u32 200) (.var "f".toList)) (.literal .i32 1))
theorem packstmt10 (tail : List Token) : statement (packStmtTokens10 ++ tail) = some (packStmt10, tail) := by rfl
def packStmtTokens11 : List Token := ["return", "x", ";"].map String.toList
def packStmt11 : Stmt := .ret (.var "x".toList)
theorem packstmt11 (tail : List Token) : statement (packStmtTokens11 ++ tail) = some (packStmt11, tail) := by rfl
def rintStmtTokens0 : List Token := ["uint64_t", "m", ",", "d", ";"].map String.toList
def rintStmt0 : Stmt := .declare .u64 ["m".toList, "d".toList]
theorem rintstmt0 (tail : List Token) : statement (rintStmtTokens0 ++ tail) = some (rintStmt0, tail) := by rfl
def rintStmtTokens1 : List Token := ["int", "e", ";"].map String.toList
def rintStmt1 : Stmt := .declare .i32 ["e".toList]
theorem rintstmt1 (tail : List Token) : statement (rintStmtTokens1 ++ tail) = some (rintStmt1, tail) := by rfl
def rintStmtTokens2 : List Token := ["uint32_t", "s", ",", "dd", ",", "f", ";"].map String.toList
def rintStmt2 : Stmt := .declare .u32 ["s".toList, "dd".toList, "f".toList]
theorem rintstmt2 (tail : List Token) : statement (rintStmtTokens2 ++ tail) = some (rintStmt2, tail) := by rfl
def rintStmtTokens3 : List Token := ["m", "=", "(", "(", "x", "<<", "10", ")", "|", "(", "(", "uint64_t", ")", "1", "<<", "62", ")", ")", "&", "(", "(", "(", "uint64_t", ")", "1", "<<", "63", ")", "-", "1", ")", ";"].map String.toList
def rintStmt3 : Stmt := .assign "m".toList (.bin .band (.bin .bor (.bin .shl (.var "x".toList) (.literal .i32 10)) (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 62))) (.bin .sub (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)) (.literal .i32 1)))
theorem rintstmt3 (tail : List Token) : statement (rintStmtTokens3 ++ tail) = some (rintStmt3, tail) := by rfl
def rintStmtTokens4 : List Token := ["e", "=", "1085", "-", "(", "(", "int", ")", "(", "x", ">>", "52", ")", "&", "0x7FF", ")", ";"].map String.toList
def rintStmt4 : Stmt := .assign "e".toList (.bin .sub (.literal .i32 1085) (.bin .band (.cast .i32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .i32 2047)))
theorem rintstmt4 (tail : List Token) : statement (rintStmtTokens4 ++ tail) = some (rintStmt4, tail) := by rfl
def rintStmtTokens5 : List Token := ["m", "&=", "-", "(", "uint64_t", ")", "(", "(", "uint32_t", ")", "(", "e", "-", "64", ")", ">>", "31", ")", ";"].map String.toList
def rintStmt5 : Stmt := .update "m".toList .band (.neg (.cast .u64 (.bin .shr (.cast .u32 (.bin .sub (.var "e".toList) (.literal .i32 64))) (.literal .i32 31))))
theorem rintstmt5 (tail : List Token) : statement (rintStmtTokens5 ++ tail) = some (rintStmt5, tail) := by rfl
def rintStmtTokens6 : List Token := ["e", "&=", "63", ";"].map String.toList
def rintStmt6 : Stmt := .update "e".toList .band (.literal .i32 63)
theorem rintstmt6 (tail : List Token) : statement (rintStmtTokens6 ++ tail) = some (rintStmt6, tail) := by rfl
def rintStmtTokens7 : List Token := ["d", "=", "fpr_ulsh", "(", "m", ",", "63", "-", "e", ")", ";"].map String.toList
def rintStmt7 : Stmt := .assign "d".toList (.call2 "fpr_ulsh".toList (.var "m".toList) (.bin .sub (.literal .i32 63) (.var "e".toList)))
theorem rintstmt7 (tail : List Token) : statement (rintStmtTokens7 ++ tail) = some (rintStmt7, tail) := by rfl
def rintStmtTokens8 : List Token := ["dd", "=", "(", "uint32_t", ")", "d", "|", "(", "(", "uint32_t", ")", "(", "d", ">>", "32", ")", "&", "0x1FFFFFFF", ")", ";"].map String.toList
def rintStmt8 : Stmt := .assign "dd".toList (.bin .bor (.cast .u32 (.var "d".toList)) (.bin .band (.cast .u32 (.bin .shr (.var "d".toList) (.literal .i32 32))) (.literal .i32 536870911)))
theorem rintstmt8 (tail : List Token) : statement (rintStmtTokens8 ++ tail) = some (rintStmt8, tail) := by rfl
def rintStmtTokens9 : List Token := ["f", "=", "(", "uint32_t", ")", "(", "d", ">>", "61", ")", "|", "(", "(", "dd", "|", "-", "dd", ")", ">>", "31", ")", ";"].map String.toList
def rintStmt9 : Stmt := .assign "f".toList (.bin .bor (.cast .u32 (.bin .shr (.var "d".toList) (.literal .i32 61))) (.bin .shr (.bin .bor (.var "dd".toList) (.neg (.var "dd".toList))) (.literal .i32 31)))
theorem rintstmt9 (tail : List Token) : statement (rintStmtTokens9 ++ tail) = some (rintStmt9, tail) := by rfl
def rintStmtTokens10 : List Token := ["m", "=", "fpr_ursh", "(", "m", ",", "e", ")", "+", "(", "uint64_t", ")", "(", "(", "0xC8U", ">>", "f", ")", "&", "1U", ")", ";"].map String.toList
def rintStmt10 : Stmt := .assign "m".toList (.bin .add (.call2 "fpr_ursh".toList (.var "m".toList) (.var "e".toList)) (.cast .u64 (.bin .band (.bin .shr (.literal .u32 200) (.var "f".toList)) (.literal .u32 1))))
theorem rintstmt10 (tail : List Token) : statement (rintStmtTokens10 ++ tail) = some (rintStmt10, tail) := by rfl
def rintStmtTokens11 : List Token := ["s", "=", "(", "uint32_t", ")", "(", "x", ">>", "63", ")", ";"].map String.toList
def rintStmt11 : Stmt := .assign "s".toList (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 63)))
theorem rintstmt11 (tail : List Token) : statement (rintStmtTokens11 ++ tail) = some (rintStmt11, tail) := by rfl
def rintStmtTokens12 : List Token := ["return", "(", "(", "int64_t", ")", "m", "^", "-", "(", "int64_t", ")", "s", ")", "+", "(", "int64_t", ")", "s", ";"].map String.toList
def rintStmt12 : Stmt := .ret (.bin .add (.bin .xor (.cast .i64 (.var "m".toList)) (.neg (.cast .i64 (.var "s".toList)))) (.cast .i64 (.var "s".toList)))
theorem rintstmt12 (tail : List Token) : statement (rintStmtTokens12 ++ tail) = some (rintStmt12, tail) := by rfl
def floorStmtTokens0 : List Token := ["uint64_t", "t", ",", "mask", ";"].map String.toList
def floorStmt0 : Stmt := .declare .u64 ["t".toList, "mask".toList]
theorem floorstmt0 (tail : List Token) : statement (floorStmtTokens0 ++ tail) = some (floorStmt0, tail) := by rfl
def floorStmtTokens1 : List Token := ["int64_t", "xi", ";"].map String.toList
def floorStmt1 : Stmt := .declare .i64 ["xi".toList]
theorem floorstmt1 (tail : List Token) : statement (floorStmtTokens1 ++ tail) = some (floorStmt1, tail) := by rfl
def floorStmtTokens2 : List Token := ["int", "e", ",", "cc", ";"].map String.toList
def floorStmt2 : Stmt := .declare .i32 ["e".toList, "cc".toList]
theorem floorstmt2 (tail : List Token) : statement (floorStmtTokens2 ++ tail) = some (floorStmt2, tail) := by rfl
def floorStmtTokens3 : List Token := ["e", "=", "(", "int", ")", "(", "x", ">>", "52", ")", "&", "0x7FF", ";"].map String.toList
def floorStmt3 : Stmt := .assign "e".toList (.bin .band (.cast .i32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .i32 2047))
theorem floorstmt3 (tail : List Token) : statement (floorStmtTokens3 ++ tail) = some (floorStmt3, tail) := by rfl
def floorStmtTokens4 : List Token := ["t", "=", "x", ">>", "63", ";"].map String.toList
def floorStmt4 : Stmt := .assign "t".toList (.bin .shr (.var "x".toList) (.literal .i32 63))
theorem floorstmt4 (tail : List Token) : statement (floorStmtTokens4 ++ tail) = some (floorStmt4, tail) := by rfl
def floorStmtTokens5 : List Token := ["xi", "=", "(", "int64_t", ")", "(", "(", "(", "x", "<<", "10", ")", "|", "(", "(", "uint64_t", ")", "1", "<<", "62", ")", ")", "&", "(", "(", "(", "uint64_t", ")", "1", "<<", "63", ")", "-", "1", ")", ")", ";"].map String.toList
def floorStmt5 : Stmt := .assign "xi".toList (.cast .i64 (.bin .band (.bin .bor (.bin .shl (.var "x".toList) (.literal .i32 10)) (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 62))) (.bin .sub (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)) (.literal .i32 1))))
theorem floorstmt5 (tail : List Token) : statement (floorStmtTokens5 ++ tail) = some (floorStmt5, tail) := by rfl
def floorStmtTokens6 : List Token := ["xi", "=", "(", "xi", "^", "-", "(", "int64_t", ")", "t", ")", "+", "(", "int64_t", ")", "t", ";"].map String.toList
def floorStmt6 : Stmt := .assign "xi".toList (.bin .add (.bin .xor (.var "xi".toList) (.neg (.cast .i64 (.var "t".toList)))) (.cast .i64 (.var "t".toList)))
theorem floorstmt6 (tail : List Token) : statement (floorStmtTokens6 ++ tail) = some (floorStmt6, tail) := by rfl
def floorStmtTokens7 : List Token := ["cc", "=", "1085", "-", "e", ";"].map String.toList
def floorStmt7 : Stmt := .assign "cc".toList (.bin .sub (.literal .i32 1085) (.var "e".toList))
theorem floorstmt7 (tail : List Token) : statement (floorStmtTokens7 ++ tail) = some (floorStmt7, tail) := by rfl
def floorStmtTokens8 : List Token := ["xi", "=", "fpr_irsh", "(", "xi", ",", "cc", "&", "63", ")", ";"].map String.toList
def floorStmt8 : Stmt := .assign "xi".toList (.call2 "fpr_irsh".toList (.var "xi".toList) (.bin .band (.var "cc".toList) (.literal .i32 63)))
theorem floorstmt8 (tail : List Token) : statement (floorStmtTokens8 ++ tail) = some (floorStmt8, tail) := by rfl
def floorStmtTokens9 : List Token := ["mask", "=", "-", "(", "uint64_t", ")", "(", "(", "uint32_t", ")", "(", "63", "-", "cc", ")", ">>", "31", ")", ";"].map String.toList
def floorStmt9 : Stmt := .assign "mask".toList (.neg (.cast .u64 (.bin .shr (.cast .u32 (.bin .sub (.literal .i32 63) (.var "cc".toList))) (.literal .i32 31))))
theorem floorstmt9 (tail : List Token) : statement (floorStmtTokens9 ++ tail) = some (floorStmt9, tail) := by rfl
def floorStmtTokens10 : List Token := ["xi", "=", "(", "int64_t", ")", "(", "(", "(", "uint64_t", ")", "xi", "&", "~", "mask", ")", "|", "(", "(", "-", "t", ")", "&", "mask", ")", ")", ";"].map String.toList
def floorStmt10 : Stmt := .assign "xi".toList (.cast .i64 (.bin .bor (.bin .band (.cast .u64 (.var "xi".toList)) (.bitNot (.var "mask".toList))) (.bin .band (.neg (.var "t".toList)) (.var "mask".toList))))
theorem floorstmt10 (tail : List Token) : statement (floorStmtTokens10 ++ tail) = some (floorStmt10, tail) := by rfl
def floorStmtTokens11 : List Token := ["return", "(", "long", ")", "xi", ";"].map String.toList
def floorStmt11 : Stmt := .ret (.cast .i64 (.var "xi".toList))
theorem floorstmt11 (tail : List Token) : statement (floorStmtTokens11 ++ tail) = some (floorStmt11, tail) := by rfl
def subStmtTokens0 : List Token := ["y", "^=", "(", "uint64_t", ")", "1", "<<", "63", ";"].map String.toList
def subStmt0 : Stmt := .update "y".toList .xor (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63))
theorem substmt0 (tail : List Token) : statement (subStmtTokens0 ++ tail) = some (subStmt0, tail) := by rfl
def subStmtTokens1 : List Token := ["return", "fpr_add", "(", "x", ",", "y", ")", ";"].map String.toList
def subStmt1 : Stmt := .ret (.call2 "fpr_add".toList (.var "x".toList) (.var "y".toList))
theorem substmt1 (tail : List Token) : statement (subStmtTokens1 ++ tail) = some (subStmt1, tail) := by rfl
def negStmtTokens0 : List Token := ["x", "^=", "(", "uint64_t", ")", "1", "<<", "63", ";"].map String.toList
def negStmt0 : Stmt := .update "x".toList .xor (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63))
theorem negstmt0 (tail : List Token) : statement (negStmtTokens0 ++ tail) = some (negStmt0, tail) := by rfl
def negStmtTokens1 : List Token := ["return", "x", ";"].map String.toList
def negStmt1 : Stmt := .ret (.var "x".toList)
theorem negstmt1 (tail : List Token) : statement (negStmtTokens1 ++ tail) = some (negStmt1, tail) := by rfl
def halfStmtTokens0 : List Token := ["uint32_t", "t", ";"].map String.toList
def halfStmt0 : Stmt := .declare .u32 ["t".toList]
theorem halfstmt0 (tail : List Token) : statement (halfStmtTokens0 ++ tail) = some (halfStmt0, tail) := by rfl
def halfStmtTokens1 : List Token := ["x", "-=", "(", "uint64_t", ")", "1", "<<", "52", ";"].map String.toList
def halfStmt1 : Stmt := .update "x".toList .sub (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 52))
theorem halfstmt1 (tail : List Token) : statement (halfStmtTokens1 ++ tail) = some (halfStmt1, tail) := by rfl
def halfStmtTokens2 : List Token := ["t", "=", "(", "(", "(", "uint32_t", ")", "(", "x", ">>", "52", ")", "&", "0x7FF", ")", "+", "1", ")", ">>", "11", ";"].map String.toList
def halfStmt2 : Stmt := .assign "t".toList (.bin .shr (.bin .add (.bin .band (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .i32 2047)) (.literal .i32 1)) (.literal .i32 11))
theorem halfstmt2 (tail : List Token) : statement (halfStmtTokens2 ++ tail) = some (halfStmt2, tail) := by rfl
def halfStmtTokens3 : List Token := ["x", "&=", "(", "uint64_t", ")", "t", "-", "1", ";"].map String.toList
def halfStmt3 : Stmt := .update "x".toList .band (.bin .sub (.cast .u64 (.var "t".toList)) (.literal .i32 1))
theorem halfstmt3 (tail : List Token) : statement (halfStmtTokens3 ++ tail) = some (halfStmt3, tail) := by rfl
def halfStmtTokens4 : List Token := ["return", "x", ";"].map String.toList
def halfStmt4 : Stmt := .ret (.var "x".toList)
theorem halfstmt4 (tail : List Token) : statement (halfStmtTokens4 ++ tail) = some (halfStmt4, tail) := by rfl
def doubleStmtTokens0 : List Token := ["x", "+=", "(", "uint64_t", ")", "(", "(", "(", "(", "unsigned", ")", "(", "x", ">>", "52", ")", "&", "0x7FFU", ")", "+", "0x7FFU", ")", ">>", "11", ")", "<<", "52", ";"].map String.toList
def doubleStmt0 : Stmt := .update "x".toList .add (.bin .shl (.cast .u64 (.bin .shr (.bin .add (.bin .band (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .u32 2047)) (.literal .u32 2047)) (.literal .i32 11))) (.literal .i32 52))
theorem doublestmt0 (tail : List Token) : statement (doubleStmtTokens0 ++ tail) = some (doubleStmt0, tail) := by rfl
def doubleStmtTokens1 : List Token := ["return", "x", ";"].map String.toList
def doubleStmt1 : Stmt := .ret (.var "x".toList)
theorem doublestmt1 (tail : List Token) : statement (doubleStmtTokens1 ++ tail) = some (doubleStmt1, tail) := by rfl
end B20.Fpr.Parsed
