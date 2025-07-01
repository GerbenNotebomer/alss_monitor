import 'package:flutter/material.dart';
import 'dart:convert';

class RawJsonScreen extends StatelessWidget {
  final Map<String, dynamic> jsonData;

  const RawJsonScreen({super.key, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);

    return Scaffold(
      appBar: AppBar(title: const Text('Raw JSON View')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: SelectableText(
            prettyJson,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ),
      ),
    );
  }
}
