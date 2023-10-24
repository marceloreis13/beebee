import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum FormatType {
  time,
  short,
  tiny,
  medium,
  long,
  weekShort,
  month,
  year,
  authTime,
}

extension ExtDateTime on DateTime {
  int get getHashCode => day * 1000000 + month * 10000 + year;
  bool get isToday => isSameDay(DateTime.now());
  DateTime get removeTime => DateTime(year, month, day, 0, 0, 0, 0, 0);
  bool get isSunday => weekday == DateTime.sunday;
  bool get isWeekday => weekday >= 1 && weekday <= 5;
  bool get isWeekend => !isWeekday;
  bool get isNightTime => hour > 18 || hour < 6;
  bool get isDayTime => !isNightTime;

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool isSameDayOrAfter(DateTime other) => isSameDay(other) || isAfter(other);
  bool isSameDayOrBefore(DateTime other) => isSameDay(other) || isBefore(other);

  String custom(String? format) {
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(this);
    final label = formatted;

    return label;
  }

  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  DateTime combine(DateTime? date) =>
      DateTime(year, month, day, date?.hour ?? 0, date?.minute ?? 0);

  String formatted({FormatType? type, String? format, bool withTime = false}) {
    String label = '';
    String time = '';
    String? systemLocale = Platform.localeName;

    switch (type) {
      case FormatType.time:
        label = DateFormat.Hm(systemLocale).format(this); // 24H
        return label;
      case FormatType.tiny:
        label = DateFormat.MEd(systemLocale).format(this);
        break;
      case FormatType.short:
        label = DateFormat.yMd(systemLocale).format(this);
        break;
      case FormatType.medium:
        label = DateFormat.yMMMd(systemLocale).format(this);
        break;
      case FormatType.weekShort:
        label = DateFormat.E(systemLocale).format(this);
        break;
      case FormatType.month:
        label = DateFormat.MMMM(systemLocale).format(this);
        break;
      case FormatType.year:
        label = DateFormat.y(systemLocale).format(this);
        break;
      case FormatType.long:
        label = DateFormat.yMMMMd(systemLocale).format(this);
        break;
      case FormatType.authTime:
        String year_ = year.toString();
        String month_ = month.toString().padLeft(2, '0');
        String day_ = day.toString().padLeft(2, '0');
        String hour_ = DateFormat('hh').format(this);
        String minutes_ = DateFormat('mm').format(this);

        label = '$year_$month_$day_$hour_$minutes_';
        break;
      default:
        label = custom(format);
        break;
    }

    if (withTime) {
      time = 'às ${DateFormat.Hm().format(this)}';
    }

    return '$label $time'.trim();
  }
}
