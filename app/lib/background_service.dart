/// File: background_service.dart
///
/// Description: Manages background services, notifications, and Pomodoro timer logic for Edudoro.
///
/// Responsibilities:
/// - Initializes and configures background services.
/// - Handles notification permissions and delivery.
/// - Manages Pomodoro timer state and transitions.
/// - Provides audio and vibration feedback.
///
/// Author: Auttakorn Camsoi
/// Course: Mobile Application Development Framework

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:edudoro/utils/string.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Initializes the background service for the application.
///
/// Side effects: Configures background execution, notification channels, and event listeners.
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

/// Entry point for background service execution.
///
/// Registers event listeners for timer state, permission checks, and alarm control.
///
/// Side effects: Invokes service events, updates timer state, and manages notifications.
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
  AudioPlayer player = AudioPlayer();
  bool isAllow = false;

  /// Checks and requests notification permissions from the user.
  ///
  /// Side effects: May prompt the user for permissions and update [isAllow].
  ///
  /// Throws [PlatformException] if permission request fails.
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

  /// Displays a notification with the given [title] and [body].
  ///
  /// Side effects: Shows a local notification to the user.
  ///
  /// Throws [PlatformException] if notification fails.
  Future<void> feat(String title, String body) async {
    if (!isAllow) return;
    await flutterLocalNotificationsPlugin.show(
      id: 888,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
    );
  }

  /// Clears all delivered notifications.
  ///
  /// Side effects: Removes all notifications from the notification tray.
  Future<void> clear() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Plays a notification sound and triggers device vibration.
  ///
  /// Side effects: Plays audio and vibrates the device.
  Future<void> soundAndVibrate() async {
    await player.setAudioContext(
      AudioContext(
        iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
        android: AudioContextAndroid(usageType: AndroidUsageType.notification),
      ),
    );

    await player.play(AssetSource('noti.mp3'));

    Future.delayed(Duration(seconds: 1), () {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    });
  }
}

/// Represents the Pomodoro timer state.
enum PomodoroState { work, rest }

/// Manages Pomodoro timer logic, state transitions, and notification integration.
class ClockManager {
  PomodoroState state = PomodoroState.work;
  int work = 0;
  int rest = 0;
  int currentTime = 0;
  Timer? timer;
  FlutterNoti noti = FlutterNoti();
  Function(PomodoroState)? onStateChange;
  Function(int)? tickCallback;

  /// Sets the timer duration for the given [timer] state.
  ///
  /// Side effects: Updates internal timer values and resets alarm.
  void setTime(PomodoroState timer, int time) {
    if (timer == PomodoroState.work) {
      work = time;
    } else {
      rest = time;
    }
    stopAlarm();
  }

  /// Starts the Pomodoro timer and handles state transitions.
  ///
  /// Side effects: Notifies listeners, triggers notifications, and manages timer lifecycle.
  void startAlarm() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (currentTime <= 0) {
        noti.feat(
          state == PomodoroState.work ? "Working" : "Resting",
          "Finished",
        );

        noti.soundAndVibrate();

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

  /// Stops the Pomodoro timer and resets state.
  ///
  /// Side effects: Cancels the timer, clears notifications, and resets timer values.
  void stopAlarm() {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    noti.clear();
    currentTime = work;
    tickCallback?.call(currentTime);
    changeState(PomodoroState.work);
  }

  /// Changes the current Pomodoro state to [inputState].
  ///
  /// Side effects: Updates state and notifies listeners.
  void changeState(PomodoroState inputState) {
    state = inputState;
    onStateChange?.call(inputState);
  }
}
