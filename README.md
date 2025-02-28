# MSI Laptop Touchscreen and Fingerprint Reader Setup for Ubuntu

This repository contains two scripts to enable and configure the fingerprint reader and touchscreen (including pen support) on MSI laptops running Ubuntu. These features are not natively supported on Ubuntu, so these scripts automate the setup process.

## Scripts Overview

### 1. `setup_fingerprint.sh`
This script configures the fingerprint reader on MSI laptops for Ubuntu. It performs the following tasks:
- Removes existing fingerprint configurations (if any).
- Reinstalls the necessary packages (`fprintd` and `libpam-fprintd`).
- Enrolls your fingerprint.
- Configures PAM (Pluggable Authentication Modules) to enable fingerprint authentication for:
  - Terminal `sudo` prompts.
  - Graphical login (LightDM/GDM).
  - PolicyKit authentication (e.g., unlocking drives).
- Starts and enables the `fprintd` service.

### 2. `touch.sh`
This script configures the touchscreen and pen input for MSI laptops on Ubuntu. It performs the following tasks:
- Reinstalls input drivers (`xserver-xorg-input-libinput` and `xserver-xorg-input-evdev`).
- Detects the touchscreen device ID.
- Configures the touchscreen for:
  - Tap-to-click.
  - Tap-and-hold for secondary click (right-click).
  - Natural scrolling (optional).
- Provides an option to install popular notebook apps for pen input (e.g., Xournal++, Joplin, Rnote, etc.).

---

## Prerequisites

- Ubuntu (tested on Ubuntu 20.04 and later).
- Administrative privileges (sudo access).
- An internet connection to download and install packages.

---

## Usage

### 1. Fingerprint Reader Setup (`setup_fingerprint.sh`)
1. Download the script:
   ```bash
   wget https://raw.githubusercontent.com/your-username/your-repo/main/setup_fingerprint.sh
   ```
2. Make the script executable:
   ```bash
   chmod +x setup_fingerprint.sh
   ```
3. Run the script with sudo:
   ```bash
   sudo ./setup_fingerprint.sh
   ```
4. Follow the on-screen instructions to enroll your fingerprint.

### 2. Touchscreen and Pen Setup (`touch.sh`)
1. Download the script:
   ```bash
   wget https://raw.githubusercontent.com/your-username/your-repo/main/touch.sh
   ```
2. Make the script executable:
   ```bash
   chmod +x touch.sh
   ```
3. Run the script:
   ```bash
   ./touch.sh
   ```
4. Follow the on-screen instructions to configure the touchscreen and install a notebook app (optional).

---

## Notes

- **Backup**: The `setup_fingerprint.sh` script creates backups of PAM configuration files (e.g., `/etc/pam.d/common-auth.bak`) before modifying them. You can restore these backups manually if needed.
- **Notebook Apps**: The `touch.sh` script provides an option to install popular notebook apps for pen input. You can skip this step if you already have a preferred app.
- **Compatibility**: These scripts are tailored for MSI laptops but may work on other devices with similar hardware. Test and modify as needed.

---

## Troubleshooting

### Fingerprint Reader
- If the fingerprint reader is not detected, ensure that your hardware is supported by `fprintd`. Check the [fprintd documentation](https://fprint.freedesktop.org/) for more details.
- If fingerprint authentication fails, verify that the `fprintd` service is running:
  ```bash
  systemctl status fprintd
  ```

### Touchscreen
- If the touchscreen is not detected, ensure that the device is properly connected and recognized by the system. You can list input devices using:
  ```bash
  xinput list
  ```
- If tap-and-hold or other gestures do not work, try reinstalling the input drivers manually:
  ```bash
  sudo apt install --reinstall xserver-xorg-input-libinput xserver-xorg-input-evdev
  ```

---

## Contributing

If you encounter issues or have suggestions for improvement, feel free to open an issue or submit a pull request. Contributions are welcome!

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Thanks to the developers of `fprintd`, `libinput`, and the Ubuntu community for their support.
- Inspired by various forum threads and guides for enabling fingerprint and touchscreen functionality on Linux.

---

Enjoy using your MSI laptop with full fingerprint and touchscreen support on Ubuntu! 🎉