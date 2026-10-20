import Source3.FprPrimitives
namespace FT1536.Source3.FprScaledAST

def scaledCode : FprPrimitives.Function := {
name := ['f', 'p', 'r', '_', 's', 'c', 'a', 'l', 'e', 'd']
result := B20.C.Ty.u64
params := [(B20.C.Ty.i64, ['i']), (B20.C.Ty.i32, ['s', 'c'])]
body := [
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.i32) [['s'], ['e']])),
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u32) [['t']])),
(.scalar (FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u64) [['m']])),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['s']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.i32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['i']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['i']
  (B20.C.BinOp.xor)
  (FT1536.Source3.CLogic.Expr.neg
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.i64) (FT1536.Source3.CLogic.Expr.var ['s']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['i'] (B20.C.BinOp.add) (FT1536.Source3.CLogic.Expr.var ['s']))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['m']
  (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['i'])))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['e']
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.add)
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 9)
    (FT1536.Source3.CLogic.Expr.var ['s', 'c'])))),
(.norm ['m'] ['e']),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['m']
  (B20.C.BinOp.bor)
  (FT1536.Source3.CLogic.Expr.bin
    (B20.C.BinOp.add)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.band)
      (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u32) (FT1536.Source3.CLogic.Expr.var ['m']))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 511))
    (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 511)))),
(.scalar (FT1536.Source3.CLogic.Stmt.update ['m'] (B20.C.BinOp.shr) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 9))),
(.scalar (FT1536.Source3.CLogic.Stmt.assign
  ['t']
  (FT1536.Source3.CLogic.Expr.cast
    (B20.C.Ty.u32)
    (FT1536.Source3.CLogic.Expr.bin
      (B20.C.BinOp.shr)
      (FT1536.Source3.CLogic.Expr.cast
        (B20.C.Ty.u64)
        (FT1536.Source3.CLogic.Expr.bin
          (B20.C.BinOp.bor)
          (FT1536.Source3.CLogic.Expr.var ['i'])
          (FT1536.Source3.CLogic.Expr.neg (FT1536.Source3.CLogic.Expr.var ['i']))))
      (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['m']
  (B20.C.BinOp.band)
  (FT1536.Source3.CLogic.Expr.neg
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['t']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.update
  ['e']
  (B20.C.BinOp.band)
  (FT1536.Source3.CLogic.Expr.neg
    (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.i32) (FT1536.Source3.CLogic.Expr.var ['t']))))),
(.scalar (FT1536.Source3.CLogic.Stmt.ret
  (FT1536.Source3.CLogic.Expr.call3
    ['F', 'P', 'R']
    (FT1536.Source3.CLogic.Expr.var ['s'])
    (FT1536.Source3.CLogic.Expr.var ['e'])
    (FT1536.Source3.CLogic.Expr.var ['m']))))
]}

def ofCode : CLogic.Function :=
  { name := ['f', 'p', 'r', '_', 'o', 'f'],
    result := B20.C.Ty.u64,
    params := [(B20.C.Ty.i64, ['i'])],
    body := [FT1536.Source3.CLogic.Stmt.ret
               (FT1536.Source3.CLogic.Expr.call2
                 ['f', 'p', 'r', '_', 's', 'c', 'a', 'l', 'e', 'd']
                 (FT1536.Source3.CLogic.Expr.var ['i'])
                 (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 0))] }
def normCode : List CLogic.Stmt := [FT1536.Source3.CLogic.Stmt.declare (B20.C.Ty.u32) [['n', 't']],
 FT1536.Source3.CLogic.Stmt.update ['e'] (B20.C.BinOp.sub) (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63),
 FT1536.Source3.CLogic.Stmt.assign
   ['n', 't']
   (FT1536.Source3.CLogic.Expr.cast
     (B20.C.Ty.u32)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.shr)
       (FT1536.Source3.CLogic.Expr.var ['m'])
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
   ['m']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['m'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['m'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 32)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e']
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
       (FT1536.Source3.CLogic.Expr.var ['m'])
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
   ['m']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['m'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['m'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 16)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e']
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
       (FT1536.Source3.CLogic.Expr.var ['m'])
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
   ['m']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['m'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['m'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 8)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e']
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
       (FT1536.Source3.CLogic.Expr.var ['m'])
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
   ['m']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['m'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['m'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 4)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e']
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
       (FT1536.Source3.CLogic.Expr.var ['m'])
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
   ['m']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['m'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['m'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 2)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e']
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
       (FT1536.Source3.CLogic.Expr.var ['m'])
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 63))),
 FT1536.Source3.CLogic.Stmt.update
   ['m']
   (B20.C.BinOp.xor)
   (FT1536.Source3.CLogic.Expr.bin
     (B20.C.BinOp.band)
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.xor)
       (FT1536.Source3.CLogic.Expr.var ['m'])
       (FT1536.Source3.CLogic.Expr.bin
         (B20.C.BinOp.shl)
         (FT1536.Source3.CLogic.Expr.var ['m'])
         (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1)))
     (FT1536.Source3.CLogic.Expr.bin
       (B20.C.BinOp.sub)
       (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.u64) (FT1536.Source3.CLogic.Expr.var ['n', 't']))
       (FT1536.Source3.CLogic.Expr.literal (B20.C.Ty.i32) 1))),
 FT1536.Source3.CLogic.Stmt.update
   ['e']
   (B20.C.BinOp.add)
   (FT1536.Source3.CLogic.Expr.cast (B20.C.Ty.i32) (FT1536.Source3.CLogic.Expr.var ['n', 't']))]
end FT1536.Source3.FprScaledAST
