library flutter_moko;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'device_util.dart';

class ThemeUtil {
  static ThemeUtil? _instance;

  ThemeUtil._internal();

  factory ThemeUtil() => _getInstance();

  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = ThemeUtil._internal();
    }
    return _instance;
  }

  Color _darkTextColor = Colors.white;
  Color _textColor = Colors.black;
  Color _darkBackgroundColor = Colors.black;
  Color _backgroundColor = Colors.grey;
  Color _darkDialogBackgroundColor = Colors.transparent;
  Color _dialogBackgroundColor = Colors.black26;

  void init({ThemeOptions? options}) {
    if (options == null) {
      return;
    }

    _darkTextColor = options.darkTextColor ?? _darkTextColor;
    _textColor = options.textColor ?? _textColor;
    _darkBackgroundColor = options.darkBackgroundColor ?? _darkBackgroundColor;
    _backgroundColor = options.backgroundColor ?? _backgroundColor;
    _darkDialogBackgroundColor =
        options.darkDialogBackgroundColor ?? _darkDialogBackgroundColor;
    _dialogBackgroundColor =
        options.dialogBackgroundColor ?? _dialogBackgroundColor;

    if (options.themeMode != null) {
      setSystemNavigationBarStyle(options.themeMode!);
    }
  }

  bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color getIconColor(BuildContext context) {
    return isDark(context) ? _darkTextColor : _textColor;
  }

  Color getBackgroundColor(BuildContext context) {
    return isDark(context)
        ? _darkDialogBackgroundColor
        : _dialogBackgroundColor;
  }

  Color getDialogBackgroundColor(BuildContext context) {
    return isDark(context)
        ? _darkDialogBackgroundColor
        : _dialogBackgroundColor;
  }

  Color getKeyboardActionsColor(BuildContext context) {
    return isDark(context) ? _darkBackgroundColor : _backgroundColor;
  }

  /// 设置NavigationBar样式
  static void setSystemNavigationBarStyle(ThemeMode mode) {
    /// 仅针对安卓
    bool _isDark = mode == ThemeMode.dark;
    if (DeviceUtil.isAndroid) {
      final SystemUiOverlayStyle style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            _isDark ? Brightness.light : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(style);
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        _isDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      );
    }
  }
}

class ThemeOptions {
  Color? darkTextColor;
  Color? textColor;
  Color? darkBackgroundColor;
  Color? backgroundColor;
  Color? darkDialogBackgroundColor;
  Color? dialogBackgroundColor;
  ThemeMode? themeMode;

  ThemeOptions({
    this.darkTextColor,
    this.textColor,
    this.darkBackgroundColor,
    this.backgroundColor,
    this.darkDialogBackgroundColor,
    this.dialogBackgroundColor,
    this.themeMode,
  });
}
