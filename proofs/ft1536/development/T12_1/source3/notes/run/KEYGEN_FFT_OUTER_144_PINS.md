#144 external checkpoint pins

- Source commits: cb5d6a39,4cd41e80,76adc1b6.
- Receipt KEYGEN_FFT_OUTER_144.json:
  004fc14fd1282f986e5793eefcb5485011e467eef82c57838772a7e7c6399d13.
- Postseal .build/fftouter144/POSTSEAL_144.json:
  2c3460b9e636de4dac800cc95fe992322a37cac231e7e66760b76a2bc7c0cee0.
- Audit collection:
  cd1d9837b7ccf6301932bbe6b76b3bc898ea09e24874501e55f2dc11eb67a8b4.
- Main export: SelectedFftMiddle144.complete_loop_source.
- Exact continuation: FftMiddleContinuation144.body.
- Actual endpoint: SelectedFftMiddle144.after (t3,m512,full1,logn10).

All middle passes of the first FFT complete; tripling and whole KeyGen still
open. No positive-mass claim, independent review or push.
