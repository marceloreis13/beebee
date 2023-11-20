part of storybook;

class ButtonSecondary extends StatelessWidget {
  final Function()? onPressed;
  final Icon? icon;
  final String label;
  final TextStyle? textStyle;
  final bool isDisabled;

  const ButtonSecondary({
    super.key,
    required this.label,
    this.icon,
    this.isDisabled = false,
    this.onPressed,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: isDisabled ? null : onPressed,
        icon: icon!,
        label: _buildLabel(),
      );
    }

    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      child: _buildLabel(),
    );
  }

  Widget _buildLabel() {
    return Text(
      label,
      style: textStyle,
    );
  }
}
