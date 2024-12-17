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

# Set up directory structure
mkdir -p zen-portable/{app/{win,lin},data,launcher}

# Change into the zen-portable directory
cd zen-portable

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

# Download Linux release and extract it
echo "Downloading Linux release..."
curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.assets[] | select(.name == "zen.linux-specific.tar.bz2") | .browser_download_url' | xargs curl -LO
echo "Extracting Linux release..."
tar -xjvf zen.linux-specific.tar.bz2 -C app/lin

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

# Create profile and profile.ini
echo "Creating profile directory and profile.ini..."
mkdir -p data/profile
cat <<EOF > data/profile.ini
[Profile0]
Name=ZenPortable
IsRelative=1
Path=..\data\profile
Default=1
EOF

# Create Linux launcher script (zenlinuxportable.sh)
echo "Creating Linux launcher script..."
cat <<EOF > launcher/zenlinuxportable.sh
#!/bin/bash
APP_DIR="\$(dirname "\$0")/../app/lin"
DATA_DIR="\$(dirname "\$0")/../data"
"\$APP_DIR/zen" --profile "\$DATA_DIR/profile" --no-remote &>/dev/null &
EOF

# Ensure Linux launcher is executable
chmod +x launcher/zenlinuxportable.sh
chmod +x app/lin/zen  # Ensure the Zen executable is also executable

# Create Windows launcher script (zenwindowsportable.bat)
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

:: Ensure profile directory exists, or create it
if not exist "%DATA_DIR%\profile" (
    echo Profile directory not found. Creating one at "%DATA_DIR%\profile".
    mkdir "%DATA_DIR%\profile"
)

:: Launch Zen Browser in portable mode
"%APP_DIR%\win\zen.exe" -profile "%DATA_DIR%\profile" -no-remote
EOF

# Clean up downloaded files
echo "Cleaning up downloaded files..."
rm -f zen.installer.exe zen.linux-specific.tar.bz2

echo "Zen Portable setup is complete!"
