import 'package:dio/dio.dart';
import 'package:app/domain/models/auth/auth.model.dart';

// Protocols
abstract class UserProviderProtocol {
  Future<Response> authenticate(Auth session);
  Future<Response> get(String id);
}
