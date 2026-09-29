# LegalTargetBuffers, initialized reads i pełny normalized-key frame

LegalTargetBuffers obejmuje live aligned typed objects: sk≥24576 fpr words
read-only, tmp≥10752 fpr words writable, hm≥1536 uint16 readable/canonical
i legalne output s1/s2 oraz context objects. Tmp jest disjoint od sk/hm/
outputs/context; source memcpy ranges nie zachodzą na siebie. Caller arrays
s1/s2/hm mają3072 slots; theorem używa pierwszych1536 hm, a outputs nie dotyka.
Standard C restrict/lifetimes są jawne, bez overlapping writable aliases.

Fixed MKN(10,1)=1536 daje pointers:
t0=tmp0,t1=tmp1536,tx=tmp3072,ty=tmp4608,tz=tmp6144;
b00=sk0,b01=sk1536,b10=sk3072,b11=sk4608,tree=sk6144.
Wszystkie formowane pointers są w legalnych allocations. Byte counts:
sk196608,tmp86016,copy12288; mieszczą się w size_t/int domains.

Actual prefix writes:
1. Conversion u0..1535 inicjalizuje wyłącznie t0.
2. FFT3 in-place czyta/zapisuje te same1536 words; legal packed indices
   i stages pochodzą z FFT certificate.
3. NI jest local Word, nie ma heap writes.
4. memcpy kopiuje wszystkie initialized t0 do disjoint t1; komentarz o
   implicit zero t1 nie wykonuje żadnych stores.
5. mul/scale t1 zapisują[1536,3072), czytając wyłącznie t1 i const b01.
   W tym czasie t0 nadal zawiera snapshot FFT(c).
6. mul/scale t0 zapisują[0,1536), czytając const b11. Całe sk jest niezmienione.

Union footprint to dokładnie tmp[0,3072). Zachowane są tmp[3072,10752),
hm, output s1/s2, context/coins i WSZYSTKIE24576 normalized sk words:
6144 basis,16896 L,1536 stored widths. To source destination/range proof,
instancjujący kernel target_frame/whole_key_frame w tagged-address modelu.
Nie ogłoszono verified C heap/compiler. Nie przypisujemy initialized status
przyszłym tx/ty/tz ani totality samplera.

Stable values pozostałe w dawnym tmp mogą zostać nadpisane przez targets.
Width source przy sampling entry to normalized tree w sk. Prefix nie czyta
starej zawartości tmp przed jej właściwą inicjalizacją. Canary controls
wypełniają scratch markerami tylko do sprawdzenia frame, nie jako premise
actual target algorithmu.

Caller3243–3245 oblicza dokładnie16N sk i7N tmp; failures malloc są poza
legal-buffer theorem. Synthetic C harness zachowuje cały sk/hm/output/
context i tmp suffix, obserwuje każdą primitive raz i kończy się przed
sampler call. Nie używa fikcyjnego samplera do kończenia do_sign.
