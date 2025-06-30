#!/bin/bash

APP_RELEASE_APK="build/app/outputs/flutter-apk/app-release.apk"
APP_DEBUG_APK="build/app/outputs/flutter-apk/app-debug.apk"

# Kleuren voor mooier menu
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # Geen kleur

function header() {
    echo -e "${CYAN}==========================================${NC}"
    echo -e "${CYAN}        Flutter Helper Menu v1.1          ${NC}"
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

# Nieuw submenu voor devices beheren
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
    echo -e "${YELLOW}0)${NC} Exit"
    echo -ne "${CYAN}Maak je keuze: ${NC}"
}

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
        0) echo -e "${GREEN}Bye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Ongeldige keuze, probeer opnieuw.${NC}"; pause ;;
    esac
done
