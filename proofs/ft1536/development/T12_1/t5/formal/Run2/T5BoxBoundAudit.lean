import Run2.T5BoxTransport

namespace FT1536.Run2.T5BoxBoundAudit

attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

#print axioms FT1536.Run2.T5BoxBound.decode_injective
#print axioms FT1536.Run2.T5BoxBound.infFiberMass_summable
#print axioms FT1536.Run2.T5BoxBound.fiberMass_le_infFiberMass
#print axioms FT1536.Run2.T5BoxTransport.transport_factor_margins
#print axioms FT1536.Run2.T5BoxTransport.flat_reject_of_towers

end FT1536.Run2.T5BoxBoundAudit
