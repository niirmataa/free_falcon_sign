# MEMORY_FRAME — ramy pamięciowe i read-time

Konsumowane z pinów (JOINT/SOURCE_ORDER §Stan pełny i projekcja, ORDERED frame):
- disjoint const targets/tree/context vs scratch; pełny stan na cut przed
  callbackiem obejmuje PC/stack, live snapshots, immutable tree/basis/targets,
  fault, prng.ptr, block index, historię getter words; unread buffer = ukryta
  część gry (nie składnik legalnej PAST).
- Deterministyczny transducer V_e(h); read-time words w parametrach mu_i(h),
  sigma_i(h) (jednoznaczne także przy cancellation/−0).
- Source-frame simulation: w callbacku jedyne writes poza scalar locals to PRNG
  context i fault; rejected proposal wraca do tej samej pętli bez caller store.
- Recomputed CM: te same operand bits (immutable L, niezmieniony y) — equal-word
  frame; rounded add/sub NIE anulują się idealnie (defekty w ERROR_LEDGER).
Mój zakres nie dodaje nowych bramek pamięciowych ani nie przedefiniowuje PAST.
