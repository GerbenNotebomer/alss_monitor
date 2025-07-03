import 'package:flutter/material.dart';

/// Een algemene pagina-layout widget met optionele appbar, body, footer en floating action button.
///
/// Gebruik deze widget als basis voor pagina's om consistentie in layout te behouden.
///
class BasePage extends StatelessWidget {
  /// Titel van de pagina, getoond in de AppBar.
  /// Als null, wordt er geen AppBar getoond.
  final String? title;

  /// Het hoofdgedeelte van de pagina.
  final Widget body;

  /// Optionele actieknoppen in de AppBar.
  final List<Widget>? actions;

  /// Optionele floating action button.
  final Widget? floatingActionButton;

  /// Optionele footer onderaan de pagina.
  final Widget? footer;

  /// Constructor voor [BasePage].
  ///
  /// [body] is verplicht.
  /// [title], [actions], [floatingActionButton] en [footer] zijn optioneel.
  const BasePage({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Toon AppBar alleen als er een title is opgegeven
      appBar: title != null
          ? AppBar(title: Text(title!), actions: actions)
          : null,

      // Body en optionele footer in een kolom
      body: Column(
        children: [
          Expanded(child: body),
          if (footer != null) footer!,
        ],
      ),

      // Optionele floating action button
      floatingActionButton: floatingActionButton,
    );
  }
}
