from msm import msm
from simpy import core
from memory_module import mem
from point_adder import p_add
from scalars import scalars as s
from randpoints import points as rp
from collections import deque

env = core.Environment()
point_adder = p_add(env)
memory = mem(29, 9)


## Estaria bueno poner un for para generar multiples memorias de diferentes tamanios y de ahi 
multiscalar = msm(env, point_adder, memory)
mp = deque(rp)
ms = deque(s)

env.process(multiscalar.bucket_aggregation(mp, ms))
env.run()
