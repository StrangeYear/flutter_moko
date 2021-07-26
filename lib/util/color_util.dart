library flutter_moko;

import 'dart:ui';

import 'package:flutter/material.dart';

class ColorUtil {
  /// 颜色创建方法
  /// - [color] 颜色值
  /// - [alpha] 透明度(默认1，0-1)
  ///
  /// 可以输入多种格式的颜色代码，如: 0x000000,0xff000000,#000000
  static Color parse(dynamic color, {double alpha = 1.0}) {
    if (color is Color) {
      return color;
    }
    if (color is String) {
      String colorStr = color;
      // colorString未带0xff前缀并且长度为6
      if (!colorStr.startsWith('0xff') && colorStr.length == 6) {
        colorStr = '0xff' + colorStr;
      }
      // colorString为8位，如0x000000
      if (colorStr.startsWith('0x') && colorStr.length == 8) {
        colorStr = colorStr.replaceRange(0, 2, '0xff');
      }
      // colorString为7位，如#000000
      if (colorStr.startsWith('#') && colorStr.length == 7) {
        colorStr = colorStr.replaceRange(0, 1, '0xff');
      }
      // 先分别获取色值的RGB通道
      Color parseValue = Color(int.parse(colorStr));
      int red = parseValue.red;
      int green = parseValue.green;
      int blue = parseValue.blue;
      // 通过fromRGBO返回带透明度和RGB值的颜色
      return Color.fromRGBO(red, green, blue, alpha);
    }

    return Colors.black;
  }
}
