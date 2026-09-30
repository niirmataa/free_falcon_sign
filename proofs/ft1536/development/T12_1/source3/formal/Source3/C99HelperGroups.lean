import Source3.C99HelperAtoms

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HelperGroups
open C99HelperReference C99HelperAtoms
local notation "code" => StableBinarySourceSyntax.expected

theorem pair_complete (l : StableBinary.Layout) (start u : Nat) (s out : State) (a b : Word)
    (h : Pair l code start u s a b out) :
    StableBinaryCExec.sourcePair l code (StableBinary.addr l.values start) u (encode s)=some ((a,b),encode out) := by
  cases h with
  | step s1 _ x _ y _ hrx hcx hry hcy =>
      have hx := C99MemoryBridge.load64_source_to_interpreter _ _ _ rfl hrx
      have hy := C99MemoryBridge.load64_source_to_interpreter _ _ _ rfl hry
      have hc1 := positive_complete l s s1 x a hcx
      have hc2 := positive_complete l s1 out y b hcy
      have addr0 : StableBinary.addr (StableBinary.addr l.values start) (u*2+0)=
          (C99HelperObjects.values l (start+(u*2^(code).first.shift+(code).first.offset))).offset := by
        simp [StableBinary.addr,C99HelperObjects.values,C99MemoryReference.ArrayPointer.offset,StableBinarySourceSyntax.expected]; omega
      have addr1 : StableBinary.addr (StableBinary.addr l.values start) (u*2+1)=
          (C99HelperObjects.values l (start+(u*2^(code).second.shift+(code).second.offset))).offset := by
        simp [StableBinary.addr,C99HelperObjects.values,C99MemoryReference.ArrayPointer.offset,StableBinarySourceSyntax.expected]; omega
      have hx' : StableBinaryCExec.load (encode s) (StableBinary.addr (StableBinary.addr l.values start) (u*2+0))=some x := by
        rw [addr0]; exact hx
      have hy' : StableBinaryCExec.load (encode s1) (StableBinary.addr (StableBinary.addr l.values start) (u*2+1))=some y := by
        rw [addr1]; exact hy
      simp only [StableBinaryCExec.sourcePair,StableBinarySourceSyntax.expected,pow_one,hx',hy',hc1,hc2,Bind.bind,Option.bind]
      rfl

theorem gram_complete (l : StableBinary.Layout) (s out : State) (a b sum product : Word)
    (h : Gram l code a b s sum product out) :
    StableBinaryCExec.sourceGram l code a b (encode s)=some ((sum,product),encode out) := by
  cases h with
  | step s1 _ rawSum _ rawProduct _ ha hcs hm hcp =>
      have ha' := add_complete (encode s) a b rawSum ha
      have hm' := mul_complete (encode s1) a b rawProduct hm
      have hcs' := positive_complete l s s1 rawSum sum hcs
      have hcp' := positive_complete l s1 out rawProduct product hcp
      have hsum : (StableBinaryCExec.binary "fpr_add".toList (encode s) a b).bind
          (fun p => StableBinaryCExec.positive l p.2 p.1)=some (sum,encode s1) := by
        rw [ha']; exact hcs'
      have hproduct : (StableBinaryCExec.binary "fpr_mul".toList (encode s1) a b).bind
          (fun p => StableBinaryCExec.positive l p.2 p.1)=some (product,encode out) := by
        rw [hm']; exact hcp'
      change ((StableBinaryCExec.binary "fpr_add".toList (encode s) a b).bind
        (fun p => StableBinaryCExec.positive l p.2 p.1)).bind
          (fun p => ((StableBinaryCExec.binary "fpr_mul".toList p.2 a b).bind
            (fun q => StableBinaryCExec.positive l q.2 q.1)).bind
              (fun q => some ((p.1,q.1),q.2))) = _
      rw [hsum]
      change ((StableBinaryCExec.binary "fpr_mul".toList (encode s1) a b).bind
        (fun p => StableBinaryCExec.positive l p.2 p.1)).bind
          (fun q => some ((sum,q.1),q.2)) = _
      rw [hproduct]
      rfl

theorem half_complete (l : StableBinary.Layout) (u : Nat) (s out : State) (sum : Word)
    (h : HalfStore l code u sum s out) : StableBinaryCExec.sourceHalfStore l code u sum (encode s)=some (encode out) := by
  cases h with
  | step mid _ raw z hh hc hw =>
      have hh' := C99HelperAtoms.half_complete (encode s) sum raw hh
      have hc' := positive_complete l s mid raw z hc
      have hw' := store_complete (C99HelperObjects.scratch l u) mid out z rfl hw
      simp only [StableBinaryCExec.sourceHalfStore,StableBinarySourceSyntax.expected,hh',hc',Bind.bind,Option.bind]
      exact hw'

theorem suffix_complete (l : StableBinary.Layout) (u hn : Nat) (s out : State) (product sum : Word)
    (h : Suffix l code u hn product sum s out) :
    StableBinaryCExec.sourceSuffix l code u hn product sum (encode s)=some (encode out) := by
  cases h with
  | step mid _ twice raw z hd hv hc hw =>
      have hd' := double_complete (encode s) product twice hd
      have hv' := div_complete (encode s) twice sum raw hv
      have hc' := positive_complete l s mid raw z hc
      have hw' := store_complete (C99HelperObjects.scratch l (u+hn)) mid out z rfl hw
      simp only [StableBinaryCExec.sourceSuffix,StableBinarySourceSyntax.expected,hd',hv',hc',Bind.bind,Option.bind]
      exact hw'

theorem step_complete (l : StableBinary.Layout) (start u hn : Nat) (s out : State)
    (h : Step l code start u hn s out) :
    StableBinaryCExec.sourceStep l code (StableBinary.addr l.values start) u hn (encode s)=some (encode out) := by
  cases h with
  | step sp sg sh _ a b sum product hp hg hh hs =>
      have hp' := pair_complete l start u s sp a b hp
      have hg' := gram_complete l sp sg a b sum product hg
      have hh' := half_complete l u sg sh sum hh
      have hs' := suffix_complete l u hn sh out product sum hs
      simp only [StableBinaryCExec.sourceStep,StableBinaryCExec.sourcePrefix,hp',hg',hh',Bind.bind,Option.bind]
      exact hs'

theorem loop_complete (l : StableBinary.Layout) (start hn u : Nat) (s out : State)
    (h : Loop l code start hn u s out) :
    StableBinaryCExec.sourceLoop l code (StableBinary.addr l.values start) hn u (encode s)=some (encode out) := by
  induction h with
  | zero _ => rfl
  | next u s mid out _ _ hb ih =>
      simp [StableBinaryCExec.sourceLoop,ih]
      exact step_complete l start u hn mid out hb

end FT1536.Source3.C99HelperGroups

#print axioms FT1536.Source3.C99HelperGroups.loop_complete
