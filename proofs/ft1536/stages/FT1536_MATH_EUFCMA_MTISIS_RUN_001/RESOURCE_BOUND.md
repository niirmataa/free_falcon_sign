# Zasoby — jawny niezamknięty interfejs

Status: **OPEN_TYPED_MACHINE_BINDING**. Ten pakiet nie dowodzi kosztu
wykonania B. Lean `noncomputable` laws nie są darmowymi wyroczniami algorytmu.
`PublicSampler.run` jest parametryczną funkcją publiczną; nie ma fałszywego
pola C_pub, które samo z siebie miałoby być certyfikatem czasu.

Jednostki zgodne z przypiętym M0 RESOURCE_MODEL: t — bit steps, w — bits,
L — bytes wszystkich portów. M=Q_H+Q_s+1,
L_key≤L+40*(Q_s+1). Lista porównuje dokładne nazwy, nie hash nazw.

Docelowy bound (SPEC, nie eksport PROVED):

```
t_B ≤ t + Q_s*(C_pub+C_A+C_emit)
        + C_verify(L)+C_extract(L)+C_table(M,L_key)+C_challenge_IO(Q_H+1)
w_B ≤ w + W_table(M,L_key)+W_pub+W_A+W_extract+W_challenge
L_B ≤ L+40*(Q_s+1)+3072*(Q_H+1)+8*1536+index_bytes(Q_H+1)+sampler_port_bytes
```

Wariant wybiera streaming challenge interface dla samej operacyjnej tabeli:
hash czyta target[used], nie przyszłe wartości. Zamiana na wejściową listę
wszystkich T celów musi policzyć challenge storage/read; nie można liczyć
jednocześnie zalet obu implementacji. Kod hash jest funkcyjny w liście targets,
nie określa urządzenia I/O. Własna praca przeciwnika także nie ma tu maszyny.

Instancjacja wymaga kosztu generowania uniform coins samplera/nonce, dokładnego
mnożenia modulo wielomianu, centrowania, odczytu/emitowania współczynników oraz
przeliczenia na rzeczywiste bajty. Przeciwnik nie uzyskuje bezpłatnych długich
wiadomości ani nieograniczonej długości payloadu. Nie wybrano dodatniego małego
epsilon_pub; ewentualny błąd/budżet musi mieć jednego właściciela.

Koszty proof/replay są osobne od kosztów kryptograficznych i znajdują się
w EXECUTION_RECEIPTS. Zmiany limitów wykonania wyjaśnia FAILED_ROUTES.md.
