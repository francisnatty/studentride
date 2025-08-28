import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupFirebaseMessaging() async {
  final messaging = FirebaseMessaging.instance;

  // Request permission on iOS (safe to call on Android too)
  await messaging.requestPermission();

  // Listen to foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'studentride_channel', // channel ID
            'Student Ride Notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
          ),
        ),
      );
    }
  });
}
