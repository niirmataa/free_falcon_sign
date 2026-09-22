# CHECKLIST — niezależny odbiór R1–R7

| Punkt | Ocena | Własne evidence / granica |
|---|---|---|
| R1 | CHANGES_REQUIRED, medium | L_V extraction direction poprawny; ATTACK_PROBLEMS oracles/Adv label niejednoznaczne; math-002 N3:accepted=true,fresh=false,różne outputs/index |
| R2 | RESOLVED_WITH_LOW_NOTES | math-002:free target1,ROM toy1/7,repeat union1/2 versus3/4; doprecyzować marginal/conditioning wording |
| R3 | RESOLVED_SCOPED | source falcon-vrfy.c:1551–1588; F wejściem,NTRU solve oddzielny,raw/emitted rozdzielone |
| R4 | RESOLVED_BY_WITHDRAWAL | author T1–T8 replay; reviewer13 mock cases+2 freshness probes; brak prawdziwego estymatora; guards nie dowodzą premises |
| R5 | NUMERIC_CORE_CONFIRMED, PRECISION_CLAIM_CHANGES_REQUIRED | QQ+MPFI1024,Arb256 exact conversion slack; >2^-40,<2^-28; author radius≈1.06e-82 versus claimed≈1e-305 |
| R6 | RESOLVED_SCOPED | lektura paper/CLAIMS/notes,PROPOSED i twiddle placeholder;12 FFT controls odtworzone,bez uniform theorem |
| R7 | RESOLVED_SCOPED | source recurrences,Lean4/14,independent closed forms16384,Newton sums/A2 geometry; kernel≠C allocator |

Publikacyjna bramka korekt S01: **NIESPEŁNIONA** do poprawy I1/I2.
Pozostałe otwarte obowiązki projektu nie były sztucznie użyte jako powód
odrzucenia zakresowej korekty. Failed attempts i transport metadata jawne.
