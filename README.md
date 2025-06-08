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
- Automated workflow script for the complete ZKP process

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Circuit Examples](#circuit-examples)
- [Proof Generation and Verification](#proof-generation-and-verification)
- [Automated Workflow](#automated-workflow)
- [Troubleshooting](#troubleshooting)
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
├── SimpleMultiplier.circom       # Simple multiplier circuit for demonstration
├── fib_circom.circom             # Modular Fibonacci function
├── fib_circom2.circom            # Implementation using modular import
├── input.json                    # Sample input values for Fibonacci
├── multiplier_input.json         # Sample input for the multiplier circuit
├── run_zkp.sh                    # Automated workflow script
├── proof.json                    # Generated proof
├── public.json                   # Public inputs/outputs
├── *.r1cs                        # R1CS constraint files
└── *.sym                         # Symbol files
```

## Quick Start

To quickly get started with the ZKP workflow, use the provided automated script:

```bash
# Make the script executable (if not already)
chmod +x run_zkp.sh

# Run the workflow with the SimpleMultiplier circuit
./run_zkp.sh SimpleMultiplier multiplier_input.json
```

This will:
1. Compile the SimpleMultiplier circuit
2. Generate a witness based on the input (a=7, b=6)
3. Set up the trusted setup
4. Generate and verify a proof
5. Create a Solidity verifier contract

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

### What's Missing in the Original Repository

The original repository was missing several key components needed for a complete ZKP workflow:

1. **WebAssembly (WASM) Files**: After compiling a circuit, you need the WASM files to generate witnesses. These files are created when you compile with the `--wasm` flag.

2. **Witness Generation Code**: The JavaScript code needed to generate witnesses from inputs was missing.

3. **Powers of Tau File**: The trusted setup requires a Powers of Tau file, which needs to be downloaded.

4. **Automated Workflow**: There was no script to automate the entire process from compilation to verification.

5. **Solidity Verifier**: Code to generate a Solidity verifier contract for on-chain verification was missing.

These missing components have been added to the repository to provide a complete ZKP workflow.

## Automated Workflow

The `run_zkp.sh` script automates the entire ZKP workflow:

```bash
./run_zkp.sh <circuit_name> [input_file]
```

For example:
```bash
./run_zkp.sh Fibonacci input.json
```

The script performs the following steps:
1. Compiles the circuit
2. Downloads the Powers of Tau file if needed
3. Generates the witness
4. Sets up the trusted setup
5. Exports the verification key
6. Generates the proof
7. Verifies the proof
8. Generates a Solidity verifier contract

## Troubleshooting

### Common Issues

1. **Missing WASM Files**:
   - Error: `Cannot find module './Fibonacci_js/generate_witness.js'`
   - Solution: Make sure to compile with the `--wasm` flag: `circom Fibonacci.circom --r1cs --wasm --sym`

2. **Powers of Tau File**:
   - Error: `Error: File "pot.ptau" not found`
   - Solution: Download the file: `wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau -O pot.ptau`

3. **Input Format Issues**:
   - Error: `Error: Input signal not found: a`
   - Solution: Make sure your input.json file has the correct signal names matching your circuit

4. **Memory Issues with Large Circuits**:
   - Error: `JavaScript heap out of memory`
   - Solution: Increase Node.js memory: `NODE_OPTIONS=--max-old-space-size=4096 node ...`

## Advanced Topics

### Modular Circuit Design

The repository demonstrates modular circuit design through:
- Separating function definitions (`fib_circom.circom`)
- Including modules in other circuits (`fib_circom2.circom`)

### Optimization Techniques

- Using functions for repeated calculations
- Efficient constraint generation
- Modular design for reusability

### Blockchain Integration

To integrate your ZKP system with a blockchain:

1. Generate a Solidity verifier contract:
   ```bash
   snarkjs zkey export solidityverifier circuit.zkey verifier.sol
   ```

2. Deploy the verifier contract to your blockchain of choice

3. Call the `verifyProof` function with your proof and public inputs

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

*Note: This README was created with the assistance of AI to provide a comprehensive and professional documentation for the ZKP-circom-Crypto-blockchain repository. The AI helped identify missing components in the original repository and created additional files and documentation to ensure a complete and functional ZKP workflow.*