SHELL := /bin/bash
.PHONY: pdf check

pdf:
	mkdir -p build/home build/tmp build/cache build/texmf-var build/texmf-config
	HOME="$(CURDIR)/build/home" TMPDIR="$(CURDIR)/build/tmp" \
	 XDG_CACHE_HOME="$(CURDIR)/build/cache" TEXMFVAR="$(CURDIR)/build/texmf-var" \
	 TEXMFCONFIG="$(CURDIR)/build/texmf-config" \
	 latexmk -pdf -outdir=build -interaction=nonstopmode -halt-on-error -file-line-error main.tex

check: pdf
	python3 -B tools/check_paper.py
