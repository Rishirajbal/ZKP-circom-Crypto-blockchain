pragma circom 2.1.9;

/*
 * Simple multiplier circuit to demonstrate ZKP workflow
 * Inputs: a, b
 * Output: c = a * b
 */
template Multiplier() {
    signal input a;
    signal input b;
    signal output c;

    c <== a * b;
}

component main = Multiplier();