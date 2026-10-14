# 116 — computable actual SHAKE process_block with source soundness

Continue the selected public counter9 source witness. Reuse114 memory and115
compact state/argument/scalar soundness. Instantiate read calls from actual
A/RC arrays and prove them against ShakeBlock.ReadCall. Interpret the pinned
ShakeBlockProgram.code with finite fuel and prove each successful computed
result gives the ORIGINAL ShakeBlock.Exec, including stores, scope and loop.
Then construct actual Process calls with the pinned readonly RC table.
No abstract Keccak/SHAKE correctness premise or native result assumption.
Fuel exhaustion is an inconclusive checker result, not a source nonreturn
or failure proof. Concrete replay must use kernel reduction/proof certificates,
not native_decide. Keep partial progress explicit and continue the program.
