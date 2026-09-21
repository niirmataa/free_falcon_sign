# Wyniki konsumowane w M0

PREV=L_V_BRIDGE. REPORT pin81702fa89ee516f162a37db86e2abb03ae0bb57a49a5723ed63eab5a17a69296,
OUTPUTS pin13fa5a9f706a962434c8ac479212af5ef33d91e1ececd6c948d68ed42871a74e.
97 wybranych wejść: INPUTS.sha256 / inputs/provenance.json.15 zadanych pinów
oraz17 źródeł zweryfikowano przed obliczeniami.

- Pełne L_V dotyczy kandydata3fe78f8d… i wszystkich canonical h,c/legal b,
  NONE/STATIC bez cap2049. W M0 jest gotowym interfejsem ekstrakcji, nie
  twierdzeniem o rozkładzie Sign albo naturalnej trudności MT-ISIS.
- Norm64.lean, pin d25a61941a86864cc9d34400e86d948124529b1e6765b0676c97cf41b4f92d5a:
  definicje A2/Q0/Q i STRICT_B dla signed16; używane przez CapacityMath
  oraz capacity_after_source_norm. NORM64_EXACT i brak overflow są odziedziczone.
- Sums.lean: dokładne skończone sumy, split/linearity; używane do nowego
  boundu l1 i quotientów. Nie zmieniono importowanych definicji.
- Transitive closure61 formalnych źródeł od Norm64 jest bajtowo identyczny,
  ponownie sprawdzony kernelowo. Stare olean/cache nie były wejściami dowodu.
- VerifyBytes.lean, pin6c33ca86d82c72fd8421d7d52ce5e13ee6a0a2b17e767ca0c308d9a72ede28ac,
  zachowano jako przypięty eksport kontekstowy L_V. M0 nie powtarza całego
  parser proof ani jego native campaign.
- Mapa dalszych działań, pin b299acc13ec1bd1b2d5d9906fb403bbd9c35e8db1483eb9671247540731266a1,
  określa zakresy M1–M7, T2C3/T5, status R5T i prawidłowy kierunek image hop.
- Cel z17 IX, pin5b1b0e3e15f14aca63fce9007cebb36c493aa2669ca6e8ad35dccd32023ac11e:
  historyczne pary praw i framing counterexample. Jego2049, otwarty L_V na
  oryginalnym S17 i zapis „448-bit ChaCha” NIE są parametrami nowego kontraktu.

T2C3 pozostaje fixed-key h*: E_h*^Q<4489/[2^54(2^24−1)^2]<2^-89.
T5 pozostaje all-successful-key pure/untruncated theta<2^-40, delta_key=0
tylko dla tego twierdzenia. Nie są utożsamione z populacyjnym accepted-image e.
Warunkowy R5T (T_h<2^-138, E<2^-106) potrzebuje nowego spójnego pakietu M4;
stary niespójny freeze279dce… nie został naprawiony ani przyjęty jako finalny.

H1R directional/full-support premises, R3G conditional composition i H6P
no-go dla scalar summaries/joint pre-cast zachowano jako opisane warunkowe
interfejsy w ledgerze. Nie nadano im nowych source-level statusów. Nie otwierano
prywatnych producentów danych, seedów, .private ani archiwalnych runnerów.
