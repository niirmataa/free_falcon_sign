//! Maszyny stanów i komunikaty protokołu progowego FT1536 (P2).
//!
//! Zakres docelowy: setup (B′: seed-share DKG + MPC `G(seed*)`), sign,
//! refresh, transkrypt, abort i rozliczanie winy. Ten crate **nie ma
//! sieci** — transport jest w `ft-threshold-transport`.
//!
//! WP-014: typestate setupu ([`state`]) — podpis tylko z walidowanego
//! DKG/NTRU. WP-020: uwierzytelnione koperty, licznik rund i replay-window
//! ([`envelope`]). Pełny protokół (ruchy, complainty, transkrypt) w G2/WP-030.

#![forbid(unsafe_code)]

pub mod envelope;
pub mod state;
