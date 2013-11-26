#!/bin/bash

# in case we're run from out of git repo
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$DIR" 1>/dev/null

# now change to the git root
ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

echo "Configuring git for commit"
if [ -z "$(git config --global user.name)" ]; then
    git config --global user.name "Travis-CI Bot"
fi
if [ -z "$(git config --global user.email)" ]; then
    git config --global user.email "Travis-CI-Bot@travis.fake"
fi

popd 1>/dev/null
