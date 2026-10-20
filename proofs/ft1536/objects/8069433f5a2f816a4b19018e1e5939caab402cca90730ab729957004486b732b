import Source3.KeygenMakeBindingPart07

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated bounded compositional syntax; atomic clauses are kernel checked. -/
namespace FT1536.Source3.KeygenMakeBinding
open KeygenMakeSyntax
open KeygenMakeGrammar

def node217 : Stmt := (.write (.variable "klen".toList) .set (.unary .dereference (.variable "privkey_len".toList)))
def node217Tokens : List B20.C.Token := ["klen","=","*","privkey_len",";"].map String.toList
theorem node217_source : Statement node217 node217Tokens := by exact .simple _ _ (by rfl)

def node218 : Stmt := (.write (.variable "skbuf".toList) .set (.variable "privkey".toList))
def node218Tokens : List B20.C.Token := ["skbuf","=","privkey",";"].map String.toList
theorem node218_source : Statement node218 node218Tokens := by exact .simple _ _ (by rfl)

def node219 : Stmt := (.ret (.number .i32 0))
def node219Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node219_source : Statement node219 node219Tokens := by exact .simple _ _ (by rfl)

def node220 : Stmt := .skip
def node220Tokens : List B20.C.Token := []
theorem node220_source : Body node220 node220Tokens := by exact .nil

def node221 : Stmt := (.seq node219 node220)
def node221Tokens : List B20.C.Token := node219Tokens++node220Tokens
theorem node221_source : Body node221 node221Tokens := by exact .cons _ _ _ _ node219_source node220_source

def node222 : Stmt := (.scope node221)
def node222Tokens : List B20.C.Token := [['{']]++node221Tokens++[['}']]
theorem node222_source : Statement node222 node222Tokens := by exact .scope _ _ node221_source

def guard223 : Expr := (.binary .lt (.variable "klen".toList) (.number .i32 1))
def guard223Tokens : List B20.C.Token := ["klen","<","1"].map String.toList
theorem guard223_source : guard guard223 guard223Tokens := by rfl

def node223 : Stmt := (.branch guard223 node222 .skip)
def node223Tokens : List B20.C.Token := ["if".toList,['(']]++guard223Tokens++[[')']]++node222Tokens
theorem node223_source : Statement node223 node223Tokens := by exact .ifOnly _ _ _ _ guard223_source node222_source

def node224 : Stmt := (.write (.index (.variable "skbuf".toList) (.number .i32 0)) .set (.binary .add (.binary .add (.binary .shl (.variable "ter".toList) (.number .i32 7)) (.binary .shl (.variable "comp".toList) (.number .i32 5))) (.variable "logn".toList)))
def node224Tokens : List B20.C.Token := ["skbuf","[","0","]","=","(","ter","<<","7",")","+","(","comp","<<","5",")","+","logn",";"].map String.toList
theorem node224_source : Statement node224 node224Tokens := by exact .simple _ _ (by rfl)

def node225 : Stmt := (.write (.variable "skoff".toList) .set (.number .i32 1))
def node225Tokens : List B20.C.Token := ["skoff","=","1",";"].map String.toList
theorem node225_source : Statement node225 node225Tokens := by exact .simple _ _ (by rfl)

def node226 : Stmt := (.write (.index (.variable "ske".toList) (.number .i32 0)) .set (.variable "f".toList))
def node226Tokens : List B20.C.Token := ["ske","[","0","]","=","f",";"].map String.toList
theorem node226_source : Statement node226 node226Tokens := by exact .simple _ _ (by rfl)

def node227 : Stmt := (.write (.index (.variable "ske".toList) (.number .i32 1)) .set (.variable "g".toList))
def node227Tokens : List B20.C.Token := ["ske","[","1","]","=","g",";"].map String.toList
theorem node227_source : Statement node227 node227Tokens := by exact .simple _ _ (by rfl)

def node228 : Stmt := (.write (.index (.variable "ske".toList) (.number .i32 2)) .set (.variable "F".toList))
def node228Tokens : List B20.C.Token := ["ske","[","2","]","=","F",";"].map String.toList
theorem node228_source : Statement node228 node228Tokens := by exact .simple _ _ (by rfl)

def node229 : Stmt := (.write (.index (.variable "ske".toList) (.number .i32 3)) .set (.variable "G".toList))
def node229Tokens : List B20.C.Token := ["ske","[","3","]","=","G",";"].map String.toList
theorem node229_source : Statement node229 node229Tokens := by exact .simple _ _ (by rfl)

def node230 : Stmt := (.declare [⟨"elen".toList,.size,none⟩])
def node230Tokens : List B20.C.Token := ["size_t","elen",";"].map String.toList
theorem node230_source : Statement node230 node230Tokens := by exact .simple _ _ (by rfl)

def node231 : Stmt := (.write (.variable "elen".toList) .set (.call .encodeSmall (argumentTree [(.binary .add (.variable "skbuf".toList) (.variable "skoff".toList)),(.binary .sub (.variable "klen".toList) (.variable "skoff".toList)),(.variable "comp".toList),(.conditional (.variable "ter".toList) (.number .i32 18433) (.number .i32 12289)),(.index (.variable "ske".toList) (.variable "i".toList)),(.variable "logn".toList)])))
def node231Tokens : List B20.C.Token := ["elen","=","falcon_encode_small","(","skbuf","+","skoff",",","klen","-","skoff",",","comp",",","ter","?","18433",":","12289",",","ske","[","i","]",",","logn",")",";"].map String.toList
theorem node231_source : Statement node231 node231Tokens := by exact .simple _ _ (by rfl)

def node232 : Stmt := (.ret (.number .i32 0))
def node232Tokens : List B20.C.Token := ["return","0",";"].map String.toList
theorem node232_source : Statement node232 node232Tokens := by exact .simple _ _ (by rfl)

def node233 : Stmt := .skip
def node233Tokens : List B20.C.Token := []
theorem node233_source : Body node233 node233Tokens := by exact .nil

def node234 : Stmt := (.seq node232 node233)
def node234Tokens : List B20.C.Token := node232Tokens++node233Tokens
theorem node234_source : Body node234 node234Tokens := by exact .cons _ _ _ _ node232_source node233_source

def node235 : Stmt := (.scope node234)
def node235Tokens : List B20.C.Token := [['{']]++node234Tokens++[['}']]
theorem node235_source : Statement node235 node235Tokens := by exact .scope _ _ node234_source

def guard236 : Expr := (.binary .eq (.variable "elen".toList) (.number .i32 0))
def guard236Tokens : List B20.C.Token := ["elen","==","0"].map String.toList
theorem guard236_source : guard guard236 guard236Tokens := by rfl

def node236 : Stmt := (.branch guard236 node235 .skip)
def node236Tokens : List B20.C.Token := ["if".toList,['(']]++guard236Tokens++[[')']]++node235Tokens
theorem node236_source : Statement node236 node236Tokens := by exact .ifOnly _ _ _ _ guard236_source node235_source

def node237 : Stmt := (.write (.variable "skoff".toList) .add (.variable "elen".toList))
def node237Tokens : List B20.C.Token := ["skoff","+=","elen",";"].map String.toList
theorem node237_source : Statement node237 node237Tokens := by exact .simple _ _ (by rfl)

def node238 : Stmt := .skip
def node238Tokens : List B20.C.Token := []
theorem node238_source : Body node238 node238Tokens := by exact .nil

def node239 : Stmt := (.seq node237 node238)
def node239Tokens : List B20.C.Token := node237Tokens++node238Tokens
theorem node239_source : Body node239 node239Tokens := by exact .cons _ _ _ _ node237_source node238_source

def node240 : Stmt := (.seq node236 node239)
def node240Tokens : List B20.C.Token := node236Tokens++node239Tokens
theorem node240_source : Body node240 node240Tokens := by exact .cons _ _ _ _ node236_source node239_source

def node241 : Stmt := (.seq node231 node240)
def node241Tokens : List B20.C.Token := node231Tokens++node240Tokens
theorem node241_source : Body node241 node241Tokens := by exact .cons _ _ _ _ node231_source node240_source

def node242 : Stmt := (.seq node230 node241)
def node242Tokens : List B20.C.Token := node230Tokens++node241Tokens
theorem node242_source : Body node242 node242Tokens := by exact .cons _ _ _ _ node230_source node241_source

def node243 : Stmt := (.scope node242)
def node243Tokens : List B20.C.Token := [['{']]++node242Tokens++[['}']]
theorem node243_source : Statement node243 node243Tokens := by exact .scope _ _ node242_source

def loop244Init : Stmt := (.write (.variable "i".toList) .set (.number .i32 0))
def loop244Update : Stmt := (.increment (.variable "i".toList))
def loop244Test : Option Expr := (some (.binary .lt (.variable "i".toList) (.number .i32 4)))
def loop244First : List B20.C.Token := ["i","=","0"].map String.toList
end FT1536.Source3.KeygenMakeBinding
