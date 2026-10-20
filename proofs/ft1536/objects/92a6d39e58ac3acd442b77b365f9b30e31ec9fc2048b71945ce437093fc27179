import Source3.LeafRange

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.LeafScan
open B20.C KeygenHelpers
open FT1536.Run2.KeygenLeafGate

/- The lexer extends the same token classes with array delimiters and ++.
It does not preprocess source text or discard an unsupported statement. -/
def tokenize : Nat → List Char → Option (List Token)
  | 0,_ => none
  | _+1,[] => some []
  | fuel+1,'/'::'*'::rest => do
      let tail ← B20.C.Scalar.skipBlock (rest.length+1) rest
      tokenize fuel tail
  | fuel+1,'/'::'/'::rest => tokenize fuel (rest.dropWhile (· != '\n'))
  | fuel+1,c::cs =>
      if c==' ' || c=='\t' || c=='\n' || c=='\r' then tokenize fuel cs
      else if wordChar c then
        let tail:=cs.takeWhile wordChar
        (tokenize fuel (cs.drop tail.length)).map ((c::tail)::·)
      else match c,cs with
        | '+','+'::rest => (tokenize fuel rest).map (['+','+']::·)
        | '>','>'::'='::rest => (tokenize fuel rest).map (['>','>','=']::·)
        | '<','<'::'='::rest => (tokenize fuel rest).map (['<','<','=']::·)
        | '>','>'::rest => (tokenize fuel rest).map (['>','>']::·)
        | '<','<'::rest => (tokenize fuel rest).map (['<','<']::·)
        | '&','&'::rest => (tokenize fuel rest).map (['&','&']::·)
        | '|','|'::rest => (tokenize fuel rest).map (['|','|']::·)
        | _,'='::rest =>
            if ['+','-','*','^','&','|','=','!','<','>'].contains c then
              (tokenize fuel rest).map ([c,'=']::·)
            else none
        | _,_ =>
            if ['(',')','{','}','[',']',';',',','^','&','|','-','+','*','~','=','!','<','>'].contains c then
              (tokenize fuel cs).map ([c]::·)
            else none

structure Loop where
  index : B20.C.Name
  bound : B20.C.Name
  array : B20.C.Name
  flag : B20.C.Name
  bits : B20.C.Name
  valid : B20.C.Name
  stableCallee : B20.C.Name
  bitsCallee : B20.C.Name
  tail : List CLogic.Stmt
  deriving DecidableEq, Repr

def parseTokens : List Token → Option Loop
  | forTk::['(']::i::['=']::zero::[';']::i'::['<']::n::[';']::i''::['+','+']::[')']::['{']::
      ty64::bits::[';']::ty32::valid::[';']::
      arr::['[']::aidx::[']']::['=']::stable::['(']::arr'::['[']::aidx'::[']']::[',']::['&']::flag::[')']::[';']::
      bits'::['=']::getBits::['(']::arr''::['[']::aidx''::[']']::[')']::[';']::rest => do
    if forTk="for".toList ∧ zero="0".toList ∧ i'=i ∧ i''=i ∧ aidx=i ∧ aidx'=i ∧ aidx''=i ∧
        arr'=arr ∧ arr''=arr ∧ bits'=bits ∧ B20.C.Scalar.typeToken ty64=some .u64 ∧
        B20.C.Scalar.typeToken ty32=some .u32 then do
      let (tail,rest) ← CLogicParser.body 64 rest
      if rest.isEmpty then pure ⟨i,n,arr,flag,bits,valid,stable,getBits,tail⟩ else none
    else none
  | _ => none

def parse (chars : List Char) : Option Loop :=
  (tokenize (chars.length+1) chars).bind parseTokens

def program : Loop := ⟨"u".toList,"n".toList,"leaves".toList,"bad".toList,"bits".toList,"valid".toList,
  "ft_stable_positive_keygen".toList,bitsName,LeafRange.tail⟩

theorem source_parses : parse (slice 7764 11)=some program := by decide

def heap (bad : Flag) : CRefWord.Heap := fun p => if p=0 then some bad else none

/- This bounded fragment uses the actual fixed scalar local names and
callee table of the parsed source. It rejects names outside that scope.
The range expressions themselves are evaluated, not replaced by a gate. -/
def body (code : Loop) (w : Word) (bad : Flag) : Option (Word × Flag) := do
  if code.flag≠"bad".toList ∨ code.bits≠"bits".toList ∨ code.valid≠"valid".toList ∨
      code.stableCallee≠"ft_stable_positive_keygen".toList then none else do
    let (value,m) ← CRefWord.execute StablePositive.pureCalls StablePositive.globals
      StablePositive.program (heap bad) [.word (.u64 w),.ref32 0]
    match value with
    | .u64 z => do
        let bits ← StablePositive.pureCalls code.bitsCallee [.u64 z]
        let bad' ← m 0
        match bits with
        | .u64 ws => do
            let (_,flag) ← LeafRange.runTail StablePositive.pureCalls code.tail ws bad'
            pure (z,flag)
        | _ => none
    | _ => none

theorem body_binding (w : Word) (bad : Flag) : body program w bad=some (leafStep w bad) := by
  have hm : heap bad 0=some bad := by simp [heap]
  simp only [body,program,ne_eq,not_true_eq_false,or_self,ite_false]
  rw [StablePositive.execute_word w bad (heap bad) 0 hm]
  simp only [StablePositive.bits_call,LeafRange.execute_tail]
  rfl

/- UInt64 counter, checked list accesses and in-place stores; the fuel
annotation is proved sufficient. No source-level early exit is inserted. -/
def run (code : Loop) (limit : BitVec 64) : Nat → BitVec 64 → List Word → Flag → Option (List Word × Flag)
  | 0,_,_,_ => none
  | fuel+1,i,ws,bad =>
      if i.toNat<limit.toNat then do
        let w ← ws[i.toNat]?
        let (z,flag) ← body code w bad
        run code limit fuel (i+1) (ws.set i.toNat z) flag
      else some (ws,bad)

theorem index_succ (i : Nat) : (BitVec.ofNat 64 i)+1=BitVec.ofNat 64 (i+1) := by
  exact BitVec.ofNat_add_ofNat i 1

theorem get_at_prefix {α : Type} (pre : List α) (x : α) (xs : List α) :
    (pre++x::xs)[pre.length]?=some x := by
  rw [List.getElem?_append_right (Nat.le_refl _)]
  simp

theorem set_at_prefix {α : Type} (pre : List α) (x y : α) (xs : List α) :
    (pre++x::xs).set pre.length y=pre++y::xs := by
  rw [List.set_append_right _ _ (Nat.le_refl _)]
  simp

theorem suffix_binding (xs : List Word) : ∀ (pre : List Word) (bad : Flag)
    (limit : BitVec 64), limit.toNat=pre.length+xs.length →
    run program limit (xs.length+1) (BitVec.ofNat 64 pre.length) (pre++xs) bad=
      some (pre++(scan xs bad).1,(scan xs bad).2) := by
  induction xs with
  | nil =>
    intro pre bad limit hl
    simp only [List.length_nil,Nat.add_zero] at hl
    have hp : pre.length<2^64 := by have hh:=limit.isLt; omega
    simp only [List.length_nil,List.append_nil,scan,run,BitVec.toNat_ofNat,Nat.mod_eq_of_lt hp,hl,lt_self_iff_false,ite_false]
  | cons x xs ih =>
    intro pre bad limit hl
    have hh:=limit.isLt
    have hp : pre.length<2^64 := by simp only [List.length_cons] at hl; omega
    have hc : pre.length<limit.toNat := by simp only [List.length_cons] at hl; omega
    rw [show (x::xs).length+1=(xs.length+1)+1 from rfl,run]
    simp only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt hp,hc,ite_true]
    simp only [get_at_prefix,bind,Option.bind,body_binding,index_succ,set_at_prefix]
    have hi:=ih (pre++[(leafStep x bad).1]) (leafStep x bad).2 limit (by
      simp only [List.length_append,List.length_cons,List.length_nil]
      simp only [List.length_cons] at hl
      omega)
    simpa only [List.length_append,List.length_singleton,List.append_assoc,List.singleton_append,scan] using hi

theorem scan_binding (ws : List Word) (bad : Flag) (h : ws.length<2^64) :
    run program (BitVec.ofNat 64 ws.length) (ws.length+1) 0#64 ws bad=some (scan ws bad) := by
  have hh:=suffix_binding ws [] bad (BitVec.ofNat 64 ws.length) (by
    simp only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt h,List.length_nil,Nat.zero_add])
  simpa only [List.length_nil,List.nil_append,Prod.mk.eta] using hh

theorem source_scan_1536 (ws : List Word) (bad : Flag) (hlen : ws.length=1536) :
    (parse (slice 7764 11)).bind (fun code => run code 1536#64 1537 0#64 ws bad)=some (scan ws bad) := by
  rw [source_parses,Option.bind_some]
  have hh:=scan_binding ws bad (by rw [hlen]; decide)
  simpa only [hlen] using hh

theorem source_accepted_all_leaves (ws result : List Word) (bad : Flag)
    (hlen : ws.length=1536)
    (hexec : (parse (slice 7764 11)).bind (fun code => run code 1536#64 1537 0#64 ws bad)=some (result,0#32)) :
    bad=0#32 ∧ result=ws ∧ ∀ w∈ws,positive w=true ∧ (1024 : ℝ)≤positiveNormalValue w := by
  rw [source_scan_1536 ws bad hlen] at hexec
  have he:=Option.some.inj hexec
  have hc : (scan ws bad).2=0#32 := congrArg Prod.snd he
  exact ⟨((scan_clear ws bad).mp hc).1,
    (congrArg Prod.fst he).symm.trans (accepted_scan_preserves ws bad hc),
    successful_scan_all_leaf_values ws bad hc⟩

/- The actual inclusive word gate is stronger than the coarse 1024 lower
bound, and does not silently replace the emitted-key source obligation. -/
theorem source_accepted_exact_word_interval (ws result : List Word) (bad : Flag)
    (hlen : ws.length=1536)
    (hexec : (parse (slice 7764 11)).bind
      (fun code => run code 1536#64 1537 0#64 ws bad)=some (result,0#32)) :
    result=ws ∧ bad=0#32 ∧ ∀ w∈ws,
      positive w=true ∧ lowerBits.toNat≤w.toNat ∧ w.toNat≤upperBits.toNat := by
  rw [source_scan_1536 ws bad hlen] at hexec
  have he:=Option.some.inj hexec
  have hc : (scan ws bad).2=0#32 := congrArg Prod.snd he
  exact ⟨(congrArg Prod.fst he).symm.trans (accepted_scan_preserves ws bad hc),
    ((scan_clear ws bad).mp hc).1,((scan_clear ws bad).mp hc).2⟩

end FT1536.Source3.LeafScan

#print FT1536.Source3.LeafScan.source_accepted_all_leaves
#print axioms FT1536.Source3.LeafScan.source_parses
#print axioms FT1536.Source3.LeafScan.body_binding
#print axioms FT1536.Source3.LeafScan.source_scan_1536
#print axioms FT1536.Source3.LeafScan.source_accepted_all_leaves
#print axioms FT1536.Source3.LeafScan.source_accepted_exact_word_interval
