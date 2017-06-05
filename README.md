# DITA-OT plugins for SVG Syntax diagrmas

These plugins are based on Deborah Pickett's "HTML Plus" plugins, originally
published in the Yahoo dita-users group. The original plugins were written 
for a much older version of the toolkit (1.4 or 1.5) and needed fairly
substantial updating to be compatible with all of the changes since that time.
The latest updates have been tested with DITA-OT 2.5.

Additionally, the original plugins performed a number of functions related
to XHTML, using a multi-step "twopass" process. I've extracted the SVG processing
from that so that it can be used independently, with any transform type.
Plugins with unrelated functions are no longer included.
At the same time, I addressed a number of bugs in the original code; such as
the fact that group titles did not appear in the rendered diagrams.

The plugins distributed here are written as a post-process step to DITA-OT's
preprocess, so (unless turned off) they will run after preprocess for every
step. Each diagram will be converted to one or more SVG files; the original
diagram markup is replaced with a reference to those diagrams. This should
work for any output format that supports SVG, though there could be issues
with height/width for some formats. For example, some extremely long 
diagrams can run off the page in PDF.

## To do

I had hoped to clean these up before sharing, but it's been on my to-do list
for long enough that I think it's best to share these usable versions
even though they are not yet optimized. There are a number of items I
would like to clean up:

1. The original plus plugins consisted of many plugins. I've removed
those clearly unrelated to diagrams. I would be happier if the remaining
plugins were consolidated into one or two with clear purposes, rather than
the current 7 + batik + the preprocess extension. (The original download
from Yahoo includes 45 plugin directories.)
1. I had trouble with batik - it seemed to require this version, didn't
like the version we already ship as part of FOP. I didn't spend much
time diagnosing this and continued using the version Deborah bundled.
1. It would also be nice if we could just reference Batik rather than storing it.
1. While removing unnecessary or obsolete code, I commented out a lot of sections.
This means the current code still has a lot of code that no longer runs. That
code should be removed.
