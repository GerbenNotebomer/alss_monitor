import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/translations.dart';
import 'screens/main_navigation.dart';

class ALSSApp extends StatefulWidget {
  final String initialLangCode;
  const ALSSApp({Key? key, required this.initialLangCode}) : super(key: key);

  @override
  State<ALSSApp> createState() => _ALSSAppState();
}

class _ALSSAppState extends State<ALSSApp> {
  late String _currentLang;

  @override
  void initState() {
    super.initState();
    _currentLang = widget.initialLangCode;
  }

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
