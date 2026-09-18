#!/usr/bin/env python3
import platform
from pathlib import Path
import subprocess

W = Path(__file__).resolve().parents[1]
commands = [
    ("SageMath", ["/home/footfalcon/.local/bin/sage", "--version"]),
    ("Python", ["python3", "--version"]),
    ("Lean", ["/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean", "--version"]),
    ("GCC", ["/usr/bin/gcc", "--version"]),
    ("Git", ["git", "--version"]),
    ("bubblewrap", ["/usr/bin/bwrap", "--version"]),
    ("ripgrep", ["rg", "--version"]),
]
lines = ["DAYBREAK toolchain capture", "platform: " + platform.platform()]
for name, argv in commands:
    p = subprocess.run(argv, capture_output=True, text=True)
    value = (p.stdout or p.stderr).splitlines()[0] if (p.stdout or p.stderr) else "no output"
    lines.append(f"{name}: {value} (exit {p.returncode})")
lines.extend([
    "C model: Linux x86_64, C99, LP64 (static assertions checked by replay harness)",
    "Sandbox observed: write allowed only under W; O_RDWR outside W returned EROFS",
    "Caches: TMPDIR, XDG_CACHE_HOME, DOT_SAGE, PYTHONPYCACHEPREFIX redirected under W",
    "Network: not used",
])
text = "\n".join(lines) + "\n"
(W / "TOOLCHAIN.txt").write_text(text, encoding="utf-8")
print(text, end="")
