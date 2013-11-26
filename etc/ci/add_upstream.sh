#!/bin/bash

# in case we're run from out of git repo
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$DIR" 1>/dev/null

echo "Adding remote..."
git remote add upstream git://github.com/HoTT/book.git
git remote update

popd 1>/dev/null
