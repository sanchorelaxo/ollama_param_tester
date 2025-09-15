# Ollama Parameter Tester

This repository contains scripts for testing Ollama model parameters.

## Scripts

- **ollama_modelfile.sh**: Generates a Modelfile with custom `temperature`, `top_p`, `top_k`, model name, and a system message, creates the model, shows the Modelfile, and runs the model with the message.
- **test_ollama.sh**: Runs a suite of tests that invoke `ollama_modelfile.sh` with various combinations of `temperature`, `top_p`, and `top_k` while keeping the model name and message constant.

## Usage

```bash
# Make scripts executable
chmod +x ollama_modelfile.sh test_ollama.sh

# Run the test suite
./test_ollama.sh
```

The test suite prints the parameters for each run, creates the model, and displays the model's response.

## License

This project is provided under the MIT License.
