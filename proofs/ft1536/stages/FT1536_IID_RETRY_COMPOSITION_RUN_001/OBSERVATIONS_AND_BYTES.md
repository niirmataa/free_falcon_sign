# Exact source bytes i obserwacja zgodna z cut M0

Obserwacja source regionu: ZERO przy return0, BYTES(sig[0..len-1]) przy
positive return, NONRETURN przy braku return. Nie odczytuje się jako payload
bufferów po return0 ani niewypełnionego suffixu4096. M0 wrapper/framing
dodaje ustalone nonce40 poza cut; source request success nie jest filtrowany
późniejszym Verify. Nie zmieniono single K_seed[E]/p_K ani adversarial domain.

POST/SourceBytes daje dla ternary source norm:
Q=sum_i(s1_i²+s2_i²)+sum_i<768(s1_i*s1_(i+768)+s2_i*s2_(i+768)),
accept iff Q<2093922385. Products i wszystkie partial sums są defined
(magnitude<=4947802324992<2^63). To s=narrow16(w), zawsze, bez Safe16 premise.

Po acceptance literal `falcon_encode_small(sig+1,4095,STATIC,18433,s2,10)`
daje exact STATIC j8 body. POST/M0 CAPACITY_3160 daje body<=3159,
positive returned total<=3160<4096, więc brak capacity failure w Ready
domain. Source header=(1<<7)|(1<<5)|10=0xaa następuje wyłącznie po sukcesie.
Encoder nie zapisuje paddingu do4096. POST inverse odtwarza dokładnie stored
s2, nie desired mathematical integer vector z samych słów „signature”.

Po16 norm rejects sig nie został zapisany. Source extended fault return
także poprzedza norm/encode. Dla mniejszych legalnych capacities encoder
może zostawić partial body i zwrócić0 bez headera — taki path sprawdza
cap64 fixture, lecz nie zalicza go do Ready(cap4096) source failure mass.
Pełne buffer snapshots i canaries są kontrolami exact writes, nie dodatkowymi
publicznymi obserwacjami theorem. Original CLI2049 nie został poprawiony.
Synthetic accepted M0 witness ma3156-byte payload; jego mała norma nie
jest dowodem Emitted membership albo Sign→Verify.
