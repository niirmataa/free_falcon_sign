SHELL := /bin/bash
.PHONY: pdf numbers check

pdf:
	mkdir -p build/home build/tmp build/cache build/texmf-var build/texmf-config
	HOME="$(CURDIR)/build/home" TMPDIR="$(CURDIR)/build/tmp" \
	 XDG_CACHE_HOME="$(CURDIR)/build/cache" TEXMFVAR="$(CURDIR)/build/texmf-var" \
	 TEXMFCONFIG="$(CURDIR)/build/texmf-config" \
	 latexmk -pdf -outdir=build -interaction=nonstopmode -halt-on-error -file-line-error main.tex

numbers:
	python3 -B tools/run_numbers.py

build/numbers.json: tools/check_numbers.sage tools/run_numbers.py
	python3 -B tools/run_numbers.py

check: pdf build/numbers.json
	python3 -B tools/check_paper.py
