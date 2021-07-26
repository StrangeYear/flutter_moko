import 'package:flutter_moko/util/lunar_util.dart';

void main() {
  var now = DateTime(1995,10,21);
  print(Lunar.fromSolar(now));
}
