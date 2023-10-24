import 'package:app/app/helpers/debugger.helper.dart';
import 'package:flutter/material.dart';

typedef JSON = Map<String, dynamic>;

enum Status {
  activated,
  pending,
  blocked,
  archived,
  deleted,
}

class Model extends ChangeNotifier {
  static Status? parseStatus(dynamic json) {
    if (json != null) {
      final status = (json as String).toUpperCase();
      final isValid = Status.values
          .where((e) => e.toString().split('.').last.toUpperCase() == status)
          .isNotEmpty;
      if (isValid) {
        return Status.values.firstWhere(
            (e) => e.toString().split('.').last.toUpperCase() == status);
      }
    }

    return null;
  }

  static DateTime? parseDate(json) {
    DateTime? date;
    if (json != null && json != 'null') {
      if (json is String) {
        date = DateTime.tryParse(json) ?? date;
      }
    }

    return date;
  }

  String enumToString(Enum? item) {
    return item.toString().split('.').last.toUpperCase();
  }

  static void populate(dynamic json, Function completion) {
    try {
      if (json != null && json != '') {
        if (json is List) {
          for (var v in json) {
            if (v is String) {
              completion({'_id': v});
            } else {
              completion(v);
            }
          }
        } else if (json is Map) {
          if (json.isNotEmpty) {
            completion(json);
          }
        }
      }
    } catch (err) {
      Log.d('[model] - ${err.toString()} - $json');
      rethrow;
    }
  }
}
