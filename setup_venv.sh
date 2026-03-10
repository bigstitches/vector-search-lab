#!/bin/bash
# stop script on error, undefined variable, or error in pipeline
set -euo pipefail

# Minimum (works, but can be tight)
# RAM: 8 GB
# Disk free before install: >3 GB
# Recommended (smooth experience)
# RAM: 12–16 GB
# the .venv file is only ~1.0GB, and the model files are cached in ~/.cache/huggingface where the model files ~600GB, but additional files can bring it to ~1GB total.



# Setup script for creating a virtual Python environment with required libraries
# for running vector-search-lab.ipynb / local_embedding_model.ipynb Jupyter notebooks
echo "Setting up virtual environment for vector-search-lab/local_embedding_model notebooks..."

# Check if python3 is available
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 is not installed or not in PATH."
    echo "Please install Python 3 first."
    exit 1
fi

# if python3 is available in PATH, check venv is supported
python3 -m venv -h >/dev/null 2>&1 || { echo "Error: python3 venv module not available."; exit 1; }

# Create the lib directory if it doesn't exist
mkdir -p ./lib

# Create virtual environment
echo "Creating virtual environment at ./lib/.venv..."
python3 -m venv ./lib/.venv

# Check if venv was created successfully
if [ ! -f ./lib/.venv/bin/activate ]; then
    echo "Error: Failed to create virtual environment."
    exit 1
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source ./lib/.venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install required packages
echo "Installing required packages..."
pip install \
  oracledb \
  sentence-transformers \
  transformers \
  torch \
  PyPDF2 \
  python-dotenv \
  jupyterlab \
  ipykernel

# Optional packages for lower-memory/int8 model loading.
# Not all platforms support bitsandbytes; continue if it fails.
echo "Installing optional int8 support packages (best effort)..."
pip install accelerate bitsandbytes || echo "Warning: bitsandbytes/accelerate not available on this platform. Falling back to standard model loading is expected."

# Install the kernel for Jupyter
echo "Installing Jupyter kernel..."
python -m ipykernel install --user --name=local_embedding_env

# Verify installation
echo "Verifying installations..."
python -c "import oracledb; print('oracledb:', oracledb.__version__)" || echo "Warning: oracledb import failed"
python -c "import sentence_transformers; print('sentence-transformers: OK')" || echo "Warning: sentence_transformers import failed"
python -c "import transformers; print('transformers: OK')" || echo "Warning: transformers import failed"
python -c "import torch; print('torch:', torch.__version__)" || echo "Warning: torch import failed"
python -c "import PyPDF2; print('PyPDF2: OK')" || echo "Warning: PyPDF2 import failed"
python -c "import dotenv; print('python-dotenv: OK')" || echo "Warning: python-dotenv import failed"
python -c "import jupyterlab; print('jupyterlab: OK')" || echo "Warning: jupyterlab import failed"
python -c "import accelerate; print('accelerate: OK')" || echo "Warning: accelerate import failed (optional)"
python -c "import bitsandbytes as bnb; print('bitsandbytes: OK')" || echo "Warning: bitsandbytes import failed (optional for int8)"

echo ""
echo "Setup complete!"
echo ""
echo "To activate the environment in future sessions, run:"
echo "source ./lib/.venv/bin/activate"
echo ""
echo "To start Jupyter Lab, run:"
echo "jupyter lab"
echo ""
echo "In Jupyter Lab, select the 'local_embedding_env' kernel when opening the notebook."
echo "Notebooks supported by this environment include vector-search-lab.ipynb and local_embedding_model.ipynb."
echo "Clean up your environment by deactivating with 'deactivate' and removing the ./lib/.venv directory if needed."
echo "Remove the large model stored in your .cache/huggingface directory if you want to free up disk space after setup."