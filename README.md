<div align="center">

# 🌟 Zen Browser Portable

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux-lightgrey.svg)
![Version](https://img.shields.io/badge/version-latest-green.svg)

**🚀 A fully portable setup for Zen Browser that runs directly from a USB drive or any folder**

*Launch Zen Browser anywhere without installation - all your data travels with you!*

</div>

---

## ✨ Features

🔹 **Fully Portable** - Run from USB drives, external storage, or any folder  
🔹 **Cross-Platform** - Works seamlessly on Windows and Linux  
🔹 **Self-Contained** - All user data stored in local `Data` directory  
🔹 **Zero Installation** - No system modifications required  
🔹 **Privacy-Focused** - Complete control over your browsing data  
🔹 **Easy to Use** - Simple one-click launcher scripts

## 📁 Folder Structure

```
zen-portable/
├── 📁 app/                         # Core application files
│   ├── 🐧 lin/                     # Linux executable files
│   └── 🪟 win/                     # Windows executable files
├── 💾 data/
│   └── 👤 profile/                 # Browser profile & user data
└── 🚀 launcher/
    ├── 🪟 zenwindowsportable.bat   # Windows launcher script
    └── 🐧 zenlinuxportable.sh      # Linux launcher script
```



## 🚀 Quick Start Guide

### 📥 Option 1: Download Pre-built Release

1. **Download** the latest [Zen Browser Portable](https://github.com/wysh3/Zen-Browser-Portable/releases) release
2. **Extract** the ZIP file to your desired location (USB drive, folder, etc.)
3. **Navigate** to the extracted folder
4. **Launch** the browser:
   - **Windows**: Double-click `launcher/zenwindowsportable.bat`
   - **Linux**: Double-click `launcher/zenlinuxportable.sh` or run via terminal

> 💡 **Tip**: Your portable browser is now ready to use! All data will be saved in the `data/` folder.

---

### 🔨 Option 2: Build from Source (Linux)

> ⚠️ **Note**: This method requires Linux but creates a portable version that works on both Linux and Windows.

1. **Download** the build script:
   ```bash
   wget https://raw.githubusercontent.com/wysh3/Zen-Browser-Portable/main/zenmake.sh
   ```

2. **Make executable**:
   ```bash
   chmod +x zenmake.sh
   ```

3. **Run the build script**:
   ```bash
   ./zenmake.sh
   ```

4. **Deploy**: The script will create a ZIP file. Extract it to your portable storage device.

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
Currently, this portable setup is designed for Windows and Linux. macOS support may be added in future releases.
</details>

<details>
<summary><strong>Can I use this with existing Zen Browser profiles?</strong></summary>
Yes! You can copy your existing profile data to the `data/profile/` folder to migrate your settings.
</details>

<details>
<summary><strong>Is this an official Zen Browser project?</strong></summary>
No, this is a community-created portable wrapper for Zen Browser. For official Zen Browser releases, visit the official Zen Browser repository.
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

[![GitHub stars](https://img.shields.io/github/stars/wysh3/Zen-Browser-Portable?style=social)](https://github.com/wysh3/Zen-Browser-Portable/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/wysh3/Zen-Browser-Portable?style=social)](https://github.com/wysh3/Zen-Browser-Portable/network/members)

*If you find this project helpful, please consider giving it a ⭐!*

</div>
