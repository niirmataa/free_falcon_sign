#147 external checkpoint pins

- Own source commits:4c2b987b,fb766036,022ced85,1bc77f6c.
- Receipt KEYGEN_FFT_INPUTS_147.json:
  2e49342bb236c4f556193937cb4fc48f2f669b3e0de420701404e68f16dae1f5.
- Postseal .build/fftinputs147/POSTSEAL_147.json:
  8e42d926730a54abc641de1610ed8c2950890a91bbbfdddf7ff908cebf3ae1fd.
- Audit collection:
  03a62724fa8fa9185e42c6f69c5dfc428bd41f745988b96e7290b73c6ad7c68e.
- Main export: FftTripleBody147.source_and_image.
- Actual endpoint remains SelectedFftMiddle144.after; next is source
  branch initialization and256-iteration loop, then first FFT call closure.

Complete generic body only; whole loop/KeyGen and positive mass still open.
No independent review or push. Shared-main S05/B4 commits are not ours.
