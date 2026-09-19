# Freeze H3_ROOT_LDL

OUTPUTS.sha256 jest autorytatywnym zbiorem bajtów, względem W. Obejmuje
wymagane dokumenty, trzy teksty dowodu, ROOT_CERTIFICATE/BOUND_LEDGER,
INPUTS/TOOLCHAIN/AGENTS oraz source/, inputs/, formal/, scripts/, checks/,
artifacts/ i logs/ istniejące podczas seal. Zawiera131 semantic matches
i artifacts/fresh_replay.json. Source/bootstrap pozostają niezmiennymi wejściami.

Wyłączone: sam manifest, dynamiczny COMMANDS.log/executor.lock, tmp/, cache/,
bin/, wszystkie olean/ilean/pyc. artifacts/COMMANDS.frozen.log jest dokładnym
ukończonym prefiksem poleceń sprzed seal; bytes/hash/count są w command_prefix.
Późniejszy seal receipt/logs i post-freeze DEST nie zmieniają tego prefiksu.

Pełne nieudane elaboracje/probe/oracle attempts zachowano, nie są finalnymi
importami. W historycznych error logs mogą wystąpić warning/sorryAx generowane
przez nieudany elaborator. Finalne17 modułów/99 twierdzeń (17 nowych) mają
czyste logs/final, pełne types/terms nowych theoremów i axiom audit wszystkich.
Nie wyciszano linterów i nie filtrowano strumieni. Wszystkie11 odziedziczonych
modułów przebudowano bez zmiany bajtów.

Mixed proof scope pozostaje jawny: kernel integer/model/frame lemmas plus
universal analytic source proof i exact certificates. Nie ogłoszono full
kernel compiler lub całego internal tree/Reach/sampler law. Standardowy replay
po freeze zapisuje wyłącznie do nowego DEST, gdzie znajdują się jego receipts.
Archiwum proof jest gotowe do niezależnego importu/checkpointu prowadzącego.
