# Suplement017/001 — globalne Dimensions także ma pustą przesłankę

Status: **PROVED_OBSTRUCTION**, obowiązek Q-BIND/Q-KEY. Uzupełnienie
zamrożonego `ROM_INVOCATION_AUDIT_017.md`; jego bajtów nie zmieniono.

Ten sam pin `18a3ffe37cf21e53f2da5e58781775aef956d9b3`,
`Source3/KeygenMakeInvocation.lean` SHA256
`c644d0edd5eeb23dd7893bc88e83a0d9560b8ee899d54318c65baadc1ffbf2d2`.
Eksport `invocation_certificate` przyjmuje
`dimensions : (s : State) → KeygenMakeSearchPrefix.Dimensions s`.

`Dimensions s` zawiera równość
`s.locals "logn".toList = some (.uint32, some (.uint32 10))`.
Dla dowolnego podanego w twierdzeniu `caller` możemy utworzyć
`{caller with locals := fun _ => none}`. Globalna przesłanka wymaga wtedy
`none = some (...)`. Jest niemożliwa niezależnie od `VirtualLegal`.

Kernel: `formal/GlobalDimensionsObstruction017.lean`, eksporty
`empty_locals_not_dimensions` i `no_global_dimensions`, czysty build
`.build/local_leaves_017/runs/dimensions002`. Dokładny model źródłowy
zaimportowano z istniejącej, własnej kopii wejść011; nie przebudowano ani
nie uruchomiono żadnego modułu/jobu/replayu T12.1. Zweryfikowano486 par
źródło/artefakt całej wymaganej closure w
`.build/local_leaves_017/DIMENSIONS_INPUT_PINS_001.json`.

Piny definicji: `KeygenMakeSearchPrefix.lean`
`7553f2080a2890521c417e248295cd15ae1ddf0a5fbecb761ec89a7d41645a69`;
`C99ArrayReference.lean`
`b2066a87240a2d53c2439977f16c791e39e366ce146050cfd98e4a5eee3bebfc`.

Wniosek dotyczy globalnego binderu w `invocation_certificate`, nie wszystkich
lokalnych wyników o Dimensions. Poprawny lokalny warunek na osiągalny stan
bramki może mieć świadków; trzeba go wyprowadzić z tej samej inwokacji.
Analogicznego globalnego `workspace` nie uznano tutaj ani za sprzeczny,
ani za wypełniony — nie objęto go tym dowodem.

Pierwsza próba `dimensions001` nie przeszła importu: częściowy katalog
Run2 biblioteki017 zasłonił pełne przypięte wejście011. Osobna próba002
używa pełnego, istniejącego korzenia011 i własnego nowego pliku dowodowego.
Limity i źródła modelu pozostały bez zmian; próba001 zachowana.
