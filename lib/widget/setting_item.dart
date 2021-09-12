import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/neu_text.dart';

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

  final GestureTapCallback? onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final NeumorphicTextStyle? titleStyle;
  final NeumorphicTextStyle? contentStyle;
  final Widget? rightBtn;
  final double? height;
  final bool showArrow;
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
                      textStyle: contentStyle ??
                          NeumorphicTextStyle(fontSize: 14.0)),
                ),
              ),
              showArrow
                  ? NeumorphicIcon(
                      Icons.arrow_forward_ios,
                      style: NeumorphicStyle(color: mainColor.resolve(context)),
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
