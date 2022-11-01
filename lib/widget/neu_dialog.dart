import 'package:flutter/material.dart';

/// Neumorphic风格对话框
class NeuDialog extends Dialog {
  /// 外间距
  final EdgeInsets? margin;

  /// 标题
  final Widget title;

  /// 内容
  final Widget content;

  /// 按钮
  final Widget actions;

  const NeuDialog(
      {Key? key,
      required this.title,
      required this.content,
      required this.actions,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          1),
      child: SizedBox(
        width: size.width * 0.7,
        child: Material(
          child: Padding(
            padding: margin ?? const EdgeInsets.fromLTRB(24, 17, 24, 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: title,
                ),
                const SizedBox(
                  height: 17,
                ),
                content,
                const SizedBox(
                  height: 17,
                ),
                actions
              ],
            ),
          ),
        ),
      ),
    );
  }
}
