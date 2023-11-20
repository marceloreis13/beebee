import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BBFormSectionWidget extends StatelessWidget {
  final String? title;
  final TextAlign titleAlign;
  final Color? cardColor;
  final List<Widget> children;
  final bool withCardEffect;
  bool hidden;
  EdgeInsets? wrapPadding;
  EdgeInsets? paddingBottom;

  BBFormSectionWidget({
    super.key,
    required this.children,
    this.title,
    this.titleAlign = TextAlign.left,
    this.cardColor,
    this.wrapPadding = const EdgeInsets.all(14),
    this.hidden = false,
    this.withCardEffect = true,
    this.paddingBottom,
  });

  @override
  Widget build(BuildContext context) {
    return hidden
        ? const SizedBox()
        : Padding(
            padding: paddingBottom ?? const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title == null || title!.isEmpty
                    ? const SizedBox()
                    : Text(
                        title!.toUpperCase(),
                        textScaleFactor: 1.3,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                const SizedBox(height: 10.0),
                Card(
                  color: withCardEffect ? cardColor : Colors.transparent,
                  elevation: withCardEffect ? 0.5 : 0,
                  margin: EdgeInsets.symmetric(
                    vertical: withCardEffect ? 4.0 : 0,
                    horizontal: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        children.map((field) => wrapField(field)).toList(),
                  ),
                ),
              ],
            ),
          );
  }

  Widget wrapField(Widget field) {
    final isHidden = field is Visibility && !field.visible;
    EdgeInsets? padding =
        !withCardEffect || isHidden ? EdgeInsets.zero : wrapPadding;
    return Column(
      children: <Widget>[
        Container(
          padding: padding,
          child: field,
        ),
      ],
    );
  }
}
