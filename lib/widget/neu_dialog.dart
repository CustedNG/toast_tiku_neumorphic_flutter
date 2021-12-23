import 'package:flutter_neumorphic/flutter_neumorphic.dart';

/// Neumorphic风格对话框
class NeuDialog extends Dialog {
  /// 外间距
  final EdgeInsets? margin;

  /// 标题
  final Widget title;

  /// 内容
  final Widget content;

  /// 按钮
  final List<Widget> actions;

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
    return SizedBox(
      height: size.height * 0.5,
      width: size.width * 0.7,
      child: Neumorphic(
        style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(
                const BorderRadius.all(Radius.circular(37)))),
        child: Padding(
          padding: margin ?? const EdgeInsets.fromLTRB(24, 17, 24, 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              content,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              )
            ],
          ),
        ),
      ),
    );
  }
}
