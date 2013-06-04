This is a textbook that we are writing on informal homotopy type theory.
It is part of the [Univalent foundations of mathematics](http://www.math.ias.edu/sp/univalent)
project which took place at the Institute for Advanced Study in 2012/13.

## How to compile the book

The book is a fairly complex piece of LaTeX code. The enclosed `Makefile` helps
you compile the main files, as follows:

* `make hott-online.pdf` -- the book appropriate for online reading, with colors and green links
* `make hott-letter.pdf` -- the book in black & white, letter paper format, for printing at home
* `make cover-letter.pdf` -- generate color cover, letter paper format, for printing at home
* `make hott-ustrade.pdf` -- the book in US Trade format, without cover, used for the bound copy available at http://lulu.com/
* `make cover-lulu.pdf` -- generate color cover, US Trade format, very high resoltuion, used for the bound copy available at http://lulu.com/
* `make exercise_solutions.pdf` -- compile (some) solutions to exercises

## License

This work is licensed under the
[Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/](http://creativecommons.org/licenses/by-sa/3.0/).

