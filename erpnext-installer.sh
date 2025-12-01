#!/bin/bash
set -e

echo "======================================================="
echo "   ERPNext v15 Automated Installer for Ubuntu (WSL2)"
echo "======================================================="

# ------------------------------
# Step 2: Install Dependencies
# ------------------------------
echo "[1/10] Updating system and installing dependencies..."
sudo apt update -y
sudo apt install -y \
    git python-is-python3 python3-dev python3-pip python3-venv \
    redis-server libmariadb-dev mariadb-server mariadb-client pkg-config \
    xvfb libfontconfig xfonts-75dpi curl wget

# ------------------------------
# Step 3: Configure MariaDB
# ------------------------------
echo "[2/10] Configuring MariaDB..."

sudo systemctl start mariadb

sudo mariadb <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
FLUSH PRIVILEGES;
EOF

sudo systemctl restart mariadb
echo "MariaDB root password set to: root"

# ------------------------------
# Step 4: Install Node + Yarn (via NVM)
# ------------------------------
echo "[3/10] Installing Node (v18) and Yarn..."

export NVM_DIR="$HOME/.nvm"

if [ ! -d "$NVM_DIR" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

source "$HOME/.nvm/nvm.sh"
nvm install 18
npm install -g yarn

# ------------------------------
# Step 5: Install wkhtmltopdf (v0.12.6)
# ------------------------------
echo "[4/10] Installing wkhtmltopdf..."

WKHTML="wkhtmltox_0.12.6.1-2.jammy_amd64.deb"

wget -O $WKHTML \
https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/$WKHTML

sudo dpkg -i $WKHTML || sudo apt --fix-broken install -y

# ------------------------------
# Step 6: Install Bench CLI (inside virtual environment)
# ------------------------------
echo "[5/10] Installing Frappe Bench..."

python3 -m venv bench-env
source bench-env/bin/activate
pip install --upgrade pip
pip install frappe-bench

# ------------------------------
# Step 7: Create Frappe Bench
# ------------------------------
echo "[6/10] Creating frappe-bench..."

bench init frappe-bench --frappe-branch version-15 --python "$(which python)"

cd frappe-bench

# ------------------------------
# Step 8: Create site + Install ERPNext
# ------------------------------
echo "[7/10] Creating ERPNext site..."

bench new-site erpnext.localhost --mariadb-root-password root --admin-password admin

bench --site erpnext.localhost set-config enable_scheduler 1

echo "[8/10] Getting ERPNext app..."
bench get-app --branch version-15 erpnext

echo "[9/10] Installing ERPNext..."
bench --site erpnext.localhost install-app erpnext

# ------------------------------
# Step 9: Start ERPNext
# ------------------------------
echo "[10/10] Starting ERPNext..."
bench start
