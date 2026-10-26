//! Transport P2: TLS 1.3/mTLS (D-010), framing, sesje, replay-window.
//!
//! Brak QSX/VM i `network_cut` (D-023): nody rozmawiają normalnym,
//! uwierzytelnionym kanałem. Na etapie WP-010 jest to szkielet;
//! implementacja wchodzi w G2/G3 (WP-045).

#![forbid(unsafe_code)]
