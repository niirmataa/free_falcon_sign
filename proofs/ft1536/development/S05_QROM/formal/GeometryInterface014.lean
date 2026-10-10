import SamplerMassCondition014

set_option pp.fullNames true
set_option pp.universes true

/- Interface inspection only, not extra theorem claims. -/
#check @FT1536.S05.PrimaryBlock014.A_cap
#check @FT1536.S05.Parseval014.parseval_matrix
#check @FT1536.S05.FullEvaluation014.actual_intertwining
#check @FT1536.S05.SpectralBlocks014.A_spectral
#check @FT1536.S05.SpectralBlocks014.C_spectral
#check @FT1536.S05.SpectralBlocks014.D_spectral
#check @FT1536.S05.ReciprocalSchur014.actual_schur_spectral
#check @FT1536.S05.ReciprocalSchur014.mass_from_actual_harmonic
#print FT1536.S05.SamplerMassCondition014.Temperature
#print FT1536.S05.SamplerMassCondition014.MassCondition
#check @FT1536.S05.SamplerMassCondition014.sampler007_mass_condition
#print axioms FT1536.S05.SamplerMassCondition014.sampler007_mass_condition
