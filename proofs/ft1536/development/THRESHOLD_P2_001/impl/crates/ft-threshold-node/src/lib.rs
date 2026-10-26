//! Node P2: proces strony z udziałem, konfiguracja i sealed storage.
//!
//! Zasady: brak sekretów w logach, `mlock`/zeroizacja, token jako brama
//! KEK pieczęci (D-024). Node **nie** używa QSX/VM (D-023). Na etapie
//! WP-010 jest to szkielet; binarium i storage wchodzą w G2 (WP-030/045).

#![forbid(unsafe_code)]
