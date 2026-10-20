import Source3.FprPrimitives
namespace FT1536.Source3.FprAST

def addCode : FprPrimitives.Function := {
name := ['f', 'p', 'r', '_', 'a', 'd', 'd']
result := B20.C.Ty.u64
params := [(B20.C.Ty.u64, ['x']), (B20.C.Ty.u64, ['y'])]
body := [
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u64) [['m'], ['x', 'u'], ['y', 'u'], ['z', 'a']])),
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u32) [['c', 's']])),
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.i32) [['e', 'x'], ['e', 'y'], ['s', 'x'], ['s', 'y'], ['c', 'c']])),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['m']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.sub)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shl)
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['z', 'a']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.sub)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['x'])
      (FT1536.Source3.CLogic.Expr.var ['m']))
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['y'])
      (FT1536.Source3.CLogic.Expr.var ['m']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['c', 's']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.bor)
    (FT1536.Source3.CLogic.Expr.cast
      (B20.C.Ty.u32)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.shr)
        (FT1536.Source3.CLogic.Expr.var ['z', 'a'])
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63)))
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.sub)
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.u32) 1)
        (FT1536.Source3.CLogic.Expr.cast
          (B20.C.Ty.u32)
          (FT1536.Source3.CLogic.Expr.bin
            (B20.C.BinOp.shr)
            (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['z', 'a']))
            (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))))
      (FT1536.Source3.CLogic.Expr.cast
        (B20.C.Ty.u32)
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.shr)
          (FT1536.Source3.CLogic.Expr.var ['x'])
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['m']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.xor)
      (FT1536.Source3.CLogic.Expr.var ['x'])
      (FT1536.Source3.CLogic.Expr.var ['y']))
    (FT1536.Source3.CLogic.Expr.neg
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['c', 's'])))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['x'] (B20.C.BinOp.xor) (FT1536.Source3.CLogic.Expr.var ['m']))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['y'] (B20.C.BinOp.xor) (FT1536.Source3.CLogic.Expr.var ['m']))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e', 'x']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['x'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['s', 'x']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.var ['e', 'x'])
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 11)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['e', 'x'] (B20.C.BinOp.band) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['m']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shl)
    (FT1536.Source3.CLogic.Expr.cast
      (B20.C.Ty.u64)
      (FT1536.Source3.CLogic.Expr.cast
        (B20.C.Ty.u32)
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.shr)
          (FT1536.Source3.CLogic.Expr.bin
            (B20.C.BinOp.add)
            (FT1536.Source3.CLogic.Expr.var ['e', 'x'])
            (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 11))))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['x', 'u']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shl)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.bor)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.band)
        (FT1536.Source3.CLogic.Expr.var ['x'])
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.sub)
          (FT1536.Source3.CLogic.Expr.bin
            (B20.C.BinOp.shl)
            (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
            (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
      (FT1536.Source3.CLogic.Expr.var ['m']))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 3)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['e', 'x'] (B20.C.BinOp.sub) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1078))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e', 'y']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['y'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['s', 'y']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.var ['e', 'y'])
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 11)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['e', 'y'] (B20.C.BinOp.band) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['m']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shl)
    (FT1536.Source3.CLogic.Expr.cast
      (B20.C.Ty.u64)
      (FT1536.Source3.CLogic.Expr.cast
        (B20.C.Ty.u32)
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.shr)
          (FT1536.Source3.CLogic.Expr.bin
            (B20.C.BinOp.add)
            (FT1536.Source3.CLogic.Expr.var ['e', 'y'])
            (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 11))))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['y', 'u']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shl)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.bor)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.band)
        (FT1536.Source3.CLogic.Expr.var ['y'])
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.sub)
          (FT1536.Source3.CLogic.Expr.bin
            (B20.C.BinOp.shl)
            (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
            (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
      (FT1536.Source3.CLogic.Expr.var ['m']))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 3)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['e', 'y'] (B20.C.BinOp.sub) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1078))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['c', 'c']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.sub)
    (FT1536.Source3.CLogic.Expr.var ['e', 'x'])
    (FT1536.Source3.CLogic.Expr.var ['e', 'y'])))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['y', 'u']
  (B20.C.BinOp.band)
  (FT1536.Source3.CLogic.Expr.neg
    (FT1536.Source3.CLogic.Expr.cast
      (B20.C.Ty.u64)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.shr)
        (FT1536.Source3.CLogic.Expr.cast
          (B20.C.Ty.u32)
          (FT1536.Source3.CLogic.Expr.bin
            (B20.C.BinOp.sub)
            (FT1536.Source3.CLogic.Expr.var ['c', 'c'])
            (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 60)))
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['c', 'c'] (B20.C.BinOp.band) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['m']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.sub)
    (FT1536.Source3.CLogic.Expr.call2
      ['f', 'p', 'r', '_', 'u', 'l', 's', 'h']
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)
      (FT1536.Source3.CLogic.Expr.var ['c', 'c']))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['y', 'u']
  (B20.C.BinOp.bor)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.add)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['y', 'u'])
      (FT1536.Source3.CLogic.Expr.var ['m']))
    (FT1536.Source3.CLogic.Expr.var ['m'])))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['y', 'u']
  (FT1536.Source3.CLogic.Expr.call2
    ['f', 'p', 'r', '_', 'u', 'r', 's', 'h']
    (FT1536.Source3.CLogic.Expr.var ['y', 'u'])
    (FT1536.Source3.CLogic.Expr.var ['c', 'c'])))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['x', 'u']
  (B20.C.BinOp.add)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.sub)
    (FT1536.Source3.CLogic.Expr.var ['y', 'u'])
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.shl)
        (FT1536.Source3.CLogic.Expr.var ['y', 'u'])
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
      (FT1536.Source3.CLogic.Expr.neg
        (FT1536.Source3.CLogic.Expr.cast
          (B20.C.Ty.u64)
          (FT1536.Source3.CLogic.Expr.bin
            (B20.C.BinOp.xor)
            (FT1536.Source3.CLogic.Expr.var ['s', 'x'])
            (FT1536.Source3.CLogic.Expr.var ['s', 'y'])))))))),
(.norm ['x', 'u'] ['e', 'x']),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['x', 'u']
  (B20.C.BinOp.bor)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.add)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['x', 'u']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 511))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 511)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['x', 'u'] (B20.C.BinOp.shr) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 9))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['e', 'x'] (B20.C.BinOp.add) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 9))),
(.scalar (FT1536.Source3.CLogic.Stmt.ret
  (FT1536.Source3.CLogic.Expr.call3
    ['F', 'P', 'R']
    (FT1536.Source3.CLogic.Expr.var ['s', 'x'])
    (FT1536.Source3.CLogic.Expr.var ['e', 'x'])
    (FT1536.Source3.CLogic.Expr.var ['x', 'u']))))
]}

def mulCode : FprPrimitives.Function := {
name := ['f', 'p', 'r', '_', 'm', 'u', 'l']
result := B20.C.Ty.u64
params := [(B20.C.Ty.u64, ['x']), (B20.C.Ty.u64, ['y'])]
body := [
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u64) [['x', 'u'], ['y', 'u'], ['w'], ['z', 'u'], ['z', 'v']])),
(.scalar (FT1536.Source3.CLogic.Stmt.declare
  (B20.C.Ty.u32)
  [['x', '0'], ['x', '1'], ['y', '0'], ['y', '1'], ['z', '0'], ['z', '1'], ['z', '2']])),
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.i32) [['e', 'x'], ['e', 'y'], ['d'], ['e'], ['s']])),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['x', 'u']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.bor)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['x'])
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.sub)
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.shl)
          (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shl)
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['y', 'u']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.bor)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['y'])
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.sub)
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.shl)
          (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shl)
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['x', '0']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['x', 'u']))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 33554431)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['x', '1']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.u32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 25))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['y', '0']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['y', 'u']))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 33554431)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['y', '1']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.u32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['y', 'u'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 25))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['w']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.mul)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['x', '0']))
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['y', '0']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['z', '0']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['w']))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 33554431)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['z', '1']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.u32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['w'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 25))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['w']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.mul)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['x', '0']))
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['y', '1']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['z', '1']
  (B20.C.BinOp.add)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['w']))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 33554431)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['z', '2']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.u32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['w'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 25))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['w']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.mul)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['x', '1']))
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['y', '0']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['z', '1']
  (B20.C.BinOp.add)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['w']))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 33554431)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['z', '2']
  (B20.C.BinOp.add)
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.u32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['w'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 25))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['z', 'u']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.mul)
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['x', '1']))
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['y', '1']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['z', '2']
  (B20.C.BinOp.add)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.var ['z', '1'])
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 25)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['z', '1']
  (B20.C.BinOp.band)
  (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 33554431))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['z', 'u'] (B20.C.BinOp.add) (FT1536.Source3.CLogic.Expr.var ['z', '2']))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['z', 'u']
  (B20.C.BinOp.bor)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.add)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.bor)
        (FT1536.Source3.CLogic.Expr.var ['z', '0'])
        (FT1536.Source3.CLogic.Expr.var ['z', '1']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 33554431))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 25)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['z', 'v']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.bor)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['z', 'u'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['z', 'u'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['w']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.var ['z', 'u'])
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 55)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['z', 'u']
  (B20.C.BinOp.xor)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.xor)
      (FT1536.Source3.CLogic.Expr.var ['z', 'u'])
      (FT1536.Source3.CLogic.Expr.var ['z', 'v']))
    (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['w']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e', 'x']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.shr)
        (FT1536.Source3.CLogic.Expr.var ['x'])
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e', 'y']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.shr)
        (FT1536.Source3.CLogic.Expr.var ['y'])
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.add)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.sub)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.add)
        (FT1536.Source3.CLogic.Expr.var ['e', 'x'])
        (FT1536.Source3.CLogic.Expr.var ['e', 'y']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2100))
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.i32) (FT1536.Source3.CLogic.Expr.var ['w']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['s']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.xor)
        (FT1536.Source3.CLogic.Expr.var ['x'])
        (FT1536.Source3.CLogic.Expr.var ['y']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['d']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.add)
        (FT1536.Source3.CLogic.Expr.var ['e', 'x'])
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.add)
        (FT1536.Source3.CLogic.Expr.var ['e', 'y'])
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047)))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 11)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['z', 'u']
  (B20.C.BinOp.band)
  (FT1536.Source3.CLogic.Expr.neg
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['d']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.ret
  (FT1536.Source3.CLogic.Expr.call3
    ['F', 'P', 'R']
    (FT1536.Source3.CLogic.Expr.var ['s'])
    (FT1536.Source3.CLogic.Expr.var ['e'])
    (FT1536.Source3.CLogic.Expr.var ['z', 'u']))))
]}

def divCode : FprPrimitives.Function := {
name := ['f', 'p', 'r', '_', 'd', 'i', 'v']
result := B20.C.Ty.u64
params := [(B20.C.Ty.u64, ['x']), (B20.C.Ty.u64, ['y'])]
body := [
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u64) [['x', 'u'], ['y', 'u'], ['q'], ['q', '2'], ['w']])),
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.i32) [['i'], ['e', 'x'], ['e', 'y'], ['e'], ['d'], ['s']])),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['x', 'u']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.bor)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['x'])
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.sub)
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.shl)
          (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shl)
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['y', 'u']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.bor)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['y'])
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.sub)
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.shl)
          (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
          (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shl)
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign ['q'] (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 0))),
(.forInc ['i'] 55 [
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u64) [['b']])),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['b']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.sub)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.sub)
        (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
        (FT1536.Source3.CLogic.Expr.var ['y', 'u']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['x', 'u']
  (B20.C.BinOp.sub)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.var ['b'])
    (FT1536.Source3.CLogic.Expr.var ['y', 'u'])))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['q']
  (B20.C.BinOp.bor)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.var ['b'])
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['x', 'u'] (B20.C.BinOp.shl) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['q'] (B20.C.BinOp.shl) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
]),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['q']
  (B20.C.BinOp.bor)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.bor)
      (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
      (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['x', 'u'])))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63)))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['q', '2']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.bor)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.var ['q'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.var ['q'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['w']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.var ['q'])
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 55)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['q']
  (B20.C.BinOp.xor)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.band)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.xor)
      (FT1536.Source3.CLogic.Expr.var ['q'])
      (FT1536.Source3.CLogic.Expr.var ['q', '2']))
    (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['w']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e', 'x']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.shr)
        (FT1536.Source3.CLogic.Expr.var ['x'])
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e', 'y']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.shr)
        (FT1536.Source3.CLogic.Expr.var ['y'])
        (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.add)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.sub)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.sub)
        (FT1536.Source3.CLogic.Expr.var ['e', 'x'])
        (FT1536.Source3.CLogic.Expr.var ['e', 'y']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 55))
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.i32) (FT1536.Source3.CLogic.Expr.var ['w']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['s']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.bin
        (B20.C.BinOp.xor)
        (FT1536.Source3.CLogic.Expr.var ['x'])
        (FT1536.Source3.CLogic.Expr.var ['y']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['d']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.shr)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.add)
      (FT1536.Source3.CLogic.Expr.var ['e', 'x'])
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2047))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 11)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['s'] (B20.C.BinOp.band) (FT1536.Source3.CLogic.Expr.var ['d']))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['e']
  (B20.C.BinOp.band)
  (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['d'])))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['q']
  (B20.C.BinOp.band)
  (FT1536.Source3.CLogic.Expr.neg
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['d']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.ret
  (FT1536.Source3.CLogic.Expr.call3
    ['F', 'P', 'R']
    (FT1536.Source3.CLogic.Expr.var ['s'])
    (FT1536.Source3.CLogic.Expr.var ['e'])
    (FT1536.Source3.CLogic.Expr.var ['q']))))
]}

def urshCode : CLogic.Function :=
  { name := ['f', 'p', 'r', '_', 'u', 'r', 's', 'h'],
    result := B20.C.Ty.u64,
    params := [(B20.C.Ty.u64, ['x']), (B20.C.Ty.i32, ['n'])],
    body := [FT1536.Source3.CLogic.Stmt.update
               ['x']
               (B20.C.BinOp.xor)
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.band)
                 (FT1536.Source3.CLogic.Expr.bin
                   (B20.C.BinOp.xor)
                   (FT1536.Source3.CLogic.Expr.var ['x'])
                   (FT1536.Source3.CLogic.Expr.bin
                     (B20.C.BinOp.shr)
                     (FT1536.Source3.CLogic.Expr.var ['x'])
                     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 32)))
                 (FT1536.Source3.CLogic.Expr.neg
                   (FT1536.Source3.CLogic.Expr.cast
                     (B20.C.Ty.u64)
                     (FT1536.Source3.CLogic.Expr.bin
                       (B20.C.BinOp.shr)
                       (FT1536.Source3.CLogic.Expr.var ['n'])
                       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 5))))),
             FT1536.Source3.CLogic.Stmt.ret
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.shr)
                 (FT1536.Source3.CLogic.Expr.var ['x'])
                 (FT1536.Source3.CLogic.Expr.bin
                   (B20.C.BinOp.band)
                   (FT1536.Source3.CLogic.Expr.var ['n'])
                   (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)))] }
def ulshCode : CLogic.Function :=
  { name := ['f', 'p', 'r', '_', 'u', 'l', 's', 'h'],
    result := B20.C.Ty.u64,
    params := [(B20.C.Ty.u64, ['x']), (B20.C.Ty.i32, ['n'])],
    body := [FT1536.Source3.CLogic.Stmt.update
               ['x']
               (B20.C.BinOp.xor)
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.band)
                 (FT1536.Source3.CLogic.Expr.bin
                   (B20.C.BinOp.xor)
                   (FT1536.Source3.CLogic.Expr.var ['x'])
                   (FT1536.Source3.CLogic.Expr.bin
                     (B20.C.BinOp.shl)
                     (FT1536.Source3.CLogic.Expr.var ['x'])
                     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 32)))
                 (FT1536.Source3.CLogic.Expr.neg
                   (FT1536.Source3.CLogic.Expr.cast
                     (B20.C.Ty.u64)
                     (FT1536.Source3.CLogic.Expr.bin
                       (B20.C.BinOp.shr)
                       (FT1536.Source3.CLogic.Expr.var ['n'])
                       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 5))))),
             FT1536.Source3.CLogic.Stmt.ret
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.shl)
                 (FT1536.Source3.CLogic.Expr.var ['x'])
                 (FT1536.Source3.CLogic.Expr.bin
                   (B20.C.BinOp.band)
                   (FT1536.Source3.CLogic.Expr.var ['n'])
                   (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)))] }
def packCode : CLogic.Function :=
  { name := ['F', 'P', 'R'],
    result := B20.C.Ty.u64,
    params := [(B20.C.Ty.i32, ['s']), (B20.C.Ty.i32, ['e']), (B20.C.Ty.u64, ['m'])],
    body := [FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u64) [['x']],
             FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u32) [['t']],
             FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u32) [['f']],
             FT1536.Source3.CLogic.Stmt.update
               ['e']
               (B20.C.BinOp.add)
               (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1076),
             FT1536.Source3.CLogic.Stmt.assign
               ['t']
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.shr)
                 (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['e']))
                 (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)),
             FT1536.Source3.CLogic.Stmt.update
               ['m']
               (B20.C.BinOp.band)
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.sub)
                 (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['t']))
                 (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)),
             FT1536.Source3.CLogic.Stmt.assign
               ['t']
               (FT1536.Source3.CLogic.Expr.cast
                 (B20.C.Ty.u32)
                 (FT1536.Source3.CLogic.Expr.bin
                   (B20.C.BinOp.shr)
                   (FT1536.Source3.CLogic.Expr.var ['m'])
                   (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 54))),
             FT1536.Source3.CLogic.Stmt.update
               ['e']
               (B20.C.BinOp.band)
               (FT1536.Source3.CLogic.Expr.neg
                 (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.i32) (FT1536.Source3.CLogic.Expr.var ['t']))),
             FT1536.Source3.CLogic.Stmt.assign
               ['x']
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.add)
                 (FT1536.Source3.CLogic.Expr.bin
                   (B20.C.BinOp.bor)
                   (FT1536.Source3.CLogic.Expr.bin
                     (B20.C.BinOp.shl)
                     (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['s']))
                     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))
                   (FT1536.Source3.CLogic.Expr.bin
                     (B20.C.BinOp.shr)
                     (FT1536.Source3.CLogic.Expr.var ['m'])
                     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2)))
                 (FT1536.Source3.CLogic.Expr.bin
                   (B20.C.BinOp.shl)
                   (FT1536.Source3.CLogic.Expr.cast
                     (B20.C.Ty.u64)
                     (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['e'])))
                   (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 52))),
             FT1536.Source3.CLogic.Stmt.assign
               ['f']
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.band)
                 (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['m']))
                 (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.u32) 7)),
             FT1536.Source3.CLogic.Stmt.update
               ['x']
               (B20.C.BinOp.add)
               (FT1536.Source3.CLogic.Expr.bin
                 (B20.C.BinOp.band)
                 (FT1536.Source3.CLogic.Expr.bin
                   (B20.C.BinOp.shr)
                   (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.u32) 200)
                   (FT1536.Source3.CLogic.Expr.var ['f']))
                 (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)),
             FT1536.Source3.CLogic.Stmt.ret (FT1536.Source3.CLogic.Expr.var ['x'])] }
def normCode : List CLogic.Stmt := [FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u32) [['n', 't']],
 FT1536.Source3.CLogic.Stmt.update ['e', 'x'] (B20.C.BinOp.sub) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.u32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shr)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 32))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.shr)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.bor)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['n', 't'])))
     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)),
 FT1536.Source3.CLogic.Stmt.update
   ['x', 'u']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 32)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e', 'x']
   (B20.C.BinOp.add)
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.i32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shl)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 5))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.u32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shr)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 48))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.shr)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.bor)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['n', 't'])))
     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)),
 FT1536.Source3.CLogic.Stmt.update
   ['x', 'u']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 16)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e', 'x']
   (B20.C.BinOp.add)
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.i32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shl)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 4))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.u32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shr)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 56))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.shr)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.bor)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['n', 't'])))
     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)),
 FT1536.Source3.CLogic.Stmt.update
   ['x', 'u']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 8)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e', 'x']
   (B20.C.BinOp.add)
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.i32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shl)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 3))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.u32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shr)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 60))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.shr)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.bor)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['n', 't'])))
     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)),
 FT1536.Source3.CLogic.Stmt.update
   ['x', 'u']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 4)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e', 'x']
   (B20.C.BinOp.add)
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.i32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shl)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.u32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shr)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 62))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.shr)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.bor)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['n', 't'])))
     (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 31)),
 FT1536.Source3.CLogic.Stmt.update
   ['x', 'u']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e', 'x']
   (B20.C.BinOp.add)
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.i32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shl)
       (FT1536.Source3.CLogic.Expr.var ['n', 't'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.u32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shr)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))),
 FT1536.Source3.CLogic.Stmt.update
   ['x', 'u']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['x', 'u'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e', 'x']
   (B20.C.BinOp.add)
   (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.i32) (FT1536.Source3.CLogic.Expr.var ['n', 't']))]
end FT1536.Source3.FprAST
