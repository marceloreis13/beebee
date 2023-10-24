// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app/app/constants/env.dart';
import 'package:app/app/helpers/forms.helper.dart';
import 'package:app/domain/models/user/user.model.dart';
import 'package:app/domain/providers/user/user.dependencies.dart';
import 'package:app/domain/providers/user/user.provider.dart';
import 'package:app/domain/providers/vehicle/vehicle.dependencies.dart';
import 'package:app/domain/providers/vehicle/vehicle.provider.dart';
import 'package:app/domain/services/user.service.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/ui/splash/launchscreen.view.dart';
import 'package:app/ui/themes/theme.app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app/app/routes/route.dart' as route;
import 'package:app/app/helpers/debugger.helper.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Forms()),

        // Providers
        Provider<UserProviderProtocol>(create: (_) => UserProvider()),
        Provider<VehicleProviderProtocol>(create: (_) => VehicleProvider()),
      ],
      child: RootViewStage(
        serviceUser: UserService(provider: UserProvider()),
      ),
    );
  }
}

class RootViewStage extends StatefulWidget {
  final UserService serviceUser;
  const RootViewStage({
    super.key,
    required this.serviceUser,
  });

  @override
  State<RootViewStage> createState() => _RootViewStageState();
}

class _RootViewStageState extends State<RootViewStage>
    with WidgetsBindingObserver {
  late StreamSubscription<FGBGType> subscription;

  @override
  void initState() {
    subscription = FGBGEvents.stream.listen((event) {
      Log.i(event.toString());
      switch (event) {
        case FGBGType.foreground:
          // Access Register
          Env.registerAccess;

          // Request for iOS notification permission
          requestiOSPermission();

          // Setup the user
          setUpUserSession();

          // Changin status bar color according theme mode
          // changeStatusColor();
          break;
        default:
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final palette = ThemeApp(context: context);
    final app = MaterialApp(
      title: Remote.appNameDisplay.string,
      debugShowCheckedModeBanner: false,
      home: LaunchScreen(setUpInitialConfigurations: setUpConfiguration),
      theme: palette.lightTheme(),
      darkTheme: palette.darkTheme(),
      themeMode: ThemeMode.system,
      onGenerateRoute: route.controller,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('pt', 'BR'),
        // Locale('en', 'US'),
      ],
    );

    return app;
  }

  Future<bool> setUpConfiguration() async {
    try {
      // Instantiate the Crashlytics
      await setUpFirebaseCrashlytics();

      // Starting the firebase remote config
      await setUpFirebaseRemoteConfig();

      // Setup the firebase notification
      final fcmToken = await setUpFirebaseMessaging();

      // Setup the user
      await setUpUserSession(fcmToken: fcmToken);

      return await Env.isLoggedIn();
    } catch (e) {
      Log.e('[root.view]', error: e);
      return await Env.isLoggedIn();
    }
  }

  Future setUpFirebaseCrashlytics() async {
    try {
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(kReleaseMode);
      Log.i('Firebase Crashlytics Configured!');
    } catch (e) {
      Log.e(e.toString(), error: e);
      return null;
    }
  }

  Future setUpFirebaseRemoteConfig() async {
    try {
      final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
      remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      await remoteConfig.setDefaults(Env.remoteconfigDefaults);
      await remoteConfig.fetchAndActivate();
      Env.remote = remoteConfig;

      Log.i('Firebase Remote Config Configured!');
    } catch (e) {
      Log.e(e.toString(), error: e);
      return null;
    }
  }

  Future<String?> setUpFirebaseMessaging() async {
    // Handle PUSHES
    // https://medium.com/firebase-tips-tricks/how-to-use-firebase-cloud-messaging-in-flutter-a15ca69ff292

    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      Log.i('Firebase Messaging Configured!');
      return fcmToken;
    } catch (e) {
      Log.e(e.toString(), error: e);
      return null;
    }
  }

  Future requestiOSPermission() async {
    Env.isLoggedIn().then((isLoggedIn) {
      if (!isLoggedIn) {
        Env.accessCount.then((count) {
          if (count >= Remote.appPushiOSPermissionAccessCount.integer) {
            if (Platform.isIOS) {
              Future.delayed(const Duration(seconds: 2), () {
                // Request user access to be notificated
                FirebaseMessaging.instance.requestPermission(
                  alert: true,
                  announcement: false,
                  badge: true,
                  carPlay: false,
                  criticalAlert: false,
                  provisional: false,
                  sound: true,
                );
              });
            }
          }
        });
      }
    });
  }

  Future<void> setUpUserSession({String? fcmToken}) async {
    try {
      final response = await widget.serviceUser.setUpUserSession(
        fcmToken: fcmToken,
      );

      // Authenticate that user
      if (response.success) {
        User user = response.object!;

        Log.i(
          'User Session Configured!\nUserID: ${user.id}\nUDID: ${user.udid}\nFCM: ${user.fcmToken}',
        );
      } else {
        Log.e('User Session Failured!', error: response.message);
      }
    } catch (e) {
      Log.e('[root.view]', error: e);
    }
  }
}
