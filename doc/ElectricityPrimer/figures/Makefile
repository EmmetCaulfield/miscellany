SVGS:=negative.svg positive.svg ivdiode.svg
RSRC:=ac.R rcstep.R rlstep.R capac.R indac.R srlac.R phasor.R acpower.R
RSRC+=pwrphasor.R

PDFS:=$(SVGS:.svg=.pdf)
PDFS+=$(RSRC:.R=.pdf)

default: $(PDFS)

%.pdf: %.eps
	epstopdf $<

# R
%.pdf: %.R header.R
	cat $< | R --no-save -q

# Inkscape / SVG
%.eps: %.svg
	inkscape -E $@ $<

# Gnuplot
%.eps: %.gp
	cat $< | gnuplot

# Octave/Matlab
%.eps: %.m
	cat $< | octave -q

%.png: %.svg
	inkscape -e $@ -d 300 $<

clean:
	rm -f *.pdf $(RSRC:.R=.svg) *~

.PHONY: clean default
