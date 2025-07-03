import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alls_monitor/services/services.dart';
import 'package:alls_monitor/navigation/navigation.dart';

/// De hoofdwidget van de ALSS Monitor app.
///
/// Beheert de huidige taal van de app en slaat deze voorkeur op in
/// `SharedPreferences`. Start de app met een initiële taalcode.
///
/// Geeft de `MainNavigationScreen` weer en zorgt voor taalwisselingen.
class ALSSApp extends StatefulWidget {
  /// De initiële taalcode waarmee de app start (bv. 'nl' of 'en').
  final String initialLangCode;

  /// Constructor voor ALSSApp.
  ///
  /// [initialLangCode] is vereist en bepaalt de taal bij opstarten.
  const ALSSApp({Key? key, required this.initialLangCode}) : super(key: key);

  @override
  State<ALSSApp> createState() => _ALSSAppState();
}

class _ALSSAppState extends State<ALSSApp> {
  /// Houdt de huidige taalcode bij.
  late String _currentLang;

  @override
  void initState() {
    super.initState();
    _currentLang = widget.initialLangCode;
  }

  /// Wijzigt de taal van de app.
  ///
  /// Laadt nieuwe vertalingen via [Translations.load], slaat de taalcode op in
  /// `SharedPreferences` en update de UI.
  ///
  /// Negeert wijzigingen als de nieuwe taal gelijk is aan de huidige.
  Future<void> _changeLanguage(String newLang) async {
    if (newLang == _currentLang) return;
    await Translations.load(newLang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLang);
    setState(() {
      _currentLang = newLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALSS Monitor',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MainNavigationScreen(
        currentLang: _currentLang,
        onChangeLanguage: _changeLanguage,
      ),
    );
  }
}
