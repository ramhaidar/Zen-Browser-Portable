@echo off
:: Set application directory
set APP_DIR=%~dp0..\App
:: Set data directory
set DATA_DIR=%~dp0..\Data

:: Ensure zen.exe exists
if not exist "%APP_DIR%\core\zen.exe" (
    echo Error: zen.exe not found in "%APP_DIR%\core".
    pause
    exit /b 1
)

:: Ensure profile directory exists, or create it
if not exist "%DATA_DIR%\profile" (
    echo Profile directory not found. Creating one at "%DATA_DIR%\profile".
    mkdir "%DATA_DIR%\profile"
)

:: Launch Zen Browser in portable mode
"%APP_DIR%\core\zen.exe" -profile "%DATA_DIR%\profile" -no-remote
