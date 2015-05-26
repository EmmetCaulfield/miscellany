define(`_CMV_', `CC')dnl        Compiler make variable
define(`_CVD_', `CC=gcc')dnl    Compiler variable definition
define(`_FMV_', `CFLAGS')dnl    Flags make variable
define(`_CLO_', `-std=c11')dnl  Compiler language options
define(`_SXT_', `.c')dnl        Source code extension
define(`_HXT_', `.h')dnl        Header extension
define(`_SGLOB_', `*.c')dnl     source file glob
define(`_HGLOB_', `*.h')dnl     header file glob
define(`_LDL_', `')dnl          Default linker libs
define(`_AUX_MK_', `')dnl       Auxiliary make file to include
include(Template.mk)
