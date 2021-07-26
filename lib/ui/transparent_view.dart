library flutter_moko;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_moko/util/image_util.dart';

// 整体透明背景
class TransparentView extends StatelessWidget {
  final Widget child;
  final bool filter;

  // 背景url地址
  final String? background;

  // 背景组件
  final Widget? backgroundWidget;

  TransparentView({
    required this.child,
    this.filter = true,
    this.background,
    this.backgroundWidget,
  }) : assert(background != null || backgroundWidget != null);

  @override
  Widget build(BuildContext context) {
    var child = Container(
      color: Colors.black12,
      child: this.child,
    );
    return Stack(
      children: [
        if (background != null)
          BackgroundWidget(
            background: background!,
          ),
        if (backgroundWidget != null) backgroundWidget!,
        filter
            ? ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: child,
                ),
              )
            : child,
      ],
    );
  }
}

class BackgroundWidget extends StatelessWidget {
  // 背景url地址
  final String background;

  BackgroundWidget({required this.background});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ImageUtil.getImageProvider(background),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
