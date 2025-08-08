import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getContactsByCategory(String category) async {
    final uid = _auth.currentUser?.uid;
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .where('type', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> triggerAlert(BuildContext context, String category) async {
    final contacts = await getContactsByCategory(category);

    if (!context.mounted) return;

    if (contacts.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("No contacts found"),
        ),
      );
      return;
    }

    final message = Uri.encodeComponent("🚨 DressDown Alert! I need help with a $category emergency!");

    for (final contact in contacts) {
      final rawPhone = contact['phone'];
      final phone = rawPhone.replaceAll(RegExp(r'[^\d]'), '');

      // Attempt WhatsApp first
      final whatsappUri = Uri.parse("https://wa.me/$phone?text=$message");
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        // Fall back to SMS
        final smsUri = Uri.parse("sms:$phone?body=$message");
        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri, mode: LaunchMode.externalApplication);
        }
      }
    }

    //save alert history to firestore
    final uid = _auth.currentUser?.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('alertHistory')
        .add({
      'category': category,
      'timestamp': Timestamp.now(),
      'contacts': contacts,
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Alert Triggered to ${contacts.length} Contacts"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: contacts
              .map((c) => Text("${c['name']} (${c['phone']})"))
              .toList(),
        ),
      ),
    );
  }
}

