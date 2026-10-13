import Source3.KeygenAttemptSerialization079
import Source3.KeygenPublicObserved077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSecretChain081
open C99ArrayReference (State)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env)
open KeygenCodecTypedSegments (Site Segments arguments nextState)
open KeygenCodecStaticComplete (encoded)
open KeygenCodecStaticHistory (positions)
open KeygenCodecByteHistory (Trace)

def bytes (inputs : Fin 4 → List (BitVec 16)) (start : Nat) : List (BitVec 8) :=
  ((List.finRange 4).drop start).flatMap (fun slot => encoded (inputs slot))

theorem bytes_step (inputs : Fin 4 → List (BitVec 16)) (slot : Fin 4) :
    bytes inputs slot.val=encoded (inputs slot)++bytes inputs (slot.val+1) := by
  fin_cases slot <;> rfl

theorem bytes_done (inputs : Fin 4 → List (BitVec 16)) (i : Nat) (bound : 4 ≤ i) : bytes inputs i=[] := by
  unfold bytes
  rw [List.drop_eq_nil_of_le (show (List.finRange 4).length ≤ i from bound)]
  rfl

theorem bytes_zero (inputs : Fin 4 → List (BitVec 16)) : bytes inputs 0=
    encoded (inputs 0)++encoded (inputs 1)++encoded (inputs 2)++encoded (inputs 3) := by
  change (encoded (inputs 0)++(encoded (inputs 1)++(encoded (inputs 2)++(encoded (inputs 3)++[]))))=_
  simp only [List.append_nil,List.append_assoc]

def Cursor (s : State) (offset : Nat) : Prop :=
  s.locals "skoff".toList=some (.uint64,some (.uint64 (BitVec.ofNat 64 offset)))

def CallBytes (env : Env) (inputs : Fin 4 → List (BitVec 16)) (c : Site env) : Prop :=
  c.ret=BitVec.ofNat 64 (encoded (inputs c.index)).length ∧
  Trace c.before.heap c.after
    (positions (arguments env c.before c.index c.after c.ret c.site).out 0 (encoded (inputs c.index)))

theorem next_cursor (env : Env) (c : Site env) (old : BitVec 64) (n k : Nat)
    (oldEq : old=BitVec.ofNat 64 n) (returned : c.ret=BitVec.ofNat 64 k) :
    Cursor (nextState c old) (n+k) := by
  change some (C99IntegerReference.Ty.uint64,some (C99IntegerReference.Value.uint64 (old+c.ret)))=
    some (C99IntegerReference.Ty.uint64,some (C99IntegerReference.Value.uint64 (BitVec.ofNat 64 (n+k))))
  rw [oldEq,returned,BitVec.ofNat_add_ofNat]

/-- Concatenate the four source-derived write traces and derive the actual
    cursor after the loop. Arithmetic bounds are local consequences of the
    encoded input lists when this lemma is consumed by the caller proof. -/
theorem source_trace (env : Env) (i : Nat) (s : State) (out : Result) (calls : List (Site env))
    (source : Segments env i s out calls) (inputs : Fin 4 → List (BitVec 16)) :
    ∀ n, Cursor s n → n+(bytes inputs i).length<2^64 →
      (∀ c, c∈calls → CallBytes env inputs c) → out.flow=.normal →
      Trace s.heap out.state.heap (positions (some env.args.privkey) n (bytes inputs i)) ∧
      Cursor out.state (n+(bytes inputs i).length) := by
  induction source with
  | done i s bound counter =>
    intro n cursor small outcomes normal
    rw [bytes_done inputs i bound]
    exact ⟨.nil _,by simpa only [List.length_nil,Nat.add_zero] using cursor⟩
  | capacity c counter zero =>
    intro n cursor small outcomes normal
    cases normal
  | next c counter nonzero old oldCell rest ih =>
    intro n cursor small outcomes normal
    obtain ⟨retEq,first⟩ := outcomes c (List.mem_cons_self)
    have siteEq : c.site.skoff=BitVec.ofNat 64 n := by simpa using c.site.skoffCell.symm.trans cursor
    have oldEq : old=BitVec.ofNat 64 n := by simpa using oldCell.symm.trans cursor
    rw [bytes_step] at small
    have nSmall : n<2^64 := by omega
    have nextSmall : n+(encoded (inputs c.index)).length+(bytes inputs (c.index.val+1)).length<2^64 := by
      simpa only [List.length_append,Nat.add_assoc] using small
    have offsetEq : c.site.skoff.toNat=n := by rw [siteEq,BitVec.toNat_ofNat,Nat.mod_eq_of_lt nSmall]
    change Trace c.before.heap c.after
      (positions (some (KeygenCodecExecution.byteOff env.args.privkey c.site.skoff.toNat)) 0
        (encoded (inputs c.index))) at first
    rw [KeygenPublicObserved077.positions_shift,offsetEq,Nat.add_zero] at first
    obtain ⟨tailTrace,tailCursor⟩ := ih (n+(encoded (inputs c.index)).length)
      (next_cursor env c old n _ oldEq retEq) nextSmall
      (fun d member => outcomes d (List.mem_cons_of_mem _ member)) normal
    rw [bytes_step,KeygenCodecStaticHistory.positions_append]
    refine ⟨KeygenCodecByteHistory.append _ _ _ _ _ first tailTrace,?_⟩
    simpa only [List.length_append,Nat.add_assoc] using tailCursor

theorem length_bound (inputs : Fin 4 → List (BitVec 16))
    (counts : ∀ slot, (inputs slot).length=1536) (start : Nat) : (bytes inputs start).length≤105984 := by
  have bound (slots : List (Fin 4)) :
      (slots.flatMap (fun slot => encoded (inputs slot))).length≤slots.length*26496 := by
    induction slots with
    | nil => simp
    | cons slot rest ih =>
      have first := (KeygenCodecStaticLength.profile_bounds (inputs slot) (counts slot)).2
      rw [←KeygenCodecStaticLength.encoded_length] at first
      simp only [List.flatMap_cons,List.length_append,List.length_cons]
      omega
  have result := bound ((List.finRange 4).drop start)
  have length : ((List.finRange 4).drop start).length≤4 := by
    rw [List.length_drop]
    change 4-start≤4
    omega
  exact result.trans (by omega)

end FT1536.Source3.KeygenSecretChain081
