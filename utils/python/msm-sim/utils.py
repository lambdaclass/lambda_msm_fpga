from dataclasses import dataclass

@dataclass
class Point:
    x: int
    y: int
    z: int

@dataclass
class status_w:
    IS_BUSY: bool
    IS_EMPTY: bool

@dataclass
class hazard:
    point : Point 
    bucket_addr : int 

## CONSTANTS
PADD_PIPELINE_DEPTH = 52
Q = 258664426012969094010652733694893533536393512754914660539884262666720468348340822774968888139573360124440321458177
R = 8444461749428370424248824938781546531375899335154063827935233455917409239041
CLK = 1

@dataclass
class Projective_Point:
    x: int
    y: int
    z: int

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
    for i in range(0, K):
        l.append(tmp % 2**K)
        tmp = tmp >> K
    return l

def split_scalars(scalar, K, c):
    tmp = format(scalar, '0'+str(K*c)+'b')
    l = []
    i = K*c - 1
    while i >= 0:
        tmpnum = ''
        for a in range(c):
            tmpnum = tmp[i] + tmpnum
            i -= 1
        l.append(int(tmpnum, 2))
    return l

