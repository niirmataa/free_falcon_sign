# fuzz/corpus — deterministyczny korpus fuzz (WP-022)

## Co to jest

`wire/*.bin` — 44 pliki binarne dla testu
`crates/ft-threshold-protocol/tests/fuzz_wire.rs`:

- `ok_body.bin`, `ok_envelope.bin` — poprawne, kanoniczne bajty wire v1
  (muszą się dekodować i re-kodować bajt w bajt),
- `bad_01..bad_10*.bin` — warianty non-canonical (muszą być odrzucone),
- `mut_00..mut_31.bin` — seedowane mutacje poprawnej koperty
  (dopuszczalne Ok/Err, zakaz paniki; przy Ok — fixpoint).

Kontrakt nazw: prefiks `ok_`/`bad_`/`mut_` decyduje o oczekiwanym
zachowaniu testu; liczba plików (44) jest asertowana.

## Proweniencja i regeneracja

Wszystkie pliki są **syntetyczne i publiczne** (zero sekretów) i są
generowane deterministycznie przez `impl/ci/fuzz/gen_corpus.py` z
niezależnej referencji CBOR (`impl/ci/wire/cbor_reference.py`). Bitowa
odtwarzalność jest weryfikowana w CI:

```sh
cd proofs/ft1536/development/THRESHOLD_P2_001/impl
./ci/fuzz/run_fuzz_corpus.sh            # cmp 44/44 plików
./ci/fuzz/run_fuzz_corpus.sh --update   # tylko po świadomej zmianie
```

Zmiana formatu wire albo generatora **wymaga** świadomego `--update`
(nowy pin w dowodzie WP-022), nie cichej regeneracji.

Uwaga: `*.bin` jest ignorowane przez `proofs/ft1536/development/.gitignore`
(artefakty builda); ten katalog jest celowo wyłączony przez negację
`!fuzz/corpus/wire/*.bin` w `impl/.gitignore`, bo korpus jest pinem testu.
