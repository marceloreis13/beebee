library storybook;

import 'package:flutter/material.dart';

part 'widgets/typography.dart';

class StoryBook extends StatelessWidget {
  const StoryBook({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story Book',
      routes: {
        '/': (context) => const StoryBookHome(),
        '/typography': (context) => const TypographyStory(),
        // '/buttons': (context) => ButtonsStory(),
        // '/colors': (context) => ColorsStory(),
      },
    );
  }
}

class StoryBookHome extends StatelessWidget {
  const StoryBookHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Book'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/typography');
                  },
                  child: const Text('Typography'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
