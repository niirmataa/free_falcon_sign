#!/bin/sh
# Hermetyczna kontrola workspace P2 (WP-010/011). Bez sieci, bez QSX/VM.
# `cargo deny --offline` korzysta z lokalnego cache advisory DB; jego
# świeżość odświeża się osobno (`cargo deny fetch`, wymaga sieci i zgody).
# `miri` wymaga nocnego toolchainu: rustup toolchain install nightly --component miri.
set -eu

cd "$(dirname "$0")/.."
export CARGO_NET_OFFLINE=true

echo "== toolchain =="
rustc --version
cargo --version

echo "== fmt =="
cargo fmt --all -- --check

echo "== build (locked, offline) =="
cargo build --workspace --locked --offline

echo "== test (locked, offline) =="
cargo test --workspace --locked --offline

echo "== test all-features (test-oracle, locked, offline) =="
cargo test --workspace --all-features --locked --offline

echo "== clippy (-D warnings) =="
cargo clippy --workspace --all-targets --locked --offline -- -D warnings

echo "== clippy all-features (-D warnings) =="
cargo clippy --workspace --all-targets --all-features --locked --offline -- -D warnings

echo "== prod build bez symboli TEST-ORACLE (WP-025) =="
./ci/check_prod_symbols.sh

echo "== korpus fuzz (WP-022) =="
./ci/fuzz/run_fuzz_corpus.sh

echo "== cargo deny (offline, cached advisory DB) =="
if ! command -v cargo-deny >/dev/null 2>&1; then
    echo "FAIL: brak cargo-deny (cargo install --locked cargo-deny)" >&2
    exit 1
fi
cargo deny --offline check

echo "== miri (nightly, offline) =="
if ! cargo +nightly miri --version >/dev/null 2>&1; then
    echo "FAIL: brak miri (rustup toolchain install nightly --component miri)" >&2
    exit 1
fi
cargo +nightly miri test --workspace --locked --offline

echo "== zakaz QSX/VM w zaleznosciach (D-023) =="
if awk '!/^[[:space:]]*#/' Cargo.toml Cargo.lock crates/*/Cargo.toml \
    | grep -qiE 'ftkey[-_]vm|qsx|libvirt|/dev/kvm'; then
    echo "FAIL: P2 nie moze zalezec od QSX/VM (D-023)" >&2
    exit 1
fi

echo "OK: workspace P2 build/test/clippy offline"
