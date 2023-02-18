## Modules 

* Karatsuba multiplication (kara_mul)
   - [x] Combinatorial
   - [x] Pipelined 
- Karatsuba optimization - LSB (kara_mul_low)
  - [x] Combinatorial
  - [ ] Pipelined 
- Karatsuba optimization - MSB (kara_mul_high)
  - [-] Combinatorial (Not fully tested)
  - [ ] Pipelined 
- Modular arithmetic - Addition (mod_add)
  - [x] Combinatorial
  - [x] Pipelined 
- Modular arithmetic - Multiplication by Barrett method (mod_mul)
  - [x] Combinatorial
  - [x] Pipelined 
- 377b point adder - Homogeneous projective coordinates (point_adder)
  - [x] Combinatorial
  - [x] Pipelined 
- Bucket method
  - [-] Structural
  - [-] Behavioral
    - [-] Loop1
    - [ ] Loop2

## Possible optimizations

- Using the most of DSP multipliers in the Karatsuba tree. (We could reduce the resources but not necessarily the latency, since it depends on the height of the tree).
- Using canonical signed digit representation (CSD rep) for the constant multiplications. It could reduce the amount of logic needed for the intermediate multiplication of the Barrett.
- Maybe trying another coordinate system for the point adder (https://zprize.hardcaml.com/msm-mixed-point-addition-with-precomputation.html)
