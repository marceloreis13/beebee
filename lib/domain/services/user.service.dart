import 'dart:async';
import 'package:app/app/helpers/api/responses/api.response.helper.dart';
import 'package:app/app/helpers/api/responses/api.response.identity.dart';
import 'package:app/domain/services/service.protocol.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/extensions/dio.extension.dart';
import 'package:app/app/extensions/error.extension.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/models/user/user.model.dart';
import 'package:app/domain/providers/user/user.dependencies.dart';

class UserService extends ServiceProtocol {
  final UserProviderProtocol provider;
  User? user = User();

  UserService({
    required this.provider,
    this.user,
  });

  @override
  get object => user;

  @override
  set object(value) {
    user = value;
  }

  Future<ApiResponse> signin() async {
    try {
      var source = await provider.authenticate(object);
      var apiResponse = ApiResponse().parseFromIdentity(source.data);

      // var identity = UserIdentity.fromJson(apiResponse.object);
      // print(identity);
      // Now I need to make the authentication with the ID extracted from TOKEN which is indide identity

      if (apiResponse.object != null) {
        User.fromJson(apiResponse.object);
      }

      return sessionResponse(source);
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  Future<ApiResponse> sessionResponse(Response source) async {
    try {
      var apiResponse = ApiResponse.fromJsonToObject(source.data);

      if (apiResponse.object != null) {
        Env.setCachedUser(User.fromJson(apiResponse.object));
      }

      return ApiResponse(
        success: apiResponse.success,
        message: apiResponse.message,
        object: Env.user,
      );
    } on Error catch (e) {
      return e.handler;
    }
  }

  Future<ApiResponse> logout() async {
    try {
      // Erasing All Super Entites Data
      Env.setCachedUser(Env.user.clean);

      // Clear all cached information
      var prefs = await SharedPreferences.getInstance();
      prefs.clear();

      return ApiResponse.succeed();
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  void populate(String? fieldName, dynamic value) {
    user ??= User();

    if (value == null) {
      return;
    }

    final user_ = user!;

    switch (fieldName) {
      case 'login':
        user_.name = (value as String).trim();
        break;
      case 'password':
        user_.password = (value as String).trim();
        break;

      default:
        Log.d(fieldName);
        Log.d(value);
    }
  }
}
