# T12.1 — aktywny wykonawca

- Model: GPT-6 Astra Fast (`openai/gpt-6-astra-fast`).
- Sesja: `ses_f33dcb1cbffe1cK536p26REYAg`; świeży kontekst zadania.
- Start: 2026-09-23, na bezpośrednie polecenie właściciela.
- HEAD obserwowany: `ba1c576ea680e4d8cf6bebbdc9e356bbf64f20c1`, main.
- BASE zadania pozostaje `c5faaeb6395c8238724494e8000eb6df55e65baf`.
- W zastano wyłącznie przygotowanie/bootstrap. Nie zastano procesu obliczeń
  ani handoffu innego wykonawcy tego W. P02 pracuje w odrębnym W.
- Status: WORKING. Jeden wykonawca; wszystkie nowe zapisy pod tym W.
- Najpierw matematyczne prawo odpowiedzi i kierunkowe prawa rozkładowe;
  następnie filtracja, ROM, ekstrakcja i bound. Finalny zakres wynika z
  faktycznie skompilowanych eksportów, nie z listy celów.

## Zmiana limitu przed kolejnym krokiem

`imports_001`: sam import Exp/Sqrt i podstawowych taktyk Mathlib (bez dowodu)
kończy się `lean::memory_exception` przy `-M2048`. Dla dalszych kroków
ustawiam `-M6144`, zachowując jeden wątek, limit przestrzeni adresowej 8 GiB
i wall 1800 s. To koszt załadowania przypiętych bibliotek; nie zmiana kernela
ani pominięcie kontroli. Próby i stderr zostają w run/.

`public_002` i dwie wcześniejsze próby: sporadyczne `failed to create thread`
przy RLIMIT_AS=8 GiB; zmierzony maksymalny RSS dziecka tylko 2455428 KiB.
Przed następnym krokiem podnoszę wyłącznie limit przestrzeni adresowej do
12 GiB dla mapowanych bibliotek/stosów. Lean heap limit pozostaje 6144 MiB,
jednowątkowo; normalny budżet pamięci fizycznej 8 GiB jest kontrolowany przez
receipt maxrss. To nie jest uruchomienie dodatkowego workera.
