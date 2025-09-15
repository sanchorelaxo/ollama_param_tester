#!/usr/bin/env bash

# Script to create an Ollama model with custom parameters, display its Modelfile, and query it with a message.
# Usage: ./ollama_modelfile.sh <temperature> <top_p> <top_k> <model_name> <message>
# Example: ./ollama_modelfile.sh 0.8 0.9 40 my_custom_model "Explain the weather"

# valid parameters https://ollama.readthedocs.io/en/modelfile/#valid-parameters-and-values

set -e

if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <temperature> <top_p> <top_k> <model_name> <message>"
  exit 1
fi

temp="$1"
top_p="$2"
top_k="$3"
model_name="$4"
message="$5"

# Ensure a clean temporary directory for the Modelfile
workdir="/tmp/ollama_modelfile_workdir"
if [ -d "$workdir" ]; then
  rm -rf "${workdir:?}"/*
else
  mkdir -p "$workdir"
fi
cd "$workdir"

# Generate the Modelfile with the provided parameters.
# Adjust the base model (FROM) as needed.
cat > Modelfile <<EOF
FROM llama2
PARAMETER temperature $temp
PARAMETER top_p $top_p
PARAMETER top_k $top_k
SYSTEM $message
EOF

# Create the model using Ollama
echo "Creating model '$model_name' with provided parameters..."
ollama create "$model_name" < Modelfile || true

# Show the Modelfile of the created model
#echo "\n--- Modelfile for model '$model_name' ---"
#ollama show "$model_name"

# Query the model with the provided message

echo "\n--- Response from model '$model_name' for message ---"
echo "$message" | ollama run "$model_name" || true

# Clean up temporary directory
cd - || true
rm -rf "$workdir" || true

echo "\nDone."
