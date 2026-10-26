//! Wspólne błędy rdzenia P2.
//!
//! Wszystkie prymitywy są **fail-closed**: zamiast cichego wyniku częściowego
//! zwracają jawny błąd. Wywołujący nie może kontynuować w niepewnym stanie.

use std::fmt;

/// Błąd rdzenia progowego FT1536.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
#[non_exhaustive]
pub enum CoreError {
    /// Próg `k` musi wynosić co najmniej 2.
    ThresholdTooLow,
    /// Podano mniej punktów niż wymaga próg.
    NotEnoughPoints,
    /// Lista punktów ewaluacji jest pusta.
    EmptyXs,
    /// Punkt ewaluacji `x = 0` jest zabroniony (pozycja sekretu).
    XZero,
    /// Ten sam punkt ewaluacji wystąpił więcej niż raz.
    DuplicateX,
    /// Liczba udziałów nie zgadza się z liczbą stron.
    PartyCountMismatch,
    /// Za mało udziałów do rekonstrukcji.
    InsufficientShares,
    /// Udział nie leży na wspólnym wielomianie (fałszerstwo/uszkodzenie).
    InconsistentShare,
    /// Niepoprawna długość danych wejściowych.
    InvalidLength,
    /// Wartość spoza dozwolonego zakresu.
    OutOfRange,
    /// Niepoprawne dane wejściowe (np. puste lub nierozróżnialne nonce).
    InvalidInput,
    /// Brak klucza dla wymaganej pary stron.
    MissingKey,
    /// Kontrola MAC z ukrytym δ nie przeszła (`MacFail`).
    MacFail,
    /// Korzeń transkryptu DKG nie zgadza się z oczekiwanym.
    TranscriptMismatch,
    /// Relacja NTRU `f·h = g` nie zachodzi.
    NtruMismatch,
    /// Profil `PROD` wymaga evidence NTRU z MPC, a otrzymał jawny klucz.
    ProdEvidenceMissing,
}

impl fmt::Display for CoreError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::ThresholdTooLow => write!(f, "threshold must be at least 2"),
            Self::NotEnoughPoints => write!(f, "not enough evaluation points"),
            Self::EmptyXs => write!(f, "empty evaluation point list"),
            Self::XZero => write!(f, "evaluation point x=0 is forbidden"),
            Self::DuplicateX => write!(f, "duplicate evaluation point"),
            Self::PartyCountMismatch => write!(f, "party count mismatch"),
            Self::InsufficientShares => write!(f, "insufficient shares"),
            Self::InconsistentShare => write!(f, "inconsistent share"),
            Self::InvalidLength => write!(f, "invalid input length"),
            Self::OutOfRange => write!(f, "value out of range"),
            Self::InvalidInput => write!(f, "invalid input"),
            Self::MissingKey => write!(f, "missing pairwise key"),
            Self::MacFail => write!(f, "MAC check failed (hidden delta)"),
            Self::TranscriptMismatch => write!(f, "DKG transcript root mismatch"),
            Self::NtruMismatch => write!(f, "NTRU relation f*h = g does not hold"),
            Self::ProdEvidenceMissing => {
                write!(
                    f,
                    "PROD requires MPC NTRU evidence, plaintext is TEST-ORACLE"
                )
            }
        }
    }
}

impl std::error::Error for CoreError {}

/// Wynik operacji rdzenia.
pub type Result<T> = std::result::Result<T, CoreError>;

#[cfg(test)]
mod tests {
    use super::CoreError;

    #[test]
    fn error_display_is_stable() {
        assert_eq!(
            CoreError::ThresholdTooLow.to_string(),
            "threshold must be at least 2"
        );
        assert_eq!(
            CoreError::InconsistentShare.to_string(),
            "inconsistent share"
        );
    }
}
