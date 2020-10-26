PDFLATEX := pdflatex
# Aggregate
.PHONY: presentation
presentation: pres.pdf pres-ann.pdf
# Single components
.PHONY: pres.pdf
pres.pdf: pres.tex content.tex
	$(PDFLATEX) $<
.PHONY: pres.pdf
pres-ann.pdf: pres-ann.tex content.tex
	$(PDFLATEX) $<
# Cleanup
.PHONY: clean
clean:
	rm -f pres.pdf
	rm -f pres-ann.pdf
