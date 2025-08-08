import 'package:dress_down_2/dash_board.dart';
import 'package:dress_down_2/profile_page.dart';
import 'package:dress_down_2/services/contact_service.dart';
import 'package:dress_down_2/setting_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabController;

  final user = FirebaseAuth.instance.currentUser!;

  final List<Widget> _pages = [
    const DashboardTab(),
    const SettingPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_backButtonInterceptor);
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  bool _backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _fabController.dispose();
    BackButtonInterceptor.remove(_backButtonInterceptor);
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  void triggerCategoryAlert(BuildContext context, String category) async {
    final contacts = await ContactService().getContactsByCategory(category);

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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Alert Sent to ${contacts.length} Contacts"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: contacts.map((c) => Text("${c['name']} (${c['phone']})")).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text('DressDown', style: TextStyle(color: colorScheme.onPrimary)),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
        elevation: 0,
      ),

      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.deepPurple[300],
        foregroundColor: colorScheme.onSecondary,
        overlayOpacity: 0.1,
        spacing: 12,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.local_hospital, color: Colors.white),
            backgroundColor: Colors.green,
            onTap: () => Future.microtask(() => ContactService().triggerAlert(context, 'medical')),
          ),
          SpeedDialChild(
            child: const Icon(Icons.home, color: Colors.white),
            backgroundColor: Colors.red,
            onTap: () => Future.microtask(() => ContactService().triggerAlert(context, 'break-in')),
          ),
          SpeedDialChild(
            child: const Icon(Icons.person, color: Colors.white),
            backgroundColor: Colors.amber,
            onTap: () => Future.microtask(() => ContactService().triggerAlert(context, 'personal')),
          ),
        ],
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.outline,
        backgroundColor: colorScheme.surface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_applications_sharp), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }
}
