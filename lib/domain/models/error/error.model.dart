import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/models/model.dart';

class ErrorModel extends Model {
  String? message;
  String? stack;
  bool success;

  ErrorModel({
    this.message = '',
    this.stack,
    this.success = false,
  });

  factory ErrorModel.fromError(dynamic error) {
    try {
      if (error == null) {
        return ErrorModel();
      }

      String? message = error.toString();
      String? stack = StackTrace.current.toString();
      bool success = false;

      return ErrorModel(
        message: message,
        stack: stack,
        success: success,
      );
    } catch (e) {
      Log.e('[ErrorModel] - Error on encode Error', error: e);
      return ErrorModel();
    }
  }

  JSON toJson() {
    final JSON data = <String, dynamic>{};
    data['message'] = message;
    data['stack'] = stack;
    data['success'] = success;
    data['origin'] = 'flutter';
    data['level'] = 'error';

    return data;
  }

  ErrorModel copyWith({
    String? message,
    String? stack,
    bool? success,
  }) =>
      ErrorModel(
        message: message ?? this.message,
        stack: stack ?? this.stack,
        success: success ?? this.success,
      );
}
