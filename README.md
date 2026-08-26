# Vector Search Lab

`vector-search-lab.ipynb` is a hands-on Jupyter notebook that demonstrates a small retrieval-augmented generation (RAG) workflow with a local PDF, sentence-transformer embeddings, and Oracle Autonomous Database vector search.

## What the lab does

1. Reads and chunks `oil_paints.pdf` from this project directory.
2. Creates embeddings with `sentence-transformers` and `all-MiniLM-L6-v2`.
3. Stores chunks and 384-dimension vectors in the Oracle table `oil_paint_chunks`.
4. Searches both locally (cosine similarity) and in Oracle (`VECTOR_DISTANCE`).
5. Optionally generates an answer from retrieved Oracle results using GPT-2.

## Project contents

- `vector-search-lab.ipynb` — main lab notebook.
- `oil_paints.pdf` — the default document embedded by the notebook. Replace it with another text-based PDF if desired, keeping the filename or updating `PDF_PATH` in the notebook.
- `setup_venv.sh` — creates `lib/.venv`, installs dependencies, and registers the `local_embedding_env` Jupyter kernel.
- `DBMS_VECTOR.sql` — separate Oracle Database vector SQL examples; it is not executed by the notebook.
- `minilm_l6_v2_onnx/` — local ONNX model assets retained with the project. The notebook currently loads `all-MiniLM-L6-v2` through `SentenceTransformer`, which uses the Hugging Face cache rather than this directory.
- `.env` — local, untracked database credentials; create this yourself.

The remaining setup documents and `setup_computeinstance.sh` are optional guides or provisioning aids; the main notebook does not use them.

## Prerequisites

- Python 3 with `venv` support.
- Oracle Autonomous Database access with Oracle AI Vector Search support.
- An Oracle wallet ZIP, such as `~/Downloads/Wallet_livelab.zip`.
- At least several GB of free disk space for the Python environment and downloaded models.

The notebook extracts the wallet to `~/oracle_wallet` on its first run and uses wallet-based `python-oracledb` connections.

## Setup

From the project directory, create the environment:

```bash
bash setup_venv.sh
source ./lib/.venv/bin/activate
jupyter lab
```

Open `vector-search-lab.ipynb` in JupyterLab and choose the **local_embedding_env** kernel.

On first use, the embedding model and GPT-2 may download from Hugging Face. Subsequent runs can use the local Hugging Face cache.

## Database configuration

Create a `.env` file in the project root:

```dotenv
DB_USER=your_database_user
DB_PASSWORD=your_database_password
CONNECT_STRING=your_service_name
```

For example, `CONNECT_STRING` might be `livelab_high`. Do not commit this file.

Before running the database cells, place the downloaded wallet ZIP at `~/Downloads/Wallet_livelab.zip`, or change `wallet_zip` in the notebook to match its location.

## Running the notebook

Run the cells in order. The database setup cell creates `oil_paint_chunks` if necessary and truncates it on later runs, so rerunning the ingestion portion replaces the table's contents.

To use another document, put a text-based PDF in the project directory and change this notebook setting:

```python
PDF_PATH = Path('your-document.pdf')
```

The final GPT-2 answer-generation cells are optional. The retrieval sections can be used independently.
