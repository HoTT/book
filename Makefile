all: main.pdf

main.pdf: *.tex
	(which latexmk && latexmk -pdf main.tex) || ( \
	pdflatex main.tex && \
	pdflatex main.tex && \
	bibtex main && \
	pdflatex main.tex)

clean:
	(which latexmk && latexmk -c main.tex) || /bin/rm -f main.{out,log,pdf,fls,fdb_latexmk}

