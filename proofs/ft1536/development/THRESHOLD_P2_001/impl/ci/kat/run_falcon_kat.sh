#!/bin/sh
# WP-024 — regeneracja i weryfikacja KAT z rzeczywistego silnika FT1536.
#
# Tryby:
#   ./run_falcon_kat.sh            — weryfikacja: przebuduj generator,
#                                    wygeneruj KAT na nowo, porównaj bajt
#                                    po bajcie z `impl/KAT/`, sprawdź hash
#                                    pliku i plików silnika względem
#                                    `impl/KAT/MANIFEST.txt`.
#   ./run_falcon_kat.sh --update   — odśwież `impl/KAT/` (tylko po świadomej
#                                    zmianie silnika lub wejść testowych).
#
# Flagi kompilacji są 1:1 z `Extra/c/Makefile` (profil FT1536 candidate).
# Wszystkie artefakty pośrednie lądują w `impl/.build/kat/`. Bez sieci.
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
IMPL_DIR=$(cd "$SCRIPT_DIR/../.." && pwd)
REPO_DIR=$(cd "$IMPL_DIR/../../../../.." && pwd)
ENGINE_DIR="$REPO_DIR/Extra/c"
KAT_DIR="$IMPL_DIR/KAT"
BUILD_DIR="$IMPL_DIR/.build/kat"
NAME="falcon_ternary_logn10_v1.txt"

ENGINE_FILES="falcon-keygen.c falcon-sign.c falcon-vrfy.c falcon-enc.c \
falcon-fft.c fpr-emulated.c frng.c shake.c shake.h falcon.h internal.h \
fpr-double.h ft1536-adaptive-cdf-tables.h"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

# Tryb trzeba zapamiętać PRZED `set --`, które nadpisuje pozycyjne parametry.
MODE=${1:-}

shake256_of() {
    python3 - "$1" <<'PY'
import hashlib, sys
print(hashlib.shake_256(open(sys.argv[1], "rb").read()).hexdigest(32))
PY
}

for f in $ENGINE_FILES; do
    [ -f "$ENGINE_DIR/$f" ] || fail "brak pliku silnika: $ENGINE_DIR/$f"
done

mkdir -p "$BUILD_DIR"
echo "== build generatora =="
# Kolejność argumentów bez `eval`: -DFPR_IMPL musi zawierać dosłowne
# cudzysłowy (single-quote), inaczej `#include FPR_IMPL` się psuje.
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
    -o "$BUILD_DIR/gen_falcon_kat" \
    "$SCRIPT_DIR/gen_falcon_kat.c"
for f in shake.c falcon-enc.c falcon-vrfy.c falcon-sign.c \
    falcon-keygen.c falcon-fft.c fpr-emulated.c frng.c; do
    set -- "$@" "$ENGINE_DIR/$f"
done
cc "$@"

echo "== generacja KAT =="
"$BUILD_DIR/gen_falcon_kat" "$BUILD_DIR/$NAME"

if [ "$MODE" = "--update" ]; then
    mkdir -p "$KAT_DIR"
    cp "$BUILD_DIR/$NAME" "$KAT_DIR/$NAME"
    {
        echo "# WP-024 — manifest KAT. Generowane przez ci/kat/run_falcon_kat.sh --update."
        echo "# Zmiana silnika lub wejsc testowych wymaga nowych pinow (nowy plik KAT)."
        echo "file = $NAME"
        echo "sha256 = $(sha256sum "$KAT_DIR/$NAME" | awk '{print $1}')"
        echo "shake256 = $(shake256_of "$KAT_DIR/$NAME")"
        for f in $ENGINE_FILES; do
            echo "engine.$f = $(sha256sum "$ENGINE_DIR/$f" | awk '{print $1}')"
        done
    } > "$KAT_DIR/MANIFEST.txt"
    echo "OK: zaktualizowano $KAT_DIR/$NAME i MANIFEST.txt"
    exit 0
fi

echo "== weryfikacja: bajty KAT =="
[ -f "$KAT_DIR/$NAME" ] || fail "brak $KAT_DIR/$NAME (uruchom z --update po swiadomej zmianie)"
if ! cmp -s "$BUILD_DIR/$NAME" "$KAT_DIR/$NAME"; then
    echo "regenerowany: $(sha256sum "$BUILD_DIR/$NAME" | awk '{print $1}')"
    echo "zakomitowany: $(sha256sum "$KAT_DIR/$NAME" | awk '{print $1}')"
    fail "KAT w repo nie jest bitowo identyczny z regeneracją silnika"
fi
echo "OK: $NAME bitowo identyczny ($(sha256sum "$KAT_DIR/$NAME" | awk '{print $1}'))"

echo "== weryfikacja: MANIFEST =="
[ -f "$KAT_DIR/MANIFEST.txt" ] || fail "brak $KAT_DIR/MANIFEST.txt"
file_sha=$(sha256sum "$KAT_DIR/$NAME" | awk '{print $1}')
pin_sha=$(awk -F' = ' '$1 == "sha256" {print $2}' "$KAT_DIR/MANIFEST.txt")
[ "$file_sha" = "$pin_sha" ] || fail "sha256 KAT niezgodny z MANIFEST"
file_k=$(shake256_of "$KAT_DIR/$NAME")
pin_k=$(awk -F' = ' '$1 == "shake256" {print $2}' "$KAT_DIR/MANIFEST.txt")
[ "$file_k" = "$pin_k" ] || fail "shake256 KAT niezgodny z MANIFEST"
for f in $ENGINE_FILES; do
    pin=$(awk -F' = ' -v k="engine.$f" '$1 == k {print $2}' "$KAT_DIR/MANIFEST.txt")
    [ -n "$pin" ] || fail "brak pinu engine.$f w MANIFEST"
    got=$(sha256sum "$ENGINE_DIR/$f" | awk '{print $1}')
    [ "$pin" = "$got" ] || fail "silnik zmieniony względem KAT: $f ($pin vs $got)"
done
echo "OK: manifest i 13 pinów silnika zgodne"
echo "PASS: KAT odtwarzalny z silnika"
