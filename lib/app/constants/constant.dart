import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:app/app/constants/env.dart';

class Constant {
  static RateMyApp rateMyApp(int minDays, int minLaunches) => RateMyApp(
        preferencesPrefix: Env.preferencesPrefix,
        minDays: minDays,
        minLaunches: minLaunches,
        googlePlayIdentifier: Env.googlePlayIdentifier,
        appStoreIdentifier: Env.appStoreIdentifier,
      );

  static RateMyApp get rateMyOnEventRequest => Constant.rateMyApp(3, 2);
  static RateMyApp get rateMyOnEventB => Constant.rateMyApp(2, 2);
  static RateMyApp get rateMyOnEventC => Constant.rateMyApp(4, 3);

  static CurrencyTextInputFormatter get currencyFormatter =>
      CurrencyTextInputFormatter(
        locale: 'Marcelo Reis',
        name: 'R\$',
        decimalDigits: 2,
      );
}
