# Zacięcia hosta — odczyt po zakończeniu prób020B

2026-10-11, późniejsza diagnostyka na zgłoszenie właściciela. Bez ciężkich
jobów, zatrzymywania aplikacji, przenoszenia danych lub zmian systemowych.

- System `/`: `/dev/sda6`, ext4, dysk sda przezUSB, ROTA=1.
- Repozytorium: `/dev/nvme0n1p3`, ext4, NVMe Samsung256GB; około27GiB wolne.
- `.elan/toolchains/leanprover--lean4---v4.34.0`, `.codex` i dane OpenCode
  znajdują się na systemowym sda6, nie na NVMe.
- MemAvailable9443720KiB; swap10360828KiB, zużycie0. PSI memory avg300=0.
- Pierwszy PSI I/O full avg300=42,04%; później33,81%. Nie jest to pomiar
  uszkodzenia nośnika, tylko istotnych zatorów I/O.
- Próbka3s: sda busy93,7%, read2,70MiB/s, write1,76MiB/s,
  await3,12ms, średnia kolejka1,33. NVMe busy0%, bez operacji w tej próbce.
- Domyślny Docker socket `/var/run/docker.sock` niedostępny. Nie zmierzono
  kontenera Alpine i nie wskazano go jako sprawcy. Odczyt journala bez
  uprawnień systemowych nie wyklucza usterek sprzętu lub sterownika.

Wniosek lokalny: mocne przesłanki wąskiego gardła systemowego dyskuUSB;
samo zwiększanie limitu RAM nie usuwa tego problemu. Nie stwierdzono
wyczerpania RAM ani użycia swapu w zmierzonym momencie.

Właściciel polecił przeniesienie narzędzi/danych na NVMe, następnie wskazał
dodatkowy dysk500GB i zapytał o instalację Debiana z obecnego systemu.
Ten dysk nie był widoczny w odczytanym lsblk. **Nic nie przeniesiono ani
nie sformatowano.** Przenosiny czekają na identyfikację docelowego nośnika;
aktywne bazy aplikacji wymagają kontrolowanego zamknięcia przed podmianą.
Instalacja Debiana przez debootstrap/chroot jest opisana w oficjalnym
podręczniku: https://www.debian.org/releases/stable/amd64/apds03.en.html.
Pytanie o instalację nie jest zgodą na formatowanie niezidentyfikowanego dysku.

Doprecyzowanie właściciela: NVMe500GB **dopiero zostanie podłączony**.
Uzgodniony kierunek: nowy Debian i migracja środowiska pracy; przed
instalacją nadal potrzebna identyfikacja dysku oraz jego danych/partycji.
