#!/usr/bin/env python

import sys
import re

words = {}
macros = set({})
antimacros = set({})
antifiles = ['symbols.tex',
             'macros.tex',
             'opt-letter.tex',
             'opt-ustrade.tex',
             'opt-color.tex',
             'hott-ustrade.tex',
             'hott-online.tex']

for fn in sys.argv[1:]:
    with open(fn, "r") as f:
        text = f.read()
    # Remove environment names
    text = re.sub(r'\\(begin|end){[^}]+}', ' ', text)
    # Remove all labels and refs
    text = re.sub(r'\\(label|cref|autoref|eqref|ref){[^}]+}', ' ', text)
    # Remove hyphenation hints
    text = re.sub(r'\\-', '', text)
    # Replace --- with space
    text = re.sub(r'---', ' ', text)
    # Replace punctuations with space
    text = re.sub(r'[,.;:?!]', ' ', text)
    # Find macros
    for m in re.findall(r"\\[a-zA-Z]+\b", text):
        if fn in antifiles:
            antimacros.add(m)
        else:
            macros.add(m)
    # Find words, try to include things like "$(n-2)$-connected"
    for w in re.findall(r"(\b(\$[^$]*\$-)?([a-zA-Z][a-zA-Z-]*)\b)", text):
        key = w[2].lower()
        if key in words:
            words[key].add(w[0])
        else:
            words[key] = set([w[0]])

#for key in sorted(words.keys()):
#    print (key, words[key])

for macro in sorted(macros - antimacros):
    print (macro)

