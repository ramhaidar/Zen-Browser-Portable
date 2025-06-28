# Zen Browser Portable Maker - PowerShell Version (Interactive)
# Interactive script to build Zen Browser portable packages

param(
    [string]$Version = ""
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Zen Browser Portable Maker" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to get latest version from GitHub API
function Get-LatestVersion {
    try {
        Write-Host "Fetching latest Zen Browser version..." -ForegroundColor Yellow
        $response = Invoke-RestMethod -Uri "https://api.github.com/repos/zen-browser/desktop/releases/latest" -UserAgent "Mozilla/5.0"
        $latestVersion = $response.tag_name
        Write-Host "Latest version: $latestVersion" -ForegroundColor Green
        return $latestVersion
    }
    catch {
        Write-Host "Failed to fetch latest version: $_" -ForegroundColor Red
        Write-Host "Falling back to hardcoded version: 1.13.2b" -ForegroundColor Yellow
        return "1.13.2b"
    }
}

# Get version to use
if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = Get-LatestVersion
}
else {
    Write-Host "Using specified version: $Version" -ForegroundColor Green
}

# Prompt user for platform choice
Write-Host "Select the platform(s) you want the resulting folder to support:" -ForegroundColor Cyan
Write-Host "1) Linux x86_64 only" -ForegroundColor White
Write-Host "2) Linux aarch64 only" -ForegroundColor White
Write-Host "3) Windows x86_64 only" -ForegroundColor White
Write-Host "4) Windows ARM64 only" -ForegroundColor White
Write-Host "5) macOS Universal only" -ForegroundColor White
Write-Host "6) All platforms (Linux, Windows, macOS)" -ForegroundColor White
Write-Host ""

do {
    $platformChoice = Read-Host "Enter the number of your choice (1-6)"
} while ($platformChoice -notmatch "^[1-6]$")

# Define platform configurations based on choice
$selectedPlatforms = @{}
$outputDirs = @()

switch ($platformChoice) {
    "1" {
        $selectedPlatforms["zen-linux-x86_64-portable"] = @{
            "archive"         = "zen-linux-x86_64.tar.xz"
            "download_url"    = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.linux-x86_64.tar.xz"
            "app_dir"         = "lin-x86_64"
            "launcher_script" = "zenlinuxportable.sh"
        }
        $outputDirs = @("zen-linux-x86_64-portable")
    }
    "2" {
        $selectedPlatforms["zen-linux-aarch64-portable"] = @{
            "archive"         = "zen-linux-aarch64.tar.xz"
            "download_url"    = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.linux-aarch64.tar.xz"
            "app_dir"         = "lin-aarch64"
            "launcher_script" = "zenlinuxportable.sh"
        }
        $outputDirs = @("zen-linux-aarch64-portable")
    }
    "3" {
        $selectedPlatforms["zen-windows-x86_64-portable"] = @{
            "archive"        = "zen-windows-x86_64.exe"
            "download_url"   = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.installer.exe"
            "app_dir"        = "win-x86_64"
            "launcher_batch" = "zenwindowsportable.bat"
        }
        $outputDirs = @("zen-windows-x86_64-portable")
    }
    "4" {
        $selectedPlatforms["zen-windows-arm64-portable"] = @{
            "archive"        = "zen-windows-arm64.exe"
            "download_url"   = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.installer-arm64.exe"
            "app_dir"        = "win-arm64"
            "launcher_batch" = "zenwindowsportable.bat"
        }
        $outputDirs = @("zen-windows-arm64-portable")
    }
    "5" {
        $selectedPlatforms["zen-macos-universal-portable"] = @{
            "archive"         = "zen-macos-universal.dmg"
            "download_url"    = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.macos-universal.dmg"
            "app_dir"         = "mac-universal"
            "launcher_script" = "zenmacosportable.sh"
        }
        $outputDirs = @("zen-macos-universal-portable")
    }
    "6" {
        $selectedPlatforms = @{
            "zen-linux-x86_64-portable"    = @{
                "archive"         = "zen-linux-x86_64.tar.xz"
                "download_url"    = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.linux-x86_64.tar.xz"
                "app_dir"         = "lin-x86_64"
                "launcher_script" = "zenlinuxportable.sh"
            }
            "zen-linux-aarch64-portable"   = @{
                "archive"         = "zen-linux-aarch64.tar.xz"
                "download_url"    = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.linux-aarch64.tar.xz"
                "app_dir"         = "lin-aarch64"
                "launcher_script" = "zenlinuxportable.sh"
            }
            "zen-windows-x86_64-portable"  = @{
                "archive"        = "zen-windows-x86_64.exe"
                "download_url"   = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.installer.exe"
                "app_dir"        = "win-x86_64"
                "launcher_batch" = "zenwindowsportable.bat"
            }
            "zen-windows-arm64-portable"   = @{
                "archive"        = "zen-windows-arm64.exe"
                "download_url"   = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.installer-arm64.exe"
                "app_dir"        = "win-arm64"
                "launcher_batch" = "zenwindowsportable.bat"
            }
            "zen-macos-universal-portable" = @{
                "archive"         = "zen-macos-universal.dmg"
                "download_url"    = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.macos-universal.dmg"
                "app_dir"         = "mac-universal"
                "launcher_script" = "zenmacosportable.sh"
            }
        }
        $outputDirs = @("zen-linux-x86_64-portable", "zen-linux-aarch64-portable", "zen-windows-x86_64-portable", "zen-windows-arm64-portable", "zen-macos-universal-portable", "zen-portable")
    }
}

Write-Host ""
Write-Host "Selected platforms:" -ForegroundColor Green
$selectedPlatforms.Keys | ForEach-Object {
    Write-Host "  - $_" -ForegroundColor White
}
Write-Host ""

# Clean up any existing directories
Write-Host "Cleaning up existing directories..." -ForegroundColor Yellow
$outputDirs | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Recurse -Force
        Write-Host "Removed existing directory: $_" -ForegroundColor Gray
    }
}

# Create directory structure for selected platforms
Write-Host "Creating directory structure..." -ForegroundColor Green
$selectedPlatforms.Keys | ForEach-Object {
    $config = $selectedPlatforms[$_]
    New-Item -ItemType Directory -Path "$_\app\$($config.app_dir)" -Force | Out-Null
    New-Item -ItemType Directory -Path "$_\data\Profiles\profile1" -Force | Out-Null
    New-Item -ItemType Directory -Path "$_\launcher" -Force | Out-Null
    Write-Host "Created directory structure for: $_" -ForegroundColor Gray
}

# Create universal portable structure if all platforms selected
if ($platformChoice -eq "6") {
    New-Item -ItemType Directory -Path "zen-portable\app\lin-x86_64" -Force | Out-Null
    New-Item -ItemType Directory -Path "zen-portable\app\lin-aarch64" -Force | Out-Null
    New-Item -ItemType Directory -Path "zen-portable\app\win-x86_64" -Force | Out-Null
    New-Item -ItemType Directory -Path "zen-portable\app\win-arm64" -Force | Out-Null
    New-Item -ItemType Directory -Path "zen-portable\app\mac-universal" -Force | Out-Null
    New-Item -ItemType Directory -Path "zen-portable\data\Profiles\profile1" -Force | Out-Null
    New-Item -ItemType Directory -Path "zen-portable\launcher" -Force | Out-Null
    Write-Host "Created universal portable structure" -ForegroundColor Gray
}

# Function to download files with retry logic
function Invoke-FileDownloadWithRetry {
    param(
        [string]$Url,
        [string]$OutFile,
        [int]$MaxRetries = 3,
        [int]$DelaySeconds = 5
    )
    
    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        try {
            Write-Host "  Attempt $attempt of $MaxRetries..." -ForegroundColor Gray
            
            # Create a more robust web request with better settings
            $progressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $Url -OutFile $OutFile -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" -TimeoutSec 300 -MaximumRedirection 5
            
            Write-Host "  Successfully downloaded: $OutFile" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "  Attempt $attempt failed: $($_.Exception.Message)" -ForegroundColor Red
            
            if ($attempt -lt $MaxRetries) {
                Write-Host "  Retrying in $DelaySeconds seconds..." -ForegroundColor Yellow
                Start-Sleep -Seconds $DelaySeconds
            }
            else {
                Write-Host "  All retry attempts failed" -ForegroundColor Red
            }
        }
    }
    return $false
}

# Download required files
Write-Host "Downloading Zen Browser releases..." -ForegroundColor Green
$skippedFiles = @()

# Collect unique archives to download
$uniqueArchives = @{}
$selectedPlatforms.Values | ForEach-Object {
    $uniqueArchives[$_.archive] = $_.download_url
}

foreach ($archive in $uniqueArchives.Keys) {
    if (-not (Test-Path $archive)) {
        Write-Host "Downloading $archive..." -ForegroundColor Yellow
        
        $success = Invoke-FileDownloadWithRetry -Url $uniqueArchives[$archive] -OutFile $archive
        
        if (-not $success) {
            Write-Host "Failed to download $archive after all retries." -ForegroundColor Red
            $skippedFiles += $archive
        }
    }
    else {
        Write-Host "Using existing: $archive" -ForegroundColor Gray
    }
}

# Function to extract archives
function Expand-ArchiveFile {
    param($Archive, $Destination)
    
    Write-Host "Extracting $Archive to $Destination..." -ForegroundColor Yellow
    
    if ($Archive.EndsWith(".tar.xz")) {
        # Use 7z for .tar.xz files
        $tempDir = "$env:TEMP\zen_extract_$(Get-Random)"
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
        try {
            # Extract .tar.xz in two steps
            & "7z" x "$Archive" -o"$tempDir" -y | Out-Null
            $tarFile = Get-ChildItem -Path $tempDir -Filter "*.tar" | Select-Object -First 1
            if ($tarFile) {
                & "7z" x "$($tarFile.FullName)" -o"$Destination" -y | Out-Null
                
                # Handle zen folder structure for Linux
                $zenDir = Join-Path $Destination "zen"
                if (Test-Path $zenDir) {
                    # Move zen executable temporarily
                    $zenExe = Join-Path $zenDir "zen"
                    $tempZenExe = Join-Path $Destination "zen-temp-exe"
                    if (Test-Path $zenExe) {
                        Move-Item $zenExe $tempZenExe -Force
                    }
                    
                    # Move all contents from zen folder to parent
                    Get-ChildItem -Path $zenDir | ForEach-Object {
                        Move-Item $_.FullName $Destination -Force
                    }
                    
                    # Remove zen folder and restore executable
                    Remove-Item $zenDir -Force
                    if (Test-Path $tempZenExe) {
                        Move-Item $tempZenExe (Join-Path $Destination "zen") -Force
                    }
                }
            }
        }
        finally {
            if (Test-Path $tempDir) {
                Remove-Item $tempDir -Recurse -Force
            }
        }
    }
    elseif ($Archive.EndsWith(".exe")) {
        # Extract Windows installer
        & "7z" x "$Archive" -o"$Destination" -y | Out-Null
        
        # Process Windows files - move files from core subdirectory if it exists
        $coreDir = Join-Path $Destination "core"
        if (Test-Path $coreDir) {
            Get-ChildItem -Path $coreDir | ForEach-Object {
                Move-Item $_.FullName $Destination -Force
            }
            Remove-Item $coreDir -Force
        }
    }
    elseif ($Archive.EndsWith(".dmg")) {
        Write-Host "  Note: Extraction warnings for macOS DMG files are normal and can be ignored" -ForegroundColor DarkYellow
        & "7z" x "$Archive" -o"$Destination" -y 2>$null
        
        # Find and rename the .app bundle
        $appBundle = Get-ChildItem -Path $Destination -Filter "*.app" -Recurse | Select-Object -First 1
        if ($appBundle) {
            $targetPath = Join-Path $Destination "Zen Browser.app"
            if ($appBundle.FullName -ne $targetPath) {
                Move-Item $appBundle.FullName $targetPath -Force
            }
        }
    }
}

# Extract archives for successfully downloaded files
Write-Host "Extracting archives..." -ForegroundColor Green
$extractedPlatforms = @()

foreach ($platform in $selectedPlatforms.Keys) {
    $config = $selectedPlatforms[$platform]
    $archive = $config.archive
    $appDir = "$platform\app\$($config.app_dir)"
    
    # Check if the archive file exists and wasn't skipped
    if ((Test-Path $archive) -and ($archive -notin $skippedFiles)) {
        Write-Host "Extracting for $platform..." -ForegroundColor Yellow
        try {
            Expand-ArchiveFile -Archive $archive -Destination $appDir
            $extractedPlatforms += $platform
            
            # Also extract to universal folder if all platforms selected
            if ($platformChoice -eq "6") {
                $universalAppDir = "zen-portable\app\$($config.app_dir)"
                Expand-ArchiveFile -Archive $archive -Destination $universalAppDir
            }
        }
        catch {
            Write-Host "Failed to extract $archive for $platform`: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "Archive $archive not available. Skipping $platform..." -ForegroundColor Yellow
    }
}

# Create profiles.ini
Write-Host "Creating profiles.ini..." -ForegroundColor Green
$profilesIni = @"
[Profile0]
Name=profile1
IsRelative=1
Path=Profiles/profile1
Default=1

[General]
StartWithLastProfile=1
Version=2
"@

foreach ($platform in $extractedPlatforms) {
    $profilesIni | Out-File -FilePath "$platform\data\profiles.ini" -Encoding ASCII
}

# Create universal profiles.ini if all platforms selected and we have extractions
if (($platformChoice -eq "6") -and ($extractedPlatforms.Count -gt 0)) {
    $profilesIni | Out-File -FilePath "zen-portable\data\profiles.ini" -Encoding ASCII
}

# Create launchers
Write-Host "Creating launchers..." -ForegroundColor Green

# Linux launcher script
$linuxLauncher = @'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

if [ -d "$SCRIPT_DIR/../app/lin" ]; then
    ZEN_DIR="$SCRIPT_DIR/../app/lin"
elif [ -d "$SCRIPT_DIR/../app/lin-x86_64" ]; then
    ZEN_DIR="$SCRIPT_DIR/../app/lin-x86_64"
elif [ -d "$SCRIPT_DIR/../app/lin-aarch64" ]; then
    ZEN_DIR="$SCRIPT_DIR/../app/lin-aarch64"
else
    echo "Error: Linux Zen executable not found"
    exit 1
fi

cd "$ZEN_DIR"
./zen --profile "$DATA_DIR/Profiles/profile1" "$@"
'@

# Windows launcher batch
$windowsLauncher = @'
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
'@

# macOS launcher script
$macosLauncher = @'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

if [ -d "$SCRIPT_DIR/../app/mac" ]; then
    ZEN_DIR="$SCRIPT_DIR/../app/mac"
elif [ -d "$SCRIPT_DIR/../app/mac-universal" ]; then
    ZEN_DIR="$SCRIPT_DIR/../app/mac-universal"
else
    echo "Error: macOS Zen app not found"
    exit 1
fi

open -a "$ZEN_DIR/Zen Browser.app" --args --profile "$DATA_DIR/Profiles/profile1" "$@"
'@

# Universal launcher script
$universalLauncher = @'
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
                ;;
            aarch64)
                ZEN_DIR="$SCRIPT_DIR/../app/lin-aarch64"
                ;;
            *)
                echo "Unsupported Linux architecture: $UNAME_M"
                exit 1
                ;;
        esac
        cd "$ZEN_DIR"
        ./zen --profile "$DATA_DIR/Profiles/profile1" "$@"
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
'@

# Universal Windows launcher
$universalWindowsLauncher = @'
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
'@

# Create platform-specific launchers for successfully extracted platforms
foreach ($platform in $extractedPlatforms) {
    $config = $selectedPlatforms[$platform]
    
    Write-Host "Creating launchers for $platform..." -ForegroundColor Yellow
    
    if ($config.ContainsKey("launcher_script")) {
        if ($platform.Contains("linux")) {
            $linuxLauncher | Out-File -FilePath "$platform\launcher\$($config.launcher_script)" -Encoding ASCII
        }
        elseif ($platform.Contains("macos")) {
            $macosLauncher | Out-File -FilePath "$platform\launcher\$($config.launcher_script)" -Encoding ASCII
        }
    }
    
    if ($config.ContainsKey("launcher_batch")) {
        $windowsLauncher | Out-File -FilePath "$platform\launcher\$($config.launcher_batch)" -Encoding ASCII
    }
}

# Create universal launchers if all platforms selected and we have extractions
if (($platformChoice -eq "6") -and ($extractedPlatforms.Count -gt 0)) {
    Write-Host "Creating universal launchers..." -ForegroundColor Yellow
    $universalLauncher | Out-File -FilePath "zen-portable\launcher\zenportable.sh" -Encoding ASCII
    $universalWindowsLauncher | Out-File -FilePath "zen-portable\launcher\zenportable.bat" -Encoding ASCII
}

# Create README files
Write-Host "Creating README files..." -ForegroundColor Green

foreach ($platform in $extractedPlatforms) {
    $readmePath = "$platform\README.md"
    
    if ($platform.Contains("linux")) {
        $readme = @"
# Zen Browser Portable - Linux

This is a portable version of Zen Browser for Linux.

## Usage

1. Run the launcher script: ``./launcher/zenlinuxportable.sh``
2. Your profile data will be stored in the ``data`` folder

## Requirements

- Linux x86_64 or aarch64
- Basic system libraries (usually pre-installed)

## Notes

- The first run may take a few seconds to initialize the profile
- All browser data is contained within this folder
- You can copy this entire folder to another location or computer
"@
    }
    elseif ($platform.Contains("windows")) {
        $readme = @"
# Zen Browser Portable - Windows

This is a portable version of Zen Browser for Windows.

## Usage

1. Run the launcher: ``launcher\zenwindowsportable.bat``
2. Your profile data will be stored in the ``data`` folder

## Requirements

- Windows 10 or later
- x86_64 (64-bit) or ARM64 architecture

## Notes

- The first run may take a few seconds to initialize the profile
- All browser data is contained within this folder
- You can copy this entire folder to another location or computer
"@
    }
    elseif ($platform.Contains("macos")) {
        $readme = @"
# Zen Browser Portable - macOS

This is a portable version of Zen Browser for macOS.

## Usage

1. Run the launcher script: ``./launcher/zenmacosportable.sh``
2. Your profile data will be stored in the ``data`` folder

## Requirements

- macOS 10.15 or later
- Universal binary (supports both Intel and Apple Silicon)

## Notes

- The first run may take a few seconds to initialize the profile
- All browser data is contained within this folder
- You can copy this entire folder to another location or computer
"@
    }
    
    $readme | Out-File -FilePath $readmePath -Encoding UTF8
}

# Create universal README if all platforms selected
if (($platformChoice -eq "6") -and ($extractedPlatforms.Count -gt 0)) {
    $universalReadme = @"
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

## Usage

### Linux/macOS:
Run: ``./launcher/zenportable.sh``

### Windows:
Run: ``launcher\zenportable.bat``

The launcher will automatically detect your platform and architecture and run the appropriate version.

## Notes

- The first run may take a few seconds to initialize the profile
- All browser data is contained within this folder
- You can copy this entire folder to another location or computer
- The universal package includes all platform binaries, so it's larger than individual platform packages
"@
    $universalReadme | Out-File -FilePath "zen-portable\README.md" -Encoding UTF8
}

# Package everything
Write-Host "Packaging portable versions..." -ForegroundColor Green

foreach ($platform in $extractedPlatforms) {
    Write-Host "Packaging $platform..." -ForegroundColor Yellow
    # Use maximum compression for final packages
    & "7z" a -tzip -mx9 -mmt4 "$platform.zip" "$platform" | Out-Null
    Write-Host "Created: $platform.zip" -ForegroundColor Gray
}

# Package universal if all platforms selected and we have extractions
if (($platformChoice -eq "6") -and ($extractedPlatforms.Count -gt 0)) {
    Write-Host "Packaging zen-portable..." -ForegroundColor Yellow
    & "7z" a -tzip -mx9 -mmt4 "zen-portable.zip" "zen-portable" | Out-Null
    Write-Host "Created: zen-portable.zip" -ForegroundColor Gray
}

# Cleanup downloaded files
Write-Host "Cleaning up downloaded files..." -ForegroundColor Green
$uniqueArchives.Keys | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Force
        Write-Host "Removed: $_" -ForegroundColor Gray
    }
}

# Cleanup extracted directories
Write-Host "Cleaning up extracted directories..." -ForegroundColor Green
$extractedPlatforms | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Recurse -Force
        Write-Host "Removed: $_" -ForegroundColor Gray
    }
}

if (($platformChoice -eq "6") -and (Test-Path "zen-portable")) {
    Remove-Item "zen-portable" -Recurse -Force
    Write-Host "Removed: zen-portable" -ForegroundColor Gray
}

Write-Host ""
if ($extractedPlatforms.Count -gt 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Build completed successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Successfully built platforms:" -ForegroundColor Cyan
    foreach ($platform in $extractedPlatforms) {
        Write-Host "  - $platform" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "Created packages:" -ForegroundColor Cyan
    Get-ChildItem -Filter "*.zip" | ForEach-Object {
        $size = [math]::Round($_.Length / 1MB, 1)
        Write-Host "  $($_.Name) ($size MB)" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "Zen Browser portable packages have been created successfully!" -ForegroundColor Green
}
else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  Build failed!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "No platforms could be built due to download failures." -ForegroundColor Red
    Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
}

if ($skippedFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "Note: The following files failed to download:" -ForegroundColor Yellow
    foreach ($file in $skippedFiles) {
        Write-Host "  - $file" -ForegroundColor Red
    }
}
