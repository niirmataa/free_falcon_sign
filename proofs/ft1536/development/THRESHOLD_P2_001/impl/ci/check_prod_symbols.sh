#!/bin/sh
# WP-025 — build PROD bez ścieżek zakazanych (TEST-ORACLE, xof, iso, dealer).
#
# Dwie niezależne kontrole:
#   1) źródła: brak modułów/wentry pointów zakazanych w crate'ach produkcyjnych.
#   2) symbole: release'owy rlib `ft-threshold-protocol` bez cechy
#      `test-oracle` NIE zawiera `verify_plaintext`/`validate_ntru`;
#      build z cechą MUSI je zawierać (kontrola negatywna — dowód, że
#      skaner nie przechodzi wakacyjnie).
#
# Bez sieci, bez QSX/VM. Wymaga `nm` (binutils) i cargo offline.
set -eu

cd "$(dirname "$0")/.."
export CARGO_NET_OFFLINE=true

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

if ! command -v nm >/dev/null 2>&1; then
    fail "brak nm (binutils); skan symboli jest wymagany"
fi

echo "== 1. zakazane moduly/wentry pointy w zrodlach prod =="
forbidden_files=$(find crates -path '*/src/*' -type f \( -name 'xof.rs' -o -name 'iso.rs' \) -print)
if [ -n "$forbidden_files" ]; then
    fail "zakazane pliki w src: $forbidden_files"
fi
forbidden_code=$(grep -RInE \
    '^[[:space:]]*(pub[[:space:]]+)?(mod[[:space:]]+(xof|iso)[[:space:]]*;|fn[[:space:]]+(sign_ceremony|trusted_dealer|dealer_keygen|deal_full_key|delta_known))' \
    crates/*/src 2>/dev/null || true)
if [ -n "$forbidden_code" ]; then
    fail "zakazany kod w zrodlach prod:
$forbidden_code"
fi
for linker in crates/ft-threshold-node/Cargo.toml crates/ft-threshold-coordinator/Cargo.toml; do
    if grep -q 'ft-threshold-testkit' "$linker"; then
        fail "$linker linkuje testkit (D-009: testkit nie moze byc w PROD)"
    fi
done
echo "OK: brak zakazanych modulow i entry pointow"

echo "== 2. symbole release: PROD bez oracle =="
cargo build -p ft-threshold-protocol --release --locked --offline
rlib="target/release/libft_threshold_protocol.rlib"
[ -f "$rlib" ] || fail "brak $rlib po buildzie"

prod_hits=$(nm -C "$rlib" 2>/dev/null | grep -E \
    'state::(NtruEvidence::verify_plaintext|PartyState<.*>::validate_ntru)|PlaintextTestkit' || true)
if [ -n "$prod_hits" ]; then
    fail "build PROD zawiera symbol TEST-ORACLE:
$prod_hits"
fi
echo "OK: 0 symboli oracle w buildzie domyslnym"

echo "== 3. kontrola negatywna: cecha test-oracle przywraca symbole =="
cargo build -p ft-threshold-protocol --release --locked --offline --features test-oracle
feature_hits=$(nm -C "$rlib" 2>/dev/null | grep -E \
    'state::(NtruEvidence::verify_plaintext|PartyState<.*>::validate_ntru)' || true)
echo "$feature_hits" | grep -q 'verify_plaintext' || fail "kontrola negatywna: brak verify_plaintext"
echo "$feature_hits" | grep -q 'validate_ntru' || fail "kontrola negatywna: brak validate_ntru"
echo "OK: cecha test-oracle daje oczekiwane symbole"

echo "== 4. przywrocenie artefaktu PROD =="
cargo build -p ft-threshold-protocol --release --locked --offline
prod_hits=$(nm -C "$rlib" 2>/dev/null | grep -E \
    'state::(NtruEvidence::verify_plaintext|PartyState<.*>::validate_ntru)|PlaintextTestkit' || true)
if [ -n "$prod_hits" ]; then
    fail "po przywroceniu PROD zostaly symbole oracle:
$prod_hits"
fi
echo "OK: artefakt PROD czysty"
