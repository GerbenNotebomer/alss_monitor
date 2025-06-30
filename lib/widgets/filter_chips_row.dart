import 'package:flutter/material.dart';

class FilterChipsRow extends StatelessWidget {
  final bool showMPPT;
  final bool showAccu1;
  final bool showAccu2;
  final ValueChanged<String> onToggle;

  const FilterChipsRow({
    super.key,
    required this.showMPPT,
    required this.showAccu1,
    required this.showAccu2,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FilterChip(
          label: const Text("MPPT"),
          selected: showMPPT,
          onSelected: (_) => onToggle("mppt"),
        ),
        FilterChip(
          label: const Text("Accu 1"),
          selected: showAccu1,
          onSelected: (_) => onToggle("accu1"),
        ),
        FilterChip(
          label: const Text("Accu 2"),
          selected: showAccu2,
          onSelected: (_) => onToggle("accu2"),
        ),
      ],
    );
  }
}
