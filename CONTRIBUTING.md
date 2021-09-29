We are very happy to receive suggestions which fix typos, formatting,
and obvious mathematical errors; which clarify exposition in a
straightforward way; or which add new technical functionality (such as
versions for other devices).  We are not asking for new mathematical
content from the public at this time.

We are very grateful to everyone who is showing interest in our project,
and to anyone who helps us improve it!  However, in order to avoid any
misunderstanding later, we should mention upfront that your
contributions will only be recorded on github commit logs, but not in
the book itself (because the book is officially an IAS project).

Note that the version of the book you are working from (including the
version posted on the public web site) may not be the most recent one.
If you've found an error and want to check whether it has already been
corrected in the most recent version, you may need to clone the git
repository and compile the sources yourself, or else look at the
source code on github.

If you only want to point out the existence of an error or make a
general suggestion, you can open an issue on the github project.  The
authors will (eventually) respond and either implement a fix or decide
that no fix is necessary.  If you would like to fix an error yourself
or suggest a specific concrete change, you can fork the github
project, commit the change in a branch on your fork, and open a pull
request to the parent project.

Please make sure that your pull request is attached to the correct
branch.  Changes which add new mathematics, or which alter the
numbering of existing sections, theorems, or equations, must wait for
the second edition.  Other changes, as long as they are not of
unreasonable size, can be released as updates to the first edition.
To ensure that your change does not alter existing numberings, you can
run "make labelcheck".

Corrections of mathematical typos and other errors, as well as changes
in exposition, should also be listed in the errata for the first
edition (`errata.tex`).

- The first column in the errata table should be the nearest
  surrounding numbered label, be it a section, theorem, or exercise.

- The second column is obtained by running `git describe` on the
  commit where the fix was merged into the master branch.  You don't
  know this when writing your fix, of course, so the correct thing to
  put here is a comment of the form

      % merge of 1234567
  
  where `1234567` is the commit hash in which you made the fix.  (This
  necessitates making two commits, one to make the fix and one to
  record the erratum.)  Please use _exactly_ this syntax so that it can
  be automatically updated by the errata-marking script.

- The third column is a description of the change.  Please be specific
  enough that someone looking at only a printed version (which may
  have page breaks in different places) could easily find its
  location.

It is generally a good idea not to submit github pull requests from
your master branch.  This is because whatever branch you submit a pull
request from, any new commits on that branch that happen before the
pull request is merged get added to the pull request.  Thus, if you
submit pull requests from your master branch, you cannot have multiple
unrelated pull requests open at once, or do unrelated work on your
master branch before your pull request is merged.  To create a special
branch for your pull request, run

    git checkout -b BRANCHNAME

Make your commits in that branch, then run

    git push origin BRANCHNAME:BRANCHNAME

assuming that your git remote `origin` is set up to be your github
fork (rather than the main `HoTT/book` repository).  The main page of
your github fork should then have a little prompt asking you whether
you want to issue a pull request from your most recently pushed
branch.
