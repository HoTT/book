.PHONY: default all clean

# Default top-level LaTeX to generate
DEFAULTTOPTEX = hott-online.tex

# Top-level LaTeX files from which HoTT book can be generated
TOPTEXFILES = $(DEFAULTTOPTEX) hott-ustrade.tex hott-letter.tex

# LaTeX files that actually comprise the book
# (that is, all of them except configuration)
BOOKTEXFILES = 	main.tex \
	macros.tex \
	front.tex \
	preface.tex \
	introduction.tex \
	preliminaries.tex \
	basics.tex \
	logic.tex \
	equivalences.tex \
	induction.tex \
	hits.tex \
	hlevels.tex \
	homotopy.tex \
	categories.tex \
	setmath.tex \
	reals.tex \
	formal.tex \
	back.tex

# All the LaTeX files for the HoTT book in order of dependency
TEXFILES = $(TOPTEXFILES) \
	opt-letter.tex \
	opt-ustrade.tex \
	$(BOOKTEXFILES)

# aux files to be used when combining info from HoTT book with
# exercises
BOOKAUXFILES := $(BOOKTEXFILES:.tex=.aux)

# PDF files corresponding to HoTT book files
TOPPDFFILES:=$(TOPTEXFILES:.tex=.pdf)

# Default PDF file to make
DEFAULTPDF:=$(DEFAULTTOPTEX:.tex=.pdf)

default: $(DEFAULTPDF)

all: $(TOPPDFFILES) exercise_solutions.pdf

# Main targets
$(TOPPDFFILES) : %.pdf : %.tex cover.png $(TEXFILES) references.bib
	if which latexmk > /dev/null ;\
	then latexmk -pdf $< ;\
	else pdflatex $< && \
	     bibtex $< && \
	     makeindex $< && \
	     pdflatex $< ;\
	     pdflatex $< ;\
	     echo "HINT: If you think this took a long time you should install latexmk." ;\
	fi

$(BOOKAUXFILES) : %.aux : %.tex
	echo "WARNING: assuming $> is up-to-date"

# Generate labels for the solutions
main.labels: $(BOOKAUXFILES)
	cat $^ | grep ^.newlabel >$@

exercise_solutions.pdf: exercise_solutions.tex main.labels
	if which latexmk > /dev/null;\
	then latexmk -pdf $<;\
	else pdflatex $<; fi

clean:
	rm -f *~ *.aux {exercise_solutions,hott-*}.{out,log,pdf,fls,fdb_latexmk,aux,brf,bbl,idx,ilg,ind,toc}
	if which latexmk > /dev/null; then latexmk -C hott-*.tex; fi

# list the tex files explicitly because:
#   - we want to tag them in the same order they appear in the book, so tag search is in logical sequence
#   - there are many *.tex garbage files in this directory
TAGS: $(TEXFILES) exercise_solutions.tex
	etags $^ >TAGS
