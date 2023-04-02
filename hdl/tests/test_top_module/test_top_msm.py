import random
import cocotb
import pprint
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer
from cocotb.result import TestFailure
#from points import *
#from scalar import *

### Module under test

### entity top_level is
###     port(x, y, scalar, CLK, RST)
### end entity

@cocotb.coroutine
def reset(dut):
    """
    Inputs: 
    Point: x and y
    Scalar: e
    Signals: rst and clk
     
    """
    G_x = dut.G_x
    G_y = dut.G_y
    x_n = dut.x_n
    fifo_input_we = dut.fifo_input_we
    rst = dut.rst
    G_x.value = 0
    G_y.value = 0
    x_n.value = 0
    fifo_input_we.value = 0
    rst.value = 1
    yield Timer(1500, 'ns')
    yield RisingEdge(dut.clk)
    rst.value = 0
    yield RisingEdge(dut.clk)
    rst._log.info("Reset complete")

@cocotb.test()
def test_input_values(dut):
    cocotb.start_soon(Clock(dut.clk, 5, units='ns').start())
    yield reset(dut)
    G_x = dut.G_x
    G_y = dut.G_y
    x_n = dut.x_n
    fifo_input_we = dut.fifo_input_we
    
    #make the test
            
            
   