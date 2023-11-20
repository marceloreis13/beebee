import 'package:flutter/material.dart';

class ScaffoldClean extends StatelessWidget {
  final Key scaffoldKey;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final bool? left;
  final bool? top;
  final bool? right;
  final bool? bottom;

  const ScaffoldClean({
    super.key,
    required this.scaffoldKey,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.floatingActionButton,
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: bottom!,
        top: top!,
        left: left!,
        right: right!,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: body,
        ),
      ),
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
    );
  }
}
