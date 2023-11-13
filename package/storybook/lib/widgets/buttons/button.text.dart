part of storybook;

class ButtonText extends StatelessWidget {
  final Function()? onPressed;
  final Icon? icon;
  final Widget child;
  final bool? isDisabled;

  const ButtonText({
    super.key,
    required this.child,
    this.icon,
    this.isDisabled = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return TextButton.icon(
        onPressed: isDisabled == true ? null : onPressed,
        icon: icon!,
        label: child,
      );
    }

    return TextButton(
      onPressed: isDisabled == true ? null : onPressed!,
      child: child,
    );
  }
}
