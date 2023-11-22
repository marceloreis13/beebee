import 'package:flutter/material.dart';

class BottomDraggableSheet extends StatelessWidget {
  final Widget child;

  const BottomDraggableSheet({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBottomSheet;
  }

  Widget get _buildBottomSheet {
    return DraggableScrollableSheet(
      initialChildSize: 0.07,
      minChildSize: 0.07,
      maxChildSize: 0.7,
      snap: true,
      snapSizes: const [0.07, 0.7],
      builder: (BuildContext context, ScrollController scrollController) {
        return Card(
          elevation: 0,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _buildBottomSheetHandle(context),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetHandle(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    if (bottomPadding < 16) bottomPadding = 16;
    // You can customize the handle appearance here if needed
    return Container(
      margin: EdgeInsets.only(
        top: 16,
        bottom: bottomPadding,
      ),
      height: 4,
      width: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
      ),
    );
  }
}
