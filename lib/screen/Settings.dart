import 'package:flutter/material.dart';
import 'privacysetting.dart'; // Import Privacy Settings Page

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';
  List<String> languages = ['English', 'Spanish', 'French'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Notifications Toggle
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  notificationsEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      notificationsEnabled ? 'Notifications Enabled' : 'Notifications Disabled',
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),

          // Privacy Settings
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacySetting(),
                ),
              );
            },
          ),
          const Divider(),

          // Language Selection
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(selectedLanguage),
            onTap: () {
              _showLanguageSelection(context);
            },
          ),
          const Divider(),

          // About Us
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Language Selection with Add Option
  void _showLanguageSelection(BuildContext context) {
    TextEditingController customLanguageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select or Add Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...languages.map((language) {
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    setState(() {
                      selectedLanguage = language;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language changed to $language')),
                    );
                  },
                );
              }),
              const Divider(),
              TextField(
                controller: customLanguageController,
                decoration: const InputDecoration(
                  labelText: 'Add Custom Language',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (customLanguageController.text.isNotEmpty) {
                  setState(() {
                    languages.add(customLanguageController.text);
                    selectedLanguage = customLanguageController.text;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Language added: ${customLanguageController.text}'),
                    ),
                  );
                }
              },
              child: const Text('Add Language'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // About Us Dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Us'),
          content: const Text(
            'Just Feed is a food delivery app providing delicious meals at your doorstep. Enjoy the best cuisines from popular restaurants near you!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
