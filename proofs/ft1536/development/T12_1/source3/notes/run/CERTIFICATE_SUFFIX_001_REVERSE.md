# CERTIFICATE_SUFFIX_001 — reverse reciprocal, krok2/3

Status: PROVED_KERNEL_SCOPED etapowego reverse / NOT_REVIEWED.
Kompozycja całego suffixu i scan są nadal w pracy.

- `CertificateIndex` wiąże sparsowane `n-1-u` z niezależnym Eval C99/GCC
  size_t. Dla u<768 dowodzi dokładnego1535-u, braku underflow/overflow,
  zakresu768…1535, injectivity i pełnego coverage. Guard i increment
  korzystają z ustalonego profilu1536/768.
- `CertificateReverse.Step/Loop/Finished` są niezależnymi relacjami;
  nie zawierają operational run=some. Każdy krok wymaga źródłowego Load64,
  actual fpr_div, stable-positive z RMW i Store64 z deskryptorem obiektu.
- `loop_complete` zachowuje cały heap i trace. `final_count` wyprowadza768
  z true guards i final false guard.
- `loop_exists` konstruuje wykonanie z Legal i Snapshot D pierwszych768
  słów. Nie wymaga inicjalizacji drugiej połowy. Zapisane słowo to
  stableWord rzeczywistego source div(q,D[u]), nie idealny iloraz.
- `finished_complete` składa zgodność, legalność, pełny memory/trace
  invariant, zachowanie Snapshot oraz wszystkie zapisane Word64.
- `Written` wiąże div witness także z eventem positive w końcowym śladzie;
  `clear_written` wyprowadza brak fallbacku przy clear, bez przyjmowania go.
- `initialized` dowodzi czytelności wszystkich1536 słów po reverse.

Event trace rozróżnia positive/lower/upper; newest-first jak poprzednio.
Lower/upper są przygotowane do następnego scanu, reverse emituje positive.
`CertificateEffects` zachowuje metadata, roots/frame, sticky oraz clear
przez flagRMW i leaf stores. Writes nie wymagają starych initialized bytes.

Accepted/clean: `certificate_effects_002`, `certificate_atoms_001`,
`certificate_index_002`, `certificate_reverse_004`.
Poprzednie próby z błędami elaboracji, reducibility/numeral/Fin i brakującym
open namespace są zachowane w `.build/jobs/` z oryginalnymi źródłami.
Finalny fresh replay i zbiorczy audyt nastąpi po kompozycji scanu.

Nie eksportowano idealnej tożsamości q²/D. Snapshot D nie jest założeniem
populacji kluczy: to snapshot pamięci na granicy etapów. W finalnym theorem
powstaje z ukończonego top; obecny etap nie jest dowodem całego certificate.
