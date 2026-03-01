import 'dart:async';

import 'package:edudoro/utils/string.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(autoStart: false, onForeground: onStart),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  bool notiIsGranted = false;
  int workTime = 0;
  int restTime = 0;
  int currentTime = 0;
  String currentStatus = "work"; // work or rest
  bool isCancel = false;
  bool isStarted = false;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NotificationDetails platformChannelSpecifics;

  service.on('checkPermission').listen((event) async {
    try {
      PermissionStatus status = await Permission.notification.status;
      if (status.isPermanentlyDenied) {
        notiIsGranted = false;
        return;
      }

      if (status.isDenied) {
        status = await Permission.notification.request();
      }

      if (status.isGranted) {
        notiIsGranted = true;

        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings(
              '@mipmap/ic_launcher',
            ); // Ensure icon exists

        const InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);

        await flutterLocalNotificationsPlugin.initialize(
          settings: initializationSettings,
        );

        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
              'edudoro_timer_id',
              'Focus Timer',
              channelDescription: 'Showing active timer progress',
              importance: Importance.low,
              priority: Priority.low,
              ongoing: true,
              showWhen: false,
              icon: '@mipmap/ic_launcher',
            );

        platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
        );
      } else {
        notiIsGranted = false;
      }
    } catch (e) {
      notiIsGranted = false;
      print("Setup Noti Fail: $e");
    }
  });

  service.on("setting").listen((event) {
    workTime = event?['workTime'] ?? 25 * 60;
    restTime = event?['restTime'] ?? 25 * 60;
    currentTime = workTime;
    currentStatus = event?['status'] ?? 'work';
    if (isStarted) isCancel = true;
    service.invoke("time_left", {'value': workTime});
  });

  service.on("start").listen((event) async {
    Timer.periodic(const Duration(seconds: 1), (t) async {
      if (currentTime <= 0) {
        if (notiIsGranted) {
          await flutterLocalNotificationsPlugin.show(
            id: 888,
            title: currentStatus == "work" ? "Working" : "Resting",
            body: "Finished",
            notificationDetails: platformChannelSpecifics,
          );
        }

        if (currentStatus == "work") {
          currentTime = restTime;
          currentStatus = "rest";
          service.invoke("stateChange", {'value': "rest"});
        } else {
          currentTime = workTime;
          currentStatus = "work";
          service.invoke("stateChange", {'value': "work"});
        }

        service.invoke("time_left", {'value': currentTime});
        return;
      }

      if (isCancel) {
        currentTime = workTime;
        isCancel = false;
        isStarted = false;
        t.cancel();
        if (notiIsGranted) await flutterLocalNotificationsPlugin.cancelAll();
        return;
      }

      if (notiIsGranted) {
        await flutterLocalNotificationsPlugin.show(
          id: 888,
          title: currentStatus == "work" ? "Working" : "Resting",
          body: "Time left: ${secondToMinuteFormat(currentTime)}",
          notificationDetails: platformChannelSpecifics,
        );
      }

      service.invoke("time_left", {'value': currentTime});
      currentTime--;
    });
  });

  service.on("cancel").listen((event) {
    isCancel = true;
    service.invoke("time_left", {'value': workTime});
    if (currentStatus == "rest") {
      currentStatus = "work";
      service.invoke("stateChange", {'value': "work"});
    }
  });
}
