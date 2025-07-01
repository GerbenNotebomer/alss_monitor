import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/meters_screen.dart';
import 'screens/raw_json_screen.dart';
import 'models/data_model.dart';
import 'services/data_service.dart';
import 'services/data_repository.dart';

void main() {
  runApp(const ALSSApp());
}

class ALSSApp extends StatelessWidget {
  const ALSSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALSS Monitor',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final DataRepository _dataRepository;
  DataModel? _data;
  String? _error;
  bool _isLoading = true;

  final titles = ["Dashboard", "Meters", "Raw JSON"];

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
    Navigator.of(context).pop(); // Sluit de drawer na selectie
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text("Fout bij laden: $_error")));
    }

    final screens = [
      if (_data != null) HomeScreen(data: _data!) else const SizedBox(),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Meters'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Raw JSON'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Meters'),
          BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Raw JSON'),
        ],
      ),
    );
  }
}
