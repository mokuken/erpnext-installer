#!/bin/bash

set -e

# install_webshop_apps.sh
# Convenience script to fetch and install webshop-related apps into a frappe-bench
# Defaults assume the bench directory is `frappe-bench` and site is `erpnext.localhost`.
# The script prefers branch `version-15` (suitable for Frappe/ERPNext v15).

BENCH_DIR="${1:-ERPNext/frappe-bench}"
SITE="${2:-erpnext.localhost}"
BRANCH="version-15"

echo "=============================="
echo " Install webshop-related apps for ERPNext/Frappe v15"
echo "=============================="
echo "Bench directory: $BENCH_DIR"
echo "Site: $SITE"
echo "Preferred branch: $BRANCH"

if [ ! -d "$BENCH_DIR" ]; then
  echo "ERROR: Bench directory '$BENCH_DIR' not found. By default this script looks for 'ERPNext/frappe-bench'."
  echo "Run this script from the parent of your 'ERPNext' directory, or pass the correct bench path as the first argument."
  echo "Usage: ./install_webshop_apps.sh [bench_dir] [site_name]"
  exit 1
fi

cd "$BENCH_DIR"

# Look for `bench-env` in the parent ERPNext folder (e.g. if BENCH_DIR is ERPNext/frappe-bench,
# the virtualenv is expected at ERPNext/bench-env). This keeps `bench-env` centralized in the
# ERPNext project folder instead of inside the bench directory itself.
if [ -d "../bench-env" ]; then
  if [ -f "../bench-env/bin/activate" ]; then
    echo "Activating Python virtualenv at '$(cd .. && pwd)/bench-env'..."
    # shellcheck disable=SC1091
    . "../bench-env/bin/activate"
  else
    echo "WARNING: 'bench-env' directory found at parent but '../bench-env/bin/activate' not present."
  fi
else
  echo "Note: No 'bench-env' virtualenv found in parent of '$BENCH_DIR' (expected '../bench-env')."
  echo "If 'bench' is not on PATH, activate the correct venv manually, for example:
  source /path/to/ERPNext/bench-env/bin/activate"
fi

if ! command -v bench >/dev/null 2>&1; then
  echo "ERROR: 'bench' command not found in PATH. Make sure you have frappe-bench installed and 'bench' is available." 
  exit 1
fi

# Helper to try multiple ways to fetch an app (prefer branch when possible)
install_app() {
  local name="$1"; shift
  local repos=("$@")

  for repo in "${repos[@]}"; do
    echo "---> Attempting: bench get-app --branch $BRANCH $name $repo"
    if bench get-app --branch "$BRANCH" "$name" "$repo"; then
      echo "Fetched $name from $repo (branch $BRANCH)."
      return 0
    fi

    echo "---> Attempting: bench get-app --branch $BRANCH $repo"
    if bench get-app --branch "$BRANCH" "$repo"; then
      echo "Fetched $name from $repo (branch $BRANCH)."
      return 0
    fi

    echo "---> Attempting: bench get-app $name $repo"
    if bench get-app "$name" "$repo"; then
      echo "Fetched $name from $repo."
      return 0
    fi

    echo "---> Attempting: bench get-app $repo"
    if bench get-app "$repo"; then
      echo "Fetched $name from $repo."
      return 0
    fi
  done

  echo "WARNING: Could not fetch '$name' from the candidate repos. You may need to provide the correct repo URL or check network access."
  return 1
}

# 1) payments app
# Official payments app: https://github.com/frappe/payments
# Prefer branch `version-15` (if available)

echo "[1/2] Installing 'payments' app..."
if install_app payments https://github.com/frappe/payments; then
  echo "Installing payments into site $SITE..."
  bench --site "$SITE" install-app payments || echo "ERROR: Installation of payments failed. Check compatibility and logs."
else
  echo "Skipping payments installation due to fetch failure."
fi

# 2) webshop app
# There are several community webshop apps. We'll try common locations and fall back to a plain 'webshop' get-app.

echo "[2/2] Installing 'webshop' app..."
if install_app webshop https://github.com/frappe/webshop https://github.com/frappe/erpnext_webshop https://github.com/frappe/commerce; then
  echo "Installing webshop into site $SITE..."
  bench --site "$SITE" install-app webshop || echo "ERROR: Installation of webshop failed. Check compatibility and logs."
else
  echo "WARNING: Could not fetch a 'webshop' app automatically. Please provide the correct GitHub repo URL, for example:\n  bench get-app webshop https://github.com/<owner>/<webshop-repo> --branch $BRANCH\nthen run:\n  bench --site $SITE install-app webshop"
fi

echo "Done."

echo "Notes:"
echo " - This script attempts to fetch apps using branch '$BRANCH' which is usually appropriate for Frappe/ERPNext v15."
echo " - If a repository does not have a 'version-15' branch, bench will try fetching the default branch as a fallback."
echo " - If installation fails due to incompatibility, you may need to select an app branch explicitly that matches your Frappe version."
