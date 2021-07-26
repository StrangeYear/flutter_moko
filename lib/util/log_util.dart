import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';

class LogUtil {
  static LogUtil? _instance;
  static Logger? _logger;

  static Lock _lock = Lock();

  static Future<LogUtil?> getInstance({bool debug = false}) async {
    if (_instance == null) {
      await _lock.synchronized(() async {
        if (_instance == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var instance = LogUtil._();
          instance._init(debug);
          _instance = instance;
        }
      });
    }
    return _instance;
  }

  LogUtil._();

  void _init(bool debug) async {
    Logger.level = debug ? Level.verbose : Level.warning;
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 4,
        errorMethodCount: 8,
        lineLength: 120,
        printEmojis: true,
        printTime: true,
      ),
    );
  }

  static v(String msg) {
    _logger?.v(msg);
  }

  static d(String msg) {
    _logger?.d(msg);
  }

  static i(String msg) {
    _logger?.i(msg);
  }

  static w(String msg) {
    _logger?.w(msg);
  }

  static e(String msg, [dynamic error]) {
    _logger?.e(msg, error);
  }

  static wtf(String msg) {
    _logger?.wtf(msg);
  }
}
