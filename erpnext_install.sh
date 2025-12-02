#!/bin/bash

set -e

echo "=============================="
echo " ERPNext v15 Installer for WSL2 Ubuntu"
echo "=============================="

# Create a working directory for ERPNext (default: ./ERPNext) and operate inside it
ERP_DIR="${1:-ERPNext}"
echo "Using ERP directory: $ERP_DIR"
mkdir -p "$ERP_DIR"
cd "$ERP_DIR"

# Step 2: Update Linux & install dependencies
echo "[1/8] Updating system and installing base packages..."
sudo apt update
sudo apt install -y \
    git python-is-python3 python3-dev python3-pip python3-venv \
    redis-server libmariadb-dev mariadb-server mariadb-client pkg-config \
    curl xvfb libfontconfig xfonts-75dpi

# Step 3: Configure MariaDB
echo "[2/8] Setting up MariaDB root password..."
sudo systemctl enable mariadb
sudo systemctl start mariadb

# AUTO CONFIGURE ROOT PASSWORD
sudo mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'; FLUSH PRIVILEGES;"

sudo systemctl restart mariadb

# Step 4: Install Node.js 18 LTS (NodeSource) and Yarn
echo "[3/8] Installing Node.js 18 LTS and Yarn..."
# Use NodeSource installer for Node.js 18 LTS (recommended for Frappe v14-v16)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install Yarn globally using npm
sudo npm install -g yarn

# Step 5: Install wkhtmltopdf
echo "[4/8] Installing wkhtmltopdf..."
WKHTML=https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
wget $WKHTML -O wkhtml.deb
sudo dpkg -i wkhtml.deb || sudo apt -f install -y
rm wkhtml.deb

# Step 6: Install Bench CLI
echo "[5/8] Installing Bench CLI..."
python3 -m venv bench-env
source bench-env/bin/activate
pip install --upgrade pip
pip install frappe-bench

# Step 7: Create Bench
echo "[6/8] Creating frappe-bench..."
bench init frappe-bench --frappe-branch version-15
cd frappe-bench

# Step 8: Create Site & Install ERPNext
echo "[7/8] Creating ERPNext site..."
SITE_NAME="erpnext.localhost"

bench new-site $SITE_NAME --admin-password admin --db-root-password root
bench --site $SITE_NAME set-config enable_scheduler 1

echo "[8/8] Installing ERPNext app..."
bench get-app --branch version-15 erpnext
bench --site $SITE_NAME install-app erpnext

echo "Starting Bench..."
bench start
