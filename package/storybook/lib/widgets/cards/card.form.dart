part of storybook;

const smallPadding = 16.0;
const mediumPadding = 32.0;
const smallSpacing = 10.0;
const double widthConstraint = 1000;

class CardForm extends StatefulWidget {
  final ButtonPrimary? buttonPrimary;
  final EdgeInsets? wrapPadding;
  final String? title;
  final double cardPadding;
  final dynamic child;
  final double? elevation;

  const CardForm({
    super.key,
    required this.child,
    this.buttonPrimary,
    this.cardPadding = mediumPadding,
    this.title,
    this.wrapPadding = const EdgeInsets.only(bottom: 32),
    this.elevation = 0,
  });

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Focus(
        focusNode: focusNode,
        canRequestFocus: true,
        child: GestureDetector(
          onTapDown: (_) {
            focusNode.requestFocus();
          },
          behavior: HitTestBehavior.opaque,
          child: Card(
            elevation: widget.elevation,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.child is Widget)
                    wrapField(widget.child, noPadding: true)
                  else if (widget.child is List<Widget>)
                    ...widget.child
                        .asMap()
                        .entries
                        .map(
                          (entry) => wrapField(
                            entry.value,
                            noPadding: entry.key == widget.child.length - 1,
                          ),
                        )
                        .toList(),
                  Visibility(
                    visible: widget.buttonPrimary != null,
                    child: widget.buttonPrimary ?? const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget wrapField(Widget field, {bool noPadding = false}) {
    final isHidden = field is Visibility && !field.visible;
    EdgeInsets? padding =
        isHidden || noPadding ? EdgeInsets.zero : widget.wrapPadding;

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

class ColumnSpacer extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const ColumnSpacer({
    super.key,
    required this.children,
    this.spacing = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((c) => Container(
                padding: EdgeInsets.only(
                  bottom: c is Visibility && !c.visible ? 0 : spacing,
                ),
                child: c,
              ))
          .toList(),
    );
  }
}
