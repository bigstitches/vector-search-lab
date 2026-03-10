#!/bin/bash
set -euo pipefail

# ====== Config (adjust as needed) ======
JUPYTER_USER="jupyter"
VENV_DIR="/opt/jupyter-venv"
NOTEBOOK_DIR="/home/${JUPYTER_USER}/notebooks"
JUPYTER_PORT="8888"

# Safer default: bind only to localhost; use SSH tunnel to access.
JUPYTER_IP="127.0.0.1"

# If you truly need remote access, set JUPYTER_IP="0.0.0.0"
# and restrict access with OCI NSGs/security lists + optionally a reverse proxy + auth.
# JUPYTER_IP="0.0.0.0"

# Set to "1" if you want to open the firewall port on the instance (still need OCI VCN rules)
OPEN_FIREWALL_PORT="0"
# =======================================

echo "[1/7] Updating OS packages..."
dnf -y update

echo "[2/7] Installing OS prerequisites..."
dnf -y install \
  python3 python3-pip python3-devel \
  gcc gcc-c++ make \
  openssl-devel bzip2-devel libffi-devel zlib-devel \
  git wget curl \
  nodejs

# (Optional) for some python packages with native deps:
dnf -y install \
  cmake \
  redhat-rpm-config || true

echo "[3/7] Creating '${JUPYTER_USER}' user (if needed)..."
if ! id "${JUPYTER_USER}" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "${JUPYTER_USER}"
fi

mkdir -p "${NOTEBOOK_DIR}"
chown -R "${JUPYTER_USER}:${JUPYTER_USER}" "/home/${JUPYTER_USER}"

echo "[4/7] Creating Python virtual environment at ${VENV_DIR}..."
python3 -m venv "${VENV_DIR}"
"${VENV_DIR}/bin/python" -m pip install --upgrade pip wheel setuptools

echo "[5/7] Installing Python packages..."
# Note: sentence-transformers and transformers are different packages; install both.
"${VENV_DIR}/bin/pip" install \
  oracledb \
  sentence-transformers \
  transformers \
  PyPDF2 \
  jupyterlab \
  ipykernel

echo "[6/7] Registering IPython kernel..."
"${VENV_DIR}/bin/python" -m ipykernel install --name "jupyter-venv" --display-name "Python (jupyter-venv)"

echo "[7/7] Creating systemd service for JupyterLab..."

cat >/etc/systemd/system/jupyterlab.service <<EOF
[Unit]
Description=JupyterLab (venv: ${VENV_DIR})
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=${JUPYTER_USER}
Group=${JUPYTER_USER}
WorkingDirectory=${NOTEBOOK_DIR}
Environment=PATH=${VENV_DIR}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
ExecStart=${VENV_DIR}/bin/jupyter lab --no-browser --ip=${JUPYTER_IP} --port=${JUPYTER_PORT} --NotebookApp.token=''
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Security: token is set to empty above for convenience.
# Recommended: set a password/token instead. For example:
#   - remove --NotebookApp.token=''
#   - or set --NotebookApp.token='YOUR_STRONG_TOKEN'
#   - or configure Jupyter password hashing.

systemctl daemon-reload
systemctl enable --now jupyterlab.service

if [[ "${OPEN_FIREWALL_PORT}" == "1" ]]; then
  echo "Opening firewall port ${JUPYTER_PORT}/tcp with firewalld..."
  systemctl enable --now firewalld || true
  firewall-cmd --permanent --add-port=${JUPYTER_PORT}/tcp
  firewall-cmd --reload
fi

echo "Done."
echo "JupyterLab service status:"
systemctl --no-pager status jupyterlab.service || true

echo
echo "Access tips:"
echo " - Default bind is ${JUPYTER_IP}:${JUPYTER_PORT}"
echo " - If bound to 127.0.0.1, use SSH port-forward:"
echo "     ssh -i <key> opc@<public_ip> -L 8888:127.0.0.1:8888"
echo "   then open: http://127.0.0.1:8888/"