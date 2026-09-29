import B20.C.Scalar
namespace B20.Fpr.Parsed
open B20.C.Scalar
def packProgram : Function := { name := "FPR".toList, result := .u64, params := [(.i32, "s".toList), (.i32, "e".toList), (.u64, "m".toList)],
  body := [
    .declare .u64 ["x".toList],
    .declare .u32 ["t".toList],
    .declare .u32 ["f".toList],
    .update "e".toList .add (.literal .i32 1076),
    .assign "t".toList (.bin .shr (.cast .u32 (.var "e".toList)) (.literal .i32 31)),
    .update "m".toList .band (.bin .sub (.cast .u64 (.var "t".toList)) (.literal .i32 1)),
    .assign "t".toList (.cast .u32 (.bin .shr (.var "m".toList) (.literal .i32 54))),
    .update "e".toList .band (.neg (.cast .i32 (.var "t".toList))),
    .assign "x".toList (.bin .add (.bin .bor (.bin .shl (.cast .u64 (.var "s".toList)) (.literal .i32 63)) (.bin .shr (.var "m".toList) (.literal .i32 2))) (.bin .shl (.cast .u64 (.cast .u32 (.var "e".toList))) (.literal .i32 52))),
    .assign "f".toList (.bin .band (.cast .u32 (.var "m".toList)) (.literal .u32 7)),
    .update "x".toList .add (.bin .band (.bin .shr (.literal .u32 200) (.var "f".toList)) (.literal .i32 1)),
    .ret (.var "x".toList)
  ] }
def rintProgram : Function := { name := "fpr_rint".toList, result := .i64, params := [(.u64, "x".toList)],
  body := [
    .declare .u64 ["m".toList, "d".toList],
    .declare .i32 ["e".toList],
    .declare .u32 ["s".toList, "dd".toList, "f".toList],
    .assign "m".toList (.bin .band (.bin .bor (.bin .shl (.var "x".toList) (.literal .i32 10)) (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 62))) (.bin .sub (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)) (.literal .i32 1))),
    .assign "e".toList (.bin .sub (.literal .i32 1085) (.bin .band (.cast .i32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .i32 2047))),
    .update "m".toList .band (.neg (.cast .u64 (.bin .shr (.cast .u32 (.bin .sub (.var "e".toList) (.literal .i32 64))) (.literal .i32 31)))),
    .update "e".toList .band (.literal .i32 63),
    .assign "d".toList (.call2 "fpr_ulsh".toList (.var "m".toList) (.bin .sub (.literal .i32 63) (.var "e".toList))),
    .assign "dd".toList (.bin .bor (.cast .u32 (.var "d".toList)) (.bin .band (.cast .u32 (.bin .shr (.var "d".toList) (.literal .i32 32))) (.literal .i32 536870911))),
    .assign "f".toList (.bin .bor (.cast .u32 (.bin .shr (.var "d".toList) (.literal .i32 61))) (.bin .shr (.bin .bor (.var "dd".toList) (.neg (.var "dd".toList))) (.literal .i32 31))),
    .assign "m".toList (.bin .add (.call2 "fpr_ursh".toList (.var "m".toList) (.var "e".toList)) (.cast .u64 (.bin .band (.bin .shr (.literal .u32 200) (.var "f".toList)) (.literal .u32 1)))),
    .assign "s".toList (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 63))),
    .ret (.bin .add (.bin .xor (.cast .i64 (.var "m".toList)) (.neg (.cast .i64 (.var "s".toList)))) (.cast .i64 (.var "s".toList)))
  ] }
def floorProgram : Function := { name := "fpr_floor".toList, result := .i64, params := [(.u64, "x".toList)],
  body := [
    .declare .u64 ["t".toList, "mask".toList],
    .declare .i64 ["xi".toList],
    .declare .i32 ["e".toList, "cc".toList],
    .assign "e".toList (.bin .band (.cast .i32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .i32 2047)),
    .assign "t".toList (.bin .shr (.var "x".toList) (.literal .i32 63)),
    .assign "xi".toList (.cast .i64 (.bin .band (.bin .bor (.bin .shl (.var "x".toList) (.literal .i32 10)) (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 62))) (.bin .sub (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)) (.literal .i32 1)))),
    .assign "xi".toList (.bin .add (.bin .xor (.var "xi".toList) (.neg (.cast .i64 (.var "t".toList)))) (.cast .i64 (.var "t".toList))),
    .assign "cc".toList (.bin .sub (.literal .i32 1085) (.var "e".toList)),
    .assign "xi".toList (.call2 "fpr_irsh".toList (.var "xi".toList) (.bin .band (.var "cc".toList) (.literal .i32 63))),
    .assign "mask".toList (.neg (.cast .u64 (.bin .shr (.cast .u32 (.bin .sub (.literal .i32 63) (.var "cc".toList))) (.literal .i32 31)))),
    .assign "xi".toList (.cast .i64 (.bin .bor (.bin .band (.cast .u64 (.var "xi".toList)) (.bitNot (.var "mask".toList))) (.bin .band (.neg (.var "t".toList)) (.var "mask".toList)))),
    .ret (.cast .i64 (.var "xi".toList))
  ] }
def subProgram : Function := { name := "fpr_sub".toList, result := .u64, params := [(.u64, "x".toList), (.u64, "y".toList)],
  body := [
    .update "y".toList .xor (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)),
    .ret (.call2 "fpr_add".toList (.var "x".toList) (.var "y".toList))
  ] }
def negProgram : Function := { name := "fpr_neg".toList, result := .u64, params := [(.u64, "x".toList)],
  body := [
    .update "x".toList .xor (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 63)),
    .ret (.var "x".toList)
  ] }
def halfProgram : Function := { name := "fpr_half".toList, result := .u64, params := [(.u64, "x".toList)],
  body := [
    .declare .u32 ["t".toList],
    .update "x".toList .sub (.bin .shl (.cast .u64 (.literal .i32 1)) (.literal .i32 52)),
    .assign "t".toList (.bin .shr (.bin .add (.bin .band (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .i32 2047)) (.literal .i32 1)) (.literal .i32 11)),
    .update "x".toList .band (.bin .sub (.cast .u64 (.var "t".toList)) (.literal .i32 1)),
    .ret (.var "x".toList)
  ] }
def doubleProgram : Function := { name := "fpr_double".toList, result := .u64, params := [(.u64, "x".toList)],
  body := [
    .update "x".toList .add (.bin .shl (.cast .u64 (.bin .shr (.bin .add (.bin .band (.cast .u32 (.bin .shr (.var "x".toList) (.literal .i32 52))) (.literal .u32 2047)) (.literal .u32 2047)) (.literal .i32 11))) (.literal .i32 52)),
    .ret (.var "x".toList)
  ] }
end B20.Fpr.Parsed
