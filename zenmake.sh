#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install dependencies
echo "Checking for required dependencies..."

# Check for curl
if ! command_exists curl; then
    echo "curl not found, installing..."
    # Detect package manager and install curl
    if command_exists apt-get; then
        sudo apt-get install -y curl
    elif command_exists yum; then
        sudo yum install -y curl
    elif command_exists pacman; then
        sudo pacman -S --noconfirm curl
    else
        echo "Error: Unable to install curl, please install it manually."
        exit 1
    fi
fi

# Check for jq
if ! command_exists jq; then
    echo "jq not found, installing..."
    # Detect package manager and install jq
    if command_exists apt-get; then
        sudo apt-get install -y jq
    elif command_exists yum; then
        sudo yum install -y jq
    elif command_exists pacman; then
        sudo pacman -S --noconfirm jq
    else
        echo "Error: Unable to install jq, please install it manually."
        exit 1
    fi
fi

# Check for 7z
if ! command_exists 7z; then
    echo "7z (p7zip) not found, installing..."
    # Detect package manager and install 7z
    if command_exists apt-get; then
        sudo apt-get install -y p7zip-full
    elif command_exists yum; then
        sudo yum install -y p7zip
    elif command_exists pacman; then
        sudo pacman -S --noconfirm p7zip
    else
        echo "Error: Unable to install 7z, please install it manually."
        exit 1
    fi
fi

# Check for tar
if ! command_exists tar; then
    echo "tar not found, installing..."
    # Detect package manager and install tar
    if command_exists apt-get; then
        sudo apt-get install -y tar
    elif command_exists yum; then
        sudo yum install -y tar
    elif command_exists pacman; then
        sudo pacman -S --noconfirm tar
    else
        echo "Error: Unable to install tar, please install it manually."
        exit 1
    fi
fi

# Check for bzip2
if ! command_exists bzip2; then
    echo "bzip2 not found, installing..."
    # Detect package manager and install bzip2
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y bzip2
    elif command_exists yum; then
        sudo yum install -y bzip2
    elif command_exists pacman; then
        sudo pacman -S --noconfirm bzip2
    else
        echo "Error: Unable to install bzip2, please install it manually."
        exit 1
    fi
fi

# Prompt user for platform choice
echo "Select the platform(s) you want the resulting folder to support:"
echo "1) Linux"
echo "2) Windows"
echo "3) Both"
read -p "Enter the number of your choice (1, 2, or 3): " platform_choice

# Set the directory name based on user input
if [ "$platform_choice" == "1" ]; then
    output_dir="zen-linux-portable"
elif [ "$platform_choice" == "2" ]; then
    output_dir="zen-windows-portable"
else
    output_dir="zen-portable"
fi

# Set up directory structure
mkdir -p "$output_dir"/data
# Create 5 profile directories
for i in {1..5}; do
    mkdir -p "$output_dir/data/profile$i"
done
mkdir -p "$output_dir"/launcher

# Conditionally create platform-specific directories
if [ "$platform_choice" == "2" ] || [ "$platform_choice" == "3" ]; then
    mkdir -p "$output_dir"/app/win
fi
if [ "$platform_choice" == "1" ] || [ "$platform_choice" == "3" ]; then
    mkdir -p "$output_dir"/app/lin
fi

# Change into the output directory
cd "$output_dir"

# Handle platform-specific logic
if [ "$platform_choice" == "1" ] || [ "$platform_choice" == "3" ]; then
    # Download Linux release and extract it
    echo "Downloading Linux release..."
    curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.assets[] | select(.name == "zen.linux-x86_64.tar.bz2") | .browser_download_url' | xargs curl -LO
    echo "Extracting Linux release..."
    tar -xjvf zen.linux-x86_64.tar.bz2 -C app/lin

    # Preserve 'zen' executable from Linux release before removing the 'zen' folder
    echo "Handling 'zen' folder in Linux release..."
    if [ -d "app/lin/zen" ]; then
        # Move the zen executable out temporarily before copying other files
        if [ -f "app/lin/zen/zen" ]; then
            mv app/lin/zen/zen app/lin/zen-executable
        fi

        # Copy all contents from 'zen' to 'lin'
        cp -r app/lin/zen/* app/lin/

        # Remove the 'zen' folder (but the 'zen' executable was moved out already)
        rm -rf app/lin/zen

        # Restore the 'zen' executable back into 'lin'
        if [ -f "app/lin/zen-executable" ]; then
            mv app/lin/zen-executable app/lin/zen
        fi
    else
        echo "Error: 'zen' folder not found after extraction!"
        exit 1
    fi
fi

if [ "$platform_choice" == "2" ] || [ "$platform_choice" == "3" ]; then
    # Download Windows release and extract it
    echo "Downloading Windows release..."
    curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.assets[] | select(.name == "zen.installer.exe") | .browser_download_url' | xargs curl -LO
    echo "Extracting Windows release..."
    7z x zen.installer.exe -oapp/win

    # Copy contents from 'core' folder to 'win'
    echo "Copying contents from 'core' folder to 'win'..."
    if [ -d "app/win/core" ]; then
        cp -r app/win/core/* app/win/
    else
        echo "Error: 'core' folder not found after extraction!"
        exit 1
    fi
fi

# Create profile.ini with 5 profiles
echo "Creating profile.ini..."
cat <<EOF > data/profile.ini
[General]
StartWithLastProfile=1
Version=2

[Profile0]
Name=Profile1
IsRelative=1
Path=../data/profile1
Default=1

[Profile1]
Name=Profile2
IsRelative=1
Path=../data/profile2

[Profile2]
Name=Profile3
IsRelative=1
Path=../data/profile3

[Profile3]
Name=Profile4
IsRelative=1
Path=../data/profile4

[Profile4]
Name=Profile5
IsRelative=1
Path=../data/profile5
EOF

# Create Linux launcher script
if [ "$platform_choice" == "1" ] || [ "$platform_choice" == "3" ]; then
    echo "Creating Linux launcher script..."
    cat <<EOF > launcher/zenlinuxportable.sh
#!/bin/bash
APP_DIR="\$(dirname "\$0")/../app/lin"
DATA_DIR="\$(dirname "\$0")/../data"
"\$APP_DIR/zen" --profile "\$DATA_DIR/profile1" --no-remote &>/dev/null &
EOF

    # Ensure Linux launcher is executable
    chmod +x launcher/zenlinuxportable.sh
    chmod +x app/lin/zen  # Ensure the Zen executable is also executable
fi

# Create Windows launcher script
if [ "$platform_choice" == "2" ] || [ "$platform_choice" == "3" ]; then
    echo "Creating Windows launcher script..."
    cat <<EOF > launcher/zenwindowsportable.bat
@echo off
:: Set application directory
set APP_DIR=%~dp0..\app
:: Set data directory
set DATA_DIR=%~dp0..\data

:: Ensure zen.exe exists
if not exist "%APP_DIR%\win\zen.exe" (
    echo Error: zen.exe not found in "%APP_DIR%\win".
    pause
    exit /b 1
)

:: Ensure profile directory exists
if not exist "%DATA_DIR%\profile1" (
    echo Profile directory not found. Creating one at "%DATA_DIR%\profile1".
    mkdir "%DATA_DIR%\profile1"
)

:: Launch Zen Browser in portable mode
"%APP_DIR%\win\zen.exe" -profile "%DATA_DIR%\profile1" -no-remote
EOF
fi

# Clean up downloaded files
echo "Cleaning up downloaded files..."
rm -f zen.installer.exe zen.linux-x86_64.tar.bz2

# Go back to the parent directory where the output directory exists
cd ..

# Create the zip archive before cleaning up
echo "Creating the zip archive..."
zip -r "$output_dir.zip" "$output_dir"

# Clean up the output directory after zipping
rm -rf "$output_dir"

echo "Zen Portable version has been created and packaged successfully!"
