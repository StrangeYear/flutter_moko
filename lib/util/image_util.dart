library flutter_moko;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'text_util.dart';

class ImageUtil {
  static ImageProvider getAssetImage(String name, {ImageFormat? format}) {
    return AssetImage(getImgPath(name, format: format));
  }

  static String getImgPath(String name, {ImageFormat? format}) {
    if (format == null) {
      if (name.contains(".")) {
        return 'assets/images/$name';
      } else {
        format = ImageFormat.png;
      }
    }
    return 'assets/images/$name.${format.value}';
  }

  static ImageProvider getImageProvider(String resource,
      {String holderImg = 'none'}) {
    if (TextUtil.isEmpty(resource)) {
      return AssetImage(getImgPath(holderImg));
    }

    if (resource.startsWith('http')) {
      return CachedNetworkImageProvider(resource);
    } else {
      return AssetImage(getImgPath(resource));
    }
  }
}

enum ImageFormat { png, jpg, gif, webp }

extension ImageFormatExtension on ImageFormat {
  String get value => ['png', 'jpg', 'gif', 'webp'][index];

  String get inString => describeEnum(this);
}
