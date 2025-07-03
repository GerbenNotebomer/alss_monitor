import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alls_monitor/models/models.dart';
import 'package:alls_monitor/services/services.dart';
import 'package:alls_monitor/screens/screens.dart';
import 'package:alls_monitor/navigation/navigation.dart';

/// Hoofd navigatie scherm van de app.
///
/// Beheert de navigatie tussen dashboard, meters en raw JSON schermen,
/// en regelt data ophalen en taalinstellingen.
///
class MainNavigationScreen extends StatefulWidget {
  /// Huidige taalcode, bijvoorbeeld 'nl' of 'en'.
  final String currentLang;

  /// Callback om taal te veranderen.
  final Future<void> Function(String) onChangeLanguage;

  /// Constructor.
  const MainNavigationScreen({
    Key? key,
    required this.currentLang,
    required this.onChangeLanguage,
  }) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final DataRepository _dataRepository;
  DataModel? _data;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Start data ophalen via repository en service
    _dataRepository = DataRepository(DataService());
    _dataRepository.startFetching();

    // Luister naar updates van data en update UI
    _dataRepository.dataNotifier.addListener(() {
      final newData = _dataRepository.dataNotifier.value;
      if (newData != null) {
        setState(() {
          _data = newData;
          _isLoading = false;
          _error = null;
        });
      }
    });
  }

  @override
  void dispose() {
    // Stop data ophalen bij afsluiten scherm
    _dataRepository.stopFetching();
    super.dispose();
  }

  /// Handler voor navigatie-item selectie.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Sluit de drawer na selectie
  }

  /// Opent het instellingen scherm en verwerkt wijzigingen.
  Future<void> _openSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final voltageMin = prefs.getDouble('voltageMin') ?? 10.7;
    final voltageMax = prefs.getDouble('voltageMax') ?? 14.4;
    final currentMin = prefs.getDouble('currentMin') ?? -10;
    final currentMax = prefs.getDouble('currentMax') ?? 10;

    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          voltageMin: voltageMin,
          voltageMax: voltageMax,
          currentMin: currentMin,
          currentMax: currentMax,
          currentLang: widget.currentLang,
          onChangeLanguage: widget.onChangeLanguage,
        ),
      ),
    );

    if (updated == true) {
      setState(() {}); // Optioneel: scherm vernieuwen na opslaan
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      Translations.t('nav.dashboard'),
      Translations.t('nav.meters'),
      Translations.t('nav.raw_json'),
    ];

    if (_isLoading) {
      return Scaffold(
        body: Center(child: Text(Translations.t('dashboard.loading'))),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text("${Translations.t('dashboard.fetch_error')}: $_error"),
        ),
      );
    }

    final screens = [
      if (_data != null) DashboardScreen(data: _data!) else const SizedBox(),
      if (_data != null)
        MetersScreen(
          channels: _data!.channels,
          currentLang: widget.currentLang,
          onChangeLanguage: widget.onChangeLanguage,
        )
      else
        const SizedBox(),
      if (_data != null)
        RawJsonScreen(jsonData: _data!.toJson())
      else
        const SizedBox(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_selectedIndex])),
      drawer: AppDrawer(
        currentLang: widget.currentLang,
        onChangeLanguage: widget.onChangeLanguage,
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        onOpenSettings: _openSettings,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: Translations.t('nav.dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.speed),
            label: Translations.t('nav.meters'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.code),
            label: Translations.t('nav.raw_json'),
          ),
        ],
      ),
    );
  }
}
