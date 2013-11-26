#!/bin/bash

# in case we're run from out of git repo
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$DIR" 1>/dev/null

# now change to the git root
ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

# only make if we should ($UPDATE_ERRATA is not empty) and we're the same as origin/master
if [ -z "$UPDATE_ERRATA" ]; then
    echo 'Not updating errata because $UPDATE_ERRATA is not set'
    exit 0
fi

git reset --hard

"$DIR"/add_upstream.sh

git remote update

SUPPORTS_UNSHALLOW="$(git fetch --help | grep -c -- '--unshallow')"
if [ "$SUPPORTS_UNSHALLOW" -eq 0 ]; then
    echo "Your git ($(git --version)) does not support the --unshallow option to fetch"
    echo '$ git fetch --depth 1000000000'
    git fetch --depth 1000000000
else
    echo '$ git fetch --unshallow'
    git fetch --unshallow
fi

git fetch --tags

echo "Updating errata..."
echo '$ ./mark-errata'
./mark-errata

if [ -z "$(git diff HEAD)" ]; then
    exit 0
fi

"$DIR"/configure_commit.sh
echo '$ git --no-pager diff HEAD'
git --no-pager diff HEAD
echo '$ git --no-pager diff HEAD..origin/master'
git --no-pager diff HEAD..origin/master
echo '$ git --no-pager diff HEAD..upstream/master'
git --no-pager diff HEAD..upstream/master

BAD_REMOTES="$(git remote -v | grep origin | grep -v 'github.com/HoTT/book')"
UPSTREAM_LOG="$(git log HEAD..upstream/master)"

git commit -am "Mark Errata (auto)"

# check that we're in the right place, or that we have -f
if [ "$1" != "-f" ]; then
    if [ ! -z "$BAD_REMOTES" ]; then
	echo 'Not updating errata because there are remotes which are not HoTT/book:'
	echo "$BAD_REMOTES"
	exit 0
    fi

    git remote update
    # only make the errata if we're the same as upstream/master
    if [ ! -z "$UPSTREAM_LOG" ]; then
	echo "Not making errata beause we do not match with upstream/master; call '$0 -f' to force"
	exit 0
    fi
fi

git rebase origin master && "$DIR"/push_remote.sh HEAD:master

popd 1>/dev/null
