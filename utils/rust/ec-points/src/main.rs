use std::env;
use std::str::FromStr;

use ark_ff::{PrimeField, Field, BigInteger, Fp384};
use ark_ec::{ProjectiveCurve, AffineCurve};
use ark_std::{Zero, One, UniformRand};
use ark_bls12_377::{G1Projective as G, G1Affine as GAffine, Fr as ScalarField, Fq};
//use ark_bls12_381::{G1Projective as G, G1Affine as GAffine, Fr as ScalarField};

fn main() {
    let mut rng = ark_std::rand::thread_rng(); 

    println!("Generating point in projective and affine coordinates");
    
    let t = G::rand(&mut rng);

    let g = t.into_affine();

    println!("Affine : {}", g);
    println!("Sum Affine : {}", g + g);

    let mut index = 0;

    while index < 100000 {
        let a = G::rand(&mut rng).into_affine();
        let b = G::rand(&mut rng).into_affine();
        let c = a + b;

        let x1 = a.x;
        let y1 = a.y;
        let z1 = Fq::one();

        let x2 = b.x;
        let y2 = b.y;
        let z2 = Fq::one();

        let mul1 = x1 * x2;
        let mul2 = y1 * y2;
        let mul3 = z1 * z2;

        let add1 = x1 + y1;
        let add2 = x2 + y2;
        let add3 = x1 + z1;
        let add4 = x2 + z2; 
        let add5 = y1 + z1;
        let add6 = y2 + z2;

        let add7 = mul1 + mul2;
        let add8 = mul1 + mul3;
        let add9 = mul2 + mul3;
        let mul4 = add1 * add2; 
        let mul5 = add3 * add4;
        let mul6 = add5 * add6;

        let prod1 = mul3 + mul3 + mul3;
        let sub1 = mul4 - add7; 
        let sub2 = mul5 - add8;
        let sub3 = mul6 - add9;

        let prod2 = mul1 + mul1 + mul1;
        let add10 = mul2 + prod1;
        let sub4  = mul2 - prod1;
        let prod3 = sub2 + sub2 + sub2;

        let finmul1 = sub4 * sub1;
        let finmul2 = prod3 * sub3;
        let finmul3 = add10 * sub4;
        let finmul4 = prod2 * prod3;
        let finmul5 = add10 * sub3;
        let finmul6 = sub1 * prod2;

        let x_res = finmul1 - finmul2;
        let y_res = finmul3 + finmul4;
        let z_res = finmul5 + finmul6;

        println!("A : {}", a);
        println!("B : {}", b);

        let result = GAffine::new(x_res / z_res, y_res/z_res, false);

        println!("Res : {}, {}, {}", x_res, y_res, z_res);
        assert!(result == c);

        index += 1;
    }
}
