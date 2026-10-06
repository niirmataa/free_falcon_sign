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
under the ignored, persistent `build/` directory. `make check` checks the
source pins and the final LaTeX log after the drafting stage is complete.
See `notes/PAPER_WORK_STATE.md` for the current stage and owner decisions.
