pragma circom 2.1.9;

include "fib_circom.circom";
template fibonacci(n) {
    // Declaration of signals.
    signal input fib1;
    signal input fib2;
    signal output fibn;

    fibn <== fibtest(fib1,fib2,n)*fib1;
}

component main = fibonacci(1000);
