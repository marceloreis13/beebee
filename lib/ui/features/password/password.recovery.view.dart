import 'package:app/ui/widgets/app/scaffold.clean.widget.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storybook/storybook.dart';

class PasswordRecoveryView extends StatefulWidget {
  const PasswordRecoveryView({super.key});

  @override
  State<PasswordRecoveryView> createState() => _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends State<PasswordRecoveryView> {
  Steps step = Steps.cpf;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return ScaffoldClean(
      scaffoldKey: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      ...handleStep(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // TODO: Create separeted Views for each step
  List<Widget> handleStep() {
    switch (step) {
      case Steps.cpf:
        return _cpfStep();
      case Steps.code:
        return _codeStep();
      case Steps.password:
        return _passwordStep();
    }
  }

  List<Widget> _cpfStep() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ColumnSpacer(
          spacing: 32,
          children: [
            const LogoImage(),
            Text(
              'Para começar\ninforme o CPF',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: CardForm(
          // title: 'Para começar\ninforme o CPF',
          cardPadding: 16,
          children: <Widget>[
            TextFormField(
              // onChanged: (value) => onFormChange('cpf', value),
              keyboardType: TextInputType.number,
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
            ButtonPrimary(
              onPressed: () {
                setState(() {
                  step = Steps.code;
                });
              },
              label: "Começar",
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> _codeStep() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ColumnSpacer(
          spacing: 32,
          children: [
            const LogoImage(),
            Text(
              'Um código de confirmação foi enviado para o número\n\n(**) * **** 4444',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: CardForm(
          cardPadding: 16,
          children: <Widget>[
            TextFormField(
              // onChanged: (value) => onFormChange('cpf', value),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: 'Código',
                hintText: '0000',
                border: OutlineInputBorder(),
              ),
            ),
            ButtonPrimary(
              onPressed: () {
                setState(() {
                  step = Steps.password;
                });
              },
              label: "Confirmar",
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> _passwordStep() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ColumnSpacer(
          spacing: 32,
          children: [
            const LogoImage(),
            Text(
              'Agora, informe a\nsua nova senha',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: CardForm(
          cardPadding: 16,
          children: <Widget>[
            TextFormField(
              // onChanged: (value) => onFormChange('cpf', value),
              decoration: const InputDecoration(
                labelText: 'Nova senha',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              // onChanged: (value) => onFormChange('cpf', value),
              decoration: const InputDecoration(
                labelText: 'Confirmar senha',
                border: OutlineInputBorder(),
              ),
            ),
            ButtonPrimary(
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: "Confirmar",
            ),
          ],
        ),
      )
    ];
  }
}

enum Steps {
  cpf,
  code,
  password,
}
