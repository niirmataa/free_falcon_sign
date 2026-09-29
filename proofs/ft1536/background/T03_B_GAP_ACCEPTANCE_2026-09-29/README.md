# T03-B RUN_002 — scoped odbiór, import i binding koordynatora

2026-09-29. Projekt Niirmata; atrybucja Falcon Project / Thomas Pornin zachowana.
Koordynator:sesja ses_f137502d0ffe6BYk3HEHU1xxZL. Ten zapis dokumentuje
przyjęcie niezależnej recenzji i archiwizację,nie nowy proof/replay.

## Piny przekazane przez właściciela

| Pakiet | Raport SHA-256 | Manifest SHA-256 |
|---|---|---|
| FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002 | b2e8c9af003edee089b49156541e631e3ab8bb01c93f9cad521edf7b66a59dfc | 12df61056ddada2f79c1b94b3b17e8f326db2b3a2cbe53d1694754d79d7958cc |
| FT1536_REFERENCE_INTEGER_RECOVERY_RUN_002_REVIEW_001 | acad9276fa7e8ed6924b8a1ada1bbf84052be330d3a0e1641a2850f2e6b5d84e | a4118200de729562ad1e6396c0bb252a204d9a1ee0f7d7ce085db1fb11689956 |

Autor:Astra Fast,sesja ses_f13640949ffeJ0RtC7tFAz07UR.
Recenzent:Sol Fast (`openai/gpt-6-sol-fast`,Fast),świeży kontekst,
sesja ses_f13139bc5ffeFI41laN8mgF1PA. Werdykt PASS_SCOPED_REVIEW przyjęty
wyłącznie dla autorskiego BLOCKED_UPSTREAM_EXPORTS;owner_accepted=false.

## Zakres odebrany

15 lokalnych identities algebra-only,10-termowy signed ledger,diagnoza
add_C1643 względem old target i warunkowe dokładne rachunki. Fizyczny
inverse I pozostaje obowiązkiem:A1–D są root-space,E coefficient-space;
root-space lemma stosuje się z e=0,następnie dodaje E. B=(t−Z)DeltaB,
A4+B=−Z DeltaB;stara nazwa B nie daje prawa przeniesienia starej majoranty.
source_gap=null,full_recovery=false. Dwa publiczne fixtures±2^-25 nie mają
required-domain membership. Nie ma nowego security claimu.

Otwarte:P02_ARITH,P02_REACHED_DOMAIN,P06_REFERENCE,INTEGER_DEFECT_TRANSPORT,
P07_BASIS,A2_INVERSE_AND_IFFT,P02_REAL_RINT. Dokładny consumer jest w
REVIEW_RESULT.json i NEXT_INTERFACE.md stage'a recenzji.

## Kontrole i wykonane operacje

- `check_review.py`:archive.verify_bundle obu pakietów,powiązanie dokładnych
  subject pins/IDs/scope i niezależności modelu;1939 outputs autora/1437 inputs,
  115 outputs recenzji/1946 inputs. Review output exact set zgodny.
- Sprawdzono recorded source/log/product bindings fresh_001(exit1),
  fresh_002(7/7 exit0),UBSan/ASan(3/3 każde);28 raw step logs i18 C-command
  log bindings.10 semantic wyników zgodnych z author baseline i receiptami.
  Suma czasów7 kroków świeżego replayu recenzenta≈452.33s.
- Własne końcowe checkery recenzenta:źródła/logi/.exit/result są sealed;
  5 sidecar exits0 i puste stderr. Koordynator ich nie uruchamiał i nie
  dorabiał nieistniejących source-before/after execution receipts.
- Ograniczenie jawne:3 wczesne stderr własnego Sage recenzenta nadpisane;
  opis w REVIEWER_FAILED_ATTEMPTS.md,finalne źródła/logi/wyniki zachowane.
  Nie oznaczamy całej historii prób jako kompletnej.
- Review INPUTS jest względne do REVIEW_W/inputs. `prepare_import.py`
  i `archive.py bootstrap` utworzyły nowy import-source:116 byte-identical
  output files z manifestem +1946 przypiętych origin copies. Nie zmieniono
  frozen W ani jego manifestu. REVIEW_IMPORT_LAYOUT opisuje transport.
- `archive.py import` autora oraz review (jawne --manifest/--report/--result,
  --id i external piny):oba integrity PASS. Catalog replay=none,bo autor
  ma custom CLI/mount protocol;własny replay recenzenta jest w sealed evidence.
- `archive.py verify`:44 checkpointy i57 dokumentów PASS,exit0,stderr pusty.
  `archive.py list --markdown`:stan po obu importach w ARCHIVE_LIST.md.

Następny krok:lokalny checkpoint pary i aktualizacja żywych wskaźników;
dalej nowe source-refined eksporty P02/P06 oraz INTEGER_DEFECT_TRANSPORT.
Brak automatycznego push,nowych wykonawców lub awansu B20.
