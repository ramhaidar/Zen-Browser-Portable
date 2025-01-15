# Zen Browser Portable

A portable setup for Zen Browser to run directly from a USB drive or any other folder on Windows. This repository includes a batch script to launch the browser in portable mode, ensuring that all data is stored locally within the portable setup.

## Features
- Fully portable Zen Browser.
- Stores all user data (profiles, settings, history) in the `Data` directory.
- No installation required.
- Works seamlessly on any Windows and Linux machine.

## Folder Structure
```
zen-portable/
├── app/                            # files related to Zen [ core for windows files | zen for linux files ]
│   └── lin/
│   └── win/
├── data/
│   └── profile/                    # Browser profile folder
└── launcher/
    └── zenwindowsportable.bat      # Launcher script for Windows
    └── zenlinuxportable.sh         # Launcher script for Linux

```



## How to Run Zen Browser(1.0.2-b.5) in portable mode: 
1. Download the [1.0.2-b.5 beta build](https://github.com/wysh3/Zen-Browser-Portable/releases/tag/1.0.2-b.5) zip file
   
2. Unpack the zip and transfer the "zen-portable" folder to your usb or any other storage device

3. Mount the usb or your storage device

4. -> Double-click the `launcher/zenbrowserportable.bat` file to launch Zen Browser in Windows 

   -> Double-click the `launcher/zenlinuxportable.sh` or try running it using terminal to launch Zen Browser in Linux.

## Steps to Build Zen Browser(latest) on Linux (the output file will work on both linux and windows):

1. Download the `zenmake.sh` script by cloning or downloading the zip.

2. Make the `zenmake.sh` script executable by running:
    ```bash
    chmod +x zenmake.sh
    ```

3. Run the `zenmake.sh` script to build Zen Browser:
    ```bash
    ./zenmake.sh
    ```

4. The script will output `zen-portable` folder.

5. Transfer the folder to your USB or other storage device.

6. Once transferred, you can launch Zen Browser on your storage device by running `./zenlinuxportable.sh` on Linux or by running `./zenwindowsportable.bat` on Windows machine.

## Usage
- Run the browser by executing the scripts.
- Close the browser before unmounting the usb/ the storage device.
- Customize the batch script if needed to adjust paths or options.

---

## License
This project is licensed under the [MIT License](LICENSE).
