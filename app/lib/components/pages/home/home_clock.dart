import 'package:edudoro/color.dart';
import 'package:edudoro/components/ui/button.dart';
import 'package:edudoro/providers/clock_setting_provider.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/string.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';

class HomeClock extends StatefulWidget {
  const HomeClock({super.key});

  @override
  State<HomeClock> createState() => _HomeClockState();
}

class _HomeClockState extends State<HomeClock>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isTimeRunning = false;

  double workTime = 0;
  double restTime = 0;
  String stateStatus = "work";

  @override
  void initState() {
    super.initState();
    _check();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    FlutterBackgroundService().on("stateChange").listen((event) {
      if (event != null) {
        if (stateStatus == "work") {
          stateStatus = "rest";
        } else {
          stateStatus = "work";
          _increaseCoin();
        }
      }
    });
  }

  Future<void> _increaseCoin() async {
    try {
      final response = await fetch(
        "/score",
        HTTPMethod.post,
        body: <String, dynamic>{'score': 10},
        withAuth: true,
      );
      if (response.statusCode == 201) {
        if (!context.mounted) return;
        final coinContext = context.read<CoinProvider>();
        coinContext.increaseCoin(10);
      } else {
        toast("There're some problems to increase coin. Sorry for mistake.");
      }
    } catch (e) {
      print("Increase coin fail: $e");
      toast("There're some problems to increase coin. Sorry for mistake. $e");
    }
  }

  void _handleStart() async {
    final service = FlutterBackgroundService();

    service.invoke('start');

    setState(() {
      isTimeRunning = true;
    });
  }

  void _check() {
    final service = FlutterBackgroundService();

    service.invoke("checkPermission");
  }

  void _setting(double workTime, double restTime, String status) {
    final service = FlutterBackgroundService();

    this.workTime = workTime * 60;
    this.restTime = restTime * 60;

    service.invoke("setting", {
      'workTime': workTime * 60,
      'restTime': restTime * 60,
      'status': status,
    });
  }

  void _cancel() {
    final service = FlutterBackgroundService();
    service.invoke("cancel");

    setState(() {
      isTimeRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var settings = context.watch<ClockSettingProvider>();

    if (settings.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(48),
        child: Text("Loading..."),
      );
    }

    _setting(settings.workTime, settings.restTime, 'work');

    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: StreamBuilder(
                  stream: FlutterBackgroundService().on("time_left"),
                  builder: (context, snapshot) {
                    final snapData = snapshot.data;
                    int currentSecond = 0;
                    if (snapData != null) {
                      currentSecond = snapData['value'];
                    }
                    double fullSecond = stateStatus == "work"
                        ? workTime
                        : restTime;

                    if (fullSecond == 0) {
                      fullSecond = 1;
                    }

                    _animationController.animateTo(
                      currentSecond / fullSecond,
                      duration: const Duration(seconds: 1),
                    );

                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: _animationController.value,
                          strokeWidth: 16,
                          backgroundColor: white,
                        );
                      },
                    );
                  },
                ),
              ),
              StreamBuilder(
                stream: FlutterBackgroundService().on("time_left"),
                builder: (context, snapshot) {
                  const textStyle = TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  );

                  if (!snapshot.hasData) {
                    return const Text("Ready", style: textStyle);
                  }

                  final timeLeft = snapshot.data!['value'];

                  return Text(secondToMinuteFormat(timeLeft), style: textStyle);
                },
              ),
            ],
          ),
          SizedBox(height: 32),
          Button(
            label: isTimeRunning ? "GIVE UP" : "START",
            onPressed: isTimeRunning ? _cancel : _handleStart,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
