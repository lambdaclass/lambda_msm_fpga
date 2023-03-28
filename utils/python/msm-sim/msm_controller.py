from utils import PADD_PIPELINE_DEPTH, mem_location, split_scalars, Point, CLK, hazard, aggregation
from simpy import core
from memory_module import mem
from point_adder import p_add
from collections import deque
from queue import Queue
from math import log2

class msm_c:
    def __init__(self, env : core.Environment, padd : p_add, memory : mem, hazard_size, window_range, gen_window):
        ## Component instantiation
        self.env = env
        self.adder = padd
        self.memory = memory
        self.hazard_fifo = [ Queue(hazard_size) for _ in range(memory.windows) ]
        self.hazard_size = hazard_size

        self.window_range_from = window_range[0]
        self.window_range_to   = window_range[1] 
        self.general_window = gen_window

        ## Control flags (Input points, hazard_fifos, point_adder)
        self.state_flag = aggregation.INPUT_POINTS
        self.state_flag_l2 = False

        ## Measurement values
        self.max_per_fifo = [0 for _ in range(memory.windows)]
        self.flushed = 0
        self.clocks_per_stage = [env.now for _ in range(2)]

    def __del__(self):
        print("Class destructor - MSM")
    
    # Stage 1 - Adding points into its respective buckets
    def bucket_aggregation(self, points : deque, scalars : deque):
        while not self.state_flag == aggregation.END:
            if len(points) == 0:
                self.state_flag = aggregation.FIFO_POINTS

            match self.state_flag:
                case aggregation.INPUT_POINTS:

                    if self.full_hazards():
                        yield self.env.process(self.flush())

                    p, sc = points.pop(), split_scalars(scalars.pop(), self.general_window, self.memory.buckets_per_window)
                    
                    p_ext = Point(p[0], p[1], 0x1)

                    ## Aca deberia extraer los escalares que me van a servir...

                    range_sc = []
                    for i in range(self.window_range_from, self.window_range_to + 1):
                        range_sc.append(sc[i])

                    bcs = [] 
                    for i in range(len(range_sc)):
                        bcs.append(self.memory.read(i, range_sc[i]))

                    yield self.env.timeout(CLK)

                    for i in range(len(range_sc)):
                        if range_sc[i] == 0:
                            yield self.env.timeout(CLK)
                            continue
                        if not self.adder.empty_FIFO():
                            print("Value on FIFO. Putting into bucket... - Time : ", self.env.now)
                            res = self.adder.outside_ADD.get()
                            ## point, window, bucket
                            self.memory.set(res[0], res[1], res[2])

                        if bcs[i][1].IS_EMPTY:
                            print("Empty. Putting into bucket... - Time : ", self.env.now)
                            self.memory.set(p_ext, i, range_sc[i])

                        elif not bcs[i][1].IS_BUSY:
                            print("Available for processing. Putting into PADD... - Time : ", self.env.now)
                            self.env.process(self.adder.process_point(3, i, range_sc[i], p_ext, bcs[i][0]))
                            self.memory.set_busy(i, range_sc[i])

                        else:
                            h = hazard(p_ext, range_sc[i])
                            self.hazard_fifo[i].put(h)
                            print("Busy. Putting into LP-FIFO... - Time : ", self.env.now, ". Size = ", self.hazard_fifo[i].qsize())

                        yield self.env.timeout(CLK)

                case aggregation.FIFO_POINTS:
                    self.env.process(self.flush())
                    yield self.env.process(self.wait_for_padd())
                    self.state_flag = aggregation.END


    # Stage 2 - Consistent sum of buckets per window
    def bucket_addition(self):
        self.env.process(self.fifos_analyzer())

        gs  = [Point(0, 0, 0) for _ in range(self.memory.windows)]
        ss  = [Point(0, 0, 0) for _ in range(self.memory.windows)]
        bcs  = [Point(0, 0, 0) for _ in range(self.memory.windows)]

        for u in range(self.memory.size_seg):
            for m in range(self.memory.segments):
                addr = self.memory.addr_calc(u, m)

                ## Me traigo los gs en un clock
                for k in range(self.memory.windows):
                    gs[k] = self.memory.read_g(k, m)

                yield self.env.timeout(CLK)

                ## Me traigo los ss en un clock
                for k in range(self.memory.windows):
                    ss[k] = self.memory.read_sum(k, m)

                yield self.env.timeout(CLK)

                for k in range(self.memory.windows):
                    bcs[k] = self.memory.read(k, addr)[0]
                    ## El primer i del proximo for me contabiliza las dos operaciones paralelas

                for i in range(len(gs)):
                    print("Processing point from gs into g")
                    self.env.process(self.adder.process_point(mem_location.g, i, m, gs[i], ss[i]))
                    yield self.env.timeout(CLK)

                for i in range(len(ss)):
                    print("Processing point from ss into sum")
                    self.env.process(self.adder.process_point(mem_location.sum,i, m, ss[i], bcs[i]))
                    yield self.env.timeout(CLK)

        yield self.env.timeout(CLK)
        self.state_flag_l2 = True

#        s = [(Point(0, 0, 0), status_w(False, False)) for _ in range(self.memory.windows)]
#        skm = [[(Point(0, 0, 0), status_w(False, False)) for _ in range(self.memory.segments)] for _ in range(self.memory.windows) ]
#
#        for m in range(self.memory.segments - 1):
#            for k in range(self.memory.windows):
#                skm[k][m] = self.memory.read_sum(k, m + 1)
#            
#            yield self.env.timeout(CLK)
#
#            for k in range(self.memory.windows):
#                if m == 0:
#                    s[k] = skm[k][0]
#                else:
#                    self.env.process(self.adder.process_point(4, k, 0, skm[k][m][0], skm[k][m - 1][0]))
#
#                yield self.env.timeout(CLK)
#
#            yield self.env.timeout(PADD_PIPELINE_DEPTH - self.memory.windows - 1)
#
#        
#        for _ in range(int(log2(self.memory.size_seg))):
#            for k in range(len(s)):
#                ### Yoooo, this is wrong.
#                self.env.process(self.adder.process_point(4, k, 0, s[k][0], s[k][0]))
#                yield self.env.timeout(CLK)
#            
#            ## Este calculo esta mal
#            yield self.env.timeout(PADD_PIPELINE_DEPTH - self.memory.windows - 1)
#
#        gk = [(Point(0, 0, 0), status_w(False, False)) for _ in range(self.memory.windows)]
##        for m in range(self.memory.segments - 1):
##            gkm = []
##            for k in range(self.memory.windows):
##                gk.append(self.memory.read_aggregator(k, m))
##
##            yield self.env.timeout(CLK)
##            for k in range(self.memory.windows):
##                if m == 0:
##                    gk[k] = gkm[k][0]
##                else:
##                    self.env.process(self.adder.process_point(k, 0, gkm[k][m], gk[k]))
##
##                yield self.env.timeout(CLK)
##                 
#        for k in range(self.memory.windows):
#            self.env.process(self.adder.process_point(4, k, 0, gk[k][0], s[k][0]))
#            yield self.env.timeout(CLK)


    # Stage 3 - Reconstruction of solution 
    def window_addition(self):
        pass

    def fifos_analyzer(self):
        while not self.state_flag_l2:
            print("Al menos entra a aca?")
            if not self.adder.outside_ADD.empty():
                v = self.adder.outside_ADD.get()
                print("Point processed : Result = ", v[0])
                match v[3]:
                    case mem_location.g:
                        print("Point ready. Putting into aggregator memory...")
                        self.memory.set_g(v[0], v[1], v[2])
                    case mem_location.sum:
                        print("Point ready. Putting into summation memory...")
                        self.memory.set_sum(v[0], v[1], v[2])
                yield self.env.timeout(CLK)
            else:
                yield self.env.timeout(CLK)

    def full_hazards(self):
        is_one_full = False
        for f in self.hazard_fifo:
            is_one_full |= f.full()

        print("Is it full? ", is_one_full)
        return is_one_full

    def wait_for_padd(self):
        print("Waiting for PADD to finish")
        while True:
            print("Elements left - ", self.adder.processing)
            if self.adder.processing == 0 and self.adder.empty_FIFO():
                break

            if not self.adder.empty_FIFO():
                res = self.adder.outside_ADD.get()
                self.memory.set(res[0],res[1],res[2])

            yield self.env.timeout(CLK)

    def flush(self):
        print("Flushing...")
        n = self.hazard_size

        while n > 0:
            processing = []
            for i in range(len(self.hazard_fifo)):
                if self.hazard_fifo[i].qsize() > 0:
                    tmp : hazard = self.hazard_fifo[i].get()
                    processing.append((tmp.point, self.memory.read(i, tmp.bucket), (i,tmp.bucket)))

            yield self.env.timeout(CLK)
            
            for r in processing:
                if r[1][1].IS_BUSY:
                    print("Return to FIFO")
                    self.hazard_fifo[r[2][0]].put(hazard(r[0], r[2][1]))
                else:
                    print("From FIFO to PADD")
                    self.env.process(self.adder.process_point(0, r[2][0], r[2][1] ,r[0], r[1][0]))

                yield self.env.timeout(CLK)

            n -= 1

        self.flushed += 1
        print("All fifos flushed")
