A Lovely Little Sed Script
==========================

This one is based on
[an answer I gave on StackOverflow](http://stackoverflow.com/questions/22308492/how-can-i-find-commands-that-will-show-all-instances-of-a-pattern-in-unix/22308579#22308579)
about how to extract the contents of HTML-like tags using only
[`sed`](http://www.gnu.org/software/sed/).

All it does is naively extract the content between a `<title>` start
tag and a `</title>` end tag, possibly spread over a number of lines.

This is such an adaptable little piece of `sed` that I've gone back to
_StackOverflow_ to find it a few times for one purpose or
another. Having revisited it so often, I decided it deserved a place
here.
