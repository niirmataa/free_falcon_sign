import Source3.RxEntry210

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.RxWhole210
open C99ArrayReference (State Name)
open C99ModularReference (GenExec LeafCall GenEval chainOf rxCode rxLoop)
open KeygenModpR2Exec (Slot)
open RxControl210 (word setI)
open RxEntry210 (entry s1 s2 s3 s4 s5 beforeLoop)
open RxModel210 (resultWord)
open RxBody210 (Run)

theorem prefix_source (base : State) (n : Nat) (p pi r2 : BitVec 32) (positive : 0 < n) (bound : n ≤ 1024)
    (out : C99ProcedureReference.Result) (rest : Run (chainOf [rxLoop,KeygenModpRxExec.retZ]) (s5 base n p pi r2) out) :
    Run rxCode (entry base n p pi r2) out := by
  have x2 : Slot (s2 base n p pi r2) "x" (word n) :=
    (RxEntry210.declared_locals base n p pi r2 "x".toList (by decide)).trans (RxEntry210.xCell base n p pi r2)
  have r22 : Slot (s2 base n p pi r2) "R2" r2 :=
    (RxEntry210.declared_locals base n p pi r2 "R2".toList (by decide)).trans (RxEntry210.r2Cell base n p pi r2)
  have p2 : Slot (s2 base n p pi r2) "p" p :=
    (RxEntry210.declared_locals base n p pi r2 "p".toList (by decide)).trans (RxEntry210.pCell base n p pi r2)
  have dec : Run KeygenModpRxExec.xDec (s2 base n p pi r2) ⟨s3 base n p pi r2,.normal⟩ :=
    .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 (word n))) (.uint32 (word (n-1))) x2
      (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ x2) (.literal .int32 1) (RxControl210.sub_one_x n positive (by omega)))))
  have r23 : Slot (s3 base n p pi r2) "R2" r2 := (CrtState205.keep32 (s2 base n p pi r2) "x" "R2" (word (n-1)) (by decide)).trans r22
  have rset : Run KeygenModpRxExec.rSet (s3 base n p pi r2) ⟨s4 base n p pi r2,.normal⟩ :=
    KeygenModpRxExec.rset_run _ r2 none rfl r23
  have p4 : Slot (s4 base n p pi r2) "p" p := (CrtState205.keep32 (s3 base n p pi r2) "r" "p" r2 (by decide)).trans
    ((CrtState205.keep32 (s2 base n p pi r2) "x" "p" (word (n-1)) (by decide)).trans p2)
  have zset : Run KeygenModpRxExec.zSet (s4 base n p pi r2) ⟨s5 base n p pi r2,.normal⟩ :=
    KeygenModpRxExec.zset_run _ p none rfl p4
  rw [KeygenModpRxExec.code_split]
  exact .seqNormal _ _ _ _ _ (KeygenModpRxExec.declI_run _) (.seqNormal _ _ _ _ _ (KeygenModpRxExec.declRZ_run _)
    (.seqNormal _ _ _ _ _ dec (.seqNormal _ _ _ _ _ rset (.seqNormal _ _ _ _ _ zset rest))))

theorem body_source (base : State) (n : Nat) (p pi r2 : BitVec 32) (positive : 0 < n) (bound : n ≤ 1024) :
    ∃ out, Run rxCode (entry base n p pi r2) ⟨out,.returned (some (.uint32 (resultWord n p pi r2)))⟩ := by
  have init : Run KeygenModpRxExec.iInit (s5 base n p pi r2) ⟨beforeLoop base n p pi r2,.normal⟩ :=
    KeygenModpRxExec.iinit_run _ none rfl
  have ic:=RxControl210.i_cell (s5 base n p pi r2) 0
  have pc : Slot (beforeLoop base n p pi r2) "p" p :=
    (RxEntry210.param_locals base n p pi r2 "p".toList (by decide) (by decide) (by decide) (by decide)).trans (RxEntry210.pCell base n p pi r2)
  have pic : Slot (beforeLoop base n p pi r2) "p0i" pi :=
    (RxEntry210.param_locals base n p pi r2 "p0i".toList (by decide) (by decide) (by decide) (by decide)).trans (RxEntry210.iCell base n p pi r2)
  have xBound : (word (n-1)).toNat < 1024 := by
    change (n-1)%2^32 < 1024
    rw [Nat.mod_eq_of_lt (by omega)]
    omega
  obtain ⟨out,loopRun,zc,_,_,_⟩:=RxLoop210.source 10 0 (by decide) (beforeLoop base n p pi r2) (word (n-1))
    (KeygenModpR.word p) r2 p pi xBound ic (RxEntry210.loop_x base n p pi r2) (RxEntry210.loop_z base n p pi r2)
    (RxEntry210.loop_r base n p pi r2) pc pic
  have rxloop : Run rxLoop (s5 base n p pi r2) ⟨out,.normal⟩ := by
    rw [KeygenModpRxExec.loop_split]
    exact .seqNormal _ _ _ _ _ init loopRun
  have ret : Run (chainOf [KeygenModpRxExec.retZ]) out ⟨out,.returned (some (.uint32 (resultWord n p pi r2)))⟩ :=
    .seqExit _ _ _ _ (.ret _ _ _ (RxBody210.cell out "z" _ zc)) (by intro h; cases h)
  exact ⟨out,prefix_source base n p pi r2 positive bound _ (.seqNormal _ _ _ _ _ rxloop ret)⟩

theorem source_exists (base : State) (n : Nat) (p pi r2 : BitVec 32) (positive : 0 < n) (bound : n ≤ 1024) :
    C99ModularReference.rxBody [.uint32 (word n),.uint32 p,.uint32 pi,.uint32 r2] (.uint32 (resultWord n p pi r2)) := by
  obtain ⟨out,run⟩:=body_source base n p pi r2 positive bound
  exact ⟨base,out,by rw [RxEntry210.binding]; exact run⟩

theorem first_bind64 (base : State) (n : Nat) (bound : n < 2^64) :
    C99ArrayReference.bindValue base "x".toList .uint32 (.uint64 (C99NatWord141.word n))=CrtState205.set32 base "x" (word n) := by
  have cast : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint64 (C99NatWord141.word n)).integer=.uint32 (word n) := by
    rw [C99NatWord141.integer n bound]
    change C99IntegerReference.Value.uint32 (BitVec.ofInt 32 (n : Int))=_
    rw [BitVec.ofInt_natCast]
    rfl
  simp only [CrtState205.set32,ModularAtoms178.set,C99ArrayReference.bindValue,cast,KeygenDecodeWordOps.self32]

theorem entry64 (base : State) (n : Nat) (p pi r2 : BitVec 32) (bound : n < 2^64) :
    C99ModularReference.bindParams base C99ModularReference.rxParams
      [.uint64 (C99NatWord141.word n),.uint32 p,.uint32 pi,.uint32 r2]=entry base n p pi r2 := by
  simp only [C99ModularReference.rxParams,C99ModularReference.bindParams]
  rw [first_bind64 base n bound]
  rfl

theorem source64_exists (base : State) (n : Nat) (p pi r2 : BitVec 32) (positive : 0 < n) (bound : n ≤ 1024) :
    C99ModularReference.rxBody [.uint64 (C99NatWord141.word n),.uint32 p,.uint32 pi,.uint32 r2]
      (.uint32 (resultWord n p pi r2)) := by
  obtain ⟨out,run⟩:=body_source base n p pi r2 positive bound
  exact ⟨base,out,by rw [entry64 base n p pi r2 (by omega)]; exact run⟩

theorem call64 (base : State) (n : Nat) (p pi r2 : BitVec 32) (positive : 0 < n) (bound : n ≤ 1024) :
    C99ModularReference.ModCall "modp_Rx".toList [.uint64 (C99NatWord141.word n),.uint32 p,.uint32 pi,.uint32 r2]
      (.uint32 (resultWord n p pi r2)) := .rx _ _ (source64_exists base n p pi r2 positive bound)

end FT1536.Source3.RxWhole210
