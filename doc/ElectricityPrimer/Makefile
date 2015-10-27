BASENAME  = primer
HAS_BIB   = no
HAS_FIGS  = yes
HAS_GLOSS = no
FIG_DIR   = figures
BIB_DIR   = ./bib
TEXFLAGS  = --output-comment 'Written by Emmet Caulfield, 2015'
TEXINPUTS = :./lib:.
#BIBINPUTS = :$(BIB_DIR)//:.
ACROREAD  = evince
PDFS      = $(addsuffix .pdf, $(BASENAME))
PSFILES   = $(addsuffix .ps,  $(BASENAME))
TEXFILES  = $(addsuffix .tex, $(BASENAME))
TEXFILES += assumptions.tex first-principles.tex rotational-mechanics.tex

export TEXINPUTS BIBINPUTS

default: pdf

pdf: figs $(PDFS)

ps: figs $(PSFILES)

view: pdf
	$(ACROREAD) $(PDFS)

preview: clean figs view

#%.pdf: LATEX:=pdflatex
#%.ps:  LATEX:=latex

%.pdf: %.tex $(TEXFILES)
	pdflatex $(TEXFLAGS) $<
ifeq ($(HAS_GLOSS),yes)
	makeglossaries $*
endif
ifeq ($(HAS_BIB),yes)
	cd $(BIB_DIR) && ${MAKE}
	bibtex $*
	pdflatex $(TEXFLAGS) $<
endif
	pdflatex $(TEXFLAGS) $<
#	pdflatex $(TEXFLAGS) $<

figs:
ifeq ($(HAS_FIGS),yes)
	cd $(FIG_DIR) && ${MAKE}
endif

%.dvi: %.tex $(TEXFILES)
	latex $(TEXFLAGS) $<
ifeq ($(HAS_GLOSS),yes)
	makeglossaries $*
endif
ifeq ($(HAS_BIB),yes)
	cd $(BIB_DIR) && ${MAKE}
	bibtex $*
	latex $(TEXFLAGS) $<
endif
	latex $(TEXFLAGS) $<

%.ps: %.dvi
	dvips -o $@ $<

clean:
	rm -f *.html *.pdf *.ps *.css
	rm -f IMG_PARAMS.db labels.pl comment.cut
	rm -f *.aux *.dvi *.log *~ temp.* *.bbl *.blg *.bmt *.idx *.ind
	rm -f IMG_PARAMS.db labels.pl *.toc *.mtc[0-9] *.mtc[0-9][0-9] *.mtc
	rm -f *.ilg *.mtc *.out *.lof *.lot *.exm
	rm -f *.ac[nr] *.alg *.gl[osg] *.ist *.xwm

pristine: clean
	cd $(FIG_DIR) && ${MAKE} clean

.PHONY: clean pristine view pdf default preview figs
