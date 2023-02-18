import random
import cocotb
import pprint
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer
from cocotb.result import TestFailure

### Module under test

### entity kara_mul is
###     generic(N, K, D, L)
###     port(clk, x, y, z)
### end entity

@cocotb.coroutine
def reset(dut):
    """ TBI (for now module is combinational)
    """
    x = dut.x
    y = dut.y

    x.value = 0
    y.value = 0

    #dut.rst <= 1
    yield Timer(1500, 'ns')
    #yield RisingEdge(dut.clk)
    #dut.rst <= 0
    #yield RisingEdge(dut.clk)
    #dut.rst._log.info("Reset complete")

@cocotb.test()
def test_ks_comb(dut):
    yield reset(dut)
    x = dut.x
    y = dut.y

    z = dut.z

    testPass = True
    for in1 in range(0, 1000):
        for in2 in range(0, 1000):
            x.value = random.getrandbits(377)
            y.value = random.getrandbits(377)
            yield Timer(1000)
            expected = x.value * y.value
            if z.value.integer != expected:
                print(f'A    : {hex(x.value)}')
                print(f'B    : {hex(y.value)}')
                print(f'Result    : {hex(z.value.integer)}')
                print(f'Should be : {hex(expected)}')
                testPass = False

    assert testPass, "Differences found!"
