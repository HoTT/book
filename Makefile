pdf: *.tex
	pdflatex main.tex
	pdflatex main.tex
	bibtex main
	pdflatex main.tex

clean:
	rm -f main.out
	rm -f main.aux
	rm -f main.log
	rm -f main.out
	rm -f main.pdf

