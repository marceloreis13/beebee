part of storybook;

class ButtonPrimary extends StatelessWidget {
  final Function()? onPressed;
  final Icon? icon;
  final Widget child;
  final bool? isDisabled;

  const ButtonPrimary({
    super.key,
    required this.child,
    this.icon,
    this.isDisabled = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return FilledButton.icon(
        onPressed: isDisabled == true ? null : onPressed,
        icon: icon!,
        label: child,
      );
    }

    return FilledButton(
      onPressed: isDisabled == true ? null : onPressed!,
      child: child,
    );
  }
}
