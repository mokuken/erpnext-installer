# ERPNext v15 — WSL2 Ubuntu Auto Installer

Automated setup script for running **ERPNext v15** on **Windows 10/11**
using **WSL2 Ubuntu**.  
This repository provides a ready-to-run Bash script that installs all
required dependencies and configures ERPNext in a single command.

---

## 🚀 One-Line Install (Recommended)

Run this directly inside **WSL2 Ubuntu** to install the base Frappe setup:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mokuken/erpnext-installer/main/install.sh | sed 's/\r$//')
```

This downloads and runs the `install.sh` script (creates a `Frappe` directory by default).

Optional: Install ERPNext on the created bench/site with a single command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mokuken/erpnext-installer/main/install_erpnext.sh | sed 's/\r$//')
```

Combined one-liner (Frappe first, then ERPNext) — runs `install.sh` then `install_erpnext.sh`:

```bash
curl -fsSL https://raw.githubusercontent.com/mokuken/erpnext-installer/main/install.sh | bash -s -- ERPNext && \
curl -fsSL https://raw.githubusercontent.com/mokuken/erpnext-installer/main/install_erpnext.sh | bash -s -- ERPNext
```

Notes:
- The `-- ERPNext` argument tells the scripts to use `ERPNext` as the working directory name (you can change it).
- Run these inside **WSL2 Ubuntu**; they assume a Linux environment.

---

## 📦 Features

✔ Automated installation  
✔ WSL2 Ubuntu compatible  
✔ MariaDB auto-configuration  
✔ Installs Node.js, Yarn, wkhtmltopdf  
✔ Bench setup + ERPNext v15 install  
✔ Runs ERPNext instantly

---

## 🛠 Prerequisites

### 1. Enable WSL2 on Windows 10/11

Open PowerShell as Administrator:

```powershell
wsl --install ubuntu
```

Then open **Ubuntu** from the Start Menu.

---

## 📥 Download This Repository (Optional)

### Using Git:

```bash
git clone https://github.com/yourusername/erpnext-wsl2-installer.git
cd erpnext-wsl2-installer
```

Or manually via GitHub → **Code → Download ZIP**

---

## ▶ Manual Installation (Alternative)

If you downloaded the scripts manually:

### 1. Make the scripts executable

```bash
chmod +x install.sh install_erpnext.sh install_webshop.sh
```

### 2. Run the base installer

```bash
./install.sh
```

### 3. (Optional) Install ERPNext

```bash
./install_erpnext.sh
```

The installer will automatically:

- Update Ubuntu  
- Install dependencies  
- Configure MariaDB  
- Install Node.js + Yarn  
- Install wkhtmltopdf  
- Install Bench  
- Create bench environment  
- Create site `erpnext.localhost`  
- Install ERPNext v15  
- Start ERPNext server  

---

## 🌐 Accessing ERPNext

Open your browser:

👉 **http://erpnext.localhost:8000/app**

### Default Login

- **User:** Administrator  
- **Password:** admin

---

## 🔁 Restarting ERPNext

```bash
cd frappe-bench
bench start
```

---

## 📘 Repository Structure

```
erpnext-installer/
├── install.sh
├── install_erpnext.sh
├── install_webshop.sh
└── README.md
```

---

## ⚠ Notes

- For development/testing use  
- MariaDB password = `root`  
- Ensure port **8000** is free  
- Works on Windows 10/11 (WSL2 only)

---

## 📄 License

MIT License

---

## Install apps (Optional)

Webshop is an add-on e-commerce application built for the Frappe Framework and designed to work with ERPNext.

Install the webshop apps using the hosted script:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mokuken/erpnext-installer/main/install_webshop.sh | sed 's/\r$//')
```

It turns your ERPNext system into a fully functional online store where customers can browse products, add them to a cart, place orders, and make online payments.
