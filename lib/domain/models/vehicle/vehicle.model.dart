import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/models/model.dart';
import 'package:app/domain/models/user/user.model.dart';

class Vehicle extends Model {
  String? id;
  String name;
  User? user;
  Status status;

  Vehicle({
    this.id,
    this.name = '',
    this.user,
    this.status = Status.activated,
  });

  factory Vehicle.fromJson(JSON? json) {
    try {
      if (json == null) {
        return Vehicle();
      }

      String? id = json['_id'];
      String name = json['name'] ?? '';
      Status status = Model.parseStatus(json['status']) ?? Status.pending;

      User? user;
      Model.populate(json['user'], (item) {
        user = User.fromJson(item);
      });

      return Vehicle(
        id: id,
        name: name,
        user: user,
        status: status,
      );
    } catch (e) {
      Log.e('[Vehicle] - Error on encode JSON', error: e);
      return Vehicle();
    }
  }

  JSON toJson() {
    final JSON data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['user'] = user?.toJson();
    data['status'] = enumToString(status);

    return data;
  }

  Vehicle copyWith({
    String? id,
    String? name,
    User? user,
    Status? status,
  }) =>
      Vehicle(
        id: id ?? this.id,
        name: name ?? this.name,
        user: user ?? this.user,
        status: status ?? this.status,
      );
}
