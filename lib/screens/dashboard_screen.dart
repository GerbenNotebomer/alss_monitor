import 'package:flutter/material.dart';

import 'package:alls_monitor/widgets/widgets.dart';
import 'package:alls_monitor/models/models.dart';

/// Dashboard scherm dat data toont van verschillende kanalen.
///
/// Bevat filters om te kiezen welke kanalen getoond worden (MPPT, Accu 1, Accu 2).
/// Toont tijd van de data en voor elk kanaal een kaart met details.
///
class DashboardScreen extends StatefulWidget {
  /// Data die getoond wordt op het dashboard.
  final DataModel? data;

  /// Constructor.
  const DashboardScreen({super.key, required this.data});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showMPPT = true;
  bool showAccu1 = true;
  bool showAccu2 = true;

  /// Wisselt de filterstatus van het type kanaal.
  ///
  /// Mogelijke types: "mppt", "accu1", "accu2".
  void _toggleFilter(String type) {
    setState(() {
      if (type == "mppt") showMPPT = !showMPPT;
      if (type == "accu1") showAccu1 = !showAccu1;
      if (type == "accu2") showAccu2 = !showAccu2;
    });
  }

  /// Bepaalt of een kanaal getoond moet worden aan de hand van de filters.
  ///
  /// Controleert de naam van het kanaal op keywords.
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

    // Laat laadindicator zien als er nog geen data is.
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BasePage(
      // title kan eventueel hier toegevoegd worden als parameter
      body: RefreshIndicator(
        onRefresh: () async {
          // Hier kun je optioneel een refresh logica toevoegen
        },
        child: Column(
          children: [
            // Filterchips rij met toggles
            Padding(
              padding: const EdgeInsets.all(12),
              child: FilterChipsRow(
                showMPPT: showMPPT,
                showAccu1: showAccu1,
                showAccu2: showAccu2,
                onToggle: _toggleFilter,
              ),
            ),
            // Lijst met kanalen die gefilterd worden weergegeven
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
                      .map<Widget>((c) => ChannelCard(channel: c)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
