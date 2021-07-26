library flutter_moko;

class RegUtil {
  static final RegExp mobile = new RegExp(
      r"^((13[0-9])|(14[0|5|6|7|9])|(15[0-3])|(15[5-9])|(16[6|7])|(17[2|3|5|6|7|8])|(18[0-9])|(19[1|8|9]))\d{8}$");

  static final RegExp email = new RegExp(
      r"^[A-Za-z0-9\u4e00-\u9fa5_-|\\.]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$");

  static bool checkPhone(String text) {
    return mobile.hasMatch(text);
  }

  static bool checkEmail(String text) {
    return email.hasMatch(text);
  }
}
