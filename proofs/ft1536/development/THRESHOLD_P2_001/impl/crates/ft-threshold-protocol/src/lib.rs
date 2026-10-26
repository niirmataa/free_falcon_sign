//! Maszyny stanów i komunikaty protokołu progowego FT1536 (P2).
//!
//! Zakres docelowy: setup (B′: seed-share DKG + MPC `G(seed*)`), sign,
//! refresh, transkrypt, abort i rozliczanie winy. Ten crate **nie ma
//! sieci** — transport jest w `ft-threshold-transport`.
//!
//! WP-014: typestate setupu ([`state`]) — podpis tylko z walidowanego
//! DKG/NTRU. WP-020: uwierzytelnione koperty, licznik rund i replay-window
//! ([`envelope`]). WP-025: ścieżka `TEST-ORACLE` (jawny NTRU) jest
//! dostępna wyłącznie z cechą `test-oracle`; build PROD nie zawiera jej
//! symboli. Pełny protokół (ruchy, complainty, transkrypt) w G2/WP-030.

#![forbid(unsafe_code)]

pub mod cbor;
pub mod envelope;
pub mod state;
