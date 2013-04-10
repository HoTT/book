.PHONY: all pdf html tex glob tidy clean

all: pdf html tex glob

glob: Reading_HoTT_in_Coq.v
	coqc Reading_HoTT_in_Coq.v

tex: glob 
	coqdoc --latex --no-lib-name --toc Reading_HoTT_in_Coq.v

html: glob
	coqdoc --html  --no-lib-name --toc --no-index Reading_HoTT_in_Coq.v

pdf: tex
	pdflatex Reading_HoTT_in_Coq.tex

tidy:
	-rm Reading_HoTT_in_Coq.vo
	-rm Reading_HoTT_in_Coq.out
	-rm Reading_HoTT_in_Coq.log
	-rm Reading_HoTT_in_Coq.aux
	-rm NReading_HoTT_in_Coq*
	-rm coqdoc.sty

clean: tidy
	-rm Reading_HoTT_in_Coq.tex
	-rm Reading_HoTT_in_Coq.html
	-rm Reading_HoTT_in_Coq.glob
	-rm Reading_HoTT_in_Coq.pdf
	-rm coqdoc.css
	-rm index.html

