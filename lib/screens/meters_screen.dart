import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../models/channel.dart';
import '../services/translations.dart'; // ✅ nodig voor vertalingen
import 'settings_screen.dart';

class MetersScreen extends StatefulWidget {
  final List<Channel> channels;

  const MetersScreen({super.key, required this.channels});

  @override
  State<MetersScreen> createState() => _MetersScreenState();
}

class _MetersScreenState extends State<MetersScreen> {
  bool showMPPT = true;
  bool showAccu1 = true;
  bool showAccu2 = true;

  double voltageMin = 10.7;
  double voltageMax = 14.4;
  double currentMin = -10;
  double currentMax = 10;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      voltageMin = prefs.getDouble('voltageMin') ?? voltageMin;
      voltageMax = prefs.getDouble('voltageMax') ?? voltageMax;
      currentMin = prefs.getDouble('currentMin') ?? currentMin;
      currentMax = prefs.getDouble('currentMax') ?? currentMax;
    });
  }

  void _toggleFilter(String type) {
    setState(() {
      if (type == "mppt") showMPPT = !showMPPT;
      if (type == "accu1") showAccu1 = !showAccu1;
      if (type == "accu2") showAccu2 = !showAccu2;
    });
  }

  bool _shouldShow(String name) {
    final n = name.toLowerCase();
    if (n.contains("mppt")) return showMPPT;
    if (n.contains("accu 1")) return showAccu1;
    if (n.contains("accu 2")) return showAccu2;
    return true;
  }

  Future<void> _openSettings() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          voltageMin: voltageMin,
          voltageMax: voltageMax,
          currentMin: currentMin,
          currentMax: currentMax,
        ),
      ),
    );

    if (updated == true) {
      _loadSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.channels.where((c) => _shouldShow(c.name)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.t('nav.meters')), // ✅
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 10,
              children: [
                FilterChip(
                  label: Text(Translations.t('meters.filter.mppt')), // ✅
                  selected: showMPPT,
                  onSelected: (_) => _toggleFilter("mppt"),
                ),
                FilterChip(
                  label: Text(Translations.t('meters.filter.accu1')), // ✅
                  selected: showAccu1,
                  onSelected: (_) => _toggleFilter("accu1"),
                ),
                FilterChip(
                  label: Text(Translations.t('meters.filter.accu2')), // ✅
                  selected: showAccu2,
                  onSelected: (_) => _toggleFilter("accu2"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final channel = filtered[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          channel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (channel.voltage != null)
                          SfRadialGauge(
                            title: GaugeTitle(
                              text: Translations.t('dashboard.voltage'), // ✅
                            ),
                            axes: [
                              RadialAxis(
                                minimum: voltageMin,
                                maximum: voltageMax,
                                ranges: [
                                  GaugeRange(
                                    startValue: voltageMin,
                                    endValue: 11.5,
                                    color: Colors.red.shade400,
                                  ),
                                  GaugeRange(
                                    startValue: 11.5,
                                    endValue: 13.0,
                                    color: Colors.orange.shade400,
                                  ),
                                  GaugeRange(
                                    startValue: 13.0,
                                    endValue: voltageMax,
                                    color: Colors.green.shade400,
                                  ),
                                ],
                                pointers: [
                                  NeedlePointer(value: channel.voltage!),
                                ],
                                annotations: [
                                  GaugeAnnotation(
                                    widget: Text(
                                      '${channel.voltage!.toStringAsFixed(2)} V',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        if (channel.current != null)
                          SfRadialGauge(
                            title: GaugeTitle(
                              text: Translations.t('dashboard.current'), // ✅
                            ),
                            axes: [
                              RadialAxis(
                                minimum: currentMin,
                                maximum: currentMax,
                                ranges: [
                                  GaugeRange(
                                    startValue: currentMin,
                                    endValue: -5,
                                    color: Colors.red.shade400,
                                  ),
                                  GaugeRange(
                                    startValue: -5,
                                    endValue: 0,
                                    color: Colors.orange.shade400,
                                  ),
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: 5,
                                    color: Colors.green.shade400,
                                  ),
                                  GaugeRange(
                                    startValue: 5,
                                    endValue: currentMax,
                                    color: Colors.orange.shade400,
                                  ),
                                ],
                                pointers: [
                                  NeedlePointer(value: channel.current!),
                                ],
                                annotations: [
                                  GaugeAnnotation(
                                    widget: Text(
                                      '${channel.current!.toStringAsFixed(2)} A',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
