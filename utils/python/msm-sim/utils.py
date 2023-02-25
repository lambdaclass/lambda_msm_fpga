from dataclasses import dataclass
from enum import Enum
from math import ceil

class mem_location(Enum):
    default = 0
    g = 1
    sum = 2

class loop(Enum):
    LOOP_1 = 1
    LOOP_2 = 2
    LOOP_3 = 3

class aggregation(Enum):
    INPUT_POINTS = 1
    FIFO_POINTS = 2
    END = 3

@dataclass
class Point:
    x: int
    y: int
    z: int

@dataclass
class hazard:
    point: Point 
    bucket: int

@dataclass
class status_w:
    IS_BUSY: bool
    IS_EMPTY: bool

@dataclass
class bucket_address:
    c: int
    k: int

## CONSTANTS
PADD_PIPELINE_DEPTH = 52
Q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177
R = 8444461749428370424248824938781546531375899335154063827935233455917409239041
CLK = 1

## Auxiliary operations for point adder
def mod_add(a, b):
    return (a + b) % Q
    
def mod_sub(a, b):
    return (a - b) % Q
    
def mod_mul(a, b):
    return (a * b) % Q

def split(s, K):
    tmp = s
    l = []
    for _ in range(0, K):
        l.append(tmp % 2**K)
        tmp = tmp >> K
    return l

def splits_per_padds(n_padds, c):
    windows = ceil(253/ c)

    sc = []

    n_scalars = ceil(windows/n_padds)

    i = 0
    while i + n_scalars < windows:
        sc.append((i, i + n_scalars - 1))
        i += n_scalars

    sc.append((i, windows - 1))
    return sc

def split_scalars(scalar, K, c):
    tmp = format(scalar, '0'+str(K*c)+'b')
    l = []
    i = K*c - 1
    while i >= 0:
        tmpnum = ''
        for _ in range(c):
            tmpnum = tmp[i] + tmpnum
            i -= 1
        l.append(int(tmpnum, 2))
    return l

