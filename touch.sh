#!/bin/bash

# Function to install libinput-tools if missing
install_libinput_tools() {
    if ! command -v libinput &> /dev/null; then
        echo "libinput-tools not found. Installing..."
        sudo apt install libinput-tools -y
    fi
}

# Function to purge and reinstall input drivers
reinstall_drivers() {
    echo "Purging existing input drivers..."
    sudo apt purge xserver-xorg-input-libinput xserver-xorg-input-evdev -y
    sudo apt autoremove -y

    echo "Reinstalling input drivers..."
    sudo apt install xserver-xorg-input-libinput xserver-xorg-input-evdev -y
}

# Function to detect touchscreen device ID
detect_touchscreen_id() {
    xinput list | grep -i "touch" | awk -F'id=' '{print $2}' | awk '{print $1}'
}

# Function to configure touchscreen for tap-and-hold as secondary click
configure_touchscreen() {
    local device_id=$1
    echo "Configuring touchscreen (ID: $device_id)..."

    # Enable tap-to-click
    xinput set-prop "$device_id" "libinput Tapping Enabled" 1

    # Enable tap-and-hold for secondary click (right-click)
    xinput set-prop "$device_id" "libinput Click Method Enabled" 0 1

    # Enable natural scrolling (optional)
    xinput set-prop "$device_id" "libinput Natural Scrolling Enabled" 1

    echo "Touchscreen configured. Tap-and-hold will now act as a secondary click."
}

# Function to install notebook apps
install_notebook_app() {
    echo "Select a notebook app to install:"
    echo "1. Xournal++"
    echo "2. Joplin"
    echo "3. Rnote"
    echo "4. Notable"
    echo "5. Obsidian"
    echo "6. Write (Stylus Labs)"
    echo "7. MyScript Nebo"
    echo "8. Skip installation"
    read -p "Enter your choice (1-8): " app_choice

    case $app_choice in
        1)
            echo "Installing Xournal++..."
            sudo apt install xournalpp -y
            ;;
        2)
            echo "Installing Joplin..."
            sudo snap install joplin-desktop
            ;;
        3)
            echo "Installing Rnote..."
            flatpak install flathub com.github.flxzt.rnote -y
            ;;
        4)
            echo "Installing Notable..."
            sudo snap install notable
            ;;
        5)
            echo "Installing Obsidian..."
            sudo snap install obsidian --classic
            ;;
        6)
            echo "Installing Write (Stylus Labs)..."
            echo "Please download Write from https://www.styluslabs.com/"
            ;;
        7)
            echo "Installing MyScript Nebo..."
            echo "Please download Nebo from https://www.nebo.app/"
            ;;
        8)
            echo "Skipping notebook app installation."
            ;;
        *)
            echo "Invalid choice. Skipping notebook app installation."
            ;;
    esac
}

# Main script
echo "Welcome to the touchscreen configuration script!"

# Reinstall drivers
reinstall_drivers

# Detect touchscreen device ID
device_id=$(detect_touchscreen_id)
if [ -z "$device_id" ]; then
    echo "Touchscreen not found. Please ensure the device is connected and recognized."
    exit 1
fi

# Configure touchscreen
configure_touchscreen "$device_id"

# Prompt to install a notebook app
install_notebook_app

echo "Configuration and installation complete!"
