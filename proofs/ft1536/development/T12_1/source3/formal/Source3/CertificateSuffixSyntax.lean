import Source3.CertificateQSquared
import Source3.LeafCertificateSuffix
import Source3.StableTopSyntax

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateSuffixSyntax
open B20.C

structure Reverse where
  index : Name
  bound : Name
  destination : CLogic.Expr
  callee : Name
  numerator : Name
  deriving DecidableEq, Repr
structure Code where
  leavesAlias : Name
  scratchBase : Name
  scratchCount : Name
  initializer : CLogic.Expr
  reverse : Reverse
  scan : LeafScan.Loop
  ret : CLogic.Stmt
  deriving DecidableEq, Repr

def words := StableBinarySourceSyntax.words
def tokens := StableTopSyntax.tokens
def parseReverse (lines : List String) : Option Reverse := do
  let [['f','o','r'],['('],idx,['='],['0'],[';'],idx2,['<'],bound,[';'],idx3,['+','+'],[')'],['{']] ← words lines 4 1 | none
  if idx != idx2 || idx != idx3 then none else do
  let ['l','e','a','v','e','s']::['[']::rest ← words lines 5 2 | none
  let (dest,rest) ← CLogicParser.expression 16 rest
  let [ [']'],['='],['f','t','_','s','t','a','b','l','e','_','p','o','s','i','t','i','v','e','_','k','e','y','g','e','n'],['('],
      callee,['('],num,[','],['l','e','a','v','e','s'],['['],readIdx,[']'],[')'],[','],['&'],['b','a','d'],[')'],[';']] := rest | none
  if readIdx != idx then none else pure ⟨idx,bound,dest,callee,num⟩

def parse (lines : List String) : Option Code := do
  if lines.length != 20 then none else do
  let [['l','e','a','v','e','s'],['='],aliasName,[';']] ← words lines 0 1 | none
  let [['s','c','r','a','t','c','h'],['='],base,['+'],count,[';']] ← words lines 1 1 | none
  if (← words lines 2 1) != (← tokens "ft_stable_top_branch_keygen(g00, leaves, scratch, &bad);") then none else do
  let (.assign ['q','_','s','q','u','a','r','e','d'] init,[]) ← CLogicParser.statement (← words lines 3 1) | none
  let reverse ← parseReverse lines
  if (← words lines 7 1) != [['}']] then none else do
  let scan ← LeafScan.parse ((lines.drop 8).take 11 |>.flatMap String.toList)
  let (ret,[]) ← LeafCertificateSuffix.parseReturn ((lines[19]!).toList) | none
  pure ⟨aliasName,base,count,init,reverse,scan,ret⟩

def expected : Code := ⟨"t3".toList,"leaves".toList,"n".toList,
  .call1 "fpr_of".toList (.var "FT1536_KEYGEN_Q_SQUARED".toList),
  ⟨['u'],"hn".toList,.bin .sub (.bin .sub (.var ['n']) (.literal .i32 1)) (.var ['u']),
    "fpr_div".toList,"q_squared".toList⟩,LeafScan.program,LeafCertificateSuffix.returnProgram⟩
def source := parse ((Pinned.keygenLines.drop 7756).take 20)
theorem pinned_source : source=some expected := by rfl

end FT1536.Source3.CertificateSuffixSyntax

#print axioms FT1536.Source3.CertificateSuffixSyntax.pinned_source
