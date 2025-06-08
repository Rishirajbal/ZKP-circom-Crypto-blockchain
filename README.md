# ZKP-circom-Crypto-blockchain

A comprehensive toolkit and tutorial for Zero-Knowledge Proofs (ZKP) using Circom and SnarkJS.

![ZKP Banner](https://img.shields.io/badge/ZKP-Circom-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Circom Version](https://img.shields.io/badge/Circom-2.1.9-orange)

## Table of Contents

- [Introduction to Zero-Knowledge Proofs](#introduction-to-zero-knowledge-proofs)
- [Technical Background](#technical-background)
- [Repository Contents](#repository-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Comprehensive Tutorial](#comprehensive-tutorial)
- [Advanced Topics](#advanced-topics)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Introduction to Zero-Knowledge Proofs

Zero-Knowledge Proofs (ZKPs) are cryptographic protocols that allow one party (the prover) to prove to another party (the verifier) that a statement is true without revealing any additional information beyond the validity of the statement itself. 

### Key Properties of ZKPs

1. **Completeness**: If the statement is true, an honest verifier will be convinced by an honest prover.
2. **Soundness**: If the statement is false, no cheating prover can convince an honest verifier that it is true, except with negligible probability.
3. **Zero-Knowledge**: If the statement is true, the verifier learns nothing other than the fact that the statement is true.

### Real-World Applications

- **Privacy-Preserving Identity Verification**: Prove you're over 18 without revealing your actual age or identity.
- **Confidential Transactions**: Prove a transaction is valid without revealing the amount or participants.
- **Authentication**: Prove knowledge of a password without sending the password.
- **Blockchain Scalability**: ZK-Rollups allow for off-chain computation with on-chain verification.
- **Supply Chain Verification**: Prove authenticity of products without revealing sensitive business data.

## Technical Background

### ZK-SNARKs

This repository focuses on ZK-SNARKs (Zero-Knowledge Succinct Non-Interactive Arguments of Knowledge), which are:

- **Succinct**: Proofs are small and quick to verify
- **Non-Interactive**: No back-and-forth communication is needed between prover and verifier
- **Arguments of Knowledge**: The prover demonstrates knowledge of some information

### Circom and SnarkJS

- **Circom**: A domain-specific language for defining arithmetic circuits that represent computational statements
- **SnarkJS**: A JavaScript implementation of the ZK-SNARK protocol

### The ZKP Workflow

1. **Circuit Definition**: Define the computation as a circuit in Circom
2. **Compilation**: Compile the circuit to a constraint system (R1CS)
3. **Trusted Setup**: Generate proving and verification keys
4. **Witness Generation**: Create a witness from the private inputs
5. **Proof Generation**: Generate a proof using the witness and proving key
6. **Verification**: Verify the proof using the verification key and public inputs

## Repository Contents

This repository contains:

1. **Fibonacci Circuit Implementations**:
   - `Fibonacci.circom`: Basic implementation of Fibonacci sequence calculation
   - `Fibonacci_using_functions.circom`: Function-based implementation
   - `fib_circom.circom`: Modular Fibonacci function
   - `fib_circom2.circom`: Implementation using modular import

2. **Simple Demonstration Circuit**:
   - `SimpleMultiplier.circom`: A basic multiplier circuit for easy demonstration

3. **Input Files**:
   - `input.json`: Sample input for Fibonacci circuits
   - `multiplier_input.json`: Sample input for the multiplier circuit

4. **Generated Files**:
   - Various `.r1cs` files: Compiled constraint systems
   - `.sym` files: Symbol files for debugging
   - `proof.json`: Example proof
   - `public.json`: Example public inputs/outputs

5. **Automation**:
   - `run_zkp.sh`: Script to automate the entire ZKP workflow

## Prerequisites

- Basic understanding of cryptography concepts
- Familiarity with command-line tools
- Basic programming knowledge
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

## Comprehensive Tutorial

This tutorial will guide you through the complete ZKP workflow using the files in this repository.

### Step 1: Understanding the Circuits

Let's start by examining the different circuit implementations:

#### Simple Multiplier Circuit

The `SimpleMultiplier.circom` file contains a basic circuit that multiplies two inputs:

```circom
pragma circom 2.1.9;

template Multiplier() {
    signal input a;
    signal input b;
    signal output c;

    c <== a * b;
}

component main = Multiplier();
```

This circuit:
- Takes two input signals `a` and `b`
- Outputs their product as signal `c`
- Uses the `<==` operator to create a constraint (a * b = c)

#### Fibonacci Circuit

The `Fibonacci.circom` file implements a circuit that calculates the nth Fibonacci number:

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

This circuit:
- Takes two input signals `fib1` and `fib2` (the first two Fibonacci numbers)
- Calculates the (n+2)th Fibonacci number through iteration
- Outputs the result as `fibn`

#### Function-Based Fibonacci

The `Fibonacci_using_functions.circom` file demonstrates how to use functions in Circom:

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

This implementation:
- Extracts the Fibonacci calculation into a separate function
- Demonstrates how to use functions to make circuits more modular
- Multiplies the result by `fib1` to show how to combine function results with signals

#### Modular Circuit Design

The repository also demonstrates modular circuit design through:
- `fib_circom.circom`: Contains only the Fibonacci function
- `fib_circom2.circom`: Imports and uses the function from the first file

This approach shows how to create reusable components in Circom.

### Step 2: Preparing Input Files

The repository includes sample input files:

1. `input.json` for the Fibonacci circuits:
   ```json
   {"fib1": "1", "fib2": 17}
   ```

2. `multiplier_input.json` for the SimpleMultiplier circuit:
   ```json
   {"a": 7, "b": 6}
   ```

These files provide the private inputs to the circuits. The format must match the input signals defined in the circuit.

### Step 3: Running the Complete Workflow

The repository includes an automated script `run_zkp.sh` that handles the entire ZKP workflow. Let's walk through how to use it:

1. Make the script executable:
   ```bash
   chmod +x run_zkp.sh
   ```

2. Run the workflow with the SimpleMultiplier circuit:
   ```bash
   ./run_zkp.sh SimpleMultiplier multiplier_input.json
   ```

This script performs the following steps:

#### 3.1: Circuit Compilation

```bash
circom SimpleMultiplier.circom --r1cs --wasm --sym
```

This command:
- Compiles the circuit to a Rank-1 Constraint System (R1CS)
- Generates WebAssembly code for witness generation
- Creates a symbol file for debugging

The output files will be:
- `SimpleMultiplier.r1cs`: The constraint system
- `SimpleMultiplier.sym`: Symbol file for debugging
- `SimpleMultiplier_js/`: Directory containing WebAssembly files

#### 3.2: Witness Generation

```bash
node SimpleMultiplier_js/generate_witness.js SimpleMultiplier_js/SimpleMultiplier.wasm multiplier_input.json witness.wtns
```

This command:
- Uses the WebAssembly code to generate a witness
- Takes the input values from `multiplier_input.json`
- Produces a witness file `witness.wtns`

The witness contains the values of all signals in the circuit, including intermediate signals.

#### 3.3: Trusted Setup

```bash
# Download Powers of Tau file if needed
wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau -O pot.ptau

# Setup
snarkjs plonk setup SimpleMultiplier.r1cs pot.ptau SimpleMultiplier.zkey
```

This step:
- Downloads a Powers of Tau file (a common reference string)
- Creates a proving key and verification key (stored in `SimpleMultiplier.zkey`)

#### 3.4: Proof Generation and Verification

```bash
# Export verification key
snarkjs zkey export verificationkey SimpleMultiplier.zkey verification_key.json

# Generate proof
snarkjs plonk prove SimpleMultiplier.zkey witness.wtns proof.json public.json

# Verify proof
snarkjs plonk verify verification_key.json public.json proof.json
```

These commands:
- Extract the verification key from the zkey file
- Generate a proof using the witness and proving key
- Verify the proof using the verification key and public inputs

#### 3.5: Solidity Verifier Generation

```bash
snarkjs zkey export solidityverifier SimpleMultiplier.zkey SimpleMultiplierVerifier.sol
```

This command generates a Solidity smart contract that can verify proofs on-chain.

### Step 4: Manual Workflow for Fibonacci Circuit

If you want to run the workflow manually for the Fibonacci circuit:

1. Compile the circuit:
   ```bash
   circom Fibonacci.circom --r1cs --wasm --sym
   ```

2. Generate the witness:
   ```bash
   node Fibonacci_js/generate_witness.js Fibonacci_js/Fibonacci.wasm input.json witness.wtns
   ```

3. Setup the trusted setup:
   ```bash
   snarkjs plonk setup Fibonacci.r1cs pot.ptau Fibonacci.zkey
   ```

4. Generate and verify the proof:
   ```bash
   snarkjs zkey export verificationkey Fibonacci.zkey verification_key.json
   snarkjs plonk prove Fibonacci.zkey witness.wtns proof.json public.json
   snarkjs plonk verify verification_key.json public.json proof.json
   ```

5. Generate a Solidity verifier:
   ```bash
   snarkjs zkey export solidityverifier Fibonacci.zkey FibonacciVerifier.sol
   ```

## Advanced Topics

### Understanding R1CS

The R1CS (Rank-1 Constraint System) is a way to represent computational statements as a set of quadratic constraints. Each constraint has the form:
```
A · B = C
```
where A, B, and C are linear combinations of variables, and · represents the dot product.

The `.r1cs` files in this repository contain these constraints in a binary format.

### PLONK Protocol

This repository uses the PLONK proving system, which:
- Requires only one universal trusted setup
- Produces smaller proofs than earlier systems
- Has efficient verification

### Blockchain Integration

To integrate your ZKP system with a blockchain:

1. Generate a Solidity verifier contract:
   ```bash
   snarkjs zkey export solidityverifier circuit.zkey verifier.sol
   ```

2. Deploy the verifier contract to your blockchain of choice

3. Call the `verifyProof` function with your proof and public inputs

### Custom Constraints

Circom allows you to define custom constraints using the `<==` operator. For example:
```circom
signal x;
signal y;
signal z;

z <== x * y;  // Creates a constraint: z = x * y
```

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

5. **Circom Version Mismatch**:
   - Error: `Error: Pragma directive indicates circom version X.Y.Z but current version is A.B.C`
   - Solution: Update the pragma directive in your circuit or install the correct circom version

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