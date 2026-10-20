import Source3.KeygenPublicParser

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicFrame
open C99ArrayReference (State Name)
open C99MemoryReference
open KeygenPublicExec
open C99ProcedureReference (Result)

abbrev Signatures := Name → Option (List C99ArrayReference.Param)
abbrev Permissions := Name → List Name
def only (signatures : Signatures) (permissions : Permissions) (names : List Name) : Stmt → Bool
  | .skip | .scalar _ | .assign _ _ | .declarePointer _ | .ret _ => true
  | .pointer dst src _ => !(names.contains dst) || names.contains src
  | .store dst _ _ _ => names.contains dst
  | .call name args => match signatures name with
    | some ps => C99PointerFootprint.arguments names (permissions name) ps args
    | none => false
  | .seq a b | .branch _ a b | .loop _ a b => only signatures permissions names a && only signatures permissions names b
  | .scope _ _ b => only signatures permissions names b
  | .arrayScope name _ b => only signatures permissions (name::names) b
def Outside (s : State) (names : List Name) (block : Nat) : Prop :=
  ∀ name∈names, ∀ p, s.arrays name=some p → p.block≠block
def Tables (s : State) (block : Nat) : Prop := ∀ name p, s.tables name=some p → p.block≠block
def Frame (before after : State) (names : List Name) (block : Nat) : Prop :=
  Outside after names block ∧ after.tables=before.tables ∧ ShakeExtractFrame.SameBlock before.heap after.heap block
theorem address (s : State) (names : List Name) (name : Name) (index : CLogic.Expr) (p : ArrayPointer)
    (source : KeygenPublicWord.Address s name index p) (block : Nat)
    (member : name∈names) (outside : Outside s names block) : p.block≠block := by
  cases source with
  | add root p i binding value nonnegative within => cases within; exact outside name member root binding
theorem bind (caller : State) (ps : List C99ArrayReference.Param) (args : List C99ArrayReference.Arg) (entry : State)
    (source : KeygenPublicWord.Bind caller ps args entry) (callerNames calleeNames : List Name)
    (checked : C99PointerFootprint.arguments callerNames calleeNames ps args=true) (block : Nat)
    (outside : Outside caller callerNames block) (tables : Tables caller block) : Outside entry calleeNames block := by
  induction source with
  | nil => exact fun n _ p hp => tables n p hp
  | scalar ty name e ps args out v value rest ih => exact ih checked
  | pointer name src index p ps args out value rest ih =>
    obtain ⟨hc,hr⟩ := Bool.and_eq_true_iff.mp checked
    have keep := ih hr
    intro n hn q hq
    by_cases eq : n=name
    · subst n
      have hm : calleeNames.contains name=true := List.contains_iff_mem.mpr hn
      have hs : src∈callerNames := List.contains_iff_mem.mp (by rw [hm] at hc; exact hc)
      have he : p=q := Option.some.inj (by simpa only [C99ArrayReference.bindPointer,ite_true] using hq)
      subst q
      exact address caller callerNames src index p value block hs outside
    · exact keep n hn q (by simpa only [C99ArrayReference.bindPointer,eq,ite_false] using hq)
theorem bind_tables (caller : State) (ps : List C99ArrayReference.Param) (args : List C99ArrayReference.Arg) (entry : State)
    (source : KeygenPublicWord.Bind caller ps args entry) : entry.tables=caller.tables := by
  induction source <;> first | rfl | assumption
theorem compose (a b c : State) (names : List Name) (block : Nat) (first : Frame a b names block) (second : Frame b c names block) :
    Frame a c names block := ⟨second.1,second.2.1.trans first.2.1,ShakeExtractFrame.same_trans _ _ _ block first.2.2 second.2.2⟩
theorem live_after (a b : State) (names : List Name) (block : Nat) (first : Frame a b names block)
    (live : 0<a.heap.size block) : 0<b.heap.size block := by rw [first.2.2.1]; exact live
theorem tables_after (a b : State) (names : List Name) (block : Nat) (first : Frame a b names block)
    (tables : Tables a block) : Tables b block := by simpa only [Tables,first.2.1] using tables
theorem body (program : Program) (signatures : Signatures) (permissions : Permissions)
    (aligned : ∀ name f, program name=some f → signatures name=some f.params)
    (closed : ∀ name f, program name=some f → only signatures permissions (permissions name) f.body=true)
    (signed : List Name) (code : Stmt) (before : State) (out : Result) (source : Exec program signed code before out)
    (names : List Name) (checked : only signatures permissions names code=true) (block : Nat)
    (outside : Outside before names block) (tables : Tables before block) (live : 0<before.heap.size block) :
    Frame before out.state names block := by
  induction source generalizing names with
  | skip | scalar | assign | ret | retVoid | loopFalse => exact ⟨outside,rfl,rfl,rfl,fun _ => rfl⟩
  | declarePointer name s =>
    refine ⟨?_,rfl,rfl,rfl,fun _ => rfl⟩
    intro n hn p hp
    by_cases eq : n=name
    · simp [eq] at hp
    · exact outside n hn p (by simpa [eq] using hp)
  | pointer dst src index s p source =>
    refine ⟨?_,rfl,rfl,rfl,fun _ => rfl⟩
    intro n hn q hq
    by_cases eq : n=dst
    · have hm : names.contains dst=true := List.contains_iff_mem.mpr (eq ▸ hn)
      have hs : src∈names := List.contains_iff_mem.mp (by simpa only [only,hm,Bool.not_true,Bool.false_or] using checked)
      have different := address s names src index p source block hs outside
      have he : p=q := Option.some.inj (by simpa only [C99ArrayReference.bindPointer,eq,ite_true] using hq)
      subst q; exact different
    · exact outside n hn q (by simpa only [C99ArrayReference.bindPointer,eq,ite_false] using hq)
  | store name index cast e before heap p v read value write =>
    have different := address before names name index p read block (List.contains_iff_mem.mp checked) outside
    exact ⟨outside,rfl,write.2.2.2.1,write.2.2.2.2.1,
      fun offset => write.2.2.2.2.2.2 block offset (Or.inl (Ne.symm different))⟩
  | call name args f before entry out lookup binding source returned ih =>
    have hc : C99PointerFootprint.arguments names (permissions name) f.params args=true := by
      simpa only [only,aligned name f lookup] using checked
    have oe := bind before f.params args entry binding names (permissions name) hc block outside tables
    have ht := bind_tables _ _ _ _ binding
    have hh := KeygenPublicWord.bind_heap _ _ _ _ binding
    have keep := ih (permissions name) (closed name f lookup) oe
      (by simpa only [Tables,ht] using tables) (by rw [hh]; exact live)
    have memory := keep.2.2
    rw [hh] at memory
    exact ⟨outside,rfl,memory⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    have a := ih1 names ha outside tables live
    exact compose _ _ _ names block a (ih2 names hb a.1 (tables_after _ _ _ _ a tables) (live_after _ _ _ _ a live))
  | seqExit a b before out head exit ih => exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables live
  | scope locals pointers body before out source ih =>
    have keep := ih names checked outside tables live
    refine ⟨?_,keep.2⟩
    intro n hn p hp
    by_cases saved : pointers.contains n=true
    · exact outside n hn p (by simpa only [C99ArrayReference.restoreScope,saved,ite_true] using hp)
    · exact keep.1 n hn p (by simpa only [C99ArrayReference.restoreScope,saved,Bool.false_eq_true,ite_false] using hp)
  | arrayScope name count code before out localBlock positive size fresh source ih =>
    have different : block≠localBlock := by intro h; subst block; rw [fresh.1] at live; omega
    have oe : Outside (localEntry before name localBlock count) (name::names) block := by
      intro n hn p hp
      by_cases eq : n=name
      · have he : localPointer localBlock count=p := Option.some.inj (by
          simpa only [localEntry,C99ArrayReference.bindPointer,eq,ite_true] using hp)
        subst p; exact Ne.symm different
      · have hn' : n∈names := (List.mem_cons.mp hn).resolve_left eq
        exact outside n hn' p (by simpa only [localEntry,C99ArrayReference.bindPointer,eq,ite_false] using hp)
    have keep := ih (name::names) checked oe tables (by
      simpa only [localEntry,C99ArrayReference.bindPointer,allocated,different,ite_false] using live)
    refine ⟨?_,keep.2.1,?_,?_,?_⟩
    · intro n hn p hp
      by_cases eq : n=name
      · exact outside n hn p (by simpa only [localExit,C99ArrayReference.restoreScope,List.contains_cons,
          List.contains_nil,Bool.or_false,beq_iff_eq,eq,ite_true] using hp)
      · exact keep.1 n (List.mem_cons_of_mem _ hn) p (by
          simpa only [localExit,C99ArrayReference.restoreScope,List.contains_cons,List.contains_nil,
            Bool.or_false,beq_iff_eq,eq,ite_false] using hp)
    · funext b
      by_cases eq : b=localBlock
      · simp only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,eq,ite_true]
      · simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
          C99ArrayReference.bindPointer,allocated,eq,ite_false] using congrFun keep.2.2.1 b
    · funext b
      by_cases eq : b=localBlock
      · simp only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,eq,ite_true]
      · simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
          C99ArrayReference.bindPointer,allocated,eq,ite_false] using congrFun keep.2.2.2.1 b
    · intro offset
      simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
        C99ArrayReference.bindPointer,allocated,different,ite_false] using keep.2.2.2.2 offset
  | branchTrue condition yes no before out v guard nonzero source ih => exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables live
  | branchFalse condition yes no before out v guard zero source ih => exact ih names (Bool.and_eq_true_iff.mp checked).2 outside tables live
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
    have a := ih1 names ha outside tables live
    have b := ih2 names hb a.1 (tables_after _ _ _ _ a tables) (live_after _ _ _ _ a live)
    exact compose _ _ _ names block a (compose _ _ _ names block b
      (ih3 names checked b.1 (tables_after _ _ _ _ b (tables_after _ _ _ _ a tables))
        (live_after _ _ _ _ b (live_after _ _ _ _ a live))))
  | loopReturn condition body increment before after v ret guard nonzero source ih => exact ih names (Bool.and_eq_true_iff.mp checked).1 outside tables live

end FT1536.Source3.KeygenPublicFrame
