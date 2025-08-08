import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _controller = TextEditingController();
  bool _includeLocation = false;
  bool _isSubmitting = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1️⃣ Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    // 2️⃣ Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission permanently denied")),
      );
      return null;
    }

    // 3️⃣ Get current position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    // 4️⃣ Get address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;
    String readableAddress =
        "${place.street}, ${place.locality}, ${place.country}";

    return {
      'address': readableAddress,
      'lat': position.latitude,
      'lng': position.longitude,
    };
  }

  Future<void> _submitReport() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);

    final uid = _auth.currentUser?.uid;
    Map<String, dynamic>? locationData;

    if (_includeLocation) {
      try {
        locationData = await _getLocation();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to get location: $e")),
        );
      }
    }

    final reportData = {
      'description': text,
      'includeLocation': _includeLocation,
      'timestamp': Timestamp.now(),
      if (locationData != null) ...{
        'location': locationData['address'],
        'lat': locationData['lat'],
        'lng': locationData['lng'],
      }
    };

    // Save to 'reports'
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('reports')
        .add(reportData);

    // Also save to alertHistory
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('alertHistory')
        .add({
      'type': 'report',
      'description': text,
      'timestamp': Timestamp.now(),
      'includeLocation': _includeLocation,
      if (locationData != null) ...{
        'location': locationData['address'],
        'lat': locationData['lat'],
        'lng': locationData['lng'],
      }
    });

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _controller.clear();
      _includeLocation = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report submitted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
        theme.appBarTheme.backgroundColor ?? Colors.deepPurple,
        title: Text(
          "Report Incident",
          style: TextStyle(color: color.onPrimary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Describe what happened",
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor ??
                    theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("Include location"),
              value: _includeLocation,
              activeColor: Colors.deepPurple,
              onChanged: (val) => setState(() => _includeLocation = val),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isSubmitting
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.send),
                label: Text(
                    _isSubmitting ? "Submitting..." : "Submit Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isSubmitting ? null : _submitReport,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
