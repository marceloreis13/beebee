import 'package:app/domain/models/user/user.model.dart';
import 'package:app/ui/widgets/forms/form.field.widget.dart';
import 'package:app/ui/widgets/forms/form.section.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SigninFormWidget extends StatefulWidget {
  final User? user;
  final Function(String, dynamic) onChange;
  const SigninFormWidget({
    super.key,
    required this.user,
    required this.onChange,
  });

  @override
  State<SigninFormWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends State<SigninFormWidget> {
  int segmentedControlGroupValue = 0;

  void setUp() {
    //
  }

  @override
  Widget build(BuildContext context) {
    setUp();
    return BBFormSectionWidget(
      children: [
        name,
        password,
      ],
    );
  }

  Widget get name {
    var controller = MaskedTextController(mask: '000.000.000-00');
    return FormFieldWidget(
      name: 'login',
      label: 'CPF',
      controller: controller,
      helperText: 'Informe o seu CPF',
      initialValue: widget.user?.name,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      onChange: widget.onChange,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
            errorText: 'Este campo deve ser preenchido')
      ]),
    );
  }

  Widget get password {
    return FormFieldWidget(
      name: 'password',
      label: 'Senha',
      helperText: 'Informe sua senha.',
      isPassword: true,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.send,
      onChange: widget.onChange,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(
            errorText: 'Este campo deve ser preenchido'),
        FormBuilderValidators.match(r'^(?=.*?[a-zA-Z])(?=.*?[0-9]).{6,}$',
            errorText:
                "Pelo menos uma letra\nPelo menos um dígito\nDeve ter no mínimo 6 digitos"),
      ]),
    );
  }
}
