# 🛠️ Godot Custom Windows Export Template Builder (Dockerized)

This repository provides a **Docker-based workflow** for building **custom, AES-encrypted Windows export templates** for the [Godot Engine](https://godotengine.org/) (version `4.4.1-stable`).  
It’s designed for **Linux developers** who need to export games for Windows.

---

## 📦 Features

- Builds the following Godot export templates for Windows 64-bit:
  - `godot.windows.template_debug.x86_64.exe`
  - `godot.windows.template_debug.x86_64.console.exe`
  - `godot.windows.template_release.x86_64.exe`
  - `godot.windows.template_release.x86_64.console.exe`
- AES-256 GDScript encryption support using a custom key
- Automatically copies the built templates to a local directory
- Fully containerized with Docker — no need to install Windows toolchains
- Runs entirely from Linux (ideal for cross-platform Godot projects)

---

## 🧱 Prerequisites

- A Linux machine with Docker installed
- A 64-character hexadecimal AES-256 encryption key

---

## 🔐 Generate AES-256 Encryption Key (Linux)

Run this command in your terminal:

```bash
openssl rand -hex 32
```
---

## 🚀 Quick Start

1. Clone the Repository
```bash
git clone https://github.com/yourusername/godot-windows-templater-builder.git
cd godot-windows-templater-builder
```
2. Build the Docker Image
```bash
docker build -t godot-templater-builder .
```
3. Run the Build
```bash
docker run --rm \
  -e SCRIPT_AES256_ENCRYPTION_KEY="your_64_char_hex_key_here" \
  -v ~/your-folder/output:/godot/templater \
  godot-templater-builder
```
✅ This will:

- `Compile both release and debug Windows export templates`

- `Encrypt GDScript files using your AES-256 key`

- `Copy the binaries to your local ~/your-folder/output directory`

##

📁 Output
After running the build, the following files will be created:

- `godot.windows.template_debug.x86_64.exe`

- `godot.windows.template_debug.x86_64.console.exe`

- `godot.windows.template_release.x86_64.exe`

- `godot.windows.template_release.x86_64.console.exe`

You can place them in your Godot export templates folder:

- `Linux: ~/.local/share/godot/export_templates/4.4.1.stable/`

## 🛠 Build Overview

What happens inside the Docker container:

- Installs required packages (`MinGW`, `SCons`, `Python`, etc.)
- Clones the Godot source at `4.4.1-stable`
- Builds both **release** and **debug** templates for Windows
- Encrypts GDScript files using your provided key
- Copies build artifacts to your mounted local volume

➡️ See [`build.sh`](./build.sh) for full logic.

## 🔐 Step 7: Export Your Encrypted Build in Godot

1. Open **Godot Editor** → **Project** → **Export**
2. Select or create a **Windows export preset**
3. Go to the **Encryption** tab and configure:
   - ☑️ **Encrypt Exported PCK**
   - ☑️ **Encrypt Index**
4. In **Filters to include files/folders**, enter:
   - `*.*` to encrypt all files, or
   - `*.tscn`, `*.gd`, `*.tres` to selectively encrypt scenes, scripts, and resources
5. Ensure your **custom export template** is selected for the release build
6. Click **Export Project**
7. 🔽 **Uncheck "Export with debug"** for clean production builds

## 💬 Troubleshooting

| Issue                                 | Solution                                                                 |
|---------------------------------------|--------------------------------------------------------------------------|
| `SCRIPT_AES256_ENCRYPTION_KEY` not set| Make sure to pass it using `-e` when running the Docker container        |
| Permission denied when copying output | Ensure the output folder exists and is writable by Docker                |
| Missing template files                | Check the Docker logs or mount `/godot/build.log` to inspect errors      |

