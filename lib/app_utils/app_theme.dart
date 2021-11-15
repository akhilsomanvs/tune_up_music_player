import 'package:flutter/material.dart';
import 'package:tune_up/arch_utils/utils/size_config.dart';

class AppTheme {
  static _AppTextThemes textTheme = _AppTextThemes();
}

class _AppTextThemes {
  late TextStyle _textStyle;

  ///Commonly used text style in the app.

  late TextStyle subtitle1 = _textStyle.copyWith(fontSize: SizeConfig.getTextSize(10), fontWeight: FontWeight.normal);
  late TextStyle subtitle2 = _textStyle.copyWith(fontSize: SizeConfig.getTextSize(12), fontWeight: FontWeight.normal);
  late TextStyle bodyText1 = _textStyle.copyWith(fontSize: SizeConfig.getTextSize(14), fontWeight: FontWeight.normal);
  late TextStyle bodyText2 = _textStyle.copyWith(fontSize: SizeConfig.getTextSize(16), fontWeight: FontWeight.normal);
  late TextStyle headline1 = _textStyle.copyWith(fontSize: SizeConfig.getTextSize(16), fontWeight: FontWeight.bold);
  late TextStyle headline2 = _textStyle.copyWith(fontSize: SizeConfig.getTextSize(18), fontWeight: FontWeight.bold);
  late TextStyle headline3 = _textStyle.copyWith(fontSize: SizeConfig.getTextSize(24), fontWeight: FontWeight.bold);
  late TextStyle headline4 = _textStyle.copyWith(fontSize: SizeConfig.getTextSize(32), fontWeight: FontWeight.bold);

  // late TextStyle primaryTextStyle = bodyText2;

  final Color _primaryTextColor = Colors.black;

  _AppTextThemes() {
    _textStyle = TextStyle(fontFamily: "RobotoCondensed",color: _primaryTextColor);
  }
}
