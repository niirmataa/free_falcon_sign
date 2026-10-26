#!/bin/sh
# WP-027 — regeneracja i weryfikacja wektorów wire v1 (kanoniczny CBOR).
#
# Tryby:
#   ./run_wire_vectors.sh            — wygeneruj wektor od zera i porównaj
#                                      bajt po bajcie z `impl/wire/vectors/`.
#   ./run_wire_vectors.sh --update   — odśwież plik w repo po świadomej
#                                      zmianie formatu (nowa wersja wire!).
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
IMPL_DIR=$(cd "$SCRIPT_DIR/../.." && pwd)
VEC_DIR="$IMPL_DIR/wire/vectors"
BUILD_DIR="$IMPL_DIR/.build/wire"
NAME="envelope_v1.txt"

MODE=${1:-}
mkdir -p "$BUILD_DIR"
python3 "$SCRIPT_DIR/cbor_reference.py" "$BUILD_DIR/$NAME"

if [ "$MODE" = "--update" ]; then
    mkdir -p "$VEC_DIR"
    cp "$BUILD_DIR/$NAME" "$VEC_DIR/$NAME"
    echo "OK: zaktualizowano $VEC_DIR/$NAME"
    exit 0
fi

if [ ! -f "$VEC_DIR/$NAME" ]; then
    echo "FAIL: brak $VEC_DIR/$NAME (uruchom z --update)" >&2
    exit 1
fi

if cmp -s "$BUILD_DIR/$NAME" "$VEC_DIR/$NAME"; then
    echo "OK: wektor wire bitowo identyczny z regeneracją referencji"
    echo "PASS: wire v1 odtwarzalny"
else
    echo "regenerowany: $(sha256sum "$BUILD_DIR/$NAME" | awk '{print $1}')"
    echo "zakomitowany: $(sha256sum "$VEC_DIR/$NAME" | awk '{print $1}')"
    echo "FAIL: wektor w repo różni się od referencji" >&2
    exit 1
fi
