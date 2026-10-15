#145 external checkpoint pins

- Source commits:84d44b68,7542dddd.
- Receipt KEYGEN_FFT_TRIPLE_145.json:
  3cdfc99c46a56ea61de7fc02f59ee716144c441f2e688d49b651e592b0ac34bf.
- Postseal .build/ffttriple145/POSTSEAL_145.json:
  ed18fdf9b820a95b267bec04cbe5fd4df7476b226d13a2730ef58414e5992fe2.
- Audit collection:
  456f8cdf2d401cda9088fa412a3db9232845f0727cbe5034c54e0ef17e24bfd1.
- Main exports: FpcMulClosed145.source,FpcSqrClosed145.source,
  FftTripleCalls145.mul/square with actual source bindings.
- Actual endpoint remains SelectedFftMiddle144.after.

Seven macro sites source-bound; six ADD sites and whole tripling still open.
Optional generic expander equality unproved/retained, not a premise. Whole
KeyGen and positive mass open; no independent review or push.
