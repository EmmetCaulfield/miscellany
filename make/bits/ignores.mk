#===[ bits/ignores.mk ]================================================
# ignores.lst: consolidate {RT,CT,MC,}_FILES and repository ignores.
#
# Consolidate *_FILES and .gitignore (if it exists) or svn:ignore
# property into ignores.lst, which can then be copied over .gitignore
# or set as the 'svn:ignore' property manually.
#
# We stop short of making the repo changes out of an abundance of caution.
# ----------------------------------------------------------------------
NODEPS+=ignores.lst
CT_FILES:=$(sort ignores.lst $(CT_FILES))
ignores.lst: $(THIS)
	echo "$(RT_FILES) $(CT_FILES) $(MC_FILES)" | tr ' ' '\n' > $@
	test -f .gitignore && sed 's/ //g' .gitignore >> $@
	-svn info >/dev/null 2>&1 && svn propget 'svn:ignore' | tr ' ' '\n' >> $@ 
	LC_ALL=C sort -u $@ | grep -v '^[[:space:]]*$$' > $@.tmp
	-grep -v '^*' $@.tmp > $@
	-grep -E '^\*([^.].*|\.[^[]{2,})$$' $@.tmp >> $@
	sed -n '/*\.[a-z]$$/{s/^\*\.//;H};$${g;/./{s/^/*.[/;s/$$/]/;s/\n//g;p}}' $@.tmp >> $@
	rm -f $@.tmp
#======================================================================
