import 'package:flutter/material.dart';
import 'package:app/app/routes/route.dart';
import 'package:storybook/storybook.dart';

class LaunchScreen extends StatefulWidget {
  final Future<bool> Function() setUpInitialConfigurations;
  const LaunchScreen({
    super.key,
    required this.setUpInitialConfigurations,
  });

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    widget.setUpInitialConfigurations().then((isLoggedIn) {
      isLoggedIn
          ? Routes.goTo.rootLoggedIn(context)
          : Routes.goTo.rootLoggedOut(context);
    });

    super.initState();
  }

  void setUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 512),
                    alignment: Alignment.centerRight,
                    child: Image.asset('assets/img/splash.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 96,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Hero(
                        tag: 'splash-logo',
                        child: LogoImage(size: 48),
                      ),
                      const SizedBox(height: 24),
                      Text('Entregas\nimediatas',
                          style: Theme.of(context).textTheme.headlineLarge),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
