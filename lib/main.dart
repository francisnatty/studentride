import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // 👈 Import
import 'package:provider/provider.dart';
import 'package:studentride/features/auth/notifier/auth_notifier.dart';
import 'features/auth/data/repo/auth_repo.dart';
import 'features/auth/screens/create_acct.dart';
import 'features/auth/screens/login.dart';
import 'features/auth/screens/verifyotp.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(authRepo: AuthRepoImpl()),
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
      home: OTPVerificationScreen(email: 'fnathaniel929@gmail.com'),
    );
  }
}
