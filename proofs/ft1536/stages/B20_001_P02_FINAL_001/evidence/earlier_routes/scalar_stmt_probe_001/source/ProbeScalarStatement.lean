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
end B20.Fpr.Parsed
