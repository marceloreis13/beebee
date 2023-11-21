import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/notify.helper.dart';
import 'package:app/app/routes/route.dart';
import 'package:app/domain/providers/user/user.dependencies.dart';
import 'package:app/domain/services/signup.service.dart';
import 'package:app/ui/features/signin/widgets/form/signin.form.vendors.widget.dart';
import 'package:app/ui/widgets/app/scaffold.clean.widget.dart';
import 'package:storybook/storybook.dart';

import 'widgets/bottom.sheet.widget.dart';

class SigninFormView extends StatefulWidget {
  const SigninFormView._();
  static Widget init() => ChangeNotifierProvider(
        lazy: false,
        create: (context) => SignupService(
          providerUser: context.read<UserProviderProtocol>(),
        ),
        child: const SigninFormView._(),
      );

  @override
  State<SigninFormView> createState() => _SigninFormViewState();
}

class _SigninFormViewState extends State<SigninFormView>
    with SingleTickerProviderStateMixin {
  late SignupService service;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    setUp();

    super.initState();
  }

  void setUp() {
    service = context.read<SignupService>();
    // UserBusiness.googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldClean(
      scaffoldKey: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Hero(
                    tag: 'splash-logo',
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: LogoImage(),
                    ),
                  ),
                  const Spacer(),
                  ButtonText(
                    label: 'Quero cadastrar',
                    onPressed: () {},
                  )
                ],
              ),
            ),
            const Expanded(child: SizedBox.expand()),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Informe o\nseu acesso',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Hero(
              tag: 'splash-card',
              child: signForm(context),
            ),

            // buildForm(context),
          ],
        ),
      ),
    );

    // return WillPopScope(
    //   child: Stack(
    //     children: [
    //       ScaffoldClean(
    //         scaffoldKey: _scaffoldKey,
    //         body: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(16),
    //               child: Row(
    //                 children: [
    //                   const Hero(
    //                     tag: 'splash-logo',
    //                     child: SizedBox(
    //                       width: 36,
    //                       height: 36,
    //                       child: LogoImage(),
    //                     ),
    //                   ),
    //                   const Spacer(),
    //                   ButtonText(
    //                     label: 'Quero cadastrar',
    //                     onPressed: () {},
    //                   )
    //                 ],
    //               ),
    //             ),
    //             const Expanded(child: SizedBox()),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 16),
    //               child: Text(
    //                 'Informe o\nseu acesso',
    //                 style: Theme.of(context).textTheme.headlineMedium,
    //               ),
    //             ),
    //             Hero(tag: 'splash-card', child: signForm(context)),

    //             // buildForm(context),
    //           ],
    //         ),
    //       ),
    //       const SigninBottomSheet()
    //     ],
    //   ),
    //   onWillPop: () async {
    //     return !Navigator.of(context).userGestureInProgress;
    //   },
    // );
  }

  Widget buildBottomSheet(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text('Precisa de ajuda?',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          const Row(
            children: [
              Expanded(
                child: CardMini(text: 'Central de ajuda', height: 200),
              ),
              SizedBox(width: 8),
              Expanded(
                child: CardMini(text: 'Falar pelo whatsapp', height: 200),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const CardMini(text: 'Conversar pelo chat', height: 100)
        ],
      ),
    );
  }

  Widget signForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 48),
      child: CardForm(
        cardPadding: 16,
        wrapPadding: const EdgeInsets.only(bottom: 16),
        child: <Widget>[
          TextFormField(
            onChanged: (value) => onFormChange('cpf', value),
            decoration: const InputDecoration(
              labelText: 'CPF',
              hintText: '000.000.000-00',
              border: OutlineInputBorder(),
            ),
          ),
          TextFormField(
            onChanged: (value) => onFormChange('cpf', value),
            decoration: const InputDecoration(
              labelText: 'Senha',
              hintText: '*********',
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonPrimary(
                onPressed: onboardingOnPressed,
                label: "Entrar",
              ),
              const SizedBox(width: 16),
              ButtonText(
                label: 'Esqueci minha senha',
                textStyle: Theme.of(context).textTheme.bodySmall,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.storyBookView.value,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 24,
        ),
        ButtonPrimary(
          onPressed: onboardingOnPressed,
          label: "Entrar!",
        ),
        SizedBox(
          width: 300,
          child: ButtonSecondary(
            onPressed: () async {
              Navigator.pushNamed(
                context,
                Routes.storyBookView.value,
              );
            },
            label: "StoryBook!",
          ),
        ),
        SizedBox(
          width: 300,
          child: ButtonText(
            onPressed: () async {
              Navigator.pushNamed(
                context,
                Routes.materialExample.value,
              );
            },
            label: "Material Example!",
          ),
        ),
        SigninFormVendorsWidget(
          btnCredentialsLoginDidTapped: btnCredentialsLoginDidTapped,
          btnGoogleLoginDidTapped: btnGoogleLoginDidTapped,
          btnAppleLoginDidTapped: btnAppleLoginDidTapped,
        ),
      ],
    );
  }

  Future onboardingOnPressed() async {
    Routes.goTo.rootLoggedIn(context);
  }

  Future btnCredentialsLoginDidTapped() async {
    Navigator.pushNamed(
      context,
      Routes.signinFormCredentialsView.value,
    );
  }

  Future btnGoogleLoginDidTapped() async {
    await btnSocialLoginDidTapped('google');
  }

  Future btnAppleLoginDidTapped() async {
    await btnSocialLoginDidTapped('apple');
  }

  Future btnSocialLoginDidTapped(String option) async {
    // final response = await service.signup(option);
    if (mounted) {
      Notify.snack.hide(context);

      Env.isLoggedIn(logged: true);
      Routes.goTo.rootLoggedIn(context);
    }
  }

  void onFormChange(String? fieldName, dynamic value) {
    service.populate(fieldName, value);
  }
}
