# Termux VirusTotal App Scanner v1.0

**Author:** Mecheri Abdellatif  
**Repo:** [Termux-VirusTotal-Scanner](https://github.com/Mecheri-Abdellatif/Termux-VirusTotal-Scanner)  
**Version:** 1.0  

A powerful Termux-based application scanner that uses **VirusTotal API** to detect suspicious or malicious apps installed on your Android device.  
Scans apps **on-demand**, runs **only when triggered**, and generates **interactive HTML reports** with notifications and sound alerts.

---

## ✨ Features

- ✅ **Auto Install & Setup** (Python, Git, Termux-API, etc.)  
- ✅ **Validates VirusTotal API Key** before scanning  
- ✅ **Progress bars and colorful console output**  
- ✅ **On-demand background scanning** via `scanapps` command  
- ✅ **Shizuku integration** for privileged app access (optional)  
- ✅ **Scans new or updated apps only**  
- ✅ **Uploads SHA256 hash first (better privacy)**  
- ✅ **Interactive Notifications with Sounds & Emojis**  
- ✅ **Generates timestamped HTML reports**  
- ✅ **Keeps log of previously scanned apps** to avoid duplicates  

---

## 📸 Screenshots

*(Add screenshots of terminal and HTML report here)*

---

## 📦 Installation

1. **Clone the repository:**
```bash
git clone https://github.com/Mecheri-Abdellatif/Termux-VirusTotal-Scanner.git
cd Termux-VirusTotal-Scanner
```

2. **Run the setup script:**
```bash
bash setup_vt.sh
```

3. **Get your VirusTotal API Key:**
- Visit: [https://www.virustotal.com/gui/my-apikey](https://www.virustotal.com/gui/my-apikey)
- Paste it when prompted during setup

4. **Trigger the scanner anytime:**
```bash
scanapps
```

---

## 📂 Output

- **Logs:** `~/.vt_scanned_apps`  
- **Reports:** `~/vt_reports/scan_YYYY-MM-DD_HH-MM.html`  
- **API Key:** `~/.vt_api_key`

---

## 🔔 Notifications

- **🔍** Scanning started  
- **⚠️** New app detected, asks for upload confirmation  
- **✅** Scan complete with HTML report link  

---

## 🛡️ Privacy & Security

- Only **SHA256 hashes** are sent first to VirusTotal for privacy  
- Full APK is uploaded **only with your confirmation**  
- Previous results are cached to **minimize API usage**  

---

## 🛠️ Requirements

- Android 7.0+ with **Termux**  
- Internet access  
- Free VirusTotal account with API key  
- Optional: **Shizuku** for advanced access

---

## 🚀 Roadmap (Future Enhancements)

1. **Colored notifications** with green/yellow/red status  
2. **Interactive prompt** in notifications (tap to approve upload)  
3. **Real-time monitoring** for new APK installations  
4. **Auto-update check** and self-update feature  
5. **Telegram/Discord integration** for remote alerts  
6. **Live VirusTotal score summary in notification**  
7. **Dark-mode HTML reports** with severity colors

---

## 🧑‍💻 Author

**Mecheri Abdellatif**  
Version **v1.0**

If you like this project, consider giving it a ⭐ on GitHub!
