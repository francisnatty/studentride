import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentride/core/helper/enum.dart';
import 'package:studentride/features/auth/notifier/auth_session_notifier.dart';
import 'package:studentride/features/auth/screens/login.dart';
import 'package:studentride/features/home/screen/driver_home_screen.dart';
import 'package:studentride/features/home/screen/home_screen.dart';

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthSessionNotifier>();

    switch (session.status) {
      case SessionStatus.loading:
      case SessionStatus.unknown:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
        );
      case SessionStatus.unauthenticated:
        return const LoginPage();
      case SessionStatus.authenticated:
        if (session.isPassenger) return const DriverHomeScreen();
        if (session.isDriver) return const HomeScreen();
        return const LoginPage();
    }
  }
}
