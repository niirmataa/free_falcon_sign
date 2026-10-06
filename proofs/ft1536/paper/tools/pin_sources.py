"""Capture the explicitly selected drafting inputs; normal checks never repin."""
import hashlib
from pathlib import Path
import re

PAPER = Path(__file__).resolve().parents[1]
ROOT = PAPER.parents[2]


def main():
    text = (PAPER / "SOURCES.md").read_text()
    block = re.search(r"<!-- PINNED_INPUTS -->\s*```text\n(.*?)\n```", text, re.S)
    paths = block.group(1).splitlines()
    assert len(paths) == len(set(paths)), "Duplicate input path"
    lines = []
    for relative in paths:
        path = ROOT / relative
        assert path.is_file(), f"Missing input: {relative}"
        lines.append(hashlib.sha256(path.read_bytes()).hexdigest() + "  " + relative)
    (PAPER / "SOURCES.sha256").write_text("\n".join(lines) + "\n")
    print(f"Captured {len(paths)} drafting input pins")


if __name__ == "__main__":
    main()
