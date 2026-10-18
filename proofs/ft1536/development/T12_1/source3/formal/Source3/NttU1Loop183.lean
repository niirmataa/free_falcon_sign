import Source3.NttU1Control183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttU1Loop183
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open NttFirstFixed182 (Fixed)

def condition : CLogic.Expr := .cmp .lt (.var "u1".toList) (.var "m".toList)
def loop : C99ModularReference.Stmt := .loop condition NttU1Body183.code KeygenNttForwardPrograms.u1Step

theorem source (n j m t h : Nat) (count : j+n=m) (mt : m*t=1536) (th : t=2*h)
    (mb : m≤512) (tb : t≤768) (hb : h≤768)
    (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (sep : NttMiddleTable183.Separate a gm) (reads : NttMiddleTable183.Reads s.heap gm)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (hc : USlot s "ht" h)
    (jc : USlot s "u1" j) (lc : USlot s "v1" (j*t)) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧ USlot out "u1" m ∧
      NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  induction n generalizing j s with
  | zero =>
    have equal : j=m := by omega
    subst j
    exact ⟨s,.loopFalse _ _ _ s (C99ScalarReference.boolean (decide (m<m)))
      (C99LoopScalar141.less s (.var "u1".toList) (.var "m".toList) m m (by omega) (by omega)
        (.variable _ _ _ jc) (.variable _ _ _ mc))
      (by simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer]),fixed,jc,NttWriteFrame182.refl a 1536 s.heap⟩
  | succ n ih =>
    have bound : j<m := by omega
    have product : (j+1)*t≤1536 := by
      rw [←mt]
      exact Nat.mul_le_mul_right t (by omega)
    have range : j*t+2*h≤1536 := by
      rw [Nat.add_mul,Nat.one_mul] at product
      omega
    obtain ⟨middle,iteration,middleFixed,memory,locals⟩ :=
      NttU1Body183.source s a gm p p0i w m j (j*t) h fixed range hb (by omega)
        mc jc lc hc reads
    let next := NttU1Control183.after middle j (j*t) t
    have update := NttU1Control183.source middle j (j*t) t (by omega) (by omega) tb
      ((congrFun locals _).trans jc) ((congrFun locals _).trans lc) ((congrFun locals _).trans tc)
    have nextPos : USlot next "v1" ((j+1)*t) := by
      simpa only [Nat.add_mul,Nat.one_mul] using
        NttU1Control183.position middle j (j*t) t (by omega)
    obtain ⟨out,rest,fo,jo,frame⟩ := ih (j+1) (by omega) next
      (NttU1Control183.fixed middle a gm p p0i w j (j*t) t middleFixed)
      (NttMiddleTable183.transport s.heap middle.heap a gm sep memory reads)
      ((congrFun locals _).trans mc) ((congrFun locals _).trans tc) ((congrFun locals _).trans hc)
      (NttU1Control183.counter middle j (j*t) t (by omega)) nextPos
    refine ⟨out,?_,fo,jo,NttWriteFrame182.trans a 1536 _ _ _ memory frame⟩
    have nonzero : (C99ScalarReference.boolean (decide (j<m))).integer≠0 := by
      simp [bound,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (C99LoopScalar141.less s (.var "u1".toList) (.var "m".toList) j m (by omega) (by omega)
        (.variable _ _ _ jc) (.variable _ _ _ mc)) nonzero iteration update rest

theorem full (m t h : Nat) (mt : m*t=1536) (th : t=2*h) (mb : m≤512) (tb : t≤768) (hb : h≤768)
    (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (fixed : Fixed s a gm p p0i w)
    (sep : NttMiddleTable183.Separate a gm) (reads : NttMiddleTable183.Reads s.heap gm)
    (mc : USlot s "m" m) (tc : USlot s "t" t) (hc : USlot s "ht" h)
    (oldU oldV : Option C99IntegerReference.Value)
    (du : s.locals "u1".toList=some (.uint64,oldU)) (dv : s.locals "v1".toList=some (.uint64,oldV)) :
    ∃ out, Exec KeygenNttForwardPrograms.u1Loop s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i w ∧
      USlot out "u1" m ∧ NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  obtain ⟨out,run,fo,jo,frame⟩ := source m 0 m t h (Nat.zero_add m) mt th mb tb hb
    (NttU1Control183.initial s) a gm p p0i w (NttU1Control183.initial_fixed s a gm p p0i w fixed)
    sep reads mc tc hc rfl (by simp only [Nat.zero_mul]; rfl)
  exact ⟨out,.seqNormal _ _ s (NttU1Control183.initial s) _ (NttU1Control183.init s oldU oldV du dv) run,fo,jo,frame⟩

end FT1536.Source3.NttU1Loop183
