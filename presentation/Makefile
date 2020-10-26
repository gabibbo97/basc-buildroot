PDFLATEX := pdflatex
# Aggregate
.PHONY: presentation
presentation: pres.pdf pres-ann.pdf
# Single components
.PHONY: pres.pdf
pres.pdf: content.tex pres.tex
	$(PDFLATEX) pres.tex
.PHONY: pres.pdf
pres-ann.pdf: content.tex pres-ann.tex
	$(PDFLATEX) pres-ann.tex
# Cleanup
.PHONY: clean
clean:
	rm -f pres.pdf
	rm -f pres-ann.pdf
