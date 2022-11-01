import 'package:flutter/material.dart';
import 'package:toast_tiku/res/color.dart';

/// 设置项Widget
class SettingItem extends StatelessWidget {
  const SettingItem({
    Key? key,
    required this.title,
    this.onTap,
    this.content = "",
    this.rightBtn,
    this.textAlign = TextAlign.start,
    this.titleStyle,
    this.contentStyle,
    this.height,
    this.showArrow = true,
    this.icon,
  }) : super(key: key);

  /// 点击后操作
  final GestureTapCallback? onTap;

  /// 标题
  final String title;

  /// 内容
  final String content;

  /// 文字对齐
  final TextAlign textAlign;

  /// 标题文字风格
  final TextStyle? titleStyle;

  /// 内容文字风格
  final TextStyle? contentStyle;

  /// 右侧视图
  final Widget? rightBtn;

  /// 高度
  final double? height;

  /// 是否显示箭头
  final bool showArrow;

  /// 图标
  final Icon? icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height ?? 55.0,
        width: double.infinity,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 10.0),
              icon ?? Container(),
              const SizedBox(width: 10.0),
              Text(title),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                      content,
                      textAlign: textAlign,
                      style:
                          contentStyle ?? const TextStyle(fontSize: 14.0)),
                ),
              ),
              showArrow && rightBtn == null
                  ? const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    )
                  : Container(),
              const SizedBox(width: 10.0),
              rightBtn ?? Container(),
              const SizedBox(
                width: 17,
              )
            ],
          ),
        ));
  }
}
