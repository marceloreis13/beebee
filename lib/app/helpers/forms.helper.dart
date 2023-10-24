import 'package:flutter/material.dart';

class Forms extends ChangeNotifier {
  bool? busy;

  bool isBusy() {
    return busy ?? false;
  }

  void setAsBusy({observable = true}) {
    setAs(true, observable: observable);
  }

  void setAsAvailable({observable = true}) {
    setAs(false, observable: observable);
  }

  void keepAvailableAsDefault() {
    setAs(false, observable: false);
  }

  void setAs(bool state, {bool observable = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      busy = state;

      if (observable) {
        notifyListeners();
      }
    });
  }
}
