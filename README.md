# DITA-OT plugins for SVG Syntax diagrmas

_This code is provided as-is._ 

These plugins are based on Deborah Pickett's "HTML Plus" plugins, originally
published in the Yahoo dita-users group. The original plugins were written 
for a much older version of the toolkit (1.4 or 1.5) and needed fairly
substantial updating to be compatible with all of the changes since that time.
Version 1.0 under the releases tab was tested and worked with DITA-OT 2.5.
Version 2.0 is most recently tested with DITA-OT 3.3.4.

Additionally, the original plugins performed a number of functions related
to XHTML, using a multi-step "twopass" process. I've extracted the SVG processing
from that so that it can be used independently, with any transform type.
Plugins with unrelated functions are no longer included.
At the same time, I addressed a number of bugs in the original code, such as
the fact that group titles did not appear in the rendered diagrams, and
syntax notes were dropped when located in unexpected places.

The plugins distributed here are written as a post-process step to DITA-OT's
preprocess, so (unless turned off) they will run after preprocess for every
output format. Each diagram will be converted to one or more SVG files; the original
diagram markup is replaced with a reference to those diagrams. This should
work for any output format that supports SVG, though there could be issues
with height/width for some formats. For example, some extremely long 
diagrams can run off the page in PDF.

## Latest status

While I have managed to update the code with bug fixes made for my own customers,
these plugins are updated infrequently and should be considered as-is.

The following list includes changes I had hoped to make before uploading the
code in 2017, but was not able to find time for (and have not had time for
since):

1. The original plus plugins consisted of 45 distinct plugins. I've removed
those clearly unrelated to diagrams. I would be happier if the remaining
plugins were consolidated into one or two, rather than
the current 7 + the preprocess extension.
1. While removing unnecessary or obsolete code, I commented out a lot of sections.
The current code still has a lot of that commented code. Some of that was
cleaned out with version 2, but a lot remains.