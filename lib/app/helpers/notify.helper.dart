import 'package:app/app/constants/constant.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/app/helpers/api.helper.dart';
import 'package:flutter/material.dart';

class NotifyAction {
  final String buttonTitle;
  final Function function;
  Color? textColor;
  Color? backgroundColor;
  NotifyAction({
    required this.buttonTitle,
    required this.function,
    this.textColor,
    this.backgroundColor,
  });
}

enum Notify {
  failure,
  success,
  delete,
  archive,
  unarchive,
  snack,
  prompt,
  response,
  widget,
}

extension NotifyExtension on Notify {
  static bool isDialogShowing = false;

  String get title {
    switch (this) {
      case Notify.failure:
        return 'Oops!';
      case Notify.success:
        return 'Tudo Certo!';
      case Notify.delete:
        return 'Remover';
      case Notify.archive:
        return 'Arquivar';
      case Notify.unarchive:
        return 'Reativar';
      case Notify.prompt:
        return 'Informe abaixo';
      case Notify.widget:
        return 'widget';
      default:
        return 'Atenção';
    }
  }

  String get message {
    switch (this) {
      case Notify.failure:
        return Remote.appMessageErrorGeneric.string;
      case Notify.success:
        return Remote.appMessageSuccessGeneric.string;
      case Notify.delete:
        return Remote.appMessageHardRemoveConfirm.string;
      case Notify.archive:
        return Remote.appMessageConfirm.string;
      case Notify.prompt:
        return 'Escreva';
      default:
        return '...';
    }
  }

  IconData get icon {
    switch (this) {
      case Notify.failure:
        return Icons.cancel;
      case Notify.success:
        return Icons.check_circle;
      case Notify.delete:
        return Icons.delete;
      case Notify.archive:
        return Icons.archive_rounded;
      case Notify.unarchive:
        return Icons.unarchive_rounded;
      case Notify.prompt:
        return Icons.keyboard;
      case Notify.widget:
        return Icons.image;
      default:
        return Icons.cancel;
    }
  }

  Future<void> show(
    BuildContext context, {
    List<NotifyAction>? actions,
    String? title,
    String? message,
    IconData? icon,
    Function(String)? onChange,
    ApiResponse? apiResponse,
    Widget? widget,
  }) async {
    if (this != Notify.snack) {
      if (NotifyExtension.isDialogShowing) {
        Navigator.of(context).pop();
      }
      NotifyExtension.isDialogShowing = true;
    }

    NotifyAction actionDefault = NotifyAction(
      buttonTitle: 'Fechar',
      textColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      function: () {
        Navigator.of(context).pop();
      },
    );

    List<NotifyAction> actions_ = actions ?? [actionDefault];
    Notify notify = this;

    if (this == Notify.response && apiResponse == null) {
      Log.d('[Notify] - ApiResponse must be provided');
      return;
    }

    var message_ = message ?? notify.message;
    if (this == Notify.response && apiResponse != null) {
      notify = apiResponse.success ? Notify.success : Notify.failure;
      message_ = apiResponse.message ?? message_;
    }

    var icon_ = icon ?? notify.icon;
    var title_ = title ?? notify.title;

    if (notify == Notify.snack) {
      _snackBar(message_, context);
    } else {
      Widget content;
      switch (notify) {
        case Notify.widget:
          content = _contentImage(widget, message_);
          break;
        case Notify.prompt:
          content = _contentPrompt(message_, onChange);
          break;
        default:
          content = _contentMessage(message_, context);
          break;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  5.0,
                ),
              ),
            ),
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    icon_,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                Expanded(
                  child: Text(
                    title_,
                    // maxLines: 2,
                    // minFontSize: 8,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            content: content,
            actions: actions_
                .map(
                  (action) => ElevatedButton(
                    onPressed: () {
                      action.function();
                      NotifyExtension.isDialogShowing = false;
                    },
                    child: Text(action.buttonTitle),
                  ),
                )
                .toList(),
          );
        },
      );
    }
  }

  Future<void> ask(
    BuildContext context, {
    String? title,
    String? message,
    Function? yes,
    Function? no,
    String yesButtonTitle = 'Sim',
    String noButtonTitle = 'Não',
  }) async {
    final actions = [
      NotifyAction(
          buttonTitle: noButtonTitle,
          textColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          function: no != null
              ? () {
                  no();
                  Navigator.of(context).pop();
                }
              : () {
                  Navigator.of(context).pop();
                }),
      NotifyAction(
          buttonTitle: yesButtonTitle,
          // textColor: Theme.of(context).colorScheme.onBackground,
          backgroundColor: Theme.of(context).colorScheme.error,
          function: yes != null
              ? () {
                  yes();
                  Navigator.of(context).pop();
                }
              : () {
                  Navigator.of(context).pop();
                }),
    ];

    show(context, title: title, message: message, actions: actions);
  }

  void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _snackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey.shade800,
        content: Text(
          value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
              ),
        ),
        duration: Duration(seconds: Remote.appSnackTimeExpire.integer),
      ),
    );
  }

  Widget _contentMessage(String? message, BuildContext context) {
    String supportMsg =
        'Não se preocupe, estamos cientes e cuidando disso! 😊🛠️';

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          message != null && message.isNotEmpty ? message : this.message,
          textAlign: TextAlign.start,
        ),
        (![Notify.failure].contains(this))
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  supportMsg,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontWeight: FontWeight.normal),
                ),
              ),
      ],
    );
  }

  Widget _contentPrompt(String message, Function(String)? onChange) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            autofocus: true,
            inputFormatters: [Constant.currencyFormatter],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: message,
              hintText: 'Insira um texto',
            ),
            onChanged: onChange!,
          ),
        )
      ],
    );
  }

  Widget _contentImage(Widget? widget, String? message) {
    if (widget == null) {
      return const SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          message ?? this.message,
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: widget,
          ),
        ),
      ],
    );
  }
}
