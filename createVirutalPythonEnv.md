# Create a Python Virtual Environment for `vector-search-lab` (Beginner Guide)

This guide explains **exactly** how to use `setup_venv.sh` in Visual Studio Code (VS Code), even if you are new to Python and have no VS Code extensions installed.

---

## Prerequisites
- Visual Studio Code
- Python3 from Python.org available in your PATH

## 1) What is a virtual environment (in plain English)?

A **virtual environment** is a private Python workspace for one project.

Why this matters:
- Different projects can need different Python packages/versions.
- A virtual environment keeps this project’s packages separate from your computer’s global Python.
- It helps avoid conflicts and “it works on my machine” problems.

Think of it like this:
- **Global Python** = your whole kitchen
- **Virtual environment** = one labeled meal-prep container for this project only

---

## 2) What `setup_venv.sh` does for you

When you run `setup_venv.sh`, it automatically:

1. Checks that `python3` exists
2. Creates a folder `./lib/.venv` (the virtual environment)
3. Activates that environment
4. Upgrades `pip`
5. Installs required packages (like `oracledb`, `sentence-transformers`, `torch`, `jupyterlab`, etc.)
6. Installs a Jupyter kernel named `local_embedding_env`
7. Runs quick import checks

So you do **not** need to install each package manually one by one.

---

## 3) Before you start (requirements)

You need:
- VS Code
- Internet connection (for package downloads the first time)
- Python 3 installed on your machine
- The project folder 'vector_search_RAG' opened in VS Code (the one containing `setup_venv.sh`)

Recommended machine resources:
- RAM: 12–16 GB for smoother experience
- Free disk: at least a few GB for packages/model caches

---

## 4) Open the project in VS Code

1. Start VS Code.
2. Go to **File → Open Folder...**
3. Select your project folder (for example: `vector-search-lab`).
4. Confirm you can see `setup_venv.sh` in the Explorer sidebar.

---

## 5) Open a terminal in VS Code

1. In VS Code, click **Terminal → New Terminal**.
2. A terminal panel opens at the bottom.
3. Make sure you are in the project root (the folder with `setup_venv.sh`).

You can check with:

```bash
pwd
ls
```

You should see `setup_venv.sh` listed.

---

## 6) Make the setup script executable (one-time step)

Run:

```bash
chmod +x setup_venv.sh
```

What this does:
- Gives permission to execute the script directly.

---

## 7) Run the script

Run either command below:

```bash
./setup_venv.sh
```

or

```bash
bash setup_venv.sh
```

What to expect:
- You will see progress messages like “Creating virtual environment...”, “Installing required packages...”, etc.
- First run can take several minutes.
- Optional package install (`accelerate`, `bitsandbytes`) may show warnings on unsupported systems; this is expected.

---

## 8) Activate the virtual environment for future sessions

After setup, each new terminal session should activate the environment:

```bash
source ./lib/.venv/bin/activate
```

When activated, your shell prompt often shows something like:

```text
(.venv) your-computer:vector-search-lab yourname$
```

That prefix means you are inside the project environment.

---

## 9) Start Jupyter Lab

With the environment active:

```bash
jupyter lab
```

Then in Jupyter/Notebook UI:
- Open `vector-search-lab.ipynb`
- Choose kernel: **`local_embedding_env`**

If you skip kernel selection, notebook cells may run with the wrong Python and fail imports.

---

## 10) Typical daily workflow (quick version)

Every day when you return to this project:

1. Open project folder in VS Code
2. Open terminal
3. Activate env:

   ```bash
   source ./lib/.venv/bin/activate
   ```

4. Launch Jupyter:

   ```bash
   jupyter lab
   ```

5. Open notebook and use `local_embedding_env` kernel

---

## 11) How to confirm things are working

In your activated terminal, run:

```bash
python -V
which python
python -c "import oracledb, torch, transformers, sentence_transformers, PyPDF2, dotenv; print('Imports OK')"
```

If all good, you should see no import errors and a final `Imports OK`.

---

## 12) Troubleshooting

### Problem: `python3: command not found`
Install Python 3 first, then retry.

### Problem: permission denied when running script
Run:

```bash
chmod +x setup_venv.sh
```

Then run script again.

### Problem: command `jupyter` not found
Make sure env is activated first:

```bash
source ./lib/.venv/bin/activate
```

Then retry:

```bash
jupyter lab
```

### Problem: Notebook says package missing
Usually means wrong kernel/interpreter.
- Re-select kernel `local_embedding_env`
- Confirm terminal is activated

### Problem: `bitsandbytes` warning
This package is platform-sensitive. The script already treats it as optional and continues.

---

## 13) How to deactivate or remove the environment

Deactivate current terminal session:

```bash
deactivate
```

Remove the environment completely (if needed):

```bash
rm -rf ./lib/.venv
```

Then recreate later by rerunning:

```bash
bash setup_venv.sh
```

---

## 14) One-command setup summary

If you just want the shortest path:

```bash
chmod +x setup_venv.sh
./setup_venv.sh
source ./lib/.venv/bin/activate
jupyter lab
```

---

## 15) Final notes for beginners

- You are not “changing system Python” by using this workflow.
- You are creating a safe, isolated Python workspace for this project.
- If something breaks, you can delete `./lib/.venv` and rebuild from the script.

That is exactly why virtual environments are standard in Python projects.
