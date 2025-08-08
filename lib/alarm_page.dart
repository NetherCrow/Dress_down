import 'package:flutter/material.dart';
import '../services/contact_service.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  // Alert trigger function
  Future<void> _triggerAlert(BuildContext context, String category) async {
    final contacts = await ContactService().getContactsByCategory(category);

    if (!context.mounted) return;

    if (contacts.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("No contacts found"),
          content: Text("Please add contacts for this category."),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Alert Sent to ${contacts.length} Contacts"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: contacts
              .map((c) => Text("${c['name']} (${c['phone']})"))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trigger Alarm"),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildPanicButton(
              context: context,
              icon: Icons.local_hospital,
              label: "Medical Emergency",
              color: Colors.green,
              category: "medical",
            ),
            const SizedBox(height: 20),
            _buildPanicButton(
              context: context,
              icon: Icons.home,
              label: "Break-in Emergency",
              color: Colors.red,
              category: "break-in",
            ),
            const SizedBox(height: 20),
            _buildPanicButton(
              context: context,
              icon: Icons.person,
              label: "Personal Emergency",
              color: Colors.amber,
              category: "personal",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanicButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required String category,
  }) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.black : Colors.white;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => _triggerAlert(context, category),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
