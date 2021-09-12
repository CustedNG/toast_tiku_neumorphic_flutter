import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/color.dart';

class NeuTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initValue;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final ValueChanged<String>? onChanged;

  const NeuTextField(
      {Key? key,
      this.label,
      this.hint,
      this.onChanged,
      this.padding,
      this.margin,
      this.initValue})
      : super(key: key);

  @override
  _TextFieldState createState() => _TextFieldState();
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
              color: mainColor.resolve(context),
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
        )
      ],
    );
  }
}
