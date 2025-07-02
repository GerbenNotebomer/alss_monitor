import 'package:flutter/material.dart';
import '../services/translations.dart';

class AppDrawer extends StatelessWidget {
  final String currentLang;
  final Future<void> Function(String) onChangeLanguage;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const AppDrawer({
    Key? key,
    required this.currentLang,
    required this.onChangeLanguage,
    required this.selectedIndex,
    required this.onItemTapped,
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
                Navigator.of(context).pop(); // Sluit drawer na taal wissel
              }
            },
          ),
        ],
      ),
    );
  }
}
