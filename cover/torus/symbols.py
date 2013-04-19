#!/usr/bin/env python

import subprocess
import os
import os.path

symbols = [
  r"$$\sum$$",
  r"$$\prod$$",
  r"$$\lambda$$",
  r"$$\times$$",
  r"$$\simeq$$"
]

ncols = 1

colors = [("gray", str(float(i)/ncols)) for i in range(0, ncols+1)]

## Generate LaTeX

template = r"""
\documentclass{article}
\usepackage{palatino}
\usepackage{amsmath,amssymb,amsfonts}
\usepackage{xcolor}
\pagestyle{empty}
\begin{document}
%s
\end{document}"""

tex = ""
for (i, s) in enumerate(symbols):
    for (j, (m,c)) in enumerate(colors):
        tex = tex + (r"\definecolor{mycolor}{%s}{%s}\textcolor{mycolor}{%s}\newpage" % (m, c, s)) + "\n"

# Write LaTeX to file

with open("temp.tex", "w") as f:
    f.write(template % tex)

# Process LaTeX and generate png files

subprocess.call(["latex", "temp.tex"])
subprocess.call(["dvipng", "-D", "1200", "-o", "preimg/image_%02d.png", "-T", "tight", "temp.dvi"])

# Convert png files to jpg

filelist = [f for f in os.listdir('preimg') if f.endswith(".png")]
for f in filelist:
    fin = os.path.join("preimg", f)
    fout = os.path.join("srcimg", os.path.splitext(f)[0] + ".jpg")
    subprocess.call(["convert", "-bordercolor", "white", "-border", "20x20", "-quality", "100", fin, fout])

# Remove auxiliary files

for f in filelist:
    os.remove(os.path.join("preimg", f))

for f in [f for f in os.listdir('.') if f.startswith("temp.")]:
    os.remove(f)
