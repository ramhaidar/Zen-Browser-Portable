# Zen Browser Portable Maker - PowerShell Version
# Automatically builds all Zen Browser portable packages for all platforms

param(
    [string]$Version = ""
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Zen Browser Portable Maker (Auto)" -ForegroundColor Cyan
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

# Define download URLs for all platforms
$downloads = @{
    "zen-linux-x86_64.tar.xz"  = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.linux-x86_64.tar.xz"
    "zen-linux-aarch64.tar.xz" = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.linux-aarch64.tar.xz"
    "zen-windows-x86_64.exe"   = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.installer.exe"
    "zen-windows-arm64.exe"    = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.installer-arm64.exe"
    "zen-macos-universal.dmg"  = "https://github.com/zen-browser/desktop/releases/download/$Version/zen.macos-universal.dmg"
}

# Define platform configurations
$platforms = @{
    "zen-linux-x86_64-portable"    = @{
        "archive"         = "zen-linux-x86_64.tar.xz"
        "app_dir"         = "lin-x86_64"
        "launcher_script" = "zenlinuxportable.sh"
        "launcher_batch"  = $null
    }
    "zen-linux-aarch64-portable"   = @{
        "archive"         = "zen-linux-aarch64.tar.xz"
        "app_dir"         = "lin-aarch64"
        "launcher_script" = "zenlinuxportable.sh"
        "launcher_batch"  = $null
    }
    "zen-windows-x86_64-portable"  = @{
        "archive"         = "zen-windows-x86_64.exe"
        "app_dir"         = "win-x86_64"
        "launcher_script" = $null
        "launcher_batch"  = "zenwindowsportable.bat"
    }
    "zen-windows-arm64-portable"   = @{
        "archive"         = "zen-windows-arm64.exe"
        "app_dir"         = "win-arm64"
        "launcher_script" = $null
        "launcher_batch"  = "zenwindowsportable.bat"
    }
    "zen-macos-universal-portable" = @{
        "archive"         = "zen-macos-universal.dmg"
        "app_dir"         = "mac-universal"
        "launcher_script" = "zenmacosportable.sh"
        "launcher_batch"  = $null
    }
}

# Clean up any existing directories
Write-Host "Cleaning up existing directories..." -ForegroundColor Yellow
$platforms.Keys | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Recurse -Force
        Write-Host "Removed existing directory: $_" -ForegroundColor Gray
    }
}

if (Test-Path "zen-portable") {
    Remove-Item "zen-portable" -Recurse -Force
    Write-Host "Removed existing directory: zen-portable" -ForegroundColor Gray
}

# Create directory structure for all platforms
Write-Host "Creating directory structure..." -ForegroundColor Green
$platforms.Keys | ForEach-Object {
    $config = $platforms[$_]
    New-Item -ItemType Directory -Path "$_\app\$($config.app_dir)" -Force | Out-Null
    New-Item -ItemType Directory -Path "$_\data\Profiles\profile1" -Force | Out-Null
    New-Item -ItemType Directory -Path "$_\launcher" -Force | Out-Null
    Write-Host "Created directory structure for: $_" -ForegroundColor Gray
}

# Create universal portable structure
New-Item -ItemType Directory -Path "zen-portable\app\lin-x86_64" -Force | Out-Null
New-Item -ItemType Directory -Path "zen-portable\app\lin-aarch64" -Force | Out-Null
New-Item -ItemType Directory -Path "zen-portable\app\win-x86_64" -Force | Out-Null
New-Item -ItemType Directory -Path "zen-portable\app\win-arm64" -Force | Out-Null
New-Item -ItemType Directory -Path "zen-portable\app\mac-universal" -Force | Out-Null
New-Item -ItemType Directory -Path "zen-portable\data\Profiles\profile1" -Force | Out-Null
New-Item -ItemType Directory -Path "zen-portable\launcher" -Force | Out-Null
Write-Host "Created universal portable structure" -ForegroundColor Gray

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
                Write-Host "  Waiting $DelaySeconds seconds before retry..." -ForegroundColor Yellow
                Start-Sleep -Seconds $DelaySeconds
            }
            else {
                Write-Host "  All download attempts failed for: $OutFile" -ForegroundColor Red
                return $false
            }
        }
    }
    return $false
}

# Download all files
Write-Host "Downloading Zen Browser releases..." -ForegroundColor Green
$skippedFiles = @()

foreach ($file in $downloads.Keys) {
    if (-not (Test-Path $file)) {
        Write-Host "Downloading $file..." -ForegroundColor Yellow
        
        $success = Invoke-FileDownloadWithRetry -Url $downloads[$file] -OutFile $file
        
        if (-not $success) {
            Write-Host "Failed to download $file after all retries. Skipping this platform." -ForegroundColor Red
            $skippedFiles += $file
        }
    }
    else {
        Write-Host "Using existing: $file" -ForegroundColor Gray
    }
}

# Report skipped files
if ($skippedFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "The following files could not be downloaded:" -ForegroundColor Yellow
    $skippedFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    Write-Host "Continuing with available platforms..." -ForegroundColor Yellow
    Write-Host ""
}

# Function to extract archives
function Expand-ArchiveFile {
    param($Archive, $Destination)
    
    Write-Host "Extracting $Archive to $Destination..." -ForegroundColor Yellow
    
    if ($Archive.EndsWith(".tar.xz")) {
        # Use 7z with better performance settings for .tar.xz files
        $tempDir = "$env:TEMP\zen_extract_$(Get-Random)"
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
        try {
            # Extract in two steps for better reliability
            Write-Host "  Step 1: Extracting .xz compression..." -ForegroundColor Gray
            & "7z" x "$Archive" -o"$tempDir" -y | Out-Null
            
            $tarFile = Get-ChildItem -Path $tempDir -Filter "*.tar" | Select-Object -First 1
            if ($tarFile) {
                Write-Host "  Step 2: Extracting .tar archive..." -ForegroundColor Gray
                & "7z" x "$($tarFile.FullName)" -o"$Destination" -y | Out-Null
            }
            else {
                throw "No .tar file found after extracting .xz"
            }
            
            # Process Linux files - move zen executable and other files from zen subdirectory
            $zenSubDir = Join-Path $Destination "zen"
            if (Test-Path $zenSubDir) {
                Write-Host "  Processing Linux directory structure..." -ForegroundColor Gray
                $zenExecutable = Join-Path $zenSubDir "zen"
                if (Test-Path $zenExecutable) {
                    Move-Item $zenExecutable "$Destination\zen-executable" -Force
                    Get-ChildItem $zenSubDir | ForEach-Object {
                        Move-Item $_.FullName $Destination -Force
                    }
                    Remove-Item $zenSubDir -Force
                    Move-Item "$Destination\zen-executable" "$Destination\zen" -Force
                }
            }
        }
        finally {
            # Clean up temp directory
            if (Test-Path $tempDir) {
                Remove-Item $tempDir -Recurse -Force
            }
        }
    }
    elseif ($Archive.EndsWith(".exe")) {
        # Extract Windows installer with better settings
        & "7z" x "$Archive" -o"$Destination" -y | Out-Null
        
        # Process Windows files - move files from core subdirectory if it exists
        $coreDir = Join-Path $Destination "core"
        if (Test-Path $coreDir) {
            Write-Host "  Processing Windows directory structure..." -ForegroundColor Gray
            Get-ChildItem $coreDir | ForEach-Object {
                Move-Item $_.FullName $Destination -Force
            }
            Remove-Item $coreDir -Force
        }
    }
    elseif ($Archive.EndsWith(".zip")) {
        Expand-Archive -Path $Archive -DestinationPath $Destination -Force
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
                Write-Host "  Renamed app bundle to: Zen Browser.app" -ForegroundColor Gray
            }
        }
    }
}

# Extract all archives
Write-Host "Extracting archives..." -ForegroundColor Green
$extractedPlatforms = @()

foreach ($platform in $platforms.Keys) {
    $config = $platforms[$platform]
    $archive = $config.archive
    $appDir = "$platform\app\$($config.app_dir)"
    
    # Check if the archive file exists before trying to extract
    if (Test-Path $archive) {
        Write-Host "Extracting $($platform)..." -ForegroundColor Yellow
        try {
            Expand-ArchiveFile $archive $appDir
            
            # Also extract to universal portable
            $universalAppDir = "zen-portable\app\$($config.app_dir)"
            Expand-ArchiveFile $archive $universalAppDir
            
            $extractedPlatforms += $platform
            Write-Host "Successfully extracted: $platform" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to extract $archive for $platform`: $_" -ForegroundColor Red
            Write-Host "Skipping $platform..." -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "Archive $archive not found. Skipping $platform..." -ForegroundColor Yellow
    }
}

# Create profiles.ini for successfully extracted platforms
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

# Always create universal profiles.ini if we have at least one platform
if ($extractedPlatforms.Count -gt 0) {
    $profilesIni | Out-File -FilePath "zen-portable\data\profiles.ini" -Encoding ASCII
    Write-Host "Created profiles.ini for extracted platforms" -ForegroundColor Gray
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
ZEN_DIR="$SCRIPT_DIR/../app/mac"
DATA_DIR="$SCRIPT_DIR/../data"

export MOZ_LEGACY_PROFILES=1
export MOZ_ALLOW_DOWNGRADE=1

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

# Create platform-specific launchers only for successfully extracted platforms
foreach ($platform in $extractedPlatforms) {
    $config = $platforms[$platform]
    
    Write-Host "Creating launchers for $platform..." -ForegroundColor Yellow
    
    if ($config.launcher_script) {
        if ($platform.Contains("linux")) {
            $linuxLauncher | Out-File -FilePath "$platform\launcher\$($config.launcher_script)" -Encoding ASCII
        }
        elseif ($platform.Contains("macos")) {
            $macosLauncher | Out-File -FilePath "$platform\launcher\$($config.launcher_script)" -Encoding ASCII
        }
    }
    
    if ($config.launcher_batch) {
        $windowsLauncher | Out-File -FilePath "$platform\launcher\$($config.launcher_batch)" -Encoding ASCII
    }
}

# Create universal launchers only if we have at least one platform
if ($extractedPlatforms.Count -gt 0) {
    Write-Host "Creating universal launcher..." -ForegroundColor Yellow
    $universalLauncher | Out-File -FilePath "zen-portable\launcher\zenportable.sh" -Encoding ASCII
    $universalWindowsLauncher | Out-File -FilePath "zen-portable\launcher\zenportable.bat" -Encoding ASCII
}

# Create README files
Write-Host "Creating README files..." -ForegroundColor Green

$linuxReadme = @"
# Zen Browser Portable - Linux

This is a portable version of Zen Browser for Linux.

## Usage

1. Run the launcher script: `./launcher/zenlinuxportable.sh`
2. Your profile data will be stored in the `data` folder

## Requirements

- Linux x86_64 or aarch64
- Basic system libraries (usually pre-installed)

## Notes

- The first run may take a few seconds to initialize the profile
- All browser data is contained within this folder
- You can copy this entire folder to another location or computer
"@

$windowsReadme = @"
# Zen Browser Portable - Windows

This is a portable version of Zen Browser for Windows.

## Usage

1. Run the launcher: `launcher\zenwindowsportable.bat`
2. Your profile data will be stored in the `data` folder

## Requirements

- Windows 10 or later
- x86_64 (64-bit) or ARM64 architecture

## Notes

- The first run may take a few seconds to initialize the profile
- All browser data is contained within this folder
- You can copy this entire folder to another location or computer
"@

$macosReadme = @"
# Zen Browser Portable - macOS

This is a portable version of Zen Browser for macOS.

## Usage

1. Run the launcher script: `./launcher/zenmacosportable.sh`
2. Your profile data will be stored in the `data` folder

## Requirements

- macOS 10.15 or later
- Universal binary (supports both Intel and Apple Silicon)

## Notes

- The first run may take a few seconds to initialize the profile
- All browser data is contained within this folder
- You can copy this entire folder to another location or computer
"@

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
Run: `./launcher/zenportable.sh`

### Windows:
Run: `launcher\zenportable.bat`

The launcher will automatically detect your platform and architecture and run the appropriate version.

## Notes

- The first run may take a few seconds to initialize the profile
- All browser data is contained within this folder
- You can copy this entire folder to another location or computer
- The universal package includes all platform binaries, so it's larger than individual platform packages
"@

# Write README files only for successfully extracted platforms
foreach ($platform in $extractedPlatforms) {
    $readmePath = "$platform\README.md"
    
    if ($platform.Contains("linux")) {
        $linuxReadme | Out-File -FilePath $readmePath -Encoding UTF8
    }
    elseif ($platform.Contains("windows")) {
        $windowsReadme | Out-File -FilePath $readmePath -Encoding UTF8
    }
    elseif ($platform.Contains("macos")) {
        $macosReadme | Out-File -FilePath $readmePath -Encoding UTF8
    }
}

# Always create universal README if we have at least one platform
if ($extractedPlatforms.Count -gt 0) {
    $universalReadme | Out-File -FilePath "zen-portable\README.md" -Encoding UTF8
}

# Package everything with no compression for maximum speed
Write-Host "Packaging portable versions (no compression for speed)..." -ForegroundColor Green

foreach ($platform in $extractedPlatforms) {
    Write-Host "Packaging $platform..." -ForegroundColor Yellow
    # Use 7z with no compression for maximum speed
    & "7z" a -tzip -mx0 -mmt4 "$platform.zip" "$platform" | Out-Null
    Write-Host "Created: $platform.zip" -ForegroundColor Gray
}

# Only package universal if we have at least one platform
if ($extractedPlatforms.Count -gt 0) {
    Write-Host "Packaging zen-portable..." -ForegroundColor Yellow
    & "7z" a -tzip -mx0 -mmt4 "zen-portable.zip" "zen-portable" | Out-Null
    Write-Host "Created: zen-portable.zip" -ForegroundColor Gray
}

# Cleanup
Write-Host "Cleaning up temporary files..." -ForegroundColor Green
$downloads.Keys | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Force
        Write-Host "Removed: $_" -ForegroundColor Gray
    }
}

Write-Host ""
if ($extractedPlatforms.Count -gt 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Build completed!" -ForegroundColor Green
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
    Write-Host "All available Zen Browser portable packages have been created!" -ForegroundColor Green
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
    Write-Host "Note: The following platforms were skipped due to download failures:" -ForegroundColor Yellow
    foreach ($file in $skippedFiles) {
        $skippedPlatform = $platforms.Keys | Where-Object { $platforms[$_].archive -eq $file }
        if ($skippedPlatform) {
            Write-Host "  - $skippedPlatform" -ForegroundColor Red
        }
    }
}
