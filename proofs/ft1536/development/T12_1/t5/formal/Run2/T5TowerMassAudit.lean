import Run2.T5BoxTransport

namespace FT1536.Run2.T5TowerMassAudit

attribute [-instance] FT1536.PublicSimulation.boxVecFintype
attribute [-instance] FT1536.PublicSimulation.boxPairFintype

#print axioms FT1536.Run2.T5TowerMass.atom_eq_exp
#print axioms FT1536.Run2.T5TowerMass.total_eq_tsum
#print axioms FT1536.Run2.T5TowerMass.infFiberMass_eq_quad
#print axioms FT1536.Run2.T5TowerMass.infFiberMass_bounds
#print axioms FT1536.Run2.T5TowerMass.infFiberMass_tilted
#print axioms FT1536.Run2.T5TowerMass.inf_bounds_of_keyTower
#print axioms FT1536.Run2.T5BoxTransport.transport_factor_margins
#print axioms FT1536.Run2.T5BoxTransport.flat_reject_of_towers

end FT1536.Run2.T5TowerMassAudit
