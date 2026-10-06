# FT1536 reduction paper v0.1

English `article` draft following
`../documents/FT1536_PAPER_OUTLINE_2026-10-06.md` and the paper prompt.
The 11 sections and two annexes preserve the distinction between closed
conditional mathematics and the in-flight real-Sign bridge.

Build from this directory:

```sh
make pdf
```

Output: `build/main.pdf`. Build logs, TeX cache and temporary files remain
under the ignored, persistent `build/` directory. For the complete document
check, first run `make numbers` (standard Sage preparser, exact QQ/ZZ
display arithmetic), then `make check`. The latter checks source pins,
claim IDs, section structure, table displays and the final LaTeX log.
It is not a Lean replay or mathematical acceptance of the development.
See `SOURCES.md` for the 20 statement groups and `SOURCES.sha256` for their
97 pinned inputs. `notes/PAPER_WORK_STATE.md` contains the handoff and the
three owner decisions. Some original receipts are local ignored artifacts;
the public-release packaging obligation is explicit in Annex A.

The first two real-Sign arrows, actual attempt-law choice, B1.10 key law,
global A3/A4 bridge and S06 certification remain open/in flight. Literature
and project-origin material retain visible TODOs. The mission and working
title await owner approval.
