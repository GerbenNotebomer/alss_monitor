import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../models/channel.dart';

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

  @override
  Widget build(BuildContext context) {
    final filtered = widget.channels.where((c) => _shouldShow(c.name)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Meters")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 10,
              children: [
                FilterChip(
                  label: const Text("MPPT"),
                  selected: showMPPT,
                  onSelected: (_) => _toggleFilter("mppt"),
                ),
                FilterChip(
                  label: const Text("Accu 1"),
                  selected: showAccu1,
                  onSelected: (_) => _toggleFilter("accu1"),
                ),
                FilterChip(
                  label: const Text("Accu 2"),
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
                            title: GaugeTitle(text: 'Voltage (V)'),
                            axes: [
                              RadialAxis(
                                minimum: 0,
                                maximum: 30,
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
                            title: GaugeTitle(text: 'Stroom (A)'),
                            axes: [
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
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
