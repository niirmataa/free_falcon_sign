# Zakres następnego etapu — uwaga prowadzącego

Odbiór RAW_ASSEMBLY dotyczy wyłącznie cut po falcon-sign.c:1253. Silniejszy
typ w zamrożonym NEXT_INTERFACE jest nowym obowiązkiem, nie już dowiedzionym
wnioskiem o akceptacji stable rebuild.

Niezmienione P_key obejmuje coefficient caps, exact NTRU i Gate00_C, ale
nie zawiera akceptacji końcowego stable-leaf range scan. Tymczasem źródło
sprawdza encoded interval [0x4090000053700377,0x4114444d1a037d50]. Same raw
positive/finite facts i dotychczasowe szerokie bounds nie dowodzą tego scan.
Nie stwierdzamy tu, że all-P_key claim jest fałszywy; nie został rozstrzygnięty.

Następne zlecenie powinno jawnie rozdzielić:
1. P_key/RawPrefix → defined actual stable computation/normalization i source
   sequence/frame, z precyzyjnym wynikiem finalnego gate;
2. source-derived obowiązkowy stable certificate udanego Emitted KeyGen →
   stable_ok przy tych samych decoded vectors, bez dodatkowego conditioning;
3. ewentualną silniejszą tezę all-P_key → stable_ok, tylko jeśli ma własny dowód.

Nowy bridge musi sprawdzić rzeczywiste body i momenty pamięci. KeyGen liczy
g00 jako selfadj(g)+selfadj(-f), a signer stable helper przelicza
selfadj(f)+selfadj(g). Potrzebna jest BITOWA niezmienność selfadj pod negacją
oraz commutativity add w osiągniętej nieujemnej domenie, także dla raw zer;
sama idealna równość matematyczna nie wystarcza. Następnie potrzebne jest
matching całej stable sequence, sticky bad i obu leaf range scans.

Normalize wykonuje się bez if(stable_ok). W każdej deklarowanej domenie
definedness musi poprzedzać sqrt/div i odczyt stable_leaves. Sqrt, rozszerzone
stable-rebuild divisor bounds oraz faktyczne stored widths wymagają osobnych
source-bound contracts. Nowe narrow gate facts nie mogą zostać ukryte pod
starą nazwą P_key. Nie zmieniamy zamrożonego raportu ani źródeł C.
