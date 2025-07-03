import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:alls_monitor/widgets/widgets.dart';

/// Scherm dat een JSON-object als geformatteerde tekst weergeeft.
///
/// Dit scherm toont de ruwe JSON-data netjes ingesprongen en
/// maakt de tekst selecteerbaar, zodat gebruikers het kunnen kopiëren.
///
class RawJsonScreen extends StatelessWidget {
  /// Het JSON-object dat weergegeven moet worden.
  final Map<String, dynamic> jsonData;

  /// Constructor met verplichte JSON-data.
  const RawJsonScreen({super.key, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    // JSON netjes indented maken met 2 spaties per niveau
    final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);

    return BasePage(
      // Titel kan toegevoegd worden indien gewenst
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: SelectableText(
            prettyJson,
            style: const TextStyle(
              fontFamily: 'monospace', // Voor betere leesbaarheid
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
