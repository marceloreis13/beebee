import 'package:dio/dio.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/api.helper.dart';
import 'package:app/app/helpers/debugger.helper.dart';

extension ExtError on Error {
  ApiResponse get handler {
    final error = this;
    if (error is DioException) {
      return error.handler;
    } else {
      Log.e(Remote.appMessageErrorGeneric.string, error: error);
      return ApiResponse.genericError(error);
    }
  }
}
