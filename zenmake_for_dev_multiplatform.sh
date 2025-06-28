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

# Create directories for each platform and architecture
echo "Setting up directories..."
mkdir -p zen-linux-x86_64-portable/{app/lin,data,launcher}
mkdir -p zen-linux-aarch64-portable/{app/lin,data,launcher}
mkdir -p zen-windows-x86_64-portable/{app/win,data,launcher}
mkdir -p zen-windows-arm64-portable/{app/win,data,launcher}
mkdir -p zen-macos-universal-portable/{app/mac,data,launcher}
mkdir -p zen-portable/{app/{lin-x86_64,lin-aarch64,win-x86_64,win-arm64,mac-universal},data,launcher}

# Create profile directories for each version
for dir in zen-linux-x86_64-portable zen-linux-aarch64-portable zen-windows-x86_64-portable zen-windows-arm64-portable zen-macos-universal-portable zen-portable; do
    for i in {1..5}; do
        mkdir -p "$dir/data/profile$i"
    done
done

# Download and extract Linux x86_64
echo "Downloading Linux x86_64 release..."
curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz" -o zen.linux-x86_64.tar.xz
echo "Extracting Linux x86_64 release..."
tar -xJvf zen.linux-x86_64.tar.xz -C zen-linux-x86_64-portable/app/lin
tar -xJvf zen.linux-x86_64.tar.xz -C zen-portable/app/lin-x86_64

# Process Linux x86_64 files
for dir in zen-linux-x86_64-portable/app/lin zen-portable/app/lin-x86_64; do
    if [ -d "$dir/zen" ]; then
        mv "$dir/zen/zen" "$dir/zen-executable"
        cp -r "$dir/zen/"* "$dir/"
        rm -rf "$dir/zen"
        mv "$dir/zen-executable" "$dir/zen"
    fi
done

# Download and extract Linux aarch64
echo "Downloading Linux aarch64 release..."
curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-aarch64.tar.xz" -o zen.linux-aarch64.tar.xz
echo "Extracting Linux aarch64 release..."
tar -xJvf zen.linux-aarch64.tar.xz -C zen-linux-aarch64-portable/app/lin
tar -xJvf zen.linux-aarch64.tar.xz -C zen-portable/app/lin-aarch64

# Process Linux aarch64 files
for dir in zen-linux-aarch64-portable/app/lin zen-portable/app/lin-aarch64; do
    if [ -d "$dir/zen" ]; then
        mv "$dir/zen/zen" "$dir/zen-executable"
        cp -r "$dir/zen/"* "$dir/"
        rm -rf "$dir/zen"
        mv "$dir/zen-executable" "$dir/zen"
    fi
done

# Download and extract Windows x86_64
echo "Downloading Windows x86_64 release..."
curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.installer.exe" -o zen.installer.exe
echo "Extracting Windows x86_64 release..."
7z x zen.installer.exe -ozen-windows-x86_64-portable/app/win
7z x zen.installer.exe -ozen-portable/app/win-x86_64

# Process Windows x86_64 files
for dir in zen-windows-x86_64-portable/app/win zen-portable/app/win-x86_64; do
    if [ -d "$dir/core" ]; then
        cp -r "$dir/core/"* "$dir/"
        rm -rf "$dir/core"
    fi
done

# Download and extract Windows ARM64
echo "Downloading Windows ARM64 release..."
curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.installer-arm64.exe" -o zen.installer-arm64.exe
echo "Extracting Windows ARM64 release..."
7z x zen.installer-arm64.exe -ozen-windows-arm64-portable/app/win
7z x zen.installer-arm64.exe -ozen-portable/app/win-arm64

# Process Windows ARM64 files
for dir in zen-windows-arm64-portable/app/win zen-portable/app/win-arm64; do
    if [ -d "$dir/core" ]; then
        cp -r "$dir/core/"* "$dir/"
        rm -rf "$dir/core"
    fi
done

# Download and extract macOS Universal
echo "Downloading macOS Universal release..."
curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.macos-universal.dmg" -o zen.macos-universal.dmg
echo "Extracting macOS Universal release..."
7z x zen.macos-universal.dmg -ozen-macos-universal-portable/app/mac
7z x zen.macos-universal.dmg -ozen-portable/app/mac-universal

# Process macOS files (if extraction was successful)
for dir in zen-macos-universal-portable/app/mac zen-portable/app/mac-universal; do
    # Find and move the .app bundle to the correct location
    if [ -d "$dir" ]; then
        find "$dir" -name "*.app" -type d | while read app_bundle; do
            if [ -n "$app_bundle" ]; then
                mv "$app_bundle" "$dir/Zen Browser.app"
                break
            fi
        done
    fi
done

# Create profile.ini for all versions
echo "Creating profile.ini..."
for dir in zen-linux-x86_64-portable zen-linux-aarch64-portable zen-windows-x86_64-portable zen-windows-arm64-portable zen-macos-universal-portable zen-portable; do
    cat <<EOF > "$dir/data/profiles.ini"
[Install4F96D1932A9F858E]
Default=Profiles/profile1
Locked=1

[Profile0]
Name=default
IsRelative=1
Path=Profiles/profile1
Default=1

[General]
StartWithLastProfile=1
Version=2
EOF
done

# Create launchers for Linux x86_64
echo "Creating launchers for Linux x86_64..."
cat <<'EOF' > zen-linux-x86_64-portable/launcher/zenlinuxportable.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZEN_DIR="$SCRIPT_DIR/../app/lin"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

cd "$ZEN_DIR"
./zen --profile "$DATA_DIR/Profiles/profile1" "$@"
EOF

chmod +x zen-linux-x86_64-portable/launcher/zenlinuxportable.sh
chmod +x zen-linux-x86_64-portable/app/lin/zen

# Create launchers for Linux aarch64
echo "Creating launchers for Linux aarch64..."
cat <<'EOF' > zen-linux-aarch64-portable/launcher/zenlinuxportable.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZEN_DIR="$SCRIPT_DIR/../app/lin"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

cd "$ZEN_DIR"
./zen --profile "$DATA_DIR/Profiles/profile1" "$@"
EOF

chmod +x zen-linux-aarch64-portable/launcher/zenlinuxportable.sh
chmod +x zen-linux-aarch64-portable/app/lin/zen

# Create launchers for Windows x86_64
echo "Creating launchers for Windows x86_64..."
cat <<'EOF' > zen-windows-x86_64-portable/launcher/zenwindowsportable.bat
@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "ZEN_DIR=%SCRIPT_DIR%..\app\win"
set "DATA_DIR=%SCRIPT_DIR%..\data"

set MOZ_LEGACY_PROFILES=1
set MOZ_ALLOW_DOWNGRADE=1

cd /d "%ZEN_DIR%"
zen.exe --profile "%DATA_DIR%\Profiles\profile1" %*
EOF

# Create launchers for Windows ARM64
echo "Creating launchers for Windows ARM64..."
cat <<'EOF' > zen-windows-arm64-portable/launcher/zenwindowsportable.bat
@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "ZEN_DIR=%SCRIPT_DIR%..\app\win"
set "DATA_DIR=%SCRIPT_DIR%..\data"

set MOZ_LEGACY_PROFILES=1
set MOZ_ALLOW_DOWNGRADE=1

cd /d "%ZEN_DIR%"
zen.exe --profile "%DATA_DIR%\Profiles\profile1" %*
EOF

# Create launchers for macOS Universal
echo "Creating launchers for macOS Universal..."
cat <<'EOF' > zen-macos-universal-portable/launcher/zenmacosportable.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZEN_DIR="$SCRIPT_DIR/../app/mac"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

open -a "$ZEN_DIR/Zen Browser.app" --args --profile "$DATA_DIR/Profiles/profile1" "$@"
EOF

chmod +x zen-macos-universal-portable/launcher/zenmacosportable.sh

# Create universal launcher
echo "Creating universal launcher..."
cat <<'EOF' > zen-portable/launcher/zenportable.sh
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

# Detect platform and architecture
UNAME_S=$(uname -s)
UNAME_M=$(uname -m)

case $UNAME_S in
    Linux*)
        case $UNAME_M in
            x86_64)
                ZEN_DIR="$SCRIPT_DIR/../app/lin-x86_64"
                cd "$ZEN_DIR"
                ./zen --profile "$DATA_DIR/Profiles/profile1" "$@"
                ;;
            aarch64|arm64)
                ZEN_DIR="$SCRIPT_DIR/../app/lin-aarch64"
                cd "$ZEN_DIR"
                ./zen --profile "$DATA_DIR/Profiles/profile1" "$@"
                ;;
            *)
                echo "Unsupported Linux architecture: $UNAME_M"
                exit 1
                ;;
        esac
        ;;
    Darwin*)
        ZEN_DIR="$SCRIPT_DIR/../app/mac-universal"
        open -a "$ZEN_DIR/Zen Browser.app" --args --profile "$DATA_DIR/Profiles/profile1" "$@"
        ;;
    *)
        echo "Unsupported platform: $UNAME_S"
        echo "For Windows, use zenportable.bat"
        exit 1
        ;;
esac
EOF

cat <<'EOF' > zen-portable/launcher/zenportable.bat
@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "DATA_DIR=%SCRIPT_DIR%..\data"

set MOZ_LEGACY_PROFILES=1
set MOZ_ALLOW_DOWNGRADE=1

REM Detect Windows architecture
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    set "ZEN_DIR=%SCRIPT_DIR%..\app\win-x86_64"
) else if "%PROCESSOR_ARCHITECTURE%"=="ARM64" (
    set "ZEN_DIR=%SCRIPT_DIR%..\app\win-arm64"
) else (
    echo Unsupported Windows architecture: %PROCESSOR_ARCHITECTURE%
    pause
    exit /b 1
)

cd /d "%ZEN_DIR%"
zen.exe --profile "%DATA_DIR%\Profiles\profile1" %*
EOF

chmod +x zen-portable/launcher/zenportable.sh

# Create README files
echo "Creating README files..."
for dir in zen-linux-x86_64-portable zen-linux-aarch64-portable zen-windows-x86_64-portable zen-windows-arm64-portable zen-macos-universal-portable; do
    case $dir in
        *linux-x86_64*)
            platform="Linux x86_64 (64-bit)"
            launcher="./launcher/zenlinuxportable.sh"
            ;;
        *linux-aarch64*)
            platform="Linux aarch64 (ARM 64-bit)"
            launcher="./launcher/zenlinuxportable.sh"
            ;;
        *windows-x86_64*)
            platform="Windows x86_64 (64-bit)"
            launcher="launcher\\zenwindowsportable.bat"
            ;;
        *windows-arm64*)
            platform="Windows ARM64"
            launcher="launcher\\zenwindowsportable.bat"
            ;;
        *macos*)
            platform="macOS Universal (Intel and Apple Silicon)"
            launcher="./launcher/zenmacosportable.sh"
            ;;
    esac
    
    cat <<EOF > "$dir/README.md"
# Zen Browser Portable - $platform

This is a portable version of Zen Browser for $platform.

## How to use

1. Run the launcher: \`$launcher\`
2. Your profile data will be stored in the \`data\` folder
3. You can copy this entire folder to any location or USB drive

## Profiles

Multiple profiles are supported. Edit \`data/profiles.ini\` to configure additional profiles.

## Requirements

- $platform
EOF
done

# Create universal README
cat <<'EOF' > zen-portable/README.md
# Zen Browser Portable - Universal

This is a universal portable version of Zen Browser that supports multiple platforms and architectures:

## Supported Platforms

### Linux:
- x86_64 (64-bit)
- aarch64 (ARM 64-bit)

### Windows:
- x86_64 (64-bit)
- ARM64

### macOS:
- Universal (Intel and Apple Silicon)

## How to use

### Linux/macOS:
Run: `./launcher/zenportable.sh`

### Windows:
Run: `launcher\zenportable.bat`

The launcher will automatically detect your platform and architecture and use the appropriate version.

## Profiles

Multiple profiles are supported. Edit `data/profiles.ini` to configure additional profiles.

Your profile data will be stored in the `data` folder, making this truly portable.
EOF

# Create zip files
echo "Creating zip files..."
zip -r zen-linux-x86_64-portable.zip zen-linux-x86_64-portable
zip -r zen-linux-aarch64-portable.zip zen-linux-aarch64-portable
zip -r zen-windows-x86_64-portable.zip zen-windows-x86_64-portable
zip -r zen-windows-arm64-portable.zip zen-windows-arm64-portable
zip -r zen-macos-universal-portable.zip zen-macos-universal-portable
zip -r zen-portable.zip zen-portable

# Clean up
echo "Cleaning up temporary files..."
rm -f zen.linux-x86_64.tar.xz zen.linux-aarch64.tar.xz zen.installer.exe zen.installer-arm64.exe zen.macos-universal.dmg
rm -rf zen-linux-x86_64-portable zen-linux-aarch64-portable zen-windows-x86_64-portable zen-windows-arm64-portable zen-macos-universal-portable zen-portable

echo "Portable Zen Browser packages created successfully!"
echo "Available files:"
echo "- zen-linux-x86_64-portable.zip (Linux x86_64)"
echo "- zen-linux-aarch64-portable.zip (Linux ARM64)"
echo "- zen-windows-x86_64-portable.zip (Windows x86_64)"
echo "- zen-windows-arm64-portable.zip (Windows ARM64)"
echo "- zen-macos-universal-portable.zip (macOS Universal)"
echo "- zen-portable.zip (Universal - all platforms)"
