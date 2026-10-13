import ProducerPipeline020E6

set_option maxRecDepth 8192
namespace FT1536.S05.ProducerMetaSource020E6
open WordRAM020 ProducerExpr020E6 ProducerPipeline020E6 ProducerCoreCircuit020E6

abbrev env (d : BoundaryPayload020E5.Data) (fresh : Bool) := windowSources (window d fresh)

theorem phase (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (env d fresh) (w 0)=word (CoreEncoding020E5.phaseTag d.core.phase).val := window_control d fresh 0

theorem cursor (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (env d fresh) (w 1)=word d.core.cursor.val := window_control d fresh 1

theorem left (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (env d fresh) (w 2)=word d.core.left.val := window_control d fresh 2

theorem sp (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (env d fresh) (w 3)=word d.core.frames.sp.val := window_control d fresh 3

theorem fault (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    eval (env d fresh) (w 15)=WordCodec020E5.boolWord d.core.state.fault := window_control d fresh 15

end FT1536.S05.ProducerMetaSource020E6
