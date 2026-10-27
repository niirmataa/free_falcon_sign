#!/bin/sh
# WP-022 — regeneracja i weryfikacja korpusu fuzz wire v1.
#
#   ./run_fuzz_corpus.sh            — weryfikacja (cmp każdego pliku + liczba)
#   ./run_fuzz_corpus.sh --update  — odśwież korpus po świadomej zmianie
#                                     (formatu wire albo generatora).
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
IMPL_DIR=$(cd "$SCRIPT_DIR/../.." && pwd)
CORPUS_DIR="$IMPL_DIR/fuzz/corpus/wire"
BUILD_DIR="$IMPL_DIR/.build/fuzz/corpus/wire"
EXPECT_FILES=44

MODE=${1:-}
mkdir -p "$BUILD_DIR"
python3 "$SCRIPT_DIR/gen_corpus.py" "$BUILD_DIR"

count=$(find "$BUILD_DIR" -name '*.bin' | wc -l)
if [ "$count" -ne "$EXPECT_FILES" ]; then
    echo "FAIL: generator wytworzył $count plików, oczekiwano $EXPECT_FILES" >&2
    exit 1
fi

if [ "$MODE" = "--update" ]; then
    mkdir -p "$CORPUS_DIR"
    for f in "$BUILD_DIR"/*.bin; do
        cp "$f" "$CORPUS_DIR/"
    done
    echo "OK: zaktualizowano korpus ($EXPECT_FILES plików)"
    exit 0
fi

if [ ! -d "$CORPUS_DIR" ]; then
    echo "FAIL: brak katalogu $CORPUS_DIR (uruchom z --update)" >&2
    exit 1
fi
repo_count=$(find "$CORPUS_DIR" -name '*.bin' | wc -l)
if [ "$repo_count" -ne "$EXPECT_FILES" ]; then
    echo "FAIL: korpus w repo ma $repo_count plików, oczekiwano $EXPECT_FILES" >&2
    exit 1
fi

status=0
for f in "$BUILD_DIR"/*.bin; do
    name=$(basename "$f")
    if ! cmp -s "$f" "$CORPUS_DIR/$name"; then
        echo "FAIL: $name różni się od regeneracji" >&2
        status=1
    fi
done
if [ "$status" -ne 0 ]; then
    exit 1
fi
echo "OK: korpus bitowo identyczny z regeneracją ($EXPECT_FILES plików)"
echo "PASS: fuzz corpus odtwarzalny"
