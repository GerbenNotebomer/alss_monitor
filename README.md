# ALSS Monitor App

## Overzicht

Deze Flutter-app visualiseert data afkomstig van een ESP32-webserver die een JSON-data streamt via een access point. De data komt van sensoren en modules zoals de INA3221 (stroom/voltage monitoring) en AHT20/BMP280 (temperatuur, vochtigheid, druk).

De app haalt elke 5 seconden de nieuwste data op en toont deze in een overzichtelijk dashboard. Filters maken het mogelijk om bepaalde kanalen te verbergen of te tonen.

## Data Format

De ESP32 webserver levert JSON data met onder andere deze structuur:

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
      "voltage": 13.96,
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
      "temperatureBMP": 26.48,
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

## Modules in de app

- DataService: Haalt de JSON data op van de ESP32 webserver.
- HomeScreen: De hoofdscherm widget met filters en lijstweergave.
- ChannelCard: Toont details van elk kanaal (spanning, stroom, vermogen, temperatuur, etc.).
- FilterChipsRow: Biedt filters aan om kanalen te tonen/verbergen op basis van naam.

## Werking

- De app initialiseert en haalt data op via DataService.
- Elke 5 seconden wordt de data ververst via een Timer.
- Data wordt getoond in een lijst, waarbij kanalen gefilterd kunnen worden.
- De gebruiker kan handmatig verversen met de "refresh" knop.

## Installatie en Gebruik

1. Clone deze repository.
2. Open het project in je Flutter-omgeving (bijv. VS Code of Android Studio).
3. Voer `flutter pub get` uit om dependencies te installeren.
4. Start de app op een emulator of fysiek apparaat.
5. Verbind met het WiFi-accesspoint van de ESP32.
6. Geniet van realtime monitoring van je sensordata.

---

Voor vragen of suggesties, graag een issue openen op GitHub.
