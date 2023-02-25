from msm_controller import msm_c
from simpy import core
from memory_module import mem
from point_adder import p_add
from scalars import scalars as s
from randpoints import points as rp
from collections import deque
from math import ceil
from random import randint

#muliscalar_multiplication = MSM()

env = core.Environment()
point_adder = p_add(env)
memory = mem(22, 12, 2**4)

## Estaria bueno poner un for para generar multiples memorias de diferentes tamanios y de ahi 
multiscalar = msm_c(env, point_adder, memory, 5,(0, 21), 22)
mp = deque(rp)
ms = deque()

for _ in range(len(mp)):
    ms.append(s[randint(0, 99999)])
    
env.process(multiscalar.bucket_aggregation(mp, ms))
env.run()

