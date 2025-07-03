import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'package:alls_monitor/services/services.dart';

/// Entry point van de applicatie.
///
/// Deze functie zorgt ervoor dat Flutter correct wordt geïnitialiseerd,
/// haalt de eerder opgeslagen taalinstelling op via SharedPreferences,
/// laadt de vertalingen voor de gekozen taal, en start vervolgens de app.
///
/// De standaardtaal is Nederlands ('nl') als er nog geen taal opgeslagen is.
void main() async {
  // Zorgt ervoor dat Flutter bindings goed zijn geladen voor async werk.
  WidgetsFlutterBinding.ensureInitialized();

  // Haal opgeslagen taalcode op uit voorkeuren, of standaard naar 'nl'.
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('languageCode') ?? 'nl';

  // Laad vertalingen voor de gekozen taal.
  await Translations.load(savedLang);

  // Start de app met de gekozen initiële taalcode.
  runApp(ALSSApp(initialLangCode: savedLang));
}
