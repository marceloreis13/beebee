part of storybook;

class CardMini extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final double? height;

  const CardMini({
    super.key,
    required this.text,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _cardMini(context);
  }

  Widget _cardMini(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          alignment: Alignment.bottomLeft,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
