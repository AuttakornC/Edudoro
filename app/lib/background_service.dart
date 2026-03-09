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
  ClockManager clock = ClockManager();
  clock.onStateChange = (PomodoroState state) =>
      service.invoke("state_change", {'value': state.toString()});
  clock.tickCallback = (int currentTime) =>
      service.invoke("time_left", {'value': currentTime});

  service.on('checkPermission').listen((event) async {
    clock.noti.checkPermission();
  });

  service.on("setting").listen((event) {
    clock.setTime(PomodoroState.work, event?['workTime'] ?? 25 * 60);
    clock.setTime(PomodoroState.rest, event?['restTime'] ?? 25 * 60);
  });

  service.on("start").listen((event) async {
    clock.startAlarm();
  });

  service.on("stop").listen((event) {
    clock.stopAlarm();
  });
}

class FlutterNoti {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NotificationDetails platformChannelSpecifics;
  bool isAllow = false;

  Future<void> checkPermission() async {
    try {
      PermissionStatus status = await Permission.notification.status;
      if (status.isPermanentlyDenied) {
        return;
      }

      if (status.isDenied) {
        status = await Permission.notification.request();
      }

      if (status.isGranted) {
        isAllow = true;

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
      }
    } catch (e) {
      isAllow = false;
      print("Setup Noti Fail: $e");
    }
  }

  Future<void> feat(String title, String body) async {
    if (!isAllow) return;
    await flutterLocalNotificationsPlugin.show(
      id: 888,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
    );
  }

  Future<void> clear() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

enum PomodoroState { work, rest }

class ClockManager {
  PomodoroState state = PomodoroState.work;
  int work = 0;
  int rest = 0;
  int currentTime = 0;
  Timer? timer;
  FlutterNoti noti = FlutterNoti();
  Function(PomodoroState)? onStateChange;
  Function(int)? tickCallback;

  void setTime(PomodoroState timer, int time) {
    if (timer == PomodoroState.work) {
      work = time;
    } else {
      rest = time;
    }
    stopAlarm();
  }

  void startAlarm() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (currentTime <= 0) {
        noti.feat(
          state == PomodoroState.work ? "Working" : "Resting",
          "Finished",
        );

        if (state == PomodoroState.work) {
          currentTime = rest;
          state = PomodoroState.rest;
          changeState(PomodoroState.rest);
        } else {
          currentTime = work;
          state = PomodoroState.work;
          changeState(PomodoroState.work);
        }

        tickCallback?.call(currentTime);
        return;
      }

      noti.feat(
        state == PomodoroState.work ? "Working" : "Resting",
        "Time left: ${secondToMinuteFormat(currentTime)}",
      );

      currentTime--;
      tickCallback?.call(currentTime);
    });
  }

  void stopAlarm() {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    noti.clear();
    currentTime = work;
    tickCallback?.call(currentTime);
    changeState(PomodoroState.work);
  }

  void changeState(PomodoroState inputState) {
    state = inputState;
    onStateChange?.call(inputState);
  }
}
