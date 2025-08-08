import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final List<Map<String, dynamic>> allHistory = [];

    // Fetch panic alerts
    final alertsSnapshot = await FirebaseFirestore.instance
        .collection('panic_alerts')
        .orderBy('timestamp', descending: true)
        .get();

    for (var doc in alertsSnapshot.docs) {
      final data = doc.data();
      allHistory.add({
        'id': doc.id,
        'type': data['type'] ?? 'Unknown',
        'address': data['location']?['address'] ?? 'Address not available',
        'timestamp': data['timestamp']?.toDate(),
        'source': 'alert',
      });
    }

    // Fetch incident reports
    final reportsSnapshot = await FirebaseFirestore.instance
        .collection('incident_reports')
        .orderBy('timestamp', descending: true)
        .get();

    for (var doc in reportsSnapshot.docs) {
      final data = doc.data();
      allHistory.add({
        'id': doc.id,
        'type': data['type'] ?? 'Report',
        'address': data['location']?['address'] ?? 'Address not available',
        'timestamp': data['timestamp']?.toDate(),
        'source': 'report',
      });
    }

    // Sort all items by timestamp
    allHistory.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

    return allHistory;
  }

  void _deleteHistoryItem(String id, String source) async {
    String collection =
    (source == 'alert') ? 'panic_alerts' : 'incident_reports';

    await FirebaseFirestore.instance.collection(collection).doc(id).delete();
    setState(() {}); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history found.'));
          }

          final history = snapshot.data!;

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(item['address']),
                  subtitle: Text(dateFormat.format(item['timestamp'])),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteHistoryItem(
                      item['id'],
                      item['source'],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
