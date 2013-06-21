This is a textbook that we are writing on informal homotopy type theory.
It is part of the [Univalent foundations of mathematics](http://www.math.ias.edu/sp/univalent)
project which took place at the Institute for Advanced Study in 2012/13.

## How to compile the book

The book is a fairly complex piece of LaTeX code. The enclosed `Makefile` helps
you compile the main files, as follows:

* `make hott-online.pdf` -- the book appropriate for online reading, with colors and green links
* `make hott-ebook.pdf` -- the book with small margins, suitable for ebook readers
* `make hott-letter.pdf hott-cover.pdf` -- the book in black & white, letter paper format,
   for printing at home, as well as a color cover (just two pages)
* `make hott-a4.pdf hott-a4.pdf` -- the book in black & white, A4 paper format,
   for printing at home, as well as a color cover (just two pages)
* `make hott-ustrade.pdf cover-lulu.pdf` -- the book in US Trade format, without cover,
   used for the bound copy available at http://lulu.com/
* `make exercise_solutions.pdf` -- compile (some) solutions to exercises

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

You also need the `make` utility. If you do not have it (for example, because
you are on MacOS and you did not install the XCode command-line utilities), you
can still fake it as follows. Create the file `version.txt` and put in it (where
"Joe Hacker" should be replaced with your name):

    \newcommand{\OPTversion}{Joe-Hacker-version}

Then use whatever tools you normally do to compile LaTeX. The main LaTeX files are called `hott-XXX.tex`.

Once you have run `make` so that `version.txt` was generated, you need not run
it again. You can just perform the usual LaTeX cycle from your favorite editor.
