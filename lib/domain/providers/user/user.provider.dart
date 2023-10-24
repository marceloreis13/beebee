import 'package:dio/dio.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/app/helpers/api.helper.dart';
import 'package:app/domain/models/auth/auth.model.dart';
import 'package:app/domain/models/user/user.model.dart';
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
  Future<Response> signup(User user) async {
    try {
      Response response =
          await ApiServices.domain.http.post('/signup', data: user.toJson());

      return response;
    } catch (err) {
      Log.d('[provider] - $err');
      rethrow;
    }
  }

  @override
  Future<Response> signin(User user) async {
    try {
      Response response = await ApiServices.domain.http
          .post('/authenticate', data: user.toJson());

      return response;
    } catch (err) {
      Log.d('[provider] - $err');
      rethrow;
    }
  }

  @override
  Future<Response> recovery(User user) async {
    try {
      Response response =
          await ApiServices.domain.http.post('/recovery', data: user.toJson());

      return response;
    } catch (err) {
      Log.d('[provider] - $err');
      rethrow;
    }
  }

  @override
  Future<Response> updatePassword(User user) async {
    try {
      Response response = await ApiServices.domain.http
          .put('/updatePassword', data: user.toJson());

      return response;
    } catch (err) {
      Log.d('[provider] - $err');
      rethrow;
    }
  }

  @override
  Future<Response> refreshToken(User user) async {
    try {
      Response response = await ApiServices.domain.http
          .post('/refreshToken', data: user.toJson());

      return response;
    } catch (err) {
      Log.d('[provider] - $err');
      rethrow;
    }
  }

  @override
  Future<Response> add(User newUser) async {
    try {
      Response response =
          await ApiServices.users.http.post('/', data: newUser.toJson());

      return response;
    } catch (err) {
      Log.d('[provider] - $err');
      rethrow;
    }
  }

  @override
  Future<Response> update(User newUser) async {
    try {
      Response response = await ApiServices.users.http
          .put("/${newUser.id}", data: newUser.toJson());

      return response;
    } catch (err) {
      Log.d('[provider] - $err');
      rethrow;
    }
  }

  @override
  Future<Response> archive(User user) {
    throw UnimplementedError();
  }

  @override
  Future<Response> delete(User user) async {
    try {
      Response response = await ApiServices.domain.http
          .delete('/removeMyAccount', data: user.toJson());

      return response;
    } catch (err) {
      Log.d('[provider] - $err');
      rethrow;
    }
  }

  @override
  Future<Response<User>> get(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Response> unarchive(User user) {
    throw UnimplementedError();
  }
}
