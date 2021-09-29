#!/bin/bash

PS4='$ '
set -x

# in case we're run from out of git repo
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$DIR" 1>/dev/null

# now change to the git root
ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

# only make if we should ($UPDATE_NIGHTLIES is not empty) and we're the same as origin/master
if [ -z "$UPDATE_NIGHTLIES" ]; then
    echo 'Not updating nightlies because $UPDATE_NIGHTLIES is not set'
    exit 0
fi

git reset --hard || exit 1

# only make if there are no errata to be updated
MARK_ERRATA_OUTPUT="$(./mark-errata; git diff HEAD)"
if [ ! -z "$MARK_ERRATA_OUTPUT" ]; then
    echo 'Not updating nightlies because the errata are not up to date'
    exit 0
fi

"$DIR"/add_upstream.sh || exit 1

git remote update || exit 1

SUPPORTS_UNSHALLOW="$(git fetch --help | grep -c -- '--unshallow')"
if [ "$SUPPORTS_UNSHALLOW" -eq 0 ]; then
    echo "Your git ($(git --version)) does not support the --unshallow option to fetch"
    git fetch --depth 1000000000 || exit 1
else
    git fetch --unshallow
fi

git fetch --tags || exit 1

echo "Building nightlies"
./build-nightlies | tee build-nightlies.log

PDFS="$(grep '^NIGHTLY: ' build-nightlies.log | sed s'/^NIGHTLY: //g')"
WIKIPAGE="$(grep '^NIGHTLY-WIKI: ' build-nightlies.log | sed s'/^NIGHTLY-WIKI: //g')"

"$DIR"/configure_commit.sh || exit 1
git remote -v
git branch -a
git --no-pager diff HEAD
git --no-pager diff HEAD..origin/master
git --no-pager diff HEAD..upstream/master

BAD_REMOTES="$(git remote -v | grep origin | grep -v 'github.com/HoTT/book')"
UPSTREAM_LOG="$(git log HEAD..upstream/master)"
#MASTER_LOG="$(git log HEAD..master)"
#ORIGIN_LOG="$(git log HEAD..origin/master)"

MASTER_COMMIT="$(git rev-parse HEAD)"

git checkout -b gh-pages upstream/gh-pages || exit 1

mkdir -p nightly

# Delete files in /nightly which are not referenced by the
# corresponding link on saunders
find nightly -type f | while read nfile
do
    SHORT_PDF=$(echo $nfile | grep -o '[^/]*\.pdf' | sed s'/-[0-9]*-[a-z0-9]*\.pdf/.pdf/g')
    REAL_URL="$(curl -Ls -w %{url_effective} -o /dev/null "saunders.phil.cmu.edu/book/${SHORT_PDF}")"
    if [ -z "${REAL_URL}" ]
    then
        echo "ERROR: Could not get a real URL for $nfile using the command:"
        echo "curl -Ls -w %{url_effective} -o /dev/null \"saunders.phil.cmu.edu/book/${SHORT_PDF}\""
        exit 1
    fi
    if ! (echo "${REAL_URL}" | grep -q "$nfile")
    then
	git rm -rf $nfile
    fi
done

git add -f $PDFS || exit 1

# The "git rm" commands above can cause the directory "nightly" itself
# to be deleted (unlike the raw "rm" command, which doesn't automatically
# remove empty directories). We restore this directory here so that the
# following git command has a chance of working.
mkdir -p nightly

git mv -f $PDFS nightly/ || exit 1

git commit -m "Update nightly builds (auto)" || exit 1
NIGHTLY_COMMIT="$(git rev-parse HEAD)"

git --no-pager diff HEAD
git --no-pager diff HEAD..origin/gh-pages
git --no-pager diff HEAD..upstream/gh-pages

git clone https://github.com/HoTT/book.wiki.git || exit 1

mv -f "$WIKIPAGE" book.wiki/ || exit 1

(cd book.wiki && git add "$WIKIPAGE" && git commit -m "Update nightly builds page (auto)") || exit 1

# check that we're in the right place, or that we have -f
if [ "$1" != "-f" ]; then
    if [ ! -z "$BAD_REMOTES" ]; then
	echo 'Not updating nightlies because there are remotes which are not HoTT/book:'
	echo "$BAD_REMOTES"
	exit 0
    fi

    # only make the nightlies if we're the same as upstream/master
    if [ ! -z "$UPSTREAM_LOG" ]; then
	echo "Not making nightlies beause we do not match with upstream/master; call '$0 -f' to force"
	exit 0
    fi

#    # only make the nightlies if we're the same as master
#    if [ ! -z "$MASTER_LOG" ]; then
#	echo "Not making nightlies beause we do not match with master; call '$0 -f' to force"
#	exit 0
#    fi
#
#    # only make the nightlies if we're the same as upstream/master
#    if [ ! -z "$ORIGIN_LOG" ]; then
#	echo "Not making nightlies beause we do not match with origin/master; call '$0 -f' to force"
#	exit 0
#    fi
fi

git reset --hard || exit 1

git checkout "$MASTER_COMMIT"

"$DIR"/checkout-and-cherry-pick-and-push.sh upstream/gh-pages "$NIGHTLY_COMMIT" gh-pages || exit 1

(cd book.wiki && git push origin HEAD:master) || exit 1

popd 1>/dev/null
