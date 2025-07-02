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
      // Pak specifieke vertaling op basis van ingestelde taal
      return entry[_currentLang] ?? key;
    } else if (entry is String) {
      // Voor flat structuur (optioneel)
      return entry;
    }

    return key; // fallback als vertaling niet bestaat
  }
}
