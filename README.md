# ERPNext v15 — WSL2 Ubuntu Auto Installer

Automated setup script for running **ERPNext v15** on **Windows 10/11**
using **WSL2 Ubuntu**.  
This repository provides a ready-to-run Bash script that installs all
required dependencies and configures ERPNext in a single command.

---

## 🚀 One-Line Install (Recommended)

Run this directly inside **WSL2 Ubuntu**:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mokuken/erpnext-installer/refs/heads/main/erpnext_install.sh | sed 's/\r$//')
```

This automatically downloads the script, and runs the installer.

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

If you downloaded the script manually:

### 1. Make the script executable

```bash
chmod +x erpnext_install.sh
```

### 2. Run it

```bash
./erpnext_install.sh
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
erpnext-wsl2-installer/
├── erpnext_install.sh
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

Webshop is an add-on e-commerce application built for the Frappe Framework and designed to work with ERPNext.:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/mokuken/erpnext-installer/refs/heads/main/install_webshop_apps.sh | sed 's/\r$//')
```

It turns your ERPNext system into a fully functional online store where customers can browse products, add them to a cart, place orders, and make online payments.
