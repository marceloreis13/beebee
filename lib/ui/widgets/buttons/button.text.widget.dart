import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ButtonTextWidget extends StatelessWidget {
  final String label;
  final TextStyle? style;
  final Function()? onTap;

  const ButtonTextWidget({
    super.key,
    required this.label,
    this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return button(context);
  }

  Widget button(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AutoSizeText(
          label,
          textAlign: TextAlign.end,
          maxLines: 1,
          style: style ?? Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
