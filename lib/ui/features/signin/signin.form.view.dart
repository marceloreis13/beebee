import 'package:app/ui/themes/theme.app.dart';
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
    return WillPopScope(
      child: ScaffoldClean(
        bottom: false,
        scaffoldKey: _scaffoldKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Hero(
                    tag: 'splash-logo',
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ThemeApp.isDark(context)
                                ? const AssetImage('assets/img/bee-white.png')
                                : const AssetImage('assets/img/bee-dark.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: null,
                      ),
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
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Informe o\nseu acesso',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Hero(tag: 'splash-card', child: signForm(context)),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      onTap: () {
                        showModalBottomSheet<void>(
                          showDragHandle: true,
                          context: context,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          elevation: 1,
                          builder: buildBottomSheet,
                        );
                      },
                      child: Container(
                        height: 48,
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                            ),
                            width: 32,
                            height: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
            // buildForm(context),
          ],
        ),
      ),
      onWillPop: () async {
        return !Navigator.of(context).userGestureInProgress;
      },
    );
  }

  Widget buildBottomSheet(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(breakTextIfNeeded('Precisa de ajuda?'),
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Row(
            children: [
              Expanded(
                child: card(context, 'Central de ajuda', 200),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: card(context, 'Falar pelo whatsapp', 200),
              ),
            ],
          ),
          const SizedBox(height: 8),
          card(context, 'Conversar pelo chat', 100)
        ],
      ),
    );
  }

  Widget card(context, String text, double height) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          alignment: Alignment.bottomLeft,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(breakTextIfNeeded(text),
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      ),
    );
  }

  String breakTextIfNeeded(String text) {
    // Define a threshold for the length of the text
    const int threshold = 20;

    // Check if the length of the text is below the threshold
    if (text.length <= threshold) {
      // Insert a line break at the middle of the text
      int middleIndex = text.length ~/ 2;
      text =
          '${text.substring(0, middleIndex)}\n${text.substring(middleIndex)}';
    }

    return text;
  }

  Widget signForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
