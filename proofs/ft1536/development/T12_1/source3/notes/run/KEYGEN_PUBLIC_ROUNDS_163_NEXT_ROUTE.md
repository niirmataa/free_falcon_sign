# Next after163

PublicMiddleStart163.source constructs t=hn and the full middle section
from Arrays plus hn768 and declared t/m/v cells. The output has t3/m512,
readable input/table arrays and a byte frame. continue_section joins it
with the original tripling association.

Next164: retain initialization of both generated tables across the first
and middle passes, then execute wSet, u=0/v=512 and512 cubic butterflies.
Use the existing PublicGenerateUpper159.mont_u32, PublicSquareSource157,
PublicWordSteps161 and scalar/address helpers; do not recertify modular
arithmetic. PublicInitializedFrame164 is prepared but not accepted at this
checkpoint: it aims to preserve readability of all initially written
uint16 words through supported source statements, including overlapping
stores, without asserting equality of changed values.

Caller-domain assembly still must derive array freshness, table separation,
scalar cells and both forward invocations from SelectedPublicConvert158.
Then public suffix/nonzero/inverse, solver/certificate/codecs and G(seed*).
