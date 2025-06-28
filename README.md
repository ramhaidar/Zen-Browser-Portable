<div align="center">

# 🌟 Zen Browser Portable

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)
![Version](https://img.shields.io/badge/version-latest-green.svg)

**🚀 A fully portable setup for Zen Browser that runs directly from a USB drive or any folder**

*Launch Zen Browser anywhere without installation - all your data travels with you!*

</div>

---

## ✨ Features

🔹 **Fully Portable** - Run from USB drives, external storage, or any folder  
🔹 **Cross-Platform** - Works seamlessly on Windows, Linux, and macOS  
🔹 **Self-Contained** - All user data stored in local `Data` directory  
🔹 **Zero Installation** - No system modifications required  
🔹 **Privacy-Focused** - Complete control over your browsing data  
🔹 **Easy to Use** - Simple one-click launcher scripts

## 📁 Folder Structure

```
zen-portable/
├── 📁 app/                         # Core application files
│   ├── 🐧 lin/                     # Linux executable files
│   ├── 🪟 win/                     # Windows executable files
│   └── 🍎 mac/                     # macOS executable files
├── 💾 data/
│   └── 👤 profile/                 # Browser profile & user data
└── 🚀 launcher/
    ├── 🪟 zenwindowsportable.bat   # Windows launcher script
    ├── 🐧 zenlinuxportable.sh      # Linux launcher script
    └── 🍎 zenmacosportable.sh      # macOS launcher script
```



## 🚀 Quick Start Guide

### 📥 Option 1: Download Pre-built Release

1. **Download** the latest [Zen Browser Portable](https://github.com/ramhaidar/Zen-Browser-Portable/releases) release
2. **Extract** the ZIP file to your desired location (USB drive, folder, etc.)
3. **Navigate** to the extracted folder
4. **Launch** the browser:
   - **Windows**: Double-click `launcher/zenwindowsportable.bat`
   - **Linux**: Double-click `launcher/zenlinuxportable.sh` or run via terminal
   - **macOS**: Double-click `launcher/zenmacosportable.sh` or run via terminal

> 💡 **Tip**: Your portable browser is now ready to use! All data will be saved in the `data/` folder.

---

### 🔨 Option 2: Build from Source (Linux)

> ⚠️ **Note**: This method requires Linux but creates portable versions that work on Linux, Windows, and macOS.

#### Automatic Build (All Platforms)

1. **Download** the automatic build script:
   ```bash
   wget https://raw.githubusercontent.com/ramhaidar/Zen-Browser-Portable/main/zenmake_auto.sh
   ```

2. **Make executable**:
   ```bash
   chmod +x zenmake_auto.sh
   ```

3. **Run the build script**:
   ```bash
   ./zenmake_auto.sh
   ```

   This will automatically build portable versions for all platforms (Linux, Windows, and macOS).

#### Interactive Build (Choose Platforms)

1. **Download** the interactive build script:
   ```bash
   wget https://raw.githubusercontent.com/ramhaidar/Zen-Browser-Portable/main/zenmake_interactive.sh
   ```

2. **Make executable**:
   ```bash
   chmod +x zenmake_interactive.sh
   ```

3. **Run the interactive build script**:
   ```bash
   ./zenmake_interactive.sh
   ```

   This will allow you to choose which platform(s) you want to build - you can select specific platforms or build all of them.

4. **Deploy**: The script(s) will create ZIP files for the selected platform(s). Extract the appropriate one to your portable storage device.

5. **Launch**: Use the appropriate launcher script for your platform.

## 💡 Usage Tips

- ✅ **Safe Exit**: Always close the browser completely before unmounting your storage device
- ⚙️ **Customization**: Modify the launcher scripts to adjust paths or add custom options
- 💾 **Data Persistence**: All your bookmarks, history, and settings are automatically saved to the `data/` folder
- 🔄 **Updates**: To update, simply replace the `app/` folder with a newer version while keeping your `data/` folder intact

---

## ❓ FAQ

<details>
<summary><strong>Does this work on macOS?</strong></summary>
Yes! This portable setup now supports Windows, Linux, and macOS. Use the appropriate launcher script for your platform.
</details>

<details>
<summary><strong>Can I use this with existing Zen Browser profiles?</strong></summary>
Yes! You can copy your existing profile data to the `data/profile/` folder to migrate your settings.
</details>

<details>
<summary><strong>Is this an official Zen Browser project?</strong></summary>
No, this is a community-created portable wrapper for Zen Browser. For official Zen Browser releases, visit the official Zen Browser repository at <a href="https://github.com/zen-browser/desktop">https://github.com/zen-browser/desktop</a>.
</details>

---

## 🤝 Contributing

We welcome contributions! Please feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🔧 Submit pull requests
- 📖 Improve documentation

---

## 🙏 Acknowledgments

- 🔗 **Original Repository**: This project is forked from [wysh3/Zen-Browser-Portable](https://github.com/wysh3/Zen-Browser-Portable) - Thanks for the excellent foundation!
- Thanks to the [Zen Browser](https://zen-browser.app/) team for creating an amazing browser
- Special thanks to all contributors who help improve this portable setup

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

---

<div align="center">

**Made with ❤️ for the Zen Browser community**

[![GitHub stars](https://img.shields.io/github/stars/ramhaidar/Zen-Browser-Portable?style=social)](https://github.com/ramhaidar/Zen-Browser-Portable/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/ramhaidar/Zen-Browser-Portable?style=social)](https://github.com/ramhaidar/Zen-Browser-Portable/network/members)

*If you find this project helpful, please consider giving it a ⭐!*

</div>
