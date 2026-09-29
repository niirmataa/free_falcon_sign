# V02 — doprecyzowanie niezależności i poprawka kontroli transportu

Właściciel przekazał frozen PASS_SCOPED_REVIEW V02 i poprosił o decyzję
koordynatora z uwzględnieniem tego samego modelu recenzenta i pakującego.
Po pytaniu prowadzącego doprecyzował dosłownie:

> ale nigdzie nie jest napisane ze odbierac musi ten sam co wyprowadzil
> dowod wcesniej wlasnie chodzilo o to zeby to robil niezalkeny model

Przyjęta podstawa:autor dowodów **Astra Fast**,recenzent **Sol**,osobna
świeża sesja ses_f12645f4effei2l7zDf6rzsuJN. Recenzent nie był wykonawcą
tych dowodów. Wspólny model z pakującym Sol w innej sesji pozostaje jawnym
ograniczeniem proweniencji,nie jest przedstawiany jako niezależność modelowa
od pakowania. Nie wymaga nowego powtarzania odbioru przez autora dowodów.

Koordynator przyjmuje wyłącznie odebrany PARTIAL scope z REVIEW_RESULT:
LE64 i literal-word execution w podanych domenach. Conditional sub nie
jest używalnym arithmetic contract;no_add_dispatch wskazuje niemożliwą
przesłankę. Real arithmetic,rint/caller domains i C→machine pozostają OPEN.
To nie owner acceptance pełnego schematu,nie nowy proof ani zgoda na push.

## Własny błąd komparatora — bez zmiany pakietów

Pierwsze `check_review.py` przeszło zewnętrzne piny,343 outputs i30633 inputs,
ale komparator semantic lookup zakładał `evidence/replay/build/`. Recenzent
ma udokumentowane kopiowanie do `evidence/replay/semantic/` w sealed
`sources/build_review_package.py`. Kontrolę zatrzymano i zgłoszono;wejścia
pozostały nietknięte. `check_review_attempt_001.py` i stop record zachowane.
Traceback był wynikiem narzędzia,nie przekierowanym raw logiem procesu;
nie dorabiamy takiego receiptu po fakcie.

Nowy checker stosuje rzeczywistą mapę transportu oraz wymaga zgodności
hashu produktu z manifestem review,baseline autora i semantic planem.
Również own_final tekstowe produkty są flat pod evidence/own_final,
co sprawdzamy jawnie;wyłączenie dotyczy wyłącznie binarnego .olean.

## Rozmiar checkpointu

Preflight wskazał34057 pathspeców:3577665 bajtów tekstu plus272960 bajtów
wskaźników i małe env. Domyślny ARG_MAX2097152 jest za mały. Kanoniczny
archive.py uruchomimy pod `prlimit --stack=33554432`;sprawdzono wtedy
ARG_MAX6291456. Nie zmieniamy walidacji,manifestów,skryptu archive.py ani
limitów Lean/Sage — to środowisko procesu organizacyjnego Git/checkpoint.
