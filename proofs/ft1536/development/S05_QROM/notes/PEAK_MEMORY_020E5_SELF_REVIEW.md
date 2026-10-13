# Kontrola autora — TODO020E5

PARTIAL_KERNEL / NOT_REVIEWED; nie jest to odbiór niezależny.

Sprawdzono wszystkie nowe020E5 oraz zależności potrzebne do oceny typów.

- Kierunek certyfikatu pozostaje J≪P i suma J²/P≤1+2^-47 pod dokładnie(M).
  ResidentCall.law_eq przenosi całe prawo, nie warunkowanie na sukces.
- Parser ma trwałe bad i licznik. Błąd nie wraca do stanu poprawnego;
  interpretacja zgodna z Option parse. IndexedParser czyta istniejący bank,
  a listy drop/ofFn w meaning są danymi dowodu.
- Bufor ma 32 tagowane sloty. round_target ma konieczną przesłankę długości;
  konkretne generatory dostarczają ≤19, ≤10 lub w+1≤32. Bez tej przesłanki
  obcięcie listy nie byłoby zgodnością. Wypełniane są także sloty none.
- Generic frame rules nie dowodzą, że context obejmuje całe wywołanie.
  ScratchConsumers.checked jawnie wyłącza producenta p.code i otoczenie.
  BoundaryPayload zawiera konkretne dane; jego suma nie została nazwana
  pełnym peak. Dwa pozostałe mosty są wskazane w checkpoint/księdze/kolejce.
- Generic bank-zero i startup dowodzą treści, nie tylko długości. Brak
  rekonstrukcji historii kwantowych zapytań. PublicData dotyczy tego samego h.
- Nowy model in-place jest jawny. Nie wywodzimy native allocation behavior
  z funkcjonalnego Array.set; stare naliczenia czasu020E4 nie są nowym czasem.
- Brak parametrów poziomu bezpieczeństwa, awansu do QROM, zmian T12.1/B20,
  KeyGen/Sign/PRG albo przesłanek (M). Kontrola nie jest owner acceptance.

Proofread-math: przegląd nowych komentarzy, checkpointu, klas i kolejki.
Rutynowe poprawki: doprecyzowanie granicy „zapisany bufor / producent”,
„wynik całego wywołania / cały ślad pamięci”, „reprezentowane dane / peak”.
Brak typograficznych zmian tokenów matematycznych w zaakceptowanych modułach.
Nierozwiązane implikacje są wprost oznaczone OPEN.
Walidacja: kernelowe buildy i #print axioms, dokładny Sage w standardowym trybie,
zgodność SHA źródeł, snapshotów, artefaktów i receiptów; git diff --check.
