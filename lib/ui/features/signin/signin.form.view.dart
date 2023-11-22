import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/notify.helper.dart';
import 'package:app/app/routes/route.dart';
import 'package:app/domain/providers/user/user.dependencies.dart';
import 'package:app/domain/services/signup.service.dart';
import 'package:app/ui/features/signin/widgets/form/signin.form.vendors.widget.dart';
import 'package:app/ui/widgets/app/scaffold.clean.widget.dart';
import 'package:storybook/storybook.dart';

import 'widgets/signin.bottom.sheet.dart';

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
      bottom: false,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Hero(
                                tag: 'splash-logo',
                                child: LogoImage(),
                              ),
                              const Spacer(),
                              ButtonText(
                                label: 'Quero cadastrar',
                                onPressed: () {},
                              )
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Informe o\nseu acesso',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Hero(
                            tag: 'splash-card',
                            child: signForm(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SigninBottomSheet(),
        ],
      ),
    );
  }

  Widget signForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 64),
      child: CardForm(
        children: [
          TextFormField(
            onChanged: (value) => onFormChange('cpf', value),
            keyboardType: TextInputType.number,
            // add a OK button to the keyboard, it should focus the next field
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
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
                    Routes.passwordRecovery.value,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future onboardingOnPressed() async {
    Routes.goTo.rootLoggedIn(context);
  }

  void onFormChange(String? fieldName, dynamic value) {
    service.populate(fieldName, value);
  }

  // TODO: remove all this code below
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
}
