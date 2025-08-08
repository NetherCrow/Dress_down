import 'package:flutter/material.dart';

class DashboardTab extends StatefulWidget {
  final Function(int)? onNavigate; // Optional navigation callback

  const DashboardTab({super.key, this.onNavigate});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Text(
            "You're safe with DressDown.",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          Card(
            color: colorScheme.secondary.withAlpha(60),
            child: ListTile(
              leading: Icon(Icons.lightbulb, color: Colors.orange[700]),
              title: Text(
                "Tip: Add your emergency contacts now.",
                style: textTheme.bodyMedium,
              ),
            ),
          ),

          const SizedBox(height: 70),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _quickOption(context, Icons.contacts, "Custom Contacts", () {
                Navigator.pushNamed(context, '/contacts');
              }),
              _quickOption(context, Icons.report, "Report Incident", () {
                Navigator.pushNamed(context, '/report');
              }),
              _quickOption(context, Icons.alarm, "Trigger Alarm", () {
                Navigator.pushNamed(context, '/Alarm');
              }),
              _quickOption(context, Icons.history, "History", () {
                Navigator.pushNamed(context, '/History');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(26),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: colorScheme.primary),
            const SizedBox(height: 10),
            Text(label, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
