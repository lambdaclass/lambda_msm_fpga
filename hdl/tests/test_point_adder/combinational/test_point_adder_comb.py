import cocotb
import progressbar
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer
from cocotb.result import TestFailure
from points import *
from res import *

q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177

@cocotb.coroutine
def reset(dut):
    """ TBI (for now module is combinational)
    """
    dut.y1.value = 0
    dut.z1.value = 0 
    dut.x1.value = 0

    dut.x2.value = 0
    dut.y2.value = 0
    dut.z2.value = 0

    #dut.rst.value = 1
    yield Timer(1500, 'ns')
    #yield RisingEdge(dut.clk)
    #dut.rst.value = 0
    #yield RisingEdge(dut.clk)
    #dut.rst._log.info("Reset complete")

@cocotb.test()
def test(dut):
    
    yield reset(dut)

    y1 = dut.y1
    z1 = dut.z1 
    x1 = dut.x1

    x2 = dut.x2
    y2 = dut.y2
    z2 = dut.z2

    xr = dut.xr
    yr = dut.yr
    zr = dut.zr

    #cocotb.fork(Clock(dut.clk, 10, units='ns').start())

    #for _ in range(5):
    #    yield RisingEdge(dut.clk)
    
    testPass = True
    errors = 0
    r = 0

    for p in progressbar.progressbar(range(0,500,2)):
        P1 = points[p]
        P2 = points[p+1]

        x1.value = P1[0]
        y1.value = P1[1]
        z1.value = 0x1

        x2.value = P2[0]
        y2.value = P2[1]
        z2.value = 0x1

        r = p // 2
        
        # py_result = point_adder(P1,P2)
        # if py_result != results[r]:
        #     print(f'results[r]    : {hex(results[r][0]), hex(results[r][1]), hex(results[r][2])}')
        #     print(f'point_adder(P1,P2)   : {hex(py_result[0]), hex(py_result[1]), hex(py_result[2])}')
        #     testPass = False

        yield Timer(10, 'ns')
            
        result = (xr.value.integer, yr.value.integer, zr.value.integer)
        expected = results[r]
        if result != expected:
                print(f'Result module    : {hex(result[0]), hex(result[1]), hex(result[2])}')
                print(f'Expected value   : {hex(expected[0]), hex(expected[1]), hex(expected[2])}')
                testPass = False

        
    assert testPass, "Differences found!"
    

def mod_add(a, b):
    return (a + b) % q

def mod_sub(a, b):
    return (a - b) % q

def mod_mul(a, b):
    return (a * b) % q

def point_adder(P, Q):
    ## P = (X1, Y1, Z1) ; Q = (X2, Y2, Z2)
    x1, y1 = P
    x2, y2 = Q
    z1 = 1
    z2 = 1
    ## Layer 01
    mul1 = mod_mul(x1, x2)
    mul2 = mod_mul(y1, y2)
    mul3 = mod_mul(z1, z2)

    add1 = mod_add(x1, y1)
    add2 = mod_add(x2, y2)
    add3 = mod_add(x1, z1)
    add4 = mod_add(x2, z2)
    add5 = mod_add(y1, z1)
    add6 = mod_add(y2, z2)

    ## Layer 02
    add7 = mod_add(mul1, mul2)
    add8 = mod_add(mul1, mul3)
    add9 = mod_add(mul2, mul3)
    mul4 = mod_mul(add1, add2)
    mul5 = mod_mul(add3, add4)
    mul6 = mod_mul(add5, add6)

    ## Layer 03
    prod1 = mod_mul(3, mul3)
    sub1 = mod_sub(mul4, add7)
    sub2 = mod_sub(mul5, add8)
    sub3 = mod_sub(mul6, add9)
    
    ## Layer 04
    prod2 = mod_mul(3, mul1)
    add10 = mod_add(mul2, prod1)
    sub4 = mod_sub(mul2, prod1)
    prod3 = mod_mul(3, sub2)

    ## Layer 05
    finmul1 = mod_mul(sub4,sub1)
    finmul2 = mod_mul(prod3, sub3)
    finmul3 = mod_mul(add10, sub4)
    finmul4 = mod_mul(prod2, prod3)
    finmul5 = mod_mul(add10, sub3)
    finmul6 = mod_mul(sub1, prod2)


    ## Layer 06
    x_res = mod_sub(finmul1, finmul2)
    y_res = mod_add(finmul3, finmul4)
    z_res = mod_add(finmul5, finmul6)

    return (x_res, y_res, z_res)
