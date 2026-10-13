import Source3.KeygenDecodeStaticUnaryBody

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- COMPLETE actual unary for-loop: ne=0, finite zero-bit iterations,
   source ne++, terminal one-bit break, and innermost-loop absorption. -/
namespace FT1536.Source3.KeygenDecodeStaticUnaryLoop
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeStaticExecution C99MemoryReference
open KeygenDecodeStaticReady KeygenDecodeStaticCertified KeygenDecodeStaticWire

def next (s : State) (n : Nat) : State :=
  withLocals s (localSet s.locals "ne".toList .uint32 (some (.uint32 (BitVec.ofNat 32 (n+1)))))
def whileCode : Stmt := .whileLoop (testExpr KeygenDecodeStaticBinding.loop070Test)
  (.seq KeygenDecodeStaticBinding.node069 KeygenDecodeStaticBinding.loop070Update)

theorem update (args : Args) (s : State) (n : Nat)
    (cell : Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 n)) s.locals) :
    Checked args KeygenDecodeStaticBinding.loop070Update s (next s n) .normal := by
  have calculation : KeygenDecodeDynamicCalculation.ScalarUpdate "ne".toList 1 s.locals
      (.uint32 (BitVec.ofNat 32 n)) (.uint32 (BitVec.ofNat 32 (n+1))) (next s n).locals :=
    .scalar (by unfold KeygenDecodeCalculation.Ordinary; decide +kernel) .uint32 cell _
      (KeygenDecodeStaticCounterOps.plus_nat32 n 1 (by decide +kernel)) (KeygenDecodeWordOps.self32 _).symm rfl
  exact KeygenDecodeStaticCertified.evaluate args s _ _ _ (.postInc _ _ _ _ _ calculation)

theorem while_loop (zeros : Nat) (args : Args) (src dst : ArrayPointer) (v p n : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (tail : List Bool) (small : p<8) (bound : n+zeros≤128)
    (wire : Wire args src dst v p db bytes s)
    (counter : Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 n)) s.locals)
    (bits : remaining p db bytes=List.replicate zeros false++true::tail) :
    ∃ v' p' db' bytes' t, Checked args whileCode s t .normal ∧
      Wire args src dst v' p' db' bytes' t ∧ p'<8 ∧
      Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 (n+zeros))) t.locals ∧
      remaining p' db' bytes'=tail ∧ v'+bytes'.length=v+bytes.length ∧ t.heap=s.heap := by
  induction zeros generalizing v p n db bytes s with
  | zero =>
    obtain ⟨v',p',db',bytes',t,body,lastWire,lastSmall,lastBits,byteCount,heap⟩ :=
      KeygenDecodeStaticUnaryBody.body args src dst v p db bytes s true tail small wire bits
    have iteration : Checked args (.seq KeygenDecodeStaticBinding.node069 KeygenDecodeStaticBinding.loop070Update) s t .broken :=
      seq_break args _ _ s t body
    have one : KeygenDecodeDynamicCalculation.Computes args s.heap s.buf
        (testExpr KeygenDecodeStaticBinding.loop070Test) s.locals (.int32 1) s.locals :=
      .pure _ _ _ (.number _ _ _ (by decide +kernel))
    have same : withLocals s s.locals=s := by cases s; rfl
    have full : Checked args whileCode s t .normal := KeygenDecodeStaticCertifiedLoop.break_exit args _ _ s t
      (.int32 1) s.locals one (by decide +kernel) (by rw [same]; exact iteration)
    have ne := (KeygenDecodeStaticCellFrame.exec_frame "ne".toList args _ s t .broken body.run (by decide +kernel)).trans counter
    exact ⟨v',p',db',bytes',t,full,lastWire,lastSmall,by simpa only [Cell,Nat.add_zero] using ne,lastBits,byteCount,heap⟩
  | succ zeros ih =>
    have headBits : remaining p db bytes=false::(List.replicate zeros false++true::tail) := by
      simpa only [List.replicate_succ,List.cons_append] using bits
    obtain ⟨v1,p1,db1,bytes1,middle,body,middleWire,middleSmall,middleBits,bodyCount,bodyHeap⟩ :=
      KeygenDecodeStaticUnaryBody.body args src dst v p db bytes s false _ small wire headBits
    have ne := (KeygenDecodeStaticCellFrame.exec_frame "ne".toList args _ s middle .normal body.run (by decide +kernel)).trans counter
    have increment := update args middle n ne
    have nextWire := KeygenDecodeStaticReaderFrame.wire_frame args src dst v1 p1 db1 bytes1 middle (next middle n)
      _ .normal increment.run (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel)
      (by decide +kernel) middleWire
    have nextNe : Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 (n+1))) (next middle n).locals := by
      simp only [Cell,next,withLocals,localSet,C99ScalarReference.set,ite_true]
    obtain ⟨v',p',db',bytes',t,rest,lastWire,lastSmall,lastCounter,lastBits,restCount,restHeap⟩ :=
      ih v1 p1 (n+1) db1 bytes1 (next middle n) middleSmall (by omega) nextWire nextNe middleBits
    have iteration : Checked args (.seq KeygenDecodeStaticBinding.node069 KeygenDecodeStaticBinding.loop070Update) s (next middle n) .normal :=
      seq args _ _ s middle (next middle n) .normal body increment
    have one : KeygenDecodeDynamicCalculation.Computes args s.heap s.buf
        (testExpr KeygenDecodeStaticBinding.loop070Test) s.locals (.int32 1) s.locals :=
      .pure _ _ _ (.number _ _ _ (by decide +kernel))
    have same : withLocals s s.locals=s := by cases s; rfl
    have full : Checked args whileCode s t .normal := KeygenDecodeStaticCertifiedLoop.next args _ _ s (next middle n) t .normal
      (.int32 1) s.locals one (by decide +kernel) (by rw [same]; exact iteration) rest
    refine ⟨v',p',db',bytes',t,full,lastWire,lastSmall,?_,lastBits,restCount.trans bodyCount,restHeap.trans bodyHeap⟩
    simpa only [show n+1+zeros=n+(zeros+1) by omega] using lastCounter

def initialized (s : State) : State := withLocals s (localSet s.locals "ne".toList .uint32 (some (.uint32 0)))

theorem loop (args : Args) (src dst : ArrayPointer) (v p q : Nat) (db : BitVec 32)
    (bytes : List (BitVec 8)) (s : State) (tail : List Bool) (small : p<8) (bound : q≤128)
    (wire : Wire args src dst v p db bytes s) (declaredNe : s.locals.scalars "ne".toList=some (.uint32,none))
    (bits : remaining p db bytes=List.replicate q false++true::tail) :
    ∃ v' p' db' bytes' t, Checked args KeygenDecodeStaticBinding.node070 s t .normal ∧
      Wire args src dst v' p' db' bytes' t ∧ p'<8 ∧
      Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 q)) t.locals ∧
      remaining p' db' bytes'=tail ∧ v'+bytes'.length=v+bytes.length ∧ t.heap=s.heap := by
  let s1 := initialized s
  have init : Checked args KeygenDecodeStaticBinding.loop070Init s s1 .normal := by
    have source := assign args s "ne".toList .uint32 none (.number .i32 0) (.int32 0) s.locals
      (by decide +kernel) (by decide +kernel) declaredNe (.pure _ _ _ (.number _ _ _ (by decide +kernel)))
    have cast : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.int32 0).integer=.uint32 0 := by decide +kernel
    simpa only [cast,KeygenDecodeStaticBinding.loop070Init,initialized,s1] using source
  have wire1 := KeygenDecodeStaticReaderFrame.wire_frame args src dst v p db bytes s s1 _ .normal init.run
    (by unfold KeygenDecodeStaticReaderFrame.Checks KeygenDecodeStaticReady.Checks; decide +kernel) (by decide +kernel) wire
  have counter1 : Cell "ne" .uint32 (.uint32 (BitVec.ofNat 32 0)) s1.locals := by
    simp only [Cell,s1,initialized,withLocals,localSet,C99ScalarReference.set,ite_true]
    rfl
  obtain ⟨v',p',db',bytes',t,body,lastWire,lastSmall,lastNe,lastBits,byteCount,heap⟩ :=
    while_loop q args src dst v p 0 db bytes s1 tail small (by omega) wire1 counter1 bits
  have expanded : Checked args (desugar KeygenDecodeStaticBinding.loop070Init KeygenDecodeStaticBinding.loop070Test
      KeygenDecodeStaticBinding.loop070Update KeygenDecodeStaticBinding.node069) s t .normal :=
    seq args _ _ s s1 t .normal init body
  have full : Checked args KeygenDecodeStaticBinding.node070 s t .normal :=
    KeygenDecodeStaticCertifiedLoop.forLoop args _ _ _ _ s t .normal expanded
  exact ⟨v',p',db',bytes',t,full,lastWire,lastSmall,by simpa only [Cell,Nat.zero_add] using lastNe,lastBits,byteCount,heap⟩

end FT1536.Source3.KeygenDecodeStaticUnaryLoop
