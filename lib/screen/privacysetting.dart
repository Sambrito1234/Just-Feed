import 'package:flutter/material.dart';

class PrivacySetting extends StatefulWidget {
  const PrivacySetting({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrivacySettingState createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> {
  bool dataSharing = true;
  bool locationTracking = false;
  bool personalizedAds = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Data Sharing'),
            subtitle: const Text('Allow sharing of usage data to improve services.'),
            trailing: Switch(
              value: dataSharing,
              onChanged: (value) {
                setState(() {
                  dataSharing = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      dataSharing ? 'Data Sharing Enabled' : 'Data Sharing Disabled',
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Location Tracking'),
            subtitle: const Text('Enable location tracking for better recommendations.'),
            trailing: Switch(
              value: locationTracking,
              onChanged: (value) {
                setState(() {
                  locationTracking = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      locationTracking ? 'Location Tracking Enabled' : 'Location Tracking Disabled',
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.ad_units),
            title: const Text('Personalized Ads'),
            subtitle: const Text('Receive ads tailored to your preferences.'),
            trailing: Switch(
              value: personalizedAds,
              onChanged: (value) {
                setState(() {
                  personalizedAds = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      personalizedAds ? 'Personalized Ads Enabled' : 'Personalized Ads Disabled',
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
