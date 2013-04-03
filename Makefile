all: main.pdf

main.pdf: *.tex cover.png
	if which latexmk > /dev/null ;\
	then latexmk -pdf main.tex ;\
	else pdflatex main.tex && \
	     bibtex main && \
	     pdflatex main.tex ;\
	fi

clean:
	(which latexmk && latexmk -c main.tex) || /bin/rm -f main.{out,log,pdf,fls,fdb_latexmk}


TAGS: *.tex
	etags $^ >TAGS
