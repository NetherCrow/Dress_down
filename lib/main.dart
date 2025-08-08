import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:dress_down_2/Theme/dark_mode.dart';
import 'package:dress_down_2/Theme/light_mode.dart';
import 'package:dress_down_2/Theme/theme_provider.dart';
import 'package:dress_down_2/auth_page.dart';
import 'package:dress_down_2/profile_page.dart';
import 'package:dress_down_2/report_page.dart';
import 'package:dress_down_2/setting_page.dart';
import 'package:dress_down_2/alarm_page.dart';
import 'package:dress_down_2/contacts_page.dart';
import 'package:dress_down_2/history.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      themeMode: themeProvider.themeMode,
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/report': (_) => const ReportPage(),
        '/profile': (_) => const ProfilePage(),
        '/Alarm': (_) => const AlarmPage(),
        '/contacts': (_) => const ContactsPage(),
        '/History': (_) => const History(),
        '/Settings': (_) => const SettingPage()
      },
    );
  }
}
