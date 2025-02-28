#!/bin/bash

# Script to delete existing fingerprint configuration (if exists) and reinstall everything
# Author: Your Name
# Version: 1.1

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Step 1: Remove Existing Fingerprint Configuration
echo "Removing existing fingerprint configuration..."

# Stop and disable fprintd service
if systemctl is-active --quiet fprintd; then
  echo "Stopping fprintd service..."
  systemctl stop fprintd
  systemctl disable fprintd
fi

# Uninstall fprintd and libpam-fprintd
echo "Uninstalling fprintd and libpam-fprintd..."
apt remove -y --purge fprintd libpam-fprintd

# Forcefully remove the /var/lib/fprint directory
if [ -d /var/lib/fprint/ ]; then
  echo "Removing /var/lib/fprint directory..."
  rm -rf /var/lib/fprint
fi

# Restore original PAM configuration files
echo "Restoring original PAM configuration files..."

# List of PAM configuration files to restore
PAM_FILES=(
  "/etc/pam.d/common-auth"     # System-wide authentication
  "/etc/pam.d/sudo"            # Terminal sudo prompts
  "/etc/pam.d/lightdm"         # LightDM graphical login (Ubuntu default)
  "/etc/pam.d/gdm-password"    # GDM graphical login (GNOME)
  "/etc/pam.d/polkit-1"        # PolicyKit authentication (e.g., unlocking drives)
)

# Restore each PAM file from backup
for pam_file in "${PAM_FILES[@]}"; do
  if [ -f "$pam_file.bak" ]; then
    echo "Restoring $pam_file from backup..."
    cp "$pam_file.bak" "$pam_file"
  else
    echo "No backup found for $pam_file. Skipping..."
  fi
done

# Step 2: Reinstall Fingerprint Authentication
echo "Reinstalling fingerprint authentication..."

# Install fprintd and libpam-fprintd
echo "Installing fprintd and libpam-fprintd..."
apt update
apt install -y fprintd libpam-fprintd

# Step 3: Enroll Fingerprint
echo "Enrolling your fingerprint. Follow the on-screen instructions..."
fprintd-enroll

# Step 4: Configure PAM for Fingerprint Authentication
echo "Configuring PAM for fingerprint authentication..."

# Add fingerprint authentication to each PAM file
for pam_file in "${PAM_FILES[@]}"; do
  if [ -f "$pam_file" ]; then
    echo "Configuring $pam_file..."
    # Backup the original file
    cp "$pam_file" "$pam_file.bak"
    # Add fingerprint authentication line
    sed -i '1i auth sufficient pam_fprintd.so' "$pam_file"
  else
    echo "File $pam_file not found. Skipping..."
  fi
done

# Step 5: Enable and Start fprintd Service
echo "Enabling and starting fprintd service..."
systemctl enable fprintd
systemctl start fprintd

# Step 6: Verify Installation
echo "Verifying fingerprint authentication setup..."

# Check if fprintd is running
if systemctl is-active --quiet fprintd; then
  echo "fprintd service is running."
else
  echo "fprintd service is not running. Please check the logs."
fi

echo "Fingerprint authentication setup complete!"
echo "You can now use your fingerprint for:"
echo "  - Terminal sudo prompts"
echo "  - Graphical login (LightDM/GDM)"
echo "  - PolicyKit authentication (e.g., unlocking BitLocker drives)"
echo "  - Other system-wide password prompts"

exit 0
