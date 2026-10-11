# Zachowana próba generacji równań

MemoryProbe020.lean to celowo zachowana nieudana diagnostyka, poza buildem
zaakceptowanych modułów. Próby memprobe001/002 mają source snapshoty
i pełne logi w runtime020. Wywołanie atomRun.eq_1 uruchamiało generację
równań z błędem rekursji/dużych potęg. Nie wyciszono ostrzeżeń.
MemoryFrames020 używa własnych równań przejścia dowiedzionych rfl;
frames008 jest czysty. To naprawa sposobu dowodzenia, bez zmiany semantyki.
