import 'package:flutter_neumorphic/flutter_neumorphic.dart';

/// Neumorphic风格卡片
class NeuCard extends StatelessWidget {
  /// 内容
  final Widget child;

  /// 内间距
  final EdgeInsets? padding;

  /// 外间距
  final EdgeInsets? margin;

  /// 风格
  final NeumorphicStyle? style;

  const NeuCard(
      {Key? key, required this.child, this.padding, this.margin, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: child,
      padding: margin ?? const EdgeInsets.all(9),
      margin: padding ?? const EdgeInsets.all(11),
      style: style,
    );
  }
}
