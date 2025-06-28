#!/bin/bash

# Clear Zen Browser Portable build artifacts and cache files

echo "Cleaning up Zen Browser Portable build artifacts..."

files=(
    "zen-linux-aarch64-portable"
    "zen-linux-aarch64-portable.zip"
    "zen-linux-x86_64-portable"
    "zen-linux-x86_64-portable.zip"
    "zen-linux-x86_64.tar"
    "zen-linux-x86_64.tar.xz"
    "zen-macos-universal-portable"
    "zen-macos-universal-portable.zip"
    "zen-macos-universal.dmg"
    "zen-portable"
    "zen-portable.zip"
    "zen-windows-arm64-portable"
    "zen-windows-arm64-portable.zip"
    "zen-windows-arm64.exe"
    "zen-windows-x86_64-portable"
    "zen-windows-x86_64-portable.zip"
    "zen-windows-x86_64.exe"
    "zen.installer-arm64.exe"
    "zen.installer.exe"
    "zen.linux-aarch64.tar"
    "zen.linux-aarch64.tar.xz"
)

deleted_count=0

for item in "${files[@]}"; do
    if [ -e "$item" ]; then
        if [ -d "$item" ]; then
            echo "Deleting directory: $item"
            rm -rf "$item"
        else
            echo "Deleting file: $item"
            rm -f "$item"
        fi
        
        if [ $? -eq 0 ]; then
            ((deleted_count++))
        else
            echo "Failed to delete: $item"
        fi
    fi
done

echo ""
if [ $deleted_count -gt 0 ]; then
    echo "Cleanup completed! Deleted $deleted_count items."
else
    echo "No build artifacts found to clean up."
fi

read -p "Press Enter to continue..."
