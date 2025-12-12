#!/bin/bash

set -e

echo "======================================"
echo " Frappe v15 Installer for WSL2 Ubuntu"
echo "======================================"
echo ""

# Prompt for configuration upfront
read -p "Enter bench name (default: frappe-bench): " BENCH_INPUT
BENCH_NAME="${BENCH_INPUT:-frappe-bench}"

read -p "Do you want to create a site? (y/n, default: y): " CREATE_SITE_INPUT
CREATE_SITE="${CREATE_SITE_INPUT:-y}"

if [[ "$CREATE_SITE" =~ ^[Yy]$ ]]; then
    read -p "Enter site name (default: frappe.localhost): " SITE_INPUT
    SITE_NAME="${SITE_INPUT:-frappe.localhost}"
fi

read -sp "Enter MariaDB root password (default: root): " DB_PASSWORD_INPUT
echo ""
DB_ROOT_PASSWORD="${DB_PASSWORD_INPUT:-root}"

echo ""
echo "Configuration:"
echo "  Bench name: $BENCH_NAME"
if [[ "$CREATE_SITE" =~ ^[Yy]$ ]]; then
    echo "  Create site: Yes"
    echo "  Site name: $SITE_NAME"
else
    echo "  Create site: No"
fi
echo "  MariaDB root password: [hidden]"
echo ""

# Create a working directory for Frappe (default: ./Frappe) and operate inside it
FRAPPE_DIR="${1:-Frappe}"
echo "Using Frappe directory: $FRAPPE_DIR"
mkdir -p "$FRAPPE_DIR"
cd "$FRAPPE_DIR"

# Step 2: Update Linux & install dependencies
echo "[1/7] Updating system and installing base packages..."
sudo apt update
sudo apt install -y \
    git python-is-python3 python3-dev python3-pip python3-venv \
    redis-server libmariadb-dev mariadb-server mariadb-client pkg-config \
    curl xvfb libfontconfig xfonts-75dpi

# Step 3: Configure MariaDB
echo "[2/7] Setting up MariaDB root password..."
sudo systemctl enable mariadb
sudo systemctl start mariadb

# AUTO CONFIGURE ROOT PASSWORD
sudo mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD'; FLUSH PRIVILEGES;"

sudo systemctl restart mariadb

# Step 4: Install Latest Node.js and Yarn
echo "[3/7] Installing latest Node.js and Yarn..."
# Use NodeSource installer for latest Node.js
curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
sudo apt install -y nodejs

# Install Yarn globally using npm
sudo npm install -g yarn

# Step 5: Install wkhtmltopdf
echo "[4/7] Installing wkhtmltopdf..."
WKHTML=https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
wget $WKHTML -O wkhtml.deb
sudo dpkg -i wkhtml.deb || sudo apt -f install -y
rm wkhtml.deb

# Step 6: Install Bench CLI
echo "[5/7] Installing Bench CLI..."
python3 -m venv bench-env
source bench-env/bin/activate
pip install --upgrade pip
pip install frappe-bench

# Step 7: Create Bench
echo "[6/7] Creating $BENCH_NAME..."
bench init $BENCH_NAME --frappe-branch version-15
cd $BENCH_NAME
bench set-config -g developer_mode 1

# Step 8: Create Site (optional)
if [[ "$CREATE_SITE" =~ ^[Yy]$ ]]; then
    echo "[7/7] Creating Frappe site..."
    bench new-site $SITE_NAME --admin-password admin --db-root-password $DB_ROOT_PASSWORD
    bench --site $SITE_NAME set-config enable_scheduler 1
    
    echo "=============================="
    echo " Frappe Installation Complete!"
    echo "=============================="
    echo ""
    echo "Site created: $SITE_NAME"
    echo "Admin password: admin"
    echo ""
    echo "To start Frappe, run:"
    echo "  source $FRAPPE_DIR/bench-env/bin/activate"
    echo "  cd $FRAPPE_DIR/$BENCH_NAME"
    echo "  bench start"
    echo ""
else
    echo "[7/7] Skipping site creation..."
    
    echo "=============================="
    echo " Frappe Installation Complete!"
    echo "=============================="
    echo ""
    echo "To create a site manually, run:"
    echo "  source $FRAPPE_DIR/bench-env/bin/activate"
    echo "  cd $FRAPPE_DIR/$BENCH_NAME"
    echo "  bench new-site <site-name> --admin-password admin --db-root-password $DB_ROOT_PASSWORD"
    echo ""
    echo "To start Frappe, run:"
    echo "  source $FRAPPE_DIR/bench-env/bin/activate"
    echo "  cd $FRAPPE_DIR/$BENCH_NAME"
    echo "  bench start"
    echo ""
fi
echo "Optional: Install ERPNext with ./install_erpnext.sh"
echo "Optional: Install Webshop apps with ./install_webshop_apps.sh"
