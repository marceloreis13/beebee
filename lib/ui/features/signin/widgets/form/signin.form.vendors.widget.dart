import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app/app/constants/env.dart';

class SigninFormVendorsWidget extends StatelessWidget {
  final Function()? btnCredentialsLoginDidTapped;
  final Function()? btnGoogleLoginDidTapped;
  final Function()? btnAppleLoginDidTapped;

  const SigninFormVendorsWidget({
    super.key,
    required this.btnCredentialsLoginDidTapped,
    required this.btnGoogleLoginDidTapped,
    required this.btnAppleLoginDidTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        const SizedBox(
          width: 400,
          child: Divider(),
        ),
        const SizedBox(
          height: 32,
        ),
        SizedBox(
          width: 300,
          child: loginButtons(context),
        ),
        const SizedBox(
          height: 64,
        ),
      ],
    );
  }

  Widget loginButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: const Text('Logar com E-mail e Senha'),
          onPressed: () {
            //
          },
        ),
        const SizedBox(height: 16),
        Visibility(
          visible: Platform.isIOS && Remote.appLoginApple.boolean,
          child: ElevatedButton(
            child: const Text('Logar com a Apple'),
            onPressed: () {
              //
            },
          ),
        ),
      ],
    );
  }
}
