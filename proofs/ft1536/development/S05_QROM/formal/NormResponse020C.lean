import BoxImage020C
import NormFinish020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.NormResponse020C
open WordRAM020 PairProgram020 ReadSemantics020A CdfPrefix020A
open NormFinish020C BoxImage020C VectorLoopCore020C
open FT1536.Geometry FT1536.PublicSimulation
attribute [local irreducible] exec loopState StandaloneRuntime019.vector

def Preserves (s t : State) : Prop :=
  t.out=s.out ∧ t.fault=s.fault ∧ ∀ j : Fin ramSize, 3072≤j.val → t.ram j=s.ram j
theorem preserves_refl (s : State) : Preserves s s := ⟨rfl,rfl,fun _ _ => rfl⟩
theorem preserves_trans {s t u : State} (h : Preserves s t) (h' : Preserves t u) : Preserves s u :=
  ⟨h'.1.trans h.1,h'.2.1.trans h.2.1,fun j hj => (h'.2.2 j hj).trans (h.2.2 j hj)⟩
theorem from_vector {s t : State} (h : VectorPrefix020C.Stable s t) : Preserves s t :=
  ⟨h.1,h.2.1,h.2.2.2⟩
theorem finish_preserves (s : State) (n : Nat) (a : Int) : Preserves s (finish s n a) := by
  have fr := finish_memory s n a
  exact ⟨fr.2.1,fr.2.2,fun j _ => congrFun fr.1 j⟩

theorem finish_read (s : State) (n : Nat) (a : Int) : readVec (finish s n a)=readVec s := by
  have fr := (finish_memory s n a).1
  funext p
  exact Prod.ext (congrFun fr _) (congrFun fr _)

theorem finish_answer (s : State) (n : Nat) (a : Int) (h20 : s.reg 20=0) :
    answer (finish s n a)=if a<2093922385 then some (readVec s) else none := by
  unfold answer FlagCore020C.observe
  rw [finish_flag s n a h20,finish_read]
  by_cases ha : a<2093922385
  · rw [ite_eq_left ha,ite_eq_right (show word 1≠0 by decide),ite_eq_left ha]
  · rw [ite_eq_right ha,ite_eq_left (show (0 : Word)=0 by rfl),ite_eq_right ha]

theorem norm_shape (i : Input) (s : State) :
    exec i PairProgram020.normTrial s=exec i tailCode (exec i vectorCode s) :=
  CdfStep020A.seqs_append i
    [set 1 (lit 0),set 16 (lit 0),.loop 1536 (lit 1) PairProgram020.pair]
    [.branch (lt (r 16) (lit 2093922385)) (set 20 (lit 1)) skip,inc 0] s

theorem reference_answer (t : StandaloneRuntime019.Tables) (c : StandaloneRuntime019.VectorSeed) :
    (StandaloneRuntime019.normTrial t c).map image=
      if Q (decode (StandaloneRuntime019.view (StandaloneRuntime019.vector t c)))<B
      then some (image (StandaloneRuntime019.vector t c)) else none := by
  by_cases h : Q (decode (StandaloneRuntime019.view (StandaloneRuntime019.vector t c)))<B
  · simp only [StandaloneRuntime019.normTrial,h,ite_true,Option.map_some]
  · simp only [StandaloneRuntime019.normTrial,h,ite_false,Option.map_none]

/-- Generic composition with named vector state/norm/result; the next module
    fills ALL vector premises from the actual machine and source019 proofs. -/
theorem norm_from_vector (i : Input) (s q : State) (n : Nat) (a : Int)
    (z : StandaloneRuntime019.CachedBox) (hn : n<196)
    (hq : exec i vectorCode s=q) (ha : 0≤a ∧ a≤1536*(3*65535^2))
    (q0 : q.reg 0=nw n) (q16 : q.reg 16=word a) (q20 : q.reg 20=0)
    (qimage : readVec q=image z) (anorm : a=Q (decode (StandaloneRuntime019.view z)))
    (fr : Preserves s q) :
    let t := exec i PairProgram020.normTrial s
    answer t=(if Q (decode (StandaloneRuntime019.view z))<B then some (image z) else none) ∧
      t.reg 0=nw (n+1) ∧ Preserves s t := by
  have he : exec i PairProgram020.normTrial s=finish q n a := by
    rw [norm_shape,hq,tail_correct i q n a hn ha q0 q16]
  dsimp only
  rw [he]
  refine ⟨?_,finish_counter _ _ _,preserves_trans fr (finish_preserves _ _ _)⟩
  rw [finish_answer q n a q20,qimage,anorm]
  rfl

end FT1536.S05.NormResponse020C
