import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';

import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'location_callback_handler.dart';

Future<void> startLocationService() async {
  await BackgroundLocator.initialize();

  BackgroundLocator.registerLocationUpdate(
    callback,
    initCallback: initCallback,
    disposeCallback: disposeCallback,
    autoStop: false,
    iosSettings: const IOSSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      distanceFilter: 0,
    ),
    androidSettings: const AndroidSettings(
      accuracy: LocationAccuracy.NAVIGATION,
      interval: 10, // cada 10 segundos
      distanceFilter: 0,
      androidNotificationSettings: AndroidNotificationSettings(
        notificationChannelName: 'Topografía Tracker',
        notificationTitle: '📡 Rastreo activo',
        notificationMsg: 'Enviando ubicación en tiempo real...',
        notificationIcon: '', // aquí puedes poner tu ícono personalizado
      ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gbrdjjlhcxhbzbrzybwn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdicmRqamxoY3hoYnpicnp5YnduIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NDQ1NTcsImV4cCI6MjA2OTUyMDU1N30.kY4vdIknblqW3V2s9EwY_Z4pW5ZpLHs0a3df3-j1Wfg',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Topografía App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 3,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue.shade300,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade300,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.system, // ✅ Cambia automáticamente claro/oscuro
      home: session == null ? const AuthPage() : const HomePage(),
    );
  }
}

