import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart'; // 👈 Import
import 'package:provider/provider.dart';
import 'package:studentride/core/utils/logger/local_storage.dart';
import 'package:studentride/features/auth/notifier/auth_notifier.dart';
import 'package:studentride/features/auth/screens/session_gate.dart';
import 'package:studentride/features/home/data/repo/home_repo.dart';
import 'package:studentride/features/home/sm/booking_provider.dart';
import 'package:studentride/features/home/sm/driver_home_provider.dart';
import 'package:studentride/features/test.dart';
import 'package:studentride/firebase_options.dart';
import 'package:studentride/flutter_local_notification.dart';
import 'features/auth/data/repo/auth_repo.dart';

import 'features/auth/notifier/auth_session_notifier.dart';
import 'features/home/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize local notifications
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Setup FCM
  await setupFirebaseMessaging();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) =>
                  AuthSessionNotifier(storage: LocalStorageImpl())..bootstrap(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(authRepo: AuthRepoImpl()),
        ),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(
          create: (_) => DriverHomeProvider(HomeRepoImpl()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Ride',
      theme: ThemeData(
        textTheme: GoogleFonts.figtreeTextTheme(), // 👈 Use Figtree
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: OTPVerificationScreen(email: 'fnathaniel929@gmail.com'),
      //    home: HomeScreen(),
      //  home: SessionGate(),
      home: TestScren(),
    );
  }
}
