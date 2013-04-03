all: main.pdf

main.pdf: *.tex cover.png
	(which latexmk && latexmk -pdf main.tex) || ( \
	pdflatex main.tex && \
	pdflatex main.tex && \
	bibtex main && \
	pdflatex main.tex)

clean:
	(which latexmk && latexmk -c main.tex) || /bin/rm -f main.{out,log,pdf,fls,fdb_latexmk}


TAGS: main.tex macros.tex front.tex preface.tex introduction.tex preliminaries.tex basics.tex basics-equivalences.tex\
	computational.tex equivalences.tex induction.tex hits.tex hlevels.tex homotopy.tex categories.tex \
	setmath.tex ordcard.tex reals.tex uatofe.tex formal.tex
	etags $^ >TAGS
