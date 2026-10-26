//! Testkit P2: harness złośliwych stron, oracle silnika, KAT.
//!
//! **Test-only** (D-009): dealer, stand-in `G(seed*)` i deterministyczny
//! sampler nie mogą istnieć w buildzie `PROD`. Ten crate nie jest
//! linkowany przez `ft-threshold-node` ani `ft-threshold-coordinator`.
//!
//! Na etapie WP-010 jest to szkielet; harness wchodzi w G2 (WP-032),
//! KAT w WP-024.

#![forbid(unsafe_code)]
