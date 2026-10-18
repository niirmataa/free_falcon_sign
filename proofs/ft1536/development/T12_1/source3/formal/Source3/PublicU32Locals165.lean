import Source3.PublicWordSteps161
import Source3.PublicSquareSource157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Shared initialization rules for the fixed straight-line triple body.
   Each rule constructs an execution of the original assignment and reuses
   the already proved modular callee; no arithmetic oracle is a premise. -/
namespace FT1536.Source3.PublicU32Locals165
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec)
open KeygenPublicTableAtoms (Slot var)
open PublicGenerateTable159 (Written)

def Declared (s : State) (name : String) : Prop :=
  ∃ old, s.locals name.toList=some (.uint32,old)
def Env (s : State) (names : List String) : Prop := ∀ name ∈ names, Declared s name
def Has (s : State) (name : String) : Prop := ∃ w : BitVec 32, Slot s name w
def Ready (s : State) (names : List String) : Prop := ∀ name ∈ names, Has s name

theorem declared_after (s : State) (dst name : String) (v : Value) (old : Declared s name) :
    Declared (bindValue s dst.toList .uint32 v) name := by
  by_cases same : name=dst
  · subst name
    exact ⟨some (C99IntegerReference.convert .uint32 v.integer),
      by simp only [bindValue,C99ScalarReference.set,ite_true]⟩
  · obtain ⟨old,slot⟩ := old
    refine ⟨old,?_⟩
    simpa only [bindValue,C99ScalarReference.set,
      show name.toList≠dst.toList from fun h => same (String.toList_injective h),ite_false] using slot

theorem env_after (s : State) (dst : String) (v : Value) (names : List String) (env : Env s names) :
    Env (bindValue s dst.toList .uint32 v) names :=
  fun name member => declared_after s dst name v (env name member)

theorem ready_after (s : State) (dst : String) (v : Value) (names : List String)
    (ready : Ready s names) (new : Has (bindValue s dst.toList .uint32 v) dst) :
    Ready (bindValue s dst.toList .uint32 v) (dst::names) := by
  intro name member
  by_cases same : name=dst
  · subst name; exact new
  · obtain ⟨w,slot⟩ := ready name ((List.mem_cons.mp member).resolve_left same)
    exact ⟨w,KeygenPublicTableAtoms.slot_preserved s name dst w .uint32 v same slot⟩

theorem weaken (s : State) (haveNames wantNames : List String)
    (ready : Ready s haveNames) (subset : ∀ n ∈ wantNames, n ∈ haveNames) : Ready s wantNames :=
  fun n member => ready n (subset n member)

theorem load (s : State) (declared initialized : List String) (env : Env s declared)
    (ready : Ready s initialized) (dst array : String) (index : CLogic.Expr) (p : ArrayPointer)
    (target : dst ∈ declared) (address : KeygenPublicWord.Address s array.toList index p)
    (written : Written s.heap p) :
    ∃ after, Exec KeygenPublicSource.program [] (.assign dst.toList (PublicTailShape159.load array index)) s
      ⟨after,.normal⟩ ∧ Env after declared ∧ Ready after (dst::initialized) ∧ after.heap=s.heap := by
  obtain ⟨old,cell⟩ := env dst target
  obtain ⟨w,run,slot⟩ := PublicWordSteps161.load_assign s dst array index p old cell address written
  exact ⟨_,run,env_after s dst _ declared env,
    ready_after s dst _ initialized ready ⟨_,slot⟩,rfl⟩

theorem mont (s : State) (declared initialized : List String) (env : Env s declared)
    (ready : Ready s initialized) (dst left right : String) (target : dst ∈ declared)
    (leftReady : left ∈ initialized) (rightReady : right ∈ initialized) :
    ∃ after, Exec KeygenPublicSource.program []
      (.assign dst.toList (PublicTailShape159.mont (var left) (var right))) s ⟨after,.normal⟩ ∧
      Env after declared ∧ Ready after (dst::initialized) ∧ after.heap=s.heap := by
  obtain ⟨x,hx⟩ := ready left leftReady
  obtain ⟨y,hy⟩ := ready right rightReady
  obtain ⟨old,cell⟩ := env dst target
  let w := PublicGenerateRow159.rowValue x y
  have run : Exec KeygenPublicSource.program []
      (.assign dst.toList (PublicTailShape159.mont (var left) (var right))) s
      ⟨bindValue s dst.toList .uint32 (.uint32 w),.normal⟩ :=
    .assign _ _ _ .uint32 old (.uint32 w) cell (PublicGenerateRow159.mont_var s left right x y hx hy)
  exact ⟨_,run,env_after s dst _ declared env,
    ready_after s dst _ initialized ready ⟨w,PublicGenerateRow159.u32_slot_after s dst w⟩,rfl⟩

def squareWord (x : BitVec 32) : BitVec 32 := KeygenPublicLeafWords.montgomery
  (PublicArgumentSource157.word (.u32 x)) (PublicArgumentSource157.word (.u32 x))
  (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18433)))
  (PublicArgumentSource157.word (.i32 (BitVec.ofInt 32 18431)))

theorem square (s : State) (declared initialized : List String) (env : Env s declared)
    (ready : Ready s initialized) (dst src : String) (target : dst ∈ declared) (input : src ∈ initialized) :
    ∃ after, Exec KeygenPublicSource.program []
      (.assign dst.toList (PublicTailShape159.sqr (var src))) s ⟨after,.normal⟩ ∧
      Env after declared ∧ Ready after (dst::initialized) ∧ after.heap=s.heap := by
  obtain ⟨x,hx⟩ := ready src input
  obtain ⟨old,cell⟩ := env dst target
  have ev : KeygenPublicWord.Eval [] s (PublicTailShape159.sqr (var src)) (.uint32 (squareWord x)) :=
    .call3 _ _ _ _ (.uint32 x) (C99IntegerReference.convert .int32 18433)
      (C99IntegerReference.convert .int32 18431) _
      (PublicGenerateHead159.eval_var s src x hx)
      (PublicGenerateHead159.eval_lit s 18433) (PublicGenerateHead159.eval_lit s 18431)
      (PublicSquareSource157.source (.u32 x) (.i32 (BitVec.ofInt 32 18433)) (.i32 (BitVec.ofInt 32 18431)))
  have run : Exec KeygenPublicSource.program []
      (.assign dst.toList (PublicTailShape159.sqr (var src))) s
      ⟨bindValue s dst.toList .uint32 (.uint32 (squareWord x)),.normal⟩ :=
    .assign _ _ _ .uint32 old (.uint32 (squareWord x)) cell ev
  exact ⟨_,run,env_after s dst _ declared env,
    ready_after s dst _ initialized ready ⟨_,PublicGenerateRow159.u32_slot_after s dst (squareWord x)⟩,rfl⟩

end FT1536.Source3.PublicU32Locals165
