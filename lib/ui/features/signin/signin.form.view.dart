import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/notify.helper.dart';
import 'package:app/app/routes/route.dart';
import 'package:app/domain/providers/user/user.dependencies.dart';
import 'package:app/domain/services/signup.service.dart';
import 'package:app/ui/features/signin/widgets/form/signin.form.vendors.widget.dart';
import 'package:app/ui/widgets/app/scaffold.clean.widget.dart';

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
        scaffoldKey: _scaffoldKey,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 100.0,
                    right: 32,
                    bottom: 8,
                    left: 32,
                  ),
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        Text(
                          Remote.appNameDisplay.string,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const Divider(),
                        Text(
                          Remote.appMessagePromotional.string,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                buildForm(context),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return !Navigator.of(context).userGestureInProgress;
      },
    );
  }

  Widget buildForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14.0),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: onboardingOnPressed,
              child: const Text("Entrar!"),
            ),
          ),
          SigninFormVendorsWidget(
            btnCredentialsLoginDidTapped: btnCredentialsLoginDidTapped,
            btnGoogleLoginDidTapped: btnGoogleLoginDidTapped,
            btnAppleLoginDidTapped: btnAppleLoginDidTapped,
          ),
        ],
      ),
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
