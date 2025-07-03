import 'package:flutter/material.dart';

/// Een rij met filterchips waarmee specifieke filters in- of uitgeschakeld kunnen worden.
///
/// Toont drie chips: MPPT, Accu 1 en Accu 2.
/// Elke chip heeft een boolean om de selectie-status aan te geven.
/// Bij een tap wordt via [onToggle] de corresponderende filter-key teruggegeven.
class FilterChipsRow extends StatelessWidget {
  /// Geeft aan of de MPPT-chip geselecteerd is.
  final bool showMPPT;

  /// Geeft aan of de Accu 1-chip geselecteerd is.
  final bool showAccu1;

  /// Geeft aan of de Accu 2-chip geselecteerd is.
  final bool showAccu2;

  /// Callback functie die wordt aangeroepen met de naam van de chip die is veranderd.
  final ValueChanged<String> onToggle;

  /// Constructor voor [FilterChipsRow].
  ///
  /// Vereist alle selectie-waarden en de [onToggle] callback.
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
