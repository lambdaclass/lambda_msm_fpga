TOPLEVEL_LANG = vhdl
SIM = ghdl

XPM:=../../../xpm
XPM_LIB:=$(XPM)/lib
CUSTOM_COMPILE_DEPS=xpm

VHDL_SOURCES += ../../config.vhd \
        ../../utils/tipos.vhd \
        ../../utils/funciones.vhd \
        ../../utils/delay_1.vhd \
        ../../utils/delay_M.vhd \
        ../../modules/point_adder/point_adder_dummy.vhd \
        ../../modules/fifo_bank/fifo_bank.vhd \
        ../../modules/bucket_mem/uram_dp_wf.vhd \
        ../../modules/bucket_mem/bucket_mem.vhd \
        ../../modules/controller/FSM/addr_selection.vhd \
        ../../modules/controller/FSM/FSM_w_counter.vhd \
        ../../modules/controller/FSM/counter_bank.vhd \
        ../../modules/controller/FSM/FSM_addition.vhd \
        ../../modules/controller/FSM/FSM_aggregator.vhd \
        ../../modules/controller/FSM/signal_selector.vhd \
        ../../modules/controller/FSM/controller.vhd \
        ../../modules/msm_top_level/arq_msm.vhd

TOPLEVEL=msm_architecture
# es importante que -frelaxed vaya después de --std !!
EXTRA_ARGS= --ieee=synopsys -P$(XPM_LIB) --warn-no-binding --std=08 -frelaxed-rules
SIM_ARGS= --wave=sim_build/msm_architecture.ghw


MODULE := test_top_msm

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.sim


GTK_SAVEFILE := $(wildcard sim_build/*.gtkw)

.PHONY: xpm
xpm:
	$(MAKE) -C $(XPM)

gtkwave:
	gtkwave sim_build/msm_architecture.ghw $(GTK_SAVEFILE) 

clear: clean
	$(MAKE) -C $(XPM) clean