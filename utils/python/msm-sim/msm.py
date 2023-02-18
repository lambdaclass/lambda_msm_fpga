from utils import split_scalars, Point, R, CLK, hazard
from simpy import core
from memory_module import mem
from point_adder import p_add
from scalars import scalars as s
from randpoints import points as rp
from collections import deque
from queue import Queue as q

class msm:
    def __init__(self, env : core.Environment, padd : p_add, memory : mem):
        ## Component instantiation
        self.env = env
        self.adder = padd
        self.memory = memory
        self.hazard_fifo : list[q[hazard]] = [ q(100) for _ in range(memory.windows) ]

        ## Measure values
        self.max_per_fifo = [0 for _ in range(memory.windows)]
        self.flushed = 0
        self.clocks_per_stage = [env.now for _ in range(2)]

    def __del__(self):
        pass
    
    # Stage 1 - Adding points into its respective buckets
    def bucket_aggregation(self, points : deque, scalars : deque):
        while len(points) != 0:
            if self.full_hazards():
                yield self.env.process(self.flush())

            p, sc = points.pop(), split_scalars(scalars.pop(), self.memory.windows, self.memory.buckets_per_window)
            p_ext = Point(p[0], p[1], 0x1)
            bcs = [] 
            for i in range(len(sc)):
                bcs.append(self.memory.read(i, sc[i]))

            yield self.env.timeout(CLK)

            for i in range(len(bcs)):
                if not self.adder.empty_FIFO():
                    print("Value on FIFO. Putting into bucket... - Time : ", self.env.now)
                    res = self.adder.outside_ADD.get()
                    self.memory.set(res[1], res[2], res[0])

                if bcs[i][1].IS_EMPTY:
                    print("Empty. Putting into bucket... - Time : ", self.env.now)
                    self.memory.set(i, sc[i], p_ext)

                elif not bcs[i][1].IS_BUSY:
                    print("Available for processing. Putting into PADD... - Time : ", self.env.now)
                    self.env.process(self.adder.process_point(p_ext, bcs[i][0], (i, sc[i])))
                    self.memory.set_busy(i, sc[i])

                else:
                    print("Busy. Putting into LP-FIFO... - Time : ", self.env.now, ". Size = ", self.hazard_fifo[i].qsize() + 1)
                    self.hazard_fifo[i].put(hazard(p, sc[i]))

                yield self.env.timeout(CLK)

        self.env.process(self.flush())
        self.env.process(self.wait_for_padd())

    # Stage 2 - Consistent sum of buckets per window
    def bucket_addition(self):
        pass

    # Stage 3 - Reconstruction of solution 
    def window_addition(self):
        pass

    def full_hazards(self):
        is_one_full = False

        for f in self.hazard_fifo:
            is_one_full |= f.full()

        return is_one_full

    def wait_for_padd(self):
        print("Waiting for PADD to finish")
        while True:
            print("Elements left - ", self.adder.processing)
            if self.adder.processing == 0 and self.adder.empty_FIFO():
                break

            if not self.adder.empty_FIFO():
                res = self.adder.outside_ADD.get()
                self.memory.set(res[1],res[2],res[0])

            yield self.env.timeout(CLK)

    def flush(self):
        print("Se ejecuta?")
        n = self.hazard_fifo[0].maxsize
        while n > 0:
            # (punto, bucket + estados, ventana ,posicion bucket)
            new_buckets = []
            for i in range(len(self.hazard_fifo)):
                if self.hazard_fifo[i].qsize() > 0:
                    t = self.hazard_fifo[i].get()
                    new_buckets.append( (t.point, self.memory.read(i, t.bucket_addr), i, t.bucket_addr ))
            yield self.env.timeout(CLK)

            for elem in new_buckets:
                if elem[1][1].IS_BUSY:
                    print("Back to FIFO")
                else:
                    print("Go to PADD")
                    self.env.process(self.adder.process_point(elem[0],elem[1][0], (elem[2], elem[3])))

                yield self.env.timeout(CLK)
        self.flushed += 1
        print("All fifos flushed")


    def execution(self):
        pass
