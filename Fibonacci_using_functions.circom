pragma circom 2.1.9;

function fibtest(fib1,fib2,n){
       var a = fib1;
    var b = fib2;
    var c;

    // Constraints.
    for (var i = 0; i < n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    return c;

}
template fibonacci(n) {
    // Declaration of signals.
    signal input fib1;
    signal input fib2;
    signal output fibn;

    fibn <== fibtest(fib1,fib2,n)*fib1;
}

component main = fibonacci(1000);
