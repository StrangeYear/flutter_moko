library flutter_moko;

import 'dart:ui';

import 'package:flutter_moko/util/lunar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_moko/flutter_moko.dart';
import 'package:flutter_picker/flutter_picker.dart';

typedef void LunarPickerSelectedCallback(LunarSolarValue value);

class PickerUtil {
  // 显示列表选项
  static void openSelectModalPicker(
    BuildContext context, {
    List<int>? selecteds,
    required PickerAdapter adapter,
    PickerConfirmCallback? onConfirm,
    PickerSelectedCallback? onSelect,
    String cancelText = "取消",
    String confirmText = "确认",
    bool transparent = false,
    WidgetBuilder? builderHeader,
  }) {
    var picker = makePicker(
      context,
      selecteds: selecteds,
      adapter: adapter,
      onConfirm: onConfirm,
      onSelect: onSelect,
      cancelText: cancelText,
      confirmText: confirmText,
      transparent: transparent,
      builderHeader: builderHeader,
    );
    showModalBottomSheet(
      backgroundColor: transparent ? Colors.black12 : null,
      barrierColor: transparent ? Colors.transparent : null,
      context: context,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return transparent
            ? ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: picker,
                ),
              )
            : picker;
      },
    );
  }

  static Widget makePicker(
    BuildContext context, {
    List<int>? selecteds,
    required PickerAdapter adapter,
    PickerConfirmCallback? onConfirm,
    PickerSelectedCallback? onSelect,
    String cancelText = "取消",
    String confirmText = "确认",
    bool transparent = false,
    WidgetBuilder? builderHeader,
    bool hideHeader = false,
  }) {
    return Picker(
      headerColor: transparent ? Colors.transparent : null,
      backgroundColor: transparent ? Colors.transparent : null,
      containerColor: transparent ? Colors.transparent : null,
      headerDecoration: transparent ? BoxDecoration() : null,
      textStyle: TextStyle(
        color: transparent ? Colors.white : Colors.black,
        fontSize: 18,
      ),
      adapter: adapter,
      selecteds: selecteds,
      cancelText: cancelText,
      confirmText: confirmText,
      builderHeader: builderHeader,
      hideHeader: hideHeader,
      cancelTextStyle: TextStyle(
        color: transparent ? Colors.white : Colors.black,
      ),
      confirmTextStyle: TextStyle(
        color: transparent ? Colors.white : Colors.black,
      ),
      textAlign: TextAlign.right,
      itemExtent: 40,
      height: 250,
      selectedTextStyle: TextStyle(
        color: transparent ? Colors.white : Colors.black,
        fontSize: 18,
      ),
      onConfirm: onConfirm,
      onSelect: onSelect,
    ).makePicker(null, true);
  }

  // 显示日期选项
  static void openDateTimeModalPicker(
    BuildContext context, {
    int? dateType,
    DateTime? minValue,
    DateTime? maxValue,
    DateTime? value,
    String yearSuffix = "年",
    String monthSuffix = "月",
    String daySuffix = "日",
    PickerConfirmCallback? onConfirm,
    PickerSelectedCallback? onSelect,
    String cancelText = "取消",
    String confirmText = "确认",
    bool transparent = false,
    int? minuteInterval,
  }) {
    openSelectModalPicker(
      context,
      transparent: transparent,
      onConfirm: onConfirm,
      onSelect: onSelect,
      cancelText: cancelText,
      confirmText: confirmText,
      adapter: DateTimePickerAdapter(
        type: dateType ?? PickerDateTimeType.kYMD,
        isNumberMonth: true,
        maxValue: maxValue,
        minValue: minValue,
        yearSuffix: yearSuffix,
        monthSuffix: monthSuffix,
        daySuffix: daySuffix,
        minuteInterval: minuteInterval,
        value: value ?? DateTime.now(),
      ),
    );
  }

  // 显示带农历阳历的日期选项
  static void openLunarSolarDateTimeModalPicker(
    BuildContext context, {
    DateTime? minValue,
    DateTime? maxValue,
    LunarSolarValue? value,
    String yearSuffix = "年",
    String monthSuffix = "月",
    String daySuffix = "日",
    String lunarText = "农历",
    String solarText = "阳历",
    LunarPickerSelectedCallback? onSelect,
    bool transparent = false,
  }) {
    var picker = LunarSolarPicker(
      value: value ?? LunarSolarValue.solarNow(),
      yearSuffix: yearSuffix,
      monthSuffix: monthSuffix,
      daySuffix: daySuffix,
      onSelect: onSelect,
      transparent: transparent,
      lunarText: lunarText,
      solarText: solarText,
    );
    showModalBottomSheet(
      backgroundColor: transparent ? Colors.black12 : null,
      barrierColor: transparent ? Colors.transparent : null,
      context: context,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return transparent
            ? ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: picker,
                ),
              )
            : picker;
      },
    );
  }
}

class LunarSolarValue {
  late int year;
  late int month;
  late int day;
  late int lunar;

  LunarSolarValue({
    required this.year,
    required this.month,
    required this.day,
    required this.lunar,
  });

  LunarSolarValue.lunarNow() {
    var lunar = Lunar.now();
    this.year = lunar.year;
    this.month = lunar.month;
    this.day = lunar.day;
    this.lunar = lunar.isLeap ? 2 : 1;
  }

  LunarSolarValue.solarNow() {
    var solar = DateTime.now();
    this.year = solar.year;
    this.month = solar.month;
    this.day = solar.day;
    this.lunar = 0;
  }

  Lunar toLunar() {
    return lunar == 0
        ? Lunar.fromSolar(DateTime(year, month, day))
        : Lunar(year: year, month: month, day: day, isLeap: lunar == 2);
  }

  DateTime toSolar() {
    return lunar == 0
        ? DateTime(year, month, day)
        : Lunar(year: year, month: month, day: day, isLeap: lunar == 2)
            .toSolar();
  }
}

class LunarSolarPicker extends StatefulWidget {
  final LunarSolarValue value;
  final List<int>? selecteds;
  final String yearSuffix;
  final String monthSuffix;
  final String daySuffix;
  final LunarPickerSelectedCallback? onSelect;
  final bool transparent;
  final String lunarText;
  final String solarText;

  LunarSolarPicker({
    required this.value,
    this.selecteds,
    this.yearSuffix = "年",
    this.monthSuffix = "月",
    this.daySuffix = "日",
    this.lunarText = "农历",
    this.solarText = "阳历",
    this.onSelect,
    this.transparent = false,
  });

  @override
  _LunarSolarPickerState createState() => _LunarSolarPickerState(value: value);
}

class _LunarSolarPickerState extends State<LunarSolarPicker> {
  late LunarSolarValue value;
  bool lunar = false;

  _LunarSolarPickerState({required this.value}) {
    this.lunar = value.lunar == 0 ? false : true;
  }

  _onSelect() {
    if (widget.onSelect != null) {
      widget.onSelect!(value);
    }
  }

  _switchLunar(bool lunar) {
    setState(() {
      this.lunar = lunar;
    });
    // 转换值
    if (lunar) {
      var lunar = value.toLunar();
      this.value = LunarSolarValue(
        year: lunar.year,
        month: lunar.month,
        day: lunar.day,
        lunar: lunar.isLeap ? 2 : 1,
      );
    } else {
      var solar = value.toSolar();
      this.value = LunarSolarValue(
        year: solar.year,
        month: solar.month,
        day: solar.day,
        lunar: 0,
      );
    }
    _onSelect();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FastWidget.textButton(
              widget.solarText,
              backgroundColor: Colors.transparent,
              borderColor: lunar ? Colors.transparent : Colors.white,
              overlayColor: Colors.transparent,
              borderRadius: 5,
              onPressed: () {
                _switchLunar(false);
              },
            ),
            FastWidget.textButton(
              widget.lunarText,
              backgroundColor: Colors.transparent,
              borderColor: lunar ? Colors.white : Colors.transparent,
              overlayColor: Colors.transparent,
              borderRadius: 5,
              onPressed: () {
                _switchLunar(true);
              },
            ),
          ],
        ),
        lunar
            ? Container(
                key: ValueKey("lunar-picker"),
                child: PickerUtil.makePicker(
                  context,
                  adapter: LunarDateTimePickerAdapter(
                    value: value.toLunar(),
                  ),
                  onSelect: (Picker picker, int index, _) {
                    var selecteds = picker.adapter.getSelectedValues();
                    value = LunarSolarValue(
                      year: selecteds[0],
                      month: selecteds[1],
                      day: selecteds[2],
                      lunar: selecteds[3] == 1 ? 2 : 1,
                    );
                    _onSelect();
                  },
                  hideHeader: true,
                  transparent: widget.transparent,
                ),
              )
            : Container(
                key: ValueKey("solar-picker"),
                child: PickerUtil.makePicker(
                  context,
                  adapter: DateTimePickerAdapter(
                    type: PickerDateTimeType.kYMD,
                    isNumberMonth: true,
                    yearSuffix: widget.yearSuffix,
                    monthSuffix: widget.monthSuffix,
                    daySuffix: widget.daySuffix,
                    value: value.toSolar(),
                  ),
                  onSelect: (Picker picker, int index, List<int> selecteds) {
                    value = LunarSolarValue(
                      year: 1900 + selecteds[0],
                      month: selecteds[1] + 1,
                      day: selecteds[2] + 1,
                      lunar: 0,
                    );
                    _onSelect();
                  },
                  hideHeader: true,
                  transparent: widget.transparent,
                ),
              )
      ],
    );
  }
}

class LunarDateTimePickerAdapter extends PickerAdapter<int> {
  /// year begin...end.
  int yearBegin, yearEnd;

  LunarDateTimePickerAdapter({
    Picker? picker,
    this.yearBegin = 1900,
    this.yearEnd = 2099,
    Lunar? value,
  }) : assert(yearBegin >= 1900 && yearEnd <= 2099) {
    super.picker = picker;
    this.value = value ?? Lunar.now();
  }

  /// Currently selected value
  late Lunar value;

  int _col = 0;

  // 获取当前列的长度
  @override
  int getLength() {
    switch (_col) {
      case 0:
        return yearEnd - yearBegin + 1;
      case 1:
        int leapMonth = LunarUtil.leapMonth(value.year);
        return leapMonth > 0 ? 13 : 12;
      case 2:
        return LunarUtil.daysInMonthThree(
          value.year,
          value.month,
          value.isLeap,
        );
    }
    return 0;
  }

  // 最大列数
  @override
  int getMaxLevel() {
    return 3;
  }

  @override
  void setColumn(int index) {
    _col = index + 1;
  }

  @override
  void initSelects() {
    // 初始化选择的索引
    int _maxLevel = getMaxLevel();
    if (picker!.selecteds.length == 0) {
      for (int i = 0; i < _maxLevel; i++) picker!.selecteds.add(0);
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    String _text = "";
    switch (_col) {
      case 0:
        // 年份显示
        _text = Lunar.parseYear(yearBegin + index);
        break;
      case 1:
        // 月份显示
        _text = Lunar.parseMonth(value.year, index + 1);
        break;
      case 2:
        // 天数显示
        _text = Lunar.parseDay(index + 1);
        break;
    }

    return makeText(null, _text, picker!.selecteds[_col] == index);
  }

  @override
  String getText() {
    return value.toString();
  }

  @override
  List<int> getSelectedValues() {
    int leapMonth = LunarUtil.leapMonth(value.year);
    int index = picker!.selecteds[1];
    // 如果当前月份是闰月 返回2 不是 返回1
    int lunar = leapMonth > 0 && leapMonth == index ? 1 : 0;
    return [
      value.year,
      value.month,
      value.day,
      lunar,
    ];
  }

  @override
  void doShow() {
    var _maxLevel = getMaxLevel();
    for (int i = 0; i < _maxLevel; i++) {
      switch (i) {
        case 0:
          picker!.selecteds[i] = value.year > yearEnd
              ? yearEnd - yearBegin
              : value.year - yearBegin;
          break;
        case 1:
          // 查出来当年闰哪个月
          int leapMonth = LunarUtil.leapMonth(value.year);
          picker!.selecteds[i] = leapMonth == 0 || value.month < leapMonth
              ? value.month - 1
              : value.month;
          break;
        case 2:
          picker!.selecteds[i] = value.day - 1;
          break;
      }
    }
  }

  @override
  void doSelect(int column, int index) {
    int year, month, day;
    year = value.year;
    month = value.month;
    day = value.day;
    bool isLeap = value.isLeap;

    switch (column) {
      case 0:
        year = yearBegin + index;
        int prevLeapMonth = LunarUtil.leapMonth(value.year);
        bool prevHasLeap = prevLeapMonth > 0;
        int leapMonth = LunarUtil.leapMonth(year);
        bool hasLeap = leapMonth > 0;
        var monthIndex = picker!.selecteds[1];
        if (!prevHasLeap && hasLeap) {
          if (monthIndex >= leapMonth) {
            // 之前没有闰月 现在有闰月 且之前的月份索引与闰月一致 月份-1
            month = monthIndex == 12 ? monthIndex - 1 : monthIndex;
            isLeap = monthIndex == leapMonth;
          } else {
            month = monthIndex + 1;
          }
        }
        if (prevHasLeap && !hasLeap) {
          // 之前有闰月 现在没有闰月
          if (monthIndex <= prevLeapMonth) {
            // 之前的月份索引小于之前的闰月
            month = monthIndex + 1;
          }
          isLeap = false;
        }
        if (_daysChange(year, month, isLeap)) {
          day = 29;
        }
        break;
      case 1:
        // 选择的值为1-13的时候代表有闰月，需要考虑到偏移问题
        int leapMonth = LunarUtil.leapMonth(year);
        // 有闰月 区分两种情况 小于等于闰月的 大于闰月的
        month = index + 1 <= leapMonth || leapMonth == 0 ? index + 1 : index;
        isLeap = leapMonth > 0 && index == leapMonth;
        if (_daysChange(year, month, isLeap)) {
          day = 29;
        }
        break;
      case 2:
        day = index + 1;
        break;
    }
    value = Lunar(year: year, month: month, day: day, isLeap: isLeap);
  }

  bool _daysChange(int year, int month, bool isLeap) {
    var prevDays = LunarUtil.daysInMonthThree(
      value.year,
      value.month,
      value.isLeap,
    );
    var days = LunarUtil.daysInMonthThree(
      year,
      month,
      isLeap,
    );
    var daysIndex = picker!.selecteds[2];
    return prevDays > days && daysIndex == prevDays - 1;
  }
}
