import 'package:app/app/helpers/debugger.helper.dart';
import 'package:app/domain/models/model.dart';

class IdentityToken {
  bool authenticated;
  DateTime? created;
  DateTime? expiration;
  String? accessToken;
  String? message;

  IdentityToken({
    this.authenticated = false,
    this.created,
    this.expiration,
    this.accessToken,
    this.message,
  });

  factory IdentityToken.fromJson(JSON? json) {
    try {
      if (json == null) {
        return IdentityToken();
      }

      bool authenticated = json['authenticated'] ?? false;
      DateTime? created = Model.parseDate(json['created']);
      DateTime? expiration = Model.parseDate(json['expiration']);
      String? accessToken = json['accessToken'];
      String? message = json['message'];

      return IdentityToken(
        authenticated: authenticated,
        created: created,
        expiration: expiration,
        accessToken: accessToken,
        message: message,
      );
    } catch (e) {
      Log.e('[UserIdentity] - Error on encode JSON', error: e);
      return IdentityToken();
    }
  }
}

class UserIdentity extends Model {
  String? id;
  IdentityToken? token;
  String? name;
  bool firstLogin;
  bool useTerm;
  bool authenticated;
  bool legacyUserToUpdatePassword;
  String? message;

  UserIdentity({
    this.id,
    this.token,
    this.name,
    this.firstLogin = false,
    this.useTerm = false,
    this.authenticated = false,
    this.legacyUserToUpdatePassword = false,
    this.message,
  });

  @override
  String toString() {
    return '$name';
  }

  factory UserIdentity.fromJson(JSON? json) {
    try {
      if (json == null) {
        return UserIdentity();
      }

      String? id = json['id'];
      String? name = json['name'];
      bool firstLogin = json['firstLogin'] ?? false;
      bool useTerm = json['useTerm'] ?? false;
      bool authenticated = json['authenticated'] ?? false;
      bool legacyUserToUpdatePassword =
          json['legacyUserToUpdatePassword'] ?? false;
      String? message = json['message'];

      IdentityToken token = IdentityToken();
      Model.populate(json['token'], (item) {
        token = IdentityToken.fromJson(item);
      });

      return UserIdentity(
        id: id,
        name: name,
        firstLogin: firstLogin,
        useTerm: useTerm,
        authenticated: authenticated,
        legacyUserToUpdatePassword: legacyUserToUpdatePassword,
        message: message,
        token: token,
      );
    } catch (e) {
      Log.e('[UserIdentity] - Error on encode JSON', error: e);
      return UserIdentity();
    }
  }
}
