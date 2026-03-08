import 'package:edudoro/providers/clock_setting_provider.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:edudoro/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLoading();
    });
  }

  Future<void> _startLoading() async {
    final coinProv = context.read<CoinProvider>();
    final clockProv = context.read<ClockSettingProvider>();

    final arraySuccess = await Future.wait([
      coinProv.loadCoin(),
      clockProv.loadSettings(),
    ]);

    if (arraySuccess.every((element) => element)) {
      Nav.goTo("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/edudoro-logo.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
