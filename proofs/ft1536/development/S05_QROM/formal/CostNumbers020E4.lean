import CostCertificate020E4

namespace FT1536.S05.CostNumbers020E4
/-- Computed by Sage; this equality, not generator output, is authoritative in Lean. -/
theorem total : CostDriver020E4.price=11763954238966829723 := by
  norm_num [CostDriver020E4.price,CostInput020E4.price,CostBoundary020E4.initialPrice,
    CostBoundary020E4.copyPrice,CostProgram020E4.price,CostBoot020E4.price,
    CostParse020E4.loadPrice,CostParse020E4.emptyPrice,CostParse020E4.parsePrice,
    CostParserStep020E4.price,CostParserStep020E4.commitPrice,CostProgram020E4.fromPrice,
    CostExecute020E4.price,CostExecute020E4.stepPrice,CostExecute020E4.pushManyPrice,
    CostAction020E4.price,CostValues020E4.buildPrice,CostValues020E4.stepPrice,
    CostAtom020E4.writeBound,CostState020E4.writePrice,CostFrames020E4.pushPrice,
    CostBank020E4.writePrice,BankProgram020E3.frameCapacity,NodeProgram020E2.controlLimit,
    WordRAM020.tapeSize,WordRAM020.romSize,WordRAM020.ramSize,WordRAM020.outputSize]

theorem every_call (k : CostInput020E4.Key) (coins : JointInterface019.Bits WordRAM020.tapeSize) :
    CostRun020E4.Bounded (CostDriver020E4.run k coins) 11763954238966829723 11763954238966829723 := by
  rw [←total]
  exact CostDriver020E4.bound k coins

/-- Payload-size statement for the declared one-word-per-Bool storage model;
    neither a native Lean measurement nor a packed tape claim. -/
theorem coin_payload_bytes : 64*WordRAM020.tapeSize=1578402447360 := by norm_num [WordRAM020.tapeSize]

end FT1536.S05.CostNumbers020E4
