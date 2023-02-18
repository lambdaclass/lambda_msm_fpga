import random
import progressbar
import cocotb
import pprint
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer
from cocotb.result import TestFailure

### Module under test

### entity mod_add is
###     port(x, y, op, result)
### end entity

@cocotb.coroutine
def reset(dut):
    """ TBI (for now module is combinational)
    """
    x = dut.x
    y = dut.y
    op = dut.op
    rst = dut.rst
    x.value = 0
    y.value = 0
    op.value = 0
    rst.value = 1
    yield Timer(1500, 'ns')
    yield RisingEdge(dut.clk)
    rst.value = 0
    yield RisingEdge(dut.clk)
    rst._log.info("Reset complete")

@cocotb.test()
def test_add(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())
    yield reset(dut)
    x = dut.x
    y = dut.y
    op = dut.op
    op.value = 0 # suma
    result = dut.result
    q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177
    testPass = True
    for in1 in progressbar.progressbar(range(100)):
        for in2 in range(0, 100):
            x.value = random.randrange(0, q)
            y.value = random.randrange(0, q)
            expected = (x.value + y.value) % q
            for _ in range(dut.DELAY.value):
                yield RisingEdge(dut.clk)

            if result.value.integer != expected:
                print(f'A    : {hex(x.value)}')
                print(f'B    : {hex(y.value)}')
                print(f'Result    : {hex(result.value.integer)}')
                print(f'Should be : {hex(expected)}')
                testPass = False

    assert testPass, "Differences found!"

@cocotb.test()
def test_diff(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())
    yield reset(dut)
    x = dut.x
    y = dut.y
    op = dut.op
    op.value = 1 # resta
    result = dut.result
    q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177
    testPass = True
    for in1 in progressbar.progressbar(range(100)):
        for in2 in range(0, 100):
            x.value = random.randrange(0, q);
            y.value = random.randrange(0, q);
            expected = (x.value - y.value) % q

            for _ in range(dut.DELAY.value):
                yield RisingEdge(dut.clk)

            if result.value.integer != expected:
                print(f'A    : {hex(x.value)}')
                print(f'B    : {hex(y.value)}')
                print(f'Result    : {hex(result.value.integer)}')
                print(f'Should be : {hex(expected)}')
                testPass = False

    assert testPass, "Differences found!"
