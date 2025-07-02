import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Translations {
  static Map<String, dynamic>? _localizedValues;
  static String _currentLang = 'nl';

  static Future<void> load(String langCode) async {
    _currentLang = langCode;
    String jsonString = await rootBundle.loadString(
      'assets/lang/translations_fallback_app.json',
    );
    _localizedValues = json.decode(jsonString);
  }

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

  /// Haal lijst van beschikbare talen uit JSON-sleutel 'taal.keuze'
  static List<String> getLanguageKeys() {
    if (_localizedValues == null) return [];

    final keuze = _localizedValues!['taal.keuze'];
    if (keuze is Map<String, dynamic>) {
      return keuze.keys.toList();
    }
    return [];
  }

  /// Haal de taalnaam op uit 'taal.keuze' per taalcode
  static String getLanguageDisplayName(String langCode) {
    if (_localizedValues == null) return langCode;

    final keuze = _localizedValues!['taal.keuze'];
    if (keuze is Map<String, dynamic>) {
      return keuze[langCode] ?? langCode;
    }
    return langCode;
  }
}
