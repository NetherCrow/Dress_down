import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final Map<String, String> _queries = {
    'medical': '',
    'break-in': '',
    'personal': '',
  };

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  final categoryLabels = {
    'medical': 'Medical',
    'break-in': 'Break-in',
    'personal': 'Personal',
  };

  final categoryIcons = {
    'medical': Icons.local_hospital,
    'break-in': Icons.security,
    'personal': Icons.family_restroom,
  };

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['medical', 'break-in', 'personal'];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: colorScheme.primary,
            child: TabBar(
              controller: _tabController,
              unselectedLabelColor: Colors.grey[300],
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              indicator: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              tabs: const [
                Tab(icon: Icon(Icons.local_hospital, color: Colors.green), text: 'Medical'),
                Tab(icon: Icon(Icons.security, color: Colors.red), text: 'Break-in'),
                Tab(icon: Icon(Icons.family_restroom, color: Colors.orange), text: 'Personal'),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: TabBarView(
        controller: _tabController,
        children: categories.map((category) => _buildContactTab(context, category)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final currentCategory = categories[_tabController.index];
          _showContactDialog(context: context, category: currentCategory);
        },
        backgroundColor: colorScheme.secondaryContainer,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildContactTab(BuildContext context, String category) {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .where('type', isEqualTo: category);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            onChanged: (val) => setState(() => _queries[category] = val),
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: "Search ${categoryLabels[category]} contacts...",
              prefixIcon: Icon(Icons.search, color: colorScheme.primary),
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: ref.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredDocs = snapshot.data!.docs.where((doc) {
                final name = doc['name'].toString().toLowerCase();
                final phone = doc['phone'].toString().toLowerCase();
                final query = _queries[category]?.toLowerCase() ?? '';
                return name.contains(query) || phone.contains(query);
              }).toList();

              if (filteredDocs.isEmpty) {
                return Center(
                  child: Text(
                    "No ${categoryLabels[category]} contacts found.",
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (_, i) {
                  final contact = filteredDocs[i];
                  return Card(
                    color: colorScheme.surface,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: Icon(Icons.person, color: _getColor(category)),
                      title: Text(contact['name'], style: theme.textTheme.bodyLarge),
                      subtitle: Text(contact['phone'], style: theme.textTheme.bodySmall),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showContactDialog(context: context, category: category, doc: contact),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: Text("Are you sure you want to delete ${contact['name']}?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await contact.reference.delete();
                              }
                            },
                          ),

                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }

  void _showContactDialog({
    required BuildContext context,
    required String category,
    DocumentSnapshot? doc,
  }) {
    final isEdit = doc != null;
    final nameController = TextEditingController(text: doc?['name'] ?? '');
    final phoneController = TextEditingController(text: doc?['phone'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Contact' : 'Add ${categoryLabels[category]} Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final data = {
                'name': nameController.text.trim(),
                'phone': phoneController.text.trim(),
                'type': category,
              };

              final ref = FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('contacts');

              if (isEdit) {
                doc.reference.update(data);
              } else {
                ref.add(data);
              }

              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  Color _getColor(String category) {
    switch (category) {
      case 'medical':
        return Colors.green;
      case 'break-in':
        return Colors.red;
      case 'personal':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
