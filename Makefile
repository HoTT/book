all pdf: *.tex
	pdflatex main.tex
	pdflatex main.tex
	bibtex main
	pdflatex main.tex

clean:
	/bin/rm -f main.out
	rm -f main.aux
	rm -f main.log
	rm -f main.out
	rm -f main.pdf

etc/refdict.py: $(wildcard *.aux)
	echo "# AUTOMATICALLY GENERATED, DO NOT HANDLE WITH BARE HANDS" > $@
	echo "ref_index = {" >> $@
	sed -f etc/aux2refdict.sed $^
	echo "}" >> $@

