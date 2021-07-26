import 'package:flutter_moko/util/lunar_util.dart';

extension DateTimeEx on DateTime {
  DateTime nextRepeatYear({DateTime? current}) {
    var now = current ?? DateTime.now();
    if (this >= now) {
      // 如果选择的时间大于或者等于现在的话 返回当前时间
      return this;
    }

    if (this.month < now.month) {
      // 当前月份小于现在月份 跳转到下一年
      var next = DateTime(now.year + 1, this.month, 1);
      var monthDays = next.daysOfMonth();
      var day = this.day > monthDays ? monthDays : this.day;
      return DateTime(next.year, next.month, day);
    } else if (this.month == now.month) {
      // 月份相同 判断天数
      if (now.day <= this.day) {
        var monthDays = now.daysOfMonth();
        var day = this.day > monthDays ? monthDays : this.day;
        return DateTime(now.year, this.month, day);
      } else {
        // 今年时间已经过去
        var next = DateTime(now.year + 1, this.month, 1);
        var monthDays = next.daysOfMonth();
        var day = this.day > monthDays ? monthDays : this.day;
        return DateTime(next.year, next.month, day);
      }
    }

    // 当前月份大于现在月份 必须有
    var monthDays = now.daysOfMonth();
    var day = this.day > monthDays ? monthDays : this.day;
    return DateTime(now.year, this.month, day);
  }

  DateTime nextRepeatMonth({DateTime? current}) {
    var now = current ?? DateTime.now();
    if (this >= now) {
      // 如果选择的时间大于或者等于现在的话 返回当前时间
      return this;
    }

    if (this.day > now.day) {
      var monthDays = now.daysOfMonth();
      // 2月特殊处理
      var iDay = this.day > monthDays ? monthDays : this.day;
      return DateTime(now.year, now.month, iDay);
    }
    if (this.day == now.day) {
      return now;
    }

    // 跳转到下一个月
    var beginningNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    var monthDays = beginningNextMonth.daysOfMonth();
    var iDay = this.day > monthDays ? monthDays : this.day;
    return DateTime(beginningNextMonth.year, beginningNextMonth.month, iDay);
  }

  DateTime nextRepeatWeek({DateTime? current}) {
    var now = current ?? DateTime.now();
    if (this >= now) {
      // 如果选择的时间大于或者等于现在的话 返回当前时间
      return this;
    }

    var weekday = this.weekday;
    var nowWeekday = now.weekday;
    if (weekday == nowWeekday) {
      return now;
    }
    if (weekday > nowWeekday) {
      return this.add(Duration(days: weekday - nowWeekday));
    }
    return now.add(Duration(days: 7 - nowWeekday + weekday));
  }

  int daysOfMonth() {
    var beginningNextMonth = (this.month < 12)
        ? DateTime(this.year, this.month + 1, 1)
        : DateTime(this.year + 1, 1, 1);
    var beginningThisMonth = DateTime(this.year, this.month, 1);
    return beginningNextMonth
        .difference(beginningThisMonth)
        .inDays;
  }

  DateTime lastDayOfMonth() {
    var beginningNextMonth = (this.month < 12)
        ? DateTime(this.year, this.month + 1, 1)
        : DateTime(this.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  bool isSameDay(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  bool operator <(DateTime other) {
    if (this.isSameDay(other)) {
      return false;
    }

    if (this.year == other.year) {
      if (this.month == other.month) {
        return this.day < other.day;
      }
      return this.month < other.month;
    }

    return this.year < other.year;
  }

  bool operator >(DateTime other) {
    return !this.isSameDay(other) && other < this;
  }

  bool operator <=(DateTime other) {
    return this.isSameDay(other) || this < other;
  }

  bool operator >=(DateTime other) {
    return this.isSameDay(other) || this > other;
  }

  Lunar toLunar() {
    return LunarUtil.solarToLunar(this);
  }
}
