import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alls_monitor/services/services.dart';

/// Scherm waarin gebruikers de instellingen kunnen aanpassen.
///
/// Bevat invoervelden voor spannings- en stroomlimieten, meterschaal,
/// en een dropdown voor taalkeuze.
/// Instellingen worden opgeslagen in SharedPreferences.
///
class SettingsScreen extends StatefulWidget {
  /// Minimum spanningswaarde.
  final double voltageMin;

  /// Maximum spanningswaarde.
  final double voltageMax;

  /// Minimum stroomwaarde.
  final double currentMin;

  /// Maximum stroomwaarde.
  final double currentMax;

  /// Huidige taalcode (bijv. 'nl', 'en').
  final String currentLang;

  /// Callback om de taal te wijzigen, die buiten deze widget wordt afgehandeld.
  final Future<void> Function(String) onChangeLanguage;

  /// Constructor met verplichte parameters.
  const SettingsScreen({
    super.key,
    required this.voltageMin,
    required this.voltageMax,
    required this.currentMin,
    required this.currentMax,
    required this.currentLang,
    required this.onChangeLanguage,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Controllers voor tekstvelden
  late TextEditingController voltageMinController;
  late TextEditingController voltageMaxController;
  late TextEditingController currentMinController;
  late TextEditingController currentMaxController;
  late TextEditingController gaugeSizeController;

  // Lokale variabele voor huidige taalkeuze
  late String currentLang;

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
    gaugeSizeController = TextEditingController(text: '100'); // Standaardwaarde

    // Initieer huidige taal van widget
    currentLang = widget.currentLang;

    // Laad meterschaal-instelling uit SharedPreferences
    _loadGaugeSize();
  }

  /// Laadt de meterschaalwaarde uit SharedPreferences.
  Future<void> _loadGaugeSize() async {
    final prefs = await SharedPreferences.getInstance();
    final gaugeSize = prefs.getDouble('gaugeSizePercent') ?? 100;
    setState(() {
      gaugeSizeController.text = gaugeSize.toStringAsFixed(0);
    });
  }

  @override
  void dispose() {
    // Controllers netjes opruimen
    voltageMinController.dispose();
    voltageMaxController.dispose();
    currentMinController.dispose();
    currentMaxController.dispose();
    gaugeSizeController.dispose();
    super.dispose();
  }

  /// Valideert en slaat de instellingen op.
  ///
  /// Als een invoer geen geldig getal is, toont een foutmelding.
  /// Bij succesvolle opslag wordt het scherm gesloten met resultaat `true`.
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

  /// Bouwt een tekstveld voor numerieke invoer met label.
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

    /// Bouwt een rij of kolom van twee invoervelden, afhankelijk van schermbreedte.
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

    /// Bouwt een gestileerde card met titel en inhoud.
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
              // Spanning instellingen
              buildSettingBlock(
                Translations.t('settings.voltage_group_title'),
                buildFieldPair(
                  voltageMinController,
                  Translations.t('settings.voltage_min'),
                  voltageMaxController,
                  Translations.t('settings.voltage_max'),
                ),
              ),

              // Stroom instellingen
              buildSettingBlock(
                Translations.t('settings.current_group_title'),
                buildFieldPair(
                  currentMinController,
                  Translations.t('settings.current_min'),
                  currentMaxController,
                  Translations.t('settings.current_max'),
                ),
              ),

              // Meterschaal instelling
              buildSettingBlock(
                "Meterschaal (%)",
                _buildNumberField(
                  gaugeSizeController,
                  "Grootte van meters in %",
                ),
              ),

              // Taal keuze dropdown
              buildSettingBlock(
                Translations.t('instellingen.taal.label'),
                DropdownButton<String>(
                  value: currentLang,
                  items: Translations.getLanguageKeys().map((langCode) {
                    return DropdownMenuItem(
                      value: langCode,
                      child: Text(
                        Translations.getLanguageDisplayName(langCode),
                      ),
                    );
                  }).toList(),
                  onChanged: (newLang) async {
                    if (newLang != null && newLang != currentLang) {
                      setState(() {
                        currentLang = newLang;
                      });
                      await widget.onChangeLanguage(newLang);
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Opslaan knop
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
