import Source3.KeygenMkgm3Program
import Source3.KeygenNttLoopSupport

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Structural control/frame facts for the already parsed table generator.
   These facts inspect ordinary Exec derivations; they say nothing about
   the values eventually stored in the tables. -/
namespace FT1536.Source3.KeygenMkgm3Control
open C99ModularReference (Stmt Exec chainOf)
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)

def writes : Stmt → List Name
  | .base (.scalar (.declare _ ns)) => ns
  | .base (.scalar (.assign n _)) | .base (.scalar (.update n _ _)) | .assign n _ => [n]
  | .seq a b | .branch _ a b | .loop _ a b => writes a++writes b
  | .scope _ body => writes body
  | _ => []

def supported : Stmt → Bool
  | .base .skip | .base (.scalar (.declare _ _)) | .base (.scalar (.assign _ _))
  | .base (.scalar (.update _ _ _)) | .assign _ _ | .store32 _ _ _ | .storeRev _ _ _ _ _ => true
  | .seq a b | .branch _ a b | .loop _ a b => supported a && supported b
  | .scope _ body => supported body
  | _ => false

def Frame (code : Stmt) (before : State) (out : Result) : Prop :=
  out.flow=.normal ∧ out.state.arrays=before.arrays ∧
    ∀ n, n∉writes code → out.state.locals n=before.locals n

theorem atom (code : Stmt) (before : State) (out : Result)
    (shape : KeygenNttLoopSupport.localOnly code=some (writes code))
    (source : Exec code before out) : Frame code before out := by
  obtain ⟨hf,ha,hl⟩ := KeygenNttLoopSupport.atom_frame code (writes code) before out source shape
  exact ⟨hf,ha,fun n hn => hl n (by simpa only [KeygenNttLoopSupport.contains_iff] using hn)⟩

theorem frame (code : Stmt) (before : State) (out : Result) (hs : supported code=true)
    (source : Exec code before out) : Frame code before out := by
  induction source with
  | base code before after body =>
      cases code with
      | skip => exact atom _ _ _ rfl (.base _ _ _ body)
      | scalar statement =>
          cases statement with
          | declare | assign | update => exact atom _ _ _ rfl (.base _ _ _ body)
          | ret => cases hs
      | assign | declarePtr | bindPtr | store64 | store32 | copy | seq | scope
      | branch | «while» | call => cases hs
  | assign name e before ty old v declared value =>
      exact atom _ _ _ rfl (.assign _ _ _ _ _ _ declared value)
  | store32 name index e before after p v address value write =>
      exact ⟨rfl,rfl,fun _ _ => rfl⟩
  | storeRev name table base index e before after p q bv w v be ta tr address value write =>
      exact ⟨rfl,rfl,fun _ _ => rfl⟩
  | seqNormal first second before middle result head tail ih1 ih2 =>
      have h := Bool.and_eq_true_iff.mp hs
      obtain ⟨_,ha,hl⟩ := ih1 h.1
      obtain ⟨hf,hb,hm⟩ := ih2 h.2
      refine ⟨hf,hb.trans ha,?_⟩
      intro n hn
      have hn' : n∉writes first ∧ n∉writes second := by simpa only [writes,List.mem_append,not_or] using hn
      exact (hm n hn'.2).trans (hl n hn'.1)
  | seqExit first second before result head exit ih =>
      exact (exit (ih (Bool.and_eq_true_iff.mp hs).1).1).elim
  | scope names body before result inner ih =>
      obtain ⟨hf,ha,hl⟩ := ih hs
      refine ⟨hf,ha,?_⟩
      intro n hn
      change (if names.contains n then before.locals n else result.state.locals n)=before.locals n
      split_ifs
      · rfl
      · exact hl n hn
  | branchTrue condition yes no before result v guard nonzero body ih =>
      obtain ⟨hf,ha,hl⟩ := ih (Bool.and_eq_true_iff.mp hs).1
      exact ⟨hf,ha,fun n hn => hl n (fun h => hn (List.mem_append_left _ h))⟩
  | branchFalse condition yes no before result v guard zero body ih =>
      obtain ⟨hf,ha,hl⟩ := ih (Bool.and_eq_true_iff.mp hs).2
      exact ⟨hf,ha,fun n hn => hl n (fun h => hn (List.mem_append_right _ h))⟩
  | loopFalse => exact ⟨rfl,rfl,fun _ _ => rfl⟩
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      have h := Bool.and_eq_true_iff.mp hs
      obtain ⟨_,ha,hl⟩ := ih1 h.1
      obtain ⟨_,hb,hm⟩ := ih2 h.2
      obtain ⟨hf,hc,hn⟩ := ih3 hs
      refine ⟨hf,hc.trans (hb.trans ha),?_⟩
      intro n hp
      have hp' : n∉writes body ∧ n∉writes increment := by simpa only [writes,List.mem_append,not_or] using hp
      exact (hn n hp).trans ((hm n hp'.2).trans (hl n hp'.1))
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      have hf := (ih (Bool.and_eq_true_iff.mp hs).1).1
      cases hf
  | ret | retVoid => cases hs

theorem chain_supported (codes : List Stmt) (hs : ∀ c∈codes, supported c=true) :
    supported (chainOf codes)=true := by
  induction codes with
  | nil => rfl
  | cons c cs ih =>
      exact Bool.and_eq_true_iff.mpr ⟨hs c (by simp),ih (fun d hd => hs d (by simp [hd]))⟩

theorem chain_inv (first : Stmt) (rest : List Stmt) (before : State) (out : Result)
    (hs : supported first=true) (source : Exec (chainOf (first::rest)) before out) :
    ∃ middle, Exec first before ⟨middle,.normal⟩ ∧ Exec (chainOf rest) middle out := by
  cases source with
  | seqNormal _ _ _ middle _ head tail => exact ⟨middle,head,tail⟩
  | seqExit _ _ _ _ head exit => exact (exit (frame first before out hs head).1).elim

def Hoare (code : Stmt) (P Q : State → Prop) : Prop :=
  ∀ before out, P before → Exec code before out → out.flow=.normal ∧ Q out.state

theorem hoare_seq (a b : Stmt) (P Q S : State → Prop)
    (ha : Hoare a P Q) (hb : Hoare b Q S) : Hoare (.seq a b) P S := by
  intro before out hp source
  cases source with
  | seqNormal _ _ _ middle _ first second => exact hb middle out (ha before _ hp first).2 second
  | seqExit _ _ _ _ first exit => exact (exit (ha before out hp first).1).elim

theorem hoare_loop (condition : CLogic.Expr) (body increment : Stmt) (I Q : State → Prop)
    (hb : ∀ before out v, I before → C99ArrayReference.scalar before condition v → v.integer≠0 →
      Exec (.seq body increment) before out → out.flow=.normal ∧ I out.state)
    (hf : ∀ before v, I before → C99ArrayReference.scalar before condition v → v.integer=0 → Q before)
    (normal : supported body=true) : Hoare (.loop condition body increment) I Q := by
  intro before out hi source
  generalize shape : Stmt.loop condition body increment=code at source
  induction source with
  | base | assign | store32 | storeRev | seqNormal | seqExit | scope | branchTrue | branchFalse | ret | retVoid => cases shape
  | loopFalse cond bod inc before v guard zero =>
      cases shape
      exact ⟨rfl,hf before v hi guard zero⟩
  | loopNormal cond bod inc before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      have hn := hb before ⟨next,.normal⟩ v hi guard nonzero
        (.seqNormal body increment before middle ⟨next,.normal⟩ iteration update)
      exact ih3 hn.2 rfl
  | loopReturn cond bod inc before after v value guard nonzero iteration ih =>
      cases shape
      have hn := (frame body before ⟨after,.returned (some value)⟩ normal iteration).1
      cases hn

theorem source_supported : supported KeygenMkgm3Program.code=true := by decide

end FT1536.Source3.KeygenMkgm3Control
