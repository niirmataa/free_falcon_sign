import Source3.KeygenPublicForwardWrapper

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual public conversion loop and its position in the complete body.
   Signed f/g parameters, uint16 destinations and source order remain explicit. -/
namespace FT1536.Source3.KeygenPublicInputProgram
open KeygenPublicExec (Stmt chain)
open KeygenPublicTableAtoms (var literal)

def signed : List C99ArrayReference.Name := ["f".toList,"g".toList]
def index : CLogic.Expr := .var "u".toList
def converted (name : String) : KeygenWordExpr.Expr :=
  .call2 (KeygenPublicScalar.name .conv) (.load16 name.toList index) (var "q")
def firstStore : Stmt := .store "t".toList index false (converted "f")
def secondStore : Stmt := .store "h".toList index false (converted "g")
def body : Stmt := .scope [] [] (chain [firstStore,secondStore])
def condition : KeygenWordExpr.Expr := .cmp .lt (var "u") (var "n")
def increment : Stmt := .scalar (.update "u".toList .add (.literal .i32 1))
def loop : Stmt := .loop condition body increment
def initial : Stmt := .assign "u".toList (literal 0)
def conversion : Stmt := .seq initial loop
def hArgs : List C99ArrayReference.Arg := [.pointer "h".toList C99ProcedureParser.zero,
  .scalar (.var "logn".toList),.scalar (.var "ternary".toList)]
def tArgs : List C99ArrayReference.Arg := [.pointer "t".toList C99ProcedureParser.zero,
  .scalar (.var "logn".toList),.scalar (.var "ternary".toList)]
def hForward : Stmt := .call (KeygenPublicSource.name .forward) hArgs
def tForward : Stmt := .call (KeygenPublicSource.name .forward) tArgs
def fragment (start count : Nat) : Stmt := ((KeygenPublicParser.body KeygenPublicSource.signatures
  (("t".toList,2)::KeygenPublicSource.types .compute) 512 (KeygenPublicScalar.expand
    ((KeygenZintTop.tokens ((KeygenPublicScalar.lines start count).flatMap String.toList++['}'])).getD []))).map (fun r => r.1)).getD .skip
def setup : Stmt := fragment 1527 4
def suffix : Stmt := fragment 1537 10
def append : Stmt → Stmt → Stmt
  | .skip,tail => tail
  | .seq a b,tail => .seq a (append b tail)
  | a,tail => .seq a tail
def ready : Stmt := append setup (chain [conversion,hForward,tForward])
def completeReady : Stmt := append setup (append (chain [conversion,hForward,tForward]) suffix)
def declareDimensions : Stmt := .scalar (.declare .u64 ["u".toList,"n".toList])
def complete : Stmt := .seq declareDimensions (.arrayScope "t".toList 3072 completeReady)

theorem source_complete : KeygenPublicSource.code .compute=complete := by decide
theorem signed_source : KeygenPublicSource.signed .compute=signed := rfl
theorem body_supported : KeygenPublicTableControl.supported body=true := by decide
theorem loop_supported : KeygenPublicTableControl.supported loop=true := by decide
theorem conversion_supported : KeygenPublicTableControl.supported conversion=true := by decide
theorem loop_writes : KeygenPublicTableControl.writes loop=["u".toList] := by decide
theorem body_writes : KeygenPublicTableControl.writes body=[] := by decide
theorem conversion_writes : KeygenPublicTableControl.writes conversion=["u".toList,"u".toList] := by decide

end FT1536.Source3.KeygenPublicInputProgram
