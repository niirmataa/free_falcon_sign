import Source3.KeygenMakeBindingPart08

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

def loop244Middle : List B20.C.Token := ["i","<","4"].map String.toList
def loop244Last : List B20.C.Token := ["i","++"].map String.toList
theorem loop244_initial : initialClause loop244Init loop244First := by rfl
theorem loop244_increment : incrementClause loop244Update loop244Last := by rfl
theorem loop244_condition : Test loop244Test loop244Middle := by exact .present _ _ (by rfl)

def node244 : Stmt := (.loop loop244Init loop244Test loop244Update node243)
def node244Tokens : List B20.C.Token := ["for".toList,['(']]++loop244First++[[';']]++loop244Middle++[[';']]++loop244Last++[[')']]++node243Tokens
theorem node244_source : Statement node244 node244Tokens := by exact .loop _ _ _ _ _ _ _ _ loop244_initial loop244_condition loop244_increment node243_source

def node245 : Stmt := (.write (.unary .dereference (.variable "privkey_len".toList)) .set (.variable "skoff".toList))
def node245Tokens : List B20.C.Token := ["*","privkey_len","=","skoff",";"].map String.toList
theorem node245_source : Statement node245 node245Tokens := by exact .simple _ _ (by rfl)

def node246 : Stmt := (.write (.variable "klen".toList) .set (.unary .dereference (.variable "pubkey_len".toList)))
def node246Tokens : List B20.C.Token := ["klen","=","*","pubkey_len",";"].map String.toList
theorem node246_source : Statement node246 node246Tokens := by exact .simple _ _ (by rfl)

def node247 : Stmt := (.ret (.number .i32 0))
def node247Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node247_source : Statement node247 node247Tokens := by exact .simple _ _ (by rfl)

def node248 : Stmt := .skip
def node248Tokens : List B20.C.Token := []
theorem node248_source : Body node248 node248Tokens := by exact .nil

def node249 : Stmt := (.seq node247 node248)
def node249Tokens : List B20.C.Token := node247Tokens++node248Tokens
theorem node249_source : Body node249 node249Tokens := by exact .cons _ _ _ _ node247_source node248_source

def node250 : Stmt := (.scope node249)
def node250Tokens : List B20.C.Token := [['{']]++node249Tokens++[['}']]
theorem node250_source : Statement node250 node250Tokens := by exact .scope _ _ node249_source

def guard251 : Expr := (.binary .lt (.variable "klen".toList) (.number .i32 1))
def guard251Tokens : List B20.C.Token := ["klen","<","1"].map String.toList
theorem guard251_source : guard guard251 guard251Tokens := by rfl

def node251 : Stmt := (.branch guard251 node250 .skip)
def node251Tokens : List B20.C.Token := ["if".toList,['(']]++guard251Tokens++[[')']]++node250Tokens
theorem node251_source : Statement node251 node251Tokens := by exact .ifOnly _ _ _ _ guard251_source node250_source

def node252 : Stmt := (.write (.index (.cast (.pointer .byte) (.variable "pubkey".toList)) (.number .i32 0)) .set (.binary .add (.binary .shl (.variable "ter".toList) (.number .i32 7)) (.variable "logn".toList)))
def node252Tokens : List B20.C.Token := ["(","(","unsigned","char","*",")","pubkey",")","[","0","]","=","(","ter","<<","7",")","+","logn",";"].map String.toList
theorem node252_source : Statement node252 node252Tokens := by exact .simple _ _ (by rfl)

def node253 : Stmt := (.write (.variable "klen".toList) .set (.call .encodeT (argumentTree [(.binary .add (.cast (.pointer .byte) (.variable "pubkey".toList)) (.number .i32 1)),(.binary .sub (.variable "klen".toList) (.number .i32 1)),(.variable "h".toList),(.variable "logn".toList)])))
def node253Tokens : List B20.C.Token := ["klen","=","falcon_encode_18433","(","(","unsigned","char","*",")","pubkey","+","1",",","klen","-","1",",","h",",","logn",")",";"].map String.toList
theorem node253_source : Statement node253 node253Tokens := by exact .simple _ _ (by rfl)

def node254 : Stmt := .skip
def node254Tokens : List B20.C.Token := []
theorem node254_source : Body node254 node254Tokens := by exact .nil

def node255 : Stmt := (.seq node253 node254)
def node255Tokens : List B20.C.Token := node253Tokens++node254Tokens
theorem node255_source : Body node255 node255Tokens := by exact .cons _ _ _ _ node253_source node254_source

def node256 : Stmt := (.scope node255)
def node256Tokens : List B20.C.Token := [['{']]++node255Tokens++[['}']]
theorem node256_source : Statement node256 node256Tokens := by exact .scope _ _ node255_source

def node257 : Stmt := (.write (.variable "klen".toList) .set (.call .encodeB (argumentTree [(.binary .add (.cast (.pointer .byte) (.variable "pubkey".toList)) (.number .i32 1)),(.binary .sub (.variable "klen".toList) (.number .i32 1)),(.variable "h".toList),(.variable "logn".toList)])))
def node257Tokens : List B20.C.Token := ["klen","=","falcon_encode_12289","(","(","unsigned","char","*",")","pubkey","+","1",",","klen","-","1",",","h",",","logn",")",";"].map String.toList
theorem node257_source : Statement node257 node257Tokens := by exact .simple _ _ (by rfl)

def node258 : Stmt := .skip
def node258Tokens : List B20.C.Token := []
theorem node258_source : Body node258 node258Tokens := by exact .nil

def node259 : Stmt := (.seq node257 node258)
def node259Tokens : List B20.C.Token := node257Tokens++node258Tokens
theorem node259_source : Body node259 node259Tokens := by exact .cons _ _ _ _ node257_source node258_source

def node260 : Stmt := (.scope node259)
def node260Tokens : List B20.C.Token := [['{']]++node259Tokens++[['}']]
theorem node260_source : Statement node260 node260Tokens := by exact .scope _ _ node259_source

def guard261 : Expr := (.variable "ter".toList)
def guard261Tokens : List B20.C.Token := ["ter"].map String.toList
theorem guard261_source : guard guard261 guard261Tokens := by rfl

def node261 : Stmt := (.branch guard261 node256 node260)
def node261Tokens : List B20.C.Token := ["if".toList,['(']]++guard261Tokens++[[')']]++node256Tokens++["else".toList]++node260Tokens
theorem node261_source : Statement node261 node261Tokens := by exact .ifElse _ _ _ _ _ _ guard261_source node256_source node260_source

def node262 : Stmt := (.ret (.number .i32 0))
def node262Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node262_source : Statement node262 node262Tokens := by exact .simple _ _ (by rfl)

def node263 : Stmt := .skip
def node263Tokens : List B20.C.Token := []
theorem node263_source : Body node263 node263Tokens := by exact .nil

def node264 : Stmt := (.seq node262 node263)
def node264Tokens : List B20.C.Token := node262Tokens++node263Tokens
theorem node264_source : Body node264 node264Tokens := by exact .cons _ _ _ _ node262_source node263_source

def node265 : Stmt := (.scope node264)
def node265Tokens : List B20.C.Token := [['{']]++node264Tokens++[['}']]
theorem node265_source : Statement node265 node265Tokens := by exact .scope _ _ node264_source

def guard266 : Expr := (.binary .eq (.variable "klen".toList) (.number .i32 0))
def guard266Tokens : List B20.C.Token := ["klen","==","0"].map String.toList
theorem guard266_source : guard guard266 guard266Tokens := by rfl

def node266 : Stmt := (.branch guard266 node265 .skip)
def node266Tokens : List B20.C.Token := ["if".toList,['(']]++guard266Tokens++[[')']]++node265Tokens
theorem node266_source : Statement node266 node266Tokens := by exact .ifOnly _ _ _ _ guard266_source node265_source

def node267 : Stmt := (.write (.unary .dereference (.variable "pubkey_len".toList)) .set (.binary .add (.variable "klen".toList) (.number .i32 1)))
def node267Tokens : List B20.C.Token := ["*","pubkey_len","=","klen","+","1",";"].map String.toList
theorem node267_source : Statement node267 node267Tokens := by exact .simple _ _ (by rfl)

def node268 : Stmt := (.ret (.number .i32 1))
def node268Tokens : List B20.C.Token := ["return","1",";"].map String.toList
theorem node268_source : Statement node268 node268Tokens := by exact .simple _ _ (by rfl)

def node269 : Stmt := .skip
def node269Tokens : List B20.C.Token := []
end FT1536.Source3.KeygenMakeBinding
