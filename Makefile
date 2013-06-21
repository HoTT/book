.PHONY: default all clean version.tex

# Default top-level LaTeX to generate
DEFAULTTOPTEX = hott-online.tex

# Top-level LaTeX files from which HoTT book can be generated
TOPTEXFILES = $(DEFAULTTOPTEX) hott-ustrade.tex hott-letter.tex hott-a4.tex hott-ebook.tex

# LaTeX files that actually comprise the book
# (that is, all of them except configuration)
BOOKTEXFILES = 	main.tex \
	macros.tex \
	version.tex \
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

# Configuration files
OPTFILES = opt-letter.tex \
	   opt-a4.tex \
	   opt-ustrade.tex \
	   opt-color.tex \
	   opt-cover.tex

# All the LaTeX files for the HoTT book in order of dependency
TEXFILES = $(TOPTEXFILES) $(BOOKTEXFILES) $(OPTFILES)

# aux files to be used when combining info from HoTT book with
# exercises
BOOKAUXFILES := $(BOOKTEXFILES:.tex=.aux)

# PDF files corresponding to HoTT book files
TOPPDFFILES:=$(TOPTEXFILES:.tex=.pdf)

# Default PDF file to make
DEFAULTPDF:=$(DEFAULTTOPTEX:.tex=.pdf)

default: $(DEFAULTPDF)

all: $(TOPPDFFILES) exercise_solutions.pdf cover-lulu-hardcover.pdf cover-lulu-paperback.pdf cover-letter.pdf cover-a4.pdf

# Main targets
$(TOPPDFFILES) : %.pdf : %.tex $(TEXFILES) references.bib cover-lores-front.png cover-lores-back.png
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $< ;\
	else pdflatex $< && \
	     bibtex $(patsubst %.tex,%,$<) && \
	     makeindex $(patsubst %.tex,%,$<) && \
	     pdflatex $< ;\
	     pdflatex $< ;\
	     echo "HINT: If you think this took a long time you should install latexmk." ;\
	fi

all default: log-check
log-check:
	: check for indexing errors
	! grep -n "!! Input index error" hott-online.ilg /dev/null

version.tex:
	/bin/echo -n '\newcommand{\OPTversion}{' > version.tex
	git describe --always --long >> version.tex
	/bin/echo -n '}' >> version.tex

# these warnings are mostly spurious, and could have been prevented by a better makeindex algorithm
log-check-for-warnings:
	: check for indexing warnings
	- ! grep -n "## Warning" hott-online.ilg /dev/null

$(BOOKAUXFILES) : %.aux : %.tex
	echo "WARNING: assuming $> is up-to-date"

# Generate labels for the solutions
main.labels: $(BOOKAUXFILES)
	cat $^ | grep ^.newlabel >$@

cover-lulu-hardcover.pdf: cover-lulu-hardcover.tex cover-hires.png $(OPTFILES)
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $<;\
	else pdflatex $<; fi

cover-lulu-paperback.pdf: cover-lulu-paperback.tex cover-hires.png $(OPTFILES)
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $<;\
	else pdflatex $<; fi

cover-letter.pdf: cover-letter.tex cover-lores-front.png cover-lores-back.png $(OPTFILES)
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $<;\
	else pdflatex $<; fi

cover-a4.pdf: cover-a4.tex cover-lores-front.png cover-lores-back.png $(OPTFILES)
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $<;\
	else pdflatex $<; fi

exercise_solutions.pdf: exercise_solutions.tex main.labels
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $<;\
	else pdflatex $<; fi

clean:
	rm -f *~ *.aux {exercise_solutions,hott-*}.{out,log,pdf,fls,fdb_latexmk,aux,brf,bbl,idx,ilg,ind,toc}
	if which latexmk > /dev/null 2>&1 ; then latexmk -C hott-*.tex; fi

# list the tex files explicitly because:
#   - we want to tag them in the same order they appear in the book, so tag search is in logical sequence
#   - there are many *.tex garbage files in this directory
TAGS: $(TEXFILES) exercise_solutions.tex
	etags $^ -o $@.tmp
	mv $@.tmp $@

indexterms.txt:					\
	other/index-helper.py			\
	front.tex				\
	preface.tex				\
	introduction.tex			\
	preliminaries.tex			\
	basics.tex				\
	logic.tex				\
	equivalences.tex			\
	induction.tex				\
	hits.tex				\
	hlevels.tex				\
	homotopy.tex				\
	categories.tex				\
	setmath.tex				\
	reals.tex				\
	formal.tex
		other/index-helper.py >$@

