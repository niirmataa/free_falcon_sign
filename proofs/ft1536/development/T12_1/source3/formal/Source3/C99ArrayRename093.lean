import Source3.C99StateRename090
import Source3.C99ArrayDeterminism089

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99ArrayRename093
open C99ArrayReference
open C99MemoryReference
open C99IntegerReference (Value)
open C99BlockRename090

theorem load16 (r : Renaming) (h : Memory) (p : ArrayPointer) (word : BitVec 16)
    (source : C99NarrowReads.Load16 h p word) : C99NarrowReads.Load16 (heap r h) (ptr r p) word := by
  cases source with
  | load bytes legal width values =>
      exact .load _ _ bytes (C99BlockRename090.allocated r h p legal) width
        (fun i => (bytes_at r h p.block (p.offset + i.val)).trans (values i))

theorem expression (r : Renaming) (s : State) (e : Expr) (v : Value) (source : Eval s e v) :
    Eval (state r s) e v := by
  induction source with
  | scalar e v source => exact .scalar e v source
  | load name index p word address read =>
      exact .load name index (ptr r p) word (C99StateRename090.pointer r s name index p address)
        (load64 r s.heap p word read)
  | load16 signed name index p word address read =>
      exact .load16 signed name index (ptr r p) word (C99StateRename090.pointer r s name index p address)
        (load16 r s.heap p word read)
  | call1 name a x z arg body ih => exact .call1 name a x z ih body
  | call2 name a b x y z left right body ih1 ih2 => exact .call2 name a b x y z ih1 ih2 body

theorem parameters (r : Renaming) (caller : State) (params : List Param) (args : List Arg) (out : State)
    (source : Bind caller params args out) : Bind (state r caller) params args (state r out) := by
  induction source with
  | nil => exact .nil
  | scalar ty name e ps args out v value rest ih =>
      rw [C99StateRename090.bindValue]
      exact .scalar ty name e ps args (state r out) v value ih
  | pointer name src index p ps args out value rest ih =>
      rw [C99StateRename090.bindPointer]
      exact .pointer name src index (ptr r p) ps args (state r out)
        (C99StateRename090.pointer r caller src index p value) ih

theorem execution (r : Renaming) (program : Program) (code : Stmt) (before after : State)
    (source : Exec program code before after) : Exec program code (state r before) (state r after) := by
  induction source with
  | skip => exact .skip _
  | scalar before env stmt body => exact .scalar _ env stmt body
  | assign before name e ty old v declared value =>
      rw [C99StateRename090.bindValue]
      exact .assign _ name e ty old v declared (expression r before e v value)
  | declarePtr before name =>
      rw [C99StateRename090.declarePointer]
      exact .declarePtr _ name
  | bindPtr before name src index p value =>
      rw [C99StateRename090.bindPointer]
      exact .bindPtr _ name src index (ptr r p) (C99StateRename090.pointer r before src index p value)
  | store64 before after name index e p v address value write =>
      exact .store64 _ (heap r after) name index e (ptr r p) v
        (C99StateRename090.pointer r before name index p address) (expression r before e v value)
        (store64 r before.heap after p _ write)
  | store32 before after name index e p v address value write =>
      exact .store32 _ (heap r after) name index e (ptr r p) v
        (C99StateRename090.pointer r before name index p address) (expression r before e v value)
        (store32 r before.heap after p _ write)
  | copy before after dst src di si count p q n destination source length destinationObject sourceObject copied =>
      exact .copy _ (heap r after) dst src di si count (ptr r p) (ptr r q) n
        (C99StateRename090.pointer r before dst di p destination) (C99StateRename090.pointer r before src si q source)
        length destinationObject sourceObject (memcpy r before.heap after p q n.toNat copied)
  | seq a b before middle after first second ih1 ih2 => exact .seq a b _ _ _ ih1 ih2
  | scope locals pointers body before after inner ih =>
      rw [C99StateRename090.restoreScope]
      exact .scope locals pointers body _ _ ih
  | branchTrue c yes no before after v guard nonzero body ih => exact .branchTrue c yes no _ _ v guard nonzero ih
  | branchFalse c yes no before after v guard zero body ih => exact .branchFalse c yes no _ _ v guard zero ih
  | whileFalse c body s v guard zero => exact .whileFalse c body _ v guard zero
  | whileTrue c body before middle after v guard nonzero step rest ih1 ih2 =>
      exact .whileTrue c body _ _ _ v guard nonzero ih1 ih2
  | call name args f before entry result source binding body ih =>
      exact .call name args f _ _ _ source (parameters r before f.params args entry binding) ih

end FT1536.Source3.C99ArrayRename093
