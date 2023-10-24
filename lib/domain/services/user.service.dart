import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/extensions/dio.extension.dart';
import 'package:app/app/extensions/error.extension.dart';
import 'package:app/app/helpers/api.helper.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/models/user/user.model.dart';
import 'package:app/domain/providers/user/user.dependencies.dart';
import 'package:app/domain/services/service.protocol.dart';

class UserService extends ServiceProtocol {
  final UserProviderProtocol provider;
  User? user = User();

  UserService({
    required this.provider,
    this.user,
  });

  // CRUD functions

  @override
  Future<ApiResponse<User>> get(String id) {
    throw UnimplementedError();
  }

  Future<ApiResponse> signup(User newUser) async {
    try {
      var source = await provider.signup(newUser);
      return sessionResponse(source);
    } on Error catch (e) {
      return e.handler;
    }
  }

  Future<ApiResponse> signin(User user) async {
    try {
      var source = await provider.signin(user);
      return sessionResponse(source);
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  Future<ApiResponse> recovery(User user) async {
    try {
      var source = await provider.recovery(user);
      return sessionResponse(source);
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  Future<ApiResponse> updatePassword(User user) async {
    try {
      var source = await provider.updatePassword(user);
      return sessionResponse(source);
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  Future<ApiResponse> refreshToken(User newUser) async {
    try {
      var source = await provider.refreshToken(newUser);
      var apiResponse = ApiResponse.fromJsonToObject(source.data);

      if (apiResponse.success && apiResponse.object != null) {
        Env.setCachedUser(User.fromJson(apiResponse.object));
      }

      return ApiResponse(
        success: apiResponse.success,
        message: apiResponse.message,
        object: Env.user,
      );
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  @override
  Future<ApiResponse> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<dynamic>> add(dynamic model) async {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> delete(dynamic item) async {
    try {
      await provider.delete(item);

      return await logout();
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  @override
  Future<ApiResponse> archive(item) async {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> unarchive(item) async {
    throw UnimplementedError();
  }

  Future<ApiResponse> update(dynamic model) async {
    try {
      final source = await provider.update(model);
      final apiResponse = ApiResponse.fromJsonToObject(source.data);

      // Update user session
      User newUser = User.fromJson(apiResponse.object);
      Env.setCachedUser(newUser);

      return ApiResponse(
        success: apiResponse.success,
        message: apiResponse.message,
        object: newUser,
      );
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  @override
  get object => user;

  @override
  set object(value) {
    user = value;
  }

  // Buisiness Functions

  Future<ApiResponse> sessionResponse(Response source) async {
    try {
      var apiResponse = ApiResponse.fromJsonToObject(source.data);

      if (apiResponse.success && apiResponse.object != null) {
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

  Future<ApiResponse> setUpUserSession({String? fcmToken}) async {
    try {
      // Get the UDID from device
      final udid = await Env.deviceUDID;

      // Get app version
      final mapAppVersion = await Env.fetchAppVersion();
      final appVersion = "${mapAppVersion.first} | ${mapAppVersion.last}";

      // Get device model
      final deviceModel = await Env.fetchDeviceModel();

      // Get app platform
      final appPlatform = await Env.fetchAppPlatform;

      //Load user from cached memory
      Env.user = await Env.getCachedUser() ?? Env.user;

      // Load device's locale
      final locale = Platform.localeName;

      // Get user from database
      User newUser = User(
        udid: udid,
        fcmToken: fcmToken,
        appVersion: appVersion,
        appPlatform: appPlatform,
        deviceModel: deviceModel,
        locale: locale,
        password: 'UDID-$udid',
      );
      ApiResponse response = await refreshToken(newUser);

      return response;
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  Future<ApiResponse> logout() async {
    try {
      // Erasing All Super Entites Data
      Env.setCachedUser(Env.user.clean);

      // Clear all cached information
      var prefs = await SharedPreferences.getInstance();
      prefs.clear();

      return setUpUserSession();
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
      case 'name':
        user_.name = (value as String).trim();
        break;
      case 'surname':
        user_.surname = (value as String).trim();
        break;
      case 'email':
        user_.emails = [(value as String).trim()];
      case 'password':
        user_.password = (value as String).trim();
        break;
      case 'pinCode':
        user_.pinCode = (value as String).trim();
        break;
      case 'fcmToken':
        user_.fcmToken = value ?? '';
        break;

      default:
        Log.d(fieldName);
        Log.d(value);
    }
  }
}
