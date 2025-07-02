import 'package:flutter/material.dart';
import '../models/data_model.dart';
import '../services/data_repository.dart';
import '../services/data_service.dart';
import '../services/translations.dart';
import 'dashboard_screen.dart';
import 'meters_screen.dart';
import 'raw_json_screen.dart';
import '../navigation/app_drawer.dart'; // nieuwe drawer import

class MainNavigationScreen extends StatefulWidget {
  final String currentLang;
  final Future<void> Function(String) onChangeLanguage;

  const MainNavigationScreen({
    Key? key,
    required this.currentLang,
    required this.onChangeLanguage,
  }) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
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

    _dataRepository = DataRepository(DataService());
    _dataRepository.startFetching();

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
    _dataRepository.stopFetching();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Sluit drawer na selectie
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
        MetersScreen(channels: _data!.channels)
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
