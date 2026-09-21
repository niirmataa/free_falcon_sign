# Zakres pakietu i freeze

scripts/scope.py obejmuje wszystkie regularne files W z wyjątkiem root tmp/,
bin/,cache/,COMMANDS.log,executor.lock,OUTPUTS.sha256 oraz __pycache__/.olean/
.ilean/.pyc. Symlinki i members>32MiB są odrzucane. Dane source/IN,formalne
źródła,proofdocuments,publicword/tapefixtures,pełne native traces,failedroutes,
receipts i exact certificates pozostają w OUTPUTS. Nie ma seeds,keys,private
extraction,credentials lub project binaries/cache w pakiecie.

W i wszystkie replaye/cache/bin/olean leżą na trwałym ext4. Systemowy /tmp
ani tmpfs nie przechowują plików projektu. Widok ukrywający historyczne originals
to readonly marker directory pod inputs/hidden_originals,bez tmpfs projectdata.

COMMANDS.frozen.log/final_prefix.log są completed prefixes z size/count/SHA
receipts. Root COMMANDS.log jest roboczym journalem poza manifestem; po freeze
nie dopisuje się do niego jobs. Failed logs/source drafts zachowane. Final
Lean logs są osobnym audytem,bez wyciszania warningów i filtrowania porażek.

Rehearsal anchor powstaje przed sobą samym,REPORT/RESULT/fresh_replay/OUTPUTS;
TODO.md pozostaje roboczą listą zadań do final freeze i jest wyłączone TYLKO
z wcześniejszego anchoru. Nie jest mathematical input. Final manifest obejmuje
snapshot TODO na freeze. Późniejszy postfreeze status jest w nowym DEST/receipt
i final handoffie,ponieważ frozen listy też nie wolno nadpisać.

Sealed artifacts/fresh_replay.json zawiera actualFRESH_REPLAY_PASS i niepuste
matches[{path,sha256}] odtworzonych semantic outputs. Wszystkie expectedgenerated
pliki usuwane przed replayjobs,bez projectbin/olean/cache. Po finalOUTPUTS
zapis tylko do nowego DEST pod W/tmp. Repo/stages/import/Git/owneracceptance
pozostają prowadzącemu sesję zgodnie z workflow.
