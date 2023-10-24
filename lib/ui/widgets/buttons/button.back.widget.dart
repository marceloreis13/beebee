import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/app/helpers/forms.helper.dart';

enum HeaderDismissButton {
  back,
  dismiss,
  none,
}

extension HeaderDismissButtonExtension on HeaderDismissButton {
  IconData get icon {
    switch (this) {
      case HeaderDismissButton.back:
        return Icons.arrow_back_ios_new_rounded;
      case HeaderDismissButton.dismiss:
        return Icons.close_rounded;
      default:
        return Icons.arrow_back_ios;
    }
  }
}

class ButtonBack extends StatelessWidget {
  final Function? backButtonAction;
  final HeaderDismissButton dismissButton;

  const ButtonBack({
    super.key,
    this.backButtonAction,
    required this.dismissButton,
  });

  @override
  Widget build(BuildContext context) {
    Forms forms = Provider.of<Forms>(context);
    bool isBusy = forms.isBusy();
    final color = Theme.of(context).colorScheme.primaryContainer;
    return Visibility(
      visible: dismissButton != HeaderDismissButton.none,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: color.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(32.0),
          ),
          onTap: isBusy
              ? null
              : () {
                  if (backButtonAction != null) {
                    backButtonAction!();
                  } else {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.of(context).pop();
                  }
                },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              dismissButton.icon,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
