# Reuse z pinami i rozliczeniem premises

Wszystkie106 wejść bootstrap zweryfikowano wobec zewnętrznego MANIFEST
f1f5aee612f7f1651ec79a5e716a8f6d2963b5121566e80c7335ce0bf32dac73.
ORIGINS zachowuje104 publiczne git:<commit>:<path>, sizes/hashes. Pełne
lokalne input piny: INPUTS.sha256 / inputs/provenance.json (110 pozycji).

| Wynik | Pin / zakres | Sposób konsumpcji |
|---|---|---|
| ZERO report | d7e59a782a3b89bf7adfe1bc0894595a18e907a11019e557ecd55d588befaec8 | Odebrany local mixed proof, nie Reach |
| ZERO OUTPUTS | 599b33ccaefb5109cf1ce25c2cd4cc639abb4330ea05e89f3537cf86d57900ab | Proweniencja wybranej projekcji |
| ZERO ANALYTIC_PROOF | 579b8614c249dc2f1a6938d600f6b234e85ef6a441ef922bde5570e304d93918 | Phase argument add rozszerzony w NOWYM dokumencie do operand cap2^100; stare E2^-20 nie przeniesione |
| ZERO BitErrors | ec214fafcf80626ef657f69bd9aa8623153cd8c55cb7222b395cf2e57cf2aef8 | Universal sticky/round/normalize integer lemmas bez fixed add exponent premise |
| ZERO PackOf | 0797e5e9677187c183001efd4f8d417e54cede1d3771113fe5d2017d0a432e9a | OF_EXACT dla signed32 oraz source-normalized pack definition. Lematu pack z e≤1054 nie zastosowano powyżej jego domeny |
| H3 Reach | b44ea093f97c66a186abca0ac8c1d8a680bd3feec1f9121e165c5f623f1809e2 | Operacyjne Emitted/Reach i chronology, bez gotowego root boundu |
| H3 report | e808b0ecd9d39b575c075bf64056df93586d6fad60a0932866d673d0b45abb8c | Stary PARTIAL_PROOF pozostaje historyczny |
| M0 interface | 2e427f66d242cd4a95f777b9be8948ced315d3c683727d21e965c5fb3934e97c | Jeden K_seed[E], pełny successful KeyGen, caller4096/nonce40/16 attempts i cel parametryczny |
| Legacy twiddle audit | 0b19e2944a7c698a09a058f01ccdf94697985a3e88dbbaa56a3075fbddcfd3a8 | Map digests porównane, wszystkie użyte stałe ponownie sprawdzone RBF; nowy full linear-map certificate |
| Legacy NUMERICAL_SOUNDNESS | af280642cf497f8dfef18a1a651008a0256a95d4bb78039a5b3c6b2c7cb1ccdf | Complete-IEEE premise NIE konsumowane; nowe source-specific add/mul/div envelopes |
| H4/T5 leaves | pełne piny w bootstrap/MANIFEST | Kontekst; nie użyto leaf positivity jako internal-pivot certificate |
| review/VALIDATION | d919df88c7d74bf57175ac4dd8b2bbe9303ebffe9266f70defd25d861a90f87a | Niezależny odbiór ZERO, nie dowód nowego root theorem |

Jedenaście modułów dependency closure PackOf zachowano byte-identical,
wszystkie przebudowano: artifacts/inherited_order.json / reuse.json. Pierwsza
próba brakowała pośredniego importu ZeroRho; jej log zachowano, następnie
domknięto i przypięto rzeczywisty import graph. Nie kopiowano olean/cache.
lean.py/dyadic.py/fp_literal.py/replaylib.py są byte-identical helper copies
ZERO, uruchamiane tylko z nowego cwd. run.py ma jawny diff i własny sandbox.
Nowy certificate.py zawiera jawny diff względem legacy twiddle runnera;
inne source models/certificates są nowe, z odpowiednimi source spans.

Bootstrap jest projekcją, nie pełnym historycznym replay tree. Starych
OUTPUTS/VALIDATION nie interpretowano w nowej bazie ani nie uruchamiano
historycznych kontrolerów w bootstrapie. Odtworzenie potrzebuje wyłącznie
nowego pakietu i przypiętego toolchainu.
