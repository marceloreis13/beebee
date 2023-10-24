import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:app/app/extensions/text.extension.dart';
import 'package:app/ui/widgets/headers/header.search.widget.dart';

class HeaderControls extends StatelessWidget {
  final String title;
  final List<Widget>? rightActions;
  final List<Widget>? leftActions;
  final HeaderSearch? headerSearch;
  final bool isModal;

  const HeaderControls({
    super.key,
    required this.title,
    this.rightActions,
    this.leftActions,
    this.headerSearch,
    this.isModal = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasRightActions = rightActions == null || rightActions!.isEmpty;
    final hasLeftActions = leftActions == null || leftActions!.isEmpty;
    // final screenHeight = MediaQuery.of(context).size.height;

    double screenHeight = MediaQuery.of(context).size.height;
    double biggestScreen = screenHeight > 900 ? screenHeight : 900;
    double smallestScreen = screenHeight < 600 ? screenHeight : 600;
    double factor = 30 / (biggestScreen - smallestScreen);

    double topPadding = 22.0 + (screenHeight - smallestScreen) * factor;
    double height = 80.0 + (screenHeight - smallestScreen) * factor;

    final padding = EdgeInsets.only(
      top: isModal ? 0.0 : topPadding,
      right: 10,
      bottom: 0,
      left: 10,
    );

    return Column(
      children: [
        Container(
          height: isModal ? 50.0 : height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                hasLeftActions
                    ? const SizedBox(
                        width: 32,
                      )
                    : Row(
                        children: leftActions!,
                      ),
                Expanded(
                  child: AutoSizeText(title,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      textScaleFactor: ExtText.textScaleFactor(context),
                      style: Theme.of(context).textTheme.displaySmall),
                ),
                hasRightActions
                    ? const SizedBox(
                        width: 32,
                      )
                    : Row(
                        children: rightActions!,
                      ),
              ],
            ),
          ),
        ),
        headerSearch != null
            ? Column(
                children: [
                  const Divider(),
                  headerSearch!,
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
