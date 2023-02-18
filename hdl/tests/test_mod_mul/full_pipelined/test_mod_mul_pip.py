import random
import cocotb
import progressbar
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer
from cocotb.result import TestFailure
### Module under test

# entity mod_mul_pip is
#     port (
#         clk : in std_logic;
#         rst : in std_logic;
#         a   : in std_logic_vector(N-1 downto 0);
#         b   : in std_logic_vector(N-1 downto 0);
#         r   : out std_logic_vector(N-1 downto 0) 
#     );
#     constant DELAY : NATURAL := KARAMUL_DELAY_PER_LEVEL * KARAMUL_TREE_DEPTH;
# end entity;


@cocotb.coroutine
def reset(dut):
    """ TBI (for now module is combinational)
    """
    a = dut.a
    b = dut.b
    rst = dut.rst
    
    a.value = 0
    b.value = 0
    rst.value = 1
    
    yield Timer(1500, 'ns')
    yield RisingEdge(dut.clk)
    rst.value = 0
    yield RisingEdge(dut.clk)
    rst._log.info("Reset complete")

@cocotb.test()
def test_mod_mul(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    yield reset(dut)
    a = dut.a
    b = dut.b
    r = dut.r

    q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177
    testPass = True
    for _ in progressbar.progressbar(range(10000)):
        a.value = random.getrandbits(377) % q
        b.value = random.getrandbits(377) % q
        expected = (a.value * b.value) % q

        for _ in range(dut.DELAY.value):
            yield RisingEdge(dut.clk)

        if r.value.integer != expected:
                print(f'A    : {hex(a.value)}')
                print(f'B    : {hex(b.value)}')
                print(f'Result    : {hex(r.value.integer)}')
                print(f'Should be : {hex(expected)}')
                testPass = False

    assert testPass, "Differences found!"

