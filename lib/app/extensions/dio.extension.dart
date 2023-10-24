import 'package:dio/dio.dart';
import 'package:app/app/helpers/api.helper.dart';

extension ExtDio on DioException {
  ApiResponse get handler {
    if (response?.data != null) {
      final apiResponse = ApiResponse.fromJsonToObject(response!.data);
      return apiResponse;
    }

    switch (type) {
      case DioExceptionType.connectionTimeout:
        return ApiError.timeout.handler;
      case DioExceptionType.badResponse:
        return ApiError.badResponse.handler;
      default:
        return ApiError.generic.handler;
    }
  }
}
