### Sets of optimal DSPs for an instance of size i.
dsp_ks   = [100000000] * 500
dsp_lsb  = [100000000] * 500
dsp_msb  = [100000000] * 500

### Sets of optimal cuts for each problem.
cuts_ks  = {}
cuts_lsb = {}
cuts_msb = {}

def fill():
    for k in range(0, 18):
        cuts_lsb[k] = 0
        cuts_msb[k] = 0

### DSP Counters

def LSB_dspCounter(bits : int):
    if bits <= 18:
        dsp_lsb[bits] = 1 
        return 1
    elif dsp_lsb[bits] != 100000000:
        return dsp_lsb[bits]
    else:
        for i in range(1, bits):
            recursiveCall = 2*LSB_dspCounter(bits - i) + KS_dspCounter(i)
            if 2*i >= bits + 2:
                if recursiveCall < dsp_lsb[bits]:
                    dsp_lsb[bits] = recursiveCall
                    cuts_lsb[bits] = i
    return dsp_lsb[bits]

def MSB_dspCounter(k : int):
    if k <= 18:
        dsp_msb[k] = 1
        return 1
    elif dsp_msb[k] != 100000000:
        return dsp_msb[k]
    else:
        for i in range(1, k):
            recursiveCall = 2*MSB_dspCounter(i) + KS_dspCounter(k - i)
            if 2*i <= k - 2:
                if recursiveCall < dsp_msb[k]:
                    dsp_msb[k] = recursiveCall
                    cuts_msb[k] = i
    return dsp_msb[k]

def KS_dspCounter(k : int):
    if k <= 18:
        return 1
    elif dsp_ks[k] != 100000000:
        return dsp_ks[k]
    else:
        for i in range(2, k):
            recursiveCall = KS_dspCounter(k - i) + KS_dspCounter(max(i, k - i) + 1) + KS_dspCounter(i)
            if recursiveCall < dsp_ks[k]:
                dsp_ks[k] = recursiveCall
                cuts_ks[k] = i
    return dsp_ks[k]

### Operand splitter

def split_at(n, k):
    if len(str(bin(n))[2:]) <= k or k == 0:
        return 0, n
    value     = str(bin(n))[2:]
    highValue = value[0:len(value) - k]
    lowValue  = value[len(value) - k:]
    return int(highValue, 2), int(lowValue, 2)

### Computations

def karatsuba(x_operand : int, y_operand : int):
    if x_operand.bit_length() <= 18 or y_operand.bit_length() <= 18:
        return x_operand * y_operand
    else:
        cut = cuts_ks[max(x_operand, y_operand).bit_length()]
        high_x, low_x = split_at(x_operand, cut)
        high_y, low_y = split_at(y_operand, cut)
        high_part = karatsuba(high_x, high_y)
        low_part = karatsuba(low_x, low_y)
        mid_part = karatsuba(high_x + low_x, high_y + low_y) - low_part - high_part

        return 2**(2*cut) * high_part + 2**cut * mid_part + low_part
    
def ks_lsb(a: int, b: int, bits : int):
    if bits <= 18:
        if karatsuba(a,b) != a*b:
            print("Karatsuba = ", karatsuba(a,b), "| Normal :", a*b)
        return a * b
    else:
        cut = cuts_lsb[bits]

        high_x, low_x = split_at(a, cut)
        high_y, low_y = split_at(b, cut)

        low_part =  karatsuba(low_x, low_y)                ##Z3
        high_part_a =  ks_lsb(low_x, high_y, bits - cut)            ##Z1
        high_part_b =  ks_lsb(high_x, low_y, bits - cut)            ##Z2

        return 2**cut * (high_part_a + high_part_b) + low_part

def ks_msb(a : int, b : int, remainingBits : int):
    if a.bit_length() <= 18 or b.bit_length() <= 18:
        return a * b
    else:
        cut = cuts_msb[remainingBits]
        high_x, low_x = split_at(a, cut)
        high_y, low_y = split_at(b, cut)

        mid_A = ks_msb(high_x, low_y, remainingBits - cut)
        mid_B = ks_msb(high_y, low_x, remainingBits - cut)

        mid = mid_A + mid_B
        high = karatsuba(high_x, high_y)
        return high*(2**(2*cut)) + (2**cut) * mid


#def ks_msb(x : int, y : int, bits : int, i : int):
#    if bits <= 45:
#        return x* y
#    else:
#        cut = cuts_msb[bits]
#
#        high_x, low_x = split_at(x, cut)
#        high_y, low_y = split_at(y, cut)
#
#        high_part = 2**(2*cut) * karatsuba(high_x, high_y)
#
#        bet_mid_A  = min_ks_msb(low_x, high_y, bits - cut)
#        mid_part_a = ks_msb(low_x, high_y, bits - cut, i + 1)
#        bet_mid_B  = min_ks_msb(high_x, low_y, bits - cut)
#        mid_part_b = ks_msb(high_x, low_y, bits - cut, i + 1)
#
#        mid_part = mid_part_a + mid_part_b
#        bet_mid  = bet_mid_A + bet_mid_B
#
#        if bet_mid == mid_part:
#            print("Coinciden en el nivel ", i)
#        else:
#            print("Error en el nivel ", i)
#        #return high_part + (2**cut)*mid_part
#        return high_part + (2**cut)*(bet_mid)

## Chequear que la cantidad de bits sea n + theta.

def comparison_LSB(a : int, b : int, length : int):
    strA = bin(a)[-length:]
    strB = bin(b)[-length:]
    for k in range(length - 1, -1, -1):
        if strA[k] != strB[k]:
            print("Error en el bit : ", length - k)
            return 1
    return 0 

def comparison_MSB(a : int, b : int, representation : int, length : int):
    rep = str(representation + 2)
    strA = format(a, '#0'+rep+'b')
    strB = format(b, '#0'+rep+'b')
    for k in range(2, length + 3):
        if strA[k] != strB[k]:
            print("Error en el bit : ", k)
            return 1
    return 0 
