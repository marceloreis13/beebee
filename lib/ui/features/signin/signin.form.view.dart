import 'package:app/domain/providers/user/user.dependencies.dart';
import 'package:app/domain/services/user.service.dart';
import 'package:app/ui/features/signin/widgets/form/signin.form.widget.dart';
import 'package:app/ui/widgets/forms/form.scaffold.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

class SigninFormView extends StatefulWidget {
  const SigninFormView._();
  static Widget init() => ChangeNotifierProvider(
        lazy: false,
        create: (context) => UserService(
          provider: context.read<UserProviderProtocol>(),
        ),
        child: const SigninFormView._(),
      );

  @override
  State<SigninFormView> createState() => _SigninFormViewState();
}

class _SigninFormViewState extends State<SigninFormView> {
  late UserService service;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    setUp();

    super.initState();
  }

  void setUp() {
    service = context.read<UserService>();
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'Bee Bee',
      form: <Widget>[
        FormBuilder(
          key: fbKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              form,
              actions,
            ],
          ),
        )
      ],
      scaffoldKey: scaffoldKey,
    );
  }

  Widget get form {
    return SigninFormWidget(
      user: service.user,
      onChange: onFormChange,
    );
  }

  Widget get actions {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 30),
      child: ElevatedButton(
        child: const Text('Entrar'),
        onPressed: () {
          // final response = service.signin();
        },
      ),
    );
  }

  void onFormChange(String? fieldName, dynamic value) {
    service.populate(fieldName, value);
  }
}
