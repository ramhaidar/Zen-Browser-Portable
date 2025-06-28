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

# Prompt user for platform choice
echo "Select the platform(s) you want the resulting folder to support:"
echo "1) Linux only"
echo "2) Windows only"
echo "3) macOS only"
echo "4) All platforms (Linux, Windows, macOS)"
read -p "Enter the number of your choice (1, 2, 3, or 4): " platform_choice

# Download and prepare releases
echo "Downloading and preparing Zen Browser releases..."

# Create directories based on user choice
case $platform_choice in
    1)
        # Linux only
        mkdir -p zen-linux-portable/{app/lin,data,launcher}
        for i in {1..5}; do
            mkdir -p zen-linux-portable/data/profile$i
        done
        ;;
    2)
        # Windows only
        mkdir -p zen-windows-portable/{app/win,data,launcher}
        for i in {1..5}; do
            mkdir -p zen-windows-portable/data/profile$i
        done
        ;;
    3)
        # macOS only
        mkdir -p zen-macos-portable/{app/mac,data,launcher}
        for i in {1..5}; do
            mkdir -p zen-macos-portable/data/profile$i
        done
        ;;
    4)
        # All platforms (Linux, Windows, macOS)
        mkdir -p zen-linux-x86_64-portable/{app/lin,data,launcher}
        mkdir -p zen-linux-aarch64-portable/{app/lin,data,launcher}
        mkdir -p zen-windows-x86_64-portable/{app/win,data,launcher}
        mkdir -p zen-windows-arm64-portable/{app/win,data,launcher}
        mkdir -p zen-macos-universal-portable/{app/mac,data,launcher}
        mkdir -p zen-portable/{app/{lin-x86_64,lin-aarch64,win-x86_64,win-arm64,mac-universal},data,launcher}
        
        for dir in zen-linux-x86_64-portable zen-linux-aarch64-portable zen-windows-x86_64-portable zen-windows-arm64-portable zen-macos-universal-portable zen-portable; do
            for i in {1..5}; do
                mkdir -p "$dir/data/profile$i"
            done
        done
        ;;
    *)
        echo "Invalid choice. Defaulting to all platforms."
        platform_choice=4
        mkdir -p zen-linux-x86_64-portable/{app/lin,data,launcher}
        mkdir -p zen-linux-aarch64-portable/{app/lin,data,launcher}
        mkdir -p zen-windows-x86_64-portable/{app/win,data,launcher}
        mkdir -p zen-windows-arm64-portable/{app/win,data,launcher}
        mkdir -p zen-macos-universal-portable/{app/mac,data,launcher}
        mkdir -p zen-portable/{app/{lin-x86_64,lin-aarch64,win-x86_64,win-arm64,mac-universal},data,launcher}
        
        for dir in zen-linux-x86_64-portable zen-linux-aarch64-portable zen-windows-x86_64-portable zen-windows-arm64-portable zen-macos-universal-portable zen-portable; do
            for i in {1..5}; do
                mkdir -p "$dir/data/profile$i"
            done
        done
        ;;
esac

# Download and extract based on platform choice
if [ "$platform_choice" == "1" ] || [ "$platform_choice" == "4" ]; then
    # Download Linux x86_64 release
    echo "Downloading Linux x86_64 release..."
    curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.assets[] | select(.name == "zen.linux-x86_64.tar.xz") | .browser_download_url' | xargs curl -LO
    echo "Extracting Linux x86_64 release..."
    
    case $platform_choice in
        1)
            tar -xJvf zen.linux-x86_64.tar.xz -C zen-linux-portable/app/lin
            ;;
        4)
            tar -xJvf zen.linux-x86_64.tar.xz -C zen-linux-x86_64-portable/app/lin
            tar -xJvf zen.linux-x86_64.tar.xz -C zen-portable/app/lin-x86_64
            ;;
    esac
    
    # Process Linux x86_64 files
    case $platform_choice in
        1)
            dirs="zen-linux-portable"
            ;;
        4)
            dirs="zen-linux-x86_64-portable zen-portable"
            ;;
    esac
    
    for dir in $dirs; do
        lin_path=""
        case $dir in
            *portable)
                if [ "$platform_choice" == "4" ] && [ "$dir" == "zen-portable" ]; then
                    lin_path="$dir/app/lin-x86_64"
                else
                    lin_path="$dir/app/lin"
                fi
                ;;
        esac
        
        if [ -n "$lin_path" ] && [ -d "$lin_path/zen" ]; then
            mv "$lin_path/zen/zen" "$lin_path/zen-executable"
            cp -r "$lin_path/zen/"* "$lin_path/"
            rm -rf "$lin_path/zen"
            mv "$lin_path/zen-executable" "$lin_path/zen"
        fi
    done
fi

if [ "$platform_choice" == "4" ]; then
    # Download Linux aarch64 release
    echo "Downloading Linux aarch64 release..."
    curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-aarch64.tar.xz" -o zen.linux-aarch64.tar.xz
    echo "Extracting Linux aarch64 release..."
    tar -xJvf zen.linux-aarch64.tar.xz -C zen-linux-aarch64-portable/app/lin
    tar -xJvf zen.linux-aarch64.tar.xz -C zen-portable/app/lin-aarch64
    
    # Process Linux aarch64 files
    for dir in zen-linux-aarch64-portable zen-portable; do
        if [ "$dir" == "zen-portable" ]; then
            lin_path="$dir/app/lin-aarch64"
        else
            lin_path="$dir/app/lin"
        fi
        
        if [ -d "$lin_path/zen" ]; then
            mv "$lin_path/zen/zen" "$lin_path/zen-executable"
            cp -r "$lin_path/zen/"* "$lin_path/"
            rm -rf "$lin_path/zen"
            mv "$lin_path/zen-executable" "$lin_path/zen"
        fi
    done
fi

if [ "$platform_choice" == "2" ] || [ "$platform_choice" == "4" ]; then
    # Download Windows x86_64 release
    echo "Downloading Windows x86_64 release..."
    curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.assets[] | select(.name == "zen.installer.exe") | .browser_download_url' | xargs curl -LO
    echo "Extracting Windows x86_64 release..."
    
    case $platform_choice in
        2)
            7z x zen.installer.exe -ozen-windows-portable/app/win
            ;;
        4)
            7z x zen.installer.exe -ozen-windows-x86_64-portable/app/win
            7z x zen.installer.exe -ozen-portable/app/win-x86_64
            ;;
    esac
    
    # Process Windows x86_64 files
    case $platform_choice in
        2)
            dirs="zen-windows-portable"
            ;;
        4)
            dirs="zen-windows-x86_64-portable zen-portable"
            ;;
    esac
    
    for dir in $dirs; do
        win_path=""
        case $dir in
            *portable)
                if [ "$platform_choice" == "4" ] && [ "$dir" == "zen-portable" ]; then
                    win_path="$dir/app/win-x86_64"
                else
                    win_path="$dir/app/win"
                fi
                ;;
        esac
        
        if [ -n "$win_path" ] && [ -d "$win_path/core" ]; then
            cp -r "$win_path/core/"* "$win_path/"
            rm -rf "$win_path/core"
        fi
    done
fi

if [ "$platform_choice" == "3" ] || [ "$platform_choice" == "4" ]; then
    # Download macOS Universal release
    echo "Downloading macOS Universal release..."
    curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.macos-universal.dmg" -o zen.macos-universal.dmg
    echo "Extracting macOS Universal release..."
    
    case $platform_choice in
        3)
            7z x zen.macos-universal.dmg -ozen-macos-portable/app/mac
            ;;
        4)
            7z x zen.macos-universal.dmg -ozen-macos-universal-portable/app/mac
            7z x zen.macos-universal.dmg -ozen-portable/app/mac-universal
            ;;
    esac
    
    # Process macOS files
    case $platform_choice in
        3)
            dirs="zen-macos-portable"
            ;;
        4)
            dirs="zen-macos-universal-portable zen-portable"
            ;;
    esac
    
    for dir in $dirs; do
        mac_path=""
        case $dir in
            *portable)
                if [ "$platform_choice" == "4" ] && [ "$dir" == "zen-portable" ]; then
                    mac_path="$dir/app/mac-universal"
                else
                    mac_path="$dir/app/mac"
                fi
                ;;
        esac
        
        if [ -n "$mac_path" ] && [ -d "$mac_path" ]; then
            find "$mac_path" -name "*.app" -type d | while read app_bundle; do
                if [ -n "$app_bundle" ]; then
                    mv "$app_bundle" "$mac_path/Zen Browser.app"
                    break
                fi
            done
        fi
    done
fi

if [ "$platform_choice" == "4" ]; then
    # Download Windows ARM64 release
    echo "Downloading Windows ARM64 release..."
    curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.installer-arm64.exe" -o zen.installer-arm64.exe
    echo "Extracting Windows ARM64 release..."
    7z x zen.installer-arm64.exe -ozen-windows-arm64-portable/app/win
    7z x zen.installer-arm64.exe -ozen-portable/app/win-arm64
    
    # Process Windows ARM64 files
    for dir in zen-windows-arm64-portable zen-portable; do
        if [ "$dir" == "zen-portable" ]; then
            win_path="$dir/app/win-arm64"
        else
            win_path="$dir/app/win"
        fi
        
        if [ -d "$win_path/core" ]; then
            cp -r "$win_path/core/"* "$win_path/"
            rm -rf "$win_path/core"
        fi
    done
    
    # Download macOS Universal release
    echo "Downloading macOS Universal release..."
    curl -L "https://github.com/zen-browser/desktop/releases/latest/download/zen.macos-universal.dmg" -o zen.macos-universal.dmg
    echo "Extracting macOS Universal release..."
    7z x zen.macos-universal.dmg -ozen-macos-universal-portable/app/mac
    7z x zen.macos-universal.dmg -ozen-portable/app/mac-universal
    
    # Process macOS files
    for dir in zen-macos-universal-portable zen-portable; do
        if [ "$dir" == "zen-portable" ]; then
            mac_path="$dir/app/mac-universal"
        else
            mac_path="$dir/app/mac"
        fi
        
        if [ -d "$mac_path" ]; then
            find "$mac_path" -name "*.app" -type d | while read app_bundle; do
                if [ -n "$app_bundle" ]; then
                    mv "$app_bundle" "$mac_path/Zen Browser.app"
                    break
                fi
            done
        fi
    done
fi

# Create profiles.ini for all created directories
echo "Creating profiles.ini..."
case $platform_choice in
    1)
        dirs="zen-linux-portable"
        ;;
    2)
        dirs="zen-windows-portable"
        ;;
    3)
        dirs="zen-macos-portable"
        ;;
    4)
        dirs="zen-linux-x86_64-portable zen-linux-aarch64-portable zen-windows-x86_64-portable zen-windows-arm64-portable zen-macos-universal-portable zen-portable"
        ;;
esac

for dir in $dirs; do
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

# Create launchers
echo "Creating launchers..."

case $platform_choice in
    1|4)
        # Create Linux launchers
        case $platform_choice in
            1)
                linux_dirs="zen-linux-portable"
                ;;
            4)
                linux_dirs="zen-linux-x86_64-portable zen-linux-aarch64-portable zen-portable"
                ;;
        esac
        
        for dir in $linux_dirs; do
            cat <<'EOF' > "$dir/launcher/zenlinuxportable.sh"
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

if [ -d "$SCRIPT_DIR/../app/lin" ]; then
    ZEN_DIR="$SCRIPT_DIR/../app/lin"
elif [ -d "$SCRIPT_DIR/../app/lin-x86_64" ]; then
    ZEN_DIR="$SCRIPT_DIR/../app/lin-x86_64"
else
    echo "Error: Linux Zen executable not found"
    exit 1
fi

cd "$ZEN_DIR"
./zen --profile "$DATA_DIR/Profiles/profile1" "$@"
EOF
            chmod +x "$dir/launcher/zenlinuxportable.sh"
            
            # Make zen executable
            if [ -f "$dir/app/lin/zen" ]; then
                chmod +x "$dir/app/lin/zen"
            fi
            if [ -f "$dir/app/lin-x86_64/zen" ]; then
                chmod +x "$dir/app/lin-x86_64/zen"
            fi
            if [ -f "$dir/app/lin-aarch64/zen" ]; then
                chmod +x "$dir/app/lin-aarch64/zen"
            fi
        done
        ;;
esac

case $platform_choice in
    2|4)
        # Create Windows launchers
        case $platform_choice in
            2)
                windows_dirs="zen-windows-portable"
                ;;
            4)
                windows_dirs="zen-windows-x86_64-portable zen-windows-arm64-portable zen-portable"
                ;;
        esac
        
        for dir in $windows_dirs; do
            cat <<'EOF' > "$dir/launcher/zenwindowsportable.bat"
@echo off
setlocal
set "SCRIPT_DIR=%~dp0"
set "DATA_DIR=%SCRIPT_DIR%..\data"

set MOZ_LEGACY_PROFILES=1
set MOZ_ALLOW_DOWNGRADE=1

if exist "%SCRIPT_DIR%..\app\win\zen.exe" (
    set "ZEN_DIR=%SCRIPT_DIR%..\app\win"
) else if exist "%SCRIPT_DIR%..\app\win-x86_64\zen.exe" (
    set "ZEN_DIR=%SCRIPT_DIR%..\app\win-x86_64"
) else if exist "%SCRIPT_DIR%..\app\win-arm64\zen.exe" (
    set "ZEN_DIR=%SCRIPT_DIR%..\app\win-arm64"
) else (
    echo Error: Windows Zen executable not found
    pause
    exit /b 1
)

cd /d "%ZEN_DIR%"
zen.exe --profile "%DATA_DIR%\Profiles\profile1" %*
EOF
        done
        ;;
esac

if [ "$platform_choice" == "3" ] || [ "$platform_choice" == "4" ]; then
    # Create macOS launchers
    case $platform_choice in
        3)
            macos_dirs="zen-macos-portable"
            ;;
        4)
            macos_dirs="zen-macos-universal-portable zen-portable"
            ;;
    esac
    
    for dir in $macos_dirs; do
        if [ "$dir" == "zen-portable" ]; then
            # This will be handled by the universal launcher below
            continue
        fi
        
        cat <<'EOF' > "$dir/launcher/zenmacosportable.sh"
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZEN_DIR="$SCRIPT_DIR/../app/mac"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

open -a "$ZEN_DIR/Zen Browser.app" --args --profile "$DATA_DIR/Profiles/profile1" "$@"
EOF
        chmod +x "$dir/launcher/zenmacosportable.sh"
    done
fi

if [ "$platform_choice" == "4" ]; then
    # Create macOS launcher
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
    
    # Create universal launcher for zen-portable
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
fi

# Create README files
echo "Creating README files..."
case $platform_choice in
    1)
        cat <<EOF > zen-linux-portable/README.md
# Zen Browser Portable - Linux

This is a portable version of Zen Browser for Linux x86_64.

## How to use

1. Run the launcher: \`./launcher/zenlinuxportable.sh\`
2. Your profile data will be stored in the \`data\` folder
3. You can copy this entire folder to any location or USB drive

## Profiles

Multiple profiles are supported. Edit \`data/profiles.ini\` to configure additional profiles.

## Requirements

- Linux x86_64 (64-bit)
EOF
        ;;
    2)
        cat <<EOF > zen-windows-portable/README.md
# Zen Browser Portable - Windows

This is a portable version of Zen Browser for Windows x86_64.

## How to use

1. Run the launcher: \`launcher\\zenwindowsportable.bat\`
2. Your profile data will be stored in the \`data\` folder
3. You can copy this entire folder to any location or USB drive

## Profiles

Multiple profiles are supported. Edit \`data/profiles.ini\` to configure additional profiles.

## Requirements

- Windows x86_64 (64-bit)
EOF
        ;;
    3)
        cat <<EOF > zen-macos-portable/README.md
# Zen Browser Portable - macOS Universal

This is a portable version of Zen Browser for macOS Universal (Intel and Apple Silicon).

## How to use

1. Run the launcher: \`./launcher/zenmacosportable.sh\`
2. Your profile data will be stored in the \`data\` folder
3. You can copy this entire folder to any location or USB drive

## Profiles

Multiple profiles are supported. Edit \`data/profiles.ini\` to configure additional profiles.

## Requirements

- macOS Universal (Intel and Apple Silicon)
EOF
        ;;
    4)
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
        ;;
esac

# Clean up downloaded files
echo "Cleaning up downloaded files..."
rm -f zen.installer.exe zen.linux-x86_64.tar.xz zen.linux-aarch64.tar.xz zen.installer-arm64.exe zen.macos-universal.dmg

# Create zip files with maximum compression
echo "Creating zip files with maximum compression..."
case $platform_choice in
    1)
        zip -9 -r zen-linux-portable.zip zen-linux-portable
        rm -rf zen-linux-portable
        echo "Zen Linux Portable package created successfully!"
        echo "Available file: zen-linux-portable.zip"
        ;;
    2)
        zip -9 -r zen-windows-portable.zip zen-windows-portable
        rm -rf zen-windows-portable
        echo "Zen Windows Portable package created successfully!"
        echo "Available file: zen-windows-portable.zip"
        ;;
    3)
        zip -9 -r zen-macos-portable.zip zen-macos-portable
        rm -rf zen-macos-portable
        echo "Zen macOS Portable package created successfully!"
        echo "Available file: zen-macos-portable.zip"
        ;;
    4)
        zip -9 -r zen-linux-x86_64-portable.zip zen-linux-x86_64-portable
        zip -9 -r zen-linux-aarch64-portable.zip zen-linux-aarch64-portable
        zip -9 -r zen-windows-x86_64-portable.zip zen-windows-x86_64-portable
        zip -9 -r zen-windows-arm64-portable.zip zen-windows-arm64-portable
        zip -9 -r zen-macos-universal-portable.zip zen-macos-universal-portable
        zip -9 -r zen-portable.zip zen-portable
        rm -rf zen-linux-x86_64-portable zen-linux-aarch64-portable zen-windows-x86_64-portable zen-windows-arm64-portable zen-macos-universal-portable zen-portable
        echo "Portable Zen Browser packages created successfully!"
        echo "Available files:"
        echo "- zen-linux-x86_64-portable.zip (Linux x86_64)"
        echo "- zen-linux-aarch64-portable.zip (Linux ARM64)"
        echo "- zen-windows-x86_64-portable.zip (Windows x86_64)"
        echo "- zen-windows-arm64-portable.zip (Windows ARM64)"
        echo "- zen-macos-universal-portable.zip (macOS Universal)"
        echo "- zen-portable.zip (Universal - all platforms)"
        ;;
esac
