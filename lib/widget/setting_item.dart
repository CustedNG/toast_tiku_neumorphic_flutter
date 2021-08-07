import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/neu_text.dart';

import 'neu_card.dart';

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
    return Container(
        height: this.height ?? 65.0,
        margin: EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        child: NeuCard(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(23)))
          ),
          margin: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(width: 10.0),
              this.icon ?? Container(),
              SizedBox(width: 10.0),
              NeuText(text: this.title),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: NeuText(
                      text: this.content,
                      align: this.textAlign,
                      textStyle: this.contentStyle ??
                          NeumorphicTextStyle(fontSize: 14.0)),
                ),
              ),
              this.showArrow
                  ? NeumorphicIcon(
                      Icons.arrow_forward_ios,
                      style: NeumorphicStyle(color: mainColor),
                      size: 16,
                    )
                  : Container(),
              SizedBox(width: 10.0),
              this.rightBtn ?? Container(),
              SizedBox(width: 17,)
            ],
          ),
        ));
  }
}
