import 'package:flutter/material.dart';
import 'package:app/ui/widgets/buttons/button.back.widget.dart';
import 'package:app/ui/widgets/headers/header.control.widget.dart';
import 'package:app/ui/widgets/app/scaffold.clean.widget.dart';

// ignore: must_be_immutable
class FormScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final List<Widget> form;
  final HeaderDismissButton dismissButton;
  final Widget? floatingActionButton;
  ScrollController? scrollController = ScrollController();
  final bool isModal;

  FormScaffold({
    super.key,
    required this.title,
    required this.form,
    required this.scaffoldKey,
    this.dismissButton = HeaderDismissButton.none,
    this.floatingActionButton,
    this.scrollController,
    this.isModal = false,
  });
  @override
  Widget build(BuildContext context) {
    return ScaffoldClean(
      scaffoldKey: scaffoldKey,
      body: Column(
        children: <Widget>[
          HeaderControls(
            title: title,
            isModal: isModal,
            leftActions: [
              ButtonBack(
                dismissButton: dismissButton,
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 2,
                right: 16.0,
                bottom: 16.0,
                left: 16.0,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: form,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
