pragma circom 2.1.9;
template fibonacci(n) {
    // Declaration of signals.
    signal input fib1;
    signal input fib2;
    signal output fibn;

    // Internal variables.
    var a = fib1;
    var b = fib2;
    var c;

    // Constraints.
    for (var i = 0; i < n; i++) {
        c = a + b;
        a = b;
        b = c;
    }

    // Assign the final Fibonacci number to the output signal.
    fibn <== c;
}

component main = fibonacci(1000);
