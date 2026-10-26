//! Weryfikator P2: wąski wrapper `ft1536-sys` + niezależne kontrole.
//!
//! `ft1536-sys` jest TCB (D-008) i **nie** jest tu jeszcze podłączony:
//! vendor + pin + KAT wchodzą w WP-048, bez absolutnej ścieżki.
//! Na etapie WP-010 jest to szkielet.

#![forbid(unsafe_code)]
