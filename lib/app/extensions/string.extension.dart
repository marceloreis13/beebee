import 'package:url_launcher/url_launcher.dart';

extension ExtString on String {
  String shortener({int limit = 50, textComplete = '...'}) {
    if (isEmpty) {
      return '';
    }

    limit = length < limit ? length : limit;
    String newList = substring(0, limit);
    newList += length > limit ? textComplete : '';

    return newList;
  }

  String get firstLastName {
    String name = this; //.nameCleanup;

    if (name.isEmpty) {
      return '';
    }

    if (!name.contains(' ')) {
      return name.ucWords;
    }

    final names = name.split(' ');
    if (names.length > 1) {
      return '${names.first} ${names.last}'.ucWords;
    } else {
      return name.ucWords;
    }
  }

  String get firstName {
    String name = this; //.nameCleanup;

    if (!name.contains(' ')) {
      return name.ucWords;
    }

    final names = name.split(' ');
    return names.first.ucWords;
  }

  String get firstLastNameShort {
    String name = this; //.nameCleanup;

    if (!name.contains(' ')) {
      return name.ucWords;
    }

    final names = name.split(' ');
    return '${names.first} ${names.last[0].toUpperCase()}.'.ucWords;
  }

  String get removeDiacritics {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    String text = this;
    for (int i = 0; i < withDia.length; i++) {
      text = text.replaceAll(withDia[i], withoutDia[i]);
    }

    return text;
  }

  String get ucFirst =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get ucWords => trim().split(' ').map((str) => str.ucFirst).join(' ');
  String get keepNumbers => replaceAll(RegExp(r'[^0-9]'), '');
  String get keepCharacters => replaceAll(RegExp(r'[0-9]'), '');

  bool compareWith(String other) {
    final otherClean = other.toLowerCase().removeDiacritics;
    final isEqual = toLowerCase().removeDiacritics.contains(otherClean);

    return isEqual;
  }

  Future get launch async {
    Uri uri = Uri.parse(this);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      throw 'Could not launch $this';
    }
  }
}
