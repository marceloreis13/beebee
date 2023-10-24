import 'package:dio/dio.dart';
import 'package:app/domain/models/vehicle/vehicle.model.dart';

// Protocols
abstract class VehicleProviderProtocol {
  Future<Response> get(String id);
  Future<Response> getAll();
  Future<Response> add(Vehicle newVehicle);
  Future<Response> update(Vehicle newVehicle);
}
