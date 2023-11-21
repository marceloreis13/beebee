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
                      Hero(
                        tag: 'splash-logo',
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/img/bee-white.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Entregas',
                          style: Theme.of(context).textTheme.headlineLarge),
                      Text('imediatas',
                          style: Theme.of(context).textTheme.headlineLarge),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: -512,
            left: 10,
            right: 10,
            child: Hero(
              tag: 'splash-card',
              child: CardForm(
                // title: 'Entrar',
                child: SizedBox(
                  height: 512,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
