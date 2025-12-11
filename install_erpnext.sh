#!/bin/bash

set -e

echo "=============================="
echo " ERPNext v15 Installer"
echo "=============================="

# Determine the Frappe directory
FRAPPE_DIR="${1:-Frappe}"

# Check if frappe-bench exists
if [ ! -d "$FRAPPE_DIR/frappe-bench" ]; then
    echo "Error: Frappe bench not found at $FRAPPE_DIR/frappe-bench"
    echo "Please run install.sh first to set up Frappe."
    exit 1
fi

cd "$FRAPPE_DIR/frappe-bench"

# Activate bench environment
source ../bench-env/bin/activate

# Get the site name (assume first site or use frappe.localhost)
SITE_NAME=$(bench --site all list-sites | head -n 1)
if [ -z "$SITE_NAME" ]; then
    SITE_NAME="frappe.localhost"
fi

echo "Installing ERPNext on site: $SITE_NAME"

# Install ERPNext app
echo "[1/2] Getting ERPNext app..."
bench get-app --branch version-15 erpnext

echo "[2/2] Installing ERPNext on site..."
bench --site $SITE_NAME install-app erpnext

echo "=============================="
echo " ERPNext Installation Complete!"
echo "=============================="
echo ""
echo "ERPNext has been installed on: $SITE_NAME"
echo ""
echo "To start the bench, run:"
echo "  cd $FRAPPE_DIR/frappe-bench"
echo "  bench start"
