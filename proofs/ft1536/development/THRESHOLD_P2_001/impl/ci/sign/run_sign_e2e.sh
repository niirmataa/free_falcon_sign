#!/bin/sh
# WP-031 — e2e sign 2-z-3 na prawdziwym silniku FT1536 (TEST-ORACLE).
#
# Buduje harness C (`sign_e2e.c` + źródła silnika `Extra/c`), generuje
# syntetyczny klucz testowy (seed 0x42), uruchamia protokół sign 2-z-3
# w Rust (testkit: dealer + oracle-sampler) i weryfikuje wynikowe podpisy
# **silnikiem C** (`falcon_vrfy`): pin F2 `gold-ff`, trzy pary rosteru
# oraz przypadek negatywny (przekłamany udział → brak podpisu).
#
# Flaga kompilacji 1:1 z `ci/kat/run_falcon_kat.sh` (profil FT1536
# candidate). Artefakty wyłącznie w `impl/.build/sign/` — plik
# `testkey.bin` zawiera bufor `sk` syntetycznego klucza (NIE jest
# commitowany; `.build/` jest ignorowane) i jest czyszczony na końcu.
# Bez sieci; Cargo działa z `--offline`.
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
IMPL_DIR=$(cd "$SCRIPT_DIR/../.." && pwd)
REPO_DIR=$(cd "$IMPL_DIR/../../../../.." && pwd)
ENGINE_DIR="$REPO_DIR/Extra/c"
BUILD_DIR="$IMPL_DIR/.build/sign"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

ENGINE_FILES="falcon-keygen.c falcon-sign.c falcon-vrfy.c falcon-enc.c \
falcon-fft.c fpr-emulated.c frng.c shake.c shake.h falcon.h internal.h \
fpr-double.h ft1536-adaptive-cdf-tables.h"

for f in $ENGINE_FILES; do
    [ -f "$ENGINE_DIR/$f" ] || fail "brak pliku silnika: $ENGINE_DIR/$f"
done

mkdir -p "$BUILD_DIR"
echo "== build harnessa C (silnik FT1536) =="
set -- \
    -W -Wall -O \
    '-DFPR_IMPL="fpr-emulated.h"' \
    -DSAMPLER_CODF=0 \
    -DSAMPLER_CDF=0 \
    -DCT_BEREXP=1 \
    -DFT_TERNARY_ADAPTIVE_CDF=1 \
    -DFT1536_CANDIDATE_PROFILE=1 \
    -DCLEANSE=1 \
    -DTRUE_TERNARY_SECRET=1 \
    -DTRUE_TERNARY_SECRET_MODE=1 \
    -DTERNARY_KEYGEN_BOUND_SCALE_NUM=1250 \
    -DTERNARY_KEYGEN_BOUND_SCALE_DEN=100 \
    -DTERNARY_KEYGEN_MAX_ATTEMPTS=3000000 \
    -DSIGN_MAX_ATTEMPTS=16 \
    -I"$ENGINE_DIR" \
    -o "$BUILD_DIR/sign_e2e" \
    "$SCRIPT_DIR/sign_e2e.c"
for f in shake.c falcon-enc.c falcon-vrfy.c falcon-sign.c \
    falcon-keygen.c falcon-fft.c fpr-emulated.c frng.c; do
    set -- "$@" "$ENGINE_DIR/$f"
done
cc "$@"

echo "== keygen (syntetyczny klucz testowy, seed 0x42) =="
"$BUILD_DIR/sign_e2e" keygen "$BUILD_DIR/testkey.bin"

echo "== protokół sign 2-z-3 (Rust) + weryfikacja silnikiem C =="
export CARGO_NET_OFFLINE=true
cargo run --quiet --offline -p ft-threshold-testkit \
    --example sign_e2e --features test-oracle -- \
    "$BUILD_DIR/testkey.bin" "$BUILD_DIR/sign_e2e" "$BUILD_DIR/out" \
    | tee "$BUILD_DIR/summary.txt"

grep -q "^E2E PASS" "$BUILD_DIR/summary.txt" \
    || fail "e2e nie osiągnął PASS (patrz $BUILD_DIR/summary.txt)"

echo "== higiena: czyszczenie syntetycznego sk =="
rm -f "$BUILD_DIR/testkey.bin" "$BUILD_DIR/out/case.txt"

echo "OK: WP-031 e2e — engine verify na wszystkich wektorach"
