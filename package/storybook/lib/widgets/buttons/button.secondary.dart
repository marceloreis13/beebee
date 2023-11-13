part of storybook;

class ButtonSecondary extends StatelessWidget {
  final Function()? onPressed;
  final Icon? icon;
  final Widget child;
  final bool? isDisabled;

  const ButtonSecondary({
    super.key,
    required this.child,
    this.icon,
    this.isDisabled = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: isDisabled == true ? null : onPressed,
        icon: icon!,
        label: child,
      );
    }

    return OutlinedButton(
      onPressed: isDisabled == true ? null : onPressed!,
      child: child,
    );
  }
}
