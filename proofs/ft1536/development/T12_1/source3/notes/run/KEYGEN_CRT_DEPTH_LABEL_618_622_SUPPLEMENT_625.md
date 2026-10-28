# Supplement: CRT body depth labels in checkpoints 618 and 622

The sealed source comments immediately before `EighthStepCrtBody217.source`
and `NinthStepCrtBody217.source`, and several comments in their companion
`EighthStepCrt217` and `NinthStepCrt217` modules, say respectively "d=4"
and "d=2". The
actual selected source depths are d=8 and d=9. The numbers 4 and 2 are the
respective `num` parameters of the CRT call, not the depth. The preceding
module headers and checked call compositions identify the correct values.

Trap → symptom → cause → correction: a copied comment conflates depth and
CRT num → d=4/d=2 label despite d8/d9 source callers → numeric adaptation
changed prose → read the checked context and distinguish depth from num.
This is a documentation correction; it changes no theorem, source semantics,
result or scope. Sealed sources, reports, receipts and pins stay unchanged.
