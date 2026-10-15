import Source3.FprUnsignedPrefixes
import Lean

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Untrusted inspection only. Emitted terms still require source equalities. -/
run_cmd Lean.Elab.Command.liftTermElabM do
  let wordType := Lean.mkApp (Lean.mkConst ``BitVec) (Lean.mkNatLit 64)
  Lean.Meta.withLocalDeclD `x wordType fun x =>
    Lean.Meta.withLocalDeclD `y wordType fun y => do
      let state ← Lean.Meta.mkAppM ``FT1536.Source3.FprUnsignedPrefixes.initial #[x,y]
      let execution ← Lean.Meta.mkAppM ``FT1536.Source3.UnsignedState.exec #[
        Lean.mkConst ``FT1536.Source3.FprPrimitives.headerCalls,state,
        Lean.mkConst ``FT1536.Source3.FprUnsignedPrefixes.mulPrefix]
      let stateType := Lean.mkConst ``B20.C.Scalar.State
      let read ← Lean.Meta.withLocalDeclD `state stateType fun s => do
        let values ← Lean.Meta.mkAppM ``B20.C.Scalar.State.values #[s]
        let name := Lean.mkApp (Lean.mkConst ``String.toList) (Lean.mkStrLit "zu")
        Lean.Meta.mkLambdaFVars #[s] (Lean.mkApp values name)
      let selected ← Lean.Meta.mkAppM ``Option.bind #[execution,read]
      let reduced ← Lean.Meta.withTransparency .all <| Lean.Meta.whnf selected
      IO.FS.writeFile "../MUL137_PREFIX_WHNF.txt" (toString (← Lean.Meta.ppExpr reduced))
