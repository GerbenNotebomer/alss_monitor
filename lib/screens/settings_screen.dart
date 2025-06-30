import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final double voltageMin;
  final double voltageMax;
  final double currentMin;
  final double currentMax;

  const SettingsScreen({
    super.key,
    required this.voltageMin,
    required this.voltageMax,
    required this.currentMin,
    required this.currentMax,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController voltageMinController;
  late TextEditingController voltageMaxController;
  late TextEditingController currentMinController;
  late TextEditingController currentMaxController;

  @override
  void initState() {
    super.initState();
    voltageMinController = TextEditingController(
      text: widget.voltageMin.toString(),
    );
    voltageMaxController = TextEditingController(
      text: widget.voltageMax.toString(),
    );
    currentMinController = TextEditingController(
      text: widget.currentMin.toString(),
    );
    currentMaxController = TextEditingController(
      text: widget.currentMax.toString(),
    );
  }

  @override
  void dispose() {
    voltageMinController.dispose();
    voltageMaxController.dispose();
    currentMinController.dispose();
    currentMaxController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final vMin = double.tryParse(voltageMinController.text);
    final vMax = double.tryParse(voltageMaxController.text);
    final cMin = double.tryParse(currentMinController.text);
    final cMax = double.tryParse(currentMaxController.text);

    if (vMin == null || vMax == null || cMin == null || cMax == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Voer geldige getallen in')));
      return;
    }

    await prefs.setDouble('voltageMin', vMin);
    await prefs.setDouble('voltageMax', vMax);
    await prefs.setDouble('currentMin', cMin);
    await prefs.setDouble('currentMax', cMax);

    Navigator.of(context).pop(true); // Terug met resultaat 'true'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instellingen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: voltageMinController,
              decoration: const InputDecoration(labelText: 'Voltage Min'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            TextField(
              controller: voltageMaxController,
              decoration: const InputDecoration(labelText: 'Voltage Max'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: currentMinController,
              decoration: const InputDecoration(labelText: 'Stroom Min'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            TextField(
              controller: currentMaxController,
              decoration: const InputDecoration(labelText: 'Stroom Max'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Opslaan'),
            ),
          ],
        ),
      ),
    );
  }
}
