# Checkpoint170 target and computation contract

Target: prove that every t word in the actual SelectedForwardT168.output
is nonzero, through SelectedEvaluation169.source and a fully kernel-checked
finite certificate for the same sampler-derived fVector. The field is
ZMod18433 and the physical point ordering is KeygenPublicRoots.point.

The certificate has1536 input coefficients, first-pass values, eight
radix stages,1536 final values and1024 twiddle candidates. Reusable
first/radix/triple soundness lemmas must identify those values with the
existing source-derived polynomial evaluation theorem. Each candidate
array is data; kernel checks must prove all input/transition/nonzero
facts. No values imported from Sage are premises.

Auxiliary command: tools/job111.py sage keygen_publicforward159_149
keygen_evaluation170_control.sage. The exact Sage GF(18433) computation
checks every physical point independently by direct polynomial evaluation,
all1536 roots of X^1536-X^768+1, and gcd(f,phi)=1. Its input is the pinned
native synthetic witness DECODED.json, while the mandatory kernel input
check separately ties coefficients to SelectedSamplerWords158.fValues.
It is only a finite candidate/control, not a source or probability proof.

Use the existing job111 resource/serialization policy. Preserve failures,
audit named declarations with full DAG roundtrip/fresh safe kernel checks,
seal/postseal and make small local commits. No full public return1,
whole-KeyGen witness, Z positivity or acceptance/coding bound is claimed
by this target alone. Public quotient/inverse and solver/codecs remain.
