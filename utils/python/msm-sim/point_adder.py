import queue as q
from simpy import core
from utils import mod_add, mod_mul, mod_sub, Point, PADD_PIPELINE_DEPTH

class p_add:
    def __init__(self, env : core.Environment):
        ## Data
        self.env = env
        self.processing = 0
        self.outside_ADD = q.Queue()

    def __del__(self):
        print("Class destructor - Point adder")

    def process_point(self, point : Point, bucket : Point, addr):
        time_i = self.env.now
        self.processing += 1
        print("On pipeline :", self.processing)
        yield self.env.timeout(PADD_PIPELINE_DEPTH)
        self.processing -= 1
        print("Value processed. Initial time :", time_i, ", Final time :", self.env.now, ". On pipeline : ", self.processing)
        print("Points : ", point, bucket)
        self.outside_ADD.put( (self.add_point(point, bucket), addr[0], addr[1]) )

    def add_point(self, P : Point, Q : Point):
        ## P = (X1, Y1, Z1) ; Q = (X2, Y2, Z2)
        x1, y1, z1 = P.x, P.y, P.z
        x2, y2, z2 = Q.x, Q.y, Q.z
    
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
    
        return Point(x_res, y_res, z_res)

    def empty_FIFO(self):
        return self.outside_ADD.empty()
