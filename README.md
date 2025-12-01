# ERPNext v15 -- WSL2 Ubuntu Auto Installer

Automated setup script for running **ERPNext v15** on **Windows 10/11**
using **WSL2 Ubuntu**.\
This repository provides a ready-to-run Bash script that installs all
required dependencies and configures ERPNext in a single command.

## 📦 Features

✔ Automated installation\
✔ WSL2 Ubuntu compatible\
✔ MariaDB auto-configuration\
✔ Auto install Node.js, Yarn, wkhtmltopdf\
✔ Bench setup + ERPNext v15 install\
✔ Runs ERPNext instantly

## 🛠 Prerequisites

### 1. Enable WSL2 on Windows 10/11

Open PowerShell as Administrator:

    wsl --install ubuntu

Then open **Ubuntu** from the Start Menu.

## 📥 Download This Repository

### Using Git:

    git clone https://github.com/yourusername/erpnext-wsl2-installer.git
    cd erpnext-wsl2-installer

Or download manually via GitHub → **Code → Download ZIP**

## ▶ How to Use the Installer

### 1. Make the script executable

    chmod +x erpnext_install.sh

### 2. Run it

    ./erpnext_install.sh

The installer will automatically: - Update Ubuntu\
- Install dependencies\
- Configure MariaDB\
- Install Node.js + Yarn\
- Install wkhtmltopdf\
- Install Bench\
- Create bench environment\
- Create site `erpnext.localhost`\
- Install ERPNext v15\
- Start ERPNext server

## 🌐 Accessing ERPNext

Open your browser:

👉 http://erpnext.localhost:8000/app

### Default Login:

-   **User:** Administrator\
-   **Password:** admin

## 🔁 Restarting ERPNext

    cd frappe-bench
    bench start

## 📘 Repository Structure

    erpnext-wsl2-installer/
    ├── erpnext_install.sh
    └── README.md

## ⚠ Notes

-   For development only\
-   MariaDB password = `root`\
-   Ensure port 8000 is free

## 📄 License

MIT License
