import Source3.LeafScan

namespace FT1536.Source3.CElementLoop
open B20.C
abbrev Word := BitVec 64
abbrev Flag := BitVec 32

/- A single-array-element view of a scalar loop. All occurrences of a[i]
in a loop iteration designate one initialized word; the counter and bound
are size_t64, and bad is a distinct initialized uint32_t local. The view
has no alias with the scalar locals or constants. This is a local typed
fragment, not a byte-heap refinement for the whole enclosing function. -/
def cellName : B20.C.Name := "__ft1536_array_cell".toList

def projectElement (array index : B20.C.Name) : List Token → Option (List Token)
  | a::['[']::i::[']']::rest =>
      if a=array ∧ i=index then (projectElement array index rest).map (cellName::·)
      else none
  | ['[']::_ | [']']::_ => none
  | t::rest => (projectElement array index rest).map (t::·)
  | [] => some []

structure Loop where
  index : B20.C.Name
  bound : B20.C.Name
  array : B20.C.Name
  body : List CLogic.Stmt
  deriving DecidableEq, Repr

def parseTokens (array : B20.C.Name) : List Token → Option Loop
  | forTk::['(']::i::['=']::zero::[';']::i'::['<']::n::[';']::i''::['+','+']::[')']::['{']::rest => do
      if forTk="for".toList ∧ zero="0".toList ∧ i=i' ∧ i=i'' ∧
          ¬rest.contains cellName then do
        let projected ← projectElement array i rest
        let (stmts,tail) ← CLogicParser.body 64 projected
        if tail.isEmpty then pure ⟨i,n,array,stmts⟩ else none
      else none
  | _ => none

def parse (array : B20.C.Name) (chars : List Char) : Option Loop :=
  (LeafScan.tokenize (chars.length+1) chars).bind (parseTokens array)

def initial (globals : Env) (w : Word) (bad : Flag) : B20.C.Scalar.State where
  types name := if name=cellName then some .u64
    else if name="bad".toList then some .u32 else none
  values name := if name=cellName then some (.u64 w)
    else if name="bad".toList then some (.u32 bad) else globals name

def body (calls : B20.C.Scalar.Calls) (globals : Env) (code : Loop)
    (w : Word) (bad : Flag) : Option (Word × Flag) := do
  let st ← LeafRange.runStmts calls code.body (initial globals w bad)
  match ← st.values cellName, ← st.values "bad".toList with
  | .u64 z,.u32 flag => pure (z,flag)
  | _,_ => none

def run (calls : B20.C.Scalar.Calls) (globals : Env) (code : Loop) (limit : BitVec 64) :
    Nat → BitVec 64 → List Word → Flag → Option (List Word × Flag)
  | 0,_,_,_ => none
  | fuel+1,i,ws,bad =>
      if i.toNat<limit.toNat then do
        let w ← ws[i.toNat]?
        let (z,flag) ← body calls globals code w bad
        run calls globals code limit fuel (i+1) (ws.set i.toNat z) flag
      else some (ws,bad)

def scan (step : Word → Flag → Word × Flag) : List Word → Flag → List Word × Flag
  | [],bad => ([],bad)
  | w::ws,bad =>
      let next:=step w bad
      let rest:=scan step ws next.2
      (next.1::rest.1,rest.2)

theorem suffix_binding (calls : B20.C.Scalar.Calls) (globals : Env) (code : Loop)
    (step : Word → Flag → Word × Flag)
    (hbody : ∀ w bad, body calls globals code w bad=some (step w bad)) (xs : List Word) :
    ∀ (pre : List Word) (bad : Flag) (limit : BitVec 64),
      limit.toNat=pre.length+xs.length →
      run calls globals code limit (xs.length+1) (BitVec.ofNat 64 pre.length) (pre++xs) bad=
        some (pre++(scan step xs bad).1,(scan step xs bad).2) := by
  induction xs with
  | nil =>
      intro pre bad limit hl
      simp only [List.length_nil,Nat.add_zero] at hl
      have hp : pre.length<2^64 := by have hh:=limit.isLt; omega
      simp only [List.length_nil,List.append_nil,scan,run,BitVec.toNat_ofNat,
        Nat.mod_eq_of_lt hp,hl,lt_self_iff_false,ite_false]
  | cons x xs ih =>
      intro pre bad limit hl
      have hh:=limit.isLt
      have hp : pre.length<2^64 := by simp only [List.length_cons] at hl; omega
      have hc : pre.length<limit.toNat := by simp only [List.length_cons] at hl; omega
      rw [show (x::xs).length+1=(xs.length+1)+1 from rfl,run]
      simp only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt hp,hc,ite_true]
      simp only [LeafScan.get_at_prefix,bind,Option.bind,hbody,
        LeafScan.index_succ,LeafScan.set_at_prefix]
      have hi:=ih (pre++[(step x bad).1]) (step x bad).2 limit (by
        simp only [List.length_append,List.length_cons,List.length_nil]
        simp only [List.length_cons] at hl
        omega)
      simpa only [List.length_append,List.length_singleton,List.append_assoc,
        List.singleton_append,scan] using hi

theorem scan_binding (calls : B20.C.Scalar.Calls) (globals : Env) (code : Loop)
    (step : Word → Flag → Word × Flag)
    (hbody : ∀ w bad, body calls globals code w bad=some (step w bad))
    (ws : List Word) (bad : Flag) (h : ws.length<2^64) :
    run calls globals code (BitVec.ofNat 64 ws.length) (ws.length+1) 0#64 ws bad=
      some (scan step ws bad) := by
  have hh:=suffix_binding calls globals code step hbody ws [] bad
    (BitVec.ofNat 64 ws.length) (by
      simp only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt h,List.length_nil,Nat.zero_add])
  simpa only [List.length_nil,List.nil_append,Prod.mk.eta] using hh

end FT1536.Source3.CElementLoop

#print axioms FT1536.Source3.CElementLoop.scan_binding
