import Source3.KeygenMakeBindingPart10

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

theorem node299_source : Body node299 node299Tokens := by exact .cons _ _ _ _ node003_source node298_source

def node300 : Stmt := (.seq node002 node299)
def node300Tokens : List B20.C.Token := node002Tokens++node299Tokens
theorem node300_source : Body node300 node300Tokens := by exact .cons _ _ _ _ node002_source node299_source

def node301 : Stmt := (.seq node001 node300)
def node301Tokens : List B20.C.Token := node001Tokens++node300Tokens
theorem node301_source : Body node301 node301Tokens := by exact .cons _ _ _ _ node001_source node300_source

def node302 : Stmt := (.seq node000 node301)
def node302Tokens : List B20.C.Token := node000Tokens++node301Tokens
theorem node302_source : Body node302 node302Tokens := by exact .cons _ _ _ _ node000_source node301_source

end FT1536.Source3.KeygenMakeBinding
