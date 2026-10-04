import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Task & Profile Manager'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 700;

          final items = [
            _NavigationCard(
              title: 'Add Note / Profile',
              subtitle: 'Fill and validate form data',
              icon: Icons.note_add,
              color: Colors.blueAccent,
              route: '/add-note',
            ),
            _NavigationCard(
              title: 'Saved Local Data',
              subtitle: 'View and manage offline data',
              icon: Icons.storage,
              color: Colors.green,
              route: '/saved-notes',
            ),
            _NavigationCard(
              title: 'REST API & Challenge',
              subtitle: 'Fetch posts and star favourites',
              icon: Icons.cloud_download,
              color: Colors.orange,
              route: '/api-data',
            ),
            _NavigationCard(
              title: 'Device Feature',
              subtitle: 'Open browser documentation',
              icon: Icons.open_in_browser,
              color: Colors.purple,
              route: '/device-feature',
            ),
          ];

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: isWide
                    ? GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.2,
                        children: items,
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: items
                            .map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: item,
                                ))
                            .toList(),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _NavigationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}