# Clear Zen Browser Portable build artifacts and cache files

Write-Host "Cleaning up Zen Browser Portable build artifacts..." -ForegroundColor Yellow

$files = @(
    "zen-linux-aarch64-portable",
    "zen-linux-aarch64-portable.zip",
    "zen-linux-x86_64-portable",
    "zen-linux-x86_64-portable.zip",
    "zen-linux-x86_64.tar",
    "zen-linux-x86_64.tar.xz",
    "zen-macos-universal-portable",
    "zen-macos-universal-portable.zip",
    "zen-macos-universal.dmg",
    "zen-portable",
    "zen-portable.zip",
    "zen-windows-arm64-portable",
    "zen-windows-arm64-portable.zip",
    "zen-windows-arm64.exe",
    "zen-windows-x86_64-portable",
    "zen-windows-x86_64-portable.zip",
    "zen-windows-x86_64.exe",
    "zen.installer-arm64.exe",
    "zen.installer.exe",
    "zen.linux-aarch64.tar",
    "zen.linux-aarch64.tar.xz"
)

$deletedCount = 0

foreach ($item in $files) {
    if (Test-Path $item) {
        try {
            if ((Get-Item $item).PSIsContainer) {
                Write-Host "Deleting directory: $item" -ForegroundColor Gray
                Remove-Item $item -Recurse -Force
            } else {
                Write-Host "Deleting file: $item" -ForegroundColor Gray
                Remove-Item $item -Force
            }
            $deletedCount++
        }
        catch {
            Write-Host "Failed to delete $item`: $_" -ForegroundColor Red
        }
    }
}

Write-Host ""
if ($deletedCount -gt 0) {
    Write-Host "Cleanup completed! Deleted $deletedCount items." -ForegroundColor Green
} else {
    Write-Host "No build artifacts found to clean up." -ForegroundColor Cyan
}

Write-Host "Press any key to continue..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
