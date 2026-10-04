import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceFeatureScreen extends StatelessWidget {
  const DeviceFeatureScreen({super.key});

  Future<void> _openWebsite(BuildContext context) async {
    final Uri url = Uri.parse('https://flutter.dev');
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open https://flutter.dev'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching URL: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Feature: URL Launcher'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.open_in_browser,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                'Open External Documentation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Launches the official Flutter website using the url_launcher package.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _openWebsite(context),
                icon: const Icon(Icons.launch),
                label: const Text('Launch flutter.dev'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}