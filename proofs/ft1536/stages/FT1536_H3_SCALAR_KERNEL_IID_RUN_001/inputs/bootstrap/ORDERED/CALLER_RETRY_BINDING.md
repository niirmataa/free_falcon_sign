# Root entry, scalar context i retry scope

TARGETS certyfikuje do_sign1849–1892 dla wszystkich canonical challenges,
normalized emitted key i legal buffers. Root call1897 ma parametry opisane
w MEMORY_FRAME; nie czyta samplera przed cut. Source3355–3359 przy ter1
inicjalizuje tsc.p, ustawia tsc.fault=NONE i wybiera sampler_large. Zatem
initial fault/key-call choice są source facts, nie nową premise P_key.

Jawny PRNG interface: context jest legalnym typed/live prng+fault object,
get_u8/get_u64 na jego aktualnym stanie są zdefiniowanymi legalnymi odczytami
i zwracają odpowiednio8/64-bit words; refill ma własne standardowe memory
premises. Teza finite-prefix nie twierdzi termination całego generatora,
uniformity, independence, indifferentiability lub sampling law. Publiczne
test tapes abstrakcyjnie reprezentują możliwe outcomes, nie source seeds.

HM powstaje3325 przed outer loop, ma canonical range po defined H2P return.
Każdy legalny entry nowego attemptu nadpisuje targets od nowa. Nie wymaga
future norm acceptance i dotyczy też legalnych entries po norm rejection.
Źródłowy conditional frame: sampling nie ma writable key/hm pointer,
do_sign postprocessing czyta sk i zapisuje tmp/s1/s2; na defined prefixes
przy legal disjointness sk/hm zachowane. Fault reset jest next-attempt entry,
nie elementem recursion. Source3374 po do_sign wychodzi przy fault, a
ordinary norm failure może powrócić do outer loop.

Nie utożsamiamy tego conditional frame z dowodem, że cały poprzedni attempt
był defined lub zawsze wrócił. Source iFFT/rint/signed16 narrowing i serialized
signature pozostają poza bieżącym proofem. Nie ma wnioskowania wstecz od
udanego Sign lub Q<B do pierwszego mu. Cap16 nie ogranicza inner rejection.

Wyprowadzony caller corollary aktualnie obejmuje tylko active floors z
pierwszej root branch, przy powyższym legal-entry/finite-prefix scope.
Pełny caller ordered reach zależy od otwartego left-root transfer. P_key,
Emitted, single K_seed[E]/p_K i obserwacje/budżety M0 pozostają bez zmian.
