import Source3.StableBinaryFpr

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.StableBinarySourceSyntax
open B20.C FT1536.Source3

abbrev Name := B20.C.Name

def words (lines : List String) (i count : Nat) : Option (List Token) := do
  let chars := ((lines.drop i).take count).flatMap String.toList
  LeafScan.tokenize (chars.length+1) chars

def natural : Token → Option Nat
  | t => match B20.C.Scalar.number t with
    | some (.literal .i32 n) => some n
    | _ => none

structure ReadCheck where
  destination : Name
  positive : Name
  array : Name
  counter : Name
  shift : Nat
  offset : Nat
  bad : Name
  deriving DecidableEq, Repr

def parseReadCheck : List Token → Option ReadCheck
  | dst :: ['='] :: check :: ['('] :: arr :: ['['] :: ['('] :: u ::
      ['<','<'] :: stride :: [')'] :: ['+'] :: offset :: [']'] ::
      [','] :: bad :: [')'] :: [';'] :: [] => do
      pure ⟨dst,check,arr,u,← natural stride,← natural offset,bad⟩
  | _ => none

structure BinaryCheck where
  destination : Name
  positive : Name
  callee : Name
  left : Name
  right : Name
  bad : Name
  deriving DecidableEq, Repr

def parseBinaryCheck : List Token → Option BinaryCheck
  | dst :: ['='] :: check :: ['('] :: f :: ['('] :: a :: [','] :: b ::
      [')'] :: [','] :: bad :: [')'] :: [';'] :: [] =>
      some ⟨dst,check,f,a,b,bad⟩
  | _ => none

structure FirstStore where
  scratch : Name
  counter : Name
  positive : Name
  half : Name
  input : Name
  bad : Name
  deriving DecidableEq, Repr

def parseFirstStore : List Token → Option FirstStore
  | scratch :: ['['] :: u :: [']'] :: ['='] :: check :: ['('] :: f ::
      ['('] :: input :: [')'] :: [','] :: bad :: [')'] :: [';'] :: [] =>
      some ⟨scratch,u,check,f,input,bad⟩
  | _ => none

structure SecondStore where
  scratch : Name
  counter : Name
  half : Name
  positive : Name
  div : Name
  double : Name
  product : Name
  sum : Name
  bad : Name
  deriving DecidableEq, Repr

def parseSecondStore : List Token → Option SecondStore
  | scratch :: ['['] :: u :: ['+'] :: hn :: [']'] :: ['='] :: check ::
      ['('] :: div :: ['('] :: double :: ['('] :: product :: [')'] ::
      [','] :: sum :: [')'] :: [','] :: bad :: [')'] :: [';'] :: [] =>
      some ⟨scratch,u,hn,check,div,double,product,sum,bad⟩
  | _ => none

structure Code where
  baseSize : Nat
  first : ReadCheck
  second : ReadCheck
  sum : BinaryCheck
  product : BinaryCheck
  firstStore : FirstStore
  secondStore : SecondStore
  deriving DecidableEq, Repr

/- Separate grammar checks for control, copy, and the recursive arguments.
   The expression parsers above *construct* the order and callee graph;
   changing a callee need not fail syntax, but changes this AST. -/
def parse (lines : List String) : Option Code := do
  if lines.length != 24 then none else do
  let signature ← words lines 0 5
  if signature !=
      (← LeafScan.tokenize 256
        ("static void ft_stable_binary_inplace_keygen(fpr *values, size_t n, fpr *scratch, uint32_t *bad) { size_t hn, u;".toList))
    then none else do
  let guard ← words lines 5 1
  let base ← match guard with
    | [['i','f'],['('],['n'],['=','='],literal,[')'],['{']] => natural literal
    | _ => none
  let baseBody ← words lines 6 1
  if baseBody !=
      (← LeafScan.tokenize 256
        "values[0] = ft_stable_positive_keygen(values[0], bad);".toList) then none else do
  if (← words lines 7 2) !=
      (← LeafScan.tokenize 256 "return; }".toList) then none else do
  if (← words lines 9 1) !=
      (← LeafScan.tokenize 256 "hn = n >> 1;".toList) then none else do
  if (← words lines 10 2) !=
      (← LeafScan.tokenize 256 "for (u = 0; u < hn; u ++) { fpr a, b, product, sum;".toList)
    then none else do
  let first ← parseReadCheck (← words lines 12 1)
  let second ← parseReadCheck (← words lines 13 1)
  let sum ← parseBinaryCheck (← words lines 14 1)
  let product ← parseBinaryCheck (← words lines 15 1)
  let firstStore ← parseFirstStore (← words lines 16 1)
  let secondStore ← parseSecondStore (← words lines 17 2)
  if (← words lines 19 1) != [['}']] then none else do
  if (← words lines 20 1) !=
      (← LeafScan.tokenize 256 "memcpy(values, scratch, n * sizeof *values);".toList)
    then none else do
  if (← words lines 21 1) !=
      (← LeafScan.tokenize 256
        "ft_stable_binary_inplace_keygen(values, hn, scratch, bad);".toList) then none else do
  if (← words lines 22 1) !=
      (← LeafScan.tokenize 256
        "ft_stable_binary_inplace_keygen(values + hn, hn, scratch, bad);".toList) then none else do
  if (← words lines 23 1) != [['}']] then none else do
  if first.destination != "a".toList || second.destination != "b".toList ||
      first.array != "values".toList || second.array != "values".toList ||
      first.counter != "u".toList || second.counter != "u".toList ||
      first.positive != "ft_stable_positive_keygen".toList ||
      second.positive != first.positive || second.bad != first.bad ||
      first.bad != "bad".toList || first.shift != 1 || second.shift != 1 ||
      first.offset != 0 || second.offset != 1 ||
      sum.destination != "sum".toList || product.destination != "product".toList ||
      sum.left != "a".toList || sum.right != "b".toList ||
      product.left != sum.left || product.right != sum.right ||
      sum.positive != first.positive || product.positive != first.positive ||
      sum.bad != first.bad || product.bad != first.bad ||
      firstStore.scratch != "scratch".toList || firstStore.counter != "u".toList ||
      firstStore.input != sum.destination || firstStore.bad != first.bad ||
      firstStore.positive != first.positive ||
      secondStore.scratch != firstStore.scratch ||
      secondStore.counter != firstStore.counter || secondStore.half != "hn".toList ||
      secondStore.product != product.destination || secondStore.sum != sum.destination ||
      secondStore.bad != first.bad || secondStore.positive != first.positive
    then none else pure ⟨base,first,second,sum,product,firstStore,secondStore⟩

def source : Option Code := parse ((Pinned.keygenLines.drop 7490).take 24)

def expected : Code :=
  ⟨1,
    ⟨"a".toList,"ft_stable_positive_keygen".toList,"values".toList,"u".toList,1,0,"bad".toList⟩,
    ⟨"b".toList,"ft_stable_positive_keygen".toList,"values".toList,"u".toList,1,1,"bad".toList⟩,
    ⟨"sum".toList,"ft_stable_positive_keygen".toList,"fpr_add".toList,
      "a".toList,"b".toList,"bad".toList⟩,
    ⟨"product".toList,"ft_stable_positive_keygen".toList,"fpr_mul".toList,
      "a".toList,"b".toList,"bad".toList⟩,
    ⟨"scratch".toList,"u".toList,"ft_stable_positive_keygen".toList,
      "fpr_half".toList,"sum".toList,"bad".toList⟩,
    ⟨"scratch".toList,"u".toList,"hn".toList,
      "ft_stable_positive_keygen".toList,"fpr_div".toList,"fpr_double".toList,
      "product".toList,"sum".toList,"bad".toList⟩⟩

theorem pinned_source : source=some expected := by
  unfold source
  rw [FT1536.Source3.StableBinaryPin.pinned]
  decide

end FT1536.Source3.StableBinarySourceSyntax

#check @FT1536.Source3.StableBinarySourceSyntax.pinned_source
#print axioms FT1536.Source3.StableBinarySourceSyntax.pinned_source
