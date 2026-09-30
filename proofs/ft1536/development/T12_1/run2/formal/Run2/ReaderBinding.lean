import Run2.TargetLaw
import Run2.MTBinding

namespace FT1536.Run2.ReaderBinding
open Games
open FT1536.Relation

def insertTarget (x : Bytes) (c : Rq) (st : State) : State :=
  ⟨⟨⟨parse x,c,some st.table.used⟩::st.table.table,st.table.seen,st.table.used+1⟩,st.events⟩

noncomputable def finishAt (h : Rq) (f : Forgery) (c : Rq) (st : State) : Option Witness :=
  if accepted h c f then
    match ROM.lookup (parse (f.nonce++f.message)) st.table with
    | none => none
    | some e => e.target.map (fun j => (j,extract h c (PublicSimulation.decodeVec f.signature)))
  else none

noncomputable def doneReader (h : Rq) (st : State) (f : Forgery) (q : ℕ) : Reader (Option Witness) (q+1) :=
  if f.message ∈ st.table.seen ∨ f.nonce.length ≠ 40 then .ret none
  else match ROM.lookup (parse (f.nonce++f.message)) st.table with
  | some e => .ret (finishAt h f e.value st)
  | none => .read fun c => .ret (finishAt h f c (insertTarget (f.nonce++f.message) c st))

noncomputable def compileSolver (S : Sampler) (h : Rq) (st : State) :
    {s q : ℕ} → Program s q → Reader (Option Witness) (q+1)
  | _,q,.done f => doneReader h st f q
  | _,_,.hash x k => match ROM.lookup (parse x) st.table with
    | some e => .weaken (compileSolver S h (recordedHash x e.value st) (k e.value))
    | none => .read fun c => compileSolver S h (recordedHash x c (insertTarget x c st)) (k c)
  | _,_,.sign m k => .sample (signSim S h st m) fun o => match o with
    | none => .ret none
    | some os => compileSolver S h os.2 (k os.1)

def suffix (cs : List Rq) (u n : ℕ) (hn : u+n≤cs.length) : Fin n → Rq :=
  fun i => cs[u+i.val]'(by omega)

theorem suffix_head (cs : List Rq) (u n : ℕ) (hn : u+(n+1)≤cs.length) :
    suffix cs u (n+1) hn 0 = cs[u]'(by omega) := by simp [suffix]

theorem suffix_tail (cs : List Rq) (u n : ℕ) (hn : u+(n+1)≤cs.length) :
    (fun i : Fin n => suffix cs u (n+1) hn i.succ) =
      suffix cs (u+1) n (by omega) := by
  funext i
  simp only [suffix,Fin.val_succ]
  congr 1
  omega

theorem suffix_prefix (cs : List Rq) (u n : ℕ) (hn : u+(n+1)≤cs.length) :
    (fun i : Fin n => suffix cs u (n+1) hn i.castSucc) =
      suffix cs u n (by omega) := rfl

theorem targets_cached (cs : List Rq) (x : Bytes) (st : State)
    (e : ROM.Entry (Option Nonce) Bytes Rq) (he : ROM.lookup (parse x) st.table=some e) :
    hashTargets cs x st=some (e.value,st) := by simp [hashTargets,he]

theorem targets_fresh (cs : List Rq) (x : Bytes) (st : State)
    (he : ROM.lookup (parse x) st.table=none) (hn : st.table.used<cs.length) :
    hashTargets cs x st=some (cs[st.table.used],insertTarget x cs[st.table.used] st) := by
  simp [hashTargets,he,List.getElem?_eq_getElem hn,insertTarget]

theorem done_binding (h : Rq) (st : State) (f : Forgery) (q : ℕ) (cs : List Rq)
    (hn : st.table.used+(q+1)≤cs.length) :
    Reader.preloaded (doneReader h st f q) (suffix cs st.table.used (q+1) hn) =
      Dist.pure (finishSim h cs (some ⟨f,st⟩)) := by
  classical
  simp only [doneReader,finishSim]
  split
  · rfl
  · cases he : ROM.lookup (parse (f.nonce++f.message)) st.table with
    | some e =>
      simp only [Reader.preloaded,targets_cached cs _ st e he,finishAt]
      rfl
    | none =>
      have hh := targets_fresh cs (f.nonce++f.message) st he (by omega)
      simp only [Reader.preloaded,suffix_head,hh,finishAt,insertTarget]
      rfl

theorem compile_binding (S : Sampler) (h : Rq) (cs : List Rq)
    {s q : ℕ} (p : Program s q) : ∀ st, Good cs st →
    ∀ hn : st.table.used+(q+1)≤cs.length,
    Dist.Same (Reader.preloaded (compileSolver S h st p) (suffix cs st.table.used (q+1) hn))
      ((simulate S h cs st p).map (finishSim h cs)) := by
  induction p with
  | done f =>
    intro st _ hn F
    rw [compileSolver,done_binding]
    simp only [simulate,Dist.expect_pure,Dist.expect_map]
  | @hash s q x k ih =>
    intro st hg hn F
    simp only [compileSolver]
    cases he : ROM.lookup (parse x) st.table with
    | some e =>
      have hgood : Good cs (recordedHash x e.value st) := hg
      have hh := targets_cached cs x st e he
      have hind := ih e.value (recordedHash x e.value st) hgood (by dsimp [recordedHash]; omega) F
      simp only [Reader.preloaded,suffix_prefix,simulate,hh,Dist.expect_map]
      exact hind
    | none =>
      have hh := targets_fresh cs x st he (by omega)
      have hgood := (hashTargets_good cs x st _ hg hh).1
      let c := cs[st.table.used]'(by omega)
      have hcount : (insertTarget x c st).table.used+(q+1)≤cs.length := by
        dsimp [insertTarget]; omega
      have hind := ih c (recordedHash x c (insertTarget x c st)) hgood hcount F
      simp only [Reader.preloaded,suffix_head,suffix_tail,simulate,hh,Dist.expect_map]
      exact hind
  | @sign s q m k ih =>
    intro st hg hn F
    simp only [compileSolver,Reader.preloaded,simulate,Dist.expect_bind,Dist.expect_map]
    unfold Dist.expect
    apply Finset.sum_congr rfl
    intro sample _
    have hi := signSim_good S h cs st m hg sample
    cases ho : (signSim S h st m).out sample with
    | none =>
      change (signSim S h st m).law.mass sample*(Dist.pure (none : Option Witness)).expect F =
        (signSim S h st m).law.mass sample*(Dist.pure (none : Option Finished)).expect
          (fun x => F (finishSim h cs x))
      rw [Dist.expect_pure,Dist.expect_pure]
      rfl
    | some os =>
      rw [ho] at hi
      have hcount : os.2.table.used+(q+1)≤cs.length := by rw [hi.2.1]; exact hn
      have hind := ih os.1 os.2 hi.1 hcount F
      have hsuf : suffix cs os.2.table.used (q+1) hcount = suffix cs st.table.used (q+1) hn := by
        funext i
        simp only [suffix,hi.2.1]
      rw [hsuf] at hind
      exact congrArg (fun t => (signSim S h st m).law.mass sample*t) hind

theorem initial_suffix (n : ℕ) (cs : List.Vector Rq n) :
    suffix cs.val 0 n (by simp) = Equiv.vectorEquivFin Rq n cs := by
  funext i
  simp only [suffix,Nat.zero_add]
  rfl

theorem simulate_uniform_targets {s q : ℕ} (S : Sampler) (h : Rq) (p : Program s q) :
    Dist.Same
      ((Dist.draw (Law.uniform : Law (List.Vector Rq (q+1)))).bind fun cs =>
        (simulate S h cs.val initial p).map (finishSim h cs.val))
      (Reader.lazy (compileSolver S h initial p)) := by
  intro F
  have hbridge :
      ((Dist.draw (Law.uniform : Law (List.Vector Rq (q+1)))).bind fun cs =>
        (simulate S h cs.val initial p).map (finishSim h cs.val)).expect F =
      (((Dist.draw (Law.uniform : Law (List.Vector Rq (q+1)))).map
        (Equiv.vectorEquivFin Rq (q+1))).bind (Reader.preloaded (compileSolver S h initial p))).expect F := by
    simp only [Dist.expect_bind,Dist.expect_map]
    apply Dist.expect_congr
    intro cs
    have hh := compile_binding S h cs.val p initial (initial_good cs.val)
      (by simp [initial,ROM.empty]) F
    have hs := initial_suffix (q+1) cs
    change suffix cs.val initial.table.used (q+1) _ = _ at hs
    rw [hs] at hh
    exact hh.symm
  rw [hbridge]
  have ht := Dist.same_bind (vector_targets_iid (q+1))
    (fun cs => Dist.same_refl (Reader.preloaded (compileSolver S h initial p) cs)) F
  rw [ht]
  exact Reader.lazy_sampling (compileSolver S h initial p) F

noncomputable def lazyBuilt (beta : Budget) (muH : Law Rq)
    (A : ClassicalAdversary beta) (S : Sampler) : Dist Bool :=
  (Dist.draw muH).bind fun h =>
    (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
      (Reader.lazy (compileSolver S h initial (A.code h coins))).map Option.isSome

theorem runMT_lazy_binding (beta : Budget) (muH : Law Rq)
    (A : ClassicalAdversary beta) (S : Sampler) :
    Dist.Same (runMT (beta.qh+1) muH (Reduction.build beta A S)) (lazyBuilt beta muH A S) := by
  apply Dist.same_trans (runMT_build_exact beta muH A S)
  intro F
  simp only [solverReturns,lazyBuilt,Dist.expect_bind]
  apply Dist.expect_congr
  intro h
  change ((Dist.draw (Law.uniform : Law (List.Vector Rq (beta.qh+1)))).expect fun cs =>
      (((Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
        (simulate S h cs.val initial (A.code h coins)).map (finishSim h cs.val)).map Option.isSome).expect F) = _
  simp only [Dist.expect_map,Dist.expect_bind]
  have hcomm := Dist.bind_comm
    (Dist.draw (Law.uniform : Law (List.Vector Rq (beta.qh+1))))
    (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool)))
    (fun cs coins => (simulate S h cs.val initial (A.code h coins)).map
      (fun f => (finishSim h cs.val f).isSome)) F
  simp only [Dist.expect_bind,Dist.expect_map] at hcomm
  rw [hcomm]
  apply Dist.expect_congr
  intro coins
  have hh := simulate_uniform_targets S h (A.code h coins) (fun w => F w.isSome)
  simpa only [Dist.expect_bind,Dist.expect_map] using hh

end FT1536.Run2.ReaderBinding
