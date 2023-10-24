import 'package:flutter/material.dart';
import 'package:app/app/routes/route.dart';

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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/launch-screen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: null,
    );
  }
}
