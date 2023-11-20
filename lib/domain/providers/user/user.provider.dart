import 'package:app/app/helpers/debugger.helper.dart';
import 'package:dio/dio.dart';
import 'package:app/app/helpers/api/api.helper.dart';
import 'package:app/domain/models/auth/auth.model.dart';
import 'package:app/domain/providers/user/user.dependencies.dart';

class UserProvider implements UserProviderProtocol {
  @override
  Future<Response> authenticate(Auth auth) async {
    try {
      Response response = await ApiServices.domain.http
          .post('/authenticate', data: auth.toJson());

      return response;
    } catch (err) {
      rethrow;
    }
  }

  @override
  Future<Response> get(String id) async {
    try {
      Response response = await ApiServices.domain.httpLegacy.get('/');

      return response;
    } catch (e) {
      Log.e('[provider]', error: e);
      rethrow;
    }
  }
}
