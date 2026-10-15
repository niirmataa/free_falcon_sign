#143 external checkpoint pins

- Source commits: d9d5e280,57eec111,8dc4af50.
- Receipt KEYGEN_FFT_GROUP_143.json:
  894cab1c48507a5d95dee5e4a93ea8809d97bdeaffc68a2c243459532a76c264.
- Postseal .build/fftgroup143/POSTSEAL_143.json:
  9fb8f638e65dd7c5a7226df05b73bf6458b3ce110979df34ec2ab7434d1ba72b.
- Audit collection:
  fa7390eeb42deed466d6fcac5441126f1671469509b1c80117155c55d8c63f4d.
- Main exports: FftGroupSource143.source; FftGroupsInduction143.source.
- Actual endpoint remains SelectedFftOuterControl142.after (t384,m4).

Generic original group body and group loop are proved; later actual passes,
full KeyGen and positive mass remain open. No independent review or push.
