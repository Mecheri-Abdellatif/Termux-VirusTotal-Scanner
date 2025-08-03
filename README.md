# Termux-VirusTotal-Scanner
Ultimate Termux VirusTotal App Scanner v1.0 by Mecheri Abdellatif Scan installed Android apps via VirusTotal API with SHA256 hash detection, HTML reports, background notifications, and Shizuku integration.


# Termux VirusTotal App Scanner

**Author:** Mecheri Abdellatif  
**Version:** 1.0  

Ultimate Termux-based scanner for Android apps using **VirusTotal API**.  
Scans installed apps by **SHA256 hash** without uploading full files,  
saves **HTML reports**, and shows **live notifications**.  

---

### Features:
- ✅ Interactive setup with colored progress bars
- ✅ VirusTotal API key validation
- ✅ Shizuku integration for privileged access
- ✅ Background scanning via `scanapps` command
- ✅ Detects only new or updated apps to save time
- ✅ Saves detailed HTML reports
- ✅ Beautiful Termux notifications with status updates

---

### Installation:
```bash
pkg update && pkg install -y git
git clone https://github.com/Mecheri-Abdellatif/Termux-VirusTotal-Scanner.git
cd Termux-VirusTotal-Scanner
chmod +x scanapps.sh
./scanapps.sh
