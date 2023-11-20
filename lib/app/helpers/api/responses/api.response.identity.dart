import 'package:app/app/helpers/api/responses/api.response.helper.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/models/model.dart';

extension ExtApiResponse on ApiResponse {
  // Parse from Identity
  ApiResponse parseFromIdentity(JSON? json) {
    try {
      if (json == null) {
        return ApiResponse.failed();
      }

      success = json['hasSuccess'];
      message = json['hasError'];
      object = json['object'];

      if (json['value'].isNotEmpty) {
        jsonMap = List<Map<String, dynamic>>.from(json['value']);
      }

      return ApiResponse(
        success: success,
        message: message,
        jsonMap: jsonMap,
        object: object,
      );
    } catch (e) {
      Log.e('[User] - Error on encode JSON', error: e);
      return ApiResponse.failed();
    }
  }
}
