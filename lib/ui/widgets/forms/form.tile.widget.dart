import 'package:flutter/material.dart';

class FormTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;
  final bool initiallyExpanded;

  const FormTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return tile(context);
  }

  Widget tile(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      backgroundColor: backgroundColor ??
          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
      collapsedBackgroundColor: collapsedBackgroundColor,
      leading: Icon(icon),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.normal,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
      ),
      tilePadding: const EdgeInsets.all(14),
      childrenPadding: EdgeInsets.zero,
      onExpansionChanged: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      children: [
        ...children,
        const SizedBox(
          height: 32,
        )
      ],
    );
  }
}
