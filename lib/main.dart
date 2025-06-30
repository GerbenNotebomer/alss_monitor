import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/meters_screen.dart';
import 'screens/raw_json_screen.dart';
import 'models/channel.dart';
import 'models/data_model.dart';
import 'services/data_service.dart';

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
  DataModel? _data;
  String? _error;
  bool _isLoading = true;

  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final result = await _dataService.fetchData();
      setState(() {
        _data = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text("Fout bij laden: $_error")));
    }

    final List<Widget> _screens = [
      const HomeScreen(),
      MetersScreen(channels: _data!.channels),
      RawJsonScreen(jsonData: _data!.toJson()),
    ];

    final List<String> _titles = ["Main", "Meters", "Raw JSON"];

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Main'),
          BottomNavigationBarItem(icon: Icon(Icons.speed), label: 'Meters'),
          BottomNavigationBarItem(icon: Icon(Icons.code), label: 'Raw JSON'),
        ],
      ),
    );
  }
}
