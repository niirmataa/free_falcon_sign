# Próby cap80 — zachowane, nie są wynikiem kernelowym

CapLoop020A.lean: ostatnia próba011, procesLean zakończony SIGABRT
z lean::memory_exception przy limicieM4096. Próby003–006,008–011
zachowują taki wynik;001/002/007 mają zwykłe błędy elaboracji.
CapDraw020A.lean: szkic następnego kroku, nie kompilowany z powodu
braku zaakceptowanego CapLoop. CapLoopProbe020A.lean: próba diagnostyczna
002 z błędami redukcji po local irreducible; wcześniejszy prefix-probe001
skompilował się, ale nie jest częścią audytu nowych wyników.

Wszystkie wersje źródeł, receipty i logi są w
.build/pair_machine_020/loops_001/runs. Nie nadpisano wcześniejszych prób.
Nie podniesiono limitu ponad historyczne020 M4096/AS8GiB.

Te pliki nie należą do zestawu finalnych czystych modułów. Status cap80:
OPEN_KERNEL. Następna trasa: ogólny lemat ograniczonej pętli w lekkim
module bez tablic; założenie o kroku wypełnić gotowym TrialCorrect020A,
następnie udowodnić cap80, zero fallback i zapis wyniku doRAM/normy.
Nie przenosić tego szkicu do finalnej tezy ani ogłaszać EveryTape.

CapDraw jest wcześniejszym szkicem: jego wywołanie loop_correct wymaga
uzgodnienia z późniejszymi parametrami i/hi CapLoop. Nie jest gotowym
konsumentem ani zaakceptowanym kontraktem. W próbie011 sourceTrial oznaczono
noncomputable wyłącznie jako alias specyfikacji; to nie naprawiło zasobów
kompilacji. Program020 nie został zmieniony.
