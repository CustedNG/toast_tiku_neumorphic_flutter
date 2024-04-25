import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../res/color.dart';

/// Neumorphic风格输入框
class NeuTextField extends StatefulWidget {
  /// 标签
  final String? label;

  /// 隐式文字
  final String? hint;

  /// 初始值
  final String? initValue;

  /// 内间距
  final EdgeInsets? padding;

  /// 外间距
  final EdgeInsets? margin;

  /// 值改变时的操作
  final ValueChanged<String>? onChanged;

  const NeuTextField(
      {super.key,
      this.label,
      this.hint,
      this.onChanged,
      this.padding,
      this.margin,
      this.initValue,});

  @override
  State<NeuTextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<NeuTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.clear();
    _controller.text = widget.initValue ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            widget.label ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: mainTextColor.resolve(context),
            ),
          ),
        ),
        Neumorphic(
          margin: widget.padding ??
              const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          style: NeumorphicStyle(
            depth: NeumorphicTheme.embossDepth(context),
            boxShape: const NeumorphicBoxShape.stadium(),
          ),
          padding: widget.margin ??
              const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: TextField(
            onChanged: widget.onChanged,
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: widget.hint),
          ),
        ),
      ],
    );
  }
}
