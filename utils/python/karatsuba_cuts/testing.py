from DSP import *
from values_050 import *
from values_127 import *
from values_256 import *
from values_317 import *
from values_377 import *

### Calculate the cuts for both the optimization and Karatsuba algorithm
fill()
LSB_dspCounter(377)
MSB_dspCounter(377)
KS_dspCounter(377)

### Least significant bits - Testing

#print("Least significant bits - 50 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if comparison_LSB(values_50[i]* values_50[j], ks_lsb(values_50[i],values_50[j],50), 50) == 1:
#            print("Error in values ", i, j)
#
#print("Least significant bits - 127 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if comparison_LSB(values_127[i]* values_127[j], ks_lsb(values_127[i],values_127[j],127), 127) == 1:
#            print("Error in values ", i, j)
#
#print("Least significant bits - 256 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if comparison_LSB(values_256[i]* values_256[j], ks_lsb(values_256[i],values_256[j],256), 256) == 1:
#            print("Error in values ", i, j)
#
#print("Least significant bits - 317 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if comparison_LSB(values_317[i]* values_317[j], ks_lsb(values_317[i],values_317[j],317), 317) == 1:
#            print("Error in values ", i, j)
#
print("Least significant bits - 377 bits")
for i in range(2000, 4000):
    for j in range(2000, 4000):
        if comparison_LSB(values_377[i]* values_377[j], ks_lsb(values_377[i],values_377[j],377), 377) == 1:
            print("Error in values ", i, j)

### Most significant bits - Testing

print("Most significant bits")

print("Comparacion para 50 bits")
for i in range(2000, 4000):
    for j in range(2000, 4000):
        if comparison_MSB(values_50[i]* values_50[j], ks_msb(values_50[i],values_50[j],50), 100, 50) == 1:
            print("Error in values ", i, j)

print("Comparacion para 127 bits")
for i in range(2000, 4000):
    for j in range(2000, 4000):
        if comparison_MSB(values_127[i]* values_127[j], ks_msb(values_127[i],values_127[j],127), 254, 127) == 1:
            print("Error in values ", i, j)

print("Comparacion para 256 bits")
for i in range(2000, 4000):
    for j in range(2000, 4000):
        if comparison_MSB(values_256[i]* values_256[j], ks_msb(values_256[i],values_256[j],256), 512, 256) == 1:
            print("Error in values ", i, j)

print("Comparacion para 317 bits")
for i in range(2000, 4000):
    for j in range(2000, 4000):
        if comparison_MSB(values_317[i]* values_317[j], ks_msb(values_317[i],values_317[j],317), 634, 317) == 1:
            print("Error in values ", i, j)

print("Comparacion para 377 bits")
for i in range(2000, 4000):
    for j in range(2000, 4000):
        if comparison_MSB(values_377[i]* values_377[j], ks_msb(values_377[i],values_377[j],377), 754,377) == 1:
            print("Error in values ", i, j)


#print("Karatsuba - Mix bits : 50 x 127 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if values_50[i]* values_127[j] != karatsuba(values_50[i],values_127[j]):
#            print("Error in values ", i, j)

#print("Karatsuba - Mix bits : 377 x 50 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if values_377[i]* values_50[j] != karatsuba(values_377[i],values_50[j]):
#            print("Error in values ", i, j)
#

#print("Karatsuba - 50 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if values_50[i]* values_50[j] != karatsuba(values_50[i],values_50[j]):
#            print("Error in values ", i, j)
#
#print("Karatsuba - 127 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if values_127[i]* values_127[j] != karatsuba(values_127[i],values_127[j]):
#            print("Error in values ", i, j)
#
#print("Karatsuba - 256 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if values_256[i]* values_256[j] != karatsuba(values_256[i],values_256[j]):
#            print("Error in values ", i, j)
#
#print("Karatsuba - 317 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if values_317[i]* values_317[j] != karatsuba(values_317[i],values_317[j]):
#            print("Error in values ", i, j)
#
#print("Karatsuba - 377 bits")
#for i in range(2000, 4000):
#    for j in range(2000, 4000):
#        if values_377[i]* values_377[j] != karatsuba(values_377[i],values_377[j]):
#            print("Error in values ", i, j)
#
