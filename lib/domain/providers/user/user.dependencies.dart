import 'package:dio/dio.dart';
import 'package:app/domain/models/auth/auth.model.dart';
import 'package:app/domain/models/user/user.model.dart';

// Protocols
abstract class UserProviderProtocol {
  Future<Response> authenticate(Auth session);
  Future<Response> refreshToken(User newUser);
  Future<Response> signup(User newUser);
  Future<Response> signin(User newUser);
  Future<Response> recovery(User newUser);
  Future<Response> updatePassword(User newUser);
  Future<Response> get(String id);
  Future<Response> add(User newUser);
  Future<Response> update(User newUser);
  Future<Response> delete(User user);
  Future<Response> archive(User user);
  Future<Response> unarchive(User user);
}
