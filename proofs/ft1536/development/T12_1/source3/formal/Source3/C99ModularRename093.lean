import Source3.C99ArrayRename093

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ModularRename093
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open C99ModularReference
open C99BlockRename090

def result (r : Renaming) (out : Result) : Result := ⟨state r out.state, out.flow⟩

theorem expression (r : Renaming) (calls : CallRelation) (s : State) (e : Expr) (v : Value)
    (source : GenEval calls s e v) : GenEval calls (state r s) e v := by
  induction source with
  | scalar e v source => exact .scalar e v source
  | load32 name index p word address read =>
      exact .load32 name index (ptr r p) word (C99StateRename090.pointer r s name index p address)
        (load32 r s.heap p word read)
  | load16 name index p word address read =>
      exact .load16 name index (ptr r p) word (C99StateRename090.pointer r s name index p address)
        (C99ArrayRename093.load16 r s.heap p word read)
  | call1 name a x out arg call ih => exact .call1 name a x out ih call
  | call2 name a b x y out first second call ih1 ih2 => exact .call2 name a b x y out ih1 ih2 call
  | call3 name a b c x y z out first second third call ih1 ih2 ih3 => exact .call3 name a b c x y z out ih1 ih2 ih3 call
  | call4 name a b c d x y z t out first second third fourth call ih1 ih2 ih3 ih4 =>
      exact .call4 name a b c d x y z t out ih1 ih2 ih3 ih4 call
  | call5 name a b c d e x y z t u out first second third fourth fifth call ih1 ih2 ih3 ih4 ih5 =>
      exact .call5 name a b c d e x y z t u out ih1 ih2 ih3 ih4 ih5 call

theorem execution (r : Renaming) (calls : CallRelation) (code : Stmt) (before : State) (out : Result)
    (source : GenExec calls code before out) : GenExec calls code (state r before) (result r out) := by
  induction source with
  | base code before after source => exact .base code _ _ (C99ArrayRename093.execution r _ code before after source)
  | assign name e before ty old v declared value =>
      exact .assign name e _ ty old v declared (expression r calls before e v value)
  | store32 name index e before after p v address value write =>
      exact .store32 name index e _ (heap r after) (ptr r p) v
        (C99StateRename090.pointer r before name index p address) (expression r calls before e v value)
        (store32 r before.heap after p _ write)
  | storeRev name table base index e before after p q bv word v baseValue tableAddress tableRead address value write =>
      exact .storeRev name table base index e _ (heap r after) (ptr r p) (ptr r q) bv word v baseValue
        (C99StateRename090.pointer r before table index q tableAddress) (C99ArrayRename093.load16 r before.heap q word tableRead)
        (C99StateRename090.pointer r before name _ p address) (expression r calls before e v value)
        (store32 r before.heap after p _ write)
  | seqNormal a b before middle out head tail ih1 ih2 => exact .seqNormal a b _ _ _ ih1 ih2
  | seqExit a b before out head exit ih => exact .seqExit a b _ _ ih exit
  | scope locals body before out inner ih =>
      change GenExec calls (.scope locals body) (state r before)
        ⟨state r (C99ArrayReference.restoreScope before out.state locals []), out.flow⟩
      rw [C99StateRename090.restoreScope]
      exact .scope locals body _ _ ih
  | branchTrue c yes no before out v guard nonzero body ih => exact .branchTrue c yes no _ _ v guard nonzero ih
  | branchFalse c yes no before out v guard zero body ih => exact .branchFalse c yes no _ _ v guard zero ih
  | loopFalse c body increment before v guard zero => exact .loopFalse c body increment _ v guard zero
  | loopNormal c body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      exact .loopNormal c body increment _ _ _ _ v guard nonzero ih1 ih2 ih3
  | loopReturn c body increment before after v value guard nonzero iteration ih =>
      exact .loopReturn c body increment _ _ v value guard nonzero ih
  | ret e before v value => exact .ret e _ v (expression r calls before e v value)
  | retVoid => exact .retVoid _

end FT1536.Source3.C99ModularRename093
