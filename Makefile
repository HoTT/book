.PHONY: default all clean version.tex dvi

# Default top-level LaTeX to generate
DEFAULTTOPTEX = hott-online.tex

# Top-level LaTeX files from which HoTT book can be generated
TOPTEXFILES = $(DEFAULTTOPTEX) hott-ustrade.tex hott-letter.tex hott-a4.tex hott-ebook.tex hott-arxiv.tex

# LaTeX files that actually comprise the book
# (that is, all of them except configuration)
BOOKTEXFILES = 	main.tex \
	macros.tex \
	version.tex \
	frontpage.tex \
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
	symbols.tex \
	back.tex \
	blurb.tex

# Configuration files
OPTFILES = opt-letter.tex \
	   opt-a4.tex \
	   opt-ustrade.tex \
	   opt-ebook.tex \
	   opt-color.tex \
	   opt-black-white.tex \
	   opt-cover.tex \
	   opt-no-cover.tex \
	   opt-bastard.tex \
	   opt-no-bastard.tex

# Image files
LORESPNGFILES = cover-lores-back-bw.png \
		cover-lores-back.png \
		cover-lores-front-bw.png \
		cover-lores-front.png \
		cover-lores.png \
		torus-lores-bw.png
HIRESPNGFILES = cover-hires-back-bw.png \
		cover-hires-back.png \
		cover-hires-front-bw.png \
		cover-hires-front.png \
		cover-hires.png \
		cover-hires-bw.png \
		torus-hires-bw.png

# All the LaTeX files for the HoTT book in order of dependency
TEXFILES = $(TOPTEXFILES) $(BOOKTEXFILES) $(OPTFILES)

# aux files to be used when combining info from HoTT book with
# exercises
BOOKAUXFILES := $(BOOKTEXFILES:.tex=.aux)

# PDF and DVI files corresponding to HoTT book files
TOPPDFFILES:=$(TOPTEXFILES:.tex=.pdf)
TOPDVIFILES:=$(TOPTEXFILES:.tex=.dvi)

# Default PDF file to make
DEFAULTPDF:=$(DEFAULTTOPTEX:.tex=.pdf)

default: $(DEFAULTPDF)

all: $(TOPPDFFILES) exercise_solutions.pdf errata.pdf cover-lulu-hardcover.pdf cover-lulu-paperback.pdf cover-letter.pdf cover-a4.pdf

dvi: $(TOPDVIFILES) exercise_solutions.dvi errata.dvi cover-lulu-hardcover.dvi cover-lulu-paperback.dvi cover-letter.dvi cover-a4.dvi

# Main targets
$(TOPPDFFILES) : %.pdf : %.tex $(TEXFILES) references.bib cover-lores-front.png cover-lores-back.png
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $< ;\
	else (echo "run 1: pdflatex $<"; pdflatex -interaction=nonstopmode $< 2>&1 >/dev/null) && \
	     bibtex $(patsubst %.tex,%,$<) && \
	     makeindex $(patsubst %.tex,%,$<) && \
	     (echo "run 2: pdflatex $<"; pdflatex -interaction=nonstopmode $< 2>&1 >/dev/null) ;\
	     pdflatex $< ;\
	     echo "HINT: If you think this took a long time you should install latexmk." ;\
	fi

$(TOPDVIFILES) : %.dvi : %.tex $(TEXFILES) references.bib cover-lores-front.png cover-lores-back.png
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -dvi $< ;\
	else (echo "run 1: latex $<"; latex -interaction=nonstopmode $< 2>&1 >/dev/null) && \
	     bibtex $(patsubst %.tex,%,$<) && \
	     makeindex $(patsubst %.tex,%,$<) && \
	     (echo "run 2: latex $<"; latex -interaction=nonstopmode $< 2>&1 >/dev/null) ;\
	     latex $< ;\
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

# Extract label numbers for verifying that they haven't changed within an edition.
# Discard symbol index numbers (not seen by user) and page numbers (we don't care about them).
main.labelnumbers: main.labels
	sed 's/.*symindex.*//g' main.labels | sed 's/{\({[^}]*}\).*/\1/g' | sort >main.labelnumbers

# Check that no labels have changed, by making sure that all label
# numbers from the first edition are still present
labelcheck: main.labelnumbers
	diff -u main.labelnumbers.first-edition main.labelnumbers | grep '^-\\newlabel' && echo Some label numbers have changed since the first edition!

cover-lulu-hardcover.pdf cover-lulu-paperback.pdf cover-letter.pdf cover-a4.pdf exercise_solutions.pdf errata.pdf : %.pdf : %.tex
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $<;\
	else pdflatex $<; fi

cover-lulu-hardcover.dvi cover-lulu-paperback.dvi cover-letter.dvi cover-a4.dvi exercise_solutions.dvi errata.dvi : %.dvi : %.tex
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -dvi $<;\
	else latex $<; fi

cover-lulu-hardcover.pdf cover-lulu-paperback.pdf cover-lulu-hardcover.dvi cover-lulu-paperback.dvi: cover-hires.png $(OPTFILES)

cover-letter.pdf cover-a4.pdf cover-letter.dvi cover-a4.dvi: cover-lores-front.png cover-lores-back.png $(OPTFILES)

hott-arxiv.tex: hott-online.tex main.tex
	echo '% hott-arxiv.tex AUTOGENERATED FROM hott-online.tex AND main.tex' >hott-arxiv.tex
	echo '\pdfoutput=1' >>hott-arxiv.tex
	cat hott-online.tex >>hott-arxiv.tex
	sed 's/\\input{main}//' <hott-arxiv.tex >hott-arxiv.tex.tmp
	mv hott-arxiv.tex.tmp hott-arxiv.tex
	cat main.tex >>hott-arxiv.tex

hott-arxiv.tar.gz: hott-arxiv.pdf
	tar -czf hott-arxiv.tar.gz hott-arxiv.tex hott-arxiv.bbl hott-arxiv.ind $(BOOKTEXFILES) $(OPTFILES) $(LORESPNGFILES) mathpartir.sty

exercise_solutions.pdf exercise_solutions.dvi: main.labels

errata.pdf errata.dvi: version.tex main.labels

clean:
	rm -f *~ *.aux {exercise_solutions,errata,hott-*}.{out,log,pdf,dvi,fls,fdb_latexmk,aux,brf,bbl,idx,ilg,ind,toc,sed}
	if which latexmk > /dev/null 2>&1 ; then latexmk -C hott-*.tex; fi

# list the tex files explicitly because:
#   - we want to tag them in the same order they appear in the book, so tag search is in logical sequence
#   - there are many *.tex garbage files in this directory
TAGS: $(TEXFILES) exercise_solutions.tex errata.tex
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
