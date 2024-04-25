import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../res/color.dart';
import 'neu_text.dart';

/// 设置项Widget
class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
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
  });

  /// 点击后操作
  final GestureTapCallback? onTap;

  /// 标题
  final String title;

  /// 内容
  final String content;

  /// 文字对齐
  final TextAlign textAlign;

  /// 标题文字风格
  final NeumorphicTextStyle? titleStyle;

  /// 内容文字风格
  final NeumorphicTextStyle? contentStyle;

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
              NeuText(text: title),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: NeuText(
                      text: content,
                      align: textAlign,
                      textStyle:
                          contentStyle ?? NeumorphicTextStyle(fontSize: 14.0)),
                ),
              ),
              showArrow && rightBtn == null
                  ? NeumorphicIcon(
                      Icons.arrow_forward_ios,
                      style: NeumorphicStyle(
                          color: mainTextColor.resolve(context)),
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
