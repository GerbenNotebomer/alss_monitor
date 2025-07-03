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
