# OUTPUT_SCOPE — zakres OUTPUTS.sha256

OUTPUTS.sha256 obejmuje regularne artefakty W (REPORT/RESULT/CLAIM/certyfikaty/
dokumenty/checks/formal/logi/evidence) BEZ: samego OUTPUTS.sha256, inputs/
(przypięte INPUTS.sha256 + bootstrap MANIFEST), cache/, bin/, home/, tmp/
(replay DESTs — robocze), *.olean, binariów checks/c_slice (harness_rint*),
__pycache__. REPORT i RESULT są członkami. Świeży artifacts/fresh_replay.json
jest członkiem (rehearsal z anchor — patrz REPLAY.md; cykl hashy uniknięty:
receipt wskazuje zewnętrzny SHA OUTPUTS i matches semantic files, a OUTPUTS
mrozi jego bajty po rehearsal).
