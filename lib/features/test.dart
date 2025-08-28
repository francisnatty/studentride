import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TestScren extends StatefulWidget {
  const TestScren({super.key});

  @override
  State<TestScren> createState() => _TestScrenState();
}

class _TestScrenState extends State<TestScren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final fcmToken = await FirebaseMessaging.instance.getToken();
                print(fcmToken);
              },
              child: Text('Text'),
            ),
          ],
        ),
      ),
    );
  }
}
