import 'dart:async';
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../widgets/channel_card.dart';
import '../widgets/filter_chips_row.dart';
import '../models/data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataService _dataService = DataService();
  DataModel? data;
  String? error;
  Timer? _timer;

  bool showMPPT = true;
  bool showAccu1 = true;
  bool showAccu2 = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final result = await _dataService.fetchData();
      setState(() {
        data = result;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        data = null;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ALSS Monitor")),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: error != null
            ? Center(child: Text("Fout: $error"))
            : data == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                          "📅 Tijd: ${data!.datetime}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...data!.channels
                            .where((c) => _shouldShow(c.name))
                            .map<Widget>((c) => ChannelCard(channel: c))
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
