import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentride/features/auth/notifier/home_nav.dart';
import 'package:studentride/features/auth/screens/login.dart';

import 'features/auth/notifier/auth_session.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthSession>(
      builder: (context, authProvider, child) {
        switch (authProvider.authState) {
          case AuthState.loading:
            return const SplashScreen();

          case AuthState.unauthenticated:
            return const LoginPage();

          case AuthState.authenticated:
            return const StudentRideApp();
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'StudentRide',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Safe rides for students',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
