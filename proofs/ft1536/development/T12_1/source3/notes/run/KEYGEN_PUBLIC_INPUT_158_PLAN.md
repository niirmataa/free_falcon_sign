# Actual signed public input conversion158

Initial status IN_PROGRESS / NOT_REVIEWED. Entry157 verified55659pins;
ENTRY_PINS SHA256528dbf18337a1e33322eac63ff99a9ba5008fc03449c1751483dcec7b9130290.

From SelectedPublicStart157.ready, derive the actual sampler f/g input
images through norm frames, prove legal uint16 writes without initial
output-image assumptions, and construct all1536 original conversion
iterations. Preserve signed int16 promotion and mq_conv_small source calls.
The unread tails of3072-element input arrays need not be initialized.

Keep the full owner goal active. No IID/D1/F04/empirical premises, no new
axioms or higher limits. One Lean job/process, standard Sage, retained
failures,0/0 accepted logs, small local commits without push and postseal.
Corrected134, frozen110 history, measured wording and five do_sign unchanged.
