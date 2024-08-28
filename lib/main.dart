import 'package:add_boat/firebase_options.dart';
import 'package:add_boat/screens/tabs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_platform/universal_platform.dart';

final theme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.kanitTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (UniversalPlatform.isWeb) {
    // Web-specific Firebase initialization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boat Service Manager',
      theme: theme,
      home: const TabsScreen(),
    );
  }
}
