# Error ledger i dependence/read-time order

Pełne exact rational terms i każda outward enclosure są w ERROR_LEDGER.json oraz
artifacts/numeric_certificate.json. Nie użyto fixture maxima jako uniform proof.

|Wielkość|PC/read-time|Discharge|Dowód|
|---|---|---|---|
|U_eta|before each suffix/FFT primitive|PROVED_UNIFORM_OUTWARD|SOURCE_MODEL_BINDING.md|
|completed_both_branch_E|after both subtree returns, before root last sub|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|returned_x_cap|before source1902|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|right_y_cap|before source1902|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|root_product_cap|before source1902|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|root_last_CM_error|before source1902|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|root_last_sub_error|before source1902|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|exact_source_L_reference_image_energy|before source1902|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|source_return_image_error_energy|before source1902|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|triangular_perpendicular_row_norm_squared_cap|before source1902|PROVED_UNIFORM_OUTWARD|SAMPLING_RETURN_INTERFACE.md|
|basis_small_cap|before1904/1905/1906/1908/1911/1912 and1914|PROVED_UNIFORM_OUTWARD|POSTPROCESSING_MAP.md|
|basis_large_cap|before1904/1905/1906/1908/1911/1912 and1914|PROVED_UNIFORM_OUTWARD|POSTPROCESSING_MAP.md|
|coarse_CM_sum_domain_cap|before1904/1905/1906/1908/1911/1912 and1914|PROVED_UNIFORM_OUTWARD|POSTPROCESSING_MAP.md|
|each_source_CM_add_error|before1904/1905/1906/1908/1911/1912 and1914|PROVED_UNIFORM_OUTWARD|POSTPROCESSING_MAP.md|
|actual_post_frequency_cap|before1904/1905/1906/1908/1911/1912 and1914|PROVED_UNIFORM_OUTWARD|POSTPROCESSING_MAP.md|
|mathematical_inverse_eval_coefficient_cap|before1904/1905/1906/1908/1911/1912 and1914|PROVED_UNIFORM_OUTWARD|POSTPROCESSING_MAP.md|
|twiddle_components|before cubic/binary use|PROVED_UNIFORM_OUTWARD|IFFT_SOURCE_PROOF.md|
|Half_error|before terminal half|PROVED_UNIFORM_OUTWARD|IFFT_SOURCE_PROOF.md|
|ifft_stages|inductively before every stage|PROVED_UNIFORM_OUTWARD|IFFT_SOURCE_PROOF.md|
|ifft_error|after scale, before rint|PROVED_UNIFORM_OUTWARD|IFFT_SOURCE_PROOF.md|
|source_word_abs_cap|before1931/1932|PROVED_UNIFORM_OUTWARD|RINT_REFINEMENT.md|
|source_rint_abs_cap|before signed16 cast|PROVED_UNIFORM_OUTWARD|RINT_REFINEMENT.md|
|int64_margin|before rint signed reconstruction|PROVED_UNIFORM_OUTWARD|RINT_REFINEMENT.md|
|static_payload_cap|after3388 norm acceptance, before3412 encoder|PROVED_UNIFORM_OUTWARD|STATIC_BYTES.md|
|Safe16|required BEFORE1931/1932, not after3388|OPEN|PRECAST_DISPOSITION.md|

Źródłowy error iFFT≤1/128, actual word≤4572095+1/128 i rint≤4572095.
Safe16 pozostaje OPEN. Rint/refinement nie odzyskuje niezależnego integer reference.
