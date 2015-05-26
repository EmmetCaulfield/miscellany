define(`_CMV_', `CXX')dnl         compiler make variable
define(`_CVD_', `CXX=g++')dnl     compiler variable definition
define(`_FMV_', `CXXFLAGS')dnl    flags make variable
define(`_CLO_', `-std=c++11')dnl  compiler language options
define(`_SXT_', `.cpp')dnl        source code extension
define(`_HXT_', `.h')dnl          header extension
define(`_SGLOB_', `*.cpp')dnl     source file glob
define(`_HGLOB_', `*.h')dnl       header file glob
define(`_LDL_', `-lstdc++')dnl    default linker libs
define(`_AUX_MK_', `')dnl         Auxiliary make file to include
include(Template.mk)
