library flutter_moko;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_moko/ui/fast_widget.dart';

class OverlayUtil {
  static Future<bool> showTipDialog(
    BuildContext context, {
    String? title,
    String? tip,
    String? cancelText,
    String? confirmText,
  }) async {
    return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(title ?? "提示"),
              content: Text(tip ?? "确认执行此操作吗?"),
              actions: <Widget>[
                TextButton(
                  child: Text(cancelText ?? "取消"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(confirmText ?? "确认"),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static Future<String?> showBottomSheetTextField(
    BuildContext context, {
    String? value,
    List<TextInputFormatter>? inputFormatters,
    String? cancelText,
    String? confirmText,
    Color? cancelColor,
    Color? cancelTextColor,
    Color? confirmColor,
    Color? confirmTextColor,
  }) {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      builder: (context) => BottomSheetTextField(
        value: value,
        inputFormatters: inputFormatters,
        cancelText: cancelText,
        confirmText: confirmText,
        cancelColor: cancelColor,
        cancelTextColor: cancelTextColor,
        confirmColor: confirmColor,
        confirmTextColor: confirmTextColor,
      ),
    );
  }
}

class BottomSheetTextField extends StatefulWidget {
  final String? value;
  final List<TextInputFormatter>? inputFormatters;
  final String? cancelText;
  final String? confirmText;
  final String? title;
  final Color? cancelColor;
  final Color? cancelTextColor;
  final Color? confirmColor;
  final Color? confirmTextColor;

  BottomSheetTextField({
    this.value,
    this.inputFormatters,
    this.cancelText,
    this.confirmText,
    this.title,
    this.cancelColor,
    this.cancelTextColor,
    this.confirmColor,
    this.confirmTextColor,
  });

  @override
  _BottomSheetTextFieldState createState() => _BottomSheetTextFieldState();
}

class _BottomSheetTextFieldState extends State<BottomSheetTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.value ?? "";
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 25,
          left: 25,
          right: 25,
          bottom: MediaQuery.of(context).viewInsets.bottom + 25,
        ),
        child: Column(
          children: [
            if (widget.title != null) Text(widget.title!),
            TextField(
              controller: _textEditingController,
              inputFormatters: widget.inputFormatters,
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.black12,
                filled: true,
              ),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FastWidget.textButton(
                  widget.cancelText ?? "取消",
                  backgroundColor: widget.cancelColor ?? Colors.black,
                  textColor: widget.cancelTextColor ?? Colors.white,
                  onPressed: () => Navigator.of(context).pop(null),
                ),
                FastWidget.textButton(
                  widget.confirmText ?? "确认",
                  backgroundColor: widget.confirmColor ?? Colors.black,
                  textColor: widget.confirmTextColor ?? Colors.white,
                  onPressed: () => Navigator.of(context).pop(
                    _textEditingController.text,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
