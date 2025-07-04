#!/bin/bash

APK_DIR="apk"
APP_RELEASE_APK="$APK_DIR/Alls_Monitor_APP.apk"
APP_DEBUG_APK="build/app/outputs/flutter-apk/app-debug.apk"
# Voeg bovenaan toe (bij voorkeur bij je variabelen):
SERVER_DIR="docs"
SERVER_PORT=8000
SERVER_PID_FILE=".local_server_pid"
SERVER_PID_FILE=".local_server_pid"


# Kleuren voor mooier menu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # Geen kleur

function header() {
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}        Flutter Helper Menu v1.2          ${NC}"
    echo -e "${CYAN}==========================================${NC}"
}

function pause() {
    echo -e "${YELLOW}Druk op Enter om verder te gaan...${NC}"
    read
}

function check_adb() {
    adb_devices=$(adb devices | grep -w "device" | wc -l)
    if [ "$adb_devices" -gt 0 ]; then
        echo -e "${GREEN}ADB device(s) gevonden.${NC}"
        return 0
    else
        echo -e "${RED}Geen ADB device gevonden! Controleer USB verbinding en debugging.${NC}"
        return 1
    fi
}

function flutter_clean() {
    echo -e "${BLUE}Running flutter clean...${NC}"
    flutter clean
}

function flutter_pub_get() {
    echo -e "${BLUE}Running flutter pub get...${NC}"
    flutter pub get
}

function build_apk_release() {
    echo -e "${BLUE}Building APK (release)...${NC}"
    flutter build apk --release

    # Maak apk map aan als die niet bestaat
    if [ ! -d "$APK_DIR" ]; then
        mkdir -p "$APK_DIR"
    fi

    # Verplaats APK en hernoem
    SRC_APK="build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$SRC_APK" ]; then
        cp "$SRC_APK" "$APP_RELEASE_APK"
        echo -e "${GREEN}APK gekopieerd naar $APP_RELEASE_APK${NC}"
    else
        echo -e "${RED}Release APK niet gevonden op $SRC_APK${NC}"
    fi
}

function build_apk_debug() {
    echo -e "${BLUE}Building APK (debug)...${NC}"
    flutter build apk --debug
}

function build_apk_profile() {
    echo -e "${BLUE}Building APK (profile)...${NC}"
    flutter build apk --profile
}

function run_debug() {
    echo -e "${BLUE}Running flutter run (debug mode)...${NC}"
    flutter run
}

function install_apk_release() {
    if [ ! -f "$APP_RELEASE_APK" ]; then
        echo -e "${RED}Release APK niet gevonden! Eerst bouwen (optie 3).${NC}"
        return
    fi
    echo -e "${BLUE}Installeren van APK bestand: $APP_RELEASE_APK${NC}"   # <-- deze regel toegevoegd
    check_adb && echo -e "${BLUE}Installing release APK...${NC}" && adb install -r "$APP_RELEASE_APK"
}

function install_apk_debug() {
    if [ ! -f "$APP_DEBUG_APK" ]; then
        echo -e "${RED}Debug APK niet gevonden! Eerst bouwen (optie 4).${NC}"
        return
    fi
    check_adb && echo -e "${BLUE}Installing debug APK...${NC}" && adb install -r "$APP_DEBUG_APK"
}

function uninstall_app() {
    echo -ne "${YELLOW}Package naam invullen om te verwijderen (b.v. com.example.app): ${NC}"
    read pkg
    if [ -z "$pkg" ]; then
        echo -e "${RED}Geen package naam opgegeven!${NC}"
        return
    fi
    check_adb && echo -e "${BLUE}Uninstalling app $pkg...${NC}" && adb uninstall "$pkg"
}

function show_logs() {
    check_adb && echo -e "${BLUE}Bekijk logcat (CTRL+C om te stoppen)...${NC}" && adb logcat | grep flutter
}

function clean_android_only() {
    echo -e "${BLUE}Project opschonen en niet-Android platforms verwijderen...${NC}"

    flutter clean

    echo -e "${YELLOW}Verwijderen: ios/, macos/, windows/, linux/, web/${NC}"
    rm -rf ios macos windows linux web

    echo -e "${YELLOW}Verwijderen: build/, .dart_tool/${NC}"
    rm -rf build .dart_tool

    echo -e "${YELLOW}Verwijderen: IDE-configuratie (.idea/, .vscode/)${NC}"
    rm -rf .idea .vscode

    echo -e "${GREEN}✅ Project is nu opgeschoond voor Android-only builds.${NC}"
}

function devices_menu() {
    while true; do
        clear
        echo -e "${CYAN}====== ADB Devices Beheer ======${NC}"
        echo -e "${YELLOW}1)${NC} Toon verbonden devices"
        echo -e "${YELLOW}2)${NC} Verbind met device (adb connect IP[:PORT])"
        echo -e "${YELLOW}3)${NC} Verbreek verbinding device (adb disconnect IP[:PORT])"
        echo -e "${YELLOW}4)${NC} Koppel USB device los (adb usb)"
        echo -e "${YELLOW}0)${NC} Terug naar hoofdmenu"
        echo -ne "${CYAN}Maak je keuze: ${NC}"
        read dev_choice
        case $dev_choice in
            1)
                echo -e "${BLUE}Verbonden ADB devices:${NC}"
                adb devices
                pause
                ;;
            2)
                echo -ne "${YELLOW}Voer IP adres en optioneel poort in (bijv. 192.168.1.10:5555): ${NC}"
                read ip
                if [ -z "$ip" ]; then
                    echo -e "${RED}Geen IP opgegeven!${NC}"
                else
                    echo -e "${BLUE}Verbinding maken met $ip...${NC}"
                    adb connect "$ip"
                fi
                pause
                ;;
            3)
                echo -ne "${YELLOW}Voer IP adres en optioneel poort in om los te koppelen: ${NC}"
                read ip
                if [ -z "$ip" ]; then
                    echo -e "${RED}Geen IP opgegeven!${NC}"
                else
                    echo -e "${BLUE}Verbinding verbreken met $ip...${NC}"
                    adb disconnect "$ip"
                fi
                pause
                ;;
            4)
                echo -e "${BLUE}Schakelen naar USB modus...${NC}"
                adb usb
                pause
                ;;
            0) break ;;
            *)
                echo -e "${RED}Ongeldige keuze, probeer opnieuw.${NC}"
                pause
                ;;
        esac
    done
}

function upload_apk_to_sd() {
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
    PRIMARY_URL="http://192.168.178.36/sd"
    FALLBACK_URL="http://192.168.4.1/sd"

    if [ ! -f "$APK_PATH" ]; then
        echo -e "${RED}APK niet gevonden op ${APK_PATH}. Eerst een build uitvoeren.${NC}"
        return 1
    fi

    echo -e "${BLUE}Zoeken naar actieve ESP32 SD endpoint...${NC}"
    if curl --silent --head --fail "$PRIMARY_URL" > /dev/null; then
        TARGET_URL="$PRIMARY_URL"
        echo -e "${GREEN}Primaire ESP32 gevonden op $TARGET_URL${NC}"
    elif curl --silent --head --fail "$FALLBACK_URL" > /dev/null; then
        TARGET_URL="$FALLBACK_URL"
        echo -e "${YELLOW}Fallback ESP32 gevonden op $TARGET_URL${NC}"
    else
        echo -e "${RED}Geen werkende ESP32 endpoint gevonden.${NC}"
        return 1
    fi

    echo -e "${BLUE}Uploaden APK naar ${TARGET_URL}/upload (met redirect handling)...${NC}"
    response_code=$(curl -L -w "%{http_code}" -o /dev/null -s \
        -F "file=@${APK_PATH}" \
        "${TARGET_URL}/upload")

    if [[ "$response_code" == "200" ]]; then
        echo -e "${GREEN}✅ APK succesvol geüpload naar ${TARGET_URL}${NC}"
    else
        echo -e "${RED}❌ Upload mislukt met HTTP statuscode: $response_code${NC}"
    fi
}



function start_local_server() {
    if [ -f "$SERVER_PID_FILE" ]; then
        pid=$(cat "$SERVER_PID_FILE")
        if ps -p $pid > /dev/null 2>&1; then
            echo -e "${YELLOW}Server draait al met PID $pid.${NC}"
            return
        else
            echo -e "${YELLOW}Verouderd PID-bestand gevonden, verwijderen.${NC}"
            rm "$SERVER_PID_FILE"
        fi
    fi

    if [ ! -d "$SERVER_DIR" ]; then
        echo -e "${RED}Map $SERVER_DIR bestaat niet! Server starten mislukt.${NC}"
        return
    fi

    # Start server op achtergrond
    echo -e "${BLUE}Start lokale server in $SERVER_DIR op poort $SERVER_PORT...${NC}"
    (cd "$SERVER_DIR" && python3 -m http.server $SERVER_PORT > /dev/null 2>&1 &) 
    pid=$!
    echo $pid > "$SERVER_PID_FILE"
    echo -e "${GREEN}Server gestart met PID $pid.${NC}"
}

function stop_local_server() {
    if [ ! -f "$SERVER_PID_FILE" ]; then
        echo -e "${RED}Server PID-bestand niet gevonden. Server draait waarschijnlijk niet.${NC}"
        return
    fi

    pid=$(cat "$SERVER_PID_FILE")
    if ps -p $pid > /dev/null 2>&1; then
        kill $pid
        rm "$SERVER_PID_FILE"
        echo -e "${GREEN}Server (PID $pid) gestopt.${NC}"
    else
        echo -e "${YELLOW}Server met PID $pid draait niet. Verwijder PID-bestand.${NC}"
        rm "$SERVER_PID_FILE"
    fi
}

# Pas je menu() functie aan, voeg opties toe, bijvoorbeeld na optie 14:

function menu() {
    clear
    header
    echo -e "${YELLOW}1)${NC} Flutter clean"
    echo -e "${YELLOW}2)${NC} Flutter pub get"
    echo -e "${YELLOW}3)${NC} Build APK (release)"
    echo -e "${YELLOW}4)${NC} Build APK (debug)"
    echo -e "${YELLOW}5)${NC} Build APK (profile)"
    echo -e "${YELLOW}6)${NC} Run app (debug mode, flutter run)"
    echo -e "${YELLOW}7)${NC} Install APK (release)"
    echo -e "${YELLOW}8)${NC} Install APK (debug)"
    echo -e "${YELLOW}9)${NC} Uninstall app (package naam)"
    echo -e "${YELLOW}10)${NC} Bekijk logs (filter flutter)"
    echo -e "${YELLOW}11)${NC} Opschonen & minimaliseren (Android-only)"
    echo -e "${YELLOW}12)${NC} Devices beheren (ADB)"
    echo -e "${YELLOW}13)${NC} Committen en pushen naar GitHub"
    echo -e "${YELLOW}14)${NC} Upload APK naar SD-kaart (via WiFi)"
    echo -e "${YELLOW}15)${NC} Start lokale server (docs/, poort 8000)"
    echo -e "${YELLOW}16)${NC} Stop lokale server"
    echo -e "${YELLOW}0)${NC} Exit"
    echo -ne "${CYAN}Maak je keuze: ${NC}"
}
function create_readme_and_push() {
  # 1. Genereer dart API docs
  echo "Dart docs genereren..."
  dart doc
  
  # 2. Maak docs map aan en kopieer dart docs ernaartoe
  echo "Docs kopiëren naar /docs voor GitHub Pages..."
  rm -rf docs
  mkdir docs
  cp -r doc/api/* docs/
  
  # 3. Maak README.md met link naar docs
  cat > README.md << 'EOF'
# ALSS Monitor App

De ALSS Monitor App is een Flutter-applicatie voor het uitlezen van een acculaadsysteem via een lokaal access point. De app communiceert met een ESP32 die als webserver fungeert en periodiek JSON-data aanbiedt met informatie over accu’s, laadstatus, vermogens, en omgevingssensoren (temperatuur, luchtvochtigheid en luchtdruk).

## Systeemoverzicht

### Hardwarecomponenten:

- ESP32 microcontroller (met WiFi access point en webserver)
- INA3221 module: meting van spanning, stroom en vermogen per kanaal
- AHT20 + BMP280 module: temperatuur, luchtvochtigheid en luchtdruk

### Communicatie:

- ESP32 draait in Access Point modus
- JSON wordt geserveerd op: http://192.168.4.1/data.json

## JSON-structuur (voorbeeld)

De JSON die door de ESP32 wordt gegenereerd heeft het volgende formaat:

\`\`\`json
{
"channels": [
{
"name": "MPPT",
"current": -1.01,
"power": -13.34,
"voltage": 14.03,
"totalAh": -1.14,
"totalWh": -16.09,
"batteryCapacityAh": 0
},
{
"name": "Accu 1",
"current": 0.05,
"power": 0.69,
"voltage": 13.97,
"totalAh": 0.57,
"totalWh": 7.55,
"batteryCapacityAh": 200
},
{
"name": "Accu 2",
"current": 0,
"power": 0,
"voltage": 0,
"totalAh": 0,
"totalWh": 0,
"batteryCapacityAh": 72
},
{
"name": "AHT20/BMP280",
"temperatureAHT": 26.05,
"humidityAHT": 47.92,
"temperatureBMP": 26.49,
"pressure": 1024.58
}
],
"datetime": "30/06/2025 11:32:58",
"dag": "Moandei",
"batteries": [
{
"state": 0,
"stateText": "Laden",
"stateOfCharge": 100,
"days": 8,
"hours": 16,
"minutes": 11
},
{
"state": 0,
"stateText": "Laden",
"stateOfCharge": 0,
"days": -1,
"hours": -1,
"minutes": -1
}
]
}
\`\`\`

## App Functionaliteit

De Flutter-app biedt:

- Real-time uitlezing van kanaalgegevens zoals spanning, stroom, vermogen, energie (Wh/Ah)
- Weergave van temperatuur, luchtvochtigheid en luchtdruk
- Filterfunctie om bepaalde kanaalgroepen (MPPT / Accu 1 / Accu 2) tijdelijk te verbergen
- Automatische update van gegevens elke 5 seconden
- Handmatige refresh via:
  - Pull-to-refresh
  - Refresh-knop rechtsonder

## API Documentatie

De API documentatie is beschikbaar via de [GitHub Pages](https://<jouw-gebruikersnaam>.github.io/<jouw-repo>/) website.

Of lokaal te bekijken in de map `docs` door `docs/index.html` te openen.

## Belangrijkste Flutter-modules

Bestand — Functie

lib/services/data_service.dart — Haalt JSON-data op via HTTP GET  
lib/screens/home_screen.dart — Hoofdscherm met filters, kanaalweergave en refresh-logica  
lib/widgets/channel_card.dart — Toont gegevens per kanaal als een kaartje  
lib/widgets/filter_chips_row.dart — Chips om MPPT / Accu 1 / Accu 2 te filteren  
lib/models/channel.dart — Datamodel voor kanaalgegevens

## App installeren en starten

Verbind je apparaat met het access point van de ESP32

Start de Flutter-app:

\`\`\`
flutter pub get
flutter run
\`\`\`

Zorg dat het ESP32-apparaat actief is en JSON serveert op: http://192.168.4.1/data.json

## Toekomstige ideeën

- Grafieken tonen per kanaal (historie)
- Beter batterijoverzicht uit batteries[]
- Multi-language ondersteuning
- Gebruik buiten lokaal netwerk via WiFi Client-modus

## Licentie

Nog niet bepaald.
EOF

  echo "README.md is aangemaakt."

  # 4. Commit en push alles
  git add -A
  if git diff --cached --quiet; then
      echo "Geen nieuwe wijzigingen om te committen."
  else
      git commit -m "Update README.md en docs"
      git push --force origin master
      echo "README.md en docs gecommit en gepusht naar GitHub."
  fi
}

# Voeg in je while-loop deze cases toe:

while true; do
    menu
    read keuze
    case $keuze in
        1) flutter_clean; pause ;;
        2) flutter_pub_get; pause ;;
        3) build_apk_release; pause ;;
        4) build_apk_debug; pause ;;
        5) build_apk_profile; pause ;;
        6) run_debug; pause ;;
        7) install_apk_release; pause ;;
        8) install_apk_debug; pause ;;
        9) uninstall_app; pause ;;
        10) show_logs; pause ;;
        11) clean_android_only; pause ;;
        12) devices_menu ;;
        13) create_readme_and_push; pause ;;
        14) upload_apk_to_sd; pause ;;
        15) start_local_server; pause ;;
        16) stop_local_server; pause ;;
        0) echo -e "${GREEN}Tot ziens!${NC}"; exit 0 ;;
        *) echo -e "${RED}Ongeldige keuze, probeer opnieuw.${NC}"; pause ;;
    esac
done