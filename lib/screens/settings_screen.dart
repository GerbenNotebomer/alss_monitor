import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/translations.dart';

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
  late TextEditingController gaugeSizeController;

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

    // Gauge size standaard op 100% instellen, wordt later overschreven
    gaugeSizeController = TextEditingController(text: '100');

    _loadGaugeSize();
  }

  Future<void> _loadGaugeSize() async {
    final prefs = await SharedPreferences.getInstance();
    final gaugeSize = prefs.getDouble('gaugeSizePercent') ?? 100;
    setState(() {
      gaugeSizeController.text = gaugeSize.toStringAsFixed(0);
    });
  }

  @override
  void dispose() {
    voltageMinController.dispose();
    voltageMaxController.dispose();
    currentMinController.dispose();
    currentMaxController.dispose();
    gaugeSizeController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final vMin = double.tryParse(voltageMinController.text);
    final vMax = double.tryParse(voltageMaxController.text);
    final cMin = double.tryParse(currentMinController.text);
    final cMax = double.tryParse(currentMaxController.text);
    final gaugeSize = double.tryParse(gaugeSizeController.text);

    if (vMin == null ||
        vMax == null ||
        cMin == null ||
        cMax == null ||
        gaugeSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.t('message.enter_valid_numbers'))),
      );
      return;
    }

    await prefs.setDouble('voltageMin', vMin);
    await prefs.setDouble('voltageMax', vMax);
    await prefs.setDouble('currentMin', cMin);
    await prefs.setDouble('currentMax', cMax);
    await prefs.setDouble('gaugeSizePercent', gaugeSize);

    Navigator.of(context).pop(true);
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return SizedBox(
      width: 250,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          border: const OutlineInputBorder(),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 600;

    Widget buildFieldPair(
      TextEditingController c1,
      String label1,
      TextEditingController c2,
      String label2,
    ) {
      if (isWideScreen) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: _buildNumberField(c1, label1)),
            const SizedBox(width: 20),
            Expanded(child: _buildNumberField(c2, label2)),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNumberField(c1, label1),
            const SizedBox(height: 16),
            _buildNumberField(c2, label2),
          ],
        );
      }
    }

    Widget buildSettingBlock(String title, Widget content) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              content,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(Translations.t('settings.title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildSettingBlock(
                Translations.t('settings.voltage_group_title'),
                buildFieldPair(
                  voltageMinController,
                  Translations.t('settings.voltage_min'),
                  voltageMaxController,
                  Translations.t('settings.voltage_max'),
                ),
              ),
              buildSettingBlock(
                Translations.t('settings.current_group_title'),
                buildFieldPair(
                  currentMinController,
                  Translations.t('settings.current_min'),
                  currentMaxController,
                  Translations.t('settings.current_max'),
                ),
              ),
              buildSettingBlock(
                "Meterschaal (%)", // Voeg hier eventueel vertaling toe
                _buildNumberField(
                  gaugeSizeController,
                  "Grootte van meters in %",
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  child: Text(Translations.t('button.opslaan')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
