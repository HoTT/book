#!/usr/bin/sed -nf
/^\\newlabel{[:a-zA-Z0-9-]+}{{[0-9]\+\(\.[0-9]\+\)*}{[0-9]\+}{[^}]*}{[^}]*}{[^}]*}}$/ !b
# l{label}c{counter}p{page}
s/^\\newlabel{\([^}]*\)}{{\([^}]*\)}{\([^}]*\)}{[^}]*}{[^}]*}{[^}]*}}$/l{\1}c{\2}p{\3}/
# a loop to replace . in counter with _
:loop
/c{[^}]*\.[^}]*}/ !b loop-done
s/c{\([^}]*\)\.\([^}]*\)}/c{\1_\2}/
b loop
:loop-done
# generate the dictionary entry
s;l{\([^}]*\)}c{\([^}]*\)}p{\([^}]*\)};  '\1': {'counter': '\2', 'page': '\3'},;
p
