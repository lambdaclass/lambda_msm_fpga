
## Variable declarations 

TOPLEVEL_LANG = vhdl
SIM = questa
ARCH = i686
COMPILE_ARGS += -2008
SIM_ARGS += -t ps
GUI=0

VHDL_SOURCES += ../../../utils/tipos.vhd \
				../../../utils/funciones.vhd \
				../../../config.vhd \
				../../../modules/mod_add/mod_add_comb.vhd

TOPLEVEL= mod_add_comb

MODULE := test_mod_add

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.sim

clear: clean
	rm -rf sim_build modelsim.ini transcript vish_stacktrace.vstf __pycache__ results.xml
