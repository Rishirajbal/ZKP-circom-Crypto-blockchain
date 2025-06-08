#!/bin/bash

# ZKP Workflow Script for Fibonacci Circuit
# This script automates the entire ZKP workflow from circuit compilation to proof verification

set -e  # Exit on error

# Check if circuit name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <circuit_name> [input_file]"
  echo "Example: $0 Fibonacci input.json"
  exit 1
fi

CIRCUIT=$1
INPUT_FILE=${2:-input.json}
PTAU_FILE="pot.ptau"
PTAU_URL="https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau"

echo "=== ZKP Workflow for $CIRCUIT ==="
echo "Using input file: $INPUT_FILE"

# Step 1: Check if circom is installed
if ! command -v circom &> /dev/null; then
  echo "Error: circom is not installed. Please install it first."
  exit 1
fi

# Step 2: Check if snarkjs is installed
if ! command -v snarkjs &> /dev/null; then
  echo "Error: snarkjs is not installed. Please install it first."
  exit 1
fi

# Step 3: Compile the circuit
echo "Compiling circuit: $CIRCUIT.circom"
circom $CIRCUIT.circom --r1cs --wasm --sym

# Step 4: Check if Powers of Tau file exists, download if not
if [ ! -f "$PTAU_FILE" ]; then
  echo "Downloading Powers of Tau file..."
  wget $PTAU_URL -O $PTAU_FILE
fi

# Step 5: Create circuit directory if it doesn't exist
mkdir -p ${CIRCUIT}_js

# Step 6: Generate witness
echo "Generating witness..."
node ${CIRCUIT}_js/generate_witness.js ${CIRCUIT}_js/${CIRCUIT}.wasm $INPUT_FILE witness.wtns

# Step 7: Setup the PLONK trusted setup
echo "Setting up PLONK trusted setup..."
snarkjs plonk setup $CIRCUIT.r1cs $PTAU_FILE $CIRCUIT.zkey

# Step 8: Export verification key
echo "Exporting verification key..."
snarkjs zkey export verificationkey $CIRCUIT.zkey verification_key.json

# Step 9: Generate proof
echo "Generating proof..."
snarkjs plonk prove $CIRCUIT.zkey witness.wtns proof.json public.json

# Step 10: Verify proof
echo "Verifying proof..."
snarkjs plonk verify verification_key.json public.json proof.json

# Step 11: Generate Solidity verifier (optional)
echo "Generating Solidity verifier..."
snarkjs zkey export solidityverifier $CIRCUIT.zkey ${CIRCUIT}Verifier.sol

echo "=== ZKP Workflow Completed Successfully ==="
echo "Generated files:"
echo "- $CIRCUIT.r1cs: Rank-1 Constraint System"
echo "- $CIRCUIT.sym: Symbol file"
echo "- ${CIRCUIT}_js/: WebAssembly files for witness generation"
echo "- witness.wtns: Witness file"
echo "- $CIRCUIT.zkey: Proving key"
echo "- verification_key.json: Verification key"
echo "- proof.json: Generated proof"
echo "- public.json: Public inputs/outputs"
echo "- ${CIRCUIT}Verifier.sol: Solidity verifier contract"