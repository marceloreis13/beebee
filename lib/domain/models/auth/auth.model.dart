class Auth {
  String? id;
  String? email;
  String? password;
  String? oldPassword;
  String? pinCode;

  Auth({
    this.id,
    this.email,
    this.password,
    this.pinCode,
    this.oldPassword,
  });

  Auth.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    pinCode = json['pin_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['old_password'] = oldPassword;
    data['timezone_offset'] = DateTime.now().timeZoneOffset.inMinutes;
    data['pin_code'] = pinCode;

    return data;
  }
}
