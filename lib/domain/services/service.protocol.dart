import 'package:flutter/foundation.dart';

abstract class ServiceProtocol extends ChangeNotifier {
  dynamic get object;
  set object(dynamic value);
}
