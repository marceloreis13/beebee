import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/models/vehicle/vehicle.model.dart';
import 'package:app/domain/models/model.dart';

class User extends Model {
  String? id;
  List<Vehicle>? vehicles;
  String? password;
  String? pinCode;
  String? name;
  String? surname;
  List<String>? emails, phones;
  String? udid;
  String? token;
  String? fcmToken;
  String? appVersion;
  String? appPlatform;
  String? deviceModel;
  bool subscribed;
  String? locale;
  Status status;

  User({
    this.id,
    this.vehicles,
    this.password,
    this.pinCode,
    this.name,
    this.surname,
    this.emails,
    this.phones,
    this.udid,
    this.token,
    this.fcmToken,
    this.appVersion,
    this.appPlatform,
    this.deviceModel,
    this.subscribed = true,
    this.locale,
    this.status = Status.activated,
  });

  @override
  String toString() {
    return '$name $surname';
  }

  factory User.fromForm(User? user) {
    try {
      if (user == null) {
        return User();
      }

      String? udid = Env.user.udid;

      return user.copyWith(
        id: Env.user.id,
        name: user.name,
        surname: user.surname,
        emails: user.emails,
        password: user.password,
        udid: udid,
        vehicles: Env.user.vehicles,
      );
    } catch (e) {
      Log.e('[User] - Error on encode JSON', error: e);
      return User();
    }
  }

  factory User.fromApple(AuthorizationCredentialAppleID? credential) {
    try {
      if (credential == null) {
        return User();
      }

      String? password = 'default-password-here';
      String? udid = Env.user.udid;

      String? name;
      String? surname;
      if (credential.givenName != null || credential.familyName != null) {
        String? givenName = credential.givenName ?? '';
        String? familyName = credential.familyName ?? '';
        name = givenName;
        surname = familyName;
      }

      List<String>? emails;
      if (credential.email != null) {
        emails = [credential.email!];
      }
      // emails = ['me@marcelo.cc'];
      // name = 'Marcelo';
      // surname = 'Reis';

      return User(
        id: Env.user.id,
        udid: udid,
        password: password,
        name: name,
        surname: surname,
        emails: emails,
      );
    } catch (e) {
      Log.e('[User] - Error on encode JSON', error: e);
      return User();
    }
  }

  factory User.fromJson(JSON? json) {
    try {
      if (json == null) {
        return User();
      }

      String? id = json['_id'];
      String? password = json['password'];
      String? pinCode = json['pin_code'];
      String? name = json['name'];
      String? surname = json['surname'];
      String? udid = json['udid'];
      String? token = json['token'];
      String? fcmToken = json['fcm_token'];
      String? appVersion = json['app_version'];
      String? appPlatform = json['app_platform'];
      String? deviceModel = json['device_model'];
      bool subscribed = json['subscribed'] ?? true;
      String? locale = json['locale'];
      Status status = Model.parseStatus(json['status']) ?? Status.pending;

      List<String> emails = [];
      if (json['emails'] != null) {
        emails = [];
        json['emails'].forEach((v) {
          emails.add(v);
        });
      }

      List<String> phones = [];
      if (json['phones'] != null) {
        phones = [];
        json['phones'].forEach((v) {
          phones.add(v);
        });
      }

      List<Vehicle> vehicles = [];
      Model.populate(json['vehicle'], (item) {
        vehicles.add(Vehicle.fromJson(item));
      });

      return User(
        id: id,
        vehicles: vehicles,
        password: password,
        pinCode: pinCode,
        name: name,
        surname: surname,
        emails: emails,
        phones: phones,
        udid: udid,
        token: token,
        fcmToken: fcmToken,
        appVersion: appVersion,
        appPlatform: appPlatform,
        deviceModel: deviceModel,
        subscribed: subscribed,
        locale: locale,
        status: status,
      );
    } catch (e) {
      Log.e('[User] - Error on encode JSON', error: e);
      return User();
    }
  }

  JSON toJson({bool relationship = true}) {
    final JSON data = <String, dynamic>{};
    data['_id'] = id;

    data['password'] = password;
    data['pin_code'] = pinCode;
    data['name'] = name;
    data['surname'] = surname;
    data['emails'] = emails;
    data['phones'] = phones;
    data['udid'] = udid;
    data['token'] = token;
    data['fcm_token'] = fcmToken;
    data['app_version'] = appVersion;
    data['app_platform'] = appPlatform;
    data['device_model'] = deviceModel;
    data['subscribed'] = subscribed;
    data['locale'] = locale;
    data['status'] = enumToString(status);

    if (relationship) {
      if (vehicles != null) {
        data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
      }
    }

    return data;
  }

  User copyWith({
    String? id,
    List<Vehicle>? vehicles,
    String? password,
    String? pinCode,
    String? name,
    String? surname,
    List<String>? emails,
    List<String>? phones,
    String? udid,
    String? token,
    String? fcmToken,
    String? appVersion,
    String? appPlatform,
    String? deviceModel,
    bool? subscribed,
    String? locale,
    Status? status,
  }) =>
      User(
        id: id ?? this.id,
        vehicles: vehicles ?? this.vehicles,
        password: password ?? this.password,
        pinCode: pinCode ?? this.pinCode,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        emails: emails ?? this.emails,
        phones: phones ?? this.phones,
        udid: udid ?? this.udid,
        token: token ?? this.token,
        fcmToken: fcmToken ?? this.fcmToken,
        appVersion: appVersion ?? this.appVersion,
        appPlatform: appPlatform ?? this.appPlatform,
        deviceModel: deviceModel ?? this.deviceModel,
        subscribed: subscribed ?? this.subscribed,
        locale: locale ?? this.locale,
        status: status ?? this.status,
      );

  User updateWith({
    JSON? vehicle,
  }) {
    if (vehicle != null) {
      Vehicle newVehicle = Vehicle.fromJson(vehicle);
      vehicles?.removeWhere((e) => e.id == newVehicle.id);
      vehicles?.add(newVehicle);
    }

    return this;
  }

  User get clean {
    return copyWith(
      vehicles: [],
    );
  }
}
