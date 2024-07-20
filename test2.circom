pragma circom 2.1.9;


template multi(){
    signal input v1;
    signal input v2;
    signal input v3;
    signal output vn;

    vn <== v1*v2;

}

component main = multi();