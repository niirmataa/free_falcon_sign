import Source3.KeygenCodecStaticWriteStep

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticCursor
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor)

def increment : Stmt := .evaluate (.postInc (.variable "u".toList))

theorem source_sites : KeygenCodecStaticBinding.node054=increment ∧
    KeygenCodecStaticBinding.node074=increment ∧ KeygenCodecStaticBinding.node114=increment :=
  ⟨rfl,rfl,rfl⟩

theorem increment_cursor (args : Args) (s t : State) (flow : Flow) (n : Nat)
    (bound : n+1<2^64) (cursor : Cursor (BitVec.ofNat 64 n) s)
    (source : Exec args increment s t flow) :
    flow=.normal ∧ Cursor (BitVec.ofNat 64 (n+1)) t ∧ t.heap=s.heap ∧ t.buf=s.buf := by
  cases source with
  | evaluate args s e value locals evaluated =>
    cases evaluated with
    | postInc name before after old next updated =>
      cases updated with
      | scalar name delta before ty v z held operation =>
        have equal : ty=.uint64 ∧ v=.uint64 (BitVec.ofNat 64 n) := by
          simpa only [Cursor,Option.some.injEq,Prod.mk.injEq,Option.some.injEq] using held.symm.trans cursor
        obtain ⟨rfl,rfl⟩ := equal
        have same := KeygenCodecNoneCursor.plus_value n 1 bound (by decide +kernel) z
          (.add _ _ _ operation)
        subst z
        refine ⟨rfl,?_,rfl,rfl⟩
        simp only [Cursor,withLocals,localSet,C99ScalarReference.set,ite_true,
          C99IntegerReference.convert,C99IntegerReference.Value.integer,
          BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem return_cursor (args : Args) (s t : State) (flow : Flow) (u : BitVec 64)
    (cursor : Cursor u s)
    (source : Exec args KeygenCodecStaticBinding.node120 s t flow) :
    flow=.returned u ∧ t=s := by
  cases source with
  | ret args s e value locals evaluated =>
    obtain ⟨same,last⟩ := KeygenCodecGuardedWrite.u_eval args s.heap s.buf s.locals locals (.integer value) u cursor evaluated
    cases same
    subst locals
    exact ⟨by simp only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq],by cases s; rfl⟩

end FT1536.Source3.KeygenCodecStaticCursor
