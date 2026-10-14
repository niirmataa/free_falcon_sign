import Source3.KeygenPrivateDispatcher107

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicSite108
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env PublicSite)
open KeygenPublicCallerSite077 (arguments Site nextState)

theorem arguments_equal (env : Env) (before : State) (a b : Memory) (x y : BitVec 64)
    (first : PublicSite env .encodeT before a x) (second : PublicSite env .encodeT before b y) :
    arguments env before a x first = arguments env before b y second := by
  have capacities : first.klen = second.klen := by simpa using first.klenCell.symm.trans second.klenCell
  have degrees : first.logn = second.logn := by simpa using first.lognCell.symm.trans second.lognCell
  simp only [arguments, capacities, degrees]

theorem call_unique (env : Env) (before : State) (a b : Memory) (x y : BitVec 64)
    (siteA : PublicSite env .encodeT before a x) (siteB : PublicSite env .encodeT before b y)
    (first : KeygenPublicEncodeExecution077.Call (arguments env before a x siteA) before.heap a x)
    (second : KeygenPublicEncodeExecution077.Call (arguments env before b y siteB) before.heap b y) : a = b ∧ x = y := by
  have same := arguments_equal env before a b x y siteA siteB
  rw [same] at first
  exact KeygenPublicExecution106.call_unique _ before.heap a b x y first second

theorem sites (env : Env) (a b : Site env) (same : a.before = b.before) : a.after = b.after ∧ a.ret = b.ret := by
  cases a with
  | mk beforeA afterA retA siteA execA =>
      cases b with
      | mk beforeB afterB retB siteB execB =>
          change beforeA = beforeB at same
          subst beforeB
          exact call_unique env beforeA afterA afterB retA retB siteA siteB execA execB

theorem head (env : Env) (before : State) (a b : Result) (xs ys : List (Site env))
    (first : KeygenPublicCallerExecution077.Head env KeygenMakeProgram.publicDispatch before a xs)
    (second : KeygenPublicCallerExecution077.Head env KeygenMakeProgram.publicDispatch before b ys) : a = b := by
  obtain ⟨ca, beforeA, outA, callsA⟩ := KeygenPublicCallerExecution077.public_extract env before a xs first
  obtain ⟨cb, beforeB, outB, callsB⟩ := KeygenPublicCallerExecution077.public_extract env before b ys second
  have sameBefore := beforeA.trans beforeB.symm
  have same := sites env ca cb sameBefore
  rw [outA, outB]
  unfold nextState
  rw [sameBefore, same.1, same.2]

end FT1536.Source3.KeygenPublicSite108
