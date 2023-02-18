TOPLEVEL_LANG = vhdl
SIM = questa
ARCH = i686
COMPILE_ARGS += -2008
SIM_ARGS += -t ps
GUI=0

VHDL_SOURCES += ../../../utils/tipos.vhd \
				../../../utils/funciones.vhd \
				../../../config.vhd \
				../../../utils/delay_1.vhd \
				../../../utils/delay_M.vhd \
				../../../modules/kara_mul/kara_mul.vhd \
				../../../modules/kara_mul/kara_mul_pip.vhd

TOPLEVEL=kara_mul_pip

MODULE := test_kara_mul_pip

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.sim

clear:
	rm -rf sim_build modelsim.ini transcript vish_stacktrace.vstf __pycache__
