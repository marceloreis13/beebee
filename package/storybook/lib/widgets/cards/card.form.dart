part of storybook;

const _spacing = 16.0;
const _cardPadding = 16.0;

class CardForm extends StatefulWidget {
  final double cardPadding;
  final double spacing;
  final List<Widget> children;
  final double? elevation;
  final String? title;

  const CardForm({
    super.key,
    required this.children,
    this.cardPadding = _cardPadding,
    this.spacing = _spacing,
    this.elevation = 0,
    this.title,
  });

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      canRequestFocus: true,
      child: GestureDetector(
        onTapDown: (_) {
          focusNode.requestFocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.title != null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ColumnSpacer(
                  spacing: 32,
                  children: [
                    const LogoImage(),
                    Text(
                      widget.title ?? '',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              elevation: widget.elevation,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.all(widget.cardPadding),
                child: ColumnSpacer(
                  spacing: widget.spacing,
                  children: widget.children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColumnSpacer extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const ColumnSpacer({
    super.key,
    required this.children,
    this.spacing = _spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map(
        (entry) {
          final widget = entry.value;
          final isVisibilityWidget = widget is Visibility;
          final isVisible = isVisibilityWidget && widget.visible == true;
          final shouldAddSpace = !isVisibilityWidget || isVisible;

          return Container(
            padding: EdgeInsets.only(
              bottom: entry.key == children.length - 1 || !shouldAddSpace
                  ? 0
                  : spacing,
            ),
            child: widget,
          );
        },
      ).toList(),
    );
  }
}
