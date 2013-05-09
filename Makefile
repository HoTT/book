.PHONY: all once clean

all: main.pdf exercise_solutions.pdf

main.pdf: *.tex cover.png
	if which latexmk > /dev/null ;\
	then latexmk -pdf main.tex ;\
	else pdflatex main.tex && \
	     bibtex main && \
	     pdflatex main.tex ;\
	fi

main.labels : main.aux front.aux preface.aux introduction.aux preliminaries.aux basics.aux logic.aux equivalences.aux induction.aux hits.aux hlevels.aux homotopy.aux categories.aux setmath.aux reals.aux formal.aux
	cat $^ | grep ^.newlabel >$@
exercise_solutions.pdf: exercise_solutions.tex main.labels
	latexmk -pdf exercise_solutions.tex

once:; pdflatex main.tex && bibtex main

clean:
	rm -f *.aux main.{out,log,pdf,fls,fdb_latexmk,aux,brf,bbl}
	if which latexmk; then latexmk -C main.tex; fi

# list the tex files explicitly because:
#   - we want to tag them in the same order they appear in the book, so tag search is in logical sequence
#   - there are many *.tex garbage files in this directory
TAGS: main.tex macros.tex front.tex preface.tex introduction.tex preliminaries.tex basics.tex \
	logic.tex equivalences.tex induction.tex hits.tex hlevels.tex homotopy.tex categories.tex \
	setmath.tex reals.tex formal.tex exercise_solutions.tex
	etags $^ >TAGS
