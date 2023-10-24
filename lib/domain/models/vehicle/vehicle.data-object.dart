import 'package:app/domain/models/vehicle/vehicle.model.dart';
import 'package:app/domain/models/model.dart';

class VehicleDataObject {
  Vehicle self;
  bool isArchived;
  Status status;

  VehicleDataObject({
    required this.self,
    required this.isArchived,
    required this.status,
  });
}

extension ExtVehicle on Vehicle {
  VehicleDataObject get makeDataObject {
    return VehicleDataObject(
      self: this,
      isArchived: isArchived,
      status: status,
    );
  }

  bool get isArchived => status != Status.activated;
}
