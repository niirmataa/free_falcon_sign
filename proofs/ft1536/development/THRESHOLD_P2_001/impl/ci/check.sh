#!/bin/sh
# Hermetyczna kontrola workspace P2 (WP-010/011). Bez sieci, bez QSX/VM.
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

echo "== clippy (-D warnings) =="
cargo clippy --workspace --all-targets --locked --offline -- -D warnings

echo "== zakaz QSX/VM w zaleznosciach (D-023) =="
if awk '!/^[[:space:]]*#/' Cargo.toml Cargo.lock crates/*/Cargo.toml \
    | grep -qiE 'ftkey[-_]vm|qsx|libvirt|/dev/kvm'; then
    echo "FAIL: P2 nie moze zalezec od QSX/VM (D-023)" >&2
    exit 1
fi

echo "OK: workspace P2 build/test/clippy offline"
