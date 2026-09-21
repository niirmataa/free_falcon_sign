# IID_BUFFER i właściwa filtracja

## Gra i przesłanki probabilistyczne

Pracujemy w standardowej countable product probability space nad bytes
{0,...,255}: blocks B_0,B_1,..., każdy4096 bytes, niezależny uniform. Nowe
blocks są niezależne od entry PAST, w tym wybranych z tej przeszłości mu/sigma,
klucza i canonical target. Jest to DEFINICJA idealnej gry, nie wniosek o
konkretnym seeded PRNG. Existence/product measure i usual conditional
probability/countable additivity są jawną matematyczną podstawą analityczną.

State to block index, ptr, type=PRNG_CHACHA20, legal buffers/context/fault oraz
deterministyczne scalar locals. Refill w grze zastępuje generator zawartości
przez kolejny B_i i ustawia ptr0. Opaque PRNG seed/state nie jest ujawnianym
oracle outputem; w tej grze nie wyznacza nowych blocks. Original getter reads,
pointer updates, discards i scalar operations pozostają niezmienione.
Typed context określa pamięć/type/ptr, nie ustala arbitralnie całego buffer value
jednocześnie nazywanego losowym IID. Przy entry ptr=p prefix[0,p) jest przeszły;
tail[p,4096) ma conditional product law wyprowadzone niżej.

## Filtracja i coupling

F_t zawiera ujawnione getter bytes, ich pozycje, get/refill/drop counts,
computed decisions/returns i deterministyczny stan wyliczony z przeszłości.
Można ujawniać wszystkie8bits get_u8 i64bits get_u64, także potem zamaskowane:
to silniejsza filtracja niż same scalar outcomes. F_t NIE zawiera unread bytes,
future blocks ani pełnego realnego PRNG private state. mu/sigma adaptacyjne są
F_t-measurable; nie mogą zależeć od przyszłego tape.

Numeruj byte cells (block,offset). Getter wybiera swój następny read interval
wyłącznie z dotychczasowego ptr/operation tag. BYTE_SCHEDULE dowodzi, że nigdy
nie czyta pozycji ponownie, w blokach czyta rosnąco, a refill trwale opuszcza
suffix. Dla dowolnej skończonej historii wybór następnych pozycji jest więc
ustalony z F_t, niezależnie od wartości na tych jeszcze nieczytanych cells.
W product space joint law wybranych8 nowych cells jest uniform i niezależna
od F_t; little-endian encoding jest bijekcją do U64. Analogicznie dla get_u8.

Indukcja po getters: dla każdego konkretnego read-prefix cylinder event H
i każdej konkretnej wartości nowych n bytes,
Pr[new bytes=v AND H]=256^(-n) Pr[H]. Discarded cells nie występują w event H
i mogą zostać wycałkowane (factor1); ujawnienie ich wyłącznie jako ghost też
nie zmienia innych cells. Fresh refill zachowuje tę tożsamość. To coupling
buforowania z lazy revealing/discarding nieskończonego IID byte stream.
Blocks mogą być fizycznie wygenerowane wcześniej; nie zostają przez to
ujawnione w F_t. Literalna kolejność i suffix drops są zachowane.

## Stopping-time / fresh-tail theorem

Scalar return jest stopping time dla read filtration: decyzja po proposal
używa wyłącznie jej5 już odczytanych getter values i PAST words. Najpierw dla
każdego finite n i jego możliwego read history H_n udowodniona wyżej tożsamość
faktoryzuje H_n z dowolnym finite cylinder zdarzeniem na post-call unread tail
i future blocks. Sumowanie po countably many H_n dowodzi tej samej
faktoryzacji przy zatrzymaniu. Nie zakłada to niezależnych scalar marginals.

REJECTION_LAW osobno dowodzi Pr_IID[N<∞]=1 przez A≥1/256. Zatem post-call
state istnieje a.s.; po conditioning na cały PAST/finite return, N,output,
final ptr i revealed trace, remaining tail i future blocks nadal są IID.
Kolejne mu/sigma mogą zależeć od return i wcześniejszej historii. Po udowodnieniu
legalności nowego wejścia ten sam conditional scalar kernel ma zastosowanie.
Nie obejmuje to conditioning na pełnej wartości pozostałego bufora.

## Rozdzielenie od źródła rzeczywistego

Deterministyczne source refinement działa także na publicznych fixed tapes,
lecz powyższa probability identity nie jest wtedy tezą o jednym fixed tape.
Test refill jest mechanizmem kontroli bytes/pointers, nie generatorem seeda
lub empirycznym dowodem uniformity. PRNG_GAP_INTERFACE definiuje odrębny
cryptographic game/resource/loss obligation dla realnego ChaCha/SHAKE.
