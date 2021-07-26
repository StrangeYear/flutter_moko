library flutter_moko;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_moko/util/color_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FastWidget {
  /// 获取Text widget
  static Widget text(String? text,
      {dynamic color = Colors.black87,
        double fontSize = 16,
        FontWeight fontWeight = FontWeight.normal,
        int? maxLines = 1,
        double? height,
        TextAlign? textAlign}) {
    return Text(
      text ?? "",
      style: TextStyle(
        color: ColorUtil.parse(color),
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// 指定宽度的SizedBox
  static Widget blankWidth(double width) {
    return SizedBox(
      width: width,
    );
  }

  /// 指定高度的SizedBox
  static Widget blankHeight(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget avatar(String image, double radius) {
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(
        image,
      ),
      radius: radius,
    );
  }

  static Widget iconRight({String color = "#999999", double size = 20}) {
    return Icon(
      Icons.chevron_right,
      color: ColorUtil.parse(color),
      size: size,
    );
  }

  static Widget spacer() {
    return Expanded(
      child: Container(),
    );
  }

  static Widget textButton(String text, {
    VoidCallback? onPressed,
    double borderRadius = 0,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    Color borderColor = Colors.black12,
    Color? overlayColor,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
      style: ButtonStyle(
        overlayColor: overlayColor != null
            ? MaterialStateProperty.all(overlayColor)
            : null,
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        side: MaterialStateProperty.all(BorderSide(
          color: borderColor,
        )),
        backgroundColor: MaterialStateProperty.all(backgroundColor),
      ),
    );
  }
}
