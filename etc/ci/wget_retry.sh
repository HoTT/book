#!/bin/sh

cd "$HOME"/.cache/latex

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
    echo "try $i"
    wget -N -t 1 "$@" && exit 0
done
