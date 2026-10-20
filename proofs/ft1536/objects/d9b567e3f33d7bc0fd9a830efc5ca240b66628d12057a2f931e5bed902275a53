import Source3.KeygenPublicEquations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Every writable callee name is an ACTUAL pointer parameter. Derive its
   nonaliasing from Bind; no additional static-table/input-nonalias premise
   is needed to preserve the SAME original f/g through the complete call. -/
namespace FT1536.Source3.KeygenPublicParameterFrames
open C99ArrayReference (State Name Param)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open KeygenPublicExec (Exec Stmt Program localPointer localEntry localExit allocated)
open KeygenPublicFrame (Signatures Permissions Outside Frame only)

def pointerNames : List Param → List Name
  | [] => []
  | .scalar _ _::rest => pointerNames rest
  | .pointer name::rest => name::pointerNames rest

theorem bind_named (caller : State) (ps : List Param) (args : List C99ArrayReference.Arg) (entry : State)
    (source : KeygenPublicWord.Bind caller ps args entry) (callerNames calleeNames : List Name)
    (checked : C99PointerFootprint.arguments callerNames calleeNames ps args=true) (block : Nat)
    (outside : Outside caller callerNames block) (n : Name) (member : n∈calleeNames) (covered : n∈pointerNames ps) :
    ∀ p, entry.arrays n=some p → p.block≠block := by
  induction source generalizing n with
  | nil => cases covered
  | scalar ty name e ps args out v value rest ih => exact ih checked n member covered
  | pointer name src index p ps args out value rest ih =>
      obtain ⟨hc,hr⟩ := Bool.and_eq_true_iff.mp checked
      by_cases equal : n=name
      · subst n
        have tracked : calleeNames.contains name=true := List.contains_iff_mem.mpr member
        have allowed : src∈callerNames := List.contains_iff_mem.mp (by rw [tracked] at hc; exact hc)
        intro q binding
        have same : p=q := Option.some.inj (by simpa only [C99ArrayReference.bindPointer,ite_true] using binding)
        subst q
        exact KeygenPublicFrame.address caller callerNames src index p value block allowed outside
      · have tail : n∈pointerNames ps := (List.mem_cons.mp covered).resolve_left equal
        intro q binding
        exact ih hr n member tail q (by simpa only [C99ArrayReference.bindPointer,equal,ite_false] using binding)

theorem bind (caller : State) (ps : List Param) (args : List C99ArrayReference.Arg) (entry : State)
    (source : KeygenPublicWord.Bind caller ps args entry) (callerNames calleeNames : List Name)
    (checked : C99PointerFootprint.arguments callerNames calleeNames ps args=true) (block : Nat)
    (outside : Outside caller callerNames block) (covered : ∀ n∈calleeNames, n∈pointerNames ps) : Outside entry calleeNames block :=
  fun n hn => bind_named caller ps args entry source callerNames calleeNames checked block outside n hn (covered n hn)

theorem permissions_covered : ∀ name f, KeygenPublicSource.program name=some f →
    ∀ n∈KeygenPublicSource.permissions name, n∈pointerNames f.params := by
  intro name f lookup
  unfold KeygenPublicSource.program at lookup
  cases found : KeygenPublicSource.find name with
  | none => simp only [found,Option.map_none] at lookup; cases lookup
  | some kind =>
      have same : KeygenPublicSource.function kind=f := Option.some.inj (by simpa only [found,Option.map_some] using lookup)
      subst f
      simp only [KeygenPublicSource.permissions,found,Option.map_some,Option.getD_some,KeygenPublicSource.function]
      cases kind <;> simp [KeygenPublicSource.writable,KeygenPublicSource.params,pointerNames]

theorem body (program : Program) (signatures : Signatures) (permissions : Permissions)
    (aligned : ∀ name f, program name=some f → signatures name=some f.params)
    (closed : ∀ name f, program name=some f → only signatures permissions (permissions name) f.body=true)
    (covered : ∀ name f, program name=some f → ∀ n∈permissions name, n∈pointerNames f.params)
    (signed : List Name) (code : Stmt) (before : State) (out : Result) (source : Exec program signed code before out)
    (names : List Name) (checked : only signatures permissions names code=true) (block : Nat)
    (outside : Outside before names block) (live : 0<before.heap.size block) : Frame before out.state names block := by
  induction source generalizing names with
  | skip | scalar | assign | ret | retVoid | loopFalse => exact ⟨outside,rfl,rfl,rfl,fun _ => rfl⟩
  | declarePointer name s =>
      refine ⟨?_,rfl,rfl,rfl,fun _ => rfl⟩
      intro n hn p hp
      by_cases equal : n=name
      · simp [equal] at hp
      · exact outside n hn p (by simpa [equal] using hp)
  | pointer dst src index s p source =>
      refine ⟨?_,rfl,rfl,rfl,fun _ => rfl⟩
      intro n hn q hq
      by_cases equal : n=dst
      · have tracked : names.contains dst=true := List.contains_iff_mem.mpr (equal ▸ hn)
        have allowed : src∈names := List.contains_iff_mem.mp (by simpa only [only,tracked,Bool.not_true,Bool.false_or] using checked)
        have different := KeygenPublicFrame.address s names src index p source block allowed outside
        have same : p=q := Option.some.inj (by simpa only [C99ArrayReference.bindPointer,equal,ite_true] using hq)
        subst q; exact different
      · exact outside n hn q (by simpa only [C99ArrayReference.bindPointer,equal,ite_false] using hq)
  | store name index cast e before heap p v read value write =>
      have different := KeygenPublicFrame.address before names name index p read block (List.contains_iff_mem.mp checked) outside
      exact ⟨outside,rfl,write.2.2.2.1,write.2.2.2.2.1,
        fun offset => write.2.2.2.2.2.2 block offset (Or.inl (Ne.symm different))⟩
  | call name args f before entry out lookup binding source returned ih =>
      have hc : C99PointerFootprint.arguments names (permissions name) f.params args=true := by
        simpa only [only,aligned name f lookup] using checked
      have oe := bind before f.params args entry binding names (permissions name) hc block outside (covered name f lookup)
      have heap := KeygenPublicWord.bind_heap _ _ _ _ binding
      have keep := ih (permissions name) (closed name f lookup) oe (by rw [heap]; exact live)
      have memory := keep.2.2
      rw [heap] at memory
      exact ⟨outside,rfl,memory⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
      obtain ⟨ha,hb⟩ := Bool.and_eq_true_iff.mp checked
      have first := ih1 names ha outside live
      exact KeygenPublicFrame.compose _ _ _ names block first
        (ih2 names hb first.1 (KeygenPublicFrame.live_after _ _ _ _ first live))
  | seqExit a b before out head exit ih => exact ih names (Bool.and_eq_true_iff.mp checked).1 outside live
  | scope locals pointers code before out source ih =>
      have keep := ih names checked outside live
      refine ⟨?_,keep.2⟩
      intro n hn p hp
      by_cases saved : pointers.contains n=true
      · exact outside n hn p (by simpa only [C99ArrayReference.restoreScope,saved,ite_true] using hp)
      · exact keep.1 n hn p (by simpa only [C99ArrayReference.restoreScope,saved,Bool.false_eq_true,ite_false] using hp)
  | arrayScope name count code before out localBlock positive size fresh source ih =>
      have different : block≠localBlock := by intro equal; subst block; rw [fresh.1] at live; omega
      have oe : Outside (localEntry before name localBlock count) (name::names) block := by
        intro n hn p hp
        by_cases equal : n=name
        · have same : localPointer localBlock count=p := Option.some.inj (by
            simpa only [localEntry,C99ArrayReference.bindPointer,equal,ite_true] using hp)
          subst p; exact Ne.symm different
        · have hn' : n∈names := (List.mem_cons.mp hn).resolve_left equal
          exact outside n hn' p (by simpa only [localEntry,C99ArrayReference.bindPointer,equal,ite_false] using hp)
      have keep := ih (name::names) checked oe (by
        simpa only [localEntry,C99ArrayReference.bindPointer,allocated,different,ite_false] using live)
      refine ⟨?_,keep.2.1,?_,?_,?_⟩
      · intro n hn p hp
        by_cases equal : n=name
        · exact outside n hn p (by simpa only [localExit,C99ArrayReference.restoreScope,List.contains_cons,
            List.contains_nil,Bool.or_false,beq_iff_eq,equal,ite_true] using hp)
        · exact keep.1 n (List.mem_cons_of_mem _ hn) p (by
            simpa only [localExit,C99ArrayReference.restoreScope,List.contains_cons,List.contains_nil,
              Bool.or_false,beq_iff_eq,equal,ite_false] using hp)
      · funext b
        by_cases equal : b=localBlock
        · simp only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,equal,ite_true]
        · simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
            C99ArrayReference.bindPointer,allocated,equal,ite_false] using congrFun keep.2.2.1 b
      · funext b
        by_cases equal : b=localBlock
        · simp only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,equal,ite_true]
        · simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
            C99ArrayReference.bindPointer,allocated,equal,ite_false] using congrFun keep.2.2.2.1 b
      · intro offset
        simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
          C99ArrayReference.bindPointer,allocated,different,ite_false] using keep.2.2.2.2 offset
  | branchTrue condition yes no before out v guard nonzero source ih => exact ih names (Bool.and_eq_true_iff.mp checked).1 outside live
  | branchFalse condition yes no before out v guard zero source ih => exact ih names (Bool.and_eq_true_iff.mp checked).2 outside live
  | loopNormal condition code increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      obtain ⟨hb,hi⟩ := Bool.and_eq_true_iff.mp checked
      have first := ih1 names hb outside live
      have second := ih2 names hi first.1 (KeygenPublicFrame.live_after _ _ _ _ first live)
      exact KeygenPublicFrame.compose _ _ _ names block first
        (KeygenPublicFrame.compose _ _ _ names block second
          (ih3 names checked second.1 (KeygenPublicFrame.live_after _ _ _ _ second (KeygenPublicFrame.live_after _ _ _ _ first live))))
  | loopReturn condition code increment before after v ret guard nonzero source ih => exact ih names (Bool.and_eq_true_iff.mp checked).1 outside live

theorem source_input (s : State) (out : Result) (h p : ArrayPointer) (v : Geometry.Vec)
    (binding : s.arrays "h".toList=some h) (different : h.block≠p.block)
    (legal : KeygenPublicInputMaterial.Legal s.heap p) (material : KeygenMaterial.Represents s.heap p v)
    (source : Exec KeygenPublicSource.program KeygenPublicInputProgram.signed (KeygenPublicSource.code .compute) s out) :
    KeygenMaterial.Represents out.state.heap p v := by
  have outside : Outside s ["h".toList] p.block := by
    intro name member actual bound
    have equal : name="h".toList := by simpa only [List.mem_singleton] using member
    subst name
    have same := Option.some.inj (bound.symm.trans binding)
    subst actual; exact different
  have keep := (body KeygenPublicSource.program KeygenPublicSource.signatures KeygenPublicSource.permissions
    KeygenPublicSource.aligned KeygenPublicSource.closed permissions_covered KeygenPublicInputProgram.signed
    (KeygenPublicSource.code .compute) s out source ["h".toList] (KeygenPublicSource.code_checked .compute).2 p.block
    outside (KeygenPublicInputLifetime.legal_live s.heap p legal)).2.2
  exact KeygenSamplerFrame.represents s.heap out.state.heap p v keep material

end FT1536.Source3.KeygenPublicParameterFrames
