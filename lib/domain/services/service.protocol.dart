import 'package:flutter/foundation.dart';
import 'package:app/app/helpers/api.helper.dart';

abstract class ServiceProtocol extends ChangeNotifier {
  dynamic get object;
  set object(dynamic value);
  Future<ApiResponse> get(String id);
  Future<ApiResponse> getAll();
  Future<ApiResponse> add(dynamic model);
  Future<ApiResponse> delete(dynamic item);
  Future<ApiResponse> archive(dynamic item);
  Future<ApiResponse> unarchive(dynamic item);
}
