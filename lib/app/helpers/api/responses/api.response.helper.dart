import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/api/api.helper.dart';
import 'package:app/domain/models/error/error.model.dart';

class ApiResponse<T> {
  bool? success;
  String? message;
  T? object;
  List<Map<String, dynamic>>? jsonMap = [];

  ApiResponse({
    this.success,
    this.message,
    this.object,
    this.jsonMap,
  });

  ApiResponse.fromJsonToMap(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    object = json['object'];
    if (json['data'].isNotEmpty) {
      jsonMap = List<Map<String, dynamic>>.from(json['data']);
    }
  }

  ApiResponse.fromJsonToObject(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    object = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['data'] = object;
    data['jsonMap'] = object;
    return data;
  }

  factory ApiResponse.genericError(dynamic error) {
    final err = ErrorModel.fromError(error);
    ApiServices.domain.http.post('/logger', data: err.toJson());

    return ApiResponse(
      success: false,
      message: Remote.appMessageErrorGeneric.string,
    );
  }

  factory ApiResponse.succeed() {
    return ApiResponse(
      success: true,
      message: Remote.appMessageSuccessGeneric.string,
    );
  }

  factory ApiResponse.failed() {
    return ApiResponse(
      success: false,
      message: Remote.appMessageErrorGeneric.string,
    );
  }

  ApiResponse<T> copyWith({
    bool? success,
    String? message,
    T? object,
    List<Map<String, dynamic>>? jsonMap,
  }) =>
      ApiResponse<T>(
        success: success ?? this.success,
        message: message ?? this.message,
        object: object ?? this.object,
        jsonMap: jsonMap ?? this.jsonMap,
      );
}
