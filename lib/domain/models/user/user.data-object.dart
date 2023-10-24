import 'package:app/domain/models/user/user.model.dart';

class UserDataObject {
  User self;

  UserDataObject({
    required this.self,
  });
}

extension ExtUser on User {
  UserDataObject get makeDataObject {
    return UserDataObject(
      self: this,
    );
  }
}
