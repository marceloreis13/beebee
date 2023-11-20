import 'package:app/app/helpers/api/responses/api.response.helper.dart';
import 'package:dio/dio.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/debugger.helper.dart';

enum ApiError {
  timeout,
  badResponse,
  generic,
}

extension ApiErrorExtension on ApiError {
  get handler {
    String message = '';
    switch (this) {
      case ApiError.timeout:
        message = Remote.appMessageErrorTimeout.string;
        break;
      case ApiError.badResponse:
        message = Remote.appMessageErrorBadResponse.string;
        break;
      default:
        message = Remote.appMessageErrorGeneric.string;
        break;
    }

    return ApiResponse(
      success: false,
      message: message,
    );
  }
}

enum ApiServices {
  domain,
  users,
  vehicles,
  companies,
}

extension ApiServicesExtension on ApiServices {
  Dio get http {
    final baseUrl = "${Remote.appBaseUrl.string}/$endpoint";
    return Api.url(this, baseUrl: baseUrl);
  }

  Dio get httpLegacy {
    final baseUrl = "${Remote.appBaseUrlLegacy.string}/$endpoint";
    return Api.url(this, baseUrl: baseUrl);
  }

  String get endpoint {
    String endpoint = toString().split('.').last;
    return endpoint;
  }

  Map<String, String> get headers {
    final header = {
      'Authorization': Env.user.token ?? '',
    };

    final log =
        "HEADER AUTH:\nendpoint: /$endpoint\nAuthorization: ${Env.user.token}";
    Log.i(log);

    return header;
  }
}

class Api {
  static Dio url(ApiServices key, {required String baseUrl}) {
    BaseOptions options = BaseOptions(
      contentType: 'application/json',
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: Remote.appConnectionTimeout.integer),
      receiveTimeout: Duration(seconds: Remote.appConnectionTimeout.integer),
      headers: key.headers,
    );
    Dio dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          final log =
              "API REQUEST\n${options.method}: ${options.baseUrl}${options.path}\n${options.data.toString()}";
          Log.i(log);

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) {
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
