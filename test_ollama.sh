#!/usr/bin/env bash

# Test script for ollama_modelfile.sh with multiple parameter sets.
# Each test prints the parameters being used before invoking the main script.
# set -e  # disabled to allow script to continue on errors
set +e  # ensure script does not exit on errors

declare -a RESPONSES
INDEX=0
RESPONSE_DIR=$(mktemp -d)

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
  # Capture the model's response
  local response=$(bash ./ollama_modelfile.sh "$temp" "$top_p" "$top_k" "$MODEL" "$MESSAGE" 2>/dev/null) || true
  RESPONSES[INDEX]="$response"
  # Save response to a file for diffing
  printf "%s\n" "$response" > "${RESPONSE_DIR}/response_${INDEX}.txt"
  # word count for this response
  wc -w "${RESPONSE_DIR}/response_${INDEX}.txt" > "${RESPONSE_DIR}/wc_${INDEX}.txt"
  # duplicate words in this response
  cut -d" " -f1 "${RESPONSE_DIR}/response_${INDEX}.txt" | sort | uniq -d > "${RESPONSE_DIR}/dup_${INDEX}.txt"
  ((INDEX++))
}

# Helper to compare a pair of runs (indices i and j)
compare_pair() {
  local i=$1
  local j=$2
  echo "--- Diff between run $((i+1)) and run $((j+1)) ---"
  diff --color "${RESPONSE_DIR}/response_${i}.txt" "${RESPONSE_DIR}/response_${j}.txt" || true
  echo "\n--- Word count difference between run $((i+1)) and run $((j+1)) ---"
  wc1=$(awk '{print $1}' "${RESPONSE_DIR}/wc_${i}.txt")
  wc2=$(awk '{print $1}' "${RESPONSE_DIR}/wc_${j}.txt")
  echo "Run $((i+1)) word count: $wc1"
  echo "Run $((j+1)) word count: $wc2"
  echo "Difference: $((wc1 - wc2))"
  echo "\n--- Duplicate words count difference between run $((i+1)) and run $((j+1)) ---"
  dup1=$(wc -l < "${RESPONSE_DIR}/dup_${i}.txt")
  dup2=$(wc -l < "${RESPONSE_DIR}/dup_${j}.txt")
  echo "Run $((i+1)) duplicate words: $dup1"
  echo "Run $((j+1)) duplicate words: $dup2"
  echo "Difference: $((dup1 - dup2))"
  echo
}


# Fixed parameters
MODEL="llama3.2"
MESSAGE="Test message: succinctly explain the concept of recursion"

# Test cases (vary only temperature, top_p, top_k)
run_test 0.2 0.2 10
run_test 0.2 0.2 80
# Compare runs 1 and 2
compare_pair 0 1

run_test 0.2 0.99 10
run_test 0.2 0.99 80
# Compare runs 3 and 4
compare_pair 2 3

run_test 0.9 0.2 10
run_test 0.9 0.2 80
# Compare runs 5 and 6
compare_pair 4 5

run_test 0.9 0.99 10
run_test 0.9 0.99 80
# Compare runs 7 and 8
compare_pair 6 7

echo "All tests completed."
# Clean up temporary response files
echo "Cleaning up temporary response directory..."
rm -rf "${RESPONSE_DIR}"
