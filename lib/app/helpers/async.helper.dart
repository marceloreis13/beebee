import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/app/helpers/forms.helper.dart';

class AsyncVoid {
  static Timer? timer;
  static void run(
    Function() completion, {
    int milliseconds = 150,
    BuildContext? context,
  }) {
    if (context != null) {
      context.read<Forms>().setAsBusy();
    }
    timer?.cancel();
    timer = Timer(Duration(milliseconds: milliseconds), () {
      completion();
      if (context != null) {
        context.read<Forms>().setAsAvailable();
      }
    });
  }
}
