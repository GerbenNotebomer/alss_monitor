import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Klasse voor het laden en ophalen van vertalingen.
///
/// Laadt vertalingen uit een JSON-bestand in assets en
/// levert vertaalde teksten op basis van sleutel en taalcode.
class Translations {
  /// Interne opslag van geladen vertalingen.
  static Map<String, dynamic>? _localizedValues;

  /// Huidige taalcode (standaard 'nl').
  static String _currentLang = 'nl';

  /// Laadt vertalingen voor [langCode] uit JSON-bestand.
  ///
  /// Laadt het bestand 'assets/lang/translations_fallback_app.json'
  /// en decodeert naar een Map.
  static Future<void> load(String langCode) async {
    _currentLang = langCode;
    String jsonString = await rootBundle.loadString(
      'assets/lang/translations_fallback_app.json',
    );
    _localizedValues = json.decode(jsonString);
  }

  /// Haalt de vertaalde tekst op voor de gegeven [key].
  ///
  /// Retourneert de vertaling in de huidige taal [ _currentLang ].
  /// Als er geen vertaling is, wordt de key zelf teruggegeven.
  static String t(String key) {
    if (_localizedValues == null) return key;

    final entry = _localizedValues![key];
    if (entry is Map<String, dynamic>) {
      return entry[_currentLang] ?? key;
    } else if (entry is String) {
      return entry;
    }

    return key;
  }

  /// Geeft een lijst van beschikbare taalcodes terug.
  ///
  /// Leest deze uit de JSON sleutel 'taal.keuze'.
  static List<String> getLanguageKeys() {
    if (_localizedValues == null) return [];

    final keuze = _localizedValues!['taal.keuze'];
    if (keuze is Map<String, dynamic>) {
      return keuze.keys.toList();
    }
    return [];
  }

  /// Geeft de displaynaam van een taal terug op basis van [langCode].
  ///
  /// Leest deze uit de JSON sleutel 'taal.keuze'.
  /// Retourneert de taalcode als displaynaam niet gevonden is.
  static String getLanguageDisplayName(String langCode) {
    if (_localizedValues == null) return langCode;

    final keuze = _localizedValues!['taal.keuze'];
    if (keuze is Map<String, dynamic>) {
      return keuze[langCode] ?? langCode;
    }
    return langCode;
  }
}
