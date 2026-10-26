//! Maszyny stanów i komunikaty protokołu progowego FT1536 (P2).
//!
//! Zakres docelowy: setup (B′: seed-share DKG + MPC `G(seed*)`), sign,
//! refresh, transkrypt, abort i rozliczanie winy. Ten crate **nie ma
//! sieci** — transport jest w `ft-threshold-transport`.
//!
//! Na etapie WP-010 jest to szkielet; implementacja wchodzi w G2 (WP-030).

#![forbid(unsafe_code)]
