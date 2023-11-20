import 'dart:async';

import 'package:app/app/helpers/api/responses/api.response.helper.dart';
import 'package:dio/dio.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/extensions/dio.extension.dart';
import 'package:app/app/extensions/error.extension.dart';
import 'package:app/domain/models/vehicle/vehicle.model.dart';
import 'package:app/domain/models/model.dart';
import 'package:app/domain/providers/vehicle/vehicle.dependencies.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/services/service.protocol.dart';

class VehicleService extends ServiceProtocol {
  final VehicleProviderProtocol provider;
  Vehicle? vehicle = Vehicle();

  VehicleService({
    required this.provider,
    this.vehicle,
  });

  // CRUD functions

  Future<ApiResponse> getAll() async {
    try {
      final source = await provider.getAll();
      final apiResponse = ApiResponse.fromJsonToMap(source.data);
      final items =
          apiResponse.jsonMap?.map((e) => Vehicle.fromJson(e)).toList();

      return ApiResponse(
        success: apiResponse.success,
        message: apiResponse.message,
        object: items,
      );
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  Future<ApiResponse<dynamic>> add(dynamic model) async {
    try {
      vehicle ??= model;
      vehicle!.user = Env.user;

      ApiResponse<dynamic> apiResponse;
      if (vehicle != null && vehicle!.id != null) {
        final source = await provider.update(vehicle!);
        apiResponse = ApiResponse.fromJsonToObject(source.data);
      } else {
        final source = await provider.add(vehicle!);
        apiResponse = ApiResponse.fromJsonToObject(source.data);
      }

      // Update user session
      Env.setCachedUser(Env.user.updateWith(vehicle: apiResponse.object));

      return ApiResponse(
        success: apiResponse.success,
        message: apiResponse.message,
        object: Vehicle.fromJson(apiResponse.object),
      );
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  Future<ApiResponse> update(dynamic model) async {
    try {
      final source = await provider.update(model);
      final apiResponse = ApiResponse.fromJsonToObject(source.data);

      // Update user session
      Env.setCachedUser(Env.user.updateWith(vehicle: apiResponse.object));

      return ApiResponse(
        success: apiResponse.success,
        message: apiResponse.message,
        object: Vehicle.fromJson(apiResponse.object),
      );
    } on Error catch (e) {
      return e.handler;
    } on DioException catch (e) {
      return e.handler;
    } catch (e) {
      return ApiResponse.genericError(e);
    }
  }

  Future<ApiResponse> delete(dynamic item) {
    Vehicle vehicle = item;
    Env.user.vehicles ??= [];
    Env.user.vehicles!.removeWhere((e) => e.id == vehicle.id);

    return update((item as Vehicle).copyWith(status: Status.deleted));
  }

  Future<ApiResponse> archive(dynamic item) =>
      update((item as Vehicle).copyWith(status: Status.archived));

  Future<ApiResponse> unarchive(dynamic item) =>
      update((item as Vehicle).copyWith(status: Status.activated));

  @override
  get object => vehicle;

  @override
  set object(value) {
    vehicle = value;
  }

  List<Vehicle> get getLocalVehicles => Env.user.vehicles ?? [];

  // Buisiness Functions

  void populate(String? fieldName, dynamic value) {
    vehicle ??= Vehicle();

    if (value == null) {
      return;
    }

    final vehicle_ = vehicle!;
    switch (fieldName) {
      case 'name':
        vehicle_.name = (value as String).trim();
        break;

      default:
        Log.d(fieldName);
        Log.d(value);
    }
  }
}
