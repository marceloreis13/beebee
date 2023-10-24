import 'package:dio/dio.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/models/error/error.model.dart';

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
    return Api.url(this);
  }

  String get absoluteUrl {
    String endpoint = toString().split('.').last;
    return "${Env.baseUrl}/$endpoint";
  }

  Map<String, String> get headers {
    String endpoint = toString().split('.').last;

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
  static Dio url(ApiServices key) {
    BaseOptions options = BaseOptions(
      contentType: 'application/json',
      baseUrl: key.absoluteUrl,
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

class ApiResponse<T> {
  bool success = false;
  String? message;
  T? object;
  List<Map<String, dynamic>>? jsonMap = [];

  ApiResponse({
    required this.success,
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
