import 'package:edudoro/color.dart';
import 'package:edudoro/components/ui/button.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:edudoro/utils/string.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(context: context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Clock()],
              ),
            ),
            HomeFooter(),
          ],
        ),
      ),
    );
  }
}

class HomeAppBar extends AppBar {
  HomeAppBar({super.key, required BuildContext context})
    : super(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => {Navigator.of(context).pushNamed("/friend")},
              icon: SVGIcon(
                src: "assets/icons/FriendsIcon.svg",
                height: 24,
                width: 24,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            IconButton(
              onPressed: () => {Navigator.of(context).pushNamed("/profile")},
              icon: SVGIcon(
                src: "assets/icons/ProfileIcon.svg",
                height: 24,
                width: 24,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      );
}

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => {Navigator.of(context).pushNamed("/shop")},
                icon: SVGIcon(src: "assets/icons/CartIcon.svg"),
              ),
              Text(
                "9999",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: yellow100,
                ),
              ),
              SizedBox(width: 2),
              SVGIcon(
                src: "assets/icons/CoinIcon.svg",
                color: yellow100,
                width: 24,
                height: 24,
              ),
            ],
          ),
          IconButton(
            onPressed: () => {Navigator.of(context).pushNamed("/setting")},
            icon: SVGIcon(src: "assets/icons/SettingIcon.svg"),
          ),
        ],
      ),
    );
  }
}

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25 * 60),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      value: 1 - _animationController.value,
                      strokeWidth: 16,
                      backgroundColor: white,
                    );
                  },
                ),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  double value = _animationController.isAnimating
                      ? ((1.0 - _animationController.value) * (25 * 60))
                            .ceil()
                            .toDouble()
                      : 25 * 60;
                  return Text(
                    "${(value / 60).floor()}:${padZero((value % 60).toInt(), 2)}",
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 32),
          Button(
            label: _animationController.isAnimating ? "GIVE UP" : "START",
            onPressed: () => {
              setState(() {
                if (_animationController.isAnimating) {
                  _animationController.stop();
                  _animationController.reset();
                } else {
                  _animationController.forward();
                }
              }),
            },
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
