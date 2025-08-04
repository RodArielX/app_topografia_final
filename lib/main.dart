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
      interval: 10,
      distanceFilter: 0,
      androidNotificationSettings: AndroidNotificationSettings(
        notificationChannelName: 'Topografía Tracker',
        notificationTitle: 'Rastreo activo',
        notificationMsg: 'Enviando ubicación en tiempo real',
        notificationIcon: '',
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: session == null ? const AuthPage() : const HomePage(),
    );
  }
}
