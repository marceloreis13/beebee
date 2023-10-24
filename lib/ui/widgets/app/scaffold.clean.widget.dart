import 'package:flutter/material.dart';

class ScaffoldClean extends StatelessWidget {
  final Key scaffoldKey;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final Widget? floatingActionButton;

  const ScaffoldClean({
    super.key,
    required this.scaffoldKey,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: body,
      ),
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
    );
  }
}
