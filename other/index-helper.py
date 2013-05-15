#!/usr/bin/env python

import sys
import re
import frequency

max_occurrences = 1000

filter_re = sys.argv[1:] if len(sys.argv) > 1 else ['.*']

files = [
    "macros.tex",
    "front.tex",
    "preface.tex",
    "introduction.tex",
    "preliminaries.tex",
    "basics.tex",
    "logic.tex",
    "equivalences.tex",
    "induction.tex",
    "hits.tex",
    "hlevels.tex",
    "homotopy.tex",
    "categories.tex",
    "setmath.tex",
    "reals.tex",
    "formal.tex"
    ]


words = {}
macros = set({})
antimacros = set({})
antifiles = ['symbols.tex',
             'macros.tex',
             'opt-letter.tex',
             'opt-ustrade.tex',
             'opt-color.tex',
             'hott-ustrade.tex',
             'hott-letter.tex',
             'hott-online.tex']

for fn in files:
    with open(fn, "r") as f:
        text = f.read()
    # Remove environment names
    #text = re.sub(r'\\(begin|end){[^}]+}', ' ', text)
    # Remove all labels and refs
    #text = re.sub(r'(\\(label|cref|autoref|eqref|ref){[^}]+})', ' ', text)    
    # Remove hyphenation hints
    #text = re.sub(r'\\-', '', text)
    # Remove quotes
    #text = re.sub(r"['`]", ' ', text)
    # Replace --- with space
    #text = re.sub(r'---', ' ', text)
    # Replace punctuations with space
    #text = re.sub(r'[,.;:?!]', ' ', text)
    # Replace newlines with spaces
    #text = re.sub(r'\n', ' ', text)
    # Find macros
    for m in re.findall(r"\\[a-zA-Z]+\b", text):
        if fn in antifiles:
            antimacros.add(m)
        else:
            macros.add(m)
    # Delete macros
    #text = re.sub(r'\\[a-zA-Z]+\b', ' ', text)
    # Find words, try to include things like "$(n-2)$-connected"
    for m in re.finditer(r".{20}[^\\]\b(\$[^$]*\$-)?([a-zA-Z]([a-zA-Z-]|\\-)*)\b.{20}", text):
        key = str(m.group(2)).lower()
        key = re.sub(r'\\-', '', key) # remove hyphenation hints
        pos = m.start(2)
        excerpt = str(m.group(0))
        excerpt = re.sub(r'\n', ' ', excerpt) # replace newlines with spaces
        if key in words:
            words[key].append((excerpt, fn, pos))
        else:
            words[key] = [(excerpt, fn, pos)]

# Macros which appear somewhere but are not in the symbols index, macros.tex,
# or configuration files.
macros -= antimacros

# Uncomment to see the macros.
#for macro in sorted(macros - antimacros):
#    print (macro)

def sortkey(word):
    return (frequency.get_frequency(word), word)

def filter_word(w, fs):
    for r in fs:
        if re.search(r, w, flags = re.IGNORECASE): return True
    return False

for key in sorted(words.keys(), key = sortkey):
    if filter_word(key, filter_re):
        freq = frequency.get_frequency(key)
        print("\n\n======== %s [%d]\n\n" % (key, freq))
        for (excerpt, fn, pos) in words[key][:max_occurrences]:
            print ("   ...%s... [%s @ %d]" % (excerpt, fn, pos))
        if len(words[key]) > max_occurrences:
            print ("\n   [[%d omitted occurrences]]" % (len(words[key]) - max_occurrences))

