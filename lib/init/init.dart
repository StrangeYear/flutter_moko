library flutter_moko;

import 'package:flutter_moko/util/http_util.dart';
import 'package:flutter_moko/util/log_util.dart';
import 'package:flutter_moko/util/theme_util.dart';
import 'package:sp_util/sp_util.dart';

class FlutterMoko {
  static Future<void> init({
    ThemeOptions? themeOptions,
    required HttpOptions httpOptions,
    bool debug = false,
  }) async {
    await SpUtil.getInstance();
    await LogUtil.getInstance(debug: debug);
    ThemeUtil().init(
      options: themeOptions,
    );
    HttpUtil().init(options: httpOptions);
  }
}
