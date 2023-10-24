import 'package:dio/dio.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/extensions/dio.extension.dart';
import 'package:app/app/extensions/error.extension.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/app/helpers/api.helper.dart';
import 'package:app/domain/models/user/user.model.dart' as user_model;
import 'package:app/domain/providers/user/user.dependencies.dart';
import 'package:app/domain/services/service.protocol.dart';
import 'package:app/domain/services/user.service.dart';

class SignupService extends ServiceProtocol {
  user_model.User? user;
  final UserProviderProtocol providerUser;
  UserService get userService => UserService(provider: providerUser);

  SignupService({
    this.user,
    required this.providerUser,
  });

  @override
  Future<ApiResponse<dynamic>> add(dynamic model) async {
    try {
      return signup('form');
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  @override
  Future<ApiResponse> archive(item) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> delete(item) => userService.delete(item);

  @override
  Future<ApiResponse> get(String id) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> unarchive(item) {
    throw UnimplementedError();
  }

  @override
  get object => user;

  @override
  set object(value) {
    user = value;
  }

  // Business

  Future<ApiResponse> signup(String vendor) async {
    try {
      switch (vendor) {
        case 'form':
          final newUser = user_model.User.fromForm(user);
          ApiResponse response = await userService.signup(newUser);
          if (response.success && response.object != null) {
            Env.setCachedUser(response.object!);
          }

          return response;
        case 'apple':
          final credential = await SignInWithApple.getAppleIDCredential(
            scopes: AppleIDAuthorizationScopes.values,
          );

          final user = user_model.User.fromApple(credential);
          return await userService.signup(user);
        default:
          return ApiResponse(success: false);
      }
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  void populate(String? fieldName, dynamic value) {
    user ??= user_model.User();

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
      case 'password':
        user_.password = (value as String).trim();
        break;
      case 'emails':
        user_.emails = [(value as String).trim()];
        break;

      default:
        Log.d(fieldName);
        Log.d(value);
    }
  }
}
