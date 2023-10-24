import 'package:dio/dio.dart';
import 'package:app/app/helpers/api.helper.dart';
import 'package:app/domain/models/vehicle/vehicle.model.dart';
import 'package:app/domain/providers/vehicle/vehicle.dependencies.dart';
import 'package:app/app/helpers/debugger.helper.dart';

class VehicleProvider implements VehicleProviderProtocol {
  @override
  Future<Response> add(Vehicle newVehicle) async {
    try {
      Response response =
          await ApiServices.vehicles.http.post('/', data: newVehicle.toJson());

      return response;
    } catch (err) {
      Log.e('[provider]', error: err);
      rethrow;
    }
  }

  @override
  Future<Response> update(Vehicle newVehicle) async {
    try {
      Response response = await ApiServices.vehicles.http
          .put("/${newVehicle.id}", data: newVehicle.toJson());

      return response;
    } catch (e) {
      Log.e('[provider]', error: e);
      rethrow;
    }
  }

  @override
  Future<Response> get(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Response> getAll() async {
    try {
      Response response = await ApiServices.vehicles.http.get('/');

      return response;
    } catch (e) {
      Log.e('[provider]', error: e);
      rethrow;
    }
  }
}
