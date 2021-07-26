library flutter_moko;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 双击返回退出
class DoubleTapBack extends StatefulWidget {
  const DoubleTapBack({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 2500),
    this.exitTip = "再次点击退出应用",
  }) : super(key: key);

  final Widget child;

  /// 两次点击返回按钮的时间间隔
  final Duration duration;

  final String exitTip;

  @override
  _DoubleTapBackState createState() => _DoubleTapBackState();
}

class _DoubleTapBackState extends State<DoubleTapBack> {
  DateTime? _lastTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExit,
      child: widget.child,
    );
  }

  Future<bool> _isExit() async {
    if (_lastTime == null ||
        DateTime.now().difference(_lastTime!) > widget.duration) {
      _lastTime = DateTime.now();
      EasyLoading.showSuccess(widget.exitTip);
      return Future.value(false);
    }

    EasyLoading.dismiss();

    /// 不推荐使用 `dart:io` 的 exit(0)
    await SystemNavigator.pop();
    return Future.value(true);
  }
}
