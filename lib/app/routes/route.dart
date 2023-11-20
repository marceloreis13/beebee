import 'package:flutter/material.dart';

// Available pages
import 'package:app/ui/features/signin/signin.form.view.dart';
import 'package:app/ui/features/vehicle/vehicle.list.view.dart';

// variable for our route names
enum Routes {
  goTo,

  vehicleListView,
  vehicleFormView,

  signupFormView,
  signinFormCredentialsView,
  signinFormRecoveryView,
  signinFormValidationView,
  signinFormNewPassView,
}

extension RoutesExtension on Routes {
  void rootLoggedIn(BuildContext context, {Function()? completion}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleListView.init(),
      ),
    );

    if (completion != null) {
      Future.delayed(const Duration(milliseconds: 200)).then(
        (_) => completion(),
      );
    }
  }

  void rootLoggedOut(BuildContext context, {Function()? completion}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SigninFormView.init(),
      ),
    ).then((value) {
      if (completion != null) {
        completion();
      }
    });
  }

  String get value {
    String key = toString().split('.').last;
    if (key.isEmpty || key == 'null') {
      return '';
    }

    return key.toLowerCase();
  }
}

Routes parseRoute(dynamic name) {
  if (name != null) {
    final entity = (name as String).toUpperCase();
    final isValid = Routes.values
        .where((e) => e.toString().split('.').last.toUpperCase() == entity)
        .isNotEmpty;
    if (isValid) {
      return Routes.values.firstWhere(
          (e) => e.toString().split('.').last.toUpperCase() == entity);
    }
  }

  return Routes.signupFormView;
}

// controller function with switch statement to control page route flow
Route<dynamic> controller(RouteSettings settings) {
  Routes route = parseRoute(settings.name);
  // final arguments = (settings.arguments ?? <String, dynamic>{}) as Map;

  switch (route) {
    // Vehicle
    case Routes.vehicleListView:
      return MaterialPageRoute(builder: (context) => VehicleListView.init());

    default:
      throw ('this route name does not exist');
  }
}
