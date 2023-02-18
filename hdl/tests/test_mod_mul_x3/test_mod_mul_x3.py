import cocotb
import progressbar
import random
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer
from cocotb.result import TestFailure

# entity mod_mul_x3 is
#     port (
#         clk : in std_logic;
#         rst : in std_logic;
        
#         x : in std_logic_vector (N-1 downto 0);
#         r : out std_logic_vector(N-1 downto 0)
#     );
#end entity;
class Data:

    def __init__(self):
        self.inputs = []
        self.expected = []
        self.outputs = []


async def reset(dut):
    dut.x.value = 0

    rst = dut.rst
    rst.value = 1
    await Timer(1500, 'ns')
    await RisingEdge(dut.clk)
    rst.value = 0
    await RisingEdge(dut.clk)
    cocotb.log.info("Reset complete")

@cocotb.test()
async def test(dut):
    
    data = Data()
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())
    await reset(dut)

    total = 10000
    
    coro_inputs = cocotb.start_soon(inputs(dut, total, data))
    coro_outputs = cocotb.start_soon(outputs(dut, total, data))

    await coro_inputs
    cocotb.log.info("inputs collected")
    await coro_outputs
    cocotb.log.info("outputs collected")

    testPass = True

    #check

    for i in range(total):
        if data.outputs[i] != data.expected[i]:
            print(f'x    : {hex(data.inputs[i])}')
            print(f'Result    : {hex(data.outputs[i])}')
            print(f'Should be : {hex(data.expected[i])}')
            testPass = False

    assert testPass, "Differences found!"

async def inputs(dut, total, data):
    q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177

    for _ in progressbar.progressbar(range(total)):
        x_v = random.randrange(0, q)
        data.inputs.append(x_v)
        data.expected.append((x_v*3) % q)
        dut.x.value = x_v
        await RisingEdge(dut.clk)

async def outputs(dut, total, data):

    for _ in range(2):
        await RisingEdge(dut.clk)

    for _ in range(total):
        await Timer(1, 'ps')        
        data.outputs.append(dut.r.value.integer)
        await RisingEdge(dut.clk)
