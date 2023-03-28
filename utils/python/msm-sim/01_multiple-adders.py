from random import randint
from msm import MSM
from msm_controller import msm_c
from simpy import core
from memory_module import mem
from point_adder import p_add
from scalars import scalars as s
from randpoints import points as rp
from collections import deque
from math import ceil

#muliscalar_multiplication = MSM()

#env = core.Environment()
#point_adder = p_add(env)
#memory = mem(22, 12, 2**4)
#
### Estaria bueno poner un for para generar multiples memorias de diferentes tamanios y de ahi 
#multiscalar = MSM(12, 4, len(rp), 1)

## Nota: El "maximo" c que puedo tomar es 12 pues 2**12 = 4096 y corresponde al espacio de direcciones de una ultraRAM
measurements = []

mp = deque(rp)
ms = deque()
    
for _ in range(len(mp)):
    ms.append(s[randint(0, 99999)])
        
print(MSM(12, 4, len(rp), 2).run(mp, ms))
