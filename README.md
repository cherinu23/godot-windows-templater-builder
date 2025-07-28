# Godot Windows Templater Builder

A Docker-based builder for creating **custom Windows export templates** for the [Godot Engine](https://godotengine.org), with **AES-256 encryption** support for secure `.pck` file exports.

Designed for **Linux-based developers** who want to export their games to Windows with custom, encrypted templates.

---

## ✅ What It Does

- Builds the following Godot export templates (for version `4.4.1-stable`):
  - `godot.windows.template_debug.x86_64.exe`
  - `godot.windows.template_debug.x86_64.console.exe`
  - `godot.windows.template_release.x86_64.exe`
  - `godot.windows.template_release.x86_64.console.exe`
- Enables **AES-256 script encryption** using a user-supplied key
- Outputs templates into a local folder, ready to be configured in the Godot Editor

---

## 🛠 Requirements

- A Linux machine (tested on Debian/Ubuntu)
- [Docker](https://docs.docker.com/get-docker/) installed
- A 64-character AES key (generated below)

---

## 🔐 Generate Encryption Key

To generate a secure 256-bit (64-character hex) AES key:

```bash
openssl rand -hex 32

