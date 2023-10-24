import 'package:flutter/material.dart';
import 'package:app/app/constants/env.dart';

extension ExtText on Text {
  static double textScaleFactor(BuildContext context, {double? factor}) {
    final scale = MediaQuery.of(context).textScaleFactor;
    final textScaleFactor = scale > 1 ? (factor ?? Env.textScaleFactor) : scale;
    return textScaleFactor;
  }

  Text copyWithA11y(
    BuildContext context, {
    Key? key,
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    double? textScaleFactor,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    final text = this.data ?? '';
    final scale = MediaQuery.of(context).textScaleFactor;
    final factor = scale > 1 ? (textScaleFactor ?? Env.textScaleFactor) : scale;
    return Text(
      data ?? text,
      key: key ?? this.key,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaleFactor: factor,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }
}
