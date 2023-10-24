import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:smarttime/domain/models/model.dart';
import 'package:smarttime/domain/models/user/user.model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recase/recase.dart';

class Env {
  static bool get debugMode {
    // return false;

    bool inDebugMode = false;
    assert(inDebugMode = true);

    return inDebugMode;
  }

  static String get baseUrl {
    return Env.debugMode
        ? 'http://192.168.100.225:3000'
        : Remote.appBaseUrl.string;
  }

  static String googlePlayIdentifier = 'br.log.beebee';
  static String appStoreIdentifier = '6463321123';
  static String preferencesPrefix = 'beebee';

  // Super Entities
  static User user = User();
  // static Company company = Company();

  static Future<String> get fetchAppPlatform async {
    final platform = Platform.isIOS ? 'iOS' : 'Android';

    String osVersion = 'not_found';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      osVersion = info.systemVersion;
    } else {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      osVersion = info.version.codename;
    }
    return '$platform | OS: $osVersion';
  }

  static Future<List<String>> fetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return [packageInfo.version, packageInfo.buildNumber];
  }

  static Future<String> fetchDeviceModel() async {
    String model = 'not_found';

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      model = info.model;
    } else {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      model = info.model;
    }

    return model;
  }

  static Future<void> setCachedUser(User user) async {
    Env.user = user;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }

  static Future<User?> getCachedUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson == null) {
      return User();
    }

    final userMap = jsonDecode(userJson);
    return User.fromJson(userMap);
  }

  static Future<bool> isLoggedIn({bool logged = false}) async {
    var prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (logged) {
      await prefs.setBool('isLoggedIn', true);
      isLoggedIn = true;
    }

    return isLoggedIn;
  }

  static Future<int> get registerAccess async {
    var prefs = await SharedPreferences.getInstance();
    int counter = await Env.accessCount;

    counter += 1;
    await prefs.setInt('accessCounter', counter);

    return counter;
  }

  static Future<int> get accessCount async {
    var prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt('accessCounter') ?? 0;

    return counter;
  }

  static Future<String> get deviceUDID async {
    const storage = FlutterSecureStorage();
    String key = '${Env.preferencesPrefix}_udid';
    String? udid = await storage.read(key: key);
    if (udid == null || udid.isEmpty) {
      udid = await FlutterUdid.udid;
      await storage.write(key: key, value: udid);
    }

    return udid;
  }

  static double get textScaleFactor => 1.3;

  // Remote Config
  static FirebaseRemoteConfig remote = FirebaseRemoteConfig.instance;

  static Map<String, dynamic> remoteconfigDefaults = {
    // Application
    Remote.appBaseUrl.constant: 'https://api.scaffold.com.br',
    Remote.appNameDisplay.constant: 'App Scaffold',
    Remote.appDesc.constant:
        'Solução logística para grandes e pequenas empresas',
    Remote.appDomain.constant: 'scaffold.com.br',
    Remote.appContactEmail.constant: 'contato@scaffold.com.br',
    Remote.appSenderEmail.constant: 'contato@scaffold.com.br',
    Remote.appSenderEmailPassword.constant: 'password-here',

    Remote.appSiteUrl.constant: 'https://scaffold.com.br',

    // Messages
    Remote.appMessagePromotional.constant: "Here goes to app description",
    Remote.appMessageSuccessGeneric.constant: 'Tudo certo, aproveite! 😎',
    Remote.appMessageErrorGeneric.constant:
        'Parece que algo inesperado ocorreu. não se preocupe, já estamos trabalhando nisso. 😅',
    Remote.appMessageConfirm.constant: 'Tem certeza?',
    Remote.appMessageErrorTimeout.constant:
        'Parace que você esta sem conexão 📶',
    Remote.appMessageErrorBadResponse.constant:
        'Parece que algo deu errado com a sua solicitação.',
    Remote.appMessageEmpty.constant: 'Nenhum registro encontrado.',
    Remote.appMessageEmptyField.constant: 'Este campo deve ser preenchido.',
    Remote.appMessageLoading.constant: 'Carregando... 🙄',
    Remote.appMessageSaving.constant: 'Salvando... 😇',
    Remote.appMessageSending.constant: 'Enviando... 📤',
    Remote.appMessageRemoving.constant: 'Removendo... 🔴',
    Remote.appMessageActivating.constant: 'Ativando... 🟢',
    Remote.appMessageArchiving.constant: 'Arquivando... 🟡',
    Remote.appMessageHardRemoveConfirm.constant:
        'Esta ação não poderá ser revertida, deseja continuar?',
    Remote.appMessageMissingFormField.constant:
        'Oops, Estão faltando algumas informações 🧐',
    Remote.appMessageInvalidPin.constant:
        "Formato inválido, seu codigo deve conter 4 dígitos.",
    Remote.appMessageWrongPin.constant:
        "Este código não está igual ao que foi enviado para o seu email 🧐",
    Remote.appMessageSendedFeedback.constant:
        'Mensagem enviada com sucesso! 😎',
    Remote.appMessageErrorSendFeedbac.constant:
        'Não foi possível enviar sua mensagem 😩',
    Remote.appMessageSignupFailure.constant: 'Autenticação Falhou 😩',

    // Configurations
    Remote.appConnectionTimeout.constant: 15,
    Remote.appSnackTimeExpire.constant: 5,

    // Flags
    Remote.appLoginApple.constant: true,

    // Default Values
    Remote.appPushiOSPermissionAccessCount.constant: 2,
  };
}

enum Remote {
  // Application
  appBaseUrl,
  appNameDisplay,
  appDesc,
  appDomain,
  appContactEmail,
  appSenderEmail,
  appSenderEmailPassword,

  appSiteUrl,

  // Messages
  appMessagePromotional,
  appMessageSuccessGeneric,
  appMessageErrorGeneric,
  appMessageConfirm,
  appMessageErrorTimeout,
  appMessageErrorBadResponse,
  appMessageEmpty,
  appMessageEmptyField,
  appMessageLoading,
  appMessageSaving,
  appMessageSending,
  appMessageRemoving,
  appMessageActivating,
  appMessageArchiving,
  appMessageHardRemoveConfirm,
  appMessageMissingFormField,
  appMessageInvalidPin,
  appMessageWrongPin,
  appMessageSendedFeedback,
  appMessageErrorSendFeedbac,
  appMessageSignupFailure,

  // Configurations
  appConnectionTimeout,
  appSnackTimeExpire,

  // Flags
  appLoginApple,

  // Values
  appPushiOSPermissionAccessCount,
}

extension RemoteExtension on Remote {
  String get constant {
    String key = toString().split('.').last;
    if (key == 'null') {
      return '';
    }

    return key.constantCase.toLowerCase();
  }

  String get string {
    return getAlternativeValueIfNeeded('string');
  }

  int get integer {
    return getAlternativeValueIfNeeded('int');
  }

  double get float {
    return getAlternativeValueIfNeeded('double');
  }

  bool get boolean {
    return getAlternativeValueIfNeeded('bool');
  }

  JSON get json {
    return getAlternativeValueIfNeeded('json');
  }

  getAlternativeValueIfNeeded(type) {
    switch (type) {
      case 'string':
        return Env.remote.getString(constant);
      case 'int':
        return Env.remote.getInt(constant);
      case 'double':
        return Env.remote.getDouble(constant);
      case 'bool':
        return Env.remote.getBool(constant);
      case 'json':
        final data = Env.remote.getValue(constant);
        final map = data.asString();
        return jsonDecode(map);
    }
  }
}
