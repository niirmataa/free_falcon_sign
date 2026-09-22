# NEXT_INTERFACE — eksport one-root recovery (bez zmiany statusów T01/T05/T06)

Do T01 (retry composition), T05/T06: INTEGER_RECOVERY_CERTIFICATE.json +
SOURCE_ERROR.json + ROUNDING_RECOVERY.md. Status pakietu: PARTIAL_PROOF;
recovery lemma gotowy do konsumpcji warunkowej; B-gap jako jawny assumption
w dalszych kompozycjach (nie jako nowy gate bezpieczeństwa).
Parametry bez zmian: single K_seed[E]/p_K raz, nonce 40, STATIC 4096, source
gates; P_key/Emitted bez zmian. Nie ogłaszać Sign→Verify/whole-Sign/security
z tego one-root wyniku.
