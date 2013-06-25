## ePub Fork

This is the ePub fork of the *Homotopy Type Theory* book.

To create an ePub from this, you need the following:

* The `internet` class.  This can
be obtained from
[LaTeXporter](http://www.math.ntnu.no/~stacey/code/LaTeXporter).  This
is a LaTeX class designed for converting LaTeX to various other text
formats.
* Perl.  Assembling an ePub is a complicated business so there is a
  perl script which does the heavy lifting.
* itex2MML.  At present, an external program is used to produce the
  MathML segments.  This is itex2MML.  You need the version
  [with perl support](http://www.math.ntnu.no/~stacey/code/itex).
  This needs to be compiled before use.  The compliation steps are:
  
	  make perl
	  make install_perl

  The latter step needs root privileges.  If you don't have them, work
  out where perl looks for its modules in your home directory:
  
	  perl -le 'print join(":",@INC)'
	  
  Then copy the files `itex2MML.bundle`, `itex2MML.pm`, and
  `ItexToMML.pm` into that directory.
* The perl module `MathML::Entities`.  This can be installed from
  CPAN.
* The [java epub validator](http://code.google.com/p/epubcheck/).  At
  present, the location of this file is coded into the
  `create_epub.pl` script from the `internet` class.  It is obvious
  which line to change.

Once everything is in place, run `pdflatex main.tex` to check that it
all works.  Then `create_epub.pl main.tex` to create the ePub.  At
present, there are some supposed errors reported, but it still opens
fine in iBooks.
  


## Original ReadMe

This is a textbook that we are writing on informal homotopy type theory.
It is part of the [Univalent foundations of mathematics](http://www.math.ias.edu/sp/univalent)
project which took place at the Institute for Advanced Study in 2012/13.

## License

This work is licensed under the
[Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/).

### Prerequisites and compilation

To compile the book you need a fairly new version of LaTeX.
[Texlive](http://www.tug.org/texlive/) 2012 is confirmed to work. You might need
to install some packages, see `main.tex` for packages that are used by the book.

[BasicTeX](http://www.tug.org/mactex/morepackages.html), which is a minimalistic
version of MacTeX is confirmed to work once the following packages have been
installed: `tlmgr`, `install`, `braket`, `comment`, `courier`, `enumitem`,
`helvetic`, `mathpazo`, `nextpage`, `ntheorem`, `palatino`, `rsfs`, `stmaryrd`,
`symbol`, `titlesec`, `wallpaper`, `wasy`, `wasysym`, `xstring`, `zapfding`.

You also need the `make` utility. The book is a fairly complex piece of LaTeX
code. Also, the file `version.tex` is generated on the fly, so you will need the
`make` utlity with which you can compile the main files, as follows:

* `make hott-online.pdf` -- the book appropriate for online reading, with colors and green links
* `make hott-ebook.pdf` -- the book with small margins, suitable for ebook readers
* `make hott-letter.pdf hott-cover.pdf` -- the book in black & white, letter paper format,
   for printing at home, as well as a color cover (just two pages)
* `make hott-a4.pdf hott-a4.pdf` -- the book in black & white, A4 paper format,
   for printing at home, as well as a color cover (just two pages)
* `make hott-ustrade.pdf cover-lulu.pdf` -- the book in US Trade format, without cover,
   used for the bound copy available at http://lulu.com/
* `make exercise_solutions.pdf` -- compile (some) solutions to exercises

If you do not have `make` (for example, because you are on MacOS and you did not
install the XCode command-line utilities), you can still fake it as follows.
Create the file `version.txt` and put in it (where "Joe Hacker" should be
replaced with your name):

    \newcommand{\OPTversion}{Joe-Hacker-version}

Then use whatever tools you normally do to compile LaTeX. The main LaTeX files are called 
`hott-XXX.tex`. But you really should have `make`, you know.

Once `make` is run so that `version.txt` gets generated, you need not run
`make` again. You can just perform the usual LaTeX cycle from your favorite editor.
