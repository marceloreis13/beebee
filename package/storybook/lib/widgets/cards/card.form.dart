part of storybook;

const smallPadding = 16.0;
const mediumPadding = 32.0;
const smallSpacing = 10.0;
const double widthConstraint = 450;

class CardForm extends StatefulWidget {
  const CardForm({
    super.key,
    required this.child,
    required this.title,
    this.buttonPrimary,
    this.isOutside = false,
  });

  final String title;
  final Widget child;
  final bool? isOutside;
  final ButtonPrimary? buttonPrimary;

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: smallSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.isOutside!,
              child: title(context),
            ),
            ConstrainedBox(
              constraints:
                  const BoxConstraints.tightFor(width: widthConstraint),
              // Tapping within the a component card should request focus for that component's children.
              child: Focus(
                focusNode: focusNode,
                canRequestFocus: true,
                child: GestureDetector(
                  onTapDown: (_) {
                    focusNode.requestFocus();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Card(
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(mediumPadding,
                            smallPadding, mediumPadding, mediumPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: !widget.isOutside!,
                              child: title(context),
                            ),
                            widget.child,
                            if (widget.buttonPrimary != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: mediumPadding),
                                child: widget.buttonPrimary,
                              ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget title(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: smallPadding),
      child: Text(
        widget.title,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.left,
      ),
    );
  }
}
