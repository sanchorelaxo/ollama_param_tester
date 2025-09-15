#!/usr/bin/env bash

# Test script for ollama_modelfile.sh with multiple parameter sets.
# Each test prints the parameters being used before invoking the main script.
# valid parameters https://ollama.readthedocs.io/en/modelfile/#valid-parameters-and-values
set -e

run_test() {
  local temp=$1
  local top_p=$2
  local top_k=$3
  echo "--------------------------------------------------"
  echo "Running test with parameters:"
  echo "  temperature = $temp"
  echo "  top_p       = $top_p"
  echo "  top_k       = $top_k"
  echo "  model       = $MODEL"
  echo "  message     = $MESSAGE"
  echo "--------------------------------------------------"
  bash ./ollama_modelfile.sh "$temp" "$top_p" "$top_k" "$MODEL" "$MESSAGE"
  echo
}

# Fixed parameters
MODEL="llama3.2"
MESSAGE="Test message: succinctly explain the concept of recursion"

# Test cases (vary only temperature, top_p, top_k)
run_test 0.2 0.2 10
run_test 0.9 0.99 80
run_test 0.5 0.98 80
run_test 0.5 0.2 10
run_test 0.5 0.98 40

echo "All tests completed."

