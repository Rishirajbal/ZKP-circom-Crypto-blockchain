# ZKP-circom-Crypto-blockchain

A comprehensive toolkit and tutorial for Zero-Knowledge Proofs (ZKP) using Circom and SnarkJS.

![ZKP Banner](https://img.shields.io/badge/ZKP-Circom-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Circom Version](https://img.shields.io/badge/Circom-2.1.9-orange)

## Overview

This repository provides a practical introduction to Zero-Knowledge Proofs (ZKPs) using Circom, a powerful domain-specific language for circuit development. The project focuses on implementing and demonstrating Fibonacci sequence calculations as a practical example of ZKP applications in blockchain and cryptography.

## Features

- Complete Circom circuit implementations for Fibonacci sequence calculations
- Multiple implementation approaches (direct, function-based, modular)
- Ready-to-use examples with input/output files
- Comprehensive tutorial for ZKP beginners and intermediate users
- Integration with SnarkJS for proof generation and verification

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Usage](#usage)
- [Circuit Examples](#circuit-examples)
- [Proof Generation and Verification](#proof-generation-and-verification)
- [Advanced Topics](#advanced-topics)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

- Basic knowledge of zero-knowledge proofs
- Familiarity with command-line tools
- Basic understanding of programming concepts
- (Optional) Understanding of blockchain technology

## Installation

### Install Rust

Circom is written in Rust, so you need to install Rust first:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### Install Circom

```bash
git clone https://github.com/iden3/circom.git
cd circom
cargo build --release
sudo cp target/release/circom /usr/local/bin/
```

### Install Node.js and npm

For Ubuntu:

```bash
sudo apt update
sudo apt install nodejs npm
```

Verify the installation:

```bash
node -v
npm -v
```

### Install SnarkJS

```bash
npm install -g snarkjs
```

## Project Structure

```
ZKP-circom-Crypto-blockchain/
├── Fibonacci.circom              # Basic Fibonacci implementation
├── Fibonacci_using_functions.circom  # Function-based implementation
├── fib_circom.circom             # Modular Fibonacci function
├── fib_circom2.circom            # Implementation using modular import
├── input.json                    # Sample input values
├── proof.json                    # Generated proof
├── public.json                   # Public inputs/outputs
├── *.r1cs                        # R1CS constraint files
└── *.sym                         # Symbol files
```

## Usage

### 1. Compile a Circuit

```bash
circom circuits/Fibonacci.circom --r1cs --wasm --sym
```

### 2. Generate a Witness

Create an input.json file with your inputs:

```json
{"fib1": "1", "fib2": "17"}
```

Generate the witness:

```bash
node Fibonacci_js/generate_witness.js Fibonacci_js/Fibonacci.wasm input.json witness.wtns
```

### 3. Setup the Trusted Setup

```bash
# Download Powers of Tau file (if needed)
wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau -O pot.ptau

# Setup
snarkjs plonk setup Fibonacci.r1cs pot.ptau Fibonacci.zkey
```

### 4. Generate and Verify Proofs

```bash
# Export verification key
snarkjs zkey export verificationkey Fibonacci.zkey verification_key.json

# Generate proof
snarkjs plonk prove Fibonacci.zkey witness.wtns proof.json public.json

# Verify proof
snarkjs plonk verify verification_key.json public.json proof.json
```

## Circuit Examples

### Basic Fibonacci Circuit

```circom
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
```

### Function-Based Implementation

```circom
pragma circom 2.1.9;

function fibtest(fib1, fib2, n) {
    var a = fib1;
    var b = fib2;
    var c;

    for (var i = 0; i < n; i++) {
        c = a + b;
        a = b;
        b = c;
    }
    return c;
}

template fibonacci(n) {
    signal input fib1;
    signal input fib2;
    signal output fibn;

    fibn <== fibtest(fib1, fib2, n) * fib1;
}

component main = fibonacci(1000);
```

## Proof Generation and Verification

The repository includes example files for proof generation and verification:

- `input.json`: Contains the input values for the Fibonacci circuit
- `proof.json`: A sample generated proof
- `public.json`: Public inputs/outputs for verification

## Advanced Topics

### Modular Circuit Design

The repository demonstrates modular circuit design through:
- Separating function definitions (`fib_circom.circom`)
- Including modules in other circuits (`fib_circom2.circom`)

### Optimization Techniques

- Using functions for repeated calculations
- Efficient constraint generation
- Modular design for reusability

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

*Note: This README was created with the assistance of AI to provide a comprehensive and professional documentation for the ZKP-circom-Crypto-blockchain repository.*