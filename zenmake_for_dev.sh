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

# Check for xz-utils
if ! command_exists xz; then
    echo "xz-utils not found, installing..."
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y xz-utils
    elif command_exists yum; then
        sudo yum install -y xz
    elif command_exists pacman; then
        sudo pacman -S --noconfirm xz
    else
        echo "Error: Unable to install xz-utils, please install it manually."
        exit 1
    fi
fi

# Download and prepare releases
echo "Downloading and preparing Zen Browser releases..."

# Create directories for each output
mkdir -p zen-linux-portable/{app/lin,data,launcher}
mkdir -p zen-windows-portable/{app/win,data,launcher}
mkdir -p zen-portable/{app/{win,lin},data,launcher}

# Create profile directories for each version
for dir in zen-linux-portable zen-windows-portable zen-portable; do
    for i in {1..5}; do
        mkdir -p "$dir/data/profile$i"
    done
done

# Download Linux release and extract it
echo "Downloading Linux release..."
curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.assets[] | select(.name == "zen.linux-x86_64.tar.xz") | .browser_download_url' | xargs curl -LO
echo "Extracting Linux release..."
tar -xJvf zen.linux-x86_64.tar.xz -C zen-linux-portable/app/lin
tar -xJvf zen.linux-x86_64.tar.xz -C zen-portable/app/lin

# Process Linux files
for dir in zen-linux-portable zen-portable; do
    if [ -d "$dir/app/lin/zen" ]; then
        mv "$dir/app/lin/zen/zen" "$dir/app/lin/zen-executable"
        cp -r "$dir/app/lin/zen/"* "$dir/app/lin/"
        rm -rf "$dir/app/lin/zen"
        mv "$dir/app/lin/zen-executable" "$dir/app/lin/zen"
    else
        echo "Error: 'zen' folder not found in Linux release!"
        exit 1
    fi
done

# Download Windows release and extract it
echo "Downloading Windows release..."
curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.assets[] | select(.name == "zen.installer.exe") | .browser_download_url' | xargs curl -LO
echo "Extracting Windows release..."
7z x zen.installer.exe -ozen-windows-portable/app/win
7z x zen.installer.exe -ozen-portable/app/win

# Process Windows files
for dir in zen-windows-portable zen-portable; do
    if [ -d "$dir/app/win/core" ]; then
        cp -r "$dir/app/win/core/"* "$dir/app/win/"
        rm -rf "$dir/app/win/core"
    else
        echo "Error: 'core' folder not found in Windows release!"
        exit 1
    fi
done

# Create profile.ini for all versions
echo "Creating profile.ini..."
for dir in zen-linux-portable zen-windows-portable zen-portable; do
    cat <<EOF > "$dir/data/profile.ini"
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
done

# Create Linux launcher
echo "Creating Linux launcher..."
cat <<EOF > zen-linux-portable/launcher/zenlinuxportable.sh
#!/bin/bash
APP_DIR="\$(dirname "\$0")/../app/lin"
DATA_DIR="\$(dirname "\$0")/../data"
"\$APP_DIR/zen" --profile "\$DATA_DIR/profile1" --no-remote &>/dev/null &
EOF

cat <<EOF > zen-portable/launcher/zenlinuxportable.sh
#!/bin/bash
APP_DIR="\$(dirname "\$0")/../app/lin"
DATA_DIR="\$(dirname "\$0")/../data"
"\$APP_DIR/zen" --profile "\$DATA_DIR/profile1" --no-remote &>/dev/null &
EOF

chmod +x zen-linux-portable/launcher/zenlinuxportable.sh
chmod +x zen-portable/launcher/zenlinuxportable.sh
chmod +x zen-linux-portable/app/lin/zen
chmod +x zen-portable/app/lin/zen

# Create Windows launcher
echo "Creating Windows launcher..."
cat <<EOF > zen-windows-portable/launcher/zenwindowsportable.bat
@echo off
set APP_DIR=%~dp0..\app
set DATA_DIR=%~dp0..\data
"%APP_DIR%\win\zen.exe" -profile "%DATA_DIR%\profile1" -no-remote
EOF

cat <<EOF > zen-portable/launcher/zenwindowsportable.bat
@echo off
set APP_DIR=%~dp0..\app
set DATA_DIR=%~dp0..\data
"%APP_DIR%\win\zen.exe" -profile "%DATA_DIR%\profile1" -no-remote
EOF

# Clean up downloaded files
echo "Cleaning up downloaded files..."
rm -f zen.installer.exe zen.linux-x86_64.tar.xz

# Create zip archives for all versions
echo "Creating zip archives..."
zip -r zen-linux-portable.zip zen-linux-portable
zip -r zen-windows-portable.zip zen-windows-portable
zip -r zen-portable.zip zen-portable

# Clean up directories after zipping
rm -rf zen-linux-portable zen-windows-portable zen-portable

echo "All Zen Portable versions have been created and packaged successfully!"
