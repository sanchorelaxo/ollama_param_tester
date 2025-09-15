# Ollama Parameter Tester

A minimal suite for experimenting with Ollama model parameters.

## Scripts

- **ollama_modelfile.sh** – builds a temporary Modelfile using supplied `temperature`, `top_p`, `top_k`, model name and a system message, creates the model, and runs it.
- **test_ollama.sh** – runs eight silent test cases (varying `temperature`, `top_p`, `top_k`), saves each response to a temporary file, and shows a colored `diff` between each consecutive pair. After the run it cleans up all temporary files.

## Quick start

```bash
chmod +x ollama_modelfile.sh test_ollama.sh   # make executable
./test_ollama.sh                               # execute the test suite
```

The script prints only the parameter headers and the diffs, keeping the output concise.

## License

MIT License.
