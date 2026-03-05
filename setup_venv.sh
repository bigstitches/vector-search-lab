#!/bin/bash
# stop script on error, undefined variable, or error in pipeline
set -euo pipefail

# Setup script for creating a virtual Python environment with required libraries
# for running the local_embedding_model.ipynb Jupyter notebook
echo "Setting up virtual environment for local_embedding_model.ipynb..."

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
pip install oracledb sentence-transformers PyPDF2 jupyterlab ipykernel

# Install the kernel for Jupyter
echo "Installing Jupyter kernel..."
python -m ipykernel install --user --name=local_embedding_env

# Verify installation
echo "Verifying installations..."
python -c "import oracledb; print('oracledb:', oracledb.__version__)" || echo "Warning: oracledb import failed"
python -c "import sentence_transformers; print('sentence-transformers: OK')" || echo "Warning: sentence_transformers import failed"
python -c "import PyPDF2; print('PyPDF2: OK')" || echo "Warning: PyPDF2 import failed"
python -c "import jupyterlab; print('jupyterlab: OK')" || echo "Warning: jupyterlab import failed"

echo ""
echo "Setup complete!"
echo ""
echo "To activate the environment in future sessions, run the following in the oracle-lab-temp directory:"
echo "source ./lib/.venv/bin/activate"
echo ""
echo "To start Jupyter Lab, run:"
echo "jupyter lab"
echo ""
echo "In Jupyter Lab, select the 'local_embedding_env' kernel when opening the notebook."
echo "The notebook local_embedding_model.ipynb can be found in the current directory."