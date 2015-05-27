#===[ bits/smake.env ]=================================================
# smake.env: write shell functions to run make, capturing output.
#
# Sometimes it is handy to be able to conditionally capture the output
# of make. This rule generates a file, 'smake.env', that can be
# sourced into bash to define a function, 'smake', that captures
# stdout into 'smake.out' and stderr into 'smake.err'
#----------------------------------------------------------------------
NODEPS+=smake.env
smake.env: $(THIS)
	echo 'smake () {' > $@
	echo '    make "$$@" > >(tee smake.out) 2> >(tee smake.err >&2)' >> $@
	echo '}' >> $@

ifeq ($(USE_GLOBS),yes)
CT_FILES:=$(sort smake.* $(CT_FILES))
else
CT_FILES:=$(sort smake.out smake.err smake.env $(CT_FILES))
endif
#======================================================================
