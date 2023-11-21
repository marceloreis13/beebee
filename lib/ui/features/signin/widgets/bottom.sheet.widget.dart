import 'package:flutter/material.dart';
import 'package:storybook/storybook.dart';

class SigninBottomSheet extends StatelessWidget {
  const SigninBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return newMethod;
  }

  DraggableScrollableSheet get newMethod {
    return DraggableScrollableSheet(
      initialChildSize: 0.07,
      minChildSize: 0.07,
      maxChildSize: 0.7,
      snap: true,
      snapSizes: const [0.07, 0.7],
      builder: (BuildContext context, ScrollController scrollController) {
        double bottomPadding = MediaQuery.of(context).padding.bottom;

        if (bottomPadding < 16) bottomPadding = 16;

        return Card(
          elevation: 0,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    IgnorePointer(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 16,
                                bottom: bottomPadding,
                              ),
                              height: 4,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text('Precisa de ajuda?',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CardMini(
                                  text: 'Central de ajuda',
                                  height: 200,
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CardMini(
                                  text: 'Falar pelo whatsapp',
                                  height: 200,
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CardMini(
                            text: 'Conversar pelo chat',
                            height: 100,
                            onTap: () {},
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
