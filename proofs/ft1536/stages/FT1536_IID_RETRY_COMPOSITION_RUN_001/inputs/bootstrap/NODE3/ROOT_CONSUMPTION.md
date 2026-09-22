# Dokładny reuse ROOT — bez ponawiania całego KeyGen/FFT/NTT etapu

P_key i Emitted_C zachowują tezy poprzednika. W tym zadaniu nie dodano
normality/small-L/pivot/center assumptions. ROOT został niezależnie odebrany
jako H3_ROOT_LDL_PROVED_FOR_PINNED_MODEL, checkpoint3d6bf58.

| Input | SHA-256 | Konsumpcja |
|---|---|---|
| ROOT/ROOT_CERTIFICATE.json | fd2130d53bdd7f580924110018dc04ed429733b4ce66e6bde6e2d75381c77f76 | S.g00 i S.d11, profile i P_key |
| ROOT/ANALYTIC_PROOF.md | e2caa8b9d7996a241bee2e6bb8a478eadf031279860cdaf586daa3473ed69ef7 | Cap2^100 add/mul envelopes, Gram/determinant correlations; div rozszerzony osobno |
| ROOT/EMITTED_BINDING.md | 7dd3be1172eb31f6b497a709d9299492e1731e139e515446c25c271e563a57a5 | Emitted same-key STATIC decode→P_key, w zakresie source-analytic proof |
| ROOT/ROOT_FRAME.md | 921d254b6da9d91978e8e44cbfbf11e721b89e12208a91979cfa169157a4d681 | Defined prefix/root chronology i immutable root Gram |
| ROOT/artifacts/numeric_certificate.json | 5190ddf21d676ebf1045a35c29b9600b26ee461aa86b58e0d2012d6db8564c10 | Dokładne delta,amax,jmax i E, physical parent root map |
| ROOT/NEXT_INTERFACE.md | 1e17e35ecbb91c410ec66f95d773c62933c1e8234283494228aac46223584952 | Dokładny zamykany w NODE3 kwantyfikowany cel |

Dla wszystkich p∈P_key ROOT daje: g00 real≥1/2 i<2^23, imag+0, error do A
<1/1024. Dla D_C istnieje real comparison r=|det(Bhat)|²/a, gdzie
|D_C−r|≤256*2^-48*j≤E, a r∈[mhat,Mhat]. Są to powiązane dane obliczonej
FFT macierzy, z exact NTRU determinantem kontrolowanym przez delta.
Nowy certificate.py ponownie sprawdza algebraiczną definicję E/mhat/Mhat
i inequalities użyte w NODE3. Nie wyprowadza positivity z samego error2^22.

Full source-domain contracts ROOT:
- add/sub: finite inputs |value|≤2^100, error≤U(|x|+|y|)+eta;
- mul: ta sama input domain, error≤U|xy|+eta;
- div: stary denominator[1/2,2^23] NIE wystarcza dla NODE3;
- wszystkie outputs normal/zero; nie jest to complete IEEE underflow theorem.
Nowy ANALYTIC_PROOF§2 dowodzi denominator[1/16,2^35], z normal/exp0/clamp
i finite pack. OF_EXACT jest konsumowane wyłącznie dla integer1 i3 oraz
publicznych integer controls w swojej signed32 domenie.

Piętnaście importowanych ROOT modułów, włącznie z dependency closure ZERO,
jest byte-identical i przebudowane z Lean źródeł. Ich pełne wcześniejsze
zakresy pozostają historyczne; nie kernelizuje to całego analitycznego ROOT.
Backend/root_model/table parser i kontrolery lean/dyadic/replaylib/toolchain
są jawnie skopiowanymi helperami z artifacts/reuse.json, w NOWYM cwd W.
Nie przeniesiono olean/bin/cache. Nie uruchamiano controllerów w bootstrapie.

Konsumujemy przejrzany ROOT theorem, nie ponawiamy eksperymentów KeyGen,
całego FFT/NTT dowodu lub source membership. Nowe twiddle/cubic/child map
oraz inverse3 są niezależnie sprawdzone w aktualnym zadaniu. Legacy T5 exact
3x3 identities są ponownie wyprowadzone; legacy correctly-rounded IEEE
premise nie jest użyte jako nowy domain bridge. H4 widths nie certyfikują
całych internal words. ZERO E2^-20 zachowuje własną domenę.

M0 caller4096/nonce40,16 attempts, jeden K_seed[E], N1536/q18433/Phi/sigma768/
B2093922385 i parametryczny cel są bez zmian. Branch0 konsumuje wyłącznie
wcześniejsze FFT/Gram/Gate g00 facts — nie wykonanie przyszłego root dim2.
Branch1 w rzeczywistym loaderze występuje tylko po stosownym defined prefix;
matematyczny Node3Slice obu branches jest określony niezależnie od ukończenia
niższych nodes. Sampler-law i global Reach pozostają oddzielne.
