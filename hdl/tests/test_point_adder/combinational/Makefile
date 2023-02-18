TOPLEVEL_LANG = vhdl
SIM = questa
ARCH = i686
COMPILE_ARGS += -2008
SIM_ARGS += -t ps
GUI=0

VHDL_SOURCES += ../../../config.vhd \
            ../../../utils/tipos.vhd \
            ../../../utils/funciones.vhd \
            ../../../utils/delay_1.vhd \
            ../../../utils/delay_M.vhd \
            ../../../modules/kara_mul/kara_mul.vhd \
			../../../modules/mod_mul/mod_mul.vhd \
            ../../../modules/mod_mul/mod_mul_comb.vhd \
            ../../../modules/mod_add/mod_add_comb.vhd \
            ../../../modules/point_adder/point_adder_comb.vhd

TOPLEVEL= point_adder_comb

MODULE := test_point_adder_comb

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.sim

clear: clean
	rm -rf sim_build modelsim.ini transcript vish_stacktrace.vstf __pycache__ results.xml
