from math import ceil
from simpy.core import Environment
from memory_module import mem

from msm_controller import msm_c
from point_adder import p_add
from utils import Point, splits_per_padds


class MSM():
    curve = "BLS12-377"
    coordinates = "Homogeneous projective coordinates"
    scalar_bits = 253

    number_of_elements = 0
    number_of_controllers = 0
    
    environment = Environment()

    memory = []
    controllers = []
    
    ## Nota: El disenio que estoy haciendo fragmenta la memoria en la cantidad de p_adds que pueda agregar en el disenio.
    ## Asi, estoy teniendo un problema con la numeracion de las ventanas. Si o si tengo que pasarle el rango de ventanas
    ## a cada controlador para que sepa con que escalares trabajar.

    def __init__(self, c, n_segments, n_elements, n_controllers):

        number_windows = ceil(self.scalar_bits / c)
        window_division = ceil(number_windows / n_controllers)
        print(number_windows, c, window_division)
        self.number_of_elements = n_elements
        self.number_of_controllers = n_controllers

        w = []
        i = 0
        while i + window_division < number_windows:
            w.append(window_division)
            i += window_division

        w.append(number_windows - i)

        ## Falta algo aca
        range_mem = splits_per_padds(n_controllers, c) 
        print(range_mem)
        print("Number of controllers ", n_controllers)
        for i in range(n_controllers):
            m = mem(w[i], c, n_segments)
            adder = p_add(self.environment)
            self.memory.append(m)
            
            ## I have to split the range of scalars for each controller 
            self.controllers.append(msm_c(self.environment, adder, m, 100, range_mem[i], number_windows))

    def run(self, q_points, q_scalars):
        if len(q_points) == 0 or len(q_scalars) == 0:
            print("Error - Scalars or points are not set")
            exit()

        print("===== Loop 1 - Bucket aggregation =====")
    
        for i in range(self.number_of_controllers):
            print("Queueing controller ", self.controllers[i])
            self.environment.process(self.controllers[i].bucket_aggregation(q_points, q_scalars))

        self.environment.run()

        print("Loop 1 finished in ", self.environment.now, " ticks")

## Note: If c is less than 12, then there're gonna be unused space, and more collitions are capable to appear. But if there's a good
##       heuristic in how to handle those points, then we could only use one memory block.

## This code block is well executed. I don't get why it doesn't work in the actual loop.
#        print("=== Filling and dumping g_mem ===")

#        for mem in self.memory:
#            for m in range(mem.segments):
#                for k in range(mem.windows):
#                    mem.set_g(k, m, Point(10,10,10))
#        
#        for m in self.memory:
#            print(m.g_mem)


#
        print("===== Loop 2 - Bucket addition =====")

        for i in range(self.number_of_controllers):
            print("Queueing for loop 1 - Controller ", self.controllers[i])
            self.environment.process(self.controllers[i].bucket_addition())

#        self.environment.run()
#
#        print(self.memory[0].sum_mem)
