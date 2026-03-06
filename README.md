# Vector Search Lab

This project is a hands-on Jupyter lab that walks through the core parts of a Retrieval-Augmented Generation (RAG) workflow using:

- A local embedding model (`sentence-transformers`, default `all-MiniLM-L6-v2`)
- A local PDF document as source data
- Oracle Autonomous Database with native `VECTOR` type
- Oracle vector distance search (`VECTOR_DISTANCE` with cosine)

The notebook file is:

- `vector-search-lab.ipynb`

---

## What the lab covers

The notebook implements 4 of the 5 common RAG stages:

1. **Document ingestion & chunking**
   Reads a local PDF and splits page text into overlapping chunks.

2. **Embedding generation**
   Uses a local sentence-transformer model to convert chunks into vector embeddings.

3. **Vector storage in Oracle**
   Creates/truncates `oil_paint_chunks` and stores:
   - `page_number`
   - `chunk_index`
   - `text_chunk` (CLOB)
   - `embedding` (VECTOR(384))

4. **Semantic retrieval**
   Runs:
   - local cosine similarity search in Python
   - Oracle-native vector search using SQL `VECTOR_DISTANCE`

> The final LLM answer-generation step is intentionally not implemented in this notebook.

---

## Repository contents

- `vector-search-lab.ipynb` — main lab notebook
- `setup_venv.sh` — helper script to create the Python virtual environment and install dependencies
- `.env` — expected place for DB credentials and connection alias

---

## Prerequisites

- Python 3.13+
- Oracle Autonomous Database access
- Downloaded Oracle wallet ZIP (e.g., `Wallet_livelab.zip`)
- Local PDF document to embed

For DB connectivity, the notebook expects wallet files under:

- `~/oracle_wallet`

and uses wallet-based `python-oracledb` connections.

---

## Setup

1. Create the virtual environment and install packages:

```bash
bash setup_venv.sh
```

2. Activate the environment:

```bash
source ./lib/.venv/bin/activate
```

3. Launch Jupyter:

```bash
jupyter lab
```

4. Open `vector-search-lab.ipynb` and select the project interpreter/kernel.

---

## Environment variables

The notebook reads these from `.env`:

- `DB_USER`
- `DB_PASSWORD`
- `CONNECT_STRING` (example: `livelab_high`)

Make sure they are set before running DB cells.

---

## Suggested run order in notebook

1. Environment + interpreter checks
2. Connection setup / `test_connection()`
3. PDF loading
4. Embedding model load
5. Chunking + embedding generation
6. Table create/truncate
7. Insert embeddings
8. Local semantic search test
9. Oracle semantic search test

---

## Notes

- The notebook includes both local retrieval and Oracle retrieval so you can compare behavior.
- If model download is blocked, run once with internet access to cache model files locally.
- If Oracle wallet SSL/cert issues occur, confirm wallet path consistency and that the same Python environment/kernel is being used throughout.
