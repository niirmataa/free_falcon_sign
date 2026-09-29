# Granica powiązania z kodem

- Source17: `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
- Wszystkie17 plików, exact set i SHA sprawdzone w `artifacts/preflight.json`.
- `artifacts/SOURCE_SPANS.json`: całe pliki, numery linii, SHA literalnych
  wycinków dla target/terminal/binary/cubic/root/suffix/iFFT/rint.
- C harness zawiera byte-exact terminal1633–1650 oraz suffix1902–1912,
  generowane z RO source. Polymul/add i FPEMU linkowane z oryginalnych plików.
  Parser, licencje i Makefile flags są zachowane; nie linkuje się całego Sign,
  KeyGen ani loadera. Callback zwraca ustalone publiczne liczby, nie sampluje.
- `C_SOURCE_BINDING.json` wiąże wycinki z wygenerowanym harness i wynikami.
  Normal/UBSan/ASan są finite diagnostics z preflightem, nie kernel proofs.
- Terminalny harness zapisuje actual mu0 z callbacku oraz returned z1.
  rx/sub0 są **ponownie obliczone** oryginalnymi pure primitives na tych
  samych word operands; porównuje się final raw z0. Nie opisujemy ich jako
  in-process instrumentation ani jako kernelowego determinism/frame proofu.

**Nie wykazano kernelowego C→algebra refinementu.** `formal/Ledger.lean`
operuje na pierścieniu i jawnym additive hom. Użycie tej algebry dla source
wymaga związania każdego read-time operand, wartości wyniku i defektu.
Hashe, ręczna mapa i zgodny C slice nie dostarczają tego twierdzenia.
Nie importuje się nieodebranego P02 jako premise. Warunki celu pozostają
niezmienione; source words ±0 i subnormal nie są zastępowane IEEE idealizacją.

Historyczne mixed certyfikaty służą do diagnozy i wskazania brakujących typów.
Nie ma twierdzenia o całym kompilatorze/maszynie, Safe16, stored norm,
Sign→Verify, retry/PRNG ani security. Wszystkie production/source change
flags pozostają false.
