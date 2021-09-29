#!/bin/bash

PS4='$ '
set -x

# in case we're run from out of git repo
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$DIR" 1>/dev/null

# now change to the git root
ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

BASE_BRANCH="$1"
COMMIT_TO_CHERRY_PICK="$2"
REMOTE_BRANCH="$3"

MASTER_COMMIT="$(git rev-parse HEAD)"

git remote update || exit 1
git reset --hard || exit 1
git checkout "$BASE_BRANCH" || exit 1
git cherry-pick "$COMMIT_TO_CHERRY_PICK" || exit 1
COMMIT_TO_PUSH="$(git rev-parse HEAD)"
git checkout "$MASTER_COMMIT" || exit 1
"$DIR"/push_remote.sh "$COMMIT_TO_PUSH:$REMOTE_BRANCH" || exit 1
git checkout "$MASTER_COMMIT" || exit 1

popd 1>/dev/null
