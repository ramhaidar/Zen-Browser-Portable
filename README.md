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
🔹 **Auto-Updated** - Automated CI/CD builds latest Zen Browser releases daily  
🔹 **Multi-Architecture** - Supports x86_64, ARM64, and Universal builds  
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

> 🔄 **Automated Builds**: Our CI/CD pipeline automatically checks for new Zen Browser releases daily at midnight UTC and builds portable versions for all platforms!

1. **Download** the latest [Zen Browser Portable](https://github.com/ramhaidar/Zen-Browser-Portable/releases) release
   - 🐧 `zen-linux-x86_64-portable.zip` - Linux x86_64 (64-bit)
   - 🐧 `zen-linux-aarch64-portable.zip` - Linux ARM64
   - 🪟 `zen-windows-x86_64-portable.zip` - Windows x86_64 (64-bit)
   - 🪟 `zen-windows-arm64-portable.zip` - Windows ARM64
   - 🍎 `zen-macos-universal-portable.zip` - macOS Universal (Intel & Apple Silicon)
   - 📦 `zen-portable.zip` - All platforms in one package

2. **Extract** the ZIP file to your desired location (USB drive, folder, etc.)
3. **Navigate** to the extracted folder
4. **Launch** the browser:
   - **Windows**: Double-click `launcher/zenwindowsportable.bat`
   - **Linux**: Double-click `launcher/zenlinuxportable.sh` or run via terminal
   - **macOS**: Double-click `launcher/zenmacosportable.sh` or run via terminal

> 💡 **Tip**: Your portable browser is now ready to use! All data will be saved in the `data/` folder.
> 
> ⚡ **Update Schedule**: New releases are automatically built daily when Zen Browser updates are detected. You can also trigger manual builds anytime!

---

### 🔨 Option 2: Build from Source

> 💡 **Cross-Platform Support**: Build scripts are available for both Linux/macOS (Bash) and Windows (PowerShell).

#### Automatic Build (All Platforms)

**For Linux/macOS:**
1. **Download** the automatic build script:
   ```bash
   wget https://raw.githubusercontent.com/ramhaidar/Zen-Browser-Portable/main/zenmake_all_platforms.sh
   ```

2. **Make executable**:
   ```bash
   chmod +x zenmake_all_platforms.sh
   ```

3. **Run the build script**:
   ```bash
   ./zenmake_all_platforms.sh
   ```

**For Windows:**
1. **Download** the PowerShell build script:
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ramhaidar/Zen-Browser-Portable/main/zenmake_all_platforms.ps1" -OutFile "zenmake_all_platforms.ps1"
   ```

2. **Run the build script**:
   ```powershell
   .\zenmake_all_platforms.ps1
   ```

This will automatically build portable versions for all platforms (Linux, Windows, and macOS).

#### Interactive Build (Choose Platforms)

**For Linux/macOS:**
1. **Download** the interactive build script:
   ```bash
   wget https://raw.githubusercontent.com/ramhaidar/Zen-Browser-Portable/main/zenmake_with_choice.sh
   ```

2. **Make executable**:
   ```bash
   chmod +x zenmake_with_choice.sh
   ```

3. **Run the interactive build script**:
   ```bash
   ./zenmake_with_choice.sh
   ```

**For Windows:**
1. **Download** the PowerShell interactive build script:
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ramhaidar/Zen-Browser-Portable/main/zenmake_with_choice.ps1" -OutFile "zenmake_with_choice.ps1"
   ```

2. **Run the interactive build script**:
   ```powershell
   .\zenmake_with_choice.ps1
   ```

This will allow you to choose which platform(s) you want to build - you can select specific platforms or build all of them.

4. **Deploy**: The script(s) will create ZIP files for the selected platform(s). Extract the appropriate one to your portable storage device.

5. **Launch**: Use the appropriate launcher script for your platform.

#### Clean Build Artifacts

After building, you can clean up temporary build files and artifacts:

**For Linux/macOS:**
```bash
./clean_build_artifacts.sh
```

**For Windows:**
```powershell
.\clean_build_artifacts.ps1
```

This will remove all generated ZIP files, extracted directories, and temporary build artifacts.

## 💡 Usage Tips

- ✅ **Safe Exit**: Always close the browser completely before unmounting your storage device
- ⚙️ **Customization**: Modify the launcher scripts to adjust paths or add custom options
- 💾 **Data Persistence**: All your bookmarks, history, and settings are automatically saved to the `data/` folder
- 🔄 **Auto-Updates**: New releases are automatically built and published when Zen Browser updates - just download the latest release!
- 🎯 **Platform Selection**: Download only the package you need, or get the universal package for all platforms
- 🧹 **Cleanup**: Use the provided cleanup scripts (`clean_build_artifacts.sh` or `clean_build_artifacts.ps1`) to remove build artifacts after creating your portable packages
- 🖥️ **Cross-Platform Building**: Choose between Bash scripts (Linux/macOS) or PowerShell scripts (Windows) for building portable packages
- ⚡ **Stay Current**: Check the releases page regularly for the latest Zen Browser updates in portable format

---

## ❓ FAQ

<details>
<summary><strong>How are releases automatically updated?</strong></summary>
Our GitHub Actions workflow runs daily at midnight UTC to check for new Zen Browser releases. When a new version is detected, it automatically:
<ul>
<li>🔍 Detects the latest Zen Browser release</li>
<li>🏗️ Builds portable versions for all supported platforms</li>
<li>📦 Creates platform-specific ZIP packages</li>
<li>🚀 Publishes a new release with all portable versions</li>
<li>✅ Ensures you get the latest Zen Browser in portable format (within 24 hours of upstream release)</li>
</ul>
You can also trigger manual builds immediately using the "Run workflow" button in the Actions tab.
</details>

<details>
<summary><strong>What platforms are automatically built?</strong></summary>
Our automated build system creates portable packages for:
<ul>
<li>🐧 <strong>Linux</strong>: x86_64 and ARM64 (aarch64) architectures</li>
<li>🪟 <strong>Windows</strong>: x86_64 and ARM64 architectures</li>
<li>🍎 <strong>macOS</strong>: Universal binaries (Intel and Apple Silicon)</li>
<li>📦 <strong>Universal</strong>: All platforms combined in one package</li>
</ul>
Each release includes individual platform packages plus a universal package containing all platforms.
</details>

<details>
<summary><strong>Does this work on macOS?</strong></summary>
Yes! This portable setup now supports Windows, Linux, and macOS. Use the appropriate launcher script for your platform.
</details>

<details>
<summary><strong>What's the difference between the build scripts?</strong></summary>
We provide two types of build scripts:
<ul>
<li><strong>zenmake_all_platforms</strong>: Automatically builds portable versions for all platforms (Linux, Windows, and macOS)</li>
<li><strong>zenmake_with_choice</strong>: Interactive script that lets you choose which specific platform(s) to build</li>
</ul>
Both are available in Bash (.sh) for Linux/macOS and PowerShell (.ps1) for Windows.
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
- ⚙️ Enhance the CI/CD automation workflow

> 🔄 **Note**: Our automated build system ensures releases stay current with Zen Browser updates. If you notice any issues with the automation, please report them!

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
