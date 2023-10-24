import 'package:intl/intl.dart';

extension ExtDouble on double {
  // String get toCurrency => NumberFormat("#,##0.00", "pt_br").format(this);
  String get toCurrency => NumberFormat("#,##0.00").format(this);
}

extension ExtInt on int {
  String get toCurrency => toDouble().toCurrency;

  static int forceParse(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    return 0;
  }
}
