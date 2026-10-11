import BinarySearch018
import BinaryCDF018
import CapMap018
import CachedSampler018
import Scatter018
import StoredInterface018
import Meter018
import SamplerTrace018
import WordBounds018
import TraceBudget018

set_option pp.universes true
set_option pp.proofs false

#check @FT1536.S05.BinarySearch018.probe_bound
#print axioms FT1536.S05.BinarySearch018.probe_bound
#check @FT1536.S05.BinarySearch018.halve_capacity
#print axioms FT1536.S05.BinarySearch018.halve_capacity
#check @FT1536.S05.BinarySearch018.search_cut
#print axioms FT1536.S05.BinarySearch018.search_cut
#check @FT1536.S05.BinarySearch018.cut_unique
#print axioms FT1536.S05.BinarySearch018.cut_unique
#check @FT1536.S05.BinaryCDF018.extended_at
#print axioms FT1536.S05.BinaryCDF018.extended_at
#check @FT1536.S05.BinaryCDF018.extended_mono
#print axioms FT1536.S05.BinaryCDF018.extended_mono
#check @FT1536.S05.BinaryCDF018.coord_probes
#print axioms FT1536.S05.BinaryCDF018.coord_probes
#check @FT1536.S05.BinaryCDF018.coord_index_in_range
#print axioms FT1536.S05.BinaryCDF018.coord_index_in_range
#check @FT1536.S05.BinaryCDF018.coord_eq_linear
#print axioms FT1536.S05.BinaryCDF018.coord_eq_linear
#check @FT1536.S05.BinaryCDF018.actual_coord_eq
#print axioms FT1536.S05.BinaryCDF018.actual_coord_eq
#check @FT1536.S05.CapMap018.first_map
#print axioms FT1536.S05.CapMap018.first_map
#check @FT1536.S05.CapMap018.first_congr
#print axioms FT1536.S05.CapMap018.first_congr
#check @FT1536.S05.CachedSampler018.view_save
#print axioms FT1536.S05.CachedSampler018.view_save
#check @FT1536.S05.CachedSampler018.pairTrial_eq
#print axioms FT1536.S05.CachedSampler018.pairTrial_eq
#check @FT1536.S05.CachedSampler018.pair_eq
#print axioms FT1536.S05.CachedSampler018.pair_eq
#check @FT1536.S05.CachedSampler018.vector_eq
#print axioms FT1536.S05.CachedSampler018.vector_eq
#check @FT1536.S05.CachedSampler018.normTrial_eq
#print axioms FT1536.S05.CachedSampler018.normTrial_eq
#check @FT1536.S05.CachedSampler018.cube_eq
#print axioms FT1536.S05.CachedSampler018.cube_eq
#check @FT1536.S05.CachedSampler018.selected_eq
#print axioms FT1536.S05.CachedSampler018.selected_eq
#check @FT1536.S05.CachedSampler018.actual_selected_eq
#print axioms FT1536.S05.CachedSampler018.actual_selected_eq
#check @FT1536.S05.Scatter018.indices_length
#print axioms FT1536.S05.Scatter018.indices_length
#check @FT1536.S05.Scatter018.pair_visits
#print axioms FT1536.S05.Scatter018.pair_visits
#check @FT1536.S05.Scatter018.update_visits_bound
#print axioms FT1536.S05.Scatter018.update_visits_bound
#check @FT1536.S05.Scatter018.coefficient_scale
#print axioms FT1536.S05.Scatter018.coefficient_scale
#check @FT1536.S05.Scatter018.get_fold
#print axioms FT1536.S05.Scatter018.get_fold
#check @FT1536.S05.Scatter018.get_step
#print axioms FT1536.S05.Scatter018.get_step
#check @FT1536.S05.Scatter018.get_multiply
#print axioms FT1536.S05.Scatter018.get_multiply
#check @FT1536.S05.Scatter018.multiply_eq
#print axioms FT1536.S05.Scatter018.multiply_eq
#check @FT1536.S05.Scatter018.get_addAt
#print axioms FT1536.S05.Scatter018.get_addAt
#check @FT1536.S05.Scatter018.get_scatter
#print axioms FT1536.S05.Scatter018.get_scatter
#check @FT1536.S05.Scatter018.sum_indices
#print axioms FT1536.S05.Scatter018.sum_indices
#check @FT1536.S05.StoredInterface018.keyView_saveKey
#print axioms FT1536.S05.StoredInterface018.keyView_saveKey
#check @FT1536.S05.StoredInterface018.challenge_eq
#print axioms FT1536.S05.StoredInterface018.challenge_eq
#check @FT1536.S05.StoredInterface018.run_eq
#print axioms FT1536.S05.StoredInterface018.run_eq
#check @FT1536.S05.StoredInterface018.sampler_eq
#print axioms FT1536.S05.StoredInterface018.sampler_eq
#check @FT1536.S05.StoredInterface018.all_h_ac
#print axioms FT1536.S05.StoredInterface018.all_h_ac
#check @FT1536.S05.StoredInterface018.moment_under_mass
#print axioms FT1536.S05.StoredInterface018.moment_under_mass
#check @FT1536.S05.StoredInterface018.initial_certificate
#print axioms FT1536.S05.StoredInterface018.initial_certificate
#check @FT1536.S05.StoredInterface018.key_law_under_cover
#print axioms FT1536.S05.StoredInterface018.key_law_under_cover
#check @FT1536.S05.Meter018.first_value
#print axioms FT1536.S05.Meter018.first_value
#check @FT1536.S05.Meter018.first_bound
#print axioms FT1536.S05.Meter018.first_bound
#check @FT1536.S05.Meter018.vector_value
#print axioms FT1536.S05.Meter018.vector_value
#check @FT1536.S05.Meter018.vector_bound
#print axioms FT1536.S05.Meter018.vector_bound
#check @FT1536.S05.SamplerTrace018.trial_bound
#print axioms FT1536.S05.SamplerTrace018.trial_bound
#check @FT1536.S05.SamplerTrace018.pair_value
#print axioms FT1536.S05.SamplerTrace018.pair_value
#check @FT1536.S05.SamplerTrace018.pair_bound
#print axioms FT1536.S05.SamplerTrace018.pair_bound
#check @FT1536.S05.SamplerTrace018.vector_value
#print axioms FT1536.S05.SamplerTrace018.vector_value
#check @FT1536.S05.SamplerTrace018.vector_bound
#print axioms FT1536.S05.SamplerTrace018.vector_bound
#check @FT1536.S05.SamplerTrace018.norm_value
#print axioms FT1536.S05.SamplerTrace018.norm_value
#check @FT1536.S05.SamplerTrace018.norm_bound
#print axioms FT1536.S05.SamplerTrace018.norm_bound
#check @FT1536.S05.SamplerTrace018.selected_value
#print axioms FT1536.S05.SamplerTrace018.selected_value
#check @FT1536.S05.SamplerTrace018.selected_bound
#print axioms FT1536.S05.SamplerTrace018.selected_bound
#check @FT1536.S05.SamplerTrace018.run_value
#print axioms FT1536.S05.SamplerTrace018.run_value
#check @FT1536.S05.SamplerTrace018.run_bound
#print axioms FT1536.S05.SamplerTrace018.run_bound
#check @FT1536.S05.WordBounds018.coordinate_bounds
#print axioms FT1536.S05.WordBounds018.coordinate_bounds
#check @FT1536.S05.WordBounds018.block_bound
#print axioms FT1536.S05.WordBounds018.block_bound
#check @FT1536.S05.WordBounds018.half_norm_bound
#print axioms FT1536.S05.WordBounds018.half_norm_bound
#check @FT1536.S05.WordBounds018.norm_width
#print axioms FT1536.S05.WordBounds018.norm_width
#check @FT1536.S05.WordBounds018.cdf_width
#print axioms FT1536.S05.WordBounds018.cdf_width
#check @FT1536.S05.WordBounds018.threshold_width
#print axioms FT1536.S05.WordBounds018.threshold_width
#check @FT1536.S05.WordBounds018.tape_address_width
#print axioms FT1536.S05.WordBounds018.tape_address_width
#check @FT1536.S05.WordBounds018.full_tape_bytes
#print axioms FT1536.S05.WordBounds018.full_tape_bytes
#check @FT1536.S05.WordBounds018.field_product_width
#print axioms FT1536.S05.WordBounds018.field_product_width
#check @FT1536.S05.WordBounds018.field_add_width
#print axioms FT1536.S05.WordBounds018.field_add_width
#check @FT1536.S05.TraceBudget018.expanded_budget
#print axioms FT1536.S05.TraceBudget018.expanded_budget
#check @FT1536.S05.TraceBudget018.weighted_event_bound
#print axioms FT1536.S05.TraceBudget018.weighted_event_bound
#check @FT1536.S05.TraceBudget018.bits_bound
#print axioms FT1536.S05.TraceBudget018.bits_bound
#check @FT1536.S05.TraceBudget018.cdf_reads_bound
#print axioms FT1536.S05.TraceBudget018.cdf_reads_bound
#check @FT1536.S05.TraceBudget018.empty_cap_control
#print axioms FT1536.S05.TraceBudget018.empty_cap_control
#check @FT1536.S05.TraceBudget018.exhaustion_control
#print axioms FT1536.S05.TraceBudget018.exhaustion_control
#check @FT1536.S05.TraceBudget018.early_success_control
#print axioms FT1536.S05.TraceBudget018.early_success_control
#check @FT1536.S05.TraceBudget018.late_success_control
#print axioms FT1536.S05.TraceBudget018.late_success_control
#check @FT1536.S05.TraceBudget018.plateau_cdf_control
#print axioms FT1536.S05.TraceBudget018.plateau_cdf_control
