import 'package:flutter/material.dart';
import '../widgets/channel_card.dart';
import '../widgets/filter_chips_row.dart';
import '../models/data_model.dart';

class HomeScreen extends StatefulWidget {
  final DataModel? data;

  const HomeScreen({super.key, required this.data});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final data = widget.data;

    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("ALSS Monitor")),
      body: RefreshIndicator(
        onRefresh: () async {
          // Optioneel: Je kunt hier een callback aanroepen om de data handmatig te verversen
          // Bijvoorbeeld via een callback in de constructor
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: FilterChipsRow(
                showMPPT: showMPPT,
                showAccu1: showAccu1,
                showAccu2: showAccu2,
                onToggle: _toggleFilter,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    "📅 Tijd: ${data.datetime}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...data.channels
                      .where((c) => _shouldShow(c.name))
                      .map<Widget>((c) => ChannelCard(channel: c))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
