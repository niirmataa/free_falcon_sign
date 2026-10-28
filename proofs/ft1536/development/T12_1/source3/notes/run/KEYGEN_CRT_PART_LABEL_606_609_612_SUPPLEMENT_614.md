# Supplement: CRT pair part labels in checkpoints 606, 609 and 612

The sealed source comment headers in FourthStepCrt216, FifthStepCrt217 and
SixthStepCrt217 respectively say "make_fg part-6 pair", "part-12 pair" and
"part-22 pair". Those numbers are the respective xlen/slen values, not the
number of the source part. The checked composition is `MakeFgCrtShape194.part3`
in each corresponding `FourthStepCrtFirst216.part3`,
`FifthStepCrtFirst217.part3` and `SixthStepCrtFirst217.part3` theorem.

Trap → symptom → cause → correction: copied prose confuses source part index
with the length parameter → misleading part label in a comment → numerical
substitution carried length into the header → read the theorem's actual
`part3` target and keep the 6/12/22 length values separately. This is a
documentation correction; it does not change the checked theorem statements,
source semantics, scope or earlier results. The sealed source, reports,
receipts and pins are unchanged. Future copied headers must say part3.
