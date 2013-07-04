We are very happy to receive pull requests which fix typos,
formatting, and obvious mathematical errors; which clarify exposition
in a straightforward way; or which add new technical functionality
(such as versions for other devices).  We are not asking for new
mathematical content from the public at this time.

Please make sure that your pull request is attached to the correct
branch.  Changes which add new mathematics, or which alter the
numbering of existing sections, theorems, or equations, must wait for
the second edition.  Other changes, as long as they are not of
unreasonable size, can be released as updates to the first edition.
To ensure that your change does not alter existing numberings, you can
run "make labelcheck".

Corrections of mathematical typos and other errors, as well as changes
in exposition, should also be listed in the errata for the first
edition (errata.tex).  The first column in the errata table should be
the nearest surrounding numbered label, be it a section or theorem.
The second column is obtained by "git describe" on the commit where
you fixed the error.  The third column is a description of the change;
please be specific enough that someone looking at only a printed
version (which may have page breaks in different places) could easily
find its location.

We are very grateful everyone who is showing interest in our project,
and to anyone who helps us improve it!  However, in order to avoid any
misunderstanding later, we should mention upfront that your
contributions will only be recorded on github commit logs, but not in
the book itself (because the book is officially an IAS project).
