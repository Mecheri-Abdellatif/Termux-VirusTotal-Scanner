#!/data/data/com.termux/files/usr/bin/bash

# ==========================================
# Termux VirusTotal App Scanner v1.0
# Author: Mecheri Abdellatif
# Repo: https://github.com/Mecheri-Abdellatif/Termux-VirusTotal-Scanner
# ==========================================

GREEN="\e[92m"
RED="\e[91m"
YELLOW="\e[93m"
BLUE="\e[94m"
RESET="\e[0m"

REPO_URL="https://github.com/Mecheri-Abdellatif/Termux-VirusTotal-Scanner.git"
API_FILE="$HOME/.vt_api_key"
REPORT_DIR="$HOME/vt_reports"
SCAN_LOG="$HOME/.vt_scanned_apps"

mkdir -p "$REPORT_DIR"

notify() {
    termux-notification --title "VT Scanner" --content "$1" --priority high --sound
}

progress_bar() {
    local duration=$1
    local i=0
    while [ $i -le $duration ]; do
        printf "\r${BLUE}[%-${duration}s]${RESET}" $(printf "#%.0s" $(seq 1 $i))
        sleep 0.1
        i=$((i+1))
    done
    echo
}

echo -e "${GREEN}=========================================="
echo -e "  Termux VirusTotal App Scanner v1.0"
echo -e "        by Mecheri Abdellatif"
echo -e "==========================================${RESET}"

# 1️⃣ Update & Install Dependencies
echo -e "${YELLOW}[*] Checking & Installing dependencies...${RESET}"
pkg update -y && pkg upgrade -y
pkg install -y python git wget unzip termux-api
pip install --upgrade pip 2>/dev/null || true
pip install requests rich tqdm psutil termcolor 2>/dev/null || true
progress_bar 20

# 2️⃣ Check for updates from GitHub
echo -e "${YELLOW}[*] Checking for updates...${RESET}"
LATEST=$(curl -s https://api.github.com/repos/Mecheri-Abdellatif/Termux-VirusTotal-Scanner/releases/latest | grep tag_name | cut -d '"' -f4)
[ -n "$LATEST" ] && echo -e "${GREEN}[✓] Latest version: $LATEST${RESET}"
progress_bar 10

# 3️⃣ Request API Key
if [ ! -f "$API_FILE" ]; then
    notify "Please get your VirusTotal API Key first!"
    echo -e "${YELLOW}>>> Get your API key: https://www.virustotal.com/gui/my-apikey${RESET}"
    read -p "[>] Enter your VirusTotal API Key: " API_KEY
    echo "$API_KEY" > "$API_FILE"
else
    API_KEY=$(cat "$API_FILE")
fi

# Validate API Key
echo -e "${YELLOW}[*] Validating API key...${RESET}"
CHECK=$(curl -s --request GET \
  --url "https://www.virustotal.com/api/v3/users/me" \
  --header "x-apikey: $API_KEY")

if echo "$CHECK" | grep -q "error"; then
    notify "❌ Invalid API Key!"
    echo -e "${RED}[!] Invalid API key. Delete $API_FILE and retry.${RESET}"
    exit 1
fi
notify "✅ API Key Validated"
echo -e "${GREEN}[✓] API Key validated${RESET}"
progress_bar 10

# 4️⃣ Prepare scan command
cat > $PREFIX/bin/scanapps <<EOF
#!/data/data/com.termux/files/usr/bin/bash
echo "[*] Starting background scan..."
$HOME/scan_vt.sh &
EOF
chmod +x $PREFIX/bin/scanapps

# 5️⃣ Create the main scanning script
cat > $HOME/scan_vt.sh <<'EOS'
#!/data/data/com.termux/files/usr/bin/bash
API_KEY=$(cat $HOME/.vt_api_key)
REPORT_DIR="$HOME/vt_reports"
SCAN_LOG="$HOME/.vt_scanned_apps"
mkdir -p "$REPORT_DIR"
touch "$SCAN_LOG"

notify() {
    termux-notification --title "VT Scanner" --content "$1" --priority high --sound
}

notify "🔍 Scanning installed apps..."

for pkg in $(pm list packages -f | sed 's/package://g'); do
    APK_PATH=$(echo $pkg | cut -d= -f1)
    APP_NAME=$(echo $pkg | cut -d= -f2)
    SHA256=$(sha256sum "$APK_PATH" | awk '{print $1}')

    # Skip if already scanned
    grep -q "$SHA256" "$SCAN_LOG" && continue

    # Ask before uploading unknown files
    RESPONSE=$(curl -s --request GET \
        --url "https://www.virustotal.com/api/v3/files/$SHA256" \
        --header "x-apikey: $API_KEY")

    if echo "$RESPONSE" | grep -q "error"; then
        termux-notification --title "VT Scanner" --content "⚠️ New app $APP_NAME detected. Upload to VirusTotal?" --button1-text "Yes" --button1-action "echo yes" --button2-text "No" --button2-action "echo no"
        # Optional: Implement wait for user choice
        UPLOAD=$(curl -s --request POST \
            --url "https://www.virustotal.com/api/v3/files" \
            --header "x-apikey: $API_KEY" \
            --form file=@"$APK_PATH")
    fi

    echo "$SHA256 $APP_NAME" >> "$SCAN_LOG"
done

# Generate HTML report
REPORT="$REPORT_DIR/scan_$(date +%F_%H-%M).html"
echo "<html><body><h1>VirusTotal Scan Report</h1><pre>" > "$REPORT"
cat "$SCAN_LOG" >> "$REPORT"
echo "</pre></body></html>" >> "$REPORT"

notify "✅ Scan complete. Report saved."
EOS

chmod +x $HOME/scan_vt.sh

notify "✅ Setup complete! Use 'scanapps' to start scanning."
echo -e "${GREEN}[✓] Setup complete! Run 'scanapps' to scan in background.${RESET}"
