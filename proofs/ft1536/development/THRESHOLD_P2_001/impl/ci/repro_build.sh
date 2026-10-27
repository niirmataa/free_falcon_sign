#!/bin/sh
# WP-026 — hermetyczny podwójny build + porównanie hashy artefaktów + SBOM.
#
# Kryterium odbioru G1: „dwa buildy = ten sam hash". Buildujemy release
# dwa razy do osobnych katalogów target (--frozen = --locked + --offline,
# każda zmiana Cargo.lock to porażka), porównujemy listę i SHA256
# wszystkich .rlib (top-level i deps). Pliki .d/.fingerprint/incremental
# są NIE-porównywalne z założenia (zawierają ścieżki katalogu target).
#
#   ./repro_build.sh            — weryfikacja (podwójny build + SBOM vs pin)
#   ./repro_build.sh --update  — odśwież przypięty SBOM po świadomej
#                                zmianie zależności (Cargo.lock).
set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
IMPL_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
BUILD="$IMPL_DIR/.build/repro"
SBOM_DIR="$IMPL_DIR/sbom"
SBOM_NAME="sbom_v1.txt"

export CARGO_NET_OFFLINE=true

MODE=${1:-}

echo "== toolchain =="
rustc --version
cargo --version

echo "== podwójny build (--frozen, offline, osobne target dirs) =="
rm -rf "$BUILD/a" "$BUILD/b"
CARGO_TARGET_DIR="$BUILD/a" cargo build --release --workspace --frozen
CARGO_TARGET_DIR="$BUILD/b" cargo build --release --workspace --frozen

echo "== porównanie artefaktów =="
(
    cd "$BUILD/a/release"
    sha256sum *.rlib 2>/dev/null | sed 's|  |  @|' | sort
    cd deps
    sha256sum *.rlib 2>/dev/null | sed 's|  |  deps/|' | sort
) > "$BUILD/ha.txt"
(
    cd "$BUILD/b/release"
    sha256sum *.rlib 2>/dev/null | sed 's|  |  @|' | sort
    cd deps
    sha256sum *.rlib 2>/dev/null | sed 's|  |  deps/|' | sort
) > "$BUILD/hb.txt"

artifacts=$(wc -l < "$BUILD/ha.txt")
if [ "$artifacts" -lt 14 ]; then
    echo "FAIL: mniej niż 14 artefaktów rlib do porównania ($artifacts)" >&2
    exit 1
fi
if ! cmp -s "$BUILD/ha.txt" "$BUILD/hb.txt"; then
    echo "FAIL: rozjazd hashy artefaktów między buildami:" >&2
    diff "$BUILD/ha.txt" "$BUILD/hb.txt" >&2 || true
    exit 1
fi
echo "OK: $artifacts artefaktów rlib bitowo identycznych"
echo "manifest_artefaktow_sha256 = $(sha256sum "$BUILD/ha.txt" | awk '{print $1}')"

echo "== SBOM (wprost z Cargo.lock, bez resolve/sieci) =="
# Pełne `cargo metadata --frozen` chce pobierać manifesty nieużywanych
# wpisów locka (np. opcjonalny backend fiat-crypto) i pada offline;
# SBOM wyprowadzamy więc wprost z Cargo.lock — to on jest inwentarzem.
python3 "$SCRIPT_DIR/sbom_from_lock.py" \
    "$IMPL_DIR/Cargo.lock" "$IMPL_DIR/Cargo.toml" > "$BUILD/$SBOM_NAME"
packages=$(grep -c ' | ' "$BUILD/$SBOM_NAME" || true)
echo "OK: SBOM: $packages pakietów (z Cargo.lock)"

if [ "$MODE" = "--update" ]; then
    mkdir -p "$SBOM_DIR"
    cp "$BUILD/$SBOM_NAME" "$SBOM_DIR/$SBOM_NAME"
    echo "OK: zaktualizowano $SBOM_DIR/$SBOM_NAME"
    exit 0
fi

if [ ! -f "$SBOM_DIR/$SBOM_NAME" ]; then
    echo "FAIL: brak $SBOM_DIR/$SBOM_NAME (uruchom z --update po zmianie Cargo.lock)" >&2
    exit 1
fi
if ! cmp -s "$BUILD/$SBOM_NAME" "$SBOM_DIR/$SBOM_NAME"; then
    echo "FAIL: SBOM niezgodny z przypiętym — zmiana zależności bez --update" >&2
    diff "$SBOM_DIR/$SBOM_NAME" "$BUILD/$SBOM_NAME" | head -20 >&2 || true
    exit 1
fi
echo "OK: SBOM zgodny z pinem ($SBOM_NAME, sha256 $(sha256sum "$SBOM_DIR/$SBOM_NAME" | awk '{print $1}'))"
echo "PASS: build odtwarzalny (dwa buildy = ten sam hash) + SBOM zweryfikowany"
