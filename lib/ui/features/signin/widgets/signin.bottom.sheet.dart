import 'package:app/ui/widgets/app/bottom.draggable.sheet.dart';
import 'package:flutter/material.dart';
import 'package:storybook/storybook.dart';

class SigninBottomSheet extends StatelessWidget {
  const SigninBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return content(context);
  }

  Widget content(BuildContext context) {
    return BottomDraggableSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Precisa de ajuda?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
    );
  }
}
