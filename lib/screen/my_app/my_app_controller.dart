import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:patient_flutter/screen/appointment_chat_screen/appointment_chat_screen_controller.dart';
import 'package:patient_flutter/screen/message_chat_screen/message_chat_screen_controller.dart';
import 'package:patient_flutter/utils/const_res.dart';
import 'package:patient_flutter/utils/update_res.dart';

class MyAppController extends GetxController {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int notificationCount = 0;

  void init() {
    saveTokenUpdate();
    FlutterAppBadger.removeBadge();
  }

  void saveTokenUpdate() async {
    await FirebaseMessaging.instance.subscribeToTopic(ConstRes.subscribeTopic);
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );

    /// Required to display a heads up notification (For iOS)
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        var initializationSettingsAndroid =
            const AndroidInitializationSettings('@mipmap/flutter_luancher');
        var initializationSettingsIOS = const DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false);
        var initializationSettings = InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
        flutterLocalNotificationsPlugin.initialize(initializationSettings);
        RemoteNotification? notification = message.notification;

        if (message.data[nNotificationType] == '0') {
          if (message.data[senderId] != MessageChatScreenController.senderId) {
            showNotification(channel: channel, notification: notification);
          }
        }
        if (message.data[nNotificationType] == '1') {
          if (message.data[nAppointmentId] !=
              AppointmentChatScreenController.appointmentId) {
            showNotification(channel: channel, notification: notification);
          }
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void showNotification(
      {RemoteNotification? notification,
      required AndroidNotificationChannel channel}) {
    log('calling notification');
    flutterLocalNotificationsPlugin.show(
      1,
      notification?.title,
      notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
        ),
        iOS: const DarwinNotificationDetails(
          presentSound: false,
          presentAlert: false,
          presentBadge: false,
        ),
      ),
    );
  }
}
