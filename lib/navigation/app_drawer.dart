import 'package:flutter/material.dart';
import 'package:alls_monitor/services/translations.dart';

/// Sidebar navigatie-menu widget met ondersteuning voor taalwissel en instellingen.
///
/// Toont verschillende navigatie-items en een taalkeuze.
///
class AppDrawer extends StatelessWidget {
  /// Huidige taalcode, bijvoorbeeld 'nl' of 'en'.
  final String currentLang;

  /// Callback om de taal te veranderen, verwacht een nieuwe taalcode als parameter.
  final Future<void> Function(String) onChangeLanguage;

  /// Index van het geselecteerde navigatie-item.
  final int selectedIndex;

  /// Callback die wordt aangeroepen als een menu-item wordt aangeklikt, met index als parameter.
  final ValueChanged<int> onItemTapped;

  /// Callback om het instellingen-scherm te openen.
  final VoidCallback onOpenSettings;

  /// Constructor voor [AppDrawer].
  const AppDrawer({
    Key? key,
    required this.currentLang,
    required this.onChangeLanguage,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onOpenSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.teal),
            child: Text(
              Translations.t('root.menu'),
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(Translations.t('nav.dashboard')),
            selected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.speed),
            title: Text(Translations.t('nav.meters')),
            selected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(Translations.t('nav.raw_json')),
            selected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(Translations.t('nav.settings')),
            selected: selectedIndex == 3,
            onTap: () {
              Navigator.of(context).pop();
              onOpenSettings();
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(Translations.t('instellingen.taal.label')),
            subtitle: Text(currentLang.toUpperCase()),
            onTap: () async {
              final availableLangs = Translations.getLanguageKeys();

              final selectedLang = await showDialog<String>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(Translations.t('instellingen.taal.label')),
                  children: availableLangs.map((langCode) {
                    return SimpleDialogOption(
                      child: Text(
                        Translations.getLanguageDisplayName(langCode),
                      ),
                      onPressed: () => Navigator.pop(context, langCode),
                    );
                  }).toList(),
                ),
              );

              if (selectedLang != null && selectedLang != currentLang) {
                await onChangeLanguage(selectedLang);
                Navigator.of(context).pop(); // Sluit drawer na taalwissel
              }
            },
          ),
        ],
      ),
    );
  }
}
