import random
import cocotb
import pprint
import progressbar

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
    x.value = 0
    y.value = 0
    op.value = 0
    yield Timer(100)


@cocotb.test()
def test_add(dut):
    yield reset(dut)
    x = dut.x
    y = dut.y
    op = dut.op
    yield reset(dut)
    op.value = 0 # suma
    result = dut.result
    q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177
    testPass = True
    for in1 in progressbar.progressbar(range(100)):
        for in2 in range(0, 100):
            
            x_v = random.randrange(0, q);
            y_v = random.randrange(0, q);

            expected = (x_v + y_v) % q
            x.value = x_v
            y.value = y_v
            yield Timer(10, 'ns')
            if result.value.integer != expected:
                print(f'A    : {hex(x.value)}')
                print(f'B    : {hex(y.value)}')
                print(f'Result    : {hex(result.value.integer)}')
                print(f'Should be : {hex(expected)}')
                testPass = False

    assert testPass, "Differences found!"

@cocotb.test()
def test_diff(dut):
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
            x_v = random.randrange(0, q);
            y_v = random.randrange(0, q);

            expected = (x_v - y_v) % q
            x.value = x_v
            y.value = y_v
            yield Timer(10, 'ns')
            if result.value.integer != expected:
                print(f'A    : {hex(x.value)}')
                print(f'B    : {hex(y.value)}')
                print(f'Result    : {hex(result.value.integer)}')
                print(f'Should be : {hex(expected)}')
                testPass = False

    assert testPass, "Differences found!"
