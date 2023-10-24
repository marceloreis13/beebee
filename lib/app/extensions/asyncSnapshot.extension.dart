import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/app/helpers/notify.helper.dart';

extension ExtAsyncSnapshot on AsyncSnapshot {
  void requestErrorHandler(BuildContext context) {
    if (hasError) {
      Log.e(error.toString());
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Displaying an error from system
      if (data == null) {
        Notify.snack.show(
          context,
          message: Remote.appMessageErrorGeneric.string,
        );
      }

      // Displaying an error from server
      final response = data!;
      if (!response.success) {
        Notify.response.show(
          context,
          apiResponse: response,
        );
      }
    });
  }
}
